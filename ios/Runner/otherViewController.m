//
//  otherViewController.m
//  Runner
//

#import "otherViewController.h"

@interface otherViewController ()

@end

@implementation otherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat safeNum = 0;
    //判断版本
    if (@available(iOS 11.0, *)) {
        //通过系统方法keyWindow来获取safeAreaInsets
        UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
        safeNum = safeArea.top;
    }
    
    
    UIView * topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44 + safeNum);
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    

    
    UIButton * backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, safeNum, 44, 44);
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * middle = [[UILabel alloc] init];
    middle.text = @"Other";
    middle.frame = CGRectMake(0, safeNum, self.view.bounds.size.width, 44);
    middle.textColor = [UIColor whiteColor];
    middle.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:middle];
    
}

-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
