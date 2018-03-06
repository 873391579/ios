//
//  SettingController.m
//  TouchIDTest
//
//  Created by Jion on 16/2/23.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

#import "SettingController.h"
#import "ZJTouchID.h"
#import "CheckController.h"
@interface SettingController ()

@property (weak, nonatomic) IBOutlet UISwitch *swich;

@end

@implementation SettingController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *storeDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userArr = [storeDefaults objectForKey:@"userData"];
    _swich.on = [[[userArr firstObject] objectForKey:@"touchID"] boolValue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
   
    
}
- (IBAction)touchIDSetting:(UISwitch*)sender {
    
    [ZJTouchID touchIDWithDelegate:self success:^{
        [self performSegueWithIdentifier:@"ToCheck" sender:sender];
       
    } errorCode:^(NSError *error) {
        [sender setOn:!sender.on animated:YES];
    }];
    
}
- (IBAction)loginoutAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UISwitch *swich = (UISwitch*)sender;
    CheckController *check =(CheckController*)[segue destinationViewController];
    check.on = swich.on;
}


@end
