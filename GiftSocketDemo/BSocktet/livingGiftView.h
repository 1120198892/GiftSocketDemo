//
//  livingGiftView.h
//  XiaoChentiku
//
//  Created by erice on 16/7/25.
//  Copyright © 2016年 erice. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "GiftModel.h"
typedef NS_ENUM(NSInteger,LivingGiftType){

    LivingGiftTypeFlower,
    LivingGiftTypeZan,
    LivingGiftTypeFlyKiss
    
};

typedef void(^completeBlock)(BOOL finished);

@interface livingGiftView : UIView

@property (nonatomic, strong) GiftModel * model;
@property (nonatomic,strong) UIImageView *headImageView; // 头像
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物
@property (nonatomic,strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic,strong) UILabel *giftLabel; // 礼物名称

@property (nonatomic, strong) UIImageView * giftView;

@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) NSInteger comboHit;



- (void)animateWithCompleteBlock:(completeBlock)completed;
- (void)doubleHit;
- (void)reset;
- (void)comboReset;
@end
