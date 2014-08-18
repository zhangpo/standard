//
//  AKOrderRepastViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//
/*
    点菜界面
 */
#import <UIKit/UIKit.h>
#import "BSDataProvider.h"//数据请求类
#import "AKMySegmentAndView.h"//顶上信息类
#import "BSAddtionView.h"//附加项累
@interface AKOrderRepastViewController : UIViewController<UISearchBarDelegate,AKMySegmentAndViewDelegate,AdditionViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSArray *classArray;
    IBOutlet UIScrollView *aScrollView;
}
@end
