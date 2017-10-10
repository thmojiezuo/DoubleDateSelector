//
//  ViewController.m
//  DateSelector
//
//  Created by tenghu on 2017/10/10.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "DateSeleCtor.h"

@interface ViewController ()
{
    UIButton *button;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择时间" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width-200, 50);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (void)buttonClick{
    
    NSString *str = @"2017.10.01-2017.10.10";
    [DateSeleCtor showDateSelectionWithTime:str WithComplete:^(NSString *timeFirst, NSString *timeLast) {
        NSLog(@"%@  %@",timeFirst,timeLast);
        NSString *s = [NSString stringWithFormat:@"%@-%@",timeFirst,timeLast];
        [button setTitle:s forState:UIControlStateNormal];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
