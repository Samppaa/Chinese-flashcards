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
#import "CFStatusView.h"

@interface AddWordViewController : NSViewController <NSTextFieldDelegate>

@property(nonatomic, weak) IBOutlet NSTextField *wordText;
@property(nonatomic, weak) IBOutlet NSTextField *pinyin;
@property(nonatomic, weak) IBOutlet NSTextField *translation;
@property(nonatomic, weak) IBOutlet CFStatusView *statusView;
@property(nonatomic, weak) IBOutlet NSTextField *exampleTextField;
@property(nonatomic, strong) WordPack *pack;

-(IBAction)cancelAddOperation:(id)sender;
-(IBAction)acceptWordOperation:(id)sender;
-(void)dismissThisView;
-(void)convertCharactersToPinyin;
-(NSString*)sanitizeUserInput:(NSString*)input;

@end
