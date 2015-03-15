//
//  SampleModel.m
//  JsonDataToModel-ReactiveCocoa
//
//  Created by yye on 3/15/15.
//  Copyright (c) 2015 Yukui Ye. All rights reserved.
//

#import "SampleModel.h"

@implementation SampleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"iconImage": @"icon",
             @"url": @"url",
             };
}

@end
