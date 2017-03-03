//
//  WordCellViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WordCellView.h"
#import "CFToneColorer.h"

@interface WordCellViewController : NSViewController

-(void)setCellWord:(NSString*)word pinyin:(NSString*)pinyin translation:(NSString*)translation level:(NSInteger)levelKnown;

@end
