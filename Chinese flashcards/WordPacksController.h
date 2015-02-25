//
//  WordPacksController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPack.h"
#import "AppDelegate.h"

@interface WordPacksController : NSObject

@property(strong, nonatomic) NSMutableArray *wordPacks;
@property(nonatomic, weak) AppDelegate *appDelegate;
@property(nonatomic, weak) NSManagedObjectContext *managedObjectContext;

+(id)sharedWordPacksController;
-(id)initWithWordPacksFromCoreData;
-(NSInteger)getWordPacksCount;
-(NSInteger)getWordCountForPackAtIndex:(NSInteger)index;
-(NSArray*)getWordPacks;
-(WordPack*)getWordPackAtIndex:(NSInteger)index;
-(Word*)getWordAtIndex:(NSInteger)index1 ofWordPackAtIndex:(NSInteger)index2;
-(BOOL)addWordWithWordText:(NSString*)wordText pinyin:(NSString*)pinyin translation:(NSString*)translation packIndex:(NSInteger)packIndex;
-(BOOL)addWordPackToCoreData:(WordPack*)pack;
-(void)getWordPacksFromCoreData;
-(BOOL)updateWordPackToCoreDataWithIndex:(NSInteger)index;
-(BOOL)updateWordPackToCoreData:(WordPack*)wordPack;
-(BOOL)addWordPackWithTitle:(NSString*)title;
-(BOOL)deleteWordPackWithTitle:(NSString*)title;
-(double)calculateTotalProgressForWordPack:(WordPack*)pack;

@end
