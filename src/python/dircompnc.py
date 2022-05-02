#!/usr/bin/env python3

import os
import filecmp
from os import path
from filecmp import dircmp
import string
import sys
import subprocess as sp
from os import path
import argparse


#Compare two directories using the python filecpm.dircmp facility
def comp_with_fatts(d1, d2):
    print(" Comparing with pythons filecmp.dircmp - i.e. by unix file attributes.")
    filecmp.dircmp(d1,d2).report()
    #for name in dcmp.diff_files:
    #    print ("diff_file %s found in %s and %s" % (name, dcmp.left, dcmp.right))
    #for sub_dcmp in dcmp.subdirs.values():
    #    print_diff_files(sub_dcmp)


#Compare the netcdf files among the two directories using GFDL's (Remiks) nccmp utility
def comp_with_nccmp (d1, d2):
    extension_nc = '.nc'
    cmpCommand = 'nccmp'

    # Create a list of all the files with the specified extension
    nc_files = [f for f in os.listdir(d1) if f.endswith(extension_nc)]
    dcount = 0
    fcount = 0
    
    #Iterate over the files to compare
    for nc_name in nc_files :
        f1 = d1 + '/' + nc_name
        f2 = d2 + '/' + nc_name
        fcount += 1
    
        print("-------------------------")
        print("Starting nccmp compare of " + nc_name)

        ##nccmp -d only prints first diff in file; -df prints more'
        # Fields of make_hgrid output: x,y,dx,dy,angle_dx,angle_dy,arcx,area
        #other_args = ' --variable=angle_dx,angle_dy --tolerance=1.0e-8 '
        other_args = ' --variable=x,y,dx,dy,arcx,area '
        other_args = ' --variable=x,y --tolerance=1.0e-10 '
        #other_args = ' --variable=dx,dy --tolerance=1.0e-6 '
        #other_args = ' --variable=area --Tolerance=1.0e-6 '
        #other_args = ' --variable=arcx --tolerance=1.0e-14 '
        #other_args = ' --variable=angle_dx,angle_dy --tolerance=1.0e-8 '
        other_args = ' '
        finCommand = cmpCommand + ' -df ' + other_args  
        
        p = sp.Popen(finCommand +  f1 + ' ' + f2 , stdout=sp.PIPE, shell=True)
        (output, err) = p.communicate()
        p_status = p.wait()
        if (p_status != 0):
            ##print("! Non-zero status/return code : ", p_status)
            ##print("Command output : ", output.decode('utf-8'))
            dcount += 1

    print("-----------------------------")
    print("nccmp comparisons finshed.")
    print("Dir 1 :" + os.path.abspath(d1));
    print("Dir 2 :" + os.path.abspath(d2));
    print("Comparison command: " + finCommand)
    print("[# files compared, # files differing]: [" + str(fcount) + ", " + str(dcount) +"]")
    print("-----------------------------")


#Compare the netcdf files among all corresponding subdirectories of the
# the two directories using GFDL's (Remiks) nccmp utility
def comp_with_nccmp_subdirs (d1, d2):
    subdirs =  [f.name for f in os.scandir(d1) if f.is_dir()]
    print("Subdirectories to compare:")
    for element in subdirs:
        print (element)

    print("-----------------------------")
    global files_failed
    global files_compared
    files_failed = 0
    files_compared = 0
    for element in subdirs:
        comp_with_nccmp(d1 + '/' + element, d2 + '/' + element)

    print("[total files compared, total files differing]: [" + str(files_compared) + ", " + str(files_failed) +"]")

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('dirA', type=str, help="The first directory")
    parser.add_argument('dirB', type=str, help="The second directory")
    parser.add_argument('--s', action='store_true', help="compare within all corresponding subdirecotries")
    parser.add_argument('--f', action='store_true', help="Also compare with file atts")
    args = parser.parse_args()

    dirA = sys.argv[1]
    dirB = sys.argv[2]
    print('Directory A: ', dirA)
    print('Direcotry B: ', dirB)
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

    if args.f :
        comp_with_fatts(dirA, dirB)
    if args.s :
        comp_with_nccmp_subdirs(dirA, dirB)
    else :
        comp_with_nccmp(dirA, dirB)

    print("All comparisons fininshed")
