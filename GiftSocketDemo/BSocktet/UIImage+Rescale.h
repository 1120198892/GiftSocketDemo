//
//  UIImage+Rescale.h
//  Xiu
//
//  Created by mayanwei on 14-10-17.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rescale)

- (UIImage *)rescaleImageToSize:(CGSize)size;

- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
