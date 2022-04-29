#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection # appropriate import to draw 3d polygons
from matplotlib import style

#get a bounding box from the input data
def bbox(points):
    """
    [xmin ymin zmin]
    [xmax ymax zmax]
    """
    a = np.zeros((2,3))
    a[0,:] = np.amin(points, axis=1)
    a[1,:] = np.amax(points, axis=1)
    return a


# Read a file of 3D points.
# A line has fields x,y,z (i.e comma separated point)
# POlygons are seperated by at least one comment line
def read_polys_3d( fname ):
    polygons = []
    poly = []
    with open(fname, "r") as filestream:
        for line in filestream:
            if line.startswith("#"):
                if (len(poly) != 0):
                    cpoly = np.asarray(poly)
                    polygons.append(cpoly)
                    poly = []     
            else:
                point = line.split(",")
                point = list(map(float, point))
                point = np.asarray(point)
                point = point
                poly.append( point )
    if (len(poly) != 0):
        cpoly = np.asarray(poly)
        polygons.append(cpoly)
        poly = []     
    return (polygons)

# Read a file of 3D points.
# A line has fields <x,y,z> 
# POlygons are seperated by at least one comment line.
# Note first coooment line is assume dto start as 
# "#ATMxLND "
# Notation
#  aXl stands for ATM-x-LND exhange grid
#  aXlXo stands for ATM-x-LND-x-OCN exhange grid
def read_polys_3d_xg( fname ):
    aXl_header="#ATMxLND "
    aXlXo_header="#ATMxLNDxOCN "
    o_header="#OCN "
    polys_aXl = []
    polys_o = []
    polys_aXlXo = []
    cpolys = polys_aXl # cpolys are the current polygons being read
    ppolys = cpolys # the prior polygons being read
    poly = []
    with open(fname, "r") as filestream:
        for line in filestream:
            if line.startswith(aXlXo_header):
                ppolys = cpolys
                cpolys = polys_aXlXo   
            elif line.startswith(aXl_header):
                ppolys = cpolys
                cpolys = polys_aXl
            elif line.startswith(o_header):
                ppolys = cpolys
                cpolys = polys_o
    
            if line.startswith("#"):
                if (len(poly) != 0): #In case the last was not saved
                    cpoly = np.asarray(poly)
                    ppolys.append(cpoly)
                    poly = []     
            elif line.startswith("<"):
                    line = line.replace("<", "")
                    line = line.replace(">", "")
                    point = line.split(",")
                    point = list(map(float, point))
                    point = np.asarray(point)
                    point = point
                    poly.append( point )
            else:
                print("dropping line", line)
    #
    if (len(poly) != 0):
        cpoly = np.asarray(poly)
        cpolys.append(cpoly)
        poly = []     
    return polys_aXl, polys_o, polys_aXlXo ;

if __name__ == '__main__':

    plt.figure('SPLTV',figsize=(10,5))
    ax=plt.subplot(121,projection='3d')

    #verts1 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/axo3_polys.txt')
    #verts2 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/polys3c.txt')

    #verts1, verts2, verts3 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/axo4_2.txt')
    #verts1, verts2, verts3 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/poly3d_good1.txt')
    #verts1, verts2, verts3 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/lxo_1.txt')
    verts1, verts2, verts3 = read_polys_3d_xg('/home/mzuniga/fre_polyarea/polys/axo5.4.txt')

    verts123 = np.concatenate((verts1, verts2) ,1)
    verts123 = np.concatenate((verts123, verts3),1)

    box = bbox(verts123)
    alpha = 0.5

    # 2. create 3d polygons and specify parameters
    coll1 = Poly3DCollection(verts1 )
    face_color1 = [1.0, 0, 0, alpha]  #red
    coll1.set_facecolor(face_color1)
    plt.gca().add_collection3d(coll1)

    # repeat for second set 
    coll2 = Poly3DCollection(verts2)
    face_color2 = [0, 1.0, 0, 2 * alpha]  #green
    coll2.set_facecolor(face_color2)
    plt.gca().add_collection3d(coll2)

     # repeat for 3rd set 
    coll3 = Poly3DCollection(verts3, linewidth=2.0,linestyle="--", edgecolors="black")
    face_color3 = [0.0, 0.0, 1.0, alpha] #blue;
    coll3.set_facecolor(face_color3)
    plt.gca().add_collection3d(coll3)


    #coll3 = Line3DCollection(verts3, colors='k', linewidths=5.0, linestyles=':')
    #plt.gca().add_collection3d(coll3)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_xlim(box[0][0], box[1][0])
    ax.set_ylim(box[0][1], box[1][1])
    #ax.set_zlim(-1, 1)
    #ax.set_xlim(-0.05, 0.05)
    #ax.set_ylim(-0.05, 0.06)
    ax.set_zlim( -1,1)
    
    plt.show()

    print("All comparisons fininshed")

