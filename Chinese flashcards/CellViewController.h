//
//  CellViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CellView.h"

@interface CellViewController : NSViewController

-(void)setCellTitle:(NSString*)title wordAmount:(NSInteger)wordAmount totalProgress:(double)totalProgress;

@end
