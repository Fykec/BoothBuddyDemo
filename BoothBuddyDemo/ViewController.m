//
//  ViewController.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "ViewController.h"
#import "BarDataManager.h"


@interface ViewController ()
{
    BarDataManager *_dataManager;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dataManager = [[BarDataManager alloc] init];
    [_dataManager startLoadDataIfNeed];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
