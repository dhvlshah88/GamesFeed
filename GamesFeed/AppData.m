//
//  AppData.m
//  GamesFeed
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "AppData.h"

static const NSString *kAppKey = @"game";
static const NSString *kAppNameKey = @"name";
static const NSString *kAppIdKey = @"id";
static const NSString *kAppIconKey = @"icons";
static const NSString *kAppIconTypeKey = @"regular";

@implementation AppData

- (instancetype)initWithCardModel:(NSDictionary *)cardModelDictionary {
    if (self = [super init]) {
        NSDictionary *appDetails = cardModelDictionary[kAppKey];
        _appName = appDetails[kAppNameKey];
        _appId = appDetails[kAppIdKey];
        _appIconUrlString = (((NSDictionary *)appDetails[kAppIconKey])[kAppIconTypeKey]);
    }
    return self;
}

#pragma mark NSObject

- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"Name: %@\n", self.appName];
    [string appendFormat:@"Id: %@\n", self.appId];
    [string appendFormat:@"Icon Url: %@\n", self.appIconUrlString];
    return string;
}

@end

