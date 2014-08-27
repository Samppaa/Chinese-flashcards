//
//  CellView.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CellView : NSTableCellView

@property(nonatomic, weak) IBOutlet NSTextField *packName;
@property(nonatomic, weak) IBOutlet NSTextField *packWordAmount;
@property(nonatomic, weak) IBOutlet NSProgressIndicator *progress;

@end
