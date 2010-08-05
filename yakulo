#!/usr/bin/env python
#-*- coding: utf-8 -*-

import os
import sys
import time
import getopt

def load_file(filename):
    f = open(filename)
    result = []
    create = None
    name = ''
    lst = []
    for line in f:
        if line.startswith('#') or not line.strip():
            pass
        elif line.startswith(':'):
            if name:
                result.append([create, name, lst])
            parts = line.split(' ', 1)
            create = parts[0][1:].lower() != 'rename'
            name = parts[1].strip()
            lst = []
        else:
            lst.append(line.strip())
    result.append([create, name, lst])
    f.close()
    return result


def cmd(args):
    def escape(s):
        return '"' + str(s).replace('"', '\\"') + '"'
    cmd = ' '.join([escape(i) for i in args])
    print 'cmd', cmd
    fin, fout = os.popen2(cmd)
    fin.close()
    data = fout.read()
    fout.close()
    return data


class Yakuake(object):
    @staticmethod
    def get():
        # TODO: after add new 
        return DbusCmdYakuake()

    def show(self):
        pass
    
    def addSession(self):
        pass
    
    def getCurrent(self):
        pass
    
    def setName(self, nr, name):
        pass
    
    def runCommand(self, nr, command):
        pass


class DcopCmdYakuake(Yakuake):
    def show(self):
        active = cmd('dcop yakuake yakuake-mainwindow#1 isActiveWindow'.split()).strip()
        if active == 'false':
            cmd('dcop yakuake DCOPInterface slotToggleState'.split())
    
    def addSession(self):
        cmd('dcop yakuake DCOPInterface slotAddSession'.split())
    
    def getCurrent(self):
        nr = cmd('dcop yakuake DCOPInterface selectedSession'.split())
        return int(nr.strip())
    
    def setName(self, nr, name):
        cmd('dcop yakuake DCOPInterface slotRenameSession'.split() + [nr, name])
    
    def getName(self, nr):
        return cmd('dcop yakuake DCOPInterface slotSessionName'.split() + [nr]).rstrip()
    
    def runCommand(self, nr, command):
        cmd('dcop yakuake DCOPInterface slotRunCommandInSession'.split() + [nr, command])

    def enterText(self, text):
        cmd('dcop klipper klipper setClipboardContents'.split() + [text+ '\n'])
        cmd('dcop yakuake DCOPInterface slotPasteClipboard'.split())
    
    def getAll(self):
        lst = cmd('dcop yakuake DCOPInterface sessionIdList'.split())
        return [int(i) for i in lst.strip().split(',')]
        
class DbusCmdYakuake(Yakuake):
    """
    qdbus org.kde.yakuake
    qdbus org.kde.yakuake /yakuake/tabs
    qdbus org.kde.yakuake /yakuake/sessions
    """
    def show(self):
        pass
        #active = cmd('dcop yakuake yakuake-mainwindow#1 isActiveWindow'.split()).strip()
        #if active == 'false':
            #cmd('dcop yakuake DCOPInterface slotToggleState'.split())
    
    def addSession(self):
        cmd('qdbus org.kde.yakuake /yakuake/sessions addSession'.split())
    
    def getCurrent(self):
        nr = cmd('qdbus org.kde.yakuake /yakuake/sessions activeSessionId'.split())
        return int(nr.strip())
    
    def setName(self, nr, name):
        cmd('qdbus org.kde.yakuake /yakuake/tabs setTabTitle'.split() + [nr, name])
    
    def getName(self, nr):
        return cmd('qdbus org.kde.yakuake /yakuake/tabs tabTitle'.split() + [nr]).rstrip()
    
    def runCommand(self, nr, command):
        tid = cmd('qdbus org.kde.yakuake /yakuake/sessions terminalIdsForSessionId'.split() + [nr]).split(',')[0]
        cmd('qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal'.split() + [tid, command])

    def enterText(self, text):
        ##nr = cmd('qdbus org.kde.yakuake /yakuake/sessions activeSessionId'.split())
        #nr = cmd('qdbus org.kde.yakuake /yakuake/sessions activeSessionId'.split())
        #tid = cmd('qdbus org.kde.yakuake /yakuake/sessions terminalIdsForSessionId'.split() + [nr]).split(',')[0]
        #cmd(('qdbus org.kde.yakuake /Sessions/%s sendText' % int(tid.strip())).split() + [text + '\n'])
        ##cmd('dcop klipper klipper setClipboardContents'.split() + [text+ '\n'])
        ##cmd('dcop yakuake DCOPInterface slotPasteClipboard'.split())
        nr = cmd('qdbus org.kde.yakuake /yakuake/sessions activeSessionId'.split())
        tid = cmd('qdbus org.kde.yakuake /yakuake/sessions terminalIdsForSessionId'.split() + [nr]).split(',')[0]
        cmd('qdbus org.kde.yakuake /yakuake/sessions runCommandInTerminal'.split() + [tid, text])
    
    def getAll(self):
        return []
        #lst = cmd('dcop yakuake DCOPInterface sessionIdList'.split())
        #return [int(i) for i in lst.strip().split(',')]
    
def run_old(create, name, commands):
    active = cmd('dcop yakuake yakuake-mainwindow#1 isActiveWindow'.split()).strip()
    if active == 'false':
        cmd('dcop yakuake DCOPInterface slotToggleState'.split())
    
    if create:
        cmd('dcop yakuake DCOPInterface slotAddSession'.split())
    
    i = cmd('dcop yakuake DCOPInterface selectedSession'.split())
    cmd('dcop yakuake DCOPInterface slotRenameSession'.split() + [i, name])
    
    for c in commands:
        cmd('dcop yakuake DCOPInterface slotRunCommandInSession'.split() + [i, c])

def load_old(filename):
    conf = load_file(filename)
    for i in conf:
        run(*i)

def load(filename):
    conf = load_file(filename)
    print conf
    yaku = Yakuake.get()
    
    yaku.show()
    
    for create, name, commands in conf:
        if create:
            yaku.addSession()
        nr = yaku.getCurrent()
        yaku.setName(nr, name)
        for command in commands:
            if command.startswith('yak-sleep'):
                sleep = float((command.split() + ['1.0'])[1])
                time.sleep(sleep)
            elif command.startswith('yak-enter'):
                yaku.enterText(command.split(' ', 1)[-1])
            else:
                yaku.runCommand(nr, command)

def save(filename):
    yaku = DcopCmdYakuake()
    
    print yaku.getAll()
    
    for nr in yaku.getAll():
        name = yaku.getName(nr)
        # yaku.runCommand(nr, 'pwd >> ~/yak.txt')
        print repr(name)

if __name__ == '__main__':
    optlist, args = getopt.getopt(sys.argv, '')
    args = args[1:]
    load('/home/kosqx/bin/yakrc')
    #print args
    #if args == ['load']:
        #load('/home/kosqx/bin/yakrc')
    ##elif args == ['save']:
        ##save('/home/kosqx/.yakrc')
    #else:
        #print "Unknown command"
    
