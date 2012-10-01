//
//  LyncToNotificationMessageParser.m
//  LyncToNotification
//
//  Created by 森下 健 on 2012/10/01.
//  Copyright (c) 2012年 森下 健. All rights reserved.
//

#import "LyncToNotificationMessageParser.h"

@interface LyncToNotificationMessageParser()
@property (retain) NSMutableString *message;
@end

@implementation LyncToNotificationMessageParser
@synthesize message=_message;

- (NSString *)parseMessage:(NSString *)message
{
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:[message dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    parser.delegate = self;
    [parser parse];
    return [NSString stringWithString:self.message];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.message = [NSMutableString string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.message appendString:string];
}
@end
