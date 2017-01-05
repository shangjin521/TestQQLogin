//
//  ViewController.m
//  TestQQLogin
//
//  Created by 中软mini049 on 15/10/29.
//  Copyright (c) 2015年 zhongruan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<TencentSessionDelegate>
{
    UIButton *qqLoginBtn;
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
    UILabel *resultLable;
    UILabel *tokenLable;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  1，初始化登陆按钮 添加到当前view中
    qqLoginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    qqLoginBtn.frame=CGRectMake(150, 50, 36, 36);
    [qqLoginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self action:@selector(loginAct) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:qqLoginBtn];
//  2,初始 lable
    resultLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 100, 250, 36)];
    resultLable.font = [UIFont systemFontOfSize:12];
    tokenLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 150, 250, 36)];
    tokenLable.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:resultLable];
    [self.view addSubview:tokenLable];
//  3,初始化TencentOAuth 对象 appid来自应用宝创建的应用， deletegate设置为self  一定记得实现代理方法
    tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"222222" andDelegate:self];
}
//点击登陆按钮
- (void)loginAct{
//    NSLog(@"loginAct");
    [tencentOAuth authorize:permissions inSafari:NO];
}

//登录成功后的回调
- (void)tencentDidLogin{
    resultLable.text = @"登录完成";
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        //记录登录用户的OpenID、Token以及过期时间
        tokenLable.text = tencentOAuth.accessToken;
        //获得QQ的信息
        [tencentOAuth getUserInfo];
    }
    else
    {
        tokenLable.text = @"登录不成功 没有获取accesstoken";
    }
}


// 登录失败后的回调
// \param cancelled 代表用户是否主动退出登录
- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        resultLable.text = @"用户取消登录";
    }else{
        resultLable.text = @"登录失败";
    }
}

// 登录时网络有问题的回调
- (void)tencentDidNotNetWork{
    NSLog(@"tencentDidNotNetWork");
    resultLable.text = @"无网络连接，请设置网络";
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    _nickname.text=[response.jsonResponse objectForKey:@"nickname"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
