//
//  AppData.h
//  GamesFeed
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

@property (nonatomic, readwrite, strong) NSString *appName;
@property (nonatomic, readwrite, strong) NSString *appIconUrlString;
@property (nonatomic, readwrite, strong) NSString *appId;

- (instancetype)initWithCardModel:(NSDictionary *)cardModelDictionary;


@end
