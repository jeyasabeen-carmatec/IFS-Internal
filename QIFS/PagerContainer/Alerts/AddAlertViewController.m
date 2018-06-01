//
//  AddAlertViewController.m
//  QIFS
//
//  Created by zylog on 13/07/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "AddAlertViewController.h"
#import "AppDelegate.h"
#import "SearchStocksCell.h"

@interface AddAlertViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableViewCompany;
@property (nonatomic, weak) IBOutlet UIView *viewCompany;
@property (nonatomic, weak) IBOutlet UIButton *buttonSave;
@property (nonatomic, weak) IBOutlet UIButton *buttonCancel;
@property (nonatomic, weak) IBOutlet UILabel *labelCompany;
@property (nonatomic, weak) IBOutlet UILabel *labelLastPrice;
@property (nonatomic, weak) IBOutlet UITextField *textFieldCompany;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPriceAbove;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPriceBelow;
@property (nonatomic, weak) IBOutlet UITextField *textFieldNotes;
@property (nonatomic, weak) IBOutlet UITextField *textFieldCurrent;

@property (nonatomic, weak) IBOutlet UIButton *buttonRiseAbove;
@property (nonatomic, weak) IBOutlet UIButton *buttonFallBelow;
@property (nonatomic, weak) IBOutlet UIView *viewRiseAbove;
@property (nonatomic, weak) IBOutlet UIView *viewFallBelow;

@property (nonatomic, strong) NSMutableArray *arrayCompany;
@property (nonatomic, strong) NSMutableArray *arrayFilterCompany;
@property (nonatomic, strong) NSString *searchStr;

@end

@implementation AddAlertViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.labelTitle setText:NSLocalizedString(@"Add Alert", @"Add Alert")];
    globalShare = [GlobalShare sharedInstance];
    self.tableViewCompany.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.arrayCompany = [[NSMutableArray alloc] init];
    self.arrayFilterCompany = [[NSMutableArray alloc] init];

    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:@"FB" forKey:@"Symbol"];
    [dict1 setValue:@"Facebook" forKey:@"Name"];
    [dict1 setValue:@"83.38" forKey:@"LastPrice"];
    [self.arrayCompany addObject:dict1];
    
    [dict2 setValue:@"GOOGL" forKey:@"Symbol"];
    [dict2 setValue:@"Google" forKey:@"Name"];
    [dict2 setValue:@"566.24" forKey:@"LastPrice"];
    [self.arrayCompany addObject:dict2];

    [dict3 setValue:@"AAPL" forKey:@"Symbol"];
    [dict3 setValue:@"Apple" forKey:@"Name"];
    [dict3 setValue:@"93.59" forKey:@"LastPrice"];
    [self.arrayCompany addObject:dict3];

    [dict4 setValue:@"CMCSA" forKey:@"Symbol"];
    [dict4 setValue:@"Comcast Corp" forKey:@"Name"];
    [dict4 setValue:@"59.47" forKey:@"LastPrice"];
    [self.arrayCompany addObject:dict4];
    
    _viewCompany.layer.cornerRadius = 3;
    _viewCompany.layer.masksToBounds = YES;
    _viewCompany.layer.borderWidth = 1.0;
    _viewCompany.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewRiseAbove.layer.cornerRadius = 3;
    _viewRiseAbove.layer.masksToBounds = YES;
    _viewRiseAbove.layer.borderWidth = 1.0;
    _viewRiseAbove.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewRiseAbove.backgroundColor = [UIColor clearColor];
    [_buttonRiseAbove setImage:nil forState:UIControlStateNormal];
    
    _viewFallBelow.layer.cornerRadius = 3;
    _viewFallBelow.layer.masksToBounds = YES;
    _viewFallBelow.layer.borderWidth = 1.0;
    _viewFallBelow.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _viewFallBelow.backgroundColor = [UIColor clearColor];
    [_buttonFallBelow setImage:nil forState:UIControlStateNormal];
    
    _textFieldCompany.layer.cornerRadius = 3;
    _textFieldCompany.layer.masksToBounds = YES;
    _textFieldCompany.layer.borderWidth = 1.0;
    _textFieldCompany.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textFieldPriceAbove.layer.cornerRadius = 3;
    _textFieldPriceAbove.layer.masksToBounds = YES;
    _textFieldPriceAbove.layer.borderWidth = 1.0;
    _textFieldPriceAbove.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textFieldPriceBelow.layer.cornerRadius = 3;
    _textFieldPriceBelow.layer.masksToBounds = YES;
    _textFieldPriceBelow.layer.borderWidth = 1.0;
    _textFieldPriceBelow.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textFieldNotes.layer.cornerRadius = 3;
    _textFieldNotes.layer.masksToBounds = YES;
    _textFieldNotes.layer.borderWidth = 1.0;
    _textFieldNotes.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    [_textFieldCompany setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldCompany setLeftView:spacerView1];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    [_textFieldPriceAbove setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldPriceAbove setLeftView:spacerView2];
    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    [_textFieldPriceBelow setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldPriceBelow setLeftView:spacerView3];
    UIView *spacerView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    [_textFieldNotes setLeftViewMode:UITextFieldViewModeAlways];
    [_textFieldNotes setLeftView:spacerView4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSave:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate callBackAlerts:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self.textFieldCurrent resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate callBackAlerts:nil];
}

- (IBAction)backgroundTapped:(id)sender {
    if([self.searchStr length] == 0) {
        [self.labelCompany setText:@""];
        [self.labelLastPrice setText:@""];
    }

    [self.textFieldCurrent resignFirstResponder];
    if(![self.viewCompany isHidden])
        [self.viewCompany setHidden:YES];
}

- (IBAction)actionCheckRiseAbove:(id)sender {
    UIButton *buttonReceive = (UIButton *)sender;
    
    if ([buttonReceive.currentImage isEqual:[UIImage imageNamed:@"icon_tickmark"]]) {
        [buttonReceive setImage:nil forState:UIControlStateNormal];
//        [_viewRiseAbove setBackgroundColor:[UIColor clearColor]];
        _viewRiseAbove.layer.borderWidth = 1.0;
        _viewRiseAbove.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        [self.textFieldPriceAbove setAlpha:0.5];
        [self.textFieldPriceAbove setEnabled:NO];
        [self.textFieldPriceAbove resignFirstResponder];
        [self.textFieldPriceAbove setText:@""];
    }
    else {
        [buttonReceive setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
//        [_viewRiseAbove setBackgroundColor:[UIColor orangeColor]];
        _viewRiseAbove.layer.borderWidth = 1.0;
        _viewRiseAbove.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [self.textFieldPriceAbove setAlpha:1.0];
        [self.textFieldPriceAbove setEnabled:YES];
        [self.textFieldPriceAbove becomeFirstResponder];
    }
}

- (IBAction)actionCheckFallBelow:(id)sender {
    UIButton *buttonReceive = (UIButton *)sender;
    
    if ([buttonReceive.currentImage isEqual:[UIImage imageNamed:@"icon_tickmark"]]) {
        [buttonReceive setImage:nil forState:UIControlStateNormal];
//        [_viewFallBelow setBackgroundColor:[UIColor clearColor]];
        _viewFallBelow.layer.borderWidth = 1.0;
        _viewFallBelow.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        [self.textFieldPriceBelow setAlpha:0.5];
        [self.textFieldPriceBelow setEnabled:NO];
        [self.textFieldPriceBelow resignFirstResponder];
        [self.textFieldPriceBelow setText:@""];
    }
    else {
        [buttonReceive setImage:[UIImage imageNamed:@"icon_tickmark"] forState:UIControlStateNormal];
//        [_viewFallBelow setBackgroundColor:[UIColor orangeColor]];
        _viewFallBelow.layer.borderWidth = 1.0;
        _viewFallBelow.layer.borderColor = [UIColor orangeColor].CGColor;
        
        [self.textFieldPriceBelow setAlpha:1.0];
        [self.textFieldPriceBelow setEnabled:YES];
        [self.textFieldPriceBelow becomeFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayFilterCompany count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *dictVal = [self.arrayFilterCompany objectAtIndex:indexPath.row];

    cell.textLabel.text = dictVal[@"Symbol"];
    cell.detailTextLabel.text = dictVal[@"Name"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if(indexPath.row % 2 == 0)
//        cell.backgroundColor = [UIColor whiteColor];
//    else
//        cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textFieldCurrent resignFirstResponder];
    [_viewCompany setHidden:YES];
    NSMutableDictionary *dictVal = [self.arrayFilterCompany objectAtIndex:indexPath.row];
    [_textFieldCompany setText:dictVal[@"Symbol"]];
    [_labelCompany setText:dictVal[@"Name"]];
    [_labelLastPrice setText:dictVal[@"LastPrice"]];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_textFieldCompany]) [_viewCompany setHidden:YES];
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_textFieldCompany]) {
        if ([string length] == 0) {
            if(range.location == 0) {
                self.searchStr = @"";
            }
            if([self.searchStr length] > 0) {
                NSString *txtString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                self.searchStr = [txtString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else {
            NSString *txtString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            self.searchStr = [txtString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if([self.searchStr length] > 0) {
            NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.Name contains [c] %@ OR self.Symbol contains [c] %@", self.searchStr, self.searchStr];
            NSArray *arrFiltered = [self.arrayCompany filteredArrayUsingPredicate:applePred];
            self.arrayFilterCompany = [NSMutableArray arrayWithArray:arrFiltered];
        }
        else {
            self.arrayFilterCompany = [NSMutableArray arrayWithArray:self.arrayCompany];
        }
        [_tableViewCompany reloadData];
        return YES;
        
    }
//    else if ([textField isEqual:_textFieldPriceAbove] || [textField isEqual:_textFieldPriceBelow]) {
//        NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//        if ([string rangeOfCharacterFromSet:charSet].location != NSNotFound)
//            return NO;
//        else {
//            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//            NSArray *sep = [newString componentsSeparatedByString:@"."];
//            if([sep count] > 2)
//                return NO;
//            else {
//                if([sep count] == 1) {
//                    return YES;
//                }
//                if([sep count] == 2) {
//                    if([[sep objectAtIndex:1] length] > 2)
//                        return NO;
//                }
//                return YES;
//            }
//        }
//    }
    else {
        if (range.location < 15)
            return YES;
        else
            return NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_viewCompany setHidden:YES];
    self.textFieldCurrent = textField;
    if ([textField isEqual:_textFieldNotes]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :100];
        [UIView commitAnimations];
    }
    
    if ([textField isEqual:_textFieldCompany]) {
        if([textField.text length] > 0)
            self.searchStr = textField.text;
        else
            self.searchStr = @"";
        if([self.searchStr length] > 0) {
            NSPredicate *applePred = [NSPredicate predicateWithFormat:@"self.Name contains [c] %@ OR self.Symbol contains [c] %@", self.searchStr, self.searchStr];
            NSArray *arrFiltered = [self.arrayCompany filteredArrayUsingPredicate:applePred];
            self.arrayFilterCompany = [NSMutableArray arrayWithArray:arrFiltered];
        }
        else {
            self.arrayFilterCompany = [NSMutableArray arrayWithArray:self.arrayCompany];
        }
        [_tableViewCompany reloadData];
        [_viewCompany setHidden:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_textFieldCompany] && [self.arrayFilterCompany count] == 0) [_viewCompany setHidden:YES];
    
    if ([textField isEqual:_textFieldNotes]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :100];
        [UIView commitAnimations];
    }
}

@end
