//
//  LoginView.m
//  QIFS
//
//  Created by Carmatec on 25/05/18.
//  Copyright © 2018 zsl. All rights reserved.
//

#import "LoginView.h"
#import "GlobalShare.h"

@implementation LoginView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // UserName TF
    self.userNameTF.borderStyle = UITextBorderStyleLine;
    self.userNameTF.layer.borderWidth = 1;
    self.userNameTF.layer.borderColor = self.viewTitle.backgroundColor.CGColor;
    //self.userNameTF.delegate = self;
    
    // PasswordTF
    self.passwordTF.borderStyle = UITextBorderStyleLine;
    self.passwordTF.layer.borderWidth = 1;
    self.passwordTF.layer.borderColor = self.viewTitle.backgroundColor.CGColor;
    /* if(globalShare.myLanguage == ARABIC_LANGUAGE)
     [textField setTextAlignment:NSTextAlignmentRight];
     else
     [textField setTextAlignment:NSTextAlignmentLeft];
     }*/
    
    
    
    
    //self.passwordTF.delegate = self;
    
   // self.viewTitle.text = NSLocalizedStringFromTable(@"qbQ-u3-Gmd.text", @"LoginView", @"");
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   
}
@end
