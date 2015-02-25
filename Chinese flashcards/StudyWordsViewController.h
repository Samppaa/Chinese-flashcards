//
//  StudyWordsViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 31.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResizableTextField.h"
#import "WordPacksController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface StudyWordsViewController : NSViewController

@property(nonatomic, weak) IBOutlet ResizableTextField *chineseWord;
@property(nonatomic, weak) IBOutlet ResizableTextField *pinyin;
@property(nonatomic, weak) IBOutlet ResizableTextField *translation;
@property(nonatomic, weak) IBOutlet NSButton *correctButton;
@property(nonatomic, weak) IBOutlet NSButton *incorrectButton;
@property(nonatomic, strong) WordPack *wordPack;
@property(nonatomic, weak) WordPack *originalWordPack;
@property(nonatomic, assign) NSInteger currentWordIndex;
@property(nonatomic, strong) NSMutableDictionary *wordLevels;

-(void)prepareWithWordPack:(WordPack*)pack;
-(IBAction)revealAnswer:(id)sender;
-(void)setNextWordCorrect:(BOOL)correct;
-(IBAction)correctAnswer:(id)sender;
-(IBAction)incorrectAnswer:(id)sender;

@end
