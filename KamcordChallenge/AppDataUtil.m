//
//  AppDataUtil.m
//  KamcordChallenge
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "AppDataUtil.h"
#import "AppData.h"

@implementation AppDataUtil

+ (NSMutableArray *)listOfAppData:(NSArray *)cardModels {
    if (!cardModels || [cardModels count] == 0)
        return nil;
    
    NSMutableArray *listOfAppData = [NSMutableArray new];
    for (NSDictionary *cardModel in cardModels) {
        [listOfAppData addObject:[[AppData alloc] initWithCardModel:cardModel]];
    }
    
    return listOfAppData;
}

@end
