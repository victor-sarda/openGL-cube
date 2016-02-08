//
//  DAMVueOpenGL.h
//  OGLTP1
//
//  Created by LOUVET Florian on 02/02/2016.
//  Copyright © 2016 LOUVET Florian. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DAMVueOpenGL : NSOpenGLView{
    GLuint bufferCube;
    GLfloat m_angleX;
    GLfloat m_angleY;
    GLfloat m_angleZ;
    NSTimer* m_timer;
    NSPoint lastPos;
}

+ (NSOpenGLPixelFormat*) basicPixelFormat;
- (void) createVBOCube;;
- (void) prepareOpenGL;
- (void) resizeGL;
- (void) animationTimer:(NSTimer *)timer;
- (void)mouseDown:(NSEvent *)event;
- (void)mouseDragged:(NSEvent *)event;

@end
