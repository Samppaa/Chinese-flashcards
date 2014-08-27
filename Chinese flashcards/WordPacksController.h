//
//  WordPacksController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPack.h"

@interface WordPacksController : NSObject

@property(strong, nonatomic) NSMutableArray *wordPacks;

+(id)sharedWordPacksController;
-(id)initWithWordPacksFromCoreData;
-(NSInteger)getWordPacksCount;
-(NSInteger)getWordCountForPackAtIndex:(NSInteger)index;
-(NSArray*)getWordPacks;
-(WordPack*)getWordPackAtIndex:(NSInteger)index;
-(Word*)getWordAtIndex:(NSInteger)index1 ofWordPackAtIndex:(NSInteger)index2;

@end
