//
//  WordPack.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "AppDelegate.h"

@interface WordPack : NSObject <NSCopying>

@property(nonatomic, getter=getTitle) NSString *title;
@property(nonatomic, getter=getWords) NSMutableArray *words;

-(id)initWithTitle:(NSString*)title;
-(BOOL)isEmpty;
-(BOOL)isCompleted;
-(BOOL)addWord:(Word*)word;
-(BOOL)addWord:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(NSInteger)levelKnowForWord;
-(BOOL)deleteWord:(Word*)word;
-(BOOL)deleteWordWithWordText:(NSString*)wordText;
-(BOOL)doesContainWord:(NSString*)wordText;
-(NSInteger)getWordCount;
-(NSInteger)count;
-(id)initWithString:(NSString*)string;
-(void)shuffleWords;
-(Word*)getWordAtIndex:(NSInteger)index;
-(NSManagedObject*)getManagedObject:(NSManagedObjectContext*)context;
-(NSString*)getCombinedWords;
-(void)mix;
-(void)setLevelKnownForWordAtIndex:(NSInteger)index levelKnown:(NSInteger)levelKnown;
-(BOOL)updateWordKnownValueWithWordName:(NSString*)name newValue:(NSInteger)newValue;

-(BOOL)save;
-(BOOL)update;
-(BOOL)destroy;
+(NSMutableArray*)all;


@end
