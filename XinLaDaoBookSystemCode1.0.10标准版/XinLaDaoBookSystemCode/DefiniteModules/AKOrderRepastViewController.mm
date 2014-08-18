//
//  AKOrderRepastViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//
#import "AKOrederClassButton.h"
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "BSLogViewController.h"
#import "AKsIsVipShowView.h"
#import "AKComboButton.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"


@interface AKOrderRepastViewController ()

@end

@implementation AKOrderRepastViewController
{
    NSArray *_array;
    NSMutableArray *_buttonArray;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dict;
    NSMutableArray *_searchByName;
    NSMutableArray *_searchByPhone;
    UISearchBar *_searchBar;
    UIScrollView *_scroll;
    NSMutableArray *_Combo;
    NSMutableArray *_ComButton;
    NSMutableArray *_selectArray;
    NSArray *_array1;
    UIImageView *_view;
    UIScrollView *scrollview;
    UIButton *_button;
    NSMutableArray *_allComboArray;
    UIButton *_recommendButton;
    NSArray *arry;
    NSMutableArray *comboFinish;
    NSMutableArray *onlyOne;
    NSMutableArray *_selectCombo;
    //    NSMutableArray *_tableArray;
    AKMySegmentAndView *akmsav;
    UILabel *label;
    NSMutableArray *classButton;
    BSAddtionView *vAddition;
    NSMutableDictionary *_dataDic;
    NSMutableDictionary *_Weight;
    UIPanGestureRecognizer *_pan;
    int _com;
    int _count;
    int _total;
    int _sele;
    int _btn;
    int _x;
    int _z;
    int cishu;
    int _y;
    
    AKsIsVipShowView    *showVip;
    BSDataProvider      *_dp;
    UIScrollView *_RecommendView;
    
    NSArray *_soldOut;
    /*
     UIView *_GestureView;
     UITableView *_tableView;
     NSMutableArray *_showdataArray;
     NSMutableArray *_showarray;
     */
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        classArray =[dp getClassById];
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_dp)
    {
        _dp=nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    akmsav= [[AKMySegmentAndView alloc] init];
    akmsav.frame=CGRectMake(0, 0, 768, 114);
    akmsav.delegate=self;
    
    [self.view addSubview:akmsav];
    if(!_dp)
    {
        _dp=[[BSDataProvider alloc]init];
        _soldOut=[_dp soldOut];
        [self upload];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
}
//-(void)soldOut
//{
//
//    [SVProgressHUD dismiss];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _y=0;
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
    _allComboArray=[[[BSDataProvider alloc] init] allCombo];
    _dataDic=[NSMutableDictionary dictionary];
    classButton=[[NSMutableArray alloc] init];
    _selectCombo=[[NSMutableArray alloc] init];
    [self searchBarInit];
    
    int i=[classArray count];
    // Do any additional setup after loading the view from its nib.
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 170, 100, 1024-190)];
    //scrollview.backgroundColor=[UIColor redColor];
    //    scrollview.contentOffset=CGPointMake(768/9*i, 40);
    [scrollview setContentSize:CGSizeMake(100,60*i)];
    [self.view addSubview:scrollview];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 60*i)];
    [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassBG.png"]];
    [scrollview addSubview:image];
    int j=0;
    for (NSDictionary *dict in classArray) {
        AKOrederClassButton *btn=[[AKOrederClassButton alloc] initWithFrame:CGRectMake(0,60*j,90, 59)];
        [btn.button setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
        btn.button.tag=j;
        [btn.button addTarget:self action:@selector(segmentClick1:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        [classButton addObject:btn];
        j++;
    }
    
    
    //    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:classArray];
    //    segment.frame = CGRectMake(0, 0, 768/9*i, 40);
    //    [segment addTarget:self action:@selector(segmentClick1:) forControlEvents:UIControlEventValueChanged];
    //    [scrollview addSubview:segment];
    //    segment.selectedSegmentIndex = 0;
    
    _count=0;
    _total=1;
    _ComButton=[[NSMutableArray alloc] init];
    _Combo=[[NSMutableArray alloc] init];
    _array=[[NSArray alloc] init];
    //_array=[BSDataProvider selectFood:1];
    
    _dataArray=[[NSMutableArray alloc] init];
    _searchByName=[[NSMutableArray alloc] init];
    _searchByPhone=[[NSMutableArray alloc] init];
    _dict=[[NSMutableDictionary alloc] init];
    _scroll=[[UIScrollView alloc] init];
    _scroll.bounces=NO;
    _view=[[UIImageView alloc] init];
    _view.frame=CGRectMake(90, 350, 678, 580);
    [_view setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Packagebg.png"]];
    _view.userInteractionEnabled=YES;
    _scroll.frame=CGRectMake(0, 60,678, 500);
    [_view addSubview:_scroll];
    [self.view addSubview:_view];
    [self.view sendSubviewToBack:_view];
    _RecommendView=[[UIScrollView alloc] initWithFrame:CGRectMake(90, 450, 678, 400)];
    _RecommendView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:_RecommendView];
    aScrollView.frame=CGRectMake(80,175, 688, 740);
    aScrollView.backgroundColor=[UIColor whiteColor];
    NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"Additions"],[[CVLocalizationSetting sharedInstance] localizedString:@"OrderedFood"],[[CVLocalizationSetting sharedInstance] localizedString:@"Back"], nil];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(270+125*i, 1024-70, 140, 60);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 125, 30)];
        lb.text=[array objectAtIndex:i];
        if ([[[NSUserDefaults standardUserDefaults]
              stringForKey:@"language"] isEqualToString:@"en"])
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        else
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        //        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tintColor=[UIColor whiteColor];
        if (i==0) {
            [btn addTarget:self action:@selector(Beizhu:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1)
        {
            [btn addTarget:self action:@selector(alreadyBuyGreens:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==2){
            [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    _recommendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _recommendButton.frame=CGRectMake(60, 800, 60, 60);
    _RecommendView.frame=_recommendButton.frame;
    [_recommendButton addGestureRecognizer:_pan];
    [_recommendButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"sweep.png"] forState:UIControlStateNormal];
    _recommendButton.hidden=YES;
    
    [_recommendButton addTarget:self action:@selector(recommendShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recommendButton];
    _RecommendView.hidden=YES;
    [_RecommendView sendSubviewToBack:_view];
    //    [_RecommendView ]
    
    
    
    //    _tableArray=[[NSMutableArray alloc] init];
    
}
-(void)recommendShow
{
    if (_RecommendView.hidden==NO) {
        [UIView animateWithDuration:0.3f animations:^{
            _RecommendView.frame = _recommendButton.frame;
        }completion:^(BOOL finished) {
            _RecommendView.hidden=YES;
        }];
    }else
    {
        _RecommendView.hidden=NO;
        [UIView animateWithDuration:0.3f animations:^{
            _RecommendView.frame = CGRectMake(90, 450, 678, 450);
        }completion:^(BOOL finished) {
            
            [_RecommendView bringSubviewToFront:self.view];
        }];
    }
    
}
//界面可拖动
-(void)tuodongView:(UIPanGestureRecognizer *)pan
{
    UIView *piece = [pan view];
    NSLog(@"%@",piece);
    _RecommendView.frame=_recommendButton.frame;
    if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_tableArray count];
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellName=@"cellName";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
//    }
//    cell.textLabel.textColor=[UIColor blackColor];
//    cell.textLabel.text=[[_tableArray objectAtIndex:indexPath.row] objectForKey:@"DES"];
//    return cell;
//}
//-(void)reloadData
//{
//    [_comboTableView reloadData];
//    NSUInteger sectionCount = [_comboTableView numberOfSections];
//    if (sectionCount) {
//
//        NSUInteger rowCount = [_comboTableView numberOfRowsInSection:0];
//        if (rowCount) {
//
//            NSUInteger ii[2] = {0, rowCount - 1};
//            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
//            [_comboTableView scrollToRowAtIndexPath:indexPath
//                                   atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
//    }
//}
//类别按钮事件
- (void)segmentClick1:(UIButton *)sender
{
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    for (AKOrederClassButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    _count=sender.selectedSegmentIndex;
    [self button:sender.tag];
}
-(void)upload
{
    _selectArray=[NSMutableArray array];
    _buttonArray=[[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *ary =[Singleton sharedSingleton].dishArray;
    
    for (NSMutableDictionary *dict in [NSArray arrayWithArray:ary]) {
        if ([dict objectForKey:@"CNT"]) {
            [ary removeObject:dict];
        }
        
    }
    for (NSMutableDictionary *dict in ary) {
        if ([[dict objectForKey:@"ISTC"] intValue]==1) {
            [dict setObject:@"NO" forKey:@"isShow"];
        }
    }
    for (UIButton *btn in [aScrollView subviews])
    {
        [btn removeFromSuperview];
    }
    [_dataArray removeAllObjects];
    [self button:0];
    [_selectArray removeAllObjects];
    [_ComButton removeAllObjects];
    
    NSArray *array=[_dp selectCache];
    
    if (![ary count])
    {
        NSMutableArray *array1=[NSMutableArray array];
        array1=[NSMutableArray arrayWithArray:array];
        [_selectArray addObjectsFromArray:array1];
    }
    [_selectArray addObjectsFromArray:ary];
    [self changeButtonColor];
    [ary removeAllObjects];
    [_RecommendView sendSubviewToBack:self.view];
}
-(void)changeButtonColor
{
    for (int i=0; i<[classArray count]; i++) {
        for (int j=0;j<[[_buttonArray objectAtIndex:i] count];j++) {
            int x=0;
            AKComboButton *btn=[[_buttonArray objectAtIndex:i] objectAtIndex:j];
            for (NSString *str in _soldOut) {
                if ([[[[_dataArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"ITCODE"] isEqualToString:str]) {
                    x++;
                }
            }
            if (x>0) {
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"assess.png"] forState:UIControlStateNormal];
            }else
            {
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (btn.selected==NO) {
                btn.lblCount.text=@"";
                btn.selected=YES;
            }
            for (NSDictionary *dict in _selectArray) {
                int k=0;
                int x=0;
                NSString *str=[dict objectForKey:@"DES"];
                if ([btn.titleLabel.text isEqualToString:str]) {
                    if (btn.selected==NO) {
                                               btn.lblCount.text=@"";
                        btn.selected=YES;
                    }
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"DES"] isEqualToString:str]) {
                            k=k+[[dict1 objectForKey:@"total"] intValue];
                        }
                    }
                    if ([dict objectForKey:@"Tpcode"]==nil||[[dict objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"ITCODE"]]||[[dict objectForKey:@"Tpcode"] isEqualToString:@""]) {
                        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
                        NSLog(@"%@",dict);
                        btn.selected=NO;
                        
                        btn.lblCount.text =[NSString stringWithFormat:@"%d",k];
                        //                        j+=[[dict objectForKey:@"total"] intValue];
                    }
                }
                
                x++;
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [self updataTitle];
}
- (void)searchBarInit {
    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 120, 768, 50)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
	_searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:_searchBar];
}
- (void)additionSelected:(NSArray *)ary{
    if (ary) {
        [_dataDic setValue:ary forKey:@"addition"];
    }
    [vAddition removeFromSuperview];
    vAddition=nil;
}
-(void)updataTitle
{
    for (int i=0; i<[classArray count]; i++) {
        int j=0;
        AKOrederClassButton *button=[classButton objectAtIndex:i];
        for (AKComboButton *btn in [_buttonArray objectAtIndex:i]) {
            if ([btn.lblCount.text intValue]>0) {
                j+=[btn.lblCount.text intValue];
            }
        }
        if (j==0) {
            button.label.text=@"";
            button.frame=CGRectMake(0,60*i,90, 59);
            button.button.frame=CGRectMake(0,0,90,59);
            [button.button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassShort.png"] forState:UIControlStateNormal];
        }
        else
        {
            button.frame=CGRectMake(0,60*i,100, 59);
            button.button.frame=CGRectMake(0,0,100,59);
            [button.button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassLong.png"] forState:UIControlStateNormal];
            button.label.text=[NSString stringWithFormat:@"%d",j];
        }
    }
    
}
-(void)comboClick:(UIButton *)btn
{
    if ([_Combo count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择套餐" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (btn.tag==1) {
        if ([_ComButton count]==0) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该套餐已选择完毕，请取消以后重新选择" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if (_com>0) {
                for (UIButton *btn in [_scroll subviews]) {
                    [btn removeFromSuperview];
                }
                _com=_com-1;
                [self comboShow:_com];
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是第一个" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    else if(btn.tag==2)
    {
        if (_com>[_Combo count]-1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最后一个" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
        }else
        {
            _com=_com+1;
            for (UIButton *btn in [_scroll subviews]) {
                if (btn.selected==NO) {
                    for (UIButton *btn in [_scroll subviews]) {
                        [btn removeFromSuperview];
                    }
                    [self comboShow:_com];
                    return;
                }
            }
            _com=_com-1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择，请选择以后再点" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            [self comboShow:_com];
        }
    }
    else
    {
        aScrollView.frame=CGRectMake(80,175, 688, 740);
        _total=1;
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        if ([_ComButton count]>0) {
            int j=[_selectArray count];
            
            int y=0;
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[[[_dataArray objectAtIndex:_count] objectAtIndex:_btn] objectForKey:@"ITCODE"]]) {
                    y++;
                }
            }
            NSString *str=[[[_dataArray objectAtIndex:_count] objectAtIndex:_btn] objectForKey:@"DES"];
            NSString *str1=[NSString stringWithFormat:@"%d",y-1];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (int i=0;i<j;i++) {
                if ([str isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"DES"]]&&[str1 isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                    [array addObject:[NSString stringWithFormat:@"%d",i]];
                }
                if ([str isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]]&&[str1 isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                    [array addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            int k=[array count];
            for (int i=0; i<k; i++) {
                [_selectArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
            }
            if ([str1 intValue]==0) {
                UIButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                button.selected=YES;
                [[[button subviews] lastObject] removeFromSuperview];
                [self.view sendSubviewToBack:_view];
                //                for (UIButton *button in [_scroll subviews]) {
                //                    [button removeFromSuperview];
                //                }
            }else
            {
                UIButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                UILabel *lb=[[button subviews] lastObject];
                int x=[lb.text intValue];
                lb.text=[NSString stringWithFormat:@"%d",y-1];
            }
            [_ComButton removeAllObjects];
            [_Combo removeAllObjects];
            _com=0;
            [self.view sendSubviewToBack:_view];
            aScrollView.frame=CGRectMake(80,175, 688, 740);
            //            for (UIButton *button in [_scroll subviews]) {
            //                [button removeFromSuperview];
            //            }
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
            [self updataTitle];
        }
    }
}
-(void)button:(int)tag
{
    if ([_buttonArray count]==0) {
        int k=0;
        for (int j=0; j<[classArray count]; j++) {
            NSArray *array1=[BSDataProvider getFoodList:[NSString stringWithFormat:@"class=%@",[[classArray objectAtIndex:j] objectForKey:@"GRP"]]];
            NSMutableArray *array2=[[NSMutableArray alloc] init];
            for (int i=0; i<[array1 count]; i++)
            {
                AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
                btn.selected=YES;
                
                if ([[[array1 objectAtIndex:i] objectForKey:@"ISTC"] intValue]==1) {
                    btn.tag=i+10000;
                }
                else
                {
                    btn.tag=i;
                }
                btn.lblCount.frame=CGRectMake(70, 50, 50, 30);
                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.numberOfLines=2;
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                [btn setTitle:[[array1 objectAtIndex:i] objectForKey:@"DES"] forState:UIControlStateNormal];
                btn.PCODE=[[array1 objectAtIndex:i] objectForKey:@"ITCODE"];
                [array2 addObject:btn];
                SearchBage *search=[[SearchBage alloc] init];
                search.localID = [NSNumber numberWithInt:k];
                search.name=[[array1 objectAtIndex:i] objectForKey:@"DES"];
                NSMutableArray *ary=[[NSMutableArray alloc] init];
                [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"ITCODE"]];
                search.phoneArray=ary;
                [_dict setObject:search forKey:search.localID];
                [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
                k++;
            }
            [_buttonArray addObject:array2];
            //_buttonArray存的是所有的button
            [_dataArray addObject:array1];
            //_dataArray存的是所有的菜的数据
        }
    }
    _array=[_buttonArray objectAtIndex:tag];
    for (int i=0; i<[classArray count]; i++) {
        int k=0;
        for (AKComboButton *btn in [_buttonArray objectAtIndex:i]) {
            btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
            k++;
        }
    }
    //    aScrollView.backgroundColor=[UIColor redColor];
    for (AKComboButton *btn in _array) {
        [aScrollView addSubview:btn];
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    for (UIButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [_dict objectForKey:localID];
                    [array addObject:btn];
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                    }
                }
                k++;
            }
        }
    }
    //    NSNumber *localID = nil;
    //    NSMutableString *matchString = [NSMutableString string];
    //    NSMutableArray *matchPos = [NSMutableArray array];
    NSMutableArray *matchPhones = [NSMutableArray array];
    for (int i=0; i<[_searchByPhone count]; i++) {//搜索到的
        localID = [_searchByPhone objectAtIndex:i];
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [array addObject:btn];
                    //号码匹配 获取对应匹配的号码串 及高亮位置
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                        [matchString appendString:[matchPhones objectAtIndex:0]];
                    }
                }
                k++;
            }
        }
    }
    //
    //    //姓名匹配 获取对应匹配的拼音串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
    //    }
    //
    //    //号码匹配 获取对应匹配的号码串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
    //        [matchString appendString:[matchPhones objectAtIndex:0]];
    //    }
    int a=0;
    _array=array;
    for (AKComboButton *btn in _array) {
        
        btn.frame=CGRectMake(a%5*135+15,a/5*90+15,120,80);
        [aScrollView addSubview:btn];
        a++;
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
-(void)buttonClick:(AKComboButton *)btn
{
    NSLog(@"%d",[_selectArray count]);
    //    if ([_selectArray count]+1>40) {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前点菜数量超过40行，请先发送！" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
    //        [alert show];
    //        return;
    //    }
    
    if(_total==0)
    {
        if (btn.selected==NO){
            if (btn.tag>=10000) {
                int k=0;
                NSMutableArray *array=[NSMutableArray array];
                for (NSDictionary *dict in _selectArray) {
                    NSString *str=[dict objectForKey:@"ITCODE"];
                    if ([str isEqualToString:btn.PCODE]) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }
                    k++;
                }
                int i=0;
                for (NSString *str in array) {
                    [_selectArray removeObjectAtIndex:[str intValue]-i];
                    i++;
                }
                [_selectCombo removeAllObjects];
                [_ComButton removeAllObjects];
                [_Combo removeAllObjects];
                for (UIButton *btn in [_scroll subviews]) {
                    [btn removeFromSuperview];
                }
                [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
                [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                aScrollView.frame=CGRectMake(80,175, 688, 740);
                [self.view sendSubviewToBack:_view];
            }else{
                int k=0;
                NSMutableArray *array=[NSMutableArray array];
                if ([_selectCombo count]>0) {
                    for (NSDictionary *dict in _selectCombo) {
                        NSString *str=[dict objectForKey:@"PCODE1"];
                        if ([str isEqualToString:btn.PCODE]) {
                            [array addObject:[NSString stringWithFormat:@"%d",k]];
                        }
                        k++;
                    }
                    int i=0;
                    for (NSString *str in array) {
                        [_selectCombo removeObjectAtIndex:[str intValue]-i];
                        i++;
                    }
                }else
                {
                    for (NSDictionary *dict in _selectArray) {
                        NSString *str=[dict objectForKey:@"ITCODE"];
                        if ([str isEqualToString:btn.PCODE]) {
                            [array addObject:[NSString stringWithFormat:@"%d",k]];
                        }
                        k++;
                    }
                    int i=0;
                    for (NSString *str in array) {
                        [_selectArray removeObjectAtIndex:[str intValue]-i];
                        i++;
                    }
                    [self PackageGroup];
                }
                
            }
            
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
            btn.lblCount.text=@"";
            btn.selected=YES;
            [self updataTitle];
        }
        
        _total=1;
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }else
    {
        
        if ([_ComButton count]>0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕，请选择完毕或者取消套餐以后再选择" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            if (btn.tag>=10000) {
                _total=1;
            }
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
            int i=0;
            if (btn.selected==NO) {
                
                i=[btn.lblCount.text intValue]+_total;
                btn.lblCount.text=[NSString stringWithFormat:@"%d",i];
            }else
            {
                btn.lblCount.text=[NSString stringWithFormat:@"%d",_total];
                btn.selected=NO;
            }
            
            if (btn.tag>=10000) {
                int k=0;
                for (NSArray *array in _dataArray) {
                    for (NSDictionary *dict in array) {
                        if ([[dict objectForKey:@"ITCODE"] isEqualToString:btn.PCODE]) {
                            _count=k;
                        }
                    }
                    k++;
                }
                aScrollView.frame=CGRectMake(80,175, 688, 360);
                [self.view bringSubviewToFront:_view];
                _x=0;
                [self comboClick1:btn];
                _button=btn;
                
            }
            else
            {
                aScrollView.frame=CGRectMake(80,175, 688,740);
                aScrollView.backgroundColor=[UIColor whiteColor];
                [self.view sendSubviewToBack:_view];
                int k=0;
                /**
                 *  获取菜品属于哪个类别
                 */
                for (NSArray *array in _dataArray) {
                    for (NSDictionary *dict in array) {
                        if ([[dict objectForKey:@"ITCODE"] isEqualToString:btn.PCODE]) {
                            _count=k;
                            break;
                        }
                    }
                    k++;
                }
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]];
                                           
//                                           dictionaryWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]];
                if ([[dict objectForKey:@"UNITCUR"] intValue]==2) {
                    _Weight=dict;
                    [self WeightFlg];
                }
                else
                {
                    _dataDic=dict;
                    [_dataDic setValue:@"0" forKey:@"Weight"];
                    [_dataDic setValue:@"1" forKey:@"Weightflg"];
                    [dict setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"total"];
                    //                    _x=0;
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"ISTC"] intValue]==0&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[_dataDic objectForKey:@"ITCODE"]]&&[dict1 objectForKey:@"addition"]==nil) {
                            [dict setValue:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
                            [_selectArray removeObject:dict1];
                            break;
                        }
                    }
                    [dict setValue:@"0" forKey:@"TPNUM"];
                    _Weight=dict;
                    [_selectArray addObject:dict];
                    _total=1;
                    [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
                    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                    cishu=0;
                    [self updataTitle];
                }
                //            注释该行代码，菜品默认选择segment份数
                [self PackageGroup];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
                
            }
            //        else
            //        {
            //            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
            //
            //            [[[btn subviews]lastObject]removeFromSuperview];
            //
            //            btn.selected=YES;
            //            if (btn.tag>=10000) {
            //                NSMutableArray *array=[[NSMutableArray alloc] init];
            //                if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"ISTC"] intValue]==1) {
            //                    int j=[_selectArray count];
            //                    for (int i=0;i<j;i++) {
            //                        NSLog(@"%@",[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"]);
            //                        NSLog(@"%@",_selectArray);
            //                        NSLog(@"aaaaa%@",[[_selectArray objectAtIndex:i] objectForKey:@"DES"]);
            //                        NSLog(@"aaaaa%@",[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]);
            //                        if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"] isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"DES"]]) {
            //                            [array addObject:[NSString stringWithFormat:@"%d",i]];
            //                        }
            //                        if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"] isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]]) {
            //                            [array addObject:[NSString stringWithFormat:@"%d",i]];
            //                        }
            //
            //                    }
            //                    NSLog(@"%@",array);
            //                    int k=[array count];
            //                    for (int i=0; i<k; i++) {
            //                        [_selectArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
            //                    }
            //                    [_ComButton removeAllObjects];
            //                    [self updataTitle];
            //                }
            //            }
            //            else
            //            {
            //                NSLog(@"%@",[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]);
            //                [_selectArray removeObject:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]];
            //                NSLog(@"%@",_selectArray);
            //                [self updataTitle];
            //            }
            //        }
            //    }
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
}
-(void)WeightFlg
{
    if (_total>_y) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:_Weight];
        _dataDic=dict;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        tf1.delegate=self;
        alertView.tag=3;
        [alertView show];
    }
    else
    {
        _y=0;
        _Weight=nil;
    }
}
//点套餐
-(void)comboClick1:(UIButton *)btn
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    arry=[dp combo:[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"ITCODE"]];
    NSLog(@"%d",[_selectArray count]);
    [_ComButton removeAllObjects];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000]];
    [dict setValue:@"1" forKey:@"total"];
    NSLog(@"%@",dict);
    [dict setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"count"];
    _z=0;
    for (NSDictionary *dict1 in _selectArray) {
        if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[dict objectForKey:@"ITCODE"]]) {
            _z++;
        }
    }
    
    [dict setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
    [_selectArray addObject:dict];
    _dataDic=dict;
    [self updataTitle];
    _btn=btn.tag-10000;
    
    if ([arry count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"此套餐已点完" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        aScrollView.frame=CGRectMake(80,175, 688, 740);
        [self.view sendSubviewToBack:_view];
    }
    else
    {
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (NSArray *array1 in arry) {
            if ([[[array1 lastObject] objectForKey:@"pmin"]intValue]==[[[array1 lastObject] objectForKey:@"pmax"] intValue]&&[[[array1 lastObject] objectForKey:@"pmin"] intValue]==1) {
                [[array1 lastObject] setValue:@"1" forKey:@"total"];
                [[array1 lastObject] setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
                [_selectCombo addObject:[array1 lastObject]];
                [[_selectArray lastObject] setObject:_selectCombo forKey:@"combo"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
            }
            else{
                [array addObject:array1];//可选择的套餐
            }
        }
        _Combo=array;
        if ([_Combo count]>0) {
            [self comboShow:_com];
        }else
        {
            
            [self comboend];
            aScrollView.frame=CGRectMake(80,175, 688, 740);
            [self.view sendSubviewToBack:_view];
        }
        
    }
    
}
//查询套餐的可换购项，生成按钮
-(void)comboShow:(int)tag1{
    if ([_ComButton count]==0) {
        int j=0;
        for (int i=0;i<[_Combo count];i++) {
            int k=0;
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in [_Combo objectAtIndex:i]) {
                AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                btn.frame=CGRectMake(k%5*135+10,k/5*90+50,120,80);
                btn.btnTag=j;
                btn.tag=k;
                btn.selected=YES;
                [btn setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
                btn.lblCount.text=[NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"pmin"],[dict objectForKey:@"pmax"]];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tintColor=[UIColor whiteColor];
                btn.PCODE=[dict objectForKey:@"PCODE1"];
                if ([[dict objectForKey:@"pmin"] intValue]>0) {
                    btn.selected=NO;
                    [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
                    [dict setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
                    //                    [dict setValue:@"1" forKey:@"total"];
                    [dict setValue:[dict objectForKey:@"pmin"] forKey:@"total"];
                    [_selectCombo addObject:dict];
                    btn.titleLabel1.text=[dict objectForKey:@"total"];
                }else
                {
                    btn.selected=YES;
                    [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                }
                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
                
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.numberOfLines=2;
                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                [array addObject:btn];
                k++;
                j++;
            }
            [_ComButton addObject:array];
        }
    }
    //
    
    int j=0;
    for (int i=0; i<[_ComButton count]; i++) {
        NSArray *array=[_ComButton objectAtIndex:i];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,j, 678, ([array count]/5)*90+135)];
        if ([array count] % 5 == 0) {
            view.frame = CGRectMake(0,j, 678, (([array count]/5)-1)*90+135);
        }else{
            view.frame = CGRectMake(0,j, 678, ([array count]/5)*90+135);
        }
        view.backgroundColor=[UIColor colorWithRed:200/255.0 green:239/255.0 blue:249/255.0 alpha:0.5];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,660,40)];
        
        label1.text=[NSString stringWithFormat:@"%@   %@-%@",[[[_Combo objectAtIndex:i] lastObject] objectForKey:@"GROUPTITLE"],[[[_Combo objectAtIndex:i] lastObject] objectForKey:@"tpmin"],[[[_Combo objectAtIndex:i] lastObject] objectForKey:@"tpmax"]];
        label1.backgroundColor=[UIColor clearColor];
        label1.font=[UIFont systemFontOfSize:20];
        [view addSubview:label1];
        //        view.backgroundColor=[UIColor ]
        for (UIButton *btn in array) {
            [view addSubview:btn];
        }
        [_scroll addSubview:view];
        if ([array count]%5==0) {
            j=j+(([array count]/5)-1)*90+140;
        }else
        {
            j=j+([array count]/5)*90+140;
        }
        
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(450, j+10,80,40);
    btn.backgroundColor=[UIColor redColor];
    [btn setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    [btn addTarget:self action:@selector(comboConfirm:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=1;
    [_scroll addSubview:btn];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(550, j+10,80,40);
    btn1.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    btn1.backgroundColor=[UIColor redColor];
    [btn1 setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(comboConfirm:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag=2;
    [_scroll addSubview:btn1];
    [_scroll setContentSize:CGSizeMake(120*5+30,j+60)];
}
//套餐明细的点击事件
-(void)btnClick:(AKComboButton *)btn
{
    //    for (UIButton *button in [_scroll subviews]) {
    //        [button removeFromSuperview];
    //    }
    int j=0;
    int k=0;
    NSLog(@"%d",btn.tag);
    //确认选择的是那一个明细
    for (NSArray *array in _ComButton) {
        for (AKComboButton *button in array) {
            if (btn.btnTag==button.btnTag) {
                k++;
                _com=j;
            }
        }
        if (k>0) {
            break;
        }
        j++;
    }
    
    int i=0;
    for (AKComboButton *btn11 in [_ComButton objectAtIndex:_com]) {
        if (btn11.selected==NO) {
            NSLog(@"%d",[btn11.titleLabel1.text intValue]);
            i=i+[btn11.titleLabel1.text intValue];
        }
    }
    if (_total==0) {
        [_selectCombo removeObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
        for (NSDictionary *dict in _selectCombo) {
            if ([[dict objectForKey:@"Tpcode"] isEqualToString:[[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] objectForKey:@"Tpcode"]]&&[[dict objectForKey:@"ITCODE"] isEqualToString:[[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] objectForKey:@"ITCODE"]]) {
                [_selectCombo removeObject:dict];
                break;
            }
        }
        btn.titleLabel1.text=@"";
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
        _total=1;
        
        btn.selected=YES;
        [[_selectArray lastObject] setObject:_selectCombo forKey:@"combo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        return;
    }
    _total=1;
    [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
    label.text=[NSString stringWithFormat:@"%d",_com+2];
    NSLog(@"%@",[[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] objectForKey:@"pmin"]);
    if (i<[[[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] objectForKey:@"tpmax"] intValue]) {
        if ([btn.titleLabel.text intValue]<[[[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] objectForKey:@"max"] intValue]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经到达这个菜的限购数量" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
        if (btn.selected==NO) {
            btn.titleLabel1.text=[NSString stringWithFormat:@"%d",[btn.titleLabel1.text intValue]+1];
        }else
        {
            btn.titleLabel1.text=@"1";
            btn.selected=NO;
        }
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
        _dataDic=dict;
        [dict setObject:@"1" forKey:@"total"];
        for (NSDictionary *dict1 in _selectCombo) {
            if ([[dict1 objectForKey:@"TPNUM"] intValue]==_z&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[_dataDic objectForKey:@"ITCODE"]]&&[dict1 objectForKey:@"addition"]==nil) {
                
                [dict setValue:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
                [_selectCombo removeObject:dict1];
                break;
            }
        }
        [dict setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
        [_selectCombo addObject:dict];
        [[_selectArray lastObject] setObject:_selectCombo forKey:@"combo"];
        if ([[_dataDic objectForKey:@"Weightflg"] intValue]==2) {
            [_dataDic setValue:@"2" forKey:@"Weightflg"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"确定",nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            tf1.delegate=self;
            alertView.tag=3;
            [alertView show];
        }
        else
        {
            [_dataDic setValue:@"0" forKey:@"Weight"];
            [_dataDic setValue:@"1" forKey:@"Weightflg"];
        }
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"This option can only choose one, please cancel the selected choose again"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
}
//套餐下面按钮的事件
-(void)comboConfirm:(UIButton *)btn
{
    if (btn.tag==1) {
        [self comboend];
    }else
    {
        aScrollView.frame=CGRectMake(80,175, 688, 740);
        _total=1;
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        if ([_ComButton count]>0) {
//            int j=[_selectArray count];
//            
            int y=0;
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[[[_dataArray objectAtIndex:_count] objectAtIndex:_btn] objectForKey:@"ITCODE"]]) {
                    y++;
                }
            }
            [_selectArray removeLastObject];
            if (y<=1) {
                 AKComboButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                button.selected=YES;
                button.lblCount.text=@"";
//                [[[button subviews] lastObject] removeFromSuperview];
                [self.view sendSubviewToBack:_view];
                //                for (UIButton *button in [_scroll subviews]) {
                //                    [button removeFromSuperview];
                //                }
            }else
            {
                AKComboButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                button.lblCount.text=[NSString stringWithFormat:@"%d",y-1];
//                UILabel *lb=[[button subviews] lastObject];
//                //                int x=[lb.text intValue];
//                lb.text=[NSString stringWithFormat:@"%d",y-1];
            }
            [_ComButton removeAllObjects];
            [_Combo removeAllObjects];
            [_selectCombo removeAllObjects];
            _com=0;
            for (UIView *button in [_scroll subviews]) {
                [button removeFromSuperview];
            }
            [self.view sendSubviewToBack:_view];
            aScrollView.frame=CGRectMake(80,175, 688, 740);
            [self updataTitle];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
}
-(void)comboend
{
    
    int x=0;
    int z=1;
    for (NSArray *array in _ComButton) {
        BOOL tag=YES;
        for (AKComboButton *button in array) {
            if (button.selected==NO) {
                x+=[button.titleLabel1.text intValue];
                tag=NO;
            }
        }
        /**
         *  判断是否满足最小数量，如果没有满足提示套餐没有选择完毕
         */
        if (tag&&[[[[_Combo objectAtIndex:z-1] lastObject] objectForKey:@"tpmin"] intValue]!=0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"Also have no choice"],z] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
            return;
        }
        z++;
    }
    int j=0,k=0,y=0;
    for (NSArray *array in _Combo) {
        j=j+[[[array lastObject] objectForKey:@"tpmin"] intValue];
        k=k+[[[array lastObject] objectForKey:@"tpmax"] intValue];
    }
    
    if (j<=x&&x<=k)
    {
        float mrMoney = 0.0;
        float tcMoney=[[[_selectArray lastObject] objectForKey:@"PRICE"] floatValue];
        /**
         *  计算套餐价格，addprice为加价
         */
//        for (NSDictionary *dict in _selectCombo) {
//            if ([[dict objectForKey:@"addprice"] floatValue]>0) {
//                tcMoney+=[[dict objectForKey:@"addprice"] floatValue]*[[dict objectForKey:@"total"] floatValue];
//            }
//        }
        for (NSDictionary *dict in _selectCombo) {
            if ([[dict objectForKey:@"addprice"] floatValue]>0) {
                tcMoney+=[[dict objectForKey:@"addprice"] floatValue]*[[dict objectForKey:@"total"] floatValue];
            }
        }
        [[_selectArray lastObject] setObject:[NSNumber numberWithFloat:tcMoney] forKey:@"PRICE"];
        //        float tcMoney=[[[_selectArray lastObject] objectForKey:@"PRICE"] floatValue];
        /**
         *  计算套餐明细价格
         */
        for (int i=0; i<[_selectCombo count]; i++) {
            
            NSDictionary *dict=[_selectCombo objectAtIndex:i];
            if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
                mrMoney+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
            }
            NSLog(@"%@",[dict objectForKey:@"PRICE"]);
            if ([dict objectForKey:@"total"]==nil) {
                [dict setValue:@"1" forKey:@"total"];
            }
            [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue]] forKey:@"PRICE"];
            mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
        }
        /**
         *  计算套餐的价格
         */
        for (int i=0; i<[_selectCombo count]; i++) {
            NSDictionary *dict=[_selectCombo objectAtIndex:i];
            float m_price1=[[dict objectForKey:@"PRICE"] floatValue];
            int TC_m_State=[[dict objectForKey:@"TCMONEYMODE"] floatValue];
            if(TC_m_State == 1)   //计价方式一
            {
                
                float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
                float tempMoney1=m_price1*tcMoney/mrMoney;
                //                    float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
            }
            else if(TC_m_State==2)
            {
                NSDictionary *dict1=[_selectArray lastObject];
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
            }else if (TC_m_State==3) {
                if (mrMoney<tcMoney) {
                    float tempMoney1=m_price1*tcMoney/mrMoney;
                    //                        float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                    [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
                }
                else
                {
                    NSDictionary *dict1=[_selectArray lastObject];
                    [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
                }
            }
            if (i==[_selectCombo count]-1) {
                float mrMoney1 = 0.0;
                //                    float tcMoney=[[[_selectArray objectAtIndex:[_selectArray count]-[arry count]+[_Combo count]-x-1] objectForKey:@"PRICE"] floatValue];
                
                for (int i=0; i<[_selectCombo count]; i++) {
                    
                    NSDictionary *dict=[_selectCombo objectAtIndex:i];
                    if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
                        mrMoney1+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
                    }else{
                        NSLog(@"%@",[dict objectForKey:@"PRICE"]);
                        mrMoney1+=[[dict objectForKey:@"PRICE"] floatValue];
                    }
                }
                
                if (mrMoney1!=tcMoney) {
                    for (int i=0; i<[_selectCombo count]; i++) {
                        NSDictionary *dict=[_selectCombo objectAtIndex:i];
                        
                        if ([[dict objectForKey:@"PRICE"] floatValue]>0) {
                            if ([[dict objectForKey:@"Weightflg"] intValue]!=2) {
                                float x=[[dict objectForKey:@"PRICE"] floatValue]+tcMoney-mrMoney1;
                                [dict setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE"];
                                break;
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        /**
         *  将最后一个菜品加入套餐数据
         */
        [[_selectArray lastObject] setObject:[NSArray arrayWithArray:_selectCombo] forKey:@"combo"];
        /**
         *  将套餐明细清空
         */
        [_Combo removeAllObjects];
        /**
         *  将选择的套餐清空
         */
        [_selectCombo removeAllObjects];
        /**
         *  提示套餐已经点完
         */
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"This package has chosen to complete"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        for (UIView *button in [_scroll subviews]) {
            [button removeFromSuperview];
        }
        label.text=[NSString stringWithFormat:@"%d",1];
        _com=0;
        [_ComButton removeAllObjects];
        if (_x<_total-1) {
            _x++;
            [self comboClick1:_button];
        }
        else
        {
            aScrollView.frame=CGRectMake(80,175, 688, 740);
            [self.view sendSubviewToBack:_view];
            _total=1;
            [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
            [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
            cishu=0;
        }
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前套餐还没有选择完毕，请检查后再点确认" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
    }
    
}
////点套餐
//-(void)comboClick1:(UIButton *)btn
//{
//    BSDataProvider *dp=[[BSDataProvider alloc] init];
//    arry=[dp combo:[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"ITCODE"]];
//    NSLog(@"%d",[_selectArray count]);
//    [_ComButton removeAllObjects];
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000]];
//    [dict setValue:@"1" forKey:@"total"];
//    NSLog(@"%@",dict);
//    [dict setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"count"];
//    _z=0;
//    for (NSDictionary *dict1 in _selectArray) {
//        if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[dict objectForKey:@"ITCODE"]]) {
//            _z++;
//        }
//    }
////
////    if ([_selectArray count]+[arry count]>40) {
////        UIButton *btn1=[[_buttonArray objectAtIndex:_count] objectAtIndex:btn.tag-10000];
////        UILabel *lb=[[btn1 subviews] lastObject];
////        int i=[lb.text intValue];
////        if (i>1) {
////            lb.text=[NSString stringWithFormat:@"%d",_z];
////        }else
////        {
////            btn.selected=YES;
////            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen.png"] forState:UIControlStateNormal];
////            [lb removeFromSuperview];
////        }
////        aScrollView.frame=CGRectMake(80,175, 688, 740);
////        [self.view sendSubviewToBack:_view];
////    }
//
//    [dict setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
//    [_selectArray addObject:dict];
//    _dataDic=dict;
//    [self updataTitle];
//    _btn=btn.tag-10000;
//
//    if ([arry count]==0) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"此套餐已点完" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//        [alert show];
//        aScrollView.frame=CGRectMake(80,175, 688, 740);
//        [self.view sendSubviewToBack:_view];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
//    }
//    else
//    {
//        NSMutableArray *array=[[NSMutableArray alloc] init];
//        for (NSArray *array1 in arry) {
//            if ([array1 count]==1) {
//                [[array1 lastObject] setValue:@"1" forKey:@"total"];
//                [[array1 lastObject] setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
////                [_tableArray addObject:[array1 lastObject]];
//                [_selectArray addObject:[array1 lastObject]];
////                [self reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
//            }
//            else{
//                [array addObject:array1];//可选择的套餐
//            }
//        }
//        _Combo=array;
//        if ([_Combo count]>0) {
////            [self reloadData];
//            [self comboShow:_com];
//        }else
//        {
////            [_tableArray removeAllObjects];
////            [_comboTableView reloadData];
//            aScrollView.frame=CGRectMake(80,175, 688, 740);
//            [self.view sendSubviewToBack:_view];
//        }
//
//    }
//
//}
//-(void)comboShow:(int)tag1{
//    if ([_ComButton count]==0) {
//        int j=0;
//        for (int i=0;i<[_Combo count];i++) {
//            int k=0;
//            NSMutableArray *array=[[NSMutableArray alloc] init];
//            for (NSDictionary *dict in [_Combo objectAtIndex:i]) {
//                AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
//                [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
//                btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
//                btn.btnTag=j;
//                btn.tag=k;
//                btn.selected=YES;
//                [btn setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//                btn.tintColor=[UIColor whiteColor];
//                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//                btn.tintColor=[UIColor whiteColor];
//                btn.titleLabel.numberOfLines=2;
//                btn.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
//                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
//                [array addObject:btn];
//                k++;
//                j++;
//            }
//            [_ComButton addObject:array];
//        }
//    }
//    //
//    int j=20;
//    for (int i=0; i<[_ComButton count]; i++) {
//        NSArray *array=[_ComButton objectAtIndex:i];
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,j, 678, ([array count]/6+1)*90+15)];
//        view.backgroundColor=[UIColor colorWithRed:200/255.0 green:239/255.0 blue:249/255.0 alpha:0.5];
////        view.backgroundColor=[UIColor ]
//        for (UIButton *btn in array) {
//            [view addSubview:btn];
//        }
//        [_scroll addSubview:view];
//        j=j+([array count]/6+1)*90+25;
//    }
//    [_scroll setContentSize:CGSizeMake(120*5+30,j)];
//}
//-(void)btnClick:(AKComboButton *)btn
//{
//    label.text=[NSString stringWithFormat:@"%d",_com+2];
////    for (UIButton *button in [_scroll subviews]) {
////        [button removeFromSuperview];
////    }
//    int j=0;
//    int k=0;
//    NSLog(@"%d",btn.tag);
//    for (NSArray *array in _ComButton) {
//        for (AKComboButton *button in array) {
//            if (btn.btnTag==button.btnTag) {
//                k++;
//                _com=j;
//            }
//        }
//        if (k>0) {
//            break;
//        }
//        j++;
//    }
//    if (btn.selected) {
//        int i=0;
//        for (AKComboButton *btn11 in [_ComButton objectAtIndex:_com]) {
//            if (btn11.selected==NO) {
//                i++;
//            }
//        }
//        if (i==0) {
//            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
//            btn.selected=NO;
//            [[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] setValue:@"1" forKey:@"total"];
//            [[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
////            [_tableArray addObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
////            [self reloadData];
//            [_selectArray addObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
//            _dataDic=[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag];
//            if ([[_dataDic objectForKey:@"Weightflg"] intValue]==2) {
//                [_dataDic setValue:@"2" forKey:@"Weightflg"];
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"确定",nil];
//                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//                UITextField *tf1 = [alertView textFieldAtIndex:0];
//                tf1.delegate=self;
//                alertView.tag=3;
//                [alertView show];
//            }
//            else
//            {
//                [_dataDic setValue:@"0" forKey:@"Weight"];
//                [_dataDic setValue:@"1" forKey:@"Weightflg"];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
//                int x=0;
//                for (NSArray *array in _ComButton) {
//                    for (AKComboButton *button in array) {
//                        if (button.selected==NO) {
//                            x++;
//                        }
//                    }
//                }
//            NSLog(@"%d",x);
//            if (x!=[_ComButton count]) {
//                _com=0;
//            }
//            else
//            {
//                float mrMoney = 0.0;
//                float tcMoney=[[[_selectArray objectAtIndex:([_selectArray count]-[arry count]-1)] objectForKey:@"PRICE"] floatValue];
//                for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
//
//                    NSDictionary *dict=[_selectArray objectAtIndex:i];
//                    if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
//                        mrMoney+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
//                    }
//                    NSLog(@"%@",[dict objectForKey:@"PRICE"]);
//                    mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
//                }
//                for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
//                    NSDictionary *dict=[_selectArray objectAtIndex:i];
//                    float m_price1=[[dict objectForKey:@"PRICE"] floatValue];
//                    int TC_m_State=[[dict objectForKey:@"TCMONEYMODE"] floatValue];
//                    if(TC_m_State == 1)   //计价方式一
//                    {
//
//                        float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
//                        float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
//                        [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
//                    }
//                    else if(TC_m_State==2)
//                    {
//                        NSDictionary *dict1=[_selectArray objectAtIndex:[_selectArray count]-[arry count]-1];
//                        [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
//                    }else if (TC_m_State==3) {
//                        if (mrMoney<tcMoney) {
//                            float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
//                            float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
//                            [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
//                        }
//                        else
//                        {
//                            NSDictionary *dict1=[_selectArray objectAtIndex:[_selectArray count]-[arry count]-1];
//                            [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
//                        }
//                    }
//                    float mrMoney = 0.0;
//                    float tcMoney=[[[_selectArray objectAtIndex:([_selectArray count]-[arry count]-1)] objectForKey:@"PRICE"] floatValue];
//                    for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
//
//                        NSDictionary *dict=[_selectArray objectAtIndex:i];
//                        if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
//                            mrMoney+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
//                        }
//                        NSLog(@"%@",[dict objectForKey:@"PRICE"]);
//                        mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
//                    }
//                    if (mrMoney!=tcMoney) {
//                        for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
//                            NSDictionary *dict=[_selectArray objectAtIndex:i];
//
//                            if ([[dict objectForKey:@"PRICE"] floatValue]>0) {
//                                if ([[dict objectForKey:@"Weightflg"] intValue]!=2) {
//                                    float x=[[dict objectForKey:@"PRICE"] floatValue]+tcMoney-mrMoney;
//                                    [dict setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE"];
//                                    break;
//                                }
//
//                            }
//                        }
//                    }
//                }
//                NSLog(@"%@",_selectArray);
//                [_Combo removeAllObjects];
////                [_tableArray removeAllObjects];
////                [self reloadData];
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"这一个套餐已点完" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//                [alert show];
//                for (UIView *button in [_scroll subviews]) {
//                    [button removeFromSuperview];
//                }
//                label.text=[NSString stringWithFormat:@"%d",1];
//                _com=0;
//                [_ComButton removeAllObjects];
//                if (_x<_total-1) {
//                    _x++;
//                    [self comboClick1:_button];
//                }
//                else
//                {
//                    aScrollView.frame=CGRectMake(80,175, 688, 740);
//                    [self.view sendSubviewToBack:_view];
//                    _total=1;
//                    [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
//                    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
//                    cishu=0;
//                }
//            }
//
//        }
//        else
//        {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"这一选项中只能选择一个,请取消已选的再选择" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//            [alert show];
////            [self comboShow:_com];
//        }
//    }
//    else
//    {
//        [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
//        [_selectArray removeObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
////        [self comboShow:_com];
//        btn.selected=YES;
//    }
////    [self reloadData];
//}
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)segmentClick1:(UIButton *)sender
//{
//    if ([_Combo count]>0) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
//    for (AKOrederClassButton *btn in [aScrollView subviews]) {
//        [btn removeFromSuperview];
//    }
//    //    _count=sender.selectedSegmentIndex;
//    [self button:sender.tag];
//}
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment
{
    if(![segmentIndex isEqualToString:@"X"])
    {
        if([[NSString stringWithFormat:@"%d",_total]length]>1)
        {
            _total=1;
            cishu=0;
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
        else
        {
            int index=[segmentIndex intValue];
            cishu=cishu*10+index;
            _total=cishu;
            NSLog(@"%d",_total);
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
    }
    else
    {
        _total=1;
        cishu=0;
        [segment setSelectedSegmentIndex:11];
        [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
    }
}



- (IBAction)alreadyBuyGreens:(id)sender//已点菜品
{
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的套餐还没有选择完毕" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSArray *foods =[[NSArray alloc] initWithArray:_selectArray];
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    for (int i=0; i<[foods count]; i++) {
        //        for (int j=0; j<[[[foods objectAtIndex:i] objectForKey:@"total"] intValue]; j++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict1=[[NSMutableDictionary alloc] initWithDictionary:[_selectArray objectAtIndex:i]];
        [dict1 setObject:@"UNIT" forKey:@"unitKey"];
        [array1 addObject:dict1];
    }
    [Singleton sharedSingleton].dishArray=array1;
    BSLogViewController *vbsvc=[[BSLogViewController alloc] init];
    [self.navigationController pushViewController:vbsvc animated:YES];
}
- (IBAction)Beizhu:(UIButton *)sender {
    if ([_dataDic count]>0) {
        if (!vAddition){
            vAddition = [[BSAddtionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withPcode:[_dataDic objectForKey:@"ITCODE"]];
            vAddition.delegate = self;
            
            //        vAddition.arySelectedAddtions=;
        }
        if (!vAddition.superview){
            vAddition.center = CGPointMake(self.view.center.x,924+self.view.center.y);
            [vAddition.arySelectedAddtions removeAllObjects];
            vAddition.arySelectedAddtions=[NSMutableArray arrayWithArray:[_dataDic objectForKey:@"addition"]];
            [vAddition.tv reloadData];
            [self.view addSubview:vAddition];
            [vAddition firstAnimation];
        }
        else{
            [vAddition removeFromSuperview];
            vAddition = nil;
        }
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择菜" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)goBack:(id)sender//返回
{
    
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前套餐没有选择完毕，请将该套餐选择完毕或取消之后再返回" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        [alert show];
        return;
    }
    if ([_selectArray count]>0&&![Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save the dishes"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],[[CVLocalizationSetting sharedInstance] localizedString:@"NO"], nil];
        alert.tag=1;
        alert.delegate=self;
        [alert show];
    }
    else if (![AKsNetAccessClass sharedNetAccess].isVipShow)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (1==buttonIndex){
            NSMutableArray *array=[[NSMutableArray alloc] initWithArray:_selectArray];
            int i=0,j=0;
            for (NSDictionary *dict in _selectArray) {
                if (![dict objectForKey:@"isShow"]&&[[dict objectForKey:@"ISTC"] intValue]==1) {
                    NSRange range = NSMakeRange(i+1+j,[[dict  objectForKey:@"combo"] count]);
                    j=[[dict objectForKey:@"combo"] count];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                    [array insertObjects:[dict objectForKey:@"combo"] atIndexes:indexSet];
                }
                i++;
            }
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [dp cache:array];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
            
        }else if (2==buttonIndex){
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
        }
        
    }
    else  if (alertView.tag==10001)
    {
        [akmsav setsegmentIndex:@"11"];
        [akmsav setTitle:@"1"];
        _total=1;
    }
    
    if (alertView.tag==3) {
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        
        if (1==buttonIndex) {
            [_dataDic setValue:@"1" forKey:@"total"];
            [_dataDic setValue:@"2" forKey:@"Weightflg"];
            [_dataDic setValue:tf1.text forKey:@"Weight"];
            [_selectArray addObject:_dataDic];
            _y++;
            [self WeightFlg];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        }
        else
        {
            _y++;
            [self WeightFlg];
        }
    }
}
-(void)PackageGroup
{
    NSMutableArray *comboAll=[NSMutableArray array];
    for (NSDictionary *dict in _allComboArray) {
        for (NSArray *array in [dict objectForKey:@"combo"]) {
            [comboAll addObjectsFromArray:array];
        }
        
    }
    int x=0;
    for (NSDictionary *dictAll in comboAll) {
        for (NSDictionary *dictSelect in _selectArray) {
            if ([[dictSelect objectForKey:@"ISTC"] intValue]!=1) {
                [dictAll setValue:@"0" forKey:@"count"];
            }
        }
    }
    for (NSDictionary *dictAll in comboAll) {
        for (NSDictionary *dictSelect in _selectArray) {
            if ([[dictSelect objectForKey:@"ISTC"] intValue]!=1) {
                if ([[dictSelect objectForKey:@"ITCODE"] isEqualToString:[dictAll objectForKey:@"ITCODE"]]) {
                    [dictAll setValue:[dictSelect objectForKey:@"total"] forKey:@"count"];
                    x++;
                }
            }
        }
    }
    comboFinish=[NSMutableArray array];//可选择套餐
    onlyOne=[NSMutableArray array];//推荐套餐
    for (int i=0;i<[_allComboArray count];i++) {//所有的套餐
        NSMutableArray *array=[[_allComboArray objectAtIndex:i] objectForKey:@"combo"];//单个套餐
        NSMutableArray *ary2=[NSMutableArray array];
        for (int k=0;k<[array count];k++) {//套餐里的层
            NSMutableArray *ary=[array objectAtIndex:k];
            int j=0;
            
            NSMutableArray *ary1=[NSMutableArray array];
            for (NSDictionary *dict in ary) {//该层里的菜
                NSMutableDictionary *dicFood=[NSMutableDictionary dictionary];
                if ([[dict objectForKey:@"pmin"] intValue]<=[[dict objectForKey:@"count"] intValue]&&[[dict objectForKey:@"count"] intValue]!=0&&[[dict objectForKey:@"tpmax"] intValue]>=j+1) {//判断数量是不是在该菜的范围
                    if ([[dict objectForKey:@"pmin"] intValue]==0) {
                        j+=1;
                    }else
                        j+=[[dict objectForKey:@"pmin"] intValue];
                    [ary1 addObject:dict];
                }
                if (dict==[ary lastObject]) {//判断最后一个菜
                    if (j>=[[dict objectForKey:@"tpmin"] intValue]&&j!=0) {//判断是否在套餐的范围内
                        [dicFood setObject:ary1 forKey:@"food"];
                        [dicFood setObject:[NSString stringWithFormat:@"%d",k] forKey:@"num"];
                        [ary2 addObject:dicFood];//选择的菜
                    }
                }
            }
            if (k==[array count]-1) {//判断套餐的最后一个菜
                //                for (NSArray *ary in array) {
                //                    if ([[[ary lastObject] objectForKey:@"tpmin"] intValue]!=0) {
                //
                //                    }
                //                }
                if ([ary2 count]==[array count]) {//判断是否符合套餐
                    [comboFinish addObject:ary2];
                }
                if ([ary2 count]==[array count]-1) {//判断是否符合推荐套餐
                    int z=0;
                    BOOL isy=NO;
                    
                    
                    for (int y=0;y<[ary2 count];y++) {
                        if ([[[ary2 objectAtIndex:y] objectForKey:@"num"] intValue]!=y) {
                            z=y;
                            isy=YES;
                            break;
                        }
                    }
                    if (!isy) {
                        z=[ary2 count];
                    }
                    NSMutableDictionary *dict10=[[NSMutableDictionary alloc] init];
                    [dict10 setObject:ary2 forKey:@"food"];
                    [dict10 setObject:[array objectAtIndex:z] forKey:@"combo"];
                    int b=0;
                    for (int a=0; a<[[array objectAtIndex:z] count];a++) {
                        b+=[[[[array objectAtIndex:z] objectAtIndex:a] objectForKey:@"count"] intValue];
                    }
                    if ((b+1==[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]&&[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]!=0)||[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]==0) {
                        [onlyOne addObject:dict10];
                    }
                    if ([[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]==0) {
                        [comboFinish addObject:ary2];
                    }
                    
                }
            }
        }
    }
    for(UIView *view in [_RecommendView subviews])
    {
        [view removeFromSuperview];
    }
    if ([comboFinish count]!=0||[onlyOne count]!=0) {
        
        UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 660, 400)];
        [image1 setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"recommendBG.png"]];
        [_RecommendView addSubview:image1];
        int h=0;
        if ([comboFinish count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 660,30)];
            lb.text=@"可组成套餐";
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textColor=[UIColor redColor];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int y=0;
            for (NSArray *ary11 in comboFinish) {
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(y%5*135,y/5*90+50,120,80);
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                [button setTitle:[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"tpname"] forState:UIControlStateNormal];
                //                button.titleLabel.text=[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"tpname"];
                NSLog(@"%@",[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"tpname"]);
                //                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.tag=y+1;
                button.titleLabel.numberOfLines=0;
                button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                [button addTarget:self action:@selector(makePackage:) forControlEvents:UIControlEventTouchUpInside];
                y++;
                [_RecommendView addSubview:button];
                h=button.frame.origin.y+button.frame.size.height;
            }
            _recommendButton.hidden=NO;
        }
        //        _RecommendView.backgroundColor=[UIColor lightGrayColor];
        if ([onlyOne count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+20, 660,30)];
            lb.text=@"推荐套餐";
            lb.textColor=[UIColor redColor];
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int j=0;
            for (NSDictionary *dict in onlyOne) {
                int i=0;
                NSArray *array=[dict objectForKey:@"combo"];
                UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+50, 476, 30)];
                lb.text=[NSString stringWithFormat:@"选择可构成%@",[[array lastObject] objectForKey:@"tpname"]];
                lb.textColor=[UIColor redColor];
                [_RecommendView addSubview:lb];
                for (NSDictionary *dict in array) {
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake(i%5*135,h+i/5*90+80,120,80);
                    [button setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                    [button setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
                    button.titleLabel.numberOfLines=0;
                    button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    button.tag=10000*(j+1)+i;
                    [button addTarget:self action:@selector(makePackage:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_RecommendView addSubview:button];
                    i++;
                }
                j++;
                h+=120;
                [_RecommendView setContentSize:CGSizeMake(650,h+50)];
                
                
            }
            
            [_RecommendView sendSubviewToBack:self.view];
            _RecommendView.hidden=YES;
            _recommendButton.hidden=NO;
        }
        image1.frame=CGRectMake(0, 0, 660, h+50);
    }else
    {
        _recommendButton.hidden=YES;
    }
}
-(void)makePackage:(UIButton *)btn
{
    /**
     *  array代表已经选择的菜品
     */
    NSMutableArray *array=[NSMutableArray array];
    /**
     *  当tag>=10000时，说明是推荐套餐，反之是组合成的套餐
     */
    if (btn.tag>=10000) {
        /**
         *  获得可注册套餐的菜品
         */
        for (NSDictionary *dict in [[onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"food"]) {
            /**
             *  将已经选择的菜品放入数组中
             */
            for (NSDictionary *dict1 in [dict objectForKey:@"food"]) {
                [array addObject:[NSMutableDictionary dictionaryWithDictionary:dict1]];
            }
//            [array addObjectsFromArray:[NSMutableArray arrayWithArray:]];
        }
        /**
         *  获取选择的菜品
         */
        [[[[onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000] setObject:@"1" forKey:@"total"];
//        [array addObject:[NSMutableDictionary dictionaryWithDictionary:[[[onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000]]];
        [array addObject:[NSMutableDictionary dictionaryWithDictionary:[[[onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000]]];
    }else
    {
        /**
         *  组合成套餐的菜品
         */
        for (NSDictionary *fooddic in [comboFinish objectAtIndex:btn.tag-1]) {
            [array addObjectsFromArray:[[NSArray alloc] initWithArray:[fooddic objectForKey:@"food"]]];
        }
    }
    //ary已经点的菜品
    NSMutableArray *ary=[[NSMutableArray alloc] initWithArray:_selectArray];
    int i=0;
    int k=0;
    /**
     *  将组合成套餐的菜品从数组里删除
     */
    for (NSDictionary *dict in array) {
        int j=0;
        for (NSDictionary *food in ary) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:[food objectForKey:@"ITCODE"]]) {
                if ([[dict objectForKey:@"count"] intValue]>=[[food objectForKey:@"total"] intValue]) {
                    [_selectArray removeObject:food];
                    [dict setValue:[dict objectForKey:@"count"] forKey:@"total"];
                    
                    //                    j已点菜数组第几个
                    //                    k去掉几个菜
                    //
                    k++;
                }else
                {
                    [[_selectArray objectAtIndex:j-k] setObject:[NSString stringWithFormat:@"%d",[[food objectForKey:@"total"] intValue]-[[dict objectForKey:@"count"] intValue] ] forKey:@"total"];
                    
                }
            }
            j++;
        }
        i++;
    }
    int j=0;
    /**
     *  计算套餐标示TPNUM
     */
    for (NSDictionary *dic in _selectArray) {
        if ([[dic objectForKey:@"Tpcode"]isEqualToString:[[array lastObject] objectForKey:@"Tpcode"]]) {
            j++;
        }
    }
    for (NSDictionary *dict1 in array) {
        [dict1 setValue:[NSString stringWithFormat:@"%d",j] forKey:@"TPNUM"];
    }
    /**
     *  拼接组合成套餐的数据
     */
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",j] forKey:@"TPNUM"];
    [dict setObject:[[array lastObject] objectForKey:@"Tpcode"] forKey:@"Tpcode"];
    [dict setObject:[[array lastObject] objectForKey:@"tpname"] forKey:@"DES"];
    [dict setObject:[[array lastObject] objectForKey:@"Tpcode"] forKey:@"ITCODE"];
    [dict setObject:[[array lastObject] objectForKey:@"tpprice"] forKey:@"PRICE"];
    [dict setObject:@"1" forKey:@"total"];
    [dict setObject:@"1" forKey:@"ISTC"];
//    NSArray *ary1=[[NSArray alloc] initWithArray:array];
    [dict setObject:array forKey:@"combo"];
    _selectCombo=array;
    onlyOne=nil;
    comboFinish=nil;
    
    [_selectArray addObject:dict];
    _RecommendView.hidden=YES;
    _recommendButton.hidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [self comboend];
    [self changeButtonColor];
    
}
#pragma mark  AKMySegmentAndViewDelegate
-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage
{
    if(isShowVipMessage)
    {
        [showVip removeFromSuperview];
        showVip=nil;
    }
    else
    {
        showVip=[[AKsIsVipShowView alloc]initWithArray:array];
        [self.view addSubview:showVip];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}
@end
