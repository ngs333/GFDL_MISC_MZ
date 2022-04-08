#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection

#Read a file of 3D points.
# A line has fields x,y,z (i.e comma separated point)
# POlygons are seperated by at least one comment line
def read_polys_2d( fname ):
    polygons = []
    poly = []
    with open(fname, "r") as filestream:
        for line in filestream:
            if line.startswith("#"):
                if (len(poly) != 0):
                    cpoly = Polygon(np.asarray(poly), closed=True)
                    polygons.append(cpoly)
                    poly = []     
            else:
                point = line.split(",")
                point = list(map(float, point))
                point = np.asarray(point)
                point = point / 360.0 ###
                poly.append( point )
        if (len(poly) != 0):
            cpoly = Polygon(np.asarray(poly), closed=True)
            polygons.append(cpoly)
    return (polygons)
    
if __name__ == '__main__':

    fig, ax = plt.subplots()
    polys = []

    num_polygons = 1
    num_sides = 3

    for i in range(num_polygons):
        poly = Polygon(np.random.rand(num_sides ,2), True)
        polys.append(poly)
        print(poly)
    print(polys)

    polys = read_polys_2d('/home/mzuniga/fre_polyarea/polys/polys2db.txt') 
    print(polys)
    p = PatchCollection(polys, cmap=matplotlib.cm.jet, alpha=0.4)

    colors = 100*np.random.rand(len(polys))

    p.set_array(np.array(colors))
    ax.add_collection(p)
    plt.show()
    print("All comparisons fininshed")

