#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 11 20:41:44 2020

@author: Max Pensack
"""
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.collections import PatchCollection

# Fixing random state for reproducibility
#np.random.seed(420000)
radius = 100 #originally 200, adjusted on 01/17/21


def new_poly(initial_vertices): 

    gain = radius*.2*np.random.randn()
    new_vertices = np.empty([len(initial_vertices)*2,2])
    diffs = np.diff(initial_vertices,axis=0)
    thetas = np.empty([len(initial_vertices),1])
    
    for i in range(len(initial_vertices)):
        new_vertices[2*i] = initial_vertices[i]
        new_vertices[2*i+1] = np.mean(initial_vertices[i:i+2],axis=0)
        if i == len(initial_vertices)-1:
            thetas[i] = np.arctan(diffs[0,1]/diffs[0,0])
        else:
            thetas[i] = np.arctan(diffs[i,1]/diffs[i,0])
        
        new_vertices[2*i+1,0] = new_vertices[2*i+1,0] + gain * np.sin(thetas[i])
        new_vertices[2*i+1,1] = new_vertices[2*i+1,1] - gain * np.cos(thetas[i])
    return new_vertices



def fractal_generator():
    #Parameters
    n_layers = 6;
    
    fig, ax = plt.subplots()
    patches = []
    
    
    #For each layer
    for i in range(n_layers):
        n_edges = np.random.randint(3,9) #initial number of edges
        recursion_depth = np.random.randint(3,5) #max # of recursive steps
        
        #Generate n-sided polygon
        initial_poly = mpatches.RegularPolygon((0,0), n_edges, radius=radius-radius*0.1*i, orientation=2*np.pi*np.random.randn())
        vertices = mpatches.Patch.get_verts(initial_poly)
        
        #Deflect midpoints
        for j in range(recursion_depth):
            vertices = new_poly(vertices)
    
        patches.append(mpatches.Polygon(vertices))
    
    colors = 100*np.random.rand(len(patches))        
    maps = ['jet']
    p = PatchCollection(patches, cmap=np.random.choice(maps), alpha=0.65)
    p.set_array(colors)
    ax.add_collection(p)
    
    #Add black circle to center of image
    #ax.add_patch(mpatches.Circle((0,0), radius=0.05*radius, color='k'))

    
    plt.axis('equal')
    plt.axis('off')
    plt.tight_layout()
    return fig


#Make stimuli
for i in range(8):
    filename= 'stim_'+str(i)+'.svg'
    f = fractal_generator()
    
    f.savefig(filename, transparent=True)
