//
//  ZJTouchID.h
//  TouchIDTest
//
//  Created by Jion on 16/2/23.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
@interface ZJTouchID : NSObject

+ (instancetype)shareIntance;

/*
 
 参数说明：
 titleString   输入密码时的提示标题
 weakself   所在的控制器self
 complete 验证输入内容inputPwd，将验证结果以BOOL类型传值给 *isYes.默认值是YES.
 
 */

- (void)alertPasswordViewTitle:(NSString*)titleString  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete;
/*

 参数说明：
 titleString   输入密码时的提示标题
 message    消息内容
 weakself   所在的控制器self
 complete 验证输入内容inputPwd，将验证结果以BOOL类型传值给 *isYes.默认值是YES.
 
 */
- (void)alertPasswordViewTitle:(NSString*)titleString subTitle:(NSString*)message  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete;

/*
 该接口用于支付
 参数说明：
 titleString   输入密码时的提示标题
 message    消息内容
 amount     支付金额
 weakself   所在的控制器self
 complete 验证输入内容inputPwd，将验证结果以BOOL类型传值给 *isYes.默认值是YES.
 
 */

- (void)alertPasswordViewTitle:(NSString*)titleString subTitle:(NSString*)message payTotal:(CGFloat)amount  delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete;

/*
 参数说明：
 titleString   输入密码时的提示标题
 weakself   所在的控制器self
 complete 验证输入内容inputPwd，将验证结果以BOOL类型传值给 *isYes.默认值是YES.
 
 */

- (void)showPasswordViewTitle:(NSString*)titleString delegate:(id)weakself completeHandle:(void (^)(NSString *inputPwd,BOOL *isYes))complete;



/********************************/

/*******************TouchID使用时的方法*************************/

/********************************/

/*
 参数说明：
 fallbackTitle 按钮标题的显示，默认nil时是输入密码，如要隐藏该按钮设置为空字符@“”
 weakself   所在的控制器self
 successCode 指纹验证成功后在此block中要做的操作
 action 在fallbackTitle不为空字符@“”时要做的操作。
 errorCode 指纹验证失败返回code,并在此block中做需要的操作
 */
+ (void)touchIDWithFallbackTitle:(NSString*)fallbackTitle delegate:(id)weakself success:(void(^)(void))successCode handlerAction:(void(^)(void))actionCode errorCode:(void(^)( NSError *error))errorCode;


/*
 参数说明：
 weakself   所在的控制器self
 successCode 指纹验证成功后在此block中要做的操作
 errorCode 指纹验证失败返回code,并在此block中做需要的操作
 */
+ (void)touchIDWithDelegate:(id)weakself success:(void(^)(void))successCode errorCode:(void(^)( NSError *error))errorCode;
/*
 参数说明：
 weakself   所在的控制器self
 successCode 指纹验证成功后在此block中要做的操作
 */

+ (void)touchIDWithDelegate:(id)weakself success:(void(^)(void))successCode;


@end
