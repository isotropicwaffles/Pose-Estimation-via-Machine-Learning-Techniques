#Utility functions for our project
from math import *
import numpy as np

def sind(angle):
    return sin(radians(angle))

def cosd(angle):
    return cos(radians(angle))

def generalRot(angle, x, y, z):
    R = np.zeros( (4, 4) )
    c = cosd(angle);
    s = sind(angle);

    l = sqrt(x*x + y*y + z*z)
    x = x / l;
    y = y / l;
    z = z / l;

    R[0][0] = x*x*(1-c) + c
    R[0][1] = x*y*(1-c) - z*s
    R[0][2] = x*z*(1-c) + y*s

    R[1][0] = y*x*(1-c) + z*s
    R[1][1] = y*y*(1-c) + c
    R[1][2] = y*z*(1-c) - x*s

    R[2][0] = x*z*(1-c) - y*s
    R[2][1] = y*z*(1-c) + x*s
    R[2][2] = z*z*(1-c) + c

    R[3][3] = 1

    return R

def pose2DCM(yaw, pitch, roll):
    R = generalRot(roll, 1, 0, 0)
    P = generalRot(pitch, 0, 1, 0)
    Y = generalRot(yaw, 0, 0, 1)

    myRot = Y.dot(P)
    myRot = myRot.dot(R)

    out = np.array([[1, 0, 0, 1], [0, 1, 0, 1], [0, 0, 1, 1]]);
    out = np.transpose(out)
    out = myRot.dot(out)
    out = out[0:3, 0:3]
    return out
