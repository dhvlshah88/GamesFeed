//
//  GamesCollectionViewCell.m
//  KamcordChallenge
//
//  Created by Dhaval on 3/16/16.
//  Copyright © 2016 Dhaval. All rights reserved.
//

#import "AppCollectionViewCell.h"

@interface AppCollectionViewCell ()

@end

@implementation AppCollectionViewCell

#pragma mark Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _appImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.appImageView];
        [self.appImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.appImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.appImageView.layer.cornerRadius = 16.0;
        self.appImageView.clipsToBounds = YES;
        self.appImageView.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *constraints = [NSMutableArray new];
        //Top constraint
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.appImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
        [constraints addObject:topConstraint];
        
        //center constraint
        NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.appImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [constraints addObject:centerConstraint];
     
        //Width constraint
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.appImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-20.0];
        [constraints addObject:widthConstraint];
        
        //Height constraint
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.appImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.appImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        [constraints addObject:heightConstraint];
        
        _appNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.appNameLabel];
        [self.appNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.appNameLabel.font = [UIFont systemFontOfSize:11.0];
        self.appNameLabel.textColor = [UIColor blackColor];
        self.appNameLabel.textAlignment = NSTextAlignmentCenter;
        self.appNameLabel.numberOfLines = 2;
        
        //Top constraint
        topConstraint = [NSLayoutConstraint constraintWithItem:self.appNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.appImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0];
        [constraints addObject:topConstraint];
        
        //Leading constraint
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.appNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0];
        [constraints addObject:leadingConstraint];
        
        //Trailing constraint
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.appNameLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10.0];
        [constraints addObject:trailingConstraint];
        
        //Bottom constraint
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.appNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0];
        [constraints addObject:bottomConstraint];
        
        //Active constraint
        [NSLayoutConstraint activateConstraints:constraints];
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        self.layer.cornerRadius = 3.0;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.appNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.appNameLabel.bounds);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _appImageView.image = nil;
    _appNameLabel.text = nil;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    return layoutAttributes;
}

@end
