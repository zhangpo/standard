//
//  BSChunkView.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSChuckView.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"


@implementation BSChuckView
{
    NSArray *_aryReasons;
    int datatag;
    
}
@synthesize tfcount=_tfcount,lblcount=_lblcount,tffan=_tffan,lblfan=_lblfan;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withTag:(int)tag{
    self = [super initWithFrame:frame];
    if (self) {
        datatag=tag;
        // Initialization code
        if (tag==1) {
            [self setTitle:@"退菜"];
        }
        else
        {
            [self setTitle:@"赠菜授权"];
        }
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        //        _aryReasons=[dp chkCodesql];
        NSLog(@"%@",_aryReasons);
        NSLog(@"%@",_aryReasons);
        if (tag!=3) {
            lblAcct = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 80, 40)];
            lblAcct.textAlignment = NSTextAlignmentRight;
            lblAcct.backgroundColor = [UIColor clearColor];
            lblAcct.text=@"授权编号";
            lblAcct.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [self addSubview:lblAcct];
            tfAcct = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, 100, 40)];
            tfAcct.borderStyle = UITextBorderStyleRoundedRect;
            [self addSubview:tfAcct];
            
            lblPwd = [[UILabel alloc] initWithFrame:CGRectMake(210, 80, 90, 40)];
            lblPwd.textAlignment = NSTextAlignmentRight;
            lblPwd.text=@"授权密码";
            lblPwd.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            lblPwd.backgroundColor = [UIColor clearColor];
            [self addSubview:lblPwd];
            tfPwd = [[UITextField alloc] initWithFrame:CGRectMake(310, 80, 100, 40)];
            tfPwd.borderStyle = UITextBorderStyleRoundedRect;
            tfPwd.secureTextEntry = YES;
            [self addSubview:tfPwd];
        }
        
        btnChunk = [UIButton buttonWithType:UIButtonTypeCustom];
        btnChunk.frame = CGRectMake(245, 285, 80, 40);
        btnChunk.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnChunk setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        if (tag==1) {
            [btnChunk setTitle:@"退菜" forState:UIControlStateNormal];
            
            btnChunk.tintColor=[UIColor whiteColor];
            _aryReasons=[[NSArray alloc] initWithArray:[dp chkCodesql]];
        }
        else
        {
            _lblcount = [[UILabel alloc] initWithFrame:CGRectMake(15, 125, 80, 40)];
            _lblcount.textAlignment = NSTextAlignmentRight;
            _lblcount.text=@"赠送数量";
            _lblcount.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            _lblcount.backgroundColor = [UIColor clearColor];
            [self addSubview:_lblcount];
            _tfcount = [[UITextField alloc] initWithFrame:CGRectMake(100, 125, 100, 40)];
            _tfcount.borderStyle = UITextBorderStyleRoundedRect;
            //            _tfcount.secureTextEntry = YES;
            _tfcount.delegate=self;
            [self addSubview:_tfcount];
            _lblfan = [[UILabel alloc] initWithFrame:CGRectMake(210, 125, 90, 40)];
            _lblfan.textAlignment = NSTextAlignmentRight;
            _lblfan.text=@"取消赠送";
            _lblfan.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            _lblfan.backgroundColor = [UIColor clearColor];
            [self addSubview:_lblfan];
            _tffan = [[UITextField alloc] initWithFrame:CGRectMake(310, 125, 100, 40)];
            _tffan.borderStyle = UITextBorderStyleRoundedRect;
            //            _tfcount.secureTextEntry = YES;
            _tffan.delegate=self;
            [self addSubview:_tffan];
            //            _tffan=[[UITextField alloc] initWithFrame:CGRectMake(210, 110, 100, 30)];
            [btnChunk setTitle:@"赠菜" forState:UIControlStateNormal];
            _aryReasons=[[NSArray alloc] initWithArray:[dp presentreason]];
        }
        pickerReason = [[UIPickerView alloc] initWithFrame:CGRectMake(65, 135, 370, 140)];
        pickerReason.showsSelectionIndicator = YES;
        pickerReason.dataSource= self;
        pickerReason.delegate = self;
        [self addSubview:pickerReason];
        [self addSubview:btnChunk];
        btnChunk.tag = 700;
        [btnChunk addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(330, 285, 80, 40);
        btnCancel.tintColor=[UIColor whiteColor];
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        dSelected=0;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


- (void)confirm{
    BOOL bAuth = NO;
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if (datatag!=3) {
        if ([tfAcct.text length]>0 && [tfPwd.text length]>0){
            bAuth = YES;
        }
    }else
    {
        bAuth = YES;
    }
    
    if (bAuth){
        NSLog(@"%@",[_aryReasons objectAtIndex:dSelected]);
        NSString *str;
        if (datatag==1) {
            str=[[_aryReasons objectAtIndex:dSelected] objectForKey:@"ID"];
        }else
        {
            str=[[_aryReasons objectAtIndex:dSelected] objectForKey:@"VCode"];
        }
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        if (datatag==3) {
            [dic setValue:str forKey:@"INIT"];
            [dic setValue:_tfcount.text forKey:@"count"];
            [dic setValue:_tffan.text forKey:@"recount"];
            //        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:str,@"INIT",nil];
        }else
        {
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tfAcct.text,@"user",tfPwd.text,@"pwd",_tfcount.text,@"count",str,@"INIT",_tffan.text,@"recount",nil];
        }
        [delegate chuckOrderWithOptions:dic];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"User and Password could not be empty"]
                                                        message:[langSetting localizedString:@"Please type again and retry"]
                                                       delegate:nil
                                              cancelButtonTitle:[langSetting localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)cancel{
    
    [delegate chuckOrderWithOptions:nil];
}
#pragma mark Pickview DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (datatag==1) {
        return [[_aryReasons objectAtIndex:row] objectForKey:@"DES"];
    }
    else
    {
        return [[_aryReasons objectAtIndex:row] objectForKey:@"VName"];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_aryReasons count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    dSelected = row;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if ([textField.text length]>=2) {
            return NO;
        }
        //        ^\d{m,n}$
        
        NSString *validRegEx =@"^[0-9]$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}
@end
