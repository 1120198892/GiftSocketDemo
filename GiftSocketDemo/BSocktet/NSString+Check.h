//
//  NSString+Check.h
//  框架
//
//  Created by mayanwei on 14-9-2.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

- (id)JSONObject;

+ (NSString *)checkNullValueForString:(id)object;
+ (NSString*)removeWhileSpace:(NSString*)orcstring;
@end
