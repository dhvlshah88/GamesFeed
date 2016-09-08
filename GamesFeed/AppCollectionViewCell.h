//
//  GamesCollectionViewCell.h
//  GamesFeed
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"

@interface AppCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UIImageView *appImageView;
@property (nonatomic, readonly, strong) UILabel *appNameLabel;

@end
