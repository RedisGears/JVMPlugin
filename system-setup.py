#!/usr/bin/env python3

import sys
import os
import argparse

ROOT = HERE = os.path.abspath(os.path.dirname(__file__))
READIES = os.path.join(ROOT, "deps/readies")
sys.path.insert(0, READIES)
import paella

#----------------------------------------------------------------------------------------------

class RedisGearsSetup(paella.Setup):
    def __init__(self, nop=False, with_python=True):
        paella.Setup.__init__(self, nop=nop)
        self.with_python = with_python

    def common_first(self):
        self.install_downloaders()

        self.pip_install("wheel")
        self.pip_install("setuptools --upgrade")

        self.install("git maven gzip unzip")
        self.run("%s/bin/getgcc --modern" % READIES)
        self.run("%s/bin/getredis --version 6" % READIES)
        self.pip_install("git+https://github.com/RedisLabsModules/RLTest.git@master")

    def debian_compat(self):
        self.install("openssh-client")

    def centos7(self):
        self.install("openssh-client")

    def centos8(self):
        self.install("openssh")

#----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Set up system for RedisGears build.')
parser.add_argument('-n', '--nop', action="store_true", help='no operation')
parser.add_argument('--with-python', action="store_true", default=True, help='with Python')
args = parser.parse_args()

RedisGearsSetup(nop = args.nop, with_python=args.with_python).setup()
