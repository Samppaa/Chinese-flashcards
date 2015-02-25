//
//  Word.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject <NSCopying>

@property(nonatomic, getter=getWordText) NSString *wordText;
@property(nonatomic, getter=getTranslation) NSString *translation;
@property(nonatomic, getter=getPinyin) NSString *pinyin;
@property(nonatomic, assign, getter=getLevelKnown, setter=setLevelKnown:) NSInteger levelKnown;

- (id)initWithWordText:(NSString*)word translation:(NSString*)translationForWord pinyin:(NSString*)pinyinForWord levelKnown:(NSInteger)levelKnowForWord;
-(id)initWithString:(NSString*)string;
-(NSString*)stringValue;


@end
