//
//  AddWordViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 29.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WordPacksController.h"
#import "ViewController.h"

@interface AddWordViewController : NSViewController

@property(nonatomic, weak) IBOutlet NSTextField *wordText;
@property(nonatomic, weak) IBOutlet NSTextField *pinyin;
@property(nonatomic, weak) IBOutlet NSTextField *translation;

-(IBAction)cancelAddOperation:(id)sender;
-(IBAction)acceptWordOperation:(id)sender;
-(void)dismissThisView;

@end
