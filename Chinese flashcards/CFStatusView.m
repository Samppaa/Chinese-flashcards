//
//  CFStatusView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 20.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "CFStatusView.h"

@implementation NSBezierPath (BezierPathQuartzUtilities)
- (CGPathRef)quartzPath
{
    int i, numElements;
    
    CGPathRef           immutablePath = NULL;
    

    numElements = (int)[self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
        
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }

        
        if (!didClosePath)
            CGPathCloseSubpath(path);
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    return immutablePath;
}
@end

@implementation CFStatusView

#define STROKE_WIDTH    (0.9)
#define STROKE_CONSTANT (4.0)

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    self.darkGreenColor = [NSColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0];
    self.darkerGreenColor = [NSColor colorWithRed:0.0 green:0.50 blue:0.0 alpha:1.0];
    self.darkRedColor = [NSColor colorWithCalibratedRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    
    if(self.color == NULL)
        self.color = [NSColor redColor];

    NSBezierPath *path;
    NSRect rectangle;
    
    rectangle = [self bounds];
    rectangle.origin.x += STROKE_WIDTH / STROKE_CONSTANT;
    rectangle.origin.y += STROKE_WIDTH / STROKE_CONSTANT;
    rectangle.size.width -= STROKE_WIDTH / STROKE_CONSTANT;
    rectangle.size.height -= STROKE_WIDTH / STROKE_CONSTANT;
    
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.frame = rectangle;
    animationLayer.backgroundColor = [[NSColor redColor] CGColor];
    animationLayer.borderColor = self.darkRedColor.CGColor;
    animationLayer.borderWidth = 0.35f;
    animationLayer.cornerRadius = (rectangle.size.width/1.8f);
    
    self.currentStatus = CF_STATUS_BAD;
    [self setLayer:animationLayer];
    [self setWantsLayer:YES];
    self.path = path;
}

-(CGPoint)getCenter
{
    return CGPointMake(((self.layer.frame.size.width / 2.67)),
                       ((self.layer.frame.size.height / 2.67)));
}

-(void)setStateTo:(NSInteger)status
{
    if(status == CF_STATUS_BAD && self.currentStatus == CF_STATUS_OK)
        [self changeStatusTo:CF_STATUS_OK];
    else if(status == CF_STATUS_OK && self.currentStatus == CF_STATUS_BAD)
        [self changeStatusTo:CF_STATUS_BAD];
}

-(void)changeStatusTo:(NSInteger)status
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    
    NSRect rect = NSMakeRect([self getCenter].x, [self getCenter].y, 0, 0);
    
    if(self.topLayer == NULL)
    {
        CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
        animationLayer.frame = rect;
        animationLayer.backgroundColor = self.darkGreenColor.CGColor;
        //animationLayer.cornerRadius = (rect.size.width/2.0f);
        self.topLayer = animationLayer;
        [self.layer addSublayer:animationLayer];
    }
    
    
    CGFloat animationTime = 0.15f;
    
    // Animation for circle size
    if(status == CF_STATUS_BAD)
    {
        animation.fromValue = [NSValue valueWithRect:self.topLayer.bounds];
        self.topLayer.frame = self.layer.bounds;
        animation.toValue = [NSValue valueWithRect:self.layer.bounds];
        animation.duration = animationTime;
        animation.delegate = self;
        
        // Animation for the circle radius
        animation2.fromValue = @(rect.size.width/2.0f);
        self.topLayer.cornerRadius = self.layer.cornerRadius+2.0;
        animation2.toValue = @(self.layer.cornerRadius+2.0);
        animation2.duration = animationTime;
        self.currentStatus = CF_STATUS_OK;
    }
    else
    {
        NSRect rect = NSMakeRect([self getCenter].x+1.5, [self getCenter].y+1.5, 0, 0);
        animation.fromValue = [NSValue valueWithRect:self.topLayer.bounds];
        self.topLayer.frame = rect;
        animation.toValue = [NSValue valueWithRect:rect];
        animation.duration = animationTime;
        animation.delegate = self;
        
        // Animation for the circle radius
        animation2.fromValue = @(self.layer.cornerRadius);
        self.topLayer.cornerRadius = rect.size.width/2.0f;
        animation2.toValue = @(rect.size.width/2.0f);
        animation2.duration = animationTime;
        self.currentStatus = CF_STATUS_BAD;
        
    }
    
    [self.topLayer addAnimation:animation forKey:@"animation"];
    [self.topLayer addAnimation:animation2 forKey:@"animation2"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.currentStatus == CF_STATUS_OK)
    {
        self.layer.borderColor = self.darkerGreenColor.CGColor;
        self.layer.backgroundColor = self.darkGreenColor.CGColor;
    }
}

-(void)animationDidStart:(CAAnimation *)anim
{
    if(self.currentStatus == CF_STATUS_BAD)
    {
        self.layer.borderColor = self.darkRedColor.CGColor;
        self.layer.backgroundColor = [[NSColor redColor] CGColor];
    }
}

-(void)toggle
{
    [self changeStatusTo:self.currentStatus];
}


@end

