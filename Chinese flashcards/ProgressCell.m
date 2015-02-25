//
//  ProgressCell.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 31.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "ProgressCell.h"

@interface ProgressCell ()

@end

@implementation ProgressCell

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setProgress:(NSInteger)progress
{
    ProgressCellView *view = (ProgressCellView*)self.view;
    [view.levelIndicator setDoubleValue:progress];
}

@end
