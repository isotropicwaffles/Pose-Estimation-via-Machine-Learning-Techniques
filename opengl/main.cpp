#include <GL/freeglut.h>
#include "SOIL/SOIL.h"
#include <iostream>
#include <fstream>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <stdint.h>
#include <string>

#define IMAGE_DIM 512
#define NUM_SAMPLES 500
#define TEXTURE_FILE "world.topo.bathy.200401.3x5400x2700.jpg"

//Prototypes
void saveData();
void display();
void saveBitmap(const std::string &fn);
void drawCube();
void drawCone();
void drawSphere();
void applyRandomPose();
float randFloat();
float cosd(float);
float sind(float);

//Globals (sorry)
GLuint textureID = 0;

float randFloat()
{
    float t = std::rand();
    return t / RAND_MAX;
}

float cosd(float x)
{
    return std::cos(x * M_PI / 180.0);
}

float sind(float x)
{
    return std::sin(x * M_PI / 180.0);
}


void display()
{
    //Do nothing
    //glutLeaveMainLoop();
}

void saveBitmap(const char *fn)
{
 /*   std::fstream fs;
    fs.open(fn.c_str(), std::ios_base::out);
    
    //Write the header
    uint32_t fileSize = 26 + IMAGE_DIM*IMAGE_DIM*3;
    uint16_t blank = 0;
    uint32_t offset = 26;
    
    fs.write("BM", 2);
    fs.write((const char *)&fileSize, sizeof(fileSize));
    fs.write((const char *)&blank, sizeof(blank));
    fs.write((const char *)&blank, sizeof(blank));
    fs.write((const char *)&offset, sizeof(offset));
    
    //Write the extended header
    uint32_t DIBSize = 12;
    uint16_t dim = IMAGE_DIM;
    uint16_t colorPlanes = 1;
    uint16_t bpp = 24;
    
    fs.write((const char *)&DIBSize, sizeof(DIBSize));
    fs.write((const char *)&dim, sizeof(dim));
    fs.write((const char *)&dim, sizeof(dim));
    fs.write((const char *)&colorPlanes, sizeof(colorPlanes));
    fs.write((const char *)&bpp, sizeof(bpp));
    
    //Get the data
    uint8_t *data =  new uint8_t[IMAGE_DIM*IMAGE_DIM*3];
    glReadPixels(0, 0, IMAGE_DIM, IMAGE_DIM, GL_BGR_EXT, GL_UNSIGNED_BYTE, data);
    fs.write((char *)data, IMAGE_DIM*IMAGE_DIM*3);
    fs.close();
    
    delete[] data;
    */
    
    SOIL_save_screenshot(fn, SOIL_SAVE_TYPE_BMP, 0, 0, IMAGE_DIM, IMAGE_DIM);
    
}

void saveData()
{
	glViewport(0, 0, IMAGE_DIM, IMAGE_DIM);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(60.0, 1.0, 1, 50);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	gluLookAt(0, 0, 0, 0, 0, -1, 0, 1, 0);

    //Runs for the three shapes
    
    for (int i = 0; i < NUM_SAMPLES; ++i)
    {
        char buf[256];
        glClear(GL_COLOR_BUFFER_BIT);
        glClear(GL_DEPTH_BUFFER_BIT);
        
        applyRandomPose();
        drawCube();
        glFlush();
        std::sprintf(buf, "cube_%d.bmp", i+1);
        saveBitmap(buf);
    }

    for (int i = 0; i < NUM_SAMPLES; ++i)
    {
        char buf[256];
        glClear(GL_COLOR_BUFFER_BIT);
        glClear(GL_DEPTH_BUFFER_BIT);
        
        applyRandomPose();
        drawCone();
        glFlush();
        std::sprintf(buf, "cone_%d.bmp", i+1);
        saveBitmap(buf);
    }
    
    for (int i = 0; i < NUM_SAMPLES; ++i)
    {
        char buf[256];
        glClear(GL_COLOR_BUFFER_BIT);
        glClear(GL_DEPTH_BUFFER_BIT);
        
        applyRandomPose();
        drawSphere();
        glFlush();
        std::sprintf(buf, "sphere_%d.bmp", i+1);
        saveBitmap(buf);
    };

}

void drawCube()
{
    glColor3f(1.0, 1.0, 1.0);
    glBegin(GL_QUADS);
    
    //Front
    glTexCoord2f(1.0/2, 2.0/3); glVertex3f(0.5, 0.5, -0.5);
    glTexCoord2f(1.0/4, 2.0/3); glVertex3f(-0.5, 0.5, -0.5);
    glTexCoord2f(1.0/4, 1.0/3); glVertex3f(-0.5, -0.5, -0.5);
    glTexCoord2f(1.0/2, 1.0/3); glVertex3f(0.5, -0.5, -0.5);
    
    //Right
    glTexCoord2f(1.0/2, 2.0/3); glVertex3f(0.5, 0.5, -0.5);
    glTexCoord2f(3.0/4, 2.0/3); glVertex3f(0.5, 0.5, 0.5);
    glTexCoord2f(3.0/4, 1.0/3); glVertex3f(0.5, -0.5, 0.5);
    glTexCoord2f(1.0/2, 1.0/3); glVertex3f(0.5, -0.5, -0.5);
    
    //Back
    glTexCoord2f(3.0/4, 2.0/3); glVertex3f(0.5, 0.5, 0.5);
    glTexCoord2f(3.0/4, 1.0/3); glVertex3f(0.5, -0.5, 0.5);
    glTexCoord2f(1, 1.0/3); glVertex3f(-0.5, -0.5, 0.5);
    glTexCoord2f(1, 2.0/3); glVertex3f(-0.5, 0.5, 0.5);
    
    //Left
    glTexCoord2f(0, 2.0/3); glVertex3f(-0.5, 0.5, 0.5);
    glTexCoord2f(0, 1.0/3); glVertex3f(-0.5, -0.5, 0.5);
    glTexCoord2f(1.0/4, 1.0/3); glVertex3f(-0.5, -0.5, -0.5);
    glTexCoord2f(1.0/4, 2.0/3); glVertex3f(-0.5, 0.5, -0.5);
    
    //Top
    glTexCoord2f(1.0/2, 2.0/3); glVertex3f(0.5, 0.5, -0.5);
    glTexCoord2f(1.0/2, 1); glVertex3f(0.5, 0.5, 0.5);
    glTexCoord2f(1.0/4, 1); glVertex3f(-0.5, 0.5, 0.5);
    glTexCoord2f(1.0/4, 2.0/3); glVertex3f(-0.5, 0.5, -0.5);
    
    //Bottom
    glTexCoord2f(1.0/2, 1.0/3); glVertex3f(0.5, -0.5, -0.5);
    glTexCoord2f(1.0/4, 1.0/3); glVertex3f(-0.5, -0.5, -0.5);
    glTexCoord2f(1.0/4, 0); glVertex3f(-0.5, -0.5, 0.5);
    glTexCoord2f(1.0/2, 0); glVertex3f(0.5, -0.5, 0.5);
    
    glEnd();
}

void drawCone()
{
    glColor3f(1.0, 1.0, 1.0);
    
    glBegin(GL_QUADS);
        //So the southern third of the Earth is our cone base
        //How about 100 divisions just because
        for (int i = 0; i < 100; ++i)
        {
            float lon = i*360.0/100.0;
            float x, y, u, v;
            
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1.0/3.0;
            glTexCoord2f(u, v);
            glVertex3f(x, y, 0.5);
            
            lon += 360.0/100.0;
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1.0/3.0;
            glTexCoord2f(u, v);
            glVertex3f(x, y, 0.5);
            
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 0;
            glTexCoord2f(u, v);
            glVertex3f(0, 0, 0.5);
            
            lon -= 360.0/100.0;
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 0;
            glTexCoord2f(u, v);
            glVertex3f(0, 0, 0.5);
            
        }
        
        //Inefficient code here, but now let's generate
        //the upper part of the cone
        for (int i = 0; i < 100; ++i)
        {
            float lon = i*360.0/100.0;
            float x, y, u, v;
            
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1.0/3.0;
            glTexCoord2f(u, v);
            glVertex3f(x, y, 0.5);
            
            lon += 360.0/100.0;
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1.0/3.0;
            glTexCoord2f(u, v);
            glVertex3f(x, y, 0.5);
            
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1;
            glTexCoord2f(u, v);
            glVertex3f(0, 0, -0.5);
            
            lon -= 360.0/100.0;
            x = cosd(lon)*0.5;
            y = sind(lon)*0.5;
            u = lon / 360.0;
            v = 1;
            glTexCoord2f(u, v);
            glVertex3f(0, 0, -0.5);
        }
    
    glEnd();
    
}

void drawSphere()
{
    glColor3f(1.0, 1.0, 1.0);
    
    //Let's make 100 divisions of longitude
    //and 20 divisions of latitude
    glBegin(GL_QUADS);
        for (int i = 0; i < 20; i++)
        {
            for (int j = 0; j < 100; j++)
            {
                float curLat = 90 - i*180.0/20;
                float curLon = j*360.0/100.0;
                float u,v;
                float x, y, z;
                
                x = 0.5*cosd(curLat)*cosd(curLon);
                y = 0.5*cosd(curLat)*sind(curLon);
                z = 0.5*sind(curLat);
                u = curLon / 360.0;
                v = (curLat + 90) / 180.0;
                glTexCoord2f(u, v);
                glVertex3f(x, y, z);
                
                curLon += 360.0/100;
                x = 0.5*cosd(curLat)*cosd(curLon);
                y = 0.5*cosd(curLat)*sind(curLon);
                z = 0.5*sind(curLat);
                u = curLon / 360.0;
                v = (curLat + 90) / 180.0;
                glTexCoord2f(u, v);
                glVertex3f(x, y, z);
                
                curLat -= 180.0/20;
                x = 0.5*cosd(curLat)*cosd(curLon);
                y = 0.5*cosd(curLat)*sind(curLon);
                z = 0.5*sind(curLat);
                u = curLon / 360.0;
                v = (curLat + 90) / 180.0;
                glTexCoord2f(u, v);
                glVertex3f(x, y, z);
                
                curLon -= 360.0/100;
                x = 0.5*cosd(curLat)*cosd(curLon);
                y = 0.5*cosd(curLat)*sind(curLon);
                z = 0.5*sind(curLat);
                u = curLon / 360.0;
                v = (curLat + 90) / 180.0;
                glTexCoord2f(u, v);
                glVertex3f(x, y, z);
            }
        }
    glEnd();
}

void applyRandomPose()
{
   GLfloat x, y, z, yaw, pitch, roll;
   x = randFloat()*3.0 - 1.5;
   y = randFloat()*3.0 - 1.5;
   z = randFloat()*-1.7320 - 2.5981;
   yaw = randFloat()*360;
   pitch = randFloat()*180 - 90.0;
   roll = randFloat()*180;
   
   std::printf("%f %f %f %f %f %f\n", x, y, z, yaw, pitch, roll);
   
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   
   glTranslatef(x, y, z);
   glRotatef(yaw, 0.0, 0.0, 1.0);
   glRotatef(pitch, 0.0, 1.0, 0.0);
   glRotatef(roll, 1.0, 0.0, 0.0);
}

int main(int argc, char* argv[])
{
    std::srand(68672016);
	glutInit(&argc, argv);
	glutInitWindowSize(IMAGE_DIM, IMAGE_DIM);
	glutInitDisplayMode(GLUT_RGB | GLUT_DEPTH);
	glutCreateWindow("GLUT Data Maker");
    
    //Load the SOIL texture
    textureID = SOIL_load_OGL_texture(
        TEXTURE_FILE,
        SOIL_LOAD_AUTO,
        SOIL_CREATE_NEW_ID,
        SOIL_FLAG_INVERT_Y);
        
    if (textureID == 0)
        std::cout << "Uh-oh.. SOIL error" << std::endl;

	//OpenGL settings
	glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

	glutDisplayFunc(display);
	saveData();
    //glutMainLoop();
    return 0;
    
}
