//
//  LyncToNotificationTest.m
//  LyncToNotificationTest
//
//  Created by 森下 健 on 2012/10/01.
//  Copyright (c) 2012年 森下 健. All rights reserved.
//

#import "LyncToNotificationMessageParserTest.h"

@implementation LyncToNotificationMessageParserTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testParse
{
    LyncToNotificationMessageParser *parser = [[[LyncToNotificationMessageParser alloc] init] autorelease];
    NSString *message = @"<a><DIV attr=\"value\">これは実&#x5b9f;という字でした 3 &gt; 2</DIV></a>";
    NSString *ret = [parser parseMessage:message];
    STAssertEqualObjects(@"これは実実という字でした 3 > 2", ret, nil);
}

@end
