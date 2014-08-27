//
//  WordPack.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordPack : NSObject

@property(nonatomic, getter=getTitle) NSString *title;
@property(nonatomic, getter=getWords) NSMutableArray *words;

-(id)initWithTitle:(NSString*)title;
-(BOOL)addWord:(Word*)word;
-(BOOL)addWord:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(int)levelKnowForWord;
-(BOOL)deleteWord:(Word*)word;
-(BOOL)deleteWordWithWordText:(NSString*)wordText;
-(BOOL)doesContainWord:(NSString*)wordText;
-(NSInteger)getWordCount;
-(id)initWithString:(NSString*)string;
-(void)shuffleWords;
-(Word*)getWordAtIndex:(NSInteger)index;


@end
