//
//  GiftHelper.h
//  Wantiku
//
//  Created by erice on 16/7/29.
//  Copyright © 2016年 mayw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "livingGiftView.h"
#import "GiftOperation.h"
#import "GiftHelper.h"
#import "GiftModel.h"
@interface GiftHelper : NSObject


+ (instancetype)shared;


@property (nonatomic, strong) NSMutableArray*operations;
@property (nonatomic, strong) NSMutableArray*giftInfos;
@property (nonatomic,strong) NSOperationQueue *queue1;
@property (nonatomic,strong) NSOperationQueue *queue2;

@property (nonatomic, assign) NSInteger giftIndex;


- (void)sendGift2View:(UIView*)toView model:(GiftModel*)giftModel;
- (void)showGiftAnimation:(UIView*)oriView frame:(CGRect)frame imageUrl:(NSString*)imgUrl;

@end
