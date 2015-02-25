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
        // Initialization code here.
        
    }
    return self;
}


-(void)viewDidLoad
{
    // Bug here
    if ([_wordPack isEmpty]) {
        [self.presentingViewController dismissViewController:self];
    }
    
    _currentWordIndex = 0;
    Word *word = [_wordPack getWordAtIndex:_currentWordIndex];
    _chineseWord.stringValue = word.wordText;
    _pinyin.stringValue = word.pinyin;
    _translation.stringValue = word.translation;
    self.title = _wordPack.title;
}


-(void)prepareWithWordPack:(WordPack*)pack
{
    _originalWordPack = pack;
    _wordPack = [pack mutableCopy];
    _wordLevels = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *include = [defaults objectForKey:@"includeKnownWords"];
    
    if(!include.boolValue)
    {
        NSLog(@"here!");
        NSMutableArray *wordsToDelete = [[NSMutableArray alloc] init];
        for (Word *word in _wordPack.words) {
            if (word.levelKnown == 4) {
                [wordsToDelete addObject:word];
            }
        }
        
        for (Word *word in wordsToDelete) {
            NSLog(@"removed word");
            [_wordPack deleteWord:word];
        }
    }
    
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

-(void)setNextWordCorrect:(BOOL)correct
{
    
    _pinyin.hidden = YES;
    _translation.hidden = YES;
    _correctButton.hidden = YES;
    _incorrectButton.hidden = YES;
    
    if(correct)
    {
        if([_wordPack getWordCount] > 0)
        {
            Word *word = [_wordPack getWordAtIndex:_currentWordIndex];
            NSNumber *numberValue = (NSNumber*)[_wordLevels objectForKey:word.wordText];
            NSInteger currentValue = numberValue.integerValue;
            currentValue++;
            [_wordLevels setObject:[NSNumber numberWithInteger:currentValue] forKey:word.wordText];
            if (currentValue == 3) {
                if (word.levelKnown < 5) {
                    NSLog(@"here!");
                    word.levelKnown++;
                    [_originalWordPack updateWordKnownValueWithWordName:word.wordText newValue:word.levelKnown];
                    if([[WordPacksController sharedWordPacksController] updateWordPackToCoreData:_originalWordPack])
                        NSLog(@"Updated word pack!");
                }
                [_wordPack deleteWord:word];
                // Problem here!
                if([_wordPack getWordCount] == 0)
                {
                    // Reload the tableview2 and tableview1
                    ViewController *controller = (ViewController*)self.presentingViewController;
                    [controller updateTableViewsAfterStudy];
                    [self.presentingViewController dismissViewController:self];
                }
            }
        }
    }
    
    if([_wordPack getWordCount] > 0)
    {
        _currentWordIndex++;
        if(_currentWordIndex+1 > _wordPack.getWordCount)
        {
            _currentWordIndex = 0;
            
            if([_wordPack getWordCount] > 4) // Settings maybe?
                [_wordPack mix];
        }
        
        Word *word = [_wordPack getWordAtIndex:_currentWordIndex];
        _chineseWord.stringValue = word.wordText;
        _pinyin.stringValue = word.pinyin;
        _translation.stringValue = word.translation;
    }
}


-(void)keyUp:(NSEvent*)event
{
    NSLog(@"test");
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

-(void)viewWillLayout
{
    /*NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"test"];
     NSString *test = @"test";
     [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:[test rangeOfString:@"te"]];
     [_chineseWord setAttributedStringValue:string];*/
    
    NSInteger minSize = 36;
    NSInteger minSize2 = 17;
    NSInteger maxSize = 90;
    NSInteger maxSize2 = 23;
    
    if(self.view.frame.size.height > 500 && (minSize+(self.view.frame.size.height-500)) < maxSize)
    {
        
        [_chineseWord setFont:[NSFont fontWithName:_chineseWord.font.fontName size:minSize+(self.view.frame.size.height-500)]];
        
        NSInteger fontToSet = minSize2+(self.view.frame.size.height-500);
        if (fontToSet > maxSize2) {
            fontToSet = maxSize2;
        }
        
        [_pinyin setFont:[NSFont fontWithName:_pinyin.font.fontName size:fontToSet]];
        [_translation setFont:[NSFont fontWithName:_pinyin.font.fontName size:fontToSet]];
        
    }
}

-(void)viewWillTransitionToSize:(NSSize)newSize
{
    NSLog(@"yes");
}


@end
