//
//  ViewController.m
//  QIFS
//
//  Created by zylog on 24/06/16.
//  Copyright © 2016 zsl. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "LoginView.h"

@implementation UIView (ShakeAnimation)

- (void)triggerShakeAnimation {
    const int MAX_SHAKES = 6;
    const CGFloat SHAKE_DURATION = 0.05;
    const CGFloat SHAKE_TRANSFORM = 4;
    
    CGFloat direction = 1;
    
    for (int i = 0; i <= MAX_SHAKES; i++) {
        [UIView animateWithDuration:SHAKE_DURATION
                              delay:SHAKE_DURATION * i
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             if (i >= MAX_SHAKES) {
                                 self.transform = CGAffineTransformIdentity;
                             } else {
                                 self.transform = CGAffineTransformMakeTranslation(SHAKE_TRANSFORM * direction, 0);
                             }
                         } completion:nil];
        
        direction *= -1;
    }
}

@end

@interface ViewController () <NSURLSessionDelegate, UITabBarControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUserName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldPassword;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UIButton *buttonLogin;
@property (nonatomic, weak) IBOutlet UIButton *buttonForgotPassword;
@property (nonatomic, weak) IBOutlet UIButton *buttonNewUser;
@property (weak, nonatomic) IBOutlet UIButton *buttonMarketPreview;

@property (nonatomic, strong) UITextField *textFieldCurrent;
@property (weak, nonatomic) IBOutlet UIView *AlertView;

@property (weak, nonatomic) IBOutlet UITextView *textVIewContent;
@property (weak, nonatomic) IBOutlet UIButton *buttonAgree;
@property (weak, nonatomic) IBOutlet UIButton *buttonOverLay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    if (userName == nil ||[userName isEqualToString:@"(null)"]) {
        userName = @"";
    }
    
    _textFieldUserName.text = userName;
    
    globalShare = [GlobalShare sharedInstance];
    [self.labelTitle setText:NSLocalizedString(@"Login", @"Login")];
    
    globalShare.topNavController = self.navigationController;
    NSString *strAgreeStatus = [[NSUserDefaults standardUserDefaults] valueForKey:@"AgrreStatus"];
    self.AlertView.layer.cornerRadius = 10.0f;
    self.textVIewContent.layer.cornerRadius = 10.0f;
    self.AlertView.layer.masksToBounds = YES;
    self.textVIewContent.layer.masksToBounds = YES;

    if(!strAgreeStatus)
    {
        NSString *strTerms = [self settingTheTermsAndConditions];
        self.textVIewContent.text = strTerms;
        self.AlertView.hidden = NO;
   

    }
    else
    {
        self.buttonOverLay.hidden = YES;
        self.AlertView.hidden = YES;
        [self version_API];

    }
    

}

#pragma Button Agree Action

- (IBAction)buttonAgreeAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"Agreed" forKey:@"AgrreStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.AlertView.hidden = YES;
    self.buttonOverLay.hidden = YES;
    [self version_API];


}
#pragma Setting the action

-(NSString *)settingTheTermsAndConditions
{
    NSString *str3 = [NSString stringWithFormat:@"￼￼￼5- The customer may not issue any instructions regarding any securities, if execution of them will result any breach of provisions of memorandum of association and articles of association that issue these securities, provisions of the law, instructions of Qatar Stock Exchange or regulations, laws and rules of Qatar Financial Market Authority, and the customer shall indemnify Islamic Financial Securities Co. (W.W.L) for any demands, damages or losses that may be arisen, or incurred by the company as result of customer’s breach of what is contained in this Agreement."];
    NSMutableArray *Temparr = [[NSMutableArray alloc]init];
    
    Temparr = [NSMutableArray arrayWithObjects:@"1- Disclosure of risks:\nThe customer declares that he is fully aware of nature and requirements of the transaction through the trading securities and that he understands the technical terms used in field of the trading securities and he knows that this transaction involves many risks, which may result in customer’s loss of his capital or part thereof, whereas prices of securities can be increased, however this price can be reduced with high percentage that may causes losses for the customer. Moreover, process of liquidation and sale of the securities is difficult due to the low demand on them, in addition to other many risks that the customer may be exposed to, therefore the trading must be built on scientific bases and with consultant of the specialists and without any responsibility assumed by Islamic Financial Securities Co. (W.W.L), whose role is limited to execute the instructions issued to it by the customer.",@"1- الإفصاح عن المخاطر :￼￼ يقر العميل بأنه على علم تام بطبيعة ومتطلبات التعامل بالتداول فى الأوراق المالية وبأنه يفهم المصطلحات الفنية المستخدمة فى مجال التداول بالأوراق المالية، وبأنه على علم بأن هذا التعامل ينطوي على عدة مخاطر قد تؤدي إلى خسارة العميل لرأس ماله أو جزء منه، فكما أن أسعار الأوراق المالية قابلة للارتفاع فإنه، يمكن لهذه الأسعار أي ًضا أن تنخفض وبنسبة كبيرة، قد تؤدي إلى إلحاق خسائر بالعميل، وكذلك قد تصبحعمليةتسييلالأوراقالماليةوبيعهاصعبةنظًرالانخفاضالطلب عليها، هذا بالإضافة إلى مخاطر أخرى عديدة قد يتعرض لها العميل، لذاينبغيأنيكونالتداولمبنًياعلىأسسعلميةوباستشارةالمختصين، وبدون أي مسؤولية تقع على الشركة الإسلامية للأوراق المالية، والتي يقتصر دورها في تنفيذ التعليمات التي تصلها من العميل.",@"￼2- I hereby authorize the Islamic Financial Securities Co. (W.L.L) (P.O. Box: 12402, Doha – Qatar) to process all sell/ buy Transactions requested by me and to register these transactions in my account. I hereby assume full responsibility for this transaction and without any responsibility assumed by the Islamic Financial Securities Co. (W.L.L)",@"2- أفوض بموجب هذه الاتفاقية الشركة الأسلامية للأوراق المالية (ذ.م.م.)￼￼￼￼ وعنوانها ص. ب: 12402 الدوحة - قطر بإجراء كافة عمليات التداول التي أطلبها من وقت لآخر (بيع/شراء) وقيدها بحسابي لديها وذلك على مسؤوليتي ودون أدني مسؤولية على الشركة الأسلامية للأوراق المالية (ذ.م.م.)",@"￼￼￼3- The customer shall give the company the full details about the deal that he desires to conclude mentioning these details in every amendment, confirmation or order that must comprise the following information clearly: customer name - investor number - transaction type (purchase or sale), and date of execution of it - securities name - securities quantity - sale price or purchase price - order validity period.",@"3- على العميل أن يعطي الشركة التفاصيل الكاملة عن الصفقة التى يرغب￼￼ إبرامها وأن يذكر تلك التفاصيل فى كل تعديل أو تأكيد أو أمر والتي\nيجب أن تتضمن المعلومات التالية بوضوح : اسم العميل - رقم المستثمر - نوع العملية (شراء أو بيع) وتاريخ تنفيذها - اسم الأوراق المالية - كمية\nالأوراق المالية - سعر البيع أو الشراء - مدة صلاحية الأمر.",@"￼4- The customer is obligated to provide the company with all the information that the company requires to verify his identity or appropriateness of his instructions.",@"4- يلتزم العميل بتزويد الشركة بكافة المعلومات التى قد تطلبها للتحقق￼￼ من هويته، أو من صلاحية تعليماته.",str3,@"5- لا يجوز للعميل إصدار أي تعليمات للشركة بخصوص أي أوراق مالية،￼￼ إذا كان تنفيذها سيؤدي إلى مخالفة أحكام عقد التأسيس والنظام الأساسي للشركة المصدرة لتلك الأوراق المالية، أو أحكام القانون أو تعليمات بورصة قطر، أو نظم وقوانين ولوائح هيئة قطر للأسواق المالية، ويقوم العميل بتعويض الشركة عن أي مطالبات أو أضرار أو خسائر قد\nتنشأ أو تتكبدها الشركة، نتيجة لإخلاله بما ورد بهذه الاتفاقية.",@"\n6- If the customer is more than one person; all of those persons are jointly and severally responsible for fulfilment of their obligations arising from this Agreement towards the company.",@"6- فى حال كون العميل أكثر من شخص، كانوا جميعهم مسؤولين بالتضامن￼ والتكافل عن الوفاء بالتزاماتهم المترتبة على هذه الاتفاقية تجاه الشركة.",@"￼￼7- The accounts open in the name of minors or any incompetent person shall be managed by the natural guardian, custodian or the person appointed by the court.",@"\n7-الحساباتالمفتوحةباسمقّصرأوأيأشخاصناقصيالأهلية،تتم￼￼ إدارتها عن طريق ولي الأمر الطبيعي، أو الوصي أو المعين من قبل المحكمة.",@"￼￼￼8-If the minors reach to the legal age, any relationship for management of the account between the minors and guardians or custodians shall be cancelled automatically, and accordingly, when the minor reaches to the legal age he must attend to conclude a new contract, and the company has the right to close the trading on the account until update of it.",@"8-فيحالةبلوغالقاصرالسنالرسمي(القانوني)،تُلغىتلقائًياأيعلاقة￼￼￼ لإدارةالحساببينالقاصرووليالأمرأوالوصي،وبناًءاعليهيجب حضور القاصر بعد بلوغه السن القانونى لعمل عقد جديد، وللشركة\nالحق في وقف التداول على الحساب لحين تحديثه.",@"9- In the case of presence of power of attorney from the customer, whose content is for certain purpose, the power of attorney shall be considered invalid automatically, immediately after expiration of this purpose, and accordingly the customer shall conduct update for his data.",@"9- أي ًضا فى حال وجود توكيل رسمي من العميل، يكون مضمونه غرض￼￼￼ معين،يعتبرالتوكيللاغًياتلقائًيابمجردانقضاءهذاالغرض،وبناًءا عليه يتعين على العميل إجراء تحديث لبياناته.",@"\n10- Execution of orders that I require from Islamic Financial Securities Co. (W.W.L) shall be subject to the conditions and regulations issued by Qatar Stock Exchange and Qatar Financial Market Authority and I declare that I acquainted with them and that I am aware of them. In addition, I declare that the electronic system can be disordered or disrupted or disconnected at any time as result of occurrence of the unexpected accidents for reasons beyond will of Islamic FinancialSecuritiesCo.(W.W.L) orQatarStockExchange.",@"10- يخضع تنفيذ الأوامر التي أطلبها من الشركة الاسلامية للأوراق￼￼￼ المالية (ذ.م.م.) للشروط واللوائح الصادرة عن بورصة قطر وهيئة\nقطر للأسواق المالية، والتي أقر بأنني قد اطلعت عليها وعلى علم بها\nوأقر بأن النظام الإلكتروني قابل للخلل أو التعطيل، أو الانقطاع في أي وقت نتيجة لحوادث غير متوقعة لأسباب خارجة عن إرادة الشركة\nالأسلامية للأوراق المالية (ذ.م.م)، أو بورصة قطر.",@"11- In accordance with the Qatar Exchange rule book, I undertake to pay value of the shares, before the purchase, including the commission due from this deal, and the Islamic Financial Securities Co. shall not be obligated to execute any Purchase Orders, if I fail to cover its value of any of the following:\n - Availability of balance in the trading account that allow to deduct value of the transaction from the account, when the Islamic Financial Securities Co. receives securities of the purchase order and before the execution.\n - Availability of funds, if the amounts due to me from previous Transactions are short to cover value of the Purchase Order.\n - Submission of bank check payable in favour of the company, provided that this check cover value of the shares to be purchased, or submission of personal check, provided that this check shall be collected before completion of the Purchase Order.",@"11- وفقا لقواعد التعامل في بوصة قطر؛ أتعهد بدفع قيمة الأسهم قبل الشراء￼￼ متضمنة العمولة المستحقة عن تلك الصفقة، ويحق للشركة الإسلامية للأوراق المالية (ذ.م.م.) عدم تنفيذ أي عملية شراء مالم أقم بتغطيتها بأي\nمن الحالات التالية: - وجود رصيد بحساب التداول يسمح بحجز أو خصم قيمة العملية من\nالحساب عند استلام الشركة الإسلامية للأوراق المالية أمر الشراء وقبل التنفيذ.\n- وجود مبالغ مستحقة لي من عمليات بيع سابقة كافية لتغطية أمر الشراء. - تقديم شيك مصرفي مصدق ومستحق الدفع لصالح الشركة، على أن يغطي قيمة الأسهم المراد شراؤها، أو شيك شخصي على أن يتم تحصيله\nأو ًلاقبلإتمامعمليةالشراء.",@"￼- Submission of unconditional bank guarantee for the value of the Purchase Order.\n- Giving instructions for customer’s bank regarding the deduction from his account in favour of account of the Islamic Financial Securities Co. (W.W.L).\n- It is agreed upon between two parties of this Agreement that any cash amounts shall not be collected from the customer at company’s office, and the customer must adhere using any of the methods stipulated above.",@"- تقديم كفالة بنكية غير مشروطة بقيمة أمر الشراء.￼￼￼ - إعطاء تعليمات لبنك العميل بالخصم من حسابه لصالح حساب\nالشركة الإسلامية للأوراق المالية (ذ.م.م.) - من المتفق عليه بين طرفي هذه الإتفاقية بأنه لن يتم تحصيل أي مبالغ\nنقدية من العميل بمقر الشركة، ويجب أن يتقيد العميل باستخدام أي من الطرق المنصوص عليها أعلاه.",@"12- Except prepayment condition and based on notice of Qatar Stock Exchange No. (22) dated 09/07/2013, the reliable customers may be exempted from prepayment condition for value of the Purchase Orders, provided that the reimbursement is made during the settlement period and until third day of settlement at most, or when selling the purchased shares, whichever is the earliest, provided that its made with certain conditions and controls.",@"12-استثناًءامنشرطالدفعالمسبق،وبناًءاعلىإشعاربورصةقطررقم￼￼￼ (22) فى 09/07/2013 ، يجوز إعفاء العملاء الموثوق بهم من شرط الدفع المسبق لقيمة عمليات الشراء، على أن يتم السداد خلال فترة\nالتسوية وبحد أقصى اليوم الثالث للتسوية (3+T)، أو عند بيع\nالأسهم المشتراة أيهما أقرب، على أن يتم بشروط وضوابط معينة.",@"\n 13- For the instructions sent via fax, the order coming via fax must be signed by the customer or his authorized signatory representative and original copy of the signed fax must be sent to the company during 3 business days from date of the order, and unless the customer perform any of the mentioned above, the copy received via fax shall be considered as the original copy.",@"13- بالنسبة للتعليمات الموجهة بواسطة الفاكس، يجب أن يكون الطلب￼￼￼￼ الواردبالفاكسموقًعامنالعميل،أومنُممثلهالمخولوالمفوض بالتوقيع، وأن يرسل أصل الفاكس الموقع إلى الشركة خلال 3 أيام عمل من الطلب، وفى حالة عدم قيامه بأي مما سبق فتعتبر الصورة\nالمستلمة بواسطة الفاكس بمثابة الأصل.",@"14- In accordance with Qatar Exchange Instructions, I undertake to authenticate the Sale and Purchase Orders issued by us to the Islamic Financial Securities Company by phone, internet or orally within three days from the date of issuing such orders, otherwise the Islamic Financial Securities Company shall not be responsible in any way whatsoever towards us or others concerning our non- compliance of such undertaking. We understand that such orders are valid and not challengeable in any case.",@"14- وف ًقا لتعليمات بورصة قطر، أتعهد بأن أوثق أوامر البيع أو الشراء￼￼￼ الصادرة مني للشركة الإسلامية للأوراق المالية (ذ.م.م.) بالهاتف أو الإنترنت أو شفاهة، خلال ثلاثة أيام من تاريخ إصدار الأمر، وفي حالة عدم التزامي بذلك لاتكون الشركة الاسلامية للأوراق المالية (ذ.م.م.) مسؤولة، بأي شكل تجاهي أوتجاه الغير إزاء عدم التزامي بهذا التعهد,\nوأقر بأن هذه الأوامر صحيحة وغير قابلة للطعن فيها بأي حال.",@"15- The Islamic Financial Securities Co. is entitled not to execute sale and purchase order unless completed according to the applicable law and regulations of Qatar Exchange and Qatar Financial Market Authority. In addition, Islamic Financial Securities Co. for reasons as deemed legally and appropriate by it, is entitled to suspend the account by serving one week notice.",@"15- يحق للشركة الأسلامية للأوراق المالية (ذ.م.م.) عدم تنفيذ أوامر البيع￼￼￼ / الشراء إذا لم تكن مستوفاة على النحو المطلوب، وفق اللوائح والنظم\nالمعمول بها في بورصة قطر، وهيئة قطر للأسواق المالية، كما يحق لها\nتعليق الحساب شريطة إخطارنا بذلك قبل أسبوع من تاريخ التعليق في\nضوء ما تراه الشركة من مبررات قانونية.",@"￼￼16- Upon receipt of order of the customer in order for conclusion one of the deals, the company shall do its best to execute this order as soon as possible as per rules of transaction in Qatar Stock Exchange in this regard.",@"16- عند استلام أمر من العميل لإبرام إحدى الصفقات، تبذل الشركة￼￼￼￼ قصارى جهدها لتنفيذ ذلك الأمر باسرع وقت ممكن، حسب قواعد\nالتعامل فى بورصة قطر المتعلقة بهذا الشأن .",@"￼￼￼17- All notices and statements sent by the Islamic Financial Securities Co. to the addresses written in this contract through (mail box – email – or approved phone) shall be deemed valid and effective, unless objected in writing within one week from the date of sending it. The Islamic Financial Securities Co. shall not be responsible in case of non-receipt of such notices for any reasons.",@"17- تعتبر كافة الإشعارات وكشوف الحسابات المرسلة من الشركة الإسلامية￼￼ للأوراقالماليةعلىالعناوينالمدونةفيهذاالعقدمنخلال(صندوقالبريد- الإيميل-أوالهاتفالمعتمد)صحيحةونافذة،مالمأعترضعليهاخطًياخلال 15 يوم عمل من تاريخ إرسالها لي، ولاتكون الشركة الاسلامية للأوراق المالية\n(ذ.م.م.) مسؤولة عن عدم استلامي لهذه الإشعارات لأي سبب من الأسباب.￼￼￼1",@"￼18- I undertake to pay all the applicable commission set by the Islamic Financial Securities Co. for the sale and purchase transactions in accordance with Qatar Exchange Rulebook and QFMA in accordance with any amendments thereto. I also agree to pay any fees or other expenses for the other additional services after approval of them by the regulatory authorities.",@"18-أوافقعلىدفعالعمولاتالمحددةلعملياتالبيعوالشراءوفًقالقواعد￼￼￼ التعامل في بورصة قطر وهيئة قطر للأسواق المالية، والحدود التي\nتقر بها، وأيه تعديلات تطرأ عليها مستقب ًلا، كما أوافق على دفع أي \nرسومأومصاريفللخدماتالإضافيةالأخرىبعدإقرارهاأيًضامن\nالجهات الرقابية .",@"￼￼19- The Islamic Financial Securities Co. Is entitled to provide any information related to our account if and when required by the regulatory authorities (Qatar Financial Market Authority – Qatar Stock Exchange – taxes authorities) or Judicial Authorities or any other concerned regulatory authority in State of Qatar or my appointed representative.",@"19-للشركة الإسلامية للأوراق المالية (ذ.م.م.) الحق في الإدلاء بأي￼￼￼ معلومات عن حسابي لديها يتم طلبها من الجهات الرقابية (هيئة قطر للأسواق المالية - بورصة قطر - سلطات الضرائب)، أو الجهات القضائية في دولة قطر، أو أي جهات رقابية أخرى مختصة في دولة\nقطر، وكذلك لأي شخص مفوض كتابة مني.",@"￼￼20- The Islamic Financial Securities Co. Is entitled to amend any of these terms and conditions with the instructions issued from time to time by Qatar Exchange and Qatar Financial Markets Authority or any other concerned Authorities. These amendments shall be binding on me and i agree to them in advance.",@"20- للشركة الإسلامية للأوراق المالية (ذ.م.م.) الحق في تعديل أي من￼￼￼ هذه الشروط والأحكام، وفق النظم والقواعد المعمول بها في بورصة قطر وهيئة قطر للأسواق المالية، أو أي جهة رقابية أخرى معنية،\nوتعتبرتلكالتعديلاتملزمةليوموافقعليهامنطرفيسلًفا.",@"￼￼21- This agreement is subject to the regulations related to investment in Qatar Exchange and Qatar Financial Markets Authority or the supervisory/regulatory authority as decided and determined by Qatari Laws.",@"21- تخضع هذه الاتفاقية الى الأحكام المنظمة للتعامل بالاستثمار في￼￼￼￼ بورصة قطر وهيئة قطر للأسواق المالية، وأي جهة رقابية معنية \nأخرى يقرها القانون القطرى .￼￼￼",@"￼￼￼22- The Islamic Financial Securities Co. Is entitled to end the relationship with the customer in the case of his inability to fulfil requirements of the regulatory authorities with the information on the customer with respect to application of rules of combating money laundering and Financing the Terrorism",@"22- يحق للشركة الإسلامية للأوراق المالية إنهاء العلاقة مع العميل فى￼￼ حالة عدم القدرة على استيفاء متطلبات الجهات الرقابية الخاصة بالمعلومات حول العميل، فيما يتعلق بتطبيق دليل قواعد مكافحة\nغسل الأموال وتمويل الإرهاب .",@"23- Any dispute arising out of or in connection with this agreement relating to securities shall be referred to Arbitration in accordance with the rules of Arbitration of Qatar Financial Market Authority through the Arbitration Panel therein.",@"23- اتفق الطرفان على حل أي نزاع ينشأ عن هذا العقد والتعاملات￼￼￼￼ المتصلةوالمتعلقةبالأوراقالماليةبطريقالتحكيم،وفًقاللأجراءات\nالمتبعة لدى هيئة قطر للأسواق المالية من خلال لجنة التحكيم به",@"24- Notwithstanding any rules and principles of evidence provided in law, proof regarding securities cases may be established by all means of evidence, including the data extracted from computer, telephone, recording, SMS and correspondences dispatched via fax, telex and email.",@"24- اتفقالطرفانعلىأنهوعلىالرغممنأحكاموقواعدالإثباتالمعززةفيأي￼￼￼ قانون، يجوز الإثبات في قضايا الأوراق المالية بجميع طرق الإثبات بما في ذلكالبياناتالصادرةعنالحاسوبوتسجيلاتالهاتفوالرسائلالنصية\n (SMS)،والمراسلاتعبرأجهزةالفاكسوالتلكسوالبريدالالكتروني.",@"25- Both parties have mutually agreed that all the phone calls related to transaction, which the customer performed or intend to perform in the company shall be recorded and kept in a manner accessible at all time, and in accordance with provisions of the second chapter of section seven or article (7.2.8) of Qatar Exchange Rulebook.",@"25- اتفق الطرفان على أن جميع المحادثات الهاتفية المتعلقة بالمعاملات التي￼￼ تتم أو يرغب العميل القيام بها عن طريق الشركة تكون هذه المكالمات مسجلة تسجي ًلا يتم الاحتفاظ به لمدة عشر سنوات، أو للمدة التي يحددها القانون، وذلك للرجوع إليها في أي حال من الأحوال، إضافة\nإلى المراسلات الإلكترونية، وذلك بنا ًءا على أحكام الفصل الثاني من الباب السابع (7.2.8) من قواعد التعامل في بورصة قطر لعام 2015.",@"￼26- Legitimately unaccredited shares:\n  Based on opinion of Sharia Supervisory Board in the company, the customer may sell the legitimately unaccredited shares only for purpose of disposal of them.",@"26-الأسهمغيرالمجازةشرًعا:￼￼￼￼ بناًءاعلىرأيهيئةالرقابةالشرعيةبالشركة،يجوزللعميلبيع الأسهمغيرالمجازةشرعًافقطوذلكبغرضالتخلصمنها.",@"￼￼￼27- I acknowledge and undertake that all information submitted by me herein are true and correct and I shall inform Islamic Financial Securities Co. with any subsequent change or amendment immediately, otherwise, Islamic Financial Securities Co. is exempt from the responsibility.",@"27- أقر وأتعهد بأن كافة البيانات المقدمة صحيحة، وفي حالة تعديلها ألتزم￼￼￼ بإبلاغالشركةالإسلاميةللأوراقالمالية(ذ.م.م.)فو ًراعنأيتعديليطرأ،\nوتنتفي مسؤولية الشركة الإسلامية للأوراق المالية عند عدم إبلاغي له",@"￼￼￼￼Terms and conditions of trading via internet:",@"أحكام وشروط التداول عن طريق الإنترنت :￼￼",@"￼First: definition of service of trading via internet :\n- It is a service provided for the customer by the company, and through this services, the customer can enter and execute the Purchase Order and electronically sale via internet, and in order to enable the customer to use this service efficiently and effectively, he must be widely aware of field of trading in securities as well as the laws and regulations applicable in the financial markets in the State.\n ￼￼- Without prejudice or conflict conditions of this agreement, the company provides, through this agreement, trading services via internet through granting the customer private password that enable him to contact with system of trading via internet, and the orders are sent directly to Qatar Stock Exchange via company’s electronic trading system.  with stipulated terms and",@"أو ًل : تعريف خدمة التداول عبر الإنترنت:￼\n- هي خدمة تقدم للعميل من قبل الشركة والتي من خلالها يستطيع العميل أنيقومبإدخالوتنفيذأوامرالشراءوالبيعإلكترونًياعنطريقالإنترنت, وحتىيتمكنالعميلمناستخدامهذهالخدمةبكفاءةوفاعلية،يتوجبعليه أن يكون على معرفة وإلمام واسع فى مجال التداول بالأوراق المالية، وكذلك\nعلىمعرفةبالأنظمةوالقوانينالمعمولبهافىالأسواقالماليةبالدولة. - دون إخلال أو تعارض مع ما هو منصوص عليه من شروط وأحكام هذه الإتفاقية، توفر الشركة من خلال هذه الاتفاقية خدمات التداول عن طريقالإنترنت،وذلكمنخلالمنحالعميلرق ًماسر ًياخا ًصابهيمكنهمن الاتصال بنظام التداول عبر الإنترنت، ويتم إرسال الأوامر إلى نظام تداول\nبورصةقطرللأوراقالماليةمباشرةعبرنظامالتداولالإلكترونىللشركة",@"￼￼Purchase of securities: the customer is obligated to pay value of the deal, including the commission prescribed for the company in accordance with the method stipulated in Clause No. (11), however, the customer is responsible for all of his orders, including any orders exceeding the limit available in his account, and in the case of completion of the order without availability of the concerned limit in his account, the customer must add the required money in his account in the company as per the method stipulated in Clause (11) of this agreement. - Sale of securities: customer’s account must contain balance of enough free securities before entry of the order.\n  - The customer acknowledges that he is aware of the risks involved in the trading transaction in general as mentioned above, and the risks related to trading via internet and that he alone assumes all the responsibilities arising from his investment from trading via internet.",@"شراء الأوراق المالية: يلتزم العميل في حالة الشراء بدفع قيمة الصفقة شاملة￼ العمولةالمقررةللشركةوف ًقاللكيفيةالمنصوصعليهابالبندرقم(11)،ومع ذلك يكون العميل مسؤول عن كافة أوامره بما فى ذلك أي أوامر تتجاوز الحد المتوفر في حسابه، وفى حالة إنجاز الأمر دون توفر الحد المعني في حسابه، فإنه يتوجب على العميل أن يضيف المال المطلوب فى حسابه لدى الشركة\nبالكيفية المنصوص عليها بالبند (11) من هذه الاتفاقية . - بيع الأوراق المالية : يجب أن يحتوى حساب العميل على رصيد أوراق\nمالية حرة كافية قبل إدخال الأمر . - يقر العميل بأنه على علم بالمخاطر التي تنطوي عليها عملية التداول\nبصفةعامةكماذكرلاحًقا،وعلىالمخاطرالمتعلقةبالتداولعبر الإنترنت، وبأنه يتحمل وحده كافة المسؤوليات المترتبة على استثماره من التداول عبر الإنترنت .",@"Second: there are some risks that customer can expose, including but not limited to:\n - The risks related to hacking the system by computer hacker or any third party.\n - The risks related to loss of the password or use of it by third party or unauthorized parties.\n - The risks related to defect or disorder in the trading system,  Exchange or loss of the orders through the contact.\n - Rejecting or ignoring the order by Qatar Stock Exchange or company.\n - Risks of duplication or repetition of the order submitted through the system intentionally or unintentionally by the customer.\n - The risks related to computer viruses by the service provider, company system or customer’s systems.\n - Any other risks related to another system not mentioned above,where these systems can be usually recognized by professionals in field of the trading via internet.",@"ثانًيا:هناكبعضالمخاطرالتىيمكنالتعرضلهاعلىسبيلالمثالوليسالحصر:￼￼\n- المخاطر المتعلقة باختراق النظام من قبل قراصنة الكمبيوتر أو أي طرف ثالث.\n- المخاطر المتعلقة بفقدان كلمة السر أو استخدامها من قبل طرف ثالث أو أطراف غير مخولين.\n- المخاطر المتعلقة بخلل فى نظام التداول أو تأخيرات فى التنفيذ أو تقديم الأوامر فى بورصة قطر أو فقدان الأوامر من خلال الاتصال.\n- رفض الأمر أو عدم الالتفات له من قبل البورصة. - مخاطر الازدواج أو تكرار الأمر المقدم من خلال النظام بصورة عمدية أو\nغير عمدية من قبل العميل. - المخاطر المتعلقة بفيروسات الكمبيوتر من جانب مقدم الخدمة أو من\nنظام الشركة أو من أنظمة العميل. مخاطر عدم إمكانية موائمة نظام الحاسب الآلي الخاص بالعميل مع نظام التداول.\n- أي مخاطر أخرى تتعلق بنظام آخر لم تذكر أعلاه والتي يمكن التعرف عليها عادة من قبل محترفي التداول عبر الإنترنت.",@"￼￼￼Third: Islamic Financial Securities Co., parent company, or its affiliates, or any directors, officers, employees or agents affiliated to Islamic Financial Securities Co., parent company or its affiliates are not obligated, towards the customer, for any losses, damages, costs, expenses or other obligations incurred by the customer due to his misuse of the trading system provided by the company.",@"ثالًثا:لن تكون الشركة الإسلامية للأوراق المالية أو الشركة الأم أو أي￼￼￼ شركة تابعة لها أو أي مدراء أو مسؤولين أو موظفين، أو وكلاء تابعين للشركة الإسلامية للأوراق المالية، أو الشركة الأم أو الشركة التابعة لها، ملزمة أو ملزمين تجاه العميل عن أي خسائر أو أضرار أو تكاليف أو مصاريف أو التزامات أخرى يتكبدها العميل، بسبب سوء استخدامه\nلنظام التداول الذي تقدمه الشركة.",@"￼Fourth: the customer is alone responsible for use of his own password, and he assumes all the obligations resulting from loss of it or use of it by third party or by unauthorized persons or as result of any disorder or breakdown in the trading system by the service provider, because of Virus Attack, any other accidents that may result in lateness or failure of execution, amendment, cancellation or loss of any order through connection to internet.",@"راب ًعا: يكون العميل وحده هو المسؤول عن استخدام كلمة السر الخاصة￼￼￼ به، ويتحمل كافة الالتزامات الناتجة عن فقدها أو استخدامها من قبل الغير، أو من قبل أشخاص غير مخولين، أو نتيجة لأي خلل أو عطل بنظام التداول من جانب مقدم الخدمة، أو هجوم الفيروسات أو أي حوادث أخرى، قد تؤدي إلى تأخير أو فشل تنفيذ أو تعديل أو إلغاء أو فقد أي أمر\nمن خلال الاتصال بالإنترنت.",nil];
    NSString *strTerms = [Temparr componentsJoinedByString:@"\n"];
    
    return strTerms;
    
  
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self version_API];
    
    globalShare.strNewOrderFlow = @"";
    _textFieldPassword.text = nil;

    [[GlobalShare sharedInstance] setIsErrorPupup:NO];
    [[GlobalShare sharedInstance] setIsTimerStockListRun:NO];
    [[GlobalShare sharedInstance] setIsTimerPortfolioRun:NO];
    [[GlobalShare sharedInstance] setIsTimerNewOrderRun:NO];
    [[GlobalShare sharedInstance] setIsTimerGainLossRun:NO];
    [[GlobalShare sharedInstance] setIsTimerActiveRun:NO];
    [[GlobalShare sharedInstance] setIsTimerFavoritesRun:NO];
    [[GlobalShare sharedInstance] setIsTimerMarketDepthRun:NO];
    
    if ([globalShare.timerStockList isValid]) {
        [globalShare.timerStockList invalidate];
        globalShare.timerStockList = nil;
    }
    if ([globalShare.timerPortfolio isValid]) {
        [globalShare.timerPortfolio invalidate];
        globalShare.timerPortfolio = nil;
    }
    if ([globalShare.timerNewOrder isValid]) {
        [globalShare.timerNewOrder invalidate];
        globalShare.timerNewOrder = nil;
    }
    if ([globalShare.timerGainLoss isValid]) {
        [globalShare.timerGainLoss invalidate];
        globalShare.timerGainLoss = nil;
    }
    if ([globalShare.timerActive isValid]) {
        [globalShare.timerActive invalidate];
        globalShare.timerActive = nil;
    }
    if ([globalShare.timerFavorites isValid]) {
        [globalShare.timerFavorites invalidate];
        globalShare.timerFavorites = nil;
    }
    if ([globalShare.timerMarketDepth isValid]) {
        [globalShare.timerMarketDepth invalidate];
        globalShare.timerMarketDepth = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if(globalShare.dictValues == nil)
        globalShare.dictValues = [[NSMutableDictionary alloc] init];
    
    if(globalShare.myLanguage == ARABIC_LANGUAGE) {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    else {
        [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    for (id control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)control;
            if(globalShare.myLanguage == ARABIC_LANGUAGE)
                [textField setTextAlignment:NSTextAlignmentRight];
            else
                [textField setTextAlignment:NSTextAlignmentLeft];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)version_API
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1424958206"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   NSError* parseError;
                                   NSDictionary *appMetadataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                   NSArray *resultsArray = (appMetadataDictionary)?[appMetadataDictionary objectForKey:@"results"]:nil;
                                   NSDictionary *resultsDic = [resultsArray firstObject];
                                   if (resultsDic) {
                                       // compare version with your apps local version
                                       NSString *iTunesVersion = [resultsDic objectForKey:@"version"];
                                       
                                       NSString *appVersion = @"1.3";
                                       
                                       NSLog(@"itunes version = %@\nAppversion = %@",iTunesVersion,appVersion);
                                    
                                       
                                       if (iTunesVersion && [appVersion compare:iTunesVersion] != NSOrderedSame) {
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Version Updated %@",iTunesVersion] message:[resultsDic valueForKey:@"releaseNotes"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Update", nil];
                                           alert.tag = 123456;
                                           [alert show];
                                           //                                           }];
                                           //                                           [alert show];
                                       }
                                   }
                               } else {
                                   // error occurred with http(s) request
                                   NSLog(@"error occurred communicating with iTunes");
                               }
                           }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123456) {
        switch (buttonIndex) {
                
                
            case 0:
            {
            //itms://itunes.apple.com/us/app/apple-store/id1445000545?mt=8
                NSString *iTunesLink =
                [NSString stringWithFormat:@"itms://itunes.apple.com/us/app/apple-store/id1424958206?mt=8"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
                break;
                
            case 1:
                
                NSLog(@"1");
                break;
                
                
                
            default:
                break;
        }
    }
}
#pragma mark - Button actions

- (BOOL)canAutoRotate
{
    return NO;
}

- (IBAction)actionLogin:(id)sender {
    @try {

        [self.textFieldUserName resignFirstResponder];
        [self.textFieldPassword resignFirstResponder];
        
        NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringPassword = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([stringUserName length] == 0) {
            [GlobalShare showBasicAlertView:self :USERNAME];
            return;
        } else if([stringPassword length] == 0) {
            [GlobalShare showBasicAlertView:self :PASSWORD];
            return;
        }
        
        if (![GlobalShare isConnectedInternet]) {
            [GlobalShare showBasicAlertView:self :INTERNET_CONNECTION];
            return;
        }
        [self verifyUserLogin];


    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
//        [self toEnableControls];
    }
}

- (IBAction)actionForgotPassword:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [[self navigationController] pushViewController:forgotPasswordViewController animated:YES];
}

- (IBAction)actionNewUser:(id)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [[self navigationController] pushViewController:registerViewController animated:YES];
}
- (IBAction)marketPreviewAction:(id)sender {

   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ssckey"];
   [[NSUserDefaults standardUserDefaults]synchronize];
   
    UITabBarController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockTabBarController"];
    tabController.delegate = self;
    [[self navigationController] pushViewController:tabController animated:YES];
    
}

#pragma mark - Common actions

-(void) toEnableControls {
    [self.buttonLogin setEnabled:YES];
    [self.buttonForgotPassword setEnabled:YES];
    [self.buttonNewUser setEnabled:YES];
    [self.buttonMarketPreview setEnabled:YES];
}

-(void) toDisableControls {
    [self.buttonLogin setEnabled:NO];
    [self.buttonForgotPassword setEnabled:NO];
    [self.buttonNewUser setEnabled:NO];
    [self.buttonMarketPreview setEnabled:NO];
}

-(void) verifyUserLogin {
    @try {
    [self.indicatorView setHidden:NO];
    [self toDisableControls];

    NSString *stringUserName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringPassword = [self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *strURL = [NSString stringWithFormat:@"%@SetCredentials?username=%@&password=%@", REQUEST_URL, stringUserName, stringPassword];
  //   strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        [self.indicatorView setHidden:YES];
                                                        [self toEnableControls];

                                                        if(error == nil)
                                                        {
//                                                            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                            NSLog(@"Data = %@",text);
                                                           
                                                            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            if([[returnedDict objectForKey:@"status"] hasPrefix:@"error"]) {
                                                                if([[returnedDict objectForKey:@"result"] hasPrefix:@"T4"])
                                                                    [GlobalShare showBasicAlertView:self :INVALID_HEADER];
                                                                else
                                                                    [GlobalShare showBasicAlertView:self :[returnedDict objectForKey:@"result"]];
                                                                return;
                                                            }
                                                            NSString *strToken = [returnedDict objectForKey:@"result"];
//                                                            NSString *strToken = @"1234567890";
                                                            [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:@"ssckey"];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                               if(globalShare.myLanguage == ARABIC_LANGUAGE) {
                                                          globalShare.strcashpositionName= [GlobalShare checkingNullValues:[[returnedDict objectForKey:@"Customer"]valueForKey:@"cust_name_a"]];
                                                               }
                                                               else{
                                                                    globalShare.strcashpositionName= [GlobalShare checkingNullValues:[[returnedDict objectForKey:@"Customer"]valueForKey:@"cust_name_e"]];
                                                                   if([globalShare.strcashpositionName isEqualToString:(@"")])
                                                                   {
                                                                globalShare.strcashpositionName= [GlobalShare checkingNullValues:[[returnedDict objectForKey:@"Customer"]valueForKey:@"cust_name_a"]];
                                                                   }
                                                               }
                                                            
                                                            // Storing UserName in Shared Preference values..
                                                            [[NSUserDefaults standardUserDefaults] setValue:stringUserName forKey:@"UserName"];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            

                                                            UITabBarController *tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"StockTabBarController"];
                                                            tabController.delegate = self;
                                                            [[self navigationController] pushViewController:tabController animated:YES];
                                                        }
                                                        else {
                                                            [GlobalShare showBasicAlertView:self :[error localizedDescription]];
                                                        }
                                                    }];
    
    [dataTask resume];
    }
    @catch (NSException * e) {
        NSLog(@"%@", [e description]);
    }
    @finally {
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[GlobalShare sharedInstance] setIsConfirmOrder:NO];
    [[GlobalShare sharedInstance] setIsDirectViewOrder:YES];
    return YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.buttonForgotPassword setEnabled:YES];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.buttonForgotPassword setEnabled:NO];
    self.textFieldCurrent = textField;
//    if ([textField isEqual:self.textFieldPassword])  {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        self.view.frame = [GlobalShare setViewMovedUp:YES :self.view :75];
//        [UIView commitAnimations];
//    }
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        // move to the left side of some containing view
//        textField.center = CGPointMake(self.view.frame.origin.x + textField.frame.size.width/2, textField.center.y);
//    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self.buttonForgotPassword setEnabled:YES];
//    if ([textField isEqual:self.textFieldPassword])  {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        self.view.frame = [GlobalShare setViewMovedUp:NO :self.view :75];
//        [UIView commitAnimations];
//    }
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        // move to the center of containing view
//        textField.center = CGPointMake(self.view.frame.size.width/2, textField.center.y);
//    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    double viewWidth = [UIScreen mainScreen].bounds.size.width;
    double viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect viewableAreaFrame = CGRectMake(0.0, 0.0, viewWidth, viewHeight - keyboardSize.height);
    CGRect activeTextFieldFrame = [self.textFieldCurrent convertRect:self.textFieldCurrent.bounds toView:self.view];
    
    if (!CGRectContainsRect(viewableAreaFrame, activeTextFieldFrame))
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -keyboardSize.height;
            self.view.frame = f;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = self.view.bounds;
    }];
}







@end
