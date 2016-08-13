//
//  ViewController.m
//  ObjcSplines
//
//  Created by 于海涛 on 16/8/13.
//  Copyright © 2016年 于海涛. All rights reserved.
//

#import "ViewController.h"

#import "UpView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageV.image = [UIImage imageNamed:@"Home_refresh_bg"];
    [self.view addSubview:imageV];
    
    UpView * upView1 = [[UpView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    upView1.center = self.view.center;
    upView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:upView1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
