//
//  DAMVueOpenGL.m
//  OGLTP1
//
//  Created by LOUVET Florian on 02/02/2016.
//  Copyright © 2016 LOUVET Florian. All rights reserved.
//

#import "DAMVueOpenGL.h"
#import <OpenGL/glu.h>
#import <GLKit/GLKit.h>


@implementation DAMVueOpenGL

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    [self resizeGL];
    [self setLight];
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0, 0, -4); //translation vers l’arrière en Z
    glRotatef(m_angleX, 1, 0, 0); //rotation/axe x de 30 degrés
    glRotatef(m_angleY, 0, 1, 0); //rotation/axe y de -30 degrés
    glRotatef(m_angleZ, 0, 0, 1); //rotation/axe Z de 0 degrés
    glTranslatef(-0.5, -0.5, -0.5); //milieu du cube à l’origine
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferCube);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, (GLvoid *)(0));
    glColorPointer(3, GL_FLOAT, 0, (GLvoid *)(72*sizeof(GLfloat)));
    glNormalPointer(GL_FLOAT, 0,  (GLvoid *)(144*sizeof(GLfloat)));
    glDrawArrays(GL_QUADS, 0, 24);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glFlush();
}

+ (NSOpenGLPixelFormat*) basicPixelFormat
{
    NSOpenGLPixelFormatAttribute attributes [] = {
        NSOpenGLPFADoubleBuffer, // double buffer
        NSOpenGLPFADepthSize, // format de z-buffer =
        (NSOpenGLPixelFormatAttribute)16, // 16 bit par pixel
        (NSOpenGLPixelFormatAttribute)nil
    };
    return [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
}

- (id)initWithFrame:(NSRect)frame
{
    NSOpenGLPixelFormat * pf = [DAMVueOpenGL basicPixelFormat];
    self = [super initWithFrame:frame pixelFormat:pf];
    if (self) {
        m_angleX = 30;
        m_angleY = -30;
        m_angleZ = 0;
        [self prepareOpenGL];
        
    }
    return self;
}

- (void) resizeGL
{
    //on récupère la taille de la vue
    NSRect rectView = [self bounds];
    float width = rectView.size.width;
    float height = rectView.size.height;
    
    //transformation de viewport
    glViewport(0, 0, width, height);
    //transformation de projection
    GLfloat ratio = width/ height;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0f, ratio, 1, 400);
    
}

- (void) prepareOpenGL
{
    glClearColor(0.8f, 0.8f, 0.8f, 0.0f);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glFrontFace(GL_CCW);
    [self createVBOCube];
    
    
}

-(void) createVBOCube{
    
    GLKVector3 A = GLKVector3Make(0, 0, 1);
    GLKVector3 B = GLKVector3Make(1, 0, 1);
    GLKVector3 C = GLKVector3Make(1, 1, 1);
    GLKVector3 D = GLKVector3Make(0, 1, 1);
    
    GLKVector3 E = GLKVector3Make(0, 0, 0);
    GLKVector3 F = GLKVector3Make(1, 0, 0);
    GLKVector3 G = GLKVector3Make(1, 1, 0);
    GLKVector3 H = GLKVector3Make(0, 1, 0);
    
    //Couleurs des faces
    GLKVector3 rouge = GLKVector3Make(1.0, 0.0, 0.0);
    GLKVector3 vert = GLKVector3Make(0.0, 1.0, 0.0);
    GLKVector3 bleu = GLKVector3Make(0.0, 0.0, 1.0);
    GLKVector3 cyan = GLKVector3Make(0.0, 1.0, 1.0);
    GLKVector3 magenta = GLKVector3Make(1.0, 0.0, 1.0);
    GLKVector3 jaune = GLKVector3Make(1.0, 1.0, 0.0);
    
    GLKVector3 N1 = GLKVector3Make(0.0, 0.0, 1.0);
    GLKVector3 N2 = GLKVector3Make(1.0, 0.0, 0.0);
    GLKVector3 N3 = GLKVector3Make(0.0, 0.0, -1.0);
    GLKVector3 N4 = GLKVector3Make(-1.0, 0.0, 0.0);
    GLKVector3 N5 = GLKVector3Make(0.0, 1.0, 0.0);
    GLKVector3 N6 = GLKVector3Make(0.0, -1.0, 0.0);

    
    GLKVector3 vertex_data[] = {
        
        A,B,C,D, //Face 1
        
        E,A,D,H, //Face 2
        
        B,F,G,C, //Face 3
        
        F,E,H,G, //Face 4
        
        D,C,G,H, //Face 5
        
        E,F,B,A, //Face 6
        
        // -----
        
        rouge,rouge,rouge,rouge, //Couleur face 1
        
        vert,vert,vert,vert, //Couleur face 2
        
        bleu,bleu,bleu,bleu, //Couleur face 3
        
        cyan,cyan, cyan, cyan, //Couleur face 4
        
        magenta, magenta, magenta, magenta, //Couleur face 5
        
        jaune, jaune, jaune, jaune, //Couleur face 6
        
        // -----
        
        N1, N1, N1, N1,
        
        N4, N4, N4, N4,

        N2, N2, N2, N2,
        
        N3, N3, N3, N3,

        N5, N5, N5, N5,

        N6, N6, N6, N6,

    };
    
    
    glGenBuffers(1, &bufferCube);
    glBindBuffer(GL_ARRAY_BUFFER, bufferCube);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GL_FLOAT)*216,
                 vertex_data, GL_STATIC_DRAW);
    
    
    
}

- (void) awakeFromNib {

m_timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f)
                target:self
                selector:@selector(animationTimer:)
                userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:m_timer
                                 forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:m_timer
                                 forMode:NSEventTrackingRunLoopMode];
     
}

- (void)animationTimer:(NSTimer *)timer{
    //m_angleY += 0.8f;
    //m_angleZ += 0.8f;
    //m_angleX += 0.8f;
    [self setNeedsDisplay:YES];
    
};

- (void) setLight{
    GL_LIGHT0;
    
    
    //glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambiante);
    
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    
    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT, GL_AMBIENT);
    glColorMaterial(GL_FRONT, GL_DIFFUSE);
}

- (void)mouseDown:(NSEvent *)event{
    lastPos = [event locationInWindow];
}


- (void)mouseDragged:(NSEvent *)event{
    NSPoint newPos = [event locationInWindow];
    NSRect rectView = [self bounds];
    float width = rectView.size.width;
    float height = rectView.size.height;
    double dx = (newPos.x - lastPos.x)/height;
    double dy = (newPos.y - lastPos.y)/width;
    m_angleX -= dy*180;
    m_angleY += dx*180;
    [self setNeedsDisplay:YES];
    lastPos = newPos;
}

@end


