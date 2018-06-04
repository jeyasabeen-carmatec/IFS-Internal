//
//  ContactUsViewController.m
//  QIFS
//
//  Created by zylog on 23/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MapViewController.h"

@interface ContactUsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIButton *buttonTradeAssistance;
@property (nonatomic, weak) IBOutlet UIButton *buttonTechSupport;
@property (nonatomic, weak) IBOutlet UITextView *textViewContact;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Contact Us", @"Contact Us")];
    [self.textViewContact setText:NSLocalizedString(@"Contact Text", @"Contact Text")];
    [self.buttonTradeAssistance setTitle:NSLocalizedString(@"Phone1", @"Phone1") forState:UIControlStateNormal];
    [self.buttonTechSupport setTitle:NSLocalizedString(@"Phone2", @"Phone2") forState:UIControlStateNormal];

    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.buttonTradeAssistance setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 30)];
        [self.buttonTechSupport setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 30)];
    }
    else {
        [self.buttonTradeAssistance setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.buttonTechSupport setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
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

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionTradingAssistance:(id)sender {
    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"(+974)44498888"];
    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

- (IBAction)actionTechnicalSupport:(id)sender {
    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"(+974)44498824"];
    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
}

- (IBAction)actionOpenMap:(id)sender {
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [[self navigationController] pushViewController:mapViewController animated:YES];
}

@end
