//
//  CheckController.h
//  TouchIDTest
//
//  Created by Jion on 16/2/24.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckController : UIViewController
@property (nonatomic,assign)BOOL  on;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);
@end
