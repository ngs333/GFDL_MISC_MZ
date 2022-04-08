#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
from mpl_toolkits.mplot3d.art3d import Poly3DCollection  # appropriate import to draw 3d polygons
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

#Read a file of 3D points.
# A line has fields x,y,z (i.e comma separated point)
def read_polys( fname ):
    verts = []
    with open(fname, "r") as filestream:
        for line in filestream:
            if not line.startswith("#"):
                point3d = line.split(",")
                point3d = list(map(float, point3d))
                verts.append( point3d )
    return (verts)
#Read a file of 3D points.
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
    return (polygons) #3 columss, nrows

if __name__ == '__main__':

    plt.figure('SPLTV',figsize=(10,5))
    ax=plt.subplot(121,projection='3d')

    verts1 = read_polys_3d('/home/mzuniga/fre_polyarea/polys/polys3b.txt')
    verts2 = read_polys_3d('/home/mzuniga/fre_polyarea/polys/polys3c.txt')
    box = bbox(verts1)

    # 2. create 3d polygons and specify parameters
    coll1 = Poly3DCollection(verts1, alpha=.25, facecolor='#800000')
    face_color1 = [0.5, 0.5, 1]
    coll1.set_facecolor(face_color1)
    # 3. add polygon to the figure (current axes)
    plt.gca().add_collection3d(coll1)

    coll2 = Poly3DCollection(verts2, alpha=.25, facecolor='#800000')
    face_color2 = [0.1, 0.5, 0.0]
    coll1.set_facecolor(face_color2)
    # 3. add polygon to the figure (current axes)
    plt.gca().add_collection3d(coll2)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_xlim(box[0][0], box[1][0])
    ax.set_ylim(box[0][1], box[1][1])
    plt.show()

    print("All comparisons fininshed")

