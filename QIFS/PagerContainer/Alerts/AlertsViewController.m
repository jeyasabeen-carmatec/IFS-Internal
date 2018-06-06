//
//  AlertsViewController.m
//  QIFS
//
//  Created by zylog on 28/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "AlertsViewController.h"
#import "PendingAlertsCell.h"
#import "ActiveAlertsCell.h"

NSString *const kPendingAlertsCellIdentifier = @"PendingAlertsCell";
NSString *const kActiveAlertsCellIdentifier = @"ActiveAlertsCell";

@interface AlertsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableViewAlerts;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentOption;

@property (strong, nonatomic) NSMutableArray *arrayAlerts1;
@property (strong, nonatomic) NSMutableArray *arrayAlerts2;
@property (strong, nonatomic) UIImageView *normalImageView;
@property (strong, nonatomic) UIView *buttonView;

@end

@implementation AlertsViewController

@synthesize tableViewAlerts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.labelTitle setText:NSLocalizedString(@"Alerts", @"Alerts")];
    self.tableViewAlerts.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.arrayAlerts1 = [[NSMutableArray alloc] init];
    self.arrayAlerts2 = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];

//    [dict1 setValue:@"FB" forKey:@"Symbol"];
//    [dict1 setValue:@"Facebook" forKey:@"Name"];
//    [dict1 setValue:@"This stock is trading now @ 99.00" forKey:@"AlertDescription"];
//    
//    [dict2 setValue:@"GOOGL" forKey:@"Symbol"];
//    [dict2 setValue:@"Google" forKey:@"Name"];
//    [dict2 setValue:@"This stock is trading now @ 579.00" forKey:@"AlertDescription"];

    [dict1 setValue:@"FB" forKey:@"ActiveSymbol"];
    [dict1 setValue:@"Facebook" forKey:@"CompanyName"];
    [dict1 setValue:@"This stock is trading now @ 99.00" forKey:@"AlertDescription"];
    [dict1 setValue:@"Notify me to Buy" forKey:@"AlertNotes"];
    
    [dict2 setValue:@"GOOGL" forKey:@"ActiveSymbol"];
    [dict2 setValue:@"Google" forKey:@"CompanyName"];
    [dict2 setValue:@"This stock is trading now @ 579.00" forKey:@"AlertDescription"];
    [dict2 setValue:@"Notify me to Sell" forKey:@"AlertNotes"];

    [self.arrayAlerts1 addObjectsFromArray:[NSArray arrayWithObjects:dict1, dict2, nil]];
    
    [dict1 setValue:@"GOOGL" forKey:@"Symbol"];
    [dict1 setValue:@"Google Inc" forKey:@"Name"];
    [dict1 setValue:@"566.54" forKey:@"LastPrice"];
    [dict1 setValue:@"580.00" forKey:@"AlertPrice"];
    [dict1 setValue:@">" forKey:@"compare"];
    [dict1 setValue:@"18-07-2016 12:43:49 AM" forKey:@"AlertSetTime"];
    [dict1 setValue:@"Sell" forKey:@"Notes"];
    
    [dict2 setValue:@"AAPL" forKey:@"Symbol"];
    [dict2 setValue:@"Apple" forKey:@"Name"];
    [dict2 setValue:@"96.54" forKey:@"LastPrice"];
    [dict2 setValue:@"95.00" forKey:@"AlertPrice"];
    [dict2 setValue:@"<" forKey:@"compare"];
    [dict2 setValue:@"07-07-2016 09:17:32 AM" forKey:@"AlertSetTime"];
    [dict2 setValue:@"Buy" forKey:@"Notes"];

    [self.arrayAlerts2 addObjectsFromArray:[NSArray arrayWithObjects:dict1, dict2, nil]];

//    self.arrayAlerts1 = @[
//                         @{
//                             @"AlertsTitle": @"FB Price Increased",
//                             @"AlertsDescription": @"FB Price increased to 100.00"
//                             },
//                         @{
//                             @"AlertsTitle": @"GOOGL Price Decreased",
//                             @"AlertsDescription": @"GOOGL Price decreased to 550.00"
//                             }
//                         ];

//    self.arrayAlerts2 = @[
//                          @{
//                              @"AlertsTitle": @"FB Buy",
//                              @"AlertsDescription": @"FB BUY @ LIMIT DOWN 10"
//                              },
//                          @{
//                              @"AlertsTitle": @"GOOGL Sell",
//                              @"AlertsDescription": @"GOOGL Sell @ LIMIT UP 10"
//                              }
//                          ];

    [self setupFloatingButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableViewAlerts reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)actionPhoneCall:(id)sender {
//    NSString *stringTitle = [GlobalShare replaceSpecialCharsFromMobileNumber:@"44498818"];
//    NSString *stringUrl = [NSString stringWithFormat:@"tel://%@", stringTitle];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSearch:(id)sender {

}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAddAlert:(id)sender {

}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    switch (self.segmentOption.selectedSegmentIndex) {
        case 0:
//            self.tableViewAlerts.estimatedRowHeight = 2.0;
//            self.tableViewAlerts.rowHeight = UITableViewAutomaticDimension;

            break;
        case 1:
//            self.tableViewAlerts.estimatedRowHeight = 2.0;
//            self.tableViewAlerts.rowHeight = UITableViewAutomaticDimension;

            break;
        default:
            break;
    }
    [self.tableViewAlerts reloadData];
}

-(void)setupFloatingButton {
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreen mainScreen].bounds.size.height - 44 - 20 - 49, 44, 44);
    _buttonView = [[UIView alloc]initWithFrame:floatFrame];
    _buttonView.backgroundColor = [UIColor clearColor];
    _buttonView.userInteractionEnabled = YES;
    
    _normalImageView = [[UIImageView alloc]initWithFrame:_buttonView.bounds];
    _normalImageView.userInteractionEnabled = YES;
    _normalImageView.contentMode = UIViewContentModeScaleAspectFit;
    _normalImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _normalImageView.layer.shadowRadius = 5.f;
    _normalImageView.layer.shadowOffset = CGSizeMake(-10, -10);
    _normalImageView.image = [UIImage imageNamed:@"icon_favorite_add"];
    
    UITapGestureRecognizer *buttonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [_buttonView addGestureRecognizer:buttonTap];
    
    [_buttonView addSubview:_normalImageView];
    [self.view addSubview:_buttonView];
}

-(void)handleTap:(id)sender //Show Menu
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.normalImageView.transform = CGAffineTransformMakeRotation(0.75);
     }
                     completion:^(BOOL finished)
     {
         AddAlertViewController *addAlertViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAlertViewController"];
         addAlertViewController.delegate = self;
         [self.navigationController presentViewController:addAlertViewController animated:YES completion:nil];
     }];
}

- (void)callBackAlerts:(NSMutableDictionary *)dict {
    [UIView animateWithDuration:0.3 animations:^
     {
         self.normalImageView.transform = CGAffineTransformMakeRotation(0);
     } completion:^(BOOL finished)
     {
     }];
    [self.tableViewAlerts reloadData];
}

- (BOOL)canAutoRotate
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentOption.selectedSegmentIndex == 0)   return [self.arrayAlerts1 count];
    else                return [self.arrayAlerts2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.segmentOption.selectedSegmentIndex == 0) {
        ActiveAlertsCell *cell = (ActiveAlertsCell *) [tableView dequeueReusableCellWithIdentifier:kActiveAlertsCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayAlerts1[indexPath.row];;
        
        cell.labelCompanyName.text = def[@"CompanyName"];
        cell.labelSymbol.text = def[@"ActiveSymbol"];
        cell.labelDescription.text = def[@"AlertDescription"];
        cell.labelNotes.text = def[@"AlertNotes"];

        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        //#if !TEST_USE_MG_DELEGATE
        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        cell.rightSwipeSettings.onlySwipeButtons = NO;
        cell.rightButtons = [self createRightButtons:1];
        //#endif
        
        return cell;
    }
    else  {
        PendingAlertsCell *cell = (PendingAlertsCell *) [tableView dequeueReusableCellWithIdentifier:kPendingAlertsCellIdentifier forIndexPath:indexPath];

        NSDictionary *def = self.arrayAlerts2[indexPath.row];
        
        cell.labelSymbol.text = def[@"Symbol"];
        cell.labelCompanyName.text = def[@"Name"];
        cell.labelLastPrice.text = def[@"LastPrice"];
        cell.labelAlertPrice.text = def[@"AlertPrice"];
        cell.labelCompare.text = def[@"compare"];
        cell.labelAlertDate.text = def[@"AlertSetTime"];
        cell.labelNotes.text = def[@"Notes"];
        
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else
            cell.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        //#if !TEST_USE_MG_DELEGATE
        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        cell.rightSwipeSettings.onlySwipeButtons = NO;
        cell.rightButtons = [self createRightButtons:2];
        //#endif
        
        return cell;
    }
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

#pragma mark - MGSwipeTableCellDelegate

//#if TEST_USE_MG_DELEGATE
-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    if (direction == MGSwipeDirectionLeftToRight) {
        return nil;
    }
    else {
        if(self.segmentOption.selectedSegmentIndex == 0)
            return [self createRightButtons:1];
        else
            return [self createRightButtons:2];
    }
}
//#endif

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    //    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
    //          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if(index == 0) {
        NSIndexPath * path = [self.tableViewAlerts indexPathForCell:cell];
        if(self.segmentOption.selectedSegmentIndex == 0)
            [self.arrayAlerts1 removeObjectAtIndex:path.row];
        else
            [self.arrayAlerts2 removeObjectAtIndex:path.row];

        [self.tableViewAlerts reloadData];
    }
    else {
        AddAlertViewController *addAlertViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAlertViewController"];
        addAlertViewController.delegate = self;
        [self.navigationController presentViewController:addAlertViewController animated:YES completion:nil];
    }
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"Remove", @"Modify"};
    
    UIColor * colors[2] = {[UIColor colorWithRed:220/255.f green:0/255.f blue:2/255.f alpha:1.f], [UIColor colorWithRed:18/255.f green:180/255.f blue:2/255.f alpha:1.f]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
}

@end
