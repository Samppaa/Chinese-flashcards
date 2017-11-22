//
//  CFStatusView.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 20.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

enum {
    CF_STATUS_OK,
    CF_STATUS_BAD
};

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CFStatusView : NSView <CAAnimationDelegate>

@property(nonatomic) NSBezierPath *path;
@property(nonatomic, strong) NSColor* color;
@property(nonatomic, strong) CALayer *topLayer;
@property(nonatomic, assign) NSInteger currentStatus;
@property(nonatomic, strong) NSColor *darkGreenColor;
@property(nonatomic, strong) NSColor *darkerGreenColor;
@property(nonatomic, strong) NSColor *darkRedColor;

-(void)setStateTo:(NSInteger)status;
-(void)changeStatusTo:(NSInteger)status;
-(void)toggle;
-(CGPoint)getCenter;

@end
