//
//  CFToneColorer.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 20.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "CFToneColorer.h"

@implementation CFToneColorer

+(BOOL)doesStringContainIllegalCharacters:(NSString*)string allowedCharacters:(NSString*)allowedCharacters
{
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:allowedCharacters];
    
    if ([string rangeOfCharacterFromSet:validChars.invertedSet].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

+(BOOL)doesStringContainCharacters:(NSString*)string characters:(NSString*)characters
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];
    if ([string rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

+(NSArray*)getColorsForTones
{
    NSArray *toneColors = [[NSArray alloc] initWithObjects:[NSColor grayColor],[NSColor redColor],[NSColor greenColor],[NSColor orangeColor],[NSColor blueColor], nil];
    return toneColors;
}

+(void)forEveryCharacterInString:(NSString*)string do:(void (^) (unichar character, BOOL *stop))handleCharacter
{
    BOOL doesStop = NO;
    
    for (int i = 0; i < string.length; i++) {
        if (doesStop == NO) {
            unichar c = [string characterAtIndex:i];
            handleCharacter(c, &doesStop);
        }
        else {
            break;
        }
    }
}


+(NSAttributedString*)getColoredString:(NSString*)pinyin characters:(NSString*)characters
{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:characters];
    NSArray *colors = [self parseColorsFromPinyin:pinyin];
    NSUInteger range = 0;
    
    for (NSColor *color in colors) {
        [aString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range, 1)];
        range++;
    }
    
    return aString;
}

+(NSArray*)parseColorsFromPinyinWithNumberedTones:(NSString*)pinyin
{
    NSArray *toneColors = [self getColorsForTones];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    __block BOOL lastCharacterWasTone = NO;
    
    [self forEveryCharacterInString:pinyin do:^(unichar character, BOOL *stop) {
        if ([self isCharacterTone:character]) {
            if ([self isCharacterNumericTone:character]) {
                NSNumber *tone = [NSNumber numberWithUnsignedChar:character];
                NSUInteger index = [tone integerValue]-48;
                [colors addObject:[toneColors objectAtIndex:index]];
            }
            else
            {
                if(lastCharacterWasTone == NO)
                    [colors addObject:[toneColors objectAtIndex:TONE_NEUTRAL]];
            }
            lastCharacterWasTone = YES;
        }
        else
            lastCharacterWasTone = NO;
    }];
    
    // Check the last character for neutral tone
    unichar lastChar = [pinyin characterAtIndex:pinyin.length-1];
    if (![self isCharacterNumericTone:lastChar]) {
        [colors addObject:[toneColors objectAtIndex:TONE_NEUTRAL]];
    }
    
    return [colors copy];
}

+(NSArray*)parseColorsFromPinyinWithToneMarks:(NSString*)pinyin
{
    NSMutableArray *tones = [[NSMutableArray alloc] init];
    NSArray *words = [pinyin componentsSeparatedByString:@" "];
    NSArray *toneColors = [self getColorsForTones];
    
    for (NSString *word in words) {
        NSInteger tone = [self getToneForWordWithToneMarks:word];
        if (tone == TONE_NEUTRAL) {
            [tones addObject:[toneColors objectAtIndex:0]];
        }
        else
        {
            [tones addObject:[toneColors objectAtIndex:tone]];
        }
    }
    
    return [tones copy];
}


+(BOOL)isCharacterTone:(unichar)character
{
    NSCharacterSet *oneToFour = [NSCharacterSet characterSetWithCharactersInString:@"1234 "];
    return [oneToFour characterIsMember:character];
}

+(BOOL)isCharacterNumericTone:(unichar)character
{
    NSCharacterSet *oneToFour = [NSCharacterSet characterSetWithCharactersInString:@"1234"];
    return [oneToFour characterIsMember:character];
}

+(NSArray*)parseColorsFromPinyin:(NSString*)pinyin
{
    if ([self doesPinyinContainToneMarks:pinyin]) {
        return [self parseColorsFromPinyinWithToneMarks:pinyin];
    }
    
    return [self parseColorsFromPinyinWithNumberedTones:pinyin];
}

+(NSCharacterSet*)firstTones
{
    NSString *firstTone = @"āēīōūǖĀĒĪŌŪǕ";
    return [NSCharacterSet characterSetWithCharactersInString:firstTone];
}

+(NSCharacterSet*)secondTones
{
    NSString *secondTone = @"áéíóúǘÁÉÍÓÚǗ";
    return [NSCharacterSet characterSetWithCharactersInString:secondTone];
}

+(NSCharacterSet*)thirdTones
{
    NSString *thirdTone = @"ǎěǐǒǔǚǍĚǏǑǓǙ";
    return [NSCharacterSet characterSetWithCharactersInString:thirdTone];
}

+(NSCharacterSet*)fourthTones
{
    NSString *fourthTone = @"àèìòùǜÀÈÌÒÙǛ";
    return [NSCharacterSet characterSetWithCharactersInString:fourthTone];
}

+(BOOL)isWordWithToneMarksValid:(NSString*)word
{
    __block BOOL toneFound = NO;
    __block BOOL end = NO;
    
    [self forEveryCharacterInString:word do:^(unichar character, BOOL *stop) {
        if([[self firstTones] characterIsMember:character] || [[self secondTones] characterIsMember:character] || [[self thirdTones] characterIsMember:character] || [[self fourthTones] characterIsMember:character])
        {
            if (toneFound) {
                end = YES;
                *stop = YES;
            }
            
            toneFound = YES;
        }
    }];
    
    return !end;
}

+(NSInteger)getToneForWordWithToneMarks:(NSString*)word
{
    __block NSInteger toneToReturn = TONE_NEUTRAL;
    
    [self forEveryCharacterInString:word do:^(unichar character, BOOL *stop) {
        if ([[self firstTones] characterIsMember:character]) {
            toneToReturn = TONE_1;
        }
        else if([[self secondTones] characterIsMember:character])
        {
            toneToReturn = TONE_2;
        }
        else if([[self thirdTones] characterIsMember:character])
        {
            toneToReturn = TONE_3;
        }
        else if([[self fourthTones] characterIsMember:character])
        {
            toneToReturn = TONE_4;
        }
        
        if (toneToReturn != TONE_NEUTRAL)
            *stop = YES;
        
    }];
    
    return toneToReturn;
}

+(BOOL)isPossibleToGetColoringForCharacters:(NSString*)characters pinyin:(NSString*)pinyin
{
    return [self validateWord:characters pinyin:pinyin];
}

+(BOOL)doesPinyinContainToneMarks:(NSString*)pinyin
{
    NSString *allTones = @"āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ";
    return [self doesStringContainCharacters:pinyin characters:allTones];
}

+(BOOL)isCharacterToneWithMark:(unichar)character
{
    NSString *allTones = @"āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ";
    NSCharacterSet *allTonesCharacterSet = [NSCharacterSet characterSetWithCharactersInString:allTones];
    return [allTonesCharacterSet characterIsMember:character];
}

+(BOOL)stringContainMultipleWhiteSpacesInRow:(NSString*)string
{
    BOOL lastCharWasWhiteSpace = NO;
    for (int i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (character == ' ') {
            if (lastCharWasWhiteSpace) {
                return YES;
            }
            else
            {
                lastCharWasWhiteSpace = YES;
            }
        }
        else
        {
            lastCharWasWhiteSpace = NO;
        }
    }
    
    return NO;
}

+(BOOL)validateWordWithToneMarksCharacters:(NSString*)characters pinyin:(NSString*)pinyin
{
    NSString *allowedCharacters = @"āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    if ([self doesStringContainIllegalCharacters:pinyin allowedCharacters:allowedCharacters])
        return NO;
    
    // Look for better solution
    if([self stringContainMultipleWhiteSpacesInRow:pinyin])
        return NO;
    
    NSArray *individualWords = [pinyin componentsSeparatedByString:@" "];
    NSUInteger toneCount = individualWords.count;
    
    for (NSString *word in individualWords) {
        if (![self isWordWithToneMarksValid:word]) {
            return NO;
        }
    }
    
    if (toneCount != characters.length) {
        return NO;
    }
    
    return YES;
}




+(BOOL)validateWord:(NSString*)characters pinyin:(NSString*)pinyin
{
    
    if(characters.length == 0 || pinyin.length == 0)
        return NO;

    
    if ([self validateWordWithToneMarksCharacters:characters pinyin:pinyin]) {
        return YES;
    }
    
    // Check for illegal characters
    NSString *lettersAnd4 = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234 ";
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:lettersAnd4];
    
    if ([pinyin rangeOfCharacterFromSet:validChars.invertedSet].location != NSNotFound) {
        return NO;
    }
    
    
    __block BOOL lastToneWasNumeric = NO;
    __block BOOL nextShouldNotBeTone = NO;
    __block NSUInteger numberOfTones = 0;
    __block BOOL shouldStop = NO;
    
    [self forEveryCharacterInString:pinyin do:^(unichar character, BOOL *stop) {
        if ([self isCharacterTone:character]) {
            if (nextShouldNotBeTone && !lastToneWasNumeric) {
                shouldStop = YES;
                *stop = YES;
            }
            
            if(!nextShouldNotBeTone)
                numberOfTones++;
            
            nextShouldNotBeTone = YES;
            
            if([self isCharacterNumericTone:character])
                lastToneWasNumeric = YES;
            else
                lastToneWasNumeric = NO;
        }
        else
        {
            nextShouldNotBeTone = NO;
            lastToneWasNumeric = NO;
        }

    }];
    
    if (shouldStop)
        return NO;
    
    
    unichar lastChar = [pinyin characterAtIndex:pinyin.length-1];
    if (![self isCharacterTone:lastChar]) {
        numberOfTones++;
    }
    
    if(numberOfTones != characters.length)
        return NO;
    
    return YES;
}

@end
