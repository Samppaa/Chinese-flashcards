//
//  Chinese_flashcardsTests.m
//  Chinese flashcardsTests
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Word.h"

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


- (void)testExample {
    Word *word = [[Word alloc] initWithWordText:@"Ni hao" translation:@"Hello" pinyin:@"Ni hao" levelKnown:5];
    XCTAssertEqual([word getWordText], @"Ni hao");
    
    Word *word2 = [[Word alloc] initWithString:@"Ni hao:Hello:Ni hao:5"];
    XCTAssertEqual([word2 stringValue], @"Ni hao:Hello:Ni hao:5");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
