//
//  CellViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "CellViewController.h"

@interface CellViewController ()

@end

@implementation CellViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setCellTitle:(NSString*)title wordAmount:(NSInteger)wordAmount totalProgress:(double)totalProgress
{
    CellView *view = (CellView*)self.view;
    view.packName.stringValue = title;
    view.packWordAmount.stringValue = [NSString stringWithFormat:@"%li", (long)wordAmount];
    view.progress.doubleValue = totalProgress*100.0;
}

@end
