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

-(NSInteger)count
{
    return self.getWordCount;
}

-(void)shuffleWords
{
    
}

-(BOOL)isEmpty
{
    if (_words.count == 0) {
        return YES;
    }
    
    return NO;
}

-(BOOL)deleteWord:(Word*)word
{
    for (int i = 0; i < _words.count; i++) {
        if(_words.count > 0)
        {
            Word *word2 = [_words objectAtIndex:i];
            if ([word.wordText isEqualToString:word2.wordText]) {
                [_words removeObjectAtIndex:i];
                return YES;
            }
        }
    }
    
    return NO;
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

-(void)mix
{
    NSUInteger count = [_words count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((uint32_t)remainingCount);
        [_words exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    WordPack* copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.title = [self.title copyWithZone:zone];
        copy.words = [self.words copyWithZone:zone];
    }
    
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WordPack* copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.title = [self.title mutableCopyWithZone:zone];
        copy.words = [self.words mutableCopyWithZone:zone];
    }
    
    return copy;
}

-(void)setLevelKnownForWordAtIndex:(NSInteger)index levelKnown:(NSInteger)levelKnown
{
    Word* word = [_words objectAtIndex:index];
    word.levelKnown = levelKnown;
}

-(BOOL)updateWordKnownValueWithWordName:(NSString*)name newValue:(NSInteger)newValue
{
    for (Word *word in _words) {
        if ([word.wordText isEqualToString:name]) {
            word.levelKnown = newValue;
            return YES;
        }
    }
    
    return NO;
}



// Format is word:pinyin:translation:levelknown;
-(id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        
        if ([string isEqualToString:@""] || string == nil) {
            _words = [[NSMutableArray alloc] init];
            return self;
        }
        
        _words = [[NSMutableArray alloc] init];
        NSArray *wordsRaw = [string componentsSeparatedByString:@";"];
        for (NSString *string in wordsRaw) {
            Word *word = [[Word alloc] initWithString:string];
            [_words addObject:word];    
        }
    }
    
    return self;
    
}

-(NSString*)getCombinedWords
{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (Word *word in _words) {
        [string appendString:[word stringValue]];
        if (word != _words.lastObject) {
            [string appendString:@";"];
        }
    }
    
    return string;
}

-(NSManagedObject*)getManagedObject:(NSManagedObjectContext*)context
{
    NSManagedObject *questionPack = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"WordPack"
                                     inManagedObjectContext:context];
    [questionPack setValue:_title forKey:@"title"];
    [questionPack setValue:[self getCombinedWords] forKey:@"words"];
    return questionPack;
}



-(BOOL)addWord:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(NSInteger)levelKnowForWord
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

-(BOOL)isCompleted
{
    for (Word *w in self.words) {
        if (w.getLevelKnown < 4) {
            return false;
        }
    }
    
    return true;
}

-(BOOL)save
{
    AppDelegate *appDelegate = [NSApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSManagedObject *questionPack = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"WordPack"
                                     inManagedObjectContext:managedObjectContext];
    [questionPack setValue:self.title forKey:@"name"];
    [questionPack setValue:[self getCombinedWords] forKey:@"words"];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}


-(BOOL)update
{
    AppDelegate *appDelegate = [NSApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", self.title];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    
    if (fetchedObjects.count > 0) {
        NSManagedObject *object = [fetchedObjects firstObject];
        [object setValue:self.title forKey:@"name"];
        [object setValue:[self getCombinedWords] forKey:@"words"];
        [managedObjectContext save:&error];
    }
    
    if (![managedObjectContext save:&error]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)destroy
{
    AppDelegate *appDelegate = [NSApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@", self.title];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WordPack" inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    
    for (NSManagedObject *o in fetchedObjects) {
        [managedObjectContext deleteObject:o];
    }
    
    NSError *error2;
    if (![managedObjectContext save:&error2]) {
        return NO;
    }
    
    return YES;
}

+(NSMutableArray*)all
{
    AppDelegate *appDelegate = [NSApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSMutableArray *wordPacks = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"WordPack" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *wordPack in fetchedObjects) {
        WordPack *pack = [[WordPack alloc] initWithString:[wordPack valueForKey:@"words"]];
        pack.title = [wordPack valueForKey:@"name"];
        [wordPacks addObject:pack];
    }
    
    return wordPacks;
}

@end
