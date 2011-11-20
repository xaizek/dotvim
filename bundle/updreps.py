#!/usr/bin/env python

import os
import urlparse

REPS_FILE_NAME = "reps.txt"
FIELDS_IN_REP_INFO = 2
DIR_NAME_FIELD = 0
URL_FIELD = 1

def getList(type):
    if type == "[git]":
        return git
    elif type == "[svn]":
        return svn
    elif type == "[mercurial]":
        return mercurial
    else:
        raise Exception("Unknown type of repository")

def processRepInfo(line):
    info = strippedLine.split('|')
    if len(info) != FIELDS_IN_REP_INFO:
        raise Exception("Invalid repo info: " + `info`)
    info = map(lambda x: x.strip(), info)
    addRepository(info)

def addRepository(repInfo):
    global current
    if current == None:
        raise Exception("Invalid format of repository file")
    current += [repInfo]

def updateGitRepo(repo):
    cmds = []
    cmds += ["pushd ." + os.sep + repo[DIR_NAME_FIELD]]
    cmds += ["git fetch"]
    cmds += ["git merge FETCH_HEAD"]
    cmds += ["popd"]
    os.system('&&'.join(cmds))

def updateSvnRepo(repo):
    cmds = []
    cmds += ["pushd " + repo[DIR_NAME_FIELD]]
    cmds += ["svn update"]
    cmds += ["popd"]
    os.system('&&'.join(cmds))

def updateMercurialRepo(repo):
    cmds = []
    cmds += ["pushd " + repo[DIR_NAME_FIELD]]
    cmds += ["hg pull"]
    cmds += ["hg update"]
    cmds += ["popd"]
    os.system('&&'.join(cmds))

git = []
svn = []
mercurial = []
current = None
with open(REPS_FILE_NAME, "r") as reps:
    for line in reps.readlines():
        strippedLine = line.strip()
        if len(strippedLine) == 0:
            continue
        elif strippedLine[0] == '#':
            continue
        elif strippedLine[0] == '[':
            current = getList(strippedLine)
        else:
            processRepInfo(strippedLine)

print "GIT repos:"
for repo in git:
    print "Name: {0}\n Url: {1}".format(*repo)
    updateGitRepo(repo)

print "SVN repos:"
for repo in svn:
    print "Name: {0}\n Url: {1}".format(*repo)
    updateSvnRepo(repo)

print "Mercurial repos:"
for repo in mercurial:
    print "Name: {0}\n Url: {1}".format(*repo)
    updateMercurialRepo(repo)
