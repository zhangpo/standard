//
//  AKMySegmentAndView.m
//  BookSystem
//
//  Created by sundaoran on 13-11-21.
//
//

#import "AKMySegmentAndView.h"
#import "Singleton.h"
#import "AKDataQueryClass.h"
#import "CVLocalizationSetting.h"
#import "AKsNetAccessClass.h"
@implementation AKMySegmentAndView
{
    UISegmentedControl *segment;
    BOOL isShowVipMessage;
    NSArray     *_vipmessage;
    BOOL isvip;
    
}
@synthesize delegate=_delegate;
@synthesize table=_table,CheckNum=_CheckNum,man=_man,woman=_woman;

- (id)init
{
    self = [super init];
    [AKsNetAccessClass sharedNetAccess].SettlemenVip=NO;
    if (self) {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userSql"]boolValue])
        {
            AKDataQueryClass *data=[[AKDataQueryClass alloc]init];
            
            _vipmessage=[[NSArray alloc]initWithArray:[data selectDataFromSqlite:[NSString stringWithFormat:@"SELECT * FROM PhoneNumSave WHERE zhangdanId='%@'and dateTime='%@'",[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time]]];
        }
        else if([AKsNetAccessClass sharedNetAccess].showVipMessageDict)
        {
            _vipmessage=[[NSArray alloc]initWithObjects:[AKsNetAccessClass sharedNetAccess].showVipMessageDict, nil];
        }
        
        if([_vipmessage count]!=0)
        {
            [AKsNetAccessClass sharedNetAccess].SettlemenVip=YES;
        }
        [self creatview];
    }
    return self;
}
-(void)creatview
{
    UIImageView *titleImageView=[[UIImageView alloc]init];
    titleImageView.frame=CGRectMake(0,0,768,44);
    [titleImageView setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"title.png"]];
    titleImageView.userInteractionEnabled=YES;
    [self addSubview:titleImageView];
    
    UIButton *Vipbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [Vipbutton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"vip.png"] forState:UIControlStateNormal];
    Vipbutton.frame=CGRectMake(768-80, 5, 40, 34);
    [Vipbutton addTarget:self action:@selector(showVip) forControlEvents:UIControlEventTouchUpInside];
    if([AKsNetAccessClass sharedNetAccess].SettlemenVip)
    {
        [titleImageView addSubview:Vipbutton];
    }
    
    
    segment=[[UISegmentedControl alloc]init];
    segment.frame=CGRectMake(4, 54, 760, 60);
    //    segment.tintColor=[UIColor blackColor];
    
    
    NSDictionary *dicSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
    
    NSDictionary *dicnomal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,nil];
    
    [segment setTitleTextAttributes:dicSelect forState:UIControlStateSelected];
    [segment setTitleTextAttributes:dicnomal forState:UIControlStateNormal];
    
    for (int i=0; i<=8; i++)
    {
        [segment insertSegmentWithTitle:[NSString stringWithFormat:@"%d",i+1] atIndex:i animated:NO];
    }
    [segment insertSegmentWithTitle:@"0" atIndex:10 animated:NO];
    [segment insertSegmentWithTitle:@"X" atIndex:11 animated:NO];
    [segment insertSegmentWithTitle:@"1" atIndex:12 animated:NO];
    segment.selectedSegmentIndex=11;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segment];
    if ([[Singleton sharedSingleton].man isEqualToString:@""]||[[Singleton sharedSingleton].man isEqualToString:NULL]||[[Singleton sharedSingleton].man isEqualToString:nil]||[[Singleton sharedSingleton].man isEqualToString:@"(null)"])
    {
        _man.text=@"0";
    }
    else
    {
        _man.text=[Singleton sharedSingleton].man;
    }
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 700, 40)];
    if([[Singleton sharedSingleton].CheckNum  isEqualToString:@""])
    {
        [Singleton sharedSingleton].CheckNum=@"暂无账单";
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"])
    {
        if ([[Singleton sharedSingleton] isYudian]){
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] isEqualToString:@"en"]) {
            lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@  %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }else
        {
        lb.text=[NSString stringWithFormat:@"%@%@     %@%@     %@%@     %@%@     %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        }
    }
        else
        {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] isEqualToString:@"en"]) {
            lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }else
        {
        lb.text=[NSString stringWithFormat:@"%@%@        %@%@        %@%@        %@%@        %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        }
    }
    }else
    {
        if ([[Singleton sharedSingleton] isYudian]){
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] isEqualToString:@"en"]) {
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
            }else
            {
                lb.text=[NSString stringWithFormat:@"%@%@     %@%@     %@%@     %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            }
        }
        else
        {
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] isEqualToString:@"en"]) {
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
            }else
            {
                lb.text=[NSString stringWithFormat:@"%@%@        %@%@        %@%@        %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].Seat,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            }
        }
    }
    lb.backgroundColor=[UIColor clearColor];
    lb.textColor=[UIColor whiteColor];
    [self addSubview:lb];
}

-(void)showVip
{
    if(isShowVipMessage)
    {
        [_delegate showVipMessageView:_vipmessage andisShowVipMessage:isShowVipMessage];
        isShowVipMessage=NO;
    }
    else
    {
        [_delegate showVipMessageView:_vipmessage andisShowVipMessage:isShowVipMessage];
        isShowVipMessage=YES;
    }
    
    
}
-(void)segmentClick:(UISegmentedControl *)segment1
{
    if(segment1.selectedSegmentIndex!=10)
    {
        if(segment1.selectedSegmentIndex==9)
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",0] andSegment:segment1];
        }
        else
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",segment.selectedSegmentIndex+1] andSegment:segment1];
        }
    }
    else
    {
        [_delegate selectSegmentIndex:@"X" andSegment:segment1];
    }
}
-(void)setsegmentIndex:(NSString *)index
{
    segment.selectedSegmentIndex=11;
}
-(void)setTitle:(NSString *)title
{
    [segment setTitle:title forSegmentAtIndex:11];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
