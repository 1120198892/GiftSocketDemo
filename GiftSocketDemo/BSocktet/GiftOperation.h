//
//  GiftOperation.h
//  XiaoChentiku
//
//  Created by erice on 16/7/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "livingGiftView.h"
@interface GiftOperation : NSOperation

@property (nonatomic, strong) UIView * listView;
@property (nonatomic, strong) livingGiftView * giftView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) GiftModel * model;



@end
