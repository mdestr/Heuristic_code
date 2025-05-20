import numpy as np
import matplotlib.pyplot as plt
import random as rd

N=20
k=0

while k<N:
    x=rd.uniform(0,1)
    y=rd.uniform(0,1)
    plt.plot(x,y,marker='o',color='r')
    k+=1

