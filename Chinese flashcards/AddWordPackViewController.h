//
//  AddWordPackViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 31.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WordPacksController.h"
#import "ViewController.h"

@interface AddWordPackViewController : NSViewController

@property(nonatomic, weak) IBOutlet NSTextField *titleField;

-(IBAction)addWordPack:(id)sender;
-(IBAction)cancelAddAction:(id)sender;
-(void)dismissThisView;


@end
