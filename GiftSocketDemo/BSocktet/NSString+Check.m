//
//  NSString+Check.m
//  框架
//
//  Created by mayanwei on 14-9-2.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

+ (NSString *)checkNullValueForString:(id)object
{
    if([object isKindOfClass:[NSNull class]])
	{
		return @"";
	}
	else if(!object)
	{
		return @"";
	}
    else if ([object isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString *)object;
        if ([string isEqualToString:@"(null)"])
        {
            return @"";
        }
        else if ([string isEqualToString:@"null"])
        {
            return @"";
        }
        else
        {
            return [NSString stringWithFormat:@"%@",string];
        }
    }
    else if ([object isKindOfClass:[NSNumber class]])
	{
		return [NSString stringWithFormat:@"%@",object];
	}
    else
    {
        return @"";
    }
}


+ (NSString*)removeWhileSpace:(NSString*)orcstring{

    orcstring = [orcstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    orcstring = [orcstring stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    orcstring = [orcstring stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return orcstring;
}


- (id)JSONObject
{
    return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
}


@end
