#!/usr/bin/env python

from os import path
from filecmp import dircmp
import sys


def print_diff_files(dcmp):
    print(" In pdf ")
    for name in dcmp.diff_files:
        print ("diff_file %s found in %s and %s" % (name, dcmp.left, dcmp.right))
    for sub_dcmp in dcmp.subdirs.values():
        print_diff_files(sub_dcmp)

#Compare two directories using the python filecpm.dircmp facility

if __name__ == '__main__':

    if (len(sys.argv) != 3):
        print('Usage: dircomp.py director1 directory 2')
        sys.exit(-1)

    dirA = sys.argv[1]
    dirB = sys.argv[2]
    print('Input Dir: ', dirA)
    print('Output Dir: ', dirB)
    if (path.exists(dirA) == False):
        print(dirA, 'does not exist...bye')
        sys.exit(-1)
    if (path.exists(dirB) == False):
        print(dirB, 'does not exist...bye')
        sys.exit(-1)
    if (path.isdir(dirA) == False):
        print(dirA, 'is not a directory. ... bye ...')
        sys.exit(-1)
    if (path.isdir(dirB) == False):
        print(dirB, 'is not a directory. ... bye ...')
        sys.exit(-1)

    dcmp = dircmp(dirA, dirB).report()
    ##print_diff_files(dcmp)
    print("Fininshed")
