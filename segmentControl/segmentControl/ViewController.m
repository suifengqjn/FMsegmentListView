//
//  ViewController.m
//  segmentControl
//
//  Created by qianjn on 16/8/1.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "ViewController.h"
#import "FMsegmentListView.h"
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *testLabel1 = [[UILabel alloc] init];
    testLabel1.frame = CGRectMake(20, 100, 200, 20);
    testLabel1.text = @"this is 1 test label";
    testLabel1.textColor = [UIColor redColor];
    testLabel1.backgroundColor = [UIColor grayColor];

    UILabel *testLabel2 = [[UILabel alloc] init];
    testLabel2.frame = CGRectMake(20, 100, 200, 20);
    testLabel2.text = @"this is 2 test label";
    testLabel2.textColor = [UIColor redColor];
    testLabel2.backgroundColor = [UIColor grayColor];
    
    UILabel *testLabel3 = [[UILabel alloc] init];
    testLabel3.frame = CGRectMake(20, 100, 200, 20);
    testLabel3.text = @"this is 3 test label";
    testLabel3.textColor = [UIColor redColor];
    testLabel3.backgroundColor = [UIColor grayColor];
    
    UILabel *testLabel4 = [[UILabel alloc] init];
    testLabel4.frame = CGRectMake(20, 100, 200, 20);
    testLabel4.text = @"this is 4 test label";
    testLabel4.textColor = [UIColor redColor];
    testLabel4.backgroundColor = [UIColor grayColor];
    
    UILabel *testLabel5 = [[UILabel alloc] init];
    testLabel5.frame = CGRectMake(20, 100, 200, 20);
    testLabel5.text = @"this is 5 test label";
    testLabel5.textColor = [UIColor redColor];
    testLabel5.backgroundColor = [UIColor grayColor];
    
    UILabel *testLabel6 = [[UILabel alloc] init];
    testLabel6.frame = CGRectMake(20, 100, 200, 20);
    testLabel6.text = @"this is 6 test label";
    testLabel6.textColor = [UIColor redColor];
    testLabel6.backgroundColor = [UIColor grayColor];
        
    
    
    NSArray *arr = @[
                     @{@"title" : @"for sale", @"view":testLabel1, @"action": @"clickTab:"},
                     @{@"title" : @"seviere", @"view":testLabel2, @"action": @"clickTab:"},
                     @{@"title" : @"following", @"view":testLabel3, @"action": @"clickTab:"},
                     @{@"title" : @"mustgo", @"view":testLabel4, @"action": @"clickTab:"},
                     @{@"title" : @"good", @"view":testLabel5, @"action": @"clickTab:"},
                     @{@"title" : @"other", @"view":testLabel6, @"action": @"clickTab:"}
                    ];
    
    FMsegmentListView *segmentView = [[FMsegmentListView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    segmentView.segmentList = arr;
    [self.view addSubview:segmentView];
    
    
}


- (void)clickTab:(NSNumber *)index
{
    NSLog(@"--%@", index);
}

@end
