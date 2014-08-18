//
//  BSQueryViewController.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataProvider.h"
#import "BSChuckView.h"
#import "BSQueryCell.h"
#import "BSQueryCell.h"

#import "AKMySegmentAndView.h"

@interface BSQueryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ChuckViewDelegate,UISearchBarDelegate,BSQueryCellDelegate,UITextFieldDelegate,AKMySegmentAndViewDelegate>{
    UIButton *btnQuery,*btnGogo,*btnPrint,*btnChuck,*btnBack;
    
    UITableView *tvOrder;
    
    UILabel *lblTitle;
    
    NSDictionary *dicOrder,*dictQuery;
    
    UIView *vHeader;
    
    int dGogoCount,dChuckCount;
    
    BSChuckView *vChuck;
    
    NSString *strTable;
    
    NSString *strUser,*strPwd;
    
    int dTable;
    NSMutableArray *arySelectedFood;
    
}
@property (nonatomic,copy) NSString *strTable;
@property (nonatomic,copy) NSString *strUser,*strPwd;

- (void)dismissViews;
- (void)printQuery;
@property (nonatomic,retain) NSDictionary *dicOrder,*dicQuery;;
@property (nonatomic,retain) NSMutableArray *arySelectedFood;
@end
