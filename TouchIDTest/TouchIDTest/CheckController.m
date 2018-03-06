//
//  CheckController.m
//  TouchIDTest
//
//  Created by Jion on 16/2/24.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "CheckController.h"
#import "ZJTouchID.h"
#define Title_Height 50
#define PWDView_Width ([UIScreen mainScreen].bounds.size.width-40)
#define PWD_Count 6
#define Spots_Width 10
#define Keyboard_Height 216
#define Key_view_distance 100
#define Alert_Height 200
#define Top_Distance 120
@interface CheckController ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *passwordView, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@end

@implementation CheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[ZJTouchID shareIntance] showPasswordViewTitle:@"请输入登录密码，以验证身份" delegate:self completeHandle:^(NSString *inputPwd, BOOL *isYes) {
        *isYes = [self checkPassword:inputPwd];
        if (*isYes) {
            
             [self saveSettings:_on];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

#pragma mark--判断密码是否正确
-(BOOL)checkPassword:(NSString*)pdw
{
    NSUserDefaults *storeDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArr = [storeDefaults objectForKey:@"userData"];
    NSString *password = [[userArr firstObject] objectForKey:@"password"];
    if ([password isEqualToString:pdw]) {
        return YES;
    }
    //    else{
    //         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码输入有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //            [self setDarkSpotsWithCount:0];
    //        }]];
    //        [self presentViewController:alert animated:YES completion:^{
    //
    //        }];
    //        return NO;
    //    }
    return NO;
}

- (void)saveSettings:(BOOL)sender
{
    NSUserDefaults *storeDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArr = [storeDefaults objectForKey:@"userData"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userArr firstObject]];
    [dic setObject:[NSNumber numberWithBool:sender] forKey:@"touchID"];
    
    [storeDefaults setValue:[NSArray arrayWithObject:dic] forKey:@"userData"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//以下代码已经被封装。
/*
- (void)drawView
{
    _passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, Top_Distance, PWDView_Width, PWDView_Width/6+Title_Height)];
    [self.view addSubview:_passwordView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, PWDView_Width, Title_Height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text= @"请输入登录密码，以验证身份";
    [_passwordView addSubview:_titleLabel];
    
    _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _passwordView.frame.size.height-(PWDView_Width)/6, PWDView_Width, PWDView_Width/6)];
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderWidth = 0.5f;
    _inputView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    [_passwordView addSubview:_inputView];
    
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _pwdTextField.hidden = YES;
    _pwdTextField.delegate = self;
    _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_pwdTextField becomeFirstResponder];
    [_inputView addSubview:_pwdTextField];
    
    CGFloat width = _inputView.bounds.size.width/PWD_Count;
    for (int i = 0; i < PWD_Count; i ++) {
        UILabel *spots = [[UILabel alloc]initWithFrame:CGRectMake((width-Spots_Width)/2.f + i*width, (_inputView.bounds.size.height-Spots_Width)/2.f, Spots_Width, Spots_Width)];
        spots.backgroundColor = [UIColor blackColor];
        spots.layer.cornerRadius = Spots_Width/2.;
        spots.clipsToBounds = YES;
        spots.hidden = YES;
        [_inputView addSubview:spots];
        [pwdIndicatorArr addObject:spots];
        
        if (i == PWD_Count-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, 0.5f, _inputView.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        [_inputView addSubview:line];
    }
    
    
}


#pragma mark--TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"---%@",textField.text);
    if (textField.text.length >= PWD_Count && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    //使用正则判断是否为数字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    
    
    
    NSString *totalString;
    if (string.length <= 0) {
        
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    NSLog(@"_____total %@",totalString);
    if (totalString.length<=PWD_Count) {
        [self setDarkSpotsWithCount:totalString.length];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码输入有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self setDarkSpotsWithCount:0];
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    
    if (totalString.length == PWD_Count) {
        if (_completeHandle) {
            
            _completeHandle(totalString);
        }
        if ([self checkPassword:totalString]) {
            [self saveSettings:_on];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            textField.text = nil;
        }
        
    }
    
    return YES;
}
- (void)setDarkSpotsWithCount:(NSInteger)count {
    for (UILabel *darkSpot in pwdIndicatorArr) {
        darkSpot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}
*/
@end
