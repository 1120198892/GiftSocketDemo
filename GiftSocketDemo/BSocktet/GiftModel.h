//
//  GiftModel.h
//  XiaoChentiku
//
//  Created by erice on 16/7/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property (nonatomic, strong) NSString* UserId;
@property (nonatomic, strong) NSString* UserName;
@property (nonatomic, strong) NSString* UserImg;
@property (nonatomic, strong) NSString* GiftId;
@property (nonatomic, strong) NSString* GiftName;
@property (nonatomic, strong) NSString* GiftImg;
@property (nonatomic, assign) NSInteger GiftNum;
@property (nonatomic, strong) NSString* TeacherId;




/*
@property (nonatomic,strong) UIImage *headImage; // 头像
@property (nonatomic,strong) UIImage *giftImage; // 礼物
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic, strong) NSString*headImgUrl;
@property (nonatomic, strong) NSString*giftImgUrl;
*/


@end
