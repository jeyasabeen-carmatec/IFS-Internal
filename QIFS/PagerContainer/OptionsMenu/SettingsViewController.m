//
//  SettingsViewController.m
//  QIFS
//
//  Created by zylog on 15/08/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIButton *buttonAbout;
@property (nonatomic, weak) IBOutlet UIButton *buttonUserGuide;



@property (nonatomic, weak) IBOutlet UIButton *buttonHelp;
@property (nonatomic, weak) IBOutlet UIButton *buttonRate;
@property (nonatomic, weak) IBOutlet UISwitch *switchEnglish;
@property (nonatomic, weak) IBOutlet UISwitch *switchArabic;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Settings", @"Settings")];
    
    _buttonAbout.layer.cornerRadius = 3;
    _buttonAbout.layer.masksToBounds = YES;
    _buttonUserGuide.layer.cornerRadius = 3;
    _buttonUserGuide.layer.masksToBounds = YES;
    _buttonHelp.layer.cornerRadius = 3;
    _buttonHelp.layer.masksToBounds = YES;
    _buttonRate.layer.cornerRadius = 3;
    _buttonRate.layer.masksToBounds = YES;
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [_switchEnglish setOn:NO animated:YES];
        [_switchArabic setOn:YES animated:YES];
    }
    else {
        [_switchEnglish setOn:YES animated:YES];
        [_switchArabic setOn:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - Button actions

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchEnglishLanguage:(id)sender {
//    [GlobalShare setSelectedLanguage:ENGLSIH_LANGUAGE];
    [_switchArabic setOn:!_switchEnglish.on animated:YES];
////    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [LanguageManager saveLanguageByIndex:0];
//    [self reloadRootViewController];
    
    [self showLanguageAlertView:ENGLSIH_LANGUAGE :CHANGE_ENGLISH];
}

- (IBAction)switchArabicLanguage:(id)sender {
//    [GlobalShare setSelectedLanguage:ARABIC_LANGUAGE];
    [_switchEnglish setOn:!_switchArabic.on animated:YES];
////    [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [LanguageManager saveLanguageByIndex:1];
//    [self reloadRootViewController];
    
    [self showLanguageAlertView:ARABIC_LANGUAGE :CHANGE_ARABIC];
}

- (void)reloadRootViewController {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

- (IBAction)actionAbout:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEB_URL]];
}

- (IBAction)actionRate:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id\(573753324)"]]];
}

#pragma mark - Common actions

- (void)showLanguageAlertView:(NSInteger)intLanguage :(NSString *)strMessage {
    NSString *alertTitle = NSLocalizedString(@"Islamic Financial Securities", @"Basic Alert Style");
    NSString *alertMessage = NSLocalizedString(strMessage, @"BasicAlertMessage");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"NO")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                {
                                    if(intLanguage == ENGLSIH_LANGUAGE) {
                                        [_switchArabic setOn:YES animated:YES];
                                        [_switchEnglish setOn:NO animated:YES];
                                    }
                                    else {
                                        [_switchArabic setOn:NO animated:YES];
                                        [_switchEnglish setOn:YES animated:YES];
                                    }
                                }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"YES")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   if(intLanguage == ENGLSIH_LANGUAGE) {
                                       [GlobalShare setSelectedLanguage:ENGLSIH_LANGUAGE];
                                       [_switchArabic setOn:!_switchEnglish.on animated:YES];
                                       [LanguageManager saveLanguageByIndex:0];
                                   }
                                   else {
                                       [GlobalShare setSelectedLanguage:ARABIC_LANGUAGE];
                                       [_switchEnglish setOn:!_switchArabic.on animated:YES];
                                       [LanguageManager saveLanguageByIndex:1];
                                   }
                                   
                                   [self.navigationController popToRootViewControllerAnimated:NO];
                                   [self reloadRootViewController];

                               }];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }
    else {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
