from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import os
import glob

########################################################################################
def readfile(f):
    col = []
    with open(f, 'r') as r:
        lines = r.readlines()
        for line in lines:
            col.append(line.split()[1])
    return col

path = '/home/Betop/Desktop/Graduation_Project/5_qmtraj/water/bond-dist/'   
dict = {}
for i in range(1,200):
    for j in range(1, 5):
        cols = []
        for k in range(1, 4):
            try:
                col = readfile(path+'new-'+str(i)+'.'+str(j)+'Bond'+str(k)+'.agr')
                cols.append(col)
            except:
                # print('not new-'+str(i)+'.'+str(j)+'Bond'+str(k)+'.agr')
                continue
        if len(cols)==0:
            continue
        dict['new-'+str(i)+'.'+str(j)+'Bond'] = cols
plt.figure()
ax = plt.subplot(111, projection='3d')
ax.set_xlim(1.5, 4.0) 
ax.set_ylim(1.5, 4.0) 
ax.set_zlim(1.5, 4.0) 
ax.set_xlabel('Bond3')
ax.set_ylabel('Bond2')
ax.set_zlabel('Bond1')
  
for key, value in dict.items():
    num_x = 0
    num_y = 0
    X=np.array([float(i) for i in value[2]])
    Y=np.array([float(i) for i in value[1]])
    Z=np.array([float(i) for i in value[0]])
    for xaxis in X:
        if xaxis < 1.6: 
            linespilt1 = ax.plot3D(X, Y, Z, color='b', linewidth=0.1)        
    for yaxis in Y:
        if yaxis < 1.6: 
            linespilt2 = ax.plot3D(X, Y, Z, color='r', linewidth=0.1)
plt.show()



