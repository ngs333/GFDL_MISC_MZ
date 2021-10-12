#!/usr/bin/env python
import sys
import os
import subprocess as sp
from os import path

#Inspect the files in the input directoryy and check if they can be combined, and if so
#combine by applying either mppcombine or combine-ncc.
#A set of files of pattern filename  X.nc.000N, where N is an integer, are combined if
#the file X.nc.0001 exists.

if __name__ == '__main__':

    if(len(sys.argv) != 3) :
        print('Usage: python combine input_directory output_directory')
        sys.exit(-1)

    inDir =  sys.argv[1]
    outDir = sys.argv[2]
    print('Input Dir: ', inDir)
    print('Output Dir: ', outDir)
    if (path.exists(inDir) == False):
        print(inDir, 'does not exist...bye')
        sys.exit(-1)
    if (path.exists(outDir) == False):
        print(outDir, 'does not exist...bye')
        sys.exit(-1)
    if( path.isdir(inDir) == False):
        print(inDir, 'is not a directory. ... bye ...')
        sys.exit(-1)
    if (path.isdir(outDir) == False):
        print(outDir, 'is not a directory. ... bye ...')
        sys.exit(-1)

    extensionZ = '.nc.0001'
    tCommand = 'is-compressed'
    mppCommand = 'mppnccombine'
    nccCommand = 'combine-ncc'

    # Create a list of all the files with the specified extension
    nameHeaders = []
    one_files = [f for f in os.listdir(inDir) if f.endswith(extensionZ)]
    for file in one_files :
         str = file[: file.rfind(extensionZ) + 5]
         nameHeaders.append(str)

    #Iterate over the groups of files to combine. A group is all the files that
    #beign with the same hname.
    for hname in nameHeaders :
        file_group = [f for f in os.listdir(inDir) if f.startswith(hname)]
        firstFile = inDir + '/' + file_group[0]
        npos = (file_group[0]).rfind('.nc.0')
        outFile = outDir + '/' + (file_group[0])[:npos + 3]
        regFile = inDir + '/' + (file_group[0])[:npos + 3] + '.????'

        # convert list of file names to a string using list comprehension
        #file_group_string = ' '.join(inDir + '/' + elem for elem in file_group)

        p = sp.Popen(tCommand + ' ' + firstFile, stdout=sp.PIPE, shell=True)
        (output, err) = p.communicate()
        p_status = p.wait()
        #combine the files in the current group
        if (p_status != 0):
            #p = sp.Popen(mppCommand + ' ' + outFile + ' ' + file_group_string, stdout=sp.PIPE, shell=True)
            p = sp.Popen(mppCommand + ' ' + outFile + ' ' + regFile, stdout=sp.PIPE, shell=True)
        else :
            #p = sp.Popen(nccCommand + ' ' + file_group_string + ' ' + outFile, stdout=sp.PIPE, shell=True)
            p = sp.Popen(nccCommand + ' ' + regFile + ' ' + outFile, stdout=sp.PIPE, shell=True)
        (output, err) = p.communicate()
        p_status = p.wait()
        print("Command exit status/return code : ", p_status)
        print("Command output : ", output.decode('utf-8'))
        print("-------------------------")

    print ("Looks like program is finished ... bye bye")

def splitPath(s):
    f = os.path.basename(s)
    p = s[:-(len(f))-1]
    return f, p






