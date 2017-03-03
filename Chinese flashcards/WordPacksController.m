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
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] initWithWordPacksFromCoreData];
    });
    
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
    _wordPacks = [WordPack all];
    _appDelegate = [NSApplication sharedApplication].delegate;
    _managedObjectContext = _appDelegate.managedObjectContext;
    
    if(self)
    {
        //_wordPacks = [[WordPack all] copy];
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

-(NSArray*)fetchWordPacksFromCoreDataWithTitle:(NSString*)wordPackTitle error:(NSError*)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", wordPackTitle];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:_managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];

    return [_managedObjectContext executeFetchRequest:fetch error:&error];
}

-(BOOL)fetchAndSaveWordPack:(WordPack*)pack
{
    NSError *error;
    NSArray *fetchedObjects = [self fetchWordPacksFromCoreDataWithTitle:pack.title error:error];
    if (fetchedObjects.count > 0) {
        NSManagedObject *object = [fetchedObjects firstObject];
        [self saveWordPackAsManagedObject:object pack:pack error:error];
    }
    
    if (![_managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}

-(void)saveWordPackAsManagedObject:(NSManagedObject*)object pack:(WordPack*)pack error:(NSError*)error
{
    [object setValue:pack.title forKey:@"name"];
    [object setValue:[pack getCombinedWords] forKey:@"words"];
    [_managedObjectContext save:&error];
}

-(BOOL)updateWordPackToCoreDataWithIndex:(NSInteger)index
{
    WordPack *pack = [_wordPacks objectAtIndex:index];
    return [self fetchAndSaveWordPack:pack];
}


-(BOOL)updateWordPackToCoreData:(WordPack*)wordPack
{
    return [self fetchAndSaveWordPack:wordPack];
}


-(BOOL)addWordWithWordText:(NSString*)wordText pinyin:(NSString*)pinyin translation:(NSString*)translation packIndex:(NSInteger)packIndex
{
    WordPack *pack = [_wordPacks objectAtIndex:packIndex];
    BOOL ok = [pack addWord:wordText translation:translation pinyin:pinyin levelKnown:0];
    if (ok) {
        return [pack update];
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
    for (WordPack *pack2 in _wordPacks) {
        if ([pack2.title isEqualToString:title]) {
            return NO;
        }
    }
    
    WordPack *pack = [[WordPack alloc] initWithTitle:title];
    if([pack save])
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
