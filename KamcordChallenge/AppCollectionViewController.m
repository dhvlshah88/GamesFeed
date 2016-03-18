//
//  ViewController.m
//  KamcordChallenge
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "AppCollectionViewController.h"
#import "AppCollectionViewCell.h"
#import "AppDataUtil.h"

#define kImage_Request_Cache_Limit 100
#define kIpadAppJsonLimit 30
#define kIphoneAppJsonLimit 20

static NSString * const kAppCollectionViewCellIdentifier = @"kAppCollectionViewCellIdentifier";
static NSString * kamcordUrlString = @"https://app.staging.kamcord.com/app/v3/games?count=%d";
static const CGFloat kGamesCellViewPadding = 10.0;

@interface AppCollectionViewController () {
    NSURLSession *_session;
}

@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) NSMutableArray *listOfAppData;
@property (nonatomic, strong) NSMutableString *nextPageValue;
@property (nonatomic, strong) NSCache *appImageCache;
@property (nonatomic) NSInteger appDataLimit;

@end

@implementation AppCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        _appImageCache = [[NSCache alloc] init];
        [self.appImageCache setCountLimit:kImage_Request_Cache_Limit];
        self.appDataLimit = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? kIpadAppJsonLimit : kIphoneAppJsonLimit;
        _listOfAppData = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewFlowLayout.minimumInteritemSpacing = kGamesCellViewPadding;
    self.collectionViewFlowLayout.minimumLineSpacing = kGamesCellViewPadding;
    
    _appDataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
    self.appDataCollectionView.dataSource = self;
    self.appDataCollectionView.delegate = self;
    self.appDataCollectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.appDataCollectionView registerClass:[AppCollectionViewCell class] forCellWithReuseIdentifier:kAppCollectionViewCellIdentifier];
    self.appDataCollectionView.contentInset = UIEdgeInsetsMake(kGamesCellViewPadding, kGamesCellViewPadding, kGamesCellViewPadding, kGamesCellViewPadding);
    [self.appDataCollectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.appDataCollectionView];
    
    NSMutableArray *collectionViewConstraints = [NSMutableArray new];
    [collectionViewConstraints addObject:[NSLayoutConstraint  constraintWithItem:self.appDataCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [collectionViewConstraints addObject:[NSLayoutConstraint  constraintWithItem:self.appDataCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint  constraintWithItem:self.appDataCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [collectionViewConstraints addObject:widthConstraint];
    NSLayoutConstraint *heightConstraint =[NSLayoutConstraint  constraintWithItem:self.appDataCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [collectionViewConstraints addObject:heightConstraint];
    [NSLayoutConstraint activateConstraints:collectionViewConstraints];
    
    [self downloadAppDataJSON:[NSString stringWithFormat:kamcordUrlString, self.appDataLimit]];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat cellWidth, cellHeight;
    
    UIDevice *device = [UIDevice currentDevice];
    if (device.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cellWidth = (screenWidth - (6 * kGamesCellViewPadding)) / 5;
        cellHeight = (screenHeight - (5 * kGamesCellViewPadding)) / 5;
    } else {
        cellWidth = (screenWidth - (4 * kGamesCellViewPadding)) / 3;
        cellHeight = (screenHeight - (4 * kGamesCellViewPadding)) / 4;
    }
    
    self.collectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session invalidateAndCancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.session invalidateAndCancel];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AppData *selectedAppData = self.listOfAppData[indexPath.row];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:selectedAppData.appName
                                          message:[NSString stringWithFormat:NSLocalizedString(@"You've selected %@, game with game_id: %@", nil), selectedAppData.appName, selectedAppData.appId]
                                          preferredStyle:UIAlertControllerStyleAlert
                                          ];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listOfAppData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppCollectionViewCell *appCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAppCollectionViewCellIdentifier forIndexPath:indexPath];
    appCell.layer.shouldRasterize = YES;
    appCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    AppData *data = self.listOfAppData[indexPath.row];
    appCell.appNameLabel.text = data.appName;
    appCell.appImageView.image = nil;

    NSURL *imageUrl = [NSURL URLWithString:data.appIconUrlString];
    if ([self.appImageCache objectForKey:data.appId]) {
        //Use image from cache.
        UIImage *appImage = [self.appImageCache objectForKey:data.appId];
        appCell.appImageView.image = appImage;
    } else {
        //Download image if not present already in image cache.
        [[self.session downloadTaskWithURL:imageUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
              if (!error) {
                  UIImage *appImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:location]];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                      [self.appImageCache setObject:appImage forKey:data.appId];
                      appCell.appImageView.image = appImage;
                  });
              } else {
                  NSLog(@"Error: %@", error);
              }
          }] resume];
    }

    return appCell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //download next page json only if collection view is scrolled to end.
    if (self.appDataCollectionView.frame.size.height >= scrollView.contentSize.height - scrollView.contentOffset.y) {
        NSMutableString *nextPageURLString = [NSMutableString new];
        [nextPageURLString appendString:[NSString stringWithFormat:kamcordUrlString, self.appDataLimit]];
        [nextPageURLString appendFormat:@"&page=%@", self.nextPageValue];
        //    NSLog(@"%@", nextPageURLString);
        
        [self downloadAppDataJSON:nextPageURLString];
    }
}

#pragma mark Private method

// NSURLSession for two tasks 1) downloading json and 2)downloading image.
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        [sessionConfiguration setHTTPAdditionalHeaders:@{@"device-token": @"abc123"}];
        sessionConfiguration.timeoutIntervalForRequest = 20.0;
        sessionConfiguration.timeoutIntervalForResource = 60.0;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 2;
        [sessionConfiguration setAllowsCellularAccess:YES];
    
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 2;
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:operationQueue];
    }
    
    return _session;
}

// Method to download json from url provided.
- (void)downloadAppDataJSON:(NSString *)urlString {
    NSURL *jsonURL = [[NSURL alloc] initWithString:urlString];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[self.session dataTaskWithURL:jsonURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                NSError *jsonError;
                NSDictionary *jsonObj = [NSJSONSerialization
                                         JSONObjectWithData:data
                                         options:NSJSONReadingMutableContainers
                                         error:&jsonError
                                         ];
                
                if (!jsonError) {
                    NSDictionary *response = jsonObj[@"response"];
                    NSArray *cardModels = response[@"card_models"];
                    self.nextPageValue = response[@"next_page"];
                    [self.listOfAppData addObjectsFromArray:[AppDataUtil listOfAppData:cardModels]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [self.appDataCollectionView reloadData];
                    });
                }
            }
        }
    }] resume];
}




@end
