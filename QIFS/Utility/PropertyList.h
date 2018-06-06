//
//  PropertyList.h
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#ifndef PropertyList_h
#define PropertyList_h

#define ENGLSIH_LANGUAGE    1
#define ARABIC_LANGUAGE     2
#define AUTO_SYNC_INTERVAL  3

#define WEB_URL @"http://islamicbroker.biz/english/index.html"

#define webSite_Url @"https://www.islamicbroker.com.qa/"

//UATPUBLIC
#define REQUEST_URL @"http://212.77.209.101/OrderManagerWebAPI/WebAPI/"

//UATPRIVATE
//#define REQUEST_URL @"http://192.168.28.79/OrderManagerWebAPI/WebAPI/"

//PRODUCTION
//#define REQUEST_URL @"http://212.77.209.102/OrderManagerWebAPI/WebAPI/"

//#define INTERNET_CONNECTION @"No internet connection. Please try again later."
//#define USERNAME @"Please enter the User Name."
//#define PASSWORD @"Please enter the Password."
//#define SESSION_EXPIRED @"Your Session has expired."
//#define INVALID_HEADER @"Invalid Header."
//#define INVALID_TOKEN @"Invalid Login Token."
//
////#define REPASSWORD @"Please enter the Retype Password."
//#define ACCOUNT_NUMBER @"Please enter the NIN Number."
////#define ACCOUNT_NUMBER_VALID @"Account Number must be at least 10 characters."
//#define PASSWORD_VALID @"Password must be at least 6 characters."
////#define REPASSWORD_MISMATCH @"Retype Password mismatched."
////#define FIRSTNAME @"Please enter the First Name."
////#define LASTNAME @"Please enter the Last Name."
//#define MOBILE_NUMBER @"Please enter the Registered Mobile Number."
////#define MOBILE_NUMBER_VALID @"Mobile number must be numeric."
//#define EMAIL @"Please enter the Email address."
//#define EMAIL_VALID @"Please enter the valid Email address."
////#define REGISTER_TERMS @"Terms & Conditions."
////#define REGISTER_SUCCESS @"Registered successfully."
////#define REGISTER_FAILED @"Unable to register the user. Please try again."
//
//#define CHANGE_NEW_PASSWORD @"Please enter the New Password."
//#define CHANGE_CONFIRM_PASSWORD @"Please enter the Confirm Password."
//#define CHANGE_PASSWORD_MISMATCH @"Password mismatched."
//#define CHANGE_PASSWORD_SUCCESS @"Password changed successfully."
//
//#define FORGOT_PASSWORD_SUCCESS @"A verification code has been sent to the registered mobile number successfully."
//#define FORGOT_PASSWORD_OTP @"Please enter the OTP below."
//
//#define NEWORDER_SECURITY @"Please select a Symbol/Company Name from search."
//#define NEWORDER_TRANSACTION @"Please select a Transaction Type."
//#define NEWORDER_ORDERTYPE @"Please select an Order Type."
//#define NEWORDER_DURATION @"Please select a Duration Type."
//#define NEWORDER_PRICE @"Please enter the Limit Price."
//#define NEWORDER_VALIDPRICE @"Please enter a valid Limit Price."
////#define NEWORDER_LIMITUPPRICE @"Limit Price should not be greater than Limit Up Price."
////#define NEWORDER_LIMITDOWNPRICE @"Limit Price should not be lesser than Limit Down Price."
//#define NEWORDER_QTY @"Please enter the Quantity."
//#define NEWORDER_DISCLOSEDQTY @"Please enter the Disclosed Qty."
//#define NEWORDER_DISCLOSEDQTYVAL @"Disclosed order Qty should not exceed the original Qty."
//#define NEWORDER_BUYINGCASH @"You don’t have enough Cash."
//#define NEWORDER_NOTENOUGHAVAILQTY @"Quantity is not available."
//
//#define CANCEL_ORDER_CONFIRM @"Are you sure want to cancel the order?"
//#define CANCEL_ORDER_SUCCESS @"Order Cancelled Successfully."
//#define FAVORITES_ADD @"You have added this to your Favorites."
//#define FAVORITES_REMOVE @"You have removed this from your Favorites."
//
//#define CALCULATOR_CASH @"Please enter the Cash Amount."
//#define CALCULATOR_VALIDCASH @"Please enter a valid Cash Amount."
//#define CALCULATOR_SHARE @"Please enter the Share Price."
//#define CALCULATOR_VALIDSHARE @"Please enter a valid Share Price."
//#define CALCULATOR_SHARES @"Please enter the No. of Shares."
//
//#define ORDERCONFIRM_CREATE_SUCCESS @"Order created successfully."
//#define ORDERCONFIRM_MODIFY_SUCCESS @"Order modified successfully."
//#define CHART_DATA_UNAVAILABLE @"No chart data available."
//#define NEWORDER_ORG_QTY @"Please enter original Qty."
//#define NEWORDER_LIMITLESSVALID @"Limit should be less than"
//#define NEWORDER_LIMITGREATERVALID @"and greater than"


#define INTERNET_CONNECTION             NSLocalizedString(@"INTERNET_CONNECTION", @"INTERNET_CONNECTION")
#define USERNAME                        NSLocalizedString(@"USERNAME", @"USERNAME")
#define PASSWORD                        NSLocalizedString(@"PASSWORD", @"PASSWORD")
#define SESSION_EXPIRED                 NSLocalizedString(@"SESSION_EXPIRED", @"SESSION_EXPIRED")
#define INVALID_HEADER                  NSLocalizedString(@"INVALID_HEADER", @"INVALID_HEADER")
#define INVALID_TOKEN                   NSLocalizedString(@"INVALID_TOKEN", @"INVALID_TOKEN")

#define REPASSWORD                      NSLocalizedString(@"REPASSWORD", @"REPASSWORD")
#define ACCOUNT_NUMBER                  NSLocalizedString(@"ACCOUNT_NUMBER", @"ACCOUNT_NUMBER")
#define ACCOUNT_NUMBER_VALID            NSLocalizedString(@"ACCOUNT_NUMBER_VALID", @"ACCOUNT_NUMBER_VALID")
#define PASSWORD_VALID                  NSLocalizedString(@"PASSWORD_VALID", @"PASSWORD_VALID")
#define REPASSWORD_MISMATCH             NSLocalizedString(@"REPASSWORD_MISMATCH", @"REPASSWORD_MISMATCH")
#define FIRSTNAME                       NSLocalizedString(@"FIRSTNAME", @"FIRSTNAME")
#define LASTNAME                        NSLocalizedString(@"LASTNAME", @"LASTNAME")
#define MOBILE_NUMBER                   NSLocalizedString(@"MOBILE_NUMBER", @"MOBILE_NUMBER")
#define MOBILE_NUMBER_VALID             NSLocalizedString(@"MOBILE_NUMBER_VALID", @"MOBILE_NUMBER_VALID")
#define EMAIL                           NSLocalizedString(@"EMAIL", @"EMAIL")
#define EMAIL_VALID                     NSLocalizedString(@"EMAIL_VALID", @"EMAIL_VALID")
#define REGISTER_TERMS                  NSLocalizedString(@"REGISTER_TERMS", @"REGISTER_TERMS")
#define REGISTER_SUCCESS                NSLocalizedString(@"REGISTER_SUCCESS", @"REGISTER_SUCCESS")
#define REGISTER_FAILED                 NSLocalizedString(@"REGISTER_FAILED", @"REGISTER_FAILED")

#define CHANGE_NEW_PASSWORD             NSLocalizedString(@"CHANGE_NEW_PASSWORD", @"CHANGE_NEW_PASSWORD")
#define CHANGE_CONFIRM_PASSWORD         NSLocalizedString(@"CHANGE_CONFIRM_PASSWORD", @"CHANGE_CONFIRM_PASSWORD")
#define CHANGE_PASSWORD_MISMATCH        NSLocalizedString(@"CHANGE_PASSWORD_MISMATCH", @"CHANGE_PASSWORD_MISMATCH")
#define CHANGE_PASSWORD_SUCCESS         NSLocalizedString(@"CHANGE_PASSWORD_SUCCESS", @"CHANGE_PASSWORD_SUCCESS")

#define FORGOT_PASSWORD_SUCCESS         NSLocalizedString(@"FORGOT_PASSWORD_SUCCESS", @"FORGOT_PASSWORD_SUCCESS")
#define FORGOT_PASSWORD_OTP             NSLocalizedString(@"FORGOT_PASSWORD_OTP", @"FORGOT_PASSWORD_OTP")

#define NEWORDER_SECURITY               NSLocalizedString(@"NEWORDER_SECURITY", @"NEWORDER_SECURITY")
#define NEWORDER_TRANSACTION            NSLocalizedString(@"NEWORDER_TRANSACTION", @"NEWORDER_TRANSACTION")
#define NEWORDER_ORDERTYPE              NSLocalizedString(@"NEWORDER_ORDERTYPE", @"NEWORDER_ORDERTYPE")
#define NEWORDER_DURATION               NSLocalizedString(@"NEWORDER_DURATION", @"NEWORDER_DURATION")
#define NEWORDER_PRICE                  NSLocalizedString(@"NEWORDER_PRICE", @"NEWORDER_PRICE")
#define NEWORDER_VALIDPRICE             NSLocalizedString(@"NEWORDER_VALIDPRICE", @"NEWORDER_VALIDPRICE")
#define NEWORDER_LIMITUPPRICE           NSLocalizedString(@"NEWORDER_LIMITUPPRICE", @"NEWORDER_LIMITUPPRICE")
#define NEWORDER_LIMITDOWNPRICE         NSLocalizedString(@"NEWORDER_LIMITDOWNPRICE", @"NEWORDER_LIMITDOWNPRICE")
#define NEWORDER_QTY                    NSLocalizedString(@"NEWORDER_QTY", @"NEWORDER_QTY")
#define NEWORDER_DISCLOSEDQTY           NSLocalizedString(@"NEWORDER_DISCLOSEDQTY", @"NEWORDER_DISCLOSEDQTY")
#define NEWORDER_DISCLOSEDQTYVAL        NSLocalizedString(@"NEWORDER_DISCLOSEDQTYVAL", @"NEWORDER_DISCLOSEDQTYVAL")
#define NEWORDER_BUYINGCASH             NSLocalizedString(@"NEWORDER_BUYINGCASH", @"NEWORDER_BUYINGCASH")
#define NEWORDER_NOTENOUGHAVAILQTY      NSLocalizedString(@"NEWORDER_NOTENOUGHAVAILQTY", @"NEWORDER_NOTENOUGHAVAILQTY")

#define CANCEL_ORDER_CONFIRM            NSLocalizedString(@"CANCEL_ORDER_CONFIRM", @"CANCEL_ORDER_CONFIRM")
#define CANCEL_ORDER_SUCCESS            NSLocalizedString(@"CANCEL_ORDER_SUCCESS", @"CANCEL_ORDER_SUCCESS")
#define FAVORITES_ADD                   NSLocalizedString(@"FAVORITES_ADD", @"FAVORITES_ADD")
#define FAVORITES_REMOVE                NSLocalizedString(@"FAVORITES_REMOVE", @"FAVORITES_REMOVE")

#define CALCULATOR_CASH                 NSLocalizedString(@"CALCULATOR_CASH", @"CALCULATOR_CASH")
#define CALCULATOR_VALIDCASH            NSLocalizedString(@"CALCULATOR_VALIDCASH", @"CALCULATOR_VALIDCASH")
#define CALCULATOR_SHARE                NSLocalizedString(@"CALCULATOR_SHARE", @"CALCULATOR_SHARE")
#define CALCULATOR_VALIDSHARE           NSLocalizedString(@"CALCULATOR_VALIDSHARE", @"CALCULATOR_VALIDSHARE")
#define CALCULATOR_SHARES               NSLocalizedString(@"CALCULATOR_SHARES", @"CALCULATOR_SHARES")

#define ORDERCONFIRM_CREATE_SUCCESS     NSLocalizedString(@"ORDERCONFIRM_CREATE_SUCCESS", @"ORDERCONFIRM_CREATE_SUCCESS")
#define ORDERCONFIRM_MODIFY_SUCCESS     NSLocalizedString(@"ORDERCONFIRM_MODIFY_SUCCESS", @"ORDERCONFIRM_MODIFY_SUCCESS")
#define CHART_DATA_UNAVAILABLE          NSLocalizedString(@"CHART_DATA_UNAVAILABLE", @"CHART_DATA_UNAVAILABLE")
#define NEWORDER_ORG_QTY                NSLocalizedString(@"NEWORDER_ORG_QTY", @"NEWORDER_ORG_QTY")
#define NEWORDER_LIMITLESSVALID         NSLocalizedString(@"NEWORDER_LIMITLESSVALID", @"NEWORDER_LIMITLESSVALID")
#define NEWORDER_LIMITGREATERVALID      NSLocalizedString(@"NEWORDER_LIMITGREATERVALID", @"NEWORDER_LIMITGREATERVALID")

#define SIGNOUT_CONFIRMATION            NSLocalizedString(@"SIGNOUT_CONFIRMATION", @"SIGNOUT_CONFIRMATION")
#define CHANGE_ARABIC                   NSLocalizedString(@"CHANGE_ARABIC", @"CHANGE_ARABIC")
#define CHANGE_ENGLISH                  NSLocalizedString(@"CHANGE_ENGLISH", @"CHANGE_ENGLISH")
#define CHECK_AMOUNT                  NSLocalizedString(@"NOT ENOUGH CASH", @"NOT ENOUGH CASH")
#define SIGNIN_CONFIRMATION            NSLocalizedString(@"SIGNIN_CONFIRMATION", @"SIGNIN_CONFIRMATION")


#endif /* PropertyList_h */
