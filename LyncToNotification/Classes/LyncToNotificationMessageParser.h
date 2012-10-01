//
//  LyncToNotificationMessageParser.h
//  LyncToNotification
//
//  Created by 森下 健 on 2012/10/01.
//  Copyright (c) 2012年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyncToNotificationMessageParser : NSObject
<NSXMLParserDelegate>
{
    NSMutableString *_message;
}
- (NSString *)parseMessage:(NSString *)message;
@end
