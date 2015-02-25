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
    _appDelegate = [NSApplication sharedApplication].delegate;
    _managedObjectContext = _appDelegate.managedObjectContext;
    
    if(self)
    {
        Word *word1 = [[Word alloc] initWithWordText:@"ni hao" translation:@"hello" pinyin:@"ni hao" levelKnown:1];
        Word *word2 = [[Word alloc] initWithWordText:@"xiexie" translation:@"thanks" pinyin:@"xiexie" levelKnown:2];
        Word *word3 = [[Word alloc] initWithWordText:@"jiejie" translation:@"bye" pinyin:@"jiejie" levelKnown:3];
        WordPack *pack1 = [[WordPack alloc] initWithTitle:@"Chinese 1 vocabulary"];
        WordPack *pack2 = [[WordPack alloc] initWithTitle:@"Chinese 2 vocabularyyyyyyyd"];
        [pack1 addWord:word1];
        [pack1 addWord:word2];
        [pack2 addWord:word3];
        
        //[self addWordPackToCoreData:pack2];
        [self getWordPacksFromCoreData];
        
        //////
        
        
        
    }
    
    return self;
}

-(BOOL)deleteWordPackWithTitle:(NSString*)title
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", title];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:_managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetch error:&error];
    
    for (NSManagedObject *o in fetchedObjects) {
        [_managedObjectContext deleteObject:o];
    }
    
    NSError *error2;
    if (![_managedObjectContext save:&error2]) {
        return NO;
    }
    
    for (WordPack *p in _wordPacks) {
        if ([p.title isEqualToString:title]) {
            [_wordPacks removeObject:p];
            break; // ?
        }
    }
    
    return YES;
}

-(void)getWordPacksFromCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"WordPack" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *wordPack in fetchedObjects) {
        WordPack *pack = [[WordPack alloc] initWithString:[wordPack valueForKey:@"words"]];
        pack.title = [wordPack valueForKey:@"name"];
        [_wordPacks addObject:pack];
    }
}

-(BOOL)addWordPackToCoreData:(WordPack*)pack
{
    NSManagedObject *questionPack = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"WordPack"
                                     inManagedObjectContext:_managedObjectContext];
    [questionPack setValue:pack.title forKey:@"name"];
    [questionPack setValue:[pack getCombinedWords] forKey:@"words"];
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)updateWordPackToCoreDataWithIndex:(NSInteger)index
{
    WordPack *pack = [_wordPacks objectAtIndex:index];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", pack.title];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:_managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0) {
        NSManagedObject *object = [fetchedObjects firstObject];
        [object setValue:pack.title forKey:@"name"];
        [object setValue:[pack getCombinedWords] forKey:@"words"];
        [_managedObjectContext save:&error];
    }
    
    if (![_managedObjectContext save:&error]) {
        return NO;
    }
    
    
    return YES;
}


-(BOOL)updateWordPackToCoreData:(WordPack*)wordPack
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", wordPack.title];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:_managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0) {
        NSManagedObject *object = [fetchedObjects firstObject];
        [object setValue:wordPack.title forKey:@"name"];
        [object setValue:[wordPack getCombinedWords] forKey:@"words"];
        [_managedObjectContext save:&error];
    }
    
    if (![_managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}


-(BOOL)addWordWithWordText:(NSString*)wordText pinyin:(NSString*)pinyin translation:(NSString*)translation packIndex:(NSInteger)packIndex
{
    BOOL ok1 = [[_wordPacks objectAtIndex:packIndex] addWord:wordText translation:translation pinyin:pinyin levelKnown:0];
    if (ok1) {
        return [self updateWordPackToCoreDataWithIndex:packIndex];
    }
    
    return NO;
}

-(double)calculateTotalProgressForWordPack:(WordPack*)pack
{
    double maxProgress = [pack getWordCount]*4;
    double currentProgress = 0;
    
    for (Word *word in pack.words) {
        currentProgress += [word getLevelKnown];
    }

    if ([pack getWordCount] == 0) {
        return 0;
    }
    
    return (currentProgress/maxProgress);
}

-(BOOL)addWordPackWithTitle:(NSString*)title
{
    // First check for same names!
    
    for (WordPack *pack2 in _wordPacks) {
        if ([pack2.title isEqualToString:title]) {
            return NO;
        }
    }
    
    WordPack *pack = [[WordPack alloc] initWithTitle:title];
    if([self addWordPackToCoreData:pack])
    {
        [_wordPacks addObject:pack];
        return YES;
    }
    
    return NO;
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
