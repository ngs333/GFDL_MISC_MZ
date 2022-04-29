import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import matplotlib.patches as mpatches
#import cartopy
#import matplotlib.patches as mpatches


def points_plot(lon,lat, lon0=0.,lat0=90.,color='k',axp=None):
    """Plot a given array of point"""
    axp.plot(lon, lat, color,
           # transform=cartopy.crs.Geodetic()
            transform=ccrs.PlateCarree()
           )
    return ax

plt.figure(figsize=(8,8))

map_proj = ccrs.cartopy.crs.NorthPolarStereo(central_longitude=0.)
ax = plt.subplot(111, projection=map_proj)
#map_proj = ccrs.Orthographic(central_latitude=-35.0, central_longitude=214)
#map_proj._threshold /= 100.
#ax = plt.axes(projection=map_proj)

ax.gridlines()

sq1=np.array([[82.400,  82.400, 262.400, 262.400, 326.498, 379.641, 82.400+360.],
              [89.835,  90.000,  90.000,  89.847,  89.648,  89.642, 89.835]])
sq2=np.array([[302.252, 330.000, 330.000, 240.000, 240.000,302.252],
              [89.876,  89.891,  90.000,  90.000,  89.942, 89.876]])
sq3=np.array([[240,240,262.4,262.4,240],[89.942, 90,  90,  89.9183,89.942 ]])
points_plot(sq1[0,:],sq1[1,:],color='r',axp=ax)
points_plot(sq2[0,:],sq2[1,:],color='b',axp=ax)
points_plot(sq3[0,:],sq3[1,:],color='o',axp=ax)
ax.gridlines(crs=ccrs.PlateCarree())

ax.set_extent([-300,60,89,90],ccrs.PlateCarree())
plt.show()




#P1
#lat_corners = np.array([ -90.,-90.,-87.9225, -87.0632, -87.9225])
#on_corners = np.array([-10.,  80., 80., 35., -10.])
#P2
#lat_corners = np.array([-87.9225 , -87.0632, -87.9225 , -90., -90. ])
#lon_corners = np.array([170, 125, 80, 80, 170])
#P3
#lat_corners = np.array([-87.9225 , -87.0632, -87.9225 , -90., -90. ])
#lon_corners = np.array([170, 125, 80, 80, 170])
#P4
#lat_corners = np.array([-87.9225 , -90., -90.,  -87.9225,  -87.0632  ])
#lon_corners = np.array([260, 260, 350, 350, 305])
#PX
#lat_corners = np.array([ -35.2644, -35.9889, -36.7609, -35.9889 ])
#lon_corners = np.array([215,  213.427,  215, 216.573])



#poly_corners = np.zeros((len(lat_corners), 2), np.float64)
#poly_corners[:,0] = lon_corners
#poly_corners[:,1] = lat_corners

#poly = mpatches.Polygon(poly_corners, closed=True, ec='r', fill=False, lw=1, fc=None, transform=ccrs.Geodetic())

##ax.add_patch(poly)

#ax.set_extent(
#    [
#        -90, # minimum latitude -90
#        -360, # min longitude
 #       -80, # max latitude
 #   360 # max longitude
 #   ],
#    crs=ccrs.PlateCarree()
#)
