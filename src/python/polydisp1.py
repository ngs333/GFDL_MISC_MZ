import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import matplotlib.patches as mpatches

map_proj = ccrs.Orthographic(central_latitude=-35.0, central_longitude=214)
map_proj._threshold /= 100.
ax = plt.axes(projection=map_proj)

ax.set_global()
ax.gridlines()

ax.coastlines(linewidth=0.5, color='k', resolution='50m')


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
lat_corners = np.array([ -35.2644, -35.9889, -36.7609, -35.9889 ])
lon_corners = np.array([215,  213.427,  215, 216.573])



poly_corners = np.zeros((len(lat_corners), 2), np.float64)
poly_corners[:,0] = lon_corners
poly_corners[:,1] = lat_corners

poly = mpatches.Polygon(poly_corners, closed=True, ec='r', fill=False, lw=1, fc=None, transform=ccrs.Geodetic())

ax.add_patch(poly)
plt.show()