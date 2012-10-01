//
//  LyncToNotificationExtension.m
//  LyncToNotification
//
//  Created by 森下 健 on 2012/09/29.
//  Copyright (c) 2012年 森下 健. All rights reserved.
//

#import "LyncToNotificationExtension.h"
#import <objc/objc-class.h>
#import "NSObject+Swizzle.h"
#import <Foundation/Foundation.h>
#import "LyncToNotificationMessageParser.h"

static LyncToNotificationExtensionUserNotificationDelegate *delegate = nil;
static LyncToNotificationMessageParser *parser = nil;

@implementation NSObject(LyncToNotificationExtension)
+ (void)load
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    Class class = objc_getClass("IMWindowController");
    [class swizzleMethod:@selector(IncrementBadge)
              withMethod:@selector(IncrementBadgeLyncToNotificationExtension)];
    
    [class swizzleMethod:@selector(ReceiveMessage:)
              withMethod:@selector(ReceiveMessageLyncToNotificationExtension:)];
    
    // Don't AutoRelease
    delegate = [[LyncToNotificationExtensionUserNotificationDelegate alloc] init];
    parser = [[LyncToNotificationMessageParser alloc] init];
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = delegate;
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

- (void)IncrementBadgeLyncToNotificationExtension
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    [self IncrementBadgeLyncToNotificationExtension];
    if (delegate.message) {
        [self notificate:delegate.userName message:delegate.message];
        delegate.message = nil;
    }
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

- (void)ReceiveMessageLyncToNotificationExtension:(const struct BInstantMessage *)arg1
{
    // NSLog(@"START %s **********************************************", __FUNCTION__);
    [self ReceiveMessageLyncToNotificationExtension:arg1];
    NSString *s = (NSString *)arg1->_field2.mCFRef;
    //NSLog(@"s=[%@]", s);
    //[self logBUser:arg1->_field5];
    
    // TODO: I want to retrive user name from struct BUser, but I can't...
    delegate.message = [self retriveText:s];
    // NSLog(@"END %s **********************************************", __FUNCTION__);
}

// 
//- (NSString *)removeTag:(NSString *)message
//{
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</?[^>]*>" options:0 error:&error];
//    NSString *ret = [regex stringByReplacingMatchesInString:message options:0 range:NSMakeRange(0, [message length]) withTemplate:@""];
//    //NSLog(@"removeTag: [%@]", ret);
//    return ret;
//}

- (NSString *)retriveText:(NSString *)message
{
    return [parser parseMessage:message];
}

- (void)logBUser:(const struct BUser *)buser
{
    NSString *s14 = (NSString *)buser->_field14.mCFRef;
    NSString *s15 = (NSString *)buser->_field15.mCFRef;
    NSString *s20 = (NSString *)buser->_field20.mCFRef;
    NSString *s23 = (NSString *)buser->_field23.mCFRef;
    NSLog(@"BUser: s14=[%@], s15=[%@], s20=[%@], s23=[%@]", s14, s15, s20, s23);
}

// Send message to Notification Center.
// 通知センターにメッセージを送ります。
- (void)notificate:(NSString *)userName message:(NSString *)message
{
    NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
    notification.title = @"Message From Lync";
    notification.subtitle = userName;
    notification.informativeText = message;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.hasActionButton = YES;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}
@end


@implementation LyncToNotificationExtensionUserNotificationDelegate
@synthesize message;
@synthesize userName;
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    /// ここをYESにすると、強制的にNotificationを表示するようになる。
    /// Lync WindowがActiveのときにも表示されるようになる。まあ、普通はNOでいいと思う。
    return NO;
}
@end

