//
//  Word.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "Word.h"

@implementation Word

- (id)initWithWordText:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(NSInteger)levelKnowForWord
{
    self = [super init];
    
    if(self)
    {
        _wordText = [[NSString alloc] initWithString:word];
        _translation = [[NSString alloc] initWithString:translationForWord];
        _pinyin = [[NSString alloc] initWithString:pinyinForWord];
        _levelKnown = levelKnowForWord;
    }
    
    return self;
}

-(NSString*)stringValue
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:_wordText];
    [string appendString:@":"];
    [string appendString:_translation];
    [string appendString:@":"];
    [string appendString:_pinyin];
    [string appendString:@":"];
    [string appendFormat:@"%li", (long)_levelKnown];
    return [NSString stringWithString:string];
}

-(id)initWithString:(NSString*)string
{
    self = [super init];
    
    if(self)
    {
        NSArray *propertiesRaw = [string componentsSeparatedByString:@":"];
        _wordText = [[NSString alloc] initWithString:[propertiesRaw objectAtIndex:0]];
        _translation = [[NSString alloc] initWithString:[propertiesRaw objectAtIndex:1]];
        _pinyin = [[NSString alloc] initWithString:[propertiesRaw objectAtIndex:2]];
        _levelKnown = [[propertiesRaw objectAtIndex:3] integerValue];
    }
    
    return self;
}

@end
