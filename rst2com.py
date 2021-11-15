import sys
import os
from numpy import *
import numpy as np
# making template file
def template(Geo,atomlist,N_solute,N_atom):
    fileout=open('./com/template.com','w')
    fileout.write('%nprocshared=8\n')
    fileout.write('%mem=8GB\n')
    fileout.write('#p opt=(calcfc,ts,noeigen) freq=(selectnormalmodes,hpmodes) oniom(m062x/6-31g(d):amber)=embedcharge nosymm geom=connectivity\n')
    fileout.write('iop(2/9=1000,3/33=0,3/36=-1,3/160=2,4/33=0,5/33=0,6/7=2,6/9=2,6/10=2,6/12=2,7/8=10,2/15=3) test\n')
    fileout.write('\n')
    fileout.write('ONIOM inputfile\n')
    fileout.write('\n')
    fileout.write('0 1 0 1 0 1\n')
    for i in range(0,N_solute):
        fileout.write(atomlist[i]+' 0 '+Geo[3*i]+' '+Geo[3*i+1]+' '+Geo[3*i+2]+' H\n')
    for i in range(N_solute,N_atom):
        fileout.write(atomlist[i]+' -1 '+Geo[3*i]+' '+Geo[3*i+1]+' '+Geo[3*i+2]+' L \n')
    fileout.close()
# get geometry info from RST file
def getGeo(Geo,lines_rst,N_atom):
    for i in range(2,(len(lines_rst)-1)/2):
        for j in range(0,6):
		Geo.append(lines_rst[i].split()[j])
    if int((N_atom-1)/2) == int(N_atom/2):
        for j in range(0,3):
		Geo.append(lines_rst[(len(lines_rst)-1)/2].split()[j])
    if int((N_atom+1)/2) == int(N_atom/2):
        for j in range(0,6):	
		Geo.append(lines_rst[(len(lines_rst)-1)/2].split()[j])
    return Geo
# making atomic list
def Atomlist(atomlist,lines_list,N_solute,N_solvent,Num_sol):
    for i in range(0,N_solute): atomlist.append(lines_list[i].split()[0])
    for i in range(0,Num_sol):
        for j in range(0,N_solvent):
            atomlist.append(lines_list[j+N_solute].split()[0])
    return atomlist
N_atom=input("Please input the total number of atoms in the system \n")
#N_geo=input("Please input the total number of RST files in your sampling \n")
N_solute=input("Please input the number of solute atoms \n")
N_solvent=input("Please input the number of atoms in each solvent molecule\n")


Num_sol=(N_atom-N_solute)/N_solvent
os.system("mkdir com")
# extract coordinate info
RST='./template.rst'
filein_rst=open(RST,'r')
lines_rst=filein_rst.readlines()
Geo=[]
Geo=getGeo(Geo,lines_rst,N_atom)
# extract atomlist
listfile='./list'
filein_list=open(listfile,'r')
lines_list=filein_list.readlines()
atomlist=[]
atomlist=Atomlist(atomlist,lines_list,N_solute,N_solvent,Num_sol)
# making template file for gaussian
template(Geo,atomlist,N_solute,N_atom)
filein_rst.close()
filein_list.close()
