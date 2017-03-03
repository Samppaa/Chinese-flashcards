//
//  WordCellView.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WordCellView : NSTableCellView

@property(nonatomic, weak) IBOutlet NSTextField *word;
@property(nonatomic, weak) IBOutlet NSTextField *pinyin;
@property(nonatomic, weak) IBOutlet NSTextField *translation;
@property(nonatomic, weak) IBOutlet NSLevelIndicator *levelKnown;


@end
