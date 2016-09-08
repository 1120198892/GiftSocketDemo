//
//  livingGiftView.m
//  XiaoChentiku
//
//  Created by erice on 16/7/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#define kGiftWidth  (self.width -60)/[UIScreen mainScreen].scale
#define kGiftHeight 40/[UIScreen mainScreen].scale
#define kcomboWH 50/[UIScreen mainScreen].scale
#define kcomboFont [UIFont boldSystemFontOfSize:30]
#define knormalFont [UIFont boldSystemFontOfSize:25]

#import "livingGiftView.h"
#import "GiftHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
@interface ShakeLabel : UILabel

@property (nonatomic,strong) UIColor *borderColor;

- (void)configuerAnimation:(completeBlock)block;

@end


@implementation ShakeLabel

- (void)configuerAnimation:(completeBlock)block{
 
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.15 animations:^{
            self.transform = CGAffineTransformMakeScale(2,2);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (block) {
               block(finished);
            }
        
        }];
    }];

    
}

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end






@interface livingGiftView ()

@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic, strong) ShakeLabel * comboPoint;
@property (nonatomic,copy) completeBlock completeBlock;


@end


@implementation livingGiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)initView{

     _comboHit = 3;
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.5;
    
    _headImageView = [[UIImageView alloc] init];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.UserImg] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    _giftImageView = [[UIImageView alloc] init];
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:self.model.GiftImg]];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor  = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    
   
    
    _nameLabel.text = self.model.UserName;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _giftLabel = [[UILabel alloc] init];
    _giftLabel.text = [NSString stringWithFormat:@"送一个%@",self.model.GiftName];
    _giftLabel.textColor  = [UIColor yellowColor];
    _giftLabel.font = [UIFont systemFontOfSize:13];
    
 
    _comboPoint =  [[ShakeLabel alloc] init];
    _comboPoint.font = knormalFont;
    _comboPoint.borderColor = [UIColor yellowColor];
    _comboPoint.textColor =[UIColor orangeColor];
    _comboPoint.textAlignment = NSTextAlignmentCenter;
   
    
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_comboPoint];
    
    
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(0,
                                      0,
                                      self.frame.size.height,
                                      self.frame.size.height);
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    
    _giftImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 50,
                                      self.frame.size.height - 50,
                                      50,
                                      50);
    
    _nameLabel.frame = CGRectMake(_headImageView.frame.size.width + 5,
                                  5,
                                  _headImageView.frame.size.width * 3,
                                  10);
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                  CGRectGetMaxY(_headImageView.frame) - 10 - 5,
                                  _nameLabel.frame.size.width,
                                  10);
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    
    _comboPoint.frame = CGRectMake(CGRectGetMaxX(self.frame) + 2,
                                   -20,
                                   [self sizeWithText:_comboPoint.text font:knormalFont constrainedToSize:CGSizeMake(MAXFLOAT, kcomboWH)].width,
                                   kcomboWH);
    
    
    
}


- (CGSize)sizeWithText:(NSString*)text font:(UIFont *)font constrainedToSize:(CGSize)size{
 
    CGSize realSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        realSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    }
    else
    {
        realSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return realSize;
}


- (void)timerHandler:(NSTimer*)timer{
    
    _comboHit--;
    if (_comboHit<=0) {
        [self reset];
    }
}

- (void)reset {
   
    
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.25 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = CGRectMake(0,
                                self.frame.origin.y - 20,
                                self.frame.size.width,
                                self.frame.size.height);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        self.frame = _originFrame;
        self.alpha = 1;
        self.comboPoint.text = @"";
        if (self.completeBlock) {
            self.completeBlock(YES);
        }
        [self removeFromSuperview];
    }];
    
    
}

// 处理连击问题
- (void)doubleHit{
    
    if (self.timer) {
        _comboHit = 5;
        self.model.GiftNum++;
        _comboPoint.text=[NSString stringWithFormat:@"x %ld",(long)self.model.GiftNum];
        [_comboPoint configuerAnimation:^(BOOL finished) {
            
        }];
    }
}

- (void)fir{

    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(0,
                                self.frame.origin.y,
                                self.width,
                                self.height);
        
    } completion:^(BOOL finished) {
        _comboPoint.text=[NSString stringWithFormat:@"x %ld",(long)self.model.GiftNum];
        [_comboPoint configuerAnimation:^(BOOL finished) {
            
        }];
        if (_comboHit<=0) {
            [self reset];
        }
       
    }];
    
}


- (void)animateWithCompleteBlock:(completeBlock)completed{
   
    [self initView];
    [self fir];
    if (completed) {
        self.completeBlock = completed;
    }
    self.backgroundColor=[UIColor clearColor];
}



- (void)dealloc{
    
    self.model = nil;
    self.headImageView =nil;
    self.giftImageView = nil;
    self.nameLabel = nil;
    self.giftLabel = nil;
    self.giftView = nil;
    self.completeBlock = nil;
   
}


@end
