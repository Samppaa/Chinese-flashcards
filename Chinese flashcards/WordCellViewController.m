//
//  WordCellViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "WordCellViewController.h"

@interface WordCellViewController ()

@end

@implementation WordCellViewController

-(void)setCellWord:(NSString*)word pinyin:(NSString*)pinyin translation:(NSString*)translation level:(NSInteger)levelKnown
{
    WordCellView *view = (WordCellView*)self.view;
    if ([CFToneColorer validateWord:word pinyin:pinyin]) {
        view.word.attributedStringValue = [CFToneColorer getColoredString:pinyin characters:word];
        //view.word.stringValue = word;
    }
    else
    {
        view.word.stringValue = word;
    }
    view.pinyin.stringValue = pinyin;
    view.translation.stringValue = translation;
    view.levelKnown.integerValue = levelKnown;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
