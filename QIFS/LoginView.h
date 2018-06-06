//
//  LoginView.h
//  QIFS
//
//  Created by Carmatec on 25/05/18.
//  Copyright © 2018 zsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
