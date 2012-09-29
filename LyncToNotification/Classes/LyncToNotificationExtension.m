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

static LyncToNotificationExtensionUserNotificationDelegate *delegate = nil;

@implementation NSObject(LyncToNotificationExtension)
+ (void)load
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    Class class = objc_getClass("IMWindowController");
    [class swizzleMethod:@selector(IncrementBadge)
              withMethod:@selector(IncrementBadgeLyncToNotificationExtension)];
    
    [class swizzleMethod:@selector(ReceiveMessage:)
              withMethod:@selector(ReceiveMessageLyncToNotificationExtension:)];
    
    [class swizzleMethod:@selector(AppendUserUniNotice:inPrefixStrIndex:inSuffixStrIndex:inStyleIndex:inPictID:fInsertUserTile:)
              withMethod:@selector(AppendUserUniNoticeLyncToNotificationExtension:inPrefixStrIndex:inSuffixStrIndex:inStyleIndex:inPictID:fInsertUserTile:)];
    
    [class swizzleMethod:@selector(AppendUserUniNoticeWithCFString:inMessageString:inStyleIndex:inPictID:inAddDivider:pstrHTML:)
              withMethod:@selector(AppendUserUniNoticeWithCFStringLyncToNotificationExtension:inMessageString:inStyleIndex:inPictID:inAddDivider:pstrHTML:)];
    // Don't AutoRelease
    delegate = [[LyncToNotificationExtensionUserNotificationDelegate alloc] init];
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = delegate;
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

- (void)IncrementBadgeLyncToNotificationExtension
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    [self IncrementBadgeLyncToNotificationExtension];
    [self notificate:delegate.userName message:delegate.message];
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

- (void)ReceiveMessageLyncToNotificationExtension:(const struct BInstantMessage *)arg1
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    [self ReceiveMessageLyncToNotificationExtension:arg1];
    NSString *s = (NSString *)arg1->_field2.mCFRef;
    NSLog(@"s=[%@]", s);
    [self logBUser:arg1->_field5];
    // TODO: あっているかわからない
    delegate.userName = s;
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

//- (void)AppendUserUniNoticeLyncToNotificationExtension:(struct BUser *)arg1 inPrefixStrIndex:(short)arg2 inSuffixStrIndex:(short)arg3 inStyleIndex:(short)arg4 inPictID:(short)arg5 fInsertUserTile:(bool)arg6
//{
//    NSLog(@"START %s **********************************************", __FUNCTION__);
//    [self AppendUserUniNoticeLyncToNotificationExtension:arg1 inPrefixStrIndex:arg2 inSuffixStrIndex:arg3 inStyleIndex:arg4 inPictID:arg5 fInsertUserTile:arg6];
//    NSLog(@"END %s **********************************************", __FUNCTION__);
//}

// どうやら警告系のメッセージのときに呼ばれるようだ
- (void)AppendUserUniNoticeWithCFStringLyncToNotificationExtension:(const struct BUser *)arg1 inMessageString:(struct __CFString *)arg2 inStyleIndex:(short)arg3 inPictID:(short)arg4 inAddDivider:(bool)arg5 pstrHTML:(const struct CFString *)arg6
{
    NSLog(@"START %s **********************************************", __FUNCTION__);
    [self AppendUserUniNoticeWithCFStringLyncToNotificationExtension:arg1 inMessageString:arg2 inStyleIndex:arg3 inPictID:arg4 inAddDivider:arg5 pstrHTML:arg6];
    NSString *str2 = (NSString *)arg2;
    NSLog(@"str2=[%@]", str2);
    [self logBUser:arg1];
    [self notificate:@"who?" message:str2];
    NSLog(@"END %s **********************************************", __FUNCTION__);
}

- (void)logBUser:(const struct BUser *)buser
{
    NSString *s14 = (NSString *)buser->_field14.mCFRef;
    NSString *s15 = (NSString *)buser->_field15.mCFRef;
    NSString *s20 = (NSString *)buser->_field20.mCFRef;
    NSString *s23 = (NSString *)buser->_field23.mCFRef;
    NSLog(@"BUser: s14=[%@], s15=[%@], s20=[%@], s23=[%@]", s14, s15, s20, s23);
}

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

