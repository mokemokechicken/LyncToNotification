//
//  LyncToNotificationExtension.h
//  LyncToNotification
//
//  Created by 森下 健 on 2012/09/29.
//  Copyright (c) 2012年 森下 健. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Definitions From Lync
struct CFString {
    void **_vptr$CFObject;
    struct __CFString *mCFRef;
    _Bool mIsMutable;
};

struct TextStyle {
    short tsFont;
    unsigned char tsFace;
    short tsSize;
    struct RGBColor tsColor;
};

struct DTextStyle {
    void **_field1;
    struct TextStyle _field2;
};

struct BInstantMessage {
    void **_field1;
    struct CFString _field2;
    unsigned short *_field3;
    struct DTextStyle _field4;
    struct BUser *_field5;
    struct BChat *_field6;
};

struct LStr255 {
    void **_vptr$LString;
    char *mStringPtr;
    void *mCompareFunc;
    unsigned short mMaxBytes;
    unsigned char mString[256];
};

struct DEmailAddress {
    struct LStr255 m_stUserName;
    struct LStr255 m_stDomain;
    unsigned short m_wstzEmailLowercase[256];
    struct CFString m_strEmail;
    unsigned char m_bShouldValidate;
};

struct BUser {
    void **_field1;
    struct DEmailAddress _field2;
    unsigned short _field3[257];
    unsigned int _field4;
    struct __CFArray *_field5;
    struct __CFArray *_field6;
    int _field7;
    unsigned char _field8;
    unsigned int _field9;
    double _field10;
    struct BUserPropertyMap *_field11;
    int _field12;
    unsigned long long _field13;
    struct CFString _field14;
    struct CFString _field15;
    struct LStr255 _field16;
    struct LStr255 _field17;
    int _field18;
    unsigned char _field19;
    struct CFString _field20;
    int _field21;
    _Bool _field22;
    struct CFString _field23;
    NSImage *_field24;
    NSImage *_field25;
};


#pragma mark - NSObject(LyncToNotificationExtension)
@interface NSObject(LyncToNotificationExtension)
- (void)IncrementBadgeLyncToNotificationExtension;
- (void)ReceiveMessageLyncToNotificationExtension:(const struct BInstantMessage *)arg1;
@end


@interface LyncToNotificationExtensionUserNotificationDelegate : NSObject
<NSUserNotificationCenterDelegate>
{
    NSString *userName;
    NSString *message;
}
@property (retain) NSString *userName;
@property (retain) NSString *message;
@end



