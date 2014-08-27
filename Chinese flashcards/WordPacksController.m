//
//  WordPacksController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "WordPacksController.h"

@implementation WordPacksController

+ (id)sharedWordPacksController
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] initWithWordPacksFromCoreData];
    });
    
    // returns the same object each time
    return _sharedObject;
}

-(WordPack*)getWordPackAtIndex:(NSInteger)index
{
    return [_wordPacks objectAtIndex:index];
}

-(NSInteger)getWordCountForPackAtIndex:(NSInteger)index
{
    return [[_wordPacks objectAtIndex:index] getWordCount];
}

-(Word*)getWordAtIndex:(NSInteger)index1 ofWordPackAtIndex:(NSInteger)index2
{
    WordPack *pack = [_wordPacks objectAtIndex:index2];
    return [pack getWordAtIndex:index1];
}

-(id)initWithWordPacksFromCoreData
{
    self = [super init];
    _wordPacks = [[NSMutableArray alloc] init];
    
    if(self)
    {
        Word *word1 = [[Word alloc] initWithWordText:@"ni hao" translation:@"hello" pinyin:@"ni hao" levelKnown:1];
        Word *word2 = [[Word alloc] initWithWordText:@"xiexie" translation:@"thanks" pinyin:@"xiexie" levelKnown:2];
        Word *word3 = [[Word alloc] initWithWordText:@"jiejie" translation:@"bye" pinyin:@"jiejie" levelKnown:3];
        WordPack *pack1 = [[WordPack alloc] initWithTitle:@"Chinese 1 vocabulary"];
        WordPack *pack2 = [[WordPack alloc] initWithTitle:@"Chinese 2 vocabulary"];
        [pack1 addWord:word1];
        [pack1 addWord:word2];
        [pack2 addWord:word3];
        
        [_wordPacks addObject:pack1];
        [_wordPacks addObject:pack2];
        
    }
    
    return self;
}

-(NSInteger)getWordPacksCount
{
    return _wordPacks.count;
}

-(NSArray*)getWordPacks
{
    return _wordPacks;
}

@end
