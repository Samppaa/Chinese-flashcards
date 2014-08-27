//
//  WordPack.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "WordPack.h"

@implementation WordPack

-(id)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self) {
        _title = [[NSString alloc] initWithString:title];
        _words = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

-(NSInteger)getWordCount
{
    return _words.count;
}

-(void)shuffleWords
{
    
}

-(BOOL)deleteWord:(Word*)word
{
    return true;
}

-(BOOL)deleteWordWithWordText:(NSString*)wordText
{
    for (Word *word in _words) {
        if ([[word getWordText] isEqualTo:wordText]) {
            [_words removeObject:word];
            return true;
        }
    }
    
    return false;
}

-(Word*)getWordAtIndex:(NSInteger)index
{
    return [_words objectAtIndex:index];
}

-(BOOL)addWord:(Word*)word
{
    if([self doesContainWord:[word getWordText]])
    {
        return false;
    }
    
    [_words addObject:word];
    return true;
}


// Format is word:pinyin:translation:levelknown;
-(id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        NSArray *wordsRaw = [string componentsSeparatedByString:@";"];
        for (NSString *string in wordsRaw) {
            Word *word = [[Word alloc] initWithString:string];
            [_words addObject:word];    
        }
    }
    
    return self;
    
}


-(BOOL)addWord:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(int)levelKnowForWord
{
    if([self doesContainWord:word])
    {
        return false;
    }
    
    Word *wordToAdd = [[Word alloc] initWithWordText:word translation:translationForWord pinyin:pinyinForWord levelKnown:levelKnowForWord];
    [_words addObject:wordToAdd];
    
    return true;
}

-(BOOL)doesContainWord:(NSString*)wordText
{
    for (Word *word in _words) {
        if([[word getWordText] isEqualToString:wordText])
            return true;
            
    }
    
    return false;
}

@end
