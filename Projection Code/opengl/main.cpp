#include <GL/freeglut.h>
#include "SOIL/SOIL.h"
#include <iostream>
#include <fstream>
#include <stdint.h>
#include <string>

#define IMAGE_DIM 512
#define TEXTURE_FILE "world.topo.bathy.200401.3x5400x2700.jpg"

//Prototypes
void saveData();
void display();
void saveBitmap(const std::string &fn);

//Globals (sorry)
GLuint textureID = 0;

void display()
{
    //Do nothing
    glutLeaveMainLoop();
}

void saveBitmap(const std::string &fn)
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
    
    SOIL_save_screenshot("test2.bmp", SOIL_SAVE_TYPE_BMP, 0, 0, IMAGE_DIM, IMAGE_DIM);
    
}

void saveData()
{
	glViewport(0, 0, IMAGE_DIM, IMAGE_DIM);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(60.0, 1.0, 1e-5, 10);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	gluLookAt(0, 0, 0, 0, 0, -1, 0, 1, 0);

	//Test shape
	glColor3f(1.0, 1.0, 1.0);
	glBegin(GL_QUADS);
	glTexCoord2f(0.0, 0.0); glVertex3f(0, 0, -2.0);
	glTexCoord2f(1.0, 0.0); glVertex3f(1.0, 0.0, -3.0);
	glTexCoord2f(1.0, 1.0); glVertex3f(1.0, 1.0, -3.0);
	glTexCoord2f(0.0, 1.0); glVertex3f(0.0, 1.0, -2.0);
	glEnd();

	glFlush();
    saveBitmap("test2.bmp");

}

int main(int argc, char* argv[])
{    
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
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

	glutDisplayFunc(display);
	saveData();
    return 0;
    
}
