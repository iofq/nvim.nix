#!/usr/bin/python

import os
import subprocess
import time
import glob
import syslog
import multiprocessing as mp
from datetime import datetime
from epicutils import getpretend,setpretend

#-----------------------------------------------------------------------------#
# This script is used to transfer files between Epic and Hosting. Files in    #
# /home/epichosted.com/<user>/to_epichosting will go to                       #
# /nfs/temp/<user>/from_epic, and files in /nfs/temp/<user>/to_epic will go   #
# to /home/epichosted.com/<user>/from_epichosting. Along the way, a forever   #
# copy of each file is taken.                                                 #
#-----------------------------------------------------------------------------#

# Some initial settings are needed
setpretend(False)
domain = subprocess.check_output('realm list --name-only'.split()).strip()
# domain = subprocess.check_output('dnsdomainname').strip()
tempdir = "/nfs/temp"
homedir = "/home/{0}".format(domain)
largedir = "/nfs/temp/large"
log = ("./{0}.log_{1}".format(
            "filewatch", datetime.today().strftime("%m%d%Y")
        )
      )
logfile = open(log,'a')

def parseArgs():
    import argparse
    parser = argparse.ArgumentParser(description='File transfer')
    parser.add_argument('--type', choices=['epic', 'hosting', 'testlab'],
        required=False,
        help="Where files from this server are coming from and going to."
    )
    args = parser.parse_args()
    if args.type:
        return args.type
    else:
        return None

# Logging utility
def tolog(message):
    tosyslog(message)

def tosyslog(message):
    if not getpretend():
        syslog.syslog(message)

# Alert email
def emailBody(file):
    import datetime
    import os
    body = ("This alert is about your recent SFTP file transfer.\n\n"
            "Digital Guardian has classified your file as containing sensitive information "
            "including PHI or PII. Your file has been quarantined but can be moved pending "
            "additional review.\n\n"
            "File: {0}\n"
            "Size: {1}kB\n"
            "Date: {2}\n\n"
            "If your file contains PHI:\n\tProvide the Security Team with the Sherlock SLG "
            "you will be attaching the file to.\n\n"
            "If your file does not contain PHI:\n\tProvide the Security Team a short description "
            "of the contents so we can improve our flagging rules.\n\n"
            "If this is an after-hours case and you need the file immediately:\n\tCall the "
            "Security on-call representative.\n"
            ).format(
                file, (os.path.getsize(file)/1000.0), datetime.datetime.now()
            )
    return body

# Send email
def sendEmail(file):
    import smtplib
    import socket
    from email.mime.text import MIMEText
    siemList = "soc@epichosted.com"
    msg = MIMEText(emailBody(file)) 
    msg['Subject'] = "Digital Guardian File Transfer Quarantine" 
    msg['From'] = "tdcr-sftp01@test.lab"
    msg['To'] = "{0}@{1}, {2}".format(file.split('/')[3], ('.').join(socket.getfqdn().split('.')[1:]), siemList) 
    s = smtplib.SMTP('localhost')
    s.sendmail(msg['From'], msg['To'].split(','), msg.as_string())
    s.quit()

# Check if a file is too large to send.
def checkfilesize(file):
    # Get file size in bytes
    size = os.path.getsize(file)
    # Arbitrarily set at 100MB
    if file.startswith(homedir) and file.split('/')[4] == 'hosting':
        maxsize = 0
    else:
        # maxsize = 100000000
        return True
    # If the file is too big, stop it from sending.
    if size >= maxsize:
        return False
    else:
        return True

# Scan file
def scanfileav(file):
    cmd = ["uvscan", file]
    try:
        result = subprocess.check_output(cmd)
    except Exception, e:
        tolog("{0} failed its file scan.".format(file))
        return False
    else:
        tolog(result)
        return True

# DG classification flags to stop
def taginDgClassFlags(tag):
    tolog("Tag is {0}.".format(tag))
    #flags = ["PCI_DATA_LOW", "PCI_DATA_MEDIUM", "PCI_DATA_HIGH",
    #        "PHI_DATA_LOW", "PHI_DATA_MEDIUM", "PHI_DATA_HIGH",
    #        "PII_DATA_LOW", "PII_DATA_MEDIUM", "PII_DATA_HIGH",
    #        "TEST"]
    flags = ["DLP_PHI_DATA", "DLP_PII_DATA"]
    if tag in flags:
        return True
    else:
        return False 

# Check DG classification
def scanfiledlp(file):
    import subprocess
    # Need to do read on file to classify with DG
    open(file, 'r').close() 
    output = subprocess.Popen(["/dgagent/dgciapp", file], stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
    if output.stdout:
        outputOut = output.stdout.read()
        lines = outputOut.split('#012')[0].split('\n')
        for line in lines:
            if line.startswith("tag:"):
                tag = line.split(":")[1].strip().split('\'')[1]
                return tag
    if not output.stdout and output.stderr:
        tolog("A DG error occurred: {0}".format(output.stderr.read()))
    return None 

# Check if tag is okay to move
def checkDGscan(file):
    #tolog("Checking DG classification of {0}.".format(file))
    #tag = scanfiledlp(file)
    #if tag:
    #    if taginDgClassFlags(tag):
    #        tolog("{0} was tagged by DG: {1}. Moving to quarantine.".format(file, tag))
    #        return False
    return True 

# Copy a file from one place to another.
def copyfile(source, destination):
    try:
        # Only do the copy if we're not pretending.
        if not getpretend():
            p = subprocess.Popen(
                    ['cp','--preserve=mode,ownership',source,destination]
                )
            p.wait()
    # Catch OS errors
    except OSError, e:
        tolog("Couldn't copy {0} to {1}. Error: {2}.".format(
                    source, destination, e
                )
             )
        tosyslog("ERROR,{0},{1},{2}".format(source,destination,e))
    else:
        tosyslog("COMPLETE,{0},{1},{2}".format(
                        source,destination,os.path.getsize(destination)
                    )
                )

# Get forever location
def getforever(source, timestamp):
    direlems = source.split('/')
    direlems[1]="nfs"
    direlems[2]="forever"
    direlems.insert(5, str(timestamp))
    direlems.pop(-1)
    # Rebuild directory in /nfs/forever
    forevercopydir = '/'.join(direlems)
    return forevercopydir

# Copy a file to /nfs/forever.
def copytoforever(file, timestamp):
    forevercopydir = getforever(file, timestamp)
    forevercopy = os.path.join(forevercopydir,os.path.basename(file))
    copyfile(file,forevercopy)
    subprocess.check_call(['gzip',forevercopy])

# Move a file from one place to another. This will delete the original
# at the end.
def movefile(source, destination, timestamp):
    try:
        # Copy the file to /nfs/forever
        copytoforever(source, timestamp)
        destdir = os.path.dirname(destination)
        if not getpretend():
            # Copy the file, then delete it.
            copyfile(source, destination)
            os.remove(source)
    # Catch OS errors
    except OSError, e:
        tolog("Could not move {0} to {1}. Error: {2}.".format(
                    source, destination, e
                )
             )
        tosyslog("ERROR,{0},{1},{2}".format(source,destination,e))

# Move a large file to be handled by CSMs
def movetolarge(source, timestamp):
    direlems = source.split('/')
    direlems[1] = "nfs"
    direlems[2] = "temp"
    direlems.insert(3, "large")
    largedest = '/'.join(direlems)
    if not os.path.isdir(os.path.dirname(largedest)):
        os.makedirs(os.path.dirname(largedest))
    movefile(source, largedest, timestamp)

# Check if file is open. There is a race condition here, but there's not much 
# I can do about that.
def checkclosed(file):
    size1 = os.path.getsize(file)
    time.sleep(5)
    size2 = os.path.getsize(file)
    if size1 == size2:
        return True
    else:
        return False

def processonefile(args):
    source = args[0]
    destination = args[1]
    timestamp = args[2]
    closed = False
    closed = checkclosed(source)
    if not closed:
        tolog("{0} is open. Skipping.".format(source))
        return    
    #sizeok = checkfilesize(source)
    scanok = scanfileav(source)
    dgok = checkDGscan(source)
    if scanok and dgok:
        movefile(source, destination, timestamp)
    else:
        tolog("{0} is too large and will have to be moved manually. Moving to "
              "/nfs/temp/large.".format(source))
        tosyslog("LARGE,{0},{1}.".format(source, os.path.getsize(source)))
        sendEmail(source)
        movetolarge(source, timestamp)

# Get destination
def getdest(direction, source):
    destination = ""
    if direction == "to":
        destination = source.replace(homedir,tempdir,1).replace(
                        "outgoing","incoming",1)
    elif direction == "from":
        destination = source.replace(tempdir,homedir,1).replace(
                        "outgoing","incoming",1)
    return destination

# Build destination directories
def builddestdirs(jobs):
    dirs = []
    for job in jobs:
        source = job[0]
        destination = job[1]
        timestamp = job[2]
        dest = os.path.dirname(destination)
        if not dest in dirs:
            dirs.append(dest)
        forever = getforever(source, timestamp)
        if not forever in dirs:
            dirs.append(forever)
    for dir in dirs:
        if not os.path.isdir(dir):
            # tolog("Creating {0}.".format(dir))
            os.makedirs(dir)

# Go through each user directory in /nfs/temp and /home/<domain>
def walktree(basedir, direction):
    jobs = []
    timestamp = time.time()
    for userdir in os.listdir(basedir):
        if xferType:
            userdir = userdir + '/{0}'.format(xferType)
        if direction == "to":
            filedir = os.path.join(basedir,userdir,"outgoing")
        elif direction == "from":
            filedir = os.path.join(basedir,userdir,"outgoing")
        if not os.path.isdir(os.path.join(basedir,userdir)):
            next
        for root, dirs, files in os.walk(filedir):
            for file in files:
                source = os.path.join(root, file)
                destination = getdest(direction, source)
                jobs.append([source,destination,str(timestamp)])
            for dir in dirs:
                fulldir = os.path.join(root,dir)
                if os.listdir(fulldir) == []:
                    try:
                        os.rmdir(fulldir)
                    except OSError, e:
                        tolog("Could not remove {0} because an error "
                              "occurred. Error: {1}.".format(fulldir, e))
    if jobs == []:
        return
    builddestdirs(jobs)
    pool.map(processonefile, jobs)

pool = mp.Pool(processes=50)
xferType = parseArgs()
while True:
    if logfile.closed:
        logfile = open(log,'a')
    try:
        walktree(homedir,"to")
        walktree(tempdir,"from")
    except Exception, e:
        tosyslog("An error occurred: {0}.".format(e))
        raise Exception("An error occurred: {0}.".format(e))
    else:
        time.sleep(5)
    logfile.close()
    
