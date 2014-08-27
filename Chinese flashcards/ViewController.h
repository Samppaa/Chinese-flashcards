//
//  ViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CellViewController.h"
#import "CellView.h"
#import "WordPacksController.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(nonatomic, weak) IBOutlet NSTableView *tableView;
@property(nonatomic, weak) IBOutlet NSTableView *tableView2;
@property(nonatomic, assign) NSInteger selectedRow;


@end

