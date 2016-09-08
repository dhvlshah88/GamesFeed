//
//  ViewController.h
//  GamesFeed
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, readonly, strong) UICollectionView *appDataCollectionView;

@end

