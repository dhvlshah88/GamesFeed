//
//  AppDataUtil.h
//  GamesFeed
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDataUtil : NSObject

//Returns array of app data object from JSON dictionary.
+ (NSMutableArray *)listOfAppData:(NSArray *)cardModels;

@end
