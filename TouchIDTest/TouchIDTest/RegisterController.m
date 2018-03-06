//
//  RegisterController.m
//  TouchIDTest
//
//  Created by Jion on 16/2/23.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerOKAction:(id)sender {
    
    if (![self verificationData]) {
        [self checkName:_nameField.text Password:_passwordField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark--匹配用户
- (void)checkName:(NSString*)name Password:(NSString*)password
{
    NSUserDefaults *storeDefaults = [NSUserDefaults standardUserDefaults];
    if (![storeDefaults objectForKey:@"users"]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [storeDefaults setValue:dictionary forKey:@"users"];
        
    }
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[storeDefaults objectForKey:@"users"]];
    if ([data.allKeys containsObject:name]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"该用户已存在" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    //为了安全的话，可对密码进行MD5加密
    [data setValue:password forKey:name];
    [storeDefaults setValue:data forKey:@"users"];

}

#pragma mark--验证数据
- (BOOL)verificationData
{
    NSString *message = nil;
    if (![_passwordField.text isEqualToString:_repeatPassword.text]) {
        message = @"两次输入密码不同";
    }
    if (_repeatPassword.text.length!=6) {
        message = @"确认密码不正确";
    }
    
    if (_passwordField.text.length!=6) {
        message = @"请输入6位密码";
    }
    if (_nameField.text.length==0) {
        message = @"请输入账号";
    }
    
    if (message) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    return message;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
