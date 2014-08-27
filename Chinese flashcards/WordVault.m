//
//  WordVault.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "WordVault.h"

@implementation WordVault

-(id)initWithWordsFromCoreData
{
    self = [super init];
    
    if(self)
    {

    }
    
    return self;
        
}

-(BOOL)addWord:(Word*)word
{
    return true;
}

-(Word*)getWordWithText:(NSString*)text
{
    return [[Word alloc] init];
}

-(BOOL)updateWord:(Word *)word newWord:(Word *)word2
{
    return true;
}

@end
