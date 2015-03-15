//
//  ServiceManager.m
//  JsonDataToModel-ReactiveCocoa
//
//  Created by yye on 3/15/15.
//  Copyright (c) 2015 Yukui Ye. All rights reserved.
//

#import "ServiceManager.h"

@interface ServiceManager() <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ServiceManager

+ (instancetype)sharedSingleton {
    static ServiceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServiceManager alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sharedSession];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
        
    }] doError:^(NSError *error) {
        NSLog(@"Error: %@",error);
    }];
}

- (RACSignal *)fetchSpecificJsonDataToModel {
//    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric", coordinate.latitude, coordinate.longitude];
//    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURL *url=[NSURL URLWithString:@"https://api.myjson.com/bins/2ukm9"];
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        RACSequence *list = [json[@"casestudies"] rac_sequence];    //YE -> title name of the json list
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[SampleModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

- (RACSignal *)updateDataFromURL {
    return [[self fetchSpecificJsonDataToModel] subscribeNext:^(NSArray *arrayFromURLdata) {
        self.arrayModelData = arrayFromURLdata;
        // [NSKeyedArchiver archiveRootObject:self.arrayModelData toFile:[self pathForAttributesFile]];
    }];
}

@end
