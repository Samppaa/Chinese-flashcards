//
//  WordVault.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordVault : NSObject

@property(nonatomic) NSMutableArray *words;

-(id)initWithWordsFromCoreData;
-(BOOL)addWord:(Word*)word;
-(Word*)getWordWithText:(NSString*)text;
-(BOOL)updateWord:(Word*)word newWord:(Word*)word2;
-(BOOL)updateWordWithName:(NSString*)name newWord:(Word*)word;

@end
