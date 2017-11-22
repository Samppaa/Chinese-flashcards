//
//  StudyWordsViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 31.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "StudyWordsViewController.h"

@interface StudyWordsViewController ()

@end

@implementation StudyWordsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

-(NSInteger)calculateMaxProgress
{
    return (self.wordPack.count*self.timesToGetCorrect);
}


-(void)increaseProgressByOneCorrectAnswer
{
    [self.progressIndicator incrementBy:1.0];
}


-(void)viewDidLoad
{
    _currentWordIndex = 0;
    _timesToGetCorrect = 3;
    
    Word *word = [_wordPack getWordAtIndex:_currentWordIndex];
    [self setCurrentWord:word];
    
    self.progressIndicator.maxValue = self.calculateMaxProgress;
}

-(void)viewDidAppear
{
    NSMutableString *titleString = [[NSMutableString alloc] initWithString:@"Studying: "];
    [titleString appendString:_wordPack.title];
    self.view.window.title = titleString;
}

-(void)trimAlreadyKnownWords
{
    NSMutableArray *wordsToDelete = [[NSMutableArray alloc] init];
    for (Word *word in _wordPack.words) {
        if (word.levelKnown == 4) {
            [wordsToDelete addObject:word];
        }
    }
    
    for (Word *word in wordsToDelete) {
        [_wordPack deleteWord:word];
    }
}

-(void)prepareWithWordPack:(WordPack*)pack
{
    _originalWordPack = pack;
    _wordPack = [pack mutableCopy];
    _wordLevels = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *include = [defaults objectForKey:@"includeKnownWords"];
    
    _timesToGetCorrect = 3;
    
    if(!include.boolValue && !pack.isCompleted)
        [self trimAlreadyKnownWords];
    
    for (Word *word in _wordPack.words) {
        [_wordLevels setObject:[NSNumber numberWithInteger:0] forKey:word.wordText];
    }
}

-(IBAction)revealAnswer:(id)sender
{
    _pinyin.hidden = !_pinyin.hidden;
    _translation.hidden = !_translation.hidden;
    _correctButton.hidden = !_correctButton.hidden;
    _incorrectButton.hidden = !_incorrectButton.hidden;
}

-(IBAction)correctAnswer:(id)sender
{
    if(!_correctButton.hidden)
        [self setNextWordCorrect:YES];
}


-(IBAction)incorrectAnswer:(id)sender
{
    if(!_correctButton.hidden)
        [self setNextWordCorrect:NO];
}

-(void)setCurrentWord:(Word*)word
{
    if ([CFToneColorer validateWord:word.wordText pinyin:word.pinyin])
    {
        NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithAttributedString:[CFToneColorer getColoredString:word.pinyin characters:word.wordText]];
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = kCTTextAlignmentCenter;
        [tempString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tempString.length)];
        _chineseWord.attributedStringValue = tempString;
    }
    else
    {
        _chineseWord.stringValue = word.wordText;
    }
    
    _pinyin.stringValue = word.pinyin;
    _translation.stringValue = word.translation;
}

-(void)startFromBeginningIfRequired
{
    if(_currentWordIndex+1 > _wordPack.getWordCount)
    {
        _currentWordIndex = 0;
        
        if([_wordPack getWordCount] > 4)
            [_wordPack mix];
    }
    
    [self setCurrentWord:[_wordPack getWordAtIndex:_currentWordIndex]];
}

-(void)increaseWordLevel:(Word*)word
{
    word.levelKnown++;
    [_originalWordPack updateWordKnownValueWithWordName:word.wordText newValue:word.levelKnown];
    [[WordPacksController sharedWordPacksController] updateWordPackToCoreData:_originalWordPack];
}

-(void)setNextWordCorrect:(BOOL)correct
{
    
    _pinyin.hidden = YES;
    _translation.hidden = YES;
    _correctButton.hidden = YES;
    _incorrectButton.hidden = YES;
    
    if(correct)
    {
        if(!_wordPack.isEmpty)
        {
            Word *word = [_wordPack getWordAtIndex:_currentWordIndex];
            NSNumber *numberValue = (NSNumber*)[_wordLevels objectForKey:word.wordText];
            NSInteger currentValue = numberValue.integerValue;
            currentValue++;
            [_wordLevels setObject:[NSNumber numberWithInteger:currentValue] forKey:word.wordText];
            [self increaseProgressByOneCorrectAnswer];
            
            if (currentValue == self.timesToGetCorrect) {
                if (word.levelKnown < 5) {
                    [self increaseWordLevel:word];
                }
                [_wordPack deleteWord:word];
                
                if(_wordPack.isEmpty)
                {
                    ViewController *controller = (ViewController*)self.presentingViewController;
                    [controller updateTableViewsAfterStudy];
                    [self.presentingViewController dismissViewController:self];
                }
            }
        }
    }
    
    if(!_wordPack.isEmpty)
    {
        _currentWordIndex++;
        [self startFromBeginningIfRequired];
    }
}


- (BOOL)acceptsFirstResponder {
    return YES;
}



@end
