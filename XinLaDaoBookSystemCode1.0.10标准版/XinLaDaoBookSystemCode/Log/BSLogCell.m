//
//  BSLogCell.m
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSLogCell.h"
#import "BSAdditionCell.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"


@implementation BSLogCell
{
    BSAddtionView *vAddition;
}
@synthesize fCount,delegate,dicInfo,lblAdditionPrice,aryAdditions,arySelectedAdditions,aryCustomAddition,arySearchMatched,tfPrice,lblUnit,indexPath,lblName,lblTotalPrice,lblAddition,tfCount,lblSelected,btnAdd,btnReduce,jia,jian,lb,lblLine,supTableView,btnEdit;
//lblName,*lblTotalPrice,*lblAddition,*lblAdditionPrice,*lblUnit
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.arySearchMatched = [NSMutableArray arrayWithArray:self.aryAdditions];
        
        self.arySelectedAdditions = [[NSMutableArray alloc] init];
        self.aryCustomAddition = [NSMutableArray array];
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        imgvFood = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 122, 96)];
        //        [self.contentView addSubview:imgvFood];
        //        [imgvFood release];
        //        imgvFood.userInteractionEnabled = YES;
        //        UIButton *btnunit = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btnunit.frame = imgvFood.bounds;
        //        [self.contentView addSubview:btnunit];
        //        [btnunit addTarget:self action:@selector(changeUnit) forControlEvents:UIControlEventTouchUpInside];
        
        float fNoPhotoOffset = kNoPhotoOffset;
        
        //        此处修改了lable坐标，让已点菜品名称尽量显示全面
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 160, 50)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:16];
        lblName.numberOfLines =0;
        lblName.lineBreakMode = UILineBreakModeWordWrap;     //指定换行模式
        lblName.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lblName];
        
        NSString *countpath = [[NSBundle mainBundle] pathForResource:@"LogCellCountBtn" ofType:@"png"];
        
        tfCount = [[UILabel alloc] initWithFrame:CGRectMake(109*2, 10,109, 30)];
//        tfCount.backgroundColor = [UIColor whiteColor];
        tfCount.backgroundColor=[UIColor lightGrayColor];
        tfCount.textColor=[UIColor redColor];
        tfCount.textAlignment=NSTextAlignmentCenter;
        tfCount.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:tfCount];
        jia=[UIButton buttonWithType:UIButtonTypeCustom];
        jia.frame=CGRectMake(109*2-20,-5, 40, 40);
        [jia setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Add.png"] forState:UIControlStateNormal];
        [jia addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        jia.tag=1;
        [self.contentView addSubview:jia];
        jian=[UIButton buttonWithType:UIButtonTypeCustom];
        jian.frame=CGRectMake(109*3-20,-5, 40, 40);
        [jian setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Subtract.png"] forState:UIControlStateNormal];
        jian.tag=2;
        [jian addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:jian];
        tfPrice = [[UILabel alloc] initWithFrame:CGRectMake(109*3, 15, 109, 25)];
        tfPrice.backgroundColor = [UIColor clearColor];
        tfPrice.textAlignment=UITextAlignmentRight;
        tfPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:tfPrice];
        
        lblUnit = [[UILabel alloc] init];
        
        lblUnit.textAlignment=NSTextAlignmentCenter;
        lblUnit.font = [UIFont systemFontOfSize:16];
        lblUnit.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblUnit];
        
        UIButton *btnunit = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.contentView addSubview:btnunit];
        [btnunit addTarget:self action:@selector(changeUnit) forControlEvents:UIControlEventTouchUpInside];
        lblTotalPrice = [[UILabel alloc] init ];
        
        lblTotalPrice.textAlignment=NSTextAlignmentRight;
        lblTotalPrice.backgroundColor = [UIColor clearColor];
        lblTotalPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lblTotalPrice];
        lb=[[UILabel alloc] initWithFrame:CGRectMake(75, 45, 100, 25)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor grayColor];
        [self.contentView addSubview:lb];
        lblAddition = [[UILabel alloc] initWithFrame:CGRectMake(170, 45, 440, 25)];
        lblAddition.backgroundColor = [UIColor clearColor];
        lblAddition.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lblAddition];
        //        lblAddition.text = [langSetting localizedString:@"Additions:"];//@"附加项:";
        
        btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btnAdd setImage:imgPlusNormal forState:UIControlStateNormal];
        //        [btnAdd setImage:imgPlusPressed forState:UIControlStateHighlighted];
        [btnAdd sizeToFit];
        [self.contentView addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Present.png"] forState:UIControlStateNormal];
        btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReduce setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Delect.png"] forState:UIControlStateNormal];
        //        [btnReduce setImage:imgMinusNormal forState:UIControlStateNormal];
        //        [btnReduce setImage:imgMinusPressed forState:UIControlStateHighlighted];
        [btnReduce sizeToFit];
        //btnReduce.center = CGPointMake(109*6+90, 30);//620,30,675,30
        
        [self.contentView addSubview:btnReduce];
        [btnReduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
        btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnEdit.frame = CGRectMake(109*5.7+45, 10, 60, 40);
        [btnEdit setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Addition.png"] forState:UIControlStateNormal];
        [btnEdit sizeToFit];
        
        [self.contentView addSubview:btnEdit];
        [btnEdit addTarget:self action:@selector(setAddition) forControlEvents:UIControlEventTouchUpInside];
        
        
//        lblSelected = [UILabel createLabelWithFrame:CGRectMake(70-fNoPhotoOffset, 44, 50, 22) font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor redColor]];
//        lblSelected.textAlignment = UITextAlignmentCenter;
//        [self.contentView addSubview:lblSelected];
        lblUnit.Frame=CGRectMake(109*4, 15, 109, 25);
        lblTotalPrice.frame= CGRectMake(109*5-20, 15, 100, 25);
        
        btnAdd.frame=CGRectMake(109*5.7, 10, 40, 40);
        btnReduce.frame=CGRectMake(109*5.7+110, 10, 40, 40);
        lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 768, 2)];
        lblLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:lblLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)countchange:(UIButton *)btn
{
    if (btn.tag==1) {
        [delegate cell:self count:1];
    }else if(btn.tag==2){
        NSLog(@"%f",fCount);
        if ([tfCount.text intValue]-1>0) {
            [delegate cell:self count:-1];
        }
        else
        {
            [self reduce];
        }
        
    }
}



#pragma mark Handle Button Events
- (void)add{
    NSLog(@"1");
    //    fCount += 1.0f;
    //    tfCount.text = [NSString stringWithFormat:@"%.2f",fCount];
    //    lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",[tfPrice.text floatValue]*fCount];
    BOOL ZS;
    if ([self.lblTotalPrice.text floatValue]!=[[NSString stringWithFormat:@"%.2f",[self.tfPrice.text floatValue]*[self.tfCount.text floatValue]] floatValue]) {
        ZS=NO;
    }
    else
    {
        ZS=YES;
    }
    
    [delegate cell:self present:ZS];
    //    lblTotalPrice.text=[NSString stringWithFormat:@"0"];
    //    [delegate cell:self countChanged:fCount];
}

- (void)reduce{
    if (fCount-1>0){
        fCount -= 1.0f;
        tfCount.text = [NSString stringWithFormat:@"%.2f",fCount];
        lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",[tfPrice.text floatValue]*fCount];
        [delegate cell:self countChanged:fCount];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确定要从列表中移除这个菜品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"移除", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"移除"]){
        //        [self.arySelectedAdditions removeAllObjects];
        [delegate cell:self countChanged:0];
    }
}

#pragma mark bSelected's Getter & Setter
- (BOOL)bSelected{
    return bSelected;
}

- (void)setBSelected:(BOOL)bSelected_{
    bSelected = bSelected_;
    
    if (bSelected){
        lblSelected.backgroundColor = [UIColor colorWithRed:0.0f green:155.0f/255.0f blue:52.0f/255.0f alpha:1.0f];
        lblSelected.text = @"叫起";
        //        for (UILabel *lbl in self.contentView.subviews){
        //            if ([lbl isKindOfClass:[UILabel class]])
        //                lbl.textColor = [UIColor whiteColor];
        //        }
    }
    else{
        lblSelected.backgroundColor = [UIColor clearColor];
        lblSelected.text = nil;
        //        for (UILabel *lbl in self.contentView.subviews){
        //            if ([lbl isKindOfClass:[UILabel class]])
        //                lbl.textColor = [UIColor blackColor];
        //        }
    }
}

- (void)setAddition{
    self.supTableView.userInteractionEnabled=NO;
    if (!pop){
        vAddition = [[BSAddtionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withPcode:[dicInfo objectForKey:@"ITCODE"]];
        vAddition.delegate = self;
        
        [self.window addSubview:vAddition];
        vAddition.arySelectedAddtions=[[NSMutableArray alloc] initWithArray:self.arySelectedAdditions];
        //        UIViewController *vc = [[UIViewController alloc] init];
        //
        //        vAddition = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        //        barAddition = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        //        barAddition.barStyle = UIBarStyleDefault;
        //        barAddition.delegate = self;
        //        [vAddition addSubview:barAddition];
        //        [vc.view addSubview:vAddition];
        //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //        //      [btn setTitle:@"+" forState:UIControlStateNormal];
        //        btn.frame = CGRectMake(150, 0, 50, 50);
        //        [vAddition addSubview:btn];
        //        [btn addTarget:self action:@selector(addCustiomAddition) forControlEvents:UIControlEventTouchUpInside];
        //
        //        tvAddition = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 200, 250) style:UITableViewStylePlain];
        //        tvAddition.delegate = self;
        //        tvAddition.backgroundColor=[UIColor whiteColor];
        //        tvAddition.dataSource = self;
        //        [vc.view addSubview:tvAddition];
        //        pop = [[UIPopoverController alloc] initWithContentViewController:vc];
        //        [pop setPopoverContentSize:CGSizeMake(200, 300)];
    }
    [pop presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)additionSelected:(NSArray *)ary{
    self.supTableView.userInteractionEnabled=YES;
    if (ary!=nil) {
        [delegate cell:self additionChanged:[NSMutableArray arrayWithArray:ary]];
    }
    [vAddition removeFromSuperview];
}


#pragma mark TableView Delegate
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *aryCustom = [self.dicInfo objectForKey:@"addition"];
    //    NSMutableArray *aryCustomDics = [NSMutableArray array];
    //    int count = [aryCustomAddition count];
    
    NSArray *ary = arySearchMatched;
    static NSString *identifier = @"AdditionCell";
    
    BSAdditionCell *cell = (BSAdditionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSAdditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
    }
    NSDictionary *dict;
    dict = [ary objectAtIndex:indexPath.row];
    NSLog(@"%@",dict);
    
    [cell setContent:dict withTag:1];
    BOOL isSelected = NO;
    for (NSDictionary *dic in arySelectedAdditions){
        if ([[dict objectForKey:@"FoodFuJia_Des"] isEqualToString:[dic objectForKey:@"FoodFuJia_Des"]])
            isSelected = YES;
    }
    NSLog(@"%@",aryCustomAddition);
    for (NSDictionary *dic in aryCustomAddition){
        if ([[dict objectForKey:@"FoodFuJia_Des"] isEqualToString:[dic objectForKey:@"FoodFuJia_Des"]])
            isSelected = YES;
    }
    cell.bSelected = isSelected;
    return cell;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [aryAdditions count]+[aryCustomAddition count];
    return [arySearchMatched count];
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//附加项的选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictSelected = [arySearchMatched objectAtIndex:indexPath.row];
    if ([aryCustomAddition containsObject:dictSelected]) {
        [aryCustomAddition removeObjectAtIndex:indexPath.row];
        [arySearchMatched removeObjectAtIndex:indexPath.row];
    }
    else{
        BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.bSelected = !cell.bSelected;
        BOOL needAdd = YES;
        int index = -1;
        
        for (NSDictionary *dicAdd in arySelectedAdditions){
            if ([[dicAdd objectForKey:@"FoodFuJia_ID"] isEqualToString:[dictSelected objectForKey:@"FoodFuJia_ID"]]){
                needAdd = NO;
                index = [arySelectedAdditions indexOfObject:dicAdd];
                break;
            }
        }
        
        if (cell.bSelected && needAdd)
            [arySelectedAdditions addObject:[arySearchMatched objectAtIndex:indexPath.row]];
        else{
            [arySelectedAdditions removeObject:[arySearchMatched objectAtIndex:indexPath.row]];
            //            [arySelectedAdditions removeObjectAtIndex:index];
        }
        
    }
    
    NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
    [aryAll addObjectsFromArray:aryCustomAddition];
    
    
    NSMutableDictionary *dictNew = [NSMutableDictionary dictionaryWithDictionary:self.dicInfo];
    if ([aryAll count]>0)
        [dictNew setObject:aryAll forKey:@"addition"];
    else
        [dictNew removeObjectForKey:@"addition"];
    
    [delegate cell:self additionChanged:aryAll];
    [tvAddition reloadData];
    
    [barAddition resignFirstResponder];
    //    NSDictionary *dictSelected = [arySearchMatched objectAtIndex:indexPath.row];
    //    if ([aryCustomAddition containsObject:dictSelected]) {
    //        [aryCustomAddition removeObjectAtIndex:indexPath.row];
    //        [arySearchMatched removeObjectAtIndex:indexPath.row];
    //    }
    //    else{
    //        BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    //        cell.bSelected = !cell.bSelected;
    //        BOOL needAdd = YES;
    //        int index = -1;
    //
    //        for (NSDictionary *dicAdd in arySelectedAdditions){
    //            if ([[dicAdd objectForKey:@"FoodFuJia_Des"] isEqualToString:[dictSelected objectForKey:@"FoodFuJia_Des"]]){
    //                needAdd = NO;
    //                index = [arySelectedAdditions indexOfObject:dicAdd];
    //                break;
    //            }
    //        }
    //        if (cell.selected && needAdd)
    //            [arySelectedAdditions addObject:[arySearchMatched objectAtIndex:indexPath.row]];
    //        else if (!cell.bSelected && !needAdd){
    //            [arySelectedAdditions removeObjectAtIndex:index];
    //        }
    ////         NSLog(@"%@",[[arySelectedAdditions objectAtIndex:0] objectForKey:@"FoodFuJia_Des"]);
    //
    //    }
    //
    //    NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
    //    [aryAll addObjectsFromArray:aryCustomAddition];
    //    NSLog(@"%@",aryAll);
    //    NSMutableDictionary *dictNew = [NSMutableDictionary dictionaryWithDictionary:self.dicInfo];
    //    if ([aryAll count]>0)
    //        [dictNew setObject:aryAll forKey:@"addition"];
    //    else
    //        [dictNew removeObjectForKey:@"addition"];
    //    NSLog(@"%@",aryAll);
    //    [delegate cell:self additionChanged:aryAll];
    //    [tvAddition reloadData];
    //    [barAddition resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)countClicked{
    if (!popCount){
        UIViewController *vc = [[UIViewController alloc] init];
        
        
        
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 130, 196)];
        picker.showsSelectionIndicator = YES;
        picker.delegate = self;
        picker.dataSource = self;
        picker.tag = 999;
        [vc.view addSubview:picker];
        
        popCount = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popCount setPopoverContentSize:CGSizeMake(130, 196)];
    }
    
    UIPickerView *pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:999];
    if  (!pickerView) {
        pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:kPriceTag];
        if (!pickerView) {
            pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:kCountTag];
        }
    }
    pickerView.tag = kCountTag;
    
    int row = (int)fCount;
    int component = (((int)(fCount*10))%10);
    int count3 = (((int)(fCount*100))%10);
    [pickerView selectRow:row inComponent:0 animated:NO];
    [pickerView selectRow:component inComponent:1 animated:NO];
    [pickerView selectRow:count3 inComponent:2 animated:NO];
    [pickerView reloadAllComponents];
}

- (void)priceClicked{
    if (!popCount){
        UIViewController *vc = [[UIViewController alloc] init];
        
        
        
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 130, 196)];
        picker.showsSelectionIndicator = YES;
        picker.delegate = self;
        picker.dataSource = self;
        picker.tag = 999;
        [vc.view addSubview:picker];
        
        popCount = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popCount setPopoverContentSize:CGSizeMake(130, 196)];
    }
    
    UIPickerView *pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:999];
    if  (!pickerView) {
        pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:kCountTag];
        if (!pickerView) {
            pickerView = (UIPickerView *)[popCount.contentViewController.view viewWithTag:kPriceTag];
        }
    }
    pickerView.tag = kPriceTag;
    
    
    int row = (int)fPrice;
    int component = (((int)(fPrice*10))%10);
    int count3 = (((int)(fPrice*100))%10);
    [pickerView selectRow:row inComponent:0 animated:NO];
    [pickerView selectRow:component inComponent:1 animated:NO];
    [pickerView selectRow:count3 inComponent:2 animated:NO];
    [pickerView reloadAllComponents];
    //    [popCount presentPopoverFromRect:btnPrice.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d",row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (kCountTag==pickerView.tag)
        return 0==component?100:10;
    else
        return 0==component?1000:10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 0==component?50:30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    float value;
    int index0 = [pickerView selectedRowInComponent:0];
    int index1 = [pickerView selectedRowInComponent:1];
    int index2 = [pickerView selectedRowInComponent:2];
    
    value = index0+(float)index1*0.1f+(float)index2*0.01f;
    
    
    if (kCountTag==pickerView.tag){
        fCount = value;
        tfCount.text = [NSString stringWithFormat:@"%.2f",fCount];
        lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",fPrice*fCount];
        [delegate cell:self countChanged:fCount];
    }
    else{
        fPrice = value;
        tfPrice.text = [NSString stringWithFormat:@"%.2f",fPrice];
        lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",fPrice*fCount];
        [delegate cell:self priceChanged:fPrice];
    }
    
}


- (void)addCustiomAddition{
    NSLog(@"qwertyuiop");
    if ([barAddition.text length]>0){
        for (NSDictionary *dic in aryCustomAddition){
            if ([[dic objectForKey:@"FoodFuJia_Des"] isEqualToString:barAddition.text])
                return;
        }
        NSDictionary *dicToAdd = [NSDictionary dictionaryWithObjectsAndKeys:barAddition.text,@"FoodFuJia_Des",@"0.0",@"FoodFujia_Checked", nil];
        [aryCustomAddition addObject:dicToAdd];
        
        [arySearchMatched removeAllObjects];
        [arySearchMatched addObjectsFromArray:aryCustomAddition];
        [arySearchMatched addObjectsFromArray:aryAdditions];
        barAddition.text = nil;
        
        [tvAddition reloadData];
        
        NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
        [aryAll addObjectsFromArray:aryCustomAddition];
        
        NSMutableDictionary *dictNew = [NSMutableDictionary dictionaryWithDictionary:self.dicInfo];
        if ([aryAll count]>0)
            [dictNew setObject:aryAll forKey:@"addition"];
        else
            [dictNew removeObjectForKey:@"addition"];
        
        [delegate cell:self additionChanged:aryAll];
        
        //     [tvAddition reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark SearchBarDelegate
NSInteger intSort4(id num1,id num2,void *context){
    int v1 = [[(NSDictionary *)num1 objectForKey:@"ITCODE"] intValue];
    int v2 = [[(NSDictionary *)num2 objectForKey:@"ITCODE"] intValue];
    
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
//附加项搜索条
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>0){
        searchText = [searchText uppercaseString];
        
        
        NSArray *ary = [NSArray arrayWithArray:aryAdditions];
        
        // clean buffer after
        self.arySearchMatched = [NSMutableArray array];
        
        int count = [ary count];
        for (int i=0;i<count;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            
            NSString *strITCODE = [[dic objectForKey:@"ITCODE"] uppercaseString];
            NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
            NSString *strDES = [dic objectForKey:@"DES"];
            if ([strITCODE rangeOfString:searchText].location!=NSNotFound ||
                [strINIT rangeOfString:searchText].location!=NSNotFound ||
                [strDES rangeOfString:searchText].location!=NSNotFound){
                [arySearchMatched addObject:dic];
            }
        }
        self.arySearchMatched = [NSMutableArray arrayWithArray:[arySearchMatched sortedArrayUsingFunction:intSort4 context:NULL]];
        
        for (int i=aryCustomAddition.count-1;i>=0;i--)
            [arySearchMatched insertObject:[aryCustomAddition objectAtIndex:i] atIndex:0];
        //        NSArray *aryCustom = [self.dicInfo objectForKey:@"addition"];
        //
        //        int j=0;
        //        for (NSDictionary *dic in aryCustom){
        //            if (![dic objectForKey:@"ITCODE"])
        //                j++;
        //        }
        
        //        if (bJump)
        //            [tvAddition scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dJump+j inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else{
        self.arySearchMatched = [NSMutableArray arrayWithArray:aryAdditions];
        
        self.arySearchMatched = [NSMutableArray arrayWithArray:[arySearchMatched sortedArrayUsingFunction:intSort4 context:NULL]];
        
        for (int i=aryCustomAddition.count-1;i>=0;i--)
            [arySearchMatched insertObject:[aryCustomAddition objectAtIndex:i] atIndex:0];
    }
    [tvAddition reloadData];
    
}


- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [self performSelector:@selector(addCustiomAddition)];
}


- (void)deleteSelf{
    [delegate cell:self countChanged:0];
}

#pragma mark -
#pragma mark Changed Unit
//改变单位
- (void)changeUnit{
    [delegate unitOfCellChanged:self];
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
