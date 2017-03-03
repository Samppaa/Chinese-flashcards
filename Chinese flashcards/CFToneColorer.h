//
//  CFToneColorer.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 20.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

enum
{
    TONE_NEUTRAL = 0,
    TONE_1,
    TONE_2,
    TONE_3,
    TONE_4
};

@interface CFToneColorer : NSObject


+(NSAttributedString*)getColoredString:(NSString*)pinyin characters:(NSString*)characters;
+(NSArray*)parseColorsFromPinyin:(NSString*)pinyin;
+(NSArray*)parseColorsFromPinyinWithNumberedTones:(NSString*)pinyin;
+(NSArray*)parseColorsFromPinyinWithToneMarks:(NSString*)pinyin;
+(BOOL)doesStringContainIllegalCharacters:(NSString*)string allowedCharacters:(NSString*)allowedCharacters;
+(BOOL)doesStringContainCharacters:(NSString*)string characters:(NSString*)characters;
+(BOOL)validateWord:(NSString*)characters pinyin:(NSString*)pinyin;
+(BOOL)validateWordWithToneMarksCharacters:(NSString*)characters pinyin:(NSString*)pinyin;
+(BOOL)isCharacterTone:(unichar)character;
+(BOOL)isCharacterNumericTone:(unichar)character;
+(BOOL)isCharacterToneWithMark:(unichar)character;
+(BOOL)stringContainMultipleWhiteSpacesInRow:(NSString*)string;
+(BOOL)isPossibleToGetColoringForCharacters:(NSString*)characters pinyin:(NSString*)pinyin;
+(BOOL)doesPinyinContainToneMarks:(NSString*)pinyin;
+(BOOL)isWordWithToneMarksValid:(NSString*)word;
+(NSInteger)getToneForWordWithToneMarks:(NSString*)word;

+(NSCharacterSet*)firstTones;
+(NSCharacterSet*)secondTones;
+(NSCharacterSet*)thirdTones;
+(NSCharacterSet*)fourthTones;

+(NSArray*)getColorsForTones;
+(void)forEveryCharacterInString:(NSString*)string do:(void (^) (unichar character, BOOL *stop))handleCharacter;

@end
