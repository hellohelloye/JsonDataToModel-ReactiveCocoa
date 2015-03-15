//
//  SampleModel.h
//  JsonDataToModel-ReactiveCocoa
//
//  Created by yye on 3/15/15.
//  Copyright (c) 2015 Yukui Ye. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SampleModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconImage;
@property (nonatomic, strong) NSString *url;

@end
