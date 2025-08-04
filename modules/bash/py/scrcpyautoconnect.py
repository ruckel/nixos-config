#!/usr/bin/env python3
from templates.subprocesses import *
import os

def run():
    cmdRes = do(['avahi-browse', '-tr', '_adb-tls-connect._tcp'])
    #adress = do([]) #avahi-browse -tr _adb-tls-connect._tcp | grep address | cut -d " "  -f6
    #port    #avahi-browse -tr _adb-tls-connect._tcp | grep port | cut -d " "  -f6
    #print('cmdres:', cmdRes, 'END')
    #print(getVal(cmdRes, ''))
    #print(getVal(cmdRes, 'ip'))
    ip = cmdRes.split('address')[1].split(']')[0][4:]
    port = cmdRes.split('port')[1].split(']')[0][4:]
    res = ip + ':' + port
    do(['adb', 'connect', res])
    do(['scrcpy', '-e'])

def getVal(text, p):
    if p =='ip': spec = 'address'
    else: spec = 'port'
    #preRes = do(['print', '\'' + text + '\'', '|', 'grep', spec, '|', 'cut', '-d', '" "', '-f6'])[1:]
    #return preRes[:len(preRes)]
    return text.split(spec)[1].split(']')[0][4:]

run()