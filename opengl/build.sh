#/bin/bash

gcc -c SOIL/*.c -ISOIL -w
g++ main.cpp *.o -o genData -lfreeglut -lglu32 -lopengl32
rm *.o
