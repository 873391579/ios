//
//  LoginController.h
//  TouchIDTest
//
//  Created by Jion on 16/2/23.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginWayBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraint;

@end
