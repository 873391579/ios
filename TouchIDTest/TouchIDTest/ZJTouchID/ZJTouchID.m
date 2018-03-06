//
//  ZJTouchID.m
//  TouchIDTest
//
//  Created by Jion on 16/2/23.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "ZJTouchID.h"

typedef NS_ENUM(NSInteger,Types) {
    shows,
    alerts
};

#define Title_Height 50
#define PWDView_Width ([UIScreen mainScreen].bounds.size.width-40)
#define AlertView_Width ([UIScreen mainScreen].bounds.size.width-80)
#define PWD_Count 6
#define Spots_Width 10
#define Top_Distance 120
#define Offset    15
#define Message_H  20
@interface ZJTouchID()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *passwordView, *inputView ,*bgView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *messageLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic,copy) BOOL (^completeHandle)(NSString *inputPwd);
@property (nonatomic,copy) void (^complete)(NSString *inputPwd,BOOL *isYes);
@property(nonatomic,strong)UIViewController *controller;

@property(nonatomic,assign)Types types;
@end

@implementation ZJTouchID
static ZJTouchID *instance = nil;
+ (instancetype)shareIntance
{

    instance = [[ZJTouchID alloc]init];

    return instance;
}


#pragma mark-----alertView
/*
 alertView方法
 */
- (void)alertPasswordViewTitle:(NSString*)titleString  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete
{
    [self alertPasswordViewTitle:titleString subTitle:nil delegate:weakself completeHandle:^(NSString *inputPwd, BOOL *isYes) {
        complete(inputPwd,isYes);
    }];
}

- (void)alertPasswordViewTitle:(NSString*)titleString subTitle:(NSString*)message  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete

{
    [self alertPasswordViewTitle:titleString subTitle:message payTotal:0 delegate:weakself completeHandle:^(NSString *inputPwd, BOOL *isYes) {
        complete(inputPwd,isYes);
    }];
}

- (void)alertPasswordViewTitle:(NSString*)titleString subTitle:(NSString*)message payTotal:(CGFloat)amount  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete
{
     _complete = complete;
    if (![weakself isKindOfClass:[UIViewController class]])return;
    _controller = weakself;
    _types = alerts;
    
    if (!_passwordView) {
        
        self.titleLabel.text= titleString?titleString:@"提示";
        [self.passwordView addSubview:self.titleLabel];
        
        [self.passwordView addSubview:self.cancleBtn];
        [self.passwordView addSubview:self.line];
        
        if (message && message.length>0) {
           
            [self.passwordView addSubview:self.messageLabel];
            self.messageLabel.text = message;
            _passwordView.bounds = CGRectMake(0, 0, _passwordView.bounds.size.width, _passwordView.bounds.size.height+Message_H+Offset);
            
        }
        
        if (amount>0) {
            [self.passwordView addSubview:self.amountLabel];
            _amountLabel.text = [NSString stringWithFormat:@"￥%.2f  ",amount];
            _passwordView.bounds = CGRectMake(0, 0, _passwordView.bounds.size.width, _passwordView.bounds.size.height+Message_H+Offset);
        }
        
         [self spotsIndicatorArr];
    }

    
}

- (UIButton*)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setFrame:CGRectMake(0, 0, Title_Height, Title_Height)];
        [_cancleBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cancleBtn;
}
//取消
- (void)dismiss {
    
    [_pwdTextField resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        _passwordView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _passwordView.alpha = 0;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [_passwordView removeFromSuperview];
        [_bgView removeFromSuperview];
        _passwordView = nil;
    }];
}

#pragma mark---getter
- (UIView*)passwordView
{
    if (!_passwordView) {
        
        _bgView = [[UIView alloc] init];
        _bgView.frame = [UIScreen mainScreen].bounds;
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController.view addSubview:_bgView];
        
        _passwordView = [[UIView alloc]initWithFrame:CGRectMake(40, Top_Distance, AlertView_Width, AlertView_Width/6+Title_Height+2*Offset)];
        if (_types==alerts) {
            _passwordView.center = CGPointMake(_controller.view.center.x, _controller.view.center.y-64);
        }
        _passwordView.layer.cornerRadius = 5.f;
        _passwordView.layer.masksToBounds = YES;
        _passwordView.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [_bgView addSubview:_passwordView];
        
        _passwordView.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _passwordView.alpha = 0;
        
        
        [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _passwordView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            _passwordView.alpha = 1.0;
        } completion:nil];
        
    }
    return _passwordView;
}

- (UILabel*)line
{
    if (!_line) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, Title_Height, AlertView_Width, .5f)];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UILabel*)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(Offset, Title_Height+Offset, AlertView_Width-2*Offset, 20)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor darkGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}

- (UILabel*)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(Offset, Title_Height*2, AlertView_Width-2*Offset, 25)];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = [UIColor darkGrayColor];
        _amountLabel.font = [UIFont systemFontOfSize:33];
    }
    return _amountLabel;
}


#pragma mark -----showPasswordView
/*
 show方法
 */
- (void)showPasswordViewTitle:(NSString*)titleString delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete
{
     _complete = complete;
    if (![weakself isKindOfClass:[UIViewController class]])return;
    _controller = weakself;
    _types = shows;
    
    if (!_passwordView) {
        _passwordView = [[UIView alloc]initWithFrame:CGRectMake(20, Top_Distance, PWDView_Width, PWDView_Width/6+Title_Height)];
        [_controller.view addSubview:_passwordView];
        
        [_passwordView addSubview:self.titleLabel];
        self.titleLabel.text = titleString;
        
        [self spotsIndicatorArr];
    }
    
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_types==shows? PWDView_Width:AlertView_Width, Title_Height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        if (_types==alerts) {
            _titleLabel.textColor = [UIColor darkGrayColor];
            _titleLabel.font = [UIFont systemFontOfSize:17];
        }
        
    }
    return _titleLabel;
}

/*============================*/
#pragma mark =====Commond Method
#pragma mark-- 密码处理部分
-(void)spotsIndicatorArr
{
    if (_types==alerts) {
        CGFloat y = _passwordView.frame.size.height-(AlertView_Width-2*Offset)/PWD_Count-Offset;
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(Offset, y, AlertView_Width-2*Offset, (AlertView_Width-2*Offset)/PWD_Count)];
        
    }else{
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _passwordView.frame.size.height-(PWDView_Width)/PWD_Count, PWDView_Width, PWDView_Width/PWD_Count)];
    }
    
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderWidth = 0.5f;
    _inputView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
    [_passwordView addSubview:_inputView];
    
    pwdIndicatorArr = [[NSMutableArray alloc]init];
   
    [_inputView addSubview:self.pwdTextField];
    
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
- (UITextField*)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_pwdTextField becomeFirstResponder];
    }
    return _pwdTextField;
}

#pragma mark--TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"text--%@",textField.text);
    if (textField.text.length >= PWD_Count && string.length!=0) {
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
    NSLog(@"total--- %@",totalString);
    if (totalString.length<=PWD_Count) {
        [self setDarkSpotsWithCount:totalString.length];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码输入有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self setDarkSpotsWithCount:0];
        }]];
        [_controller presentViewController:alert animated:YES completion:^{
            
        }];
    }
   if (totalString.length == PWD_Count)
   {
       [self performSelector:@selector(popAction:) withObject:totalString afterDelay:.3f];
   }
    
    return YES;
}

- (void)popAction:(NSString*)totalString
{
    if (totalString.length == PWD_Count) {
        
        BOOL b=YES;
        _complete(totalString,&b);
        if (b) {
            
            [self dismiss];
            
        }else{
            //如果block返回no，则把textField置空
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码输入有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self setDarkSpotsWithCount:0];
                _pwdTextField.text = nil;
            }]];
            [_controller presentViewController:alert animated:YES completion:^{
                
            }];
            
        }
        
    }
 
}

- (void)setDarkSpotsWithCount:(NSInteger)count {
    for (UILabel *darkSpot in pwdIndicatorArr) {
        darkSpot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
        
    }
}


/************************************************/
/*           TouchID                */
/************************************************/
#pragma mark--TouchID Method

+ (void)touchIDWithDelegate:(id)weakself success:(void(^)(void))successCode
{
    [self touchIDWithFallbackTitle:@"" delegate:weakself success:^{
        successCode();
    } handlerAction:^{
        
    } errorCode:^(NSError *error) {
       
    }];
}

+ (void)touchIDWithDelegate:(id)weakself success:(void(^)(void))successCode errorCode:(void(^)( NSError *error))errorCode

{
    [self touchIDWithFallbackTitle:@"" delegate:weakself success:^{
        successCode();
    } handlerAction:^{
        
    } errorCode:^(NSError *error) {
        errorCode(error);
    }];
}


+ (void)touchIDWithFallbackTitle:(NSString*)fallbackTitle delegate:(id)weakself success:(void(^)(void))successCode handlerAction:(void(^)(void))actionCode errorCode:(void(^)( NSError *error))errorCode
{
    //初始化上下文
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = fallbackTitle;
    //错误对象
    NSError *error = nil;
    NSString *reason = @"请验证指纹信息";
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证 reason参数不能为空
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
            
            NSString *message = nil;
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //切换主线程处理
                    successCode();
                    
                        }];
                
//                message = @"验证成功";
                
            }else{
                
                NSLog(@">>>%@",error.localizedDescription);
                
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        message = @"系统取消授权";
                        
                    }
                        
                        break;
                    case LAErrorUserCancel:
                    {
                         message = @"用户取消授权";
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //切换主线程处理
                            errorCode(error);
                        }];
                    }
                       
                        break;
                    case LAErrorAuthenticationFailed:
                    {
                       message = @"授权失败";
                       
                    }
                        
                        break;
                    case LAErrorUserFallback:
                    {
                        message = @"用户选择输入密码";
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //切换主线程处理
                            actionCode();
                        }];
 
                    }
                        
                        break;
                        
                    default:
                        
                    {
                        
                        message = @"操作失败";
                    }
                        break;
                }
                
                if (error.code!=LAErrorUserCancel && error.code!=LAErrorUserFallback) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        errorCode(error);
                       
                    }]];
                    [weakself presentViewController:alert animated:YES completion:^{
                        
                    }];
                }
                
                
            }
            
            
        }];
    }
    else{
        NSString *message = nil;
        //不支持指纹识别
        errorCode(error);
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                message = @"Touch ID不可用 指纹不存在或被删除 在“设置->TouchID与密码”中重新添加指纹";
                break;
            case LAErrorPasscodeNotSet:
                message = @"指纹密码未设置 在“设置->TouchID与密码”中设置";
                break;
                
            case LAErrorTouchIDNotAvailable:
                message = @"Touch ID未设置 在“设置->TouchID与密码”中添加指纹";
                break;
                
            case LAErrorAuthenticationFailed:
                message = @"授权失败";
                break;
                
                
            default:
                break;
        }
        NSLog(@"%@",error.localizedDescription);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            errorCode(error);
        }]];
        [weakself presentViewController:alert animated:YES completion:^{
            
        }];
    }
}



@end
