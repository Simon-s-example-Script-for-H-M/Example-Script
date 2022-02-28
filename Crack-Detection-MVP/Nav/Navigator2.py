from math import radians
import os
import OpenGL.GL as gl
import OpenGL.GLU as glu
import glob
from OpenGL.raw.GL.VERSION.GL_1_0 import glRects
from pandas.core import window
import pygame
import pygame.locals as locals

# Import the Model3D class
import model3d
from PIL import ImageOps
#import download360
import json

class Navigator2():

    def __init__(self, folder_with_subfolders):
        print(folder_with_subfolders)
        self.original_screen_size = (1200,600)
        self.SCREEN_SIZE = self.original_screen_size
        self.folder_path = folder_with_subfolders
        #assert len(glob.glob(os.path.join(self.folder_path,"coord*"))) > 0, (f"No coordinate files in {glob.glob(self.folder_path)}")
        self.n_cubes = len(glob.glob(os.path.join(self.folder_path,"coord*")))

        


    def initRender(self):

        # Enable the GL features we will be using

        gl.glEnable(gl.GL_DEPTH_TEST)
        gl.glEnable(gl.GL_LIGHTING)
        gl.glEnable(gl.GL_TEXTURE_2D)
        gl.glShadeModel(gl.GL_SMOOTH)

        # Enable light 1 and set position
        gl.glEnable(gl.GL_LIGHTING)
        gl.glEnable(gl.GL_LIGHT0)
        gl.glLight(gl.GL_LIGHT0, gl.GL_POSITION,  (0, .5, 1))

    def resize(self, width, height):

        gl.glViewport(0, 0, width, height)
        gl.glMatrixMode(gl.GL_PROJECTION)
        gl.glLoadIdentity()
        glu.gluPerspective(60.0, float(width)/height, .1, 1000.)
        gl.glMatrixMode(gl.GL_MODELVIEW)
        gl.glLoadIdentity()


    def run(self):

        pygame.init()
        screen = pygame.display.set_mode(self.SCREEN_SIZE, locals.HWSURFACE|locals.OPENGLBLIT|locals.OPENGL|locals.DOUBLEBUF, pygame.RESIZABLE)

        self.resize(*self.SCREEN_SIZE)
        self.initRender()    
        
        # Read the skybox model
        sky_box = model3d.Model3D()
        sky_box.read_obj(glob.glob(os.path.join(self.folder_path,"*_idx0","cube.obj"))[0])  
              
        # Used to rotate the world
        mouse_x = 0.0
        mouse_y = 0.0
        mouse_rel_x = 0.0
        mouse_rel_y = 0.0    
        #Display the mouse cursor
        pygame.mouse.set_visible(True)
        i = 0

        for material in sky_box.materials.values():
    
            gl.glBindTexture(gl.GL_TEXTURE_2D, material.texture_id)    
            gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP_TO_EDGE)
            gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP_TO_EDGE)
        while True:
            
            for event in pygame.event.get():
                if event.type == pygame.MOUSEWHEEL:
                    pass
                if event.type == locals.QUIT:
                    pygame.quit()
                    quit()
                if event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 7:
                        i+=1
                        i = i % (self.n_cubes)
                    elif event.button == 6:
                        i-=1
                        i = i % (self.n_cubes)
                    elif event.button == 4:
                        self.SCREEN_SIZE = (int(self.SCREEN_SIZE[0]*1.1),int(self.SCREEN_SIZE[1]*1.1))
                        self.resize(*self.SCREEN_SIZE)
                    elif event.button == 5:
                        if self.SCREEN_SIZE > self.original_screen_size:
                            self.SCREEN_SIZE = (int(self.SCREEN_SIZE[0]/1.1),int(self.SCREEN_SIZE[1]/1.1))
                            self.resize(*self.SCREEN_SIZE)
                        else:
                            self.SCREEN_SIZE = self.original_screen_size
                            self.resize(*self.SCREEN_SIZE)
                    

                    sky_box = model3d.Model3D()
                    sky_box.read_obj(str(glob.glob(os.path.join(self.folder_path,f"*_idx{i}","cube.obj"))[0]))
                    

                    for material in sky_box.materials.values():
                
                        gl.glBindTexture(gl.GL_TEXTURE_2D, material.texture_id)    
                        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP_TO_EDGE)
                        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP_TO_EDGE)
                        print(material)
                        
            
            f = open(glob.glob(os.path.join(self.folder_path,f"*_idx{i}"))[0] + '/density.json')
            data = json.load(f)
            density_info = data[os.path.basename(glob.glob(os.path.join(self.folder_path,f"*_idx{i}"))[0])]
            density_crack = "{0:.2g}".format(density_info['crack'])
            density_cluster = "{0:.2g}".format(density_info['cluster'])
            density_pothole = "{0:.2g}".format(density_info['pothole'])


            pygame.display.set_caption(glob.glob(os.path.join(self.folder_path,f"*_idx{i}"))[0].split("/")[-1].split("_")[-2].split("[")[-1].split("]")[-2] + f"  {i}/{self.n_cubes-1}" + '    crack-density: ' + f'{density_crack}, ' + 'cluster-density: ' + f'{density_cluster}, ' + 'pothole_density: ' + f'{density_pothole}')
            # We don't need to clear the color buffer (GL_COLOR_BUFFER_BIT)
            # because the skybox covers the entire screen 
            gl.glClear(gl.GL_DEPTH_BUFFER_BIT)        

            gl.glLoadIdentity()

            #print(mouse_x,mouse_y)   
            
            if pygame.mouse.get_pressed()[0]:
                #mouse_rel_x, mouse_rel_y = pygame.mouse.get_rel()
                mouse_x += float(mouse_rel_x) / 10.0
                mouse_y += float(mouse_rel_y) / 10.0
                x_pos, y_pos = mouse_x, mouse_y
            mouse_rel_x, mouse_rel_y = pygame.mouse.get_rel()
            # Rotate around the x and y axes to create a mouse-look camera
            gl.glRotatef(mouse_y, -1, 0, 0)
            gl.glRotatef(mouse_x, 0, -1, 0)

            # Disable lighting and depth test
            gl.glDisable(gl.GL_LIGHTING)
            gl.glDepthMask(False)
            
            # Draw the skybox
            sky_box.draw_quick()

            # Re-enable lighting and depth test before we redraw the world
            gl.glEnable(gl.GL_LIGHTING)
            gl.glDepthMask(True) 
     
            pygame.display.flip()


if __name__ == "__main__":
    from PIL import Image
    Navig = Navigator2("Nav/cubeEdges")
    Navig.run()

