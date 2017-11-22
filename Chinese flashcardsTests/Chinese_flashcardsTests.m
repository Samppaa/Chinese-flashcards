//
//  Chinese_flashcardsTests.m
//  Chinese flashcardsTests
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Word.h"
#import "CFToneColorer.h"

@interface Chinese_flashcardsTests : XCTestCase

@end

@implementation Chinese_flashcardsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testToneColoring {
    BOOL isGoodPinyin1 = [CFToneColorer validateWord:@"你好" pinyin:@"ni2hao3"];
    XCTAssertEqual(isGoodPinyin1, YES);
    BOOL isGoodPinyin2 = [CFToneColorer validateWord:@"你好" pinyin:@"ni2hao3hao1"];
    XCTAssertEqual(isGoodPinyin2, NO);
    BOOL isGoodPinyin3 = [CFToneColorer validateWord:@"中国国民党" pinyin:@"zhong1guo2guo2min2dang4"];
    XCTAssertEqual(isGoodPinyin3, YES);
    BOOL isGoodPinyin4 = [CFToneColorer validateWord:@"中国国民党" pinyin:@"zhong1guo2guo min dang4"];
    XCTAssertEqual(isGoodPinyin4, YES);
    BOOL isGoodPinyin5 = [CFToneColorer validateWord:@"我们" pinyin:@"wo3men"];
    XCTAssertEqual(isGoodPinyin5, YES);
    BOOL isGoodPinyin6 = [CFToneColorer validateWord:@"现在" pinyin:@"xian4 zai4"];
    XCTAssertEqual(isGoodPinyin6, YES);
}



@end
