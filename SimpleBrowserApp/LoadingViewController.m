//
//  LoadingViewController.m
//  CitrixSimpleBrowser
//
//  Created by junkang on 1/3/24.
//  Copyright © 2024. Cloud Software Group, Inc. All rights reserved. Confidential & Proprietary.
//

#import "LoadingViewController.h"

const CGFloat yOffset = 30.0;

@interface LoadingViewController ()

@property(nonatomic, copy) NSString *message;
@property (nonatomic, strong) UILabel *loadingLabel;

@end

@implementation LoadingViewController

- (instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    if (self)
    {
        _message = [message copy];
    }
    return self;
}

- (void)createAndLayoutSubviews
{
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.loadingLabel.center = self.view.center;
    if (self.message != nil) {
        self.loadingLabel.text = self.message;
    } else {
        self.loadingLabel.text = @"loading...";
    }
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loadingLabel];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createAndLayoutSubviews];
}

@end

