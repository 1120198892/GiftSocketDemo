//
//  BSocket.h
//  GiftSocketDemo
//
//  Created by erice on 16/9/8.
//  Copyright © 2016年 erice. All rights reserved.
//

#ifndef BSocket_h
#define BSocket_h


#import "UIView+Frame.h"
#import "GCDAsyncSocket.h"
#import "GiftHelper.h"
#import "SocketHelper.h"
#import "GiftModel.h"
#import "livingGiftView.h"
#import "GiftOperation.h"
#import "GiftHelper.h"
#import "NSString+Check.h"
#import "NSArray+Shortcuts.h"
#import "NSMutableArray+Shortcuts.h"
#import "NSMutableDictionary+Check.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"


#define kScreenWidth [[UIScreen mainScreen] applicationFrame].size.width
#define kScreenHeight [[UIScreen mainScreen] applicationFrame].size.height



#define DISPATCH_ONCE_CLASS \
static id shared = nil; \
\
+ (instancetype)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
} \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [super allocWithZone:zone]; \
}); \
return shared; \
} \



#endif /* BSocket_h */
