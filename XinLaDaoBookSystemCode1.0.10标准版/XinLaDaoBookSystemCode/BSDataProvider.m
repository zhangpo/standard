//
//  BSDataProvider.m
//  BookSystem
//
//  Created by Dream on 11-3-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSDataProvider.h"
#import "FMDatabase.h"
#import "Singleton.h"
#import "AKsNetAccessClass.h"
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"
#import "AKsCanDanListClass.h"
#import "AKsNetAccessClass.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import "UIKitUtil.h"
#import "CardJuanClass.h"
#import "CVLocalizationSetting.h"

//#import "PaymentSelect.h"


@implementation BSDataProvider

//static BSDataProvider *sharedInstance = nil;
//static NSDictionary *infoDict = nil;
//static NSDictionary *dicCurrentPageConfig = nil;
//static NSDictionary *dicCurrentPageConfigDetail = nil;
//static NSArray *aryPageConfigList = nil;
//static NSLock *_loadingMutex = nil;
//static NSMutableArray *aryOrders = nil;
//static NSArray *aryAllDetailPages = nil;
//static NSArray *aryAllPages = nil;
//static int dSendCount = 0;

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization cod
    }
    return self;
}
//PadId
-(NSString *)padID{
    NSString *deviceID=[[NSUserDefaults standardUserDefaults] objectForKey:@"PDAID"];
    AKsNetAccessClass *netaccess=[AKsNetAccessClass sharedNetAccess];
    netaccess.UserId=deviceID;
    return deviceID;
}
//查询菜品分类
-(NSArray *)getClassById
{
    NSString *path = [BSDataProvider sqlitePath];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
    if(![db open])
    {
        NSLog(@"打开失败");
        return nil;
    }
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSString *str=[NSString stringWithFormat:@"select * from class order by GRP asc"];
    FMResultSet *rs = [db executeQuery:str];
    
    while ([rs next]){
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:[rs stringForColumn:@"DES"] forKey:@"DES"];
        [dict setObject:[rs stringForColumn:@"GRP"] forKey:@"GRP"];
        [array addObject:dict];
    }
    [db close];
    return array;
}
//select PNAME,PRICE1,PRODUCTTC_ORDER,defualtS from products_sub where pcode ='10011' order by PRODUCTTC_ORDER asc
//预定台位
-(void)reserveCache:(NSArray *)ary
{
    for (int i=0; i<ary.count; i++) {
        
        AKsCanDanListClass *caiList=[ary objectAtIndex:i];
        
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            NSLog(@"数据库打开失败");
        }
        else
        {
            NSLog(@"数据库打开成功");
        }
        FMResultSet *rs = [db executeQuery:@"select * from food where itcode=?",caiList.pcode];
        NSString *class;
        while ([rs next]){
            class=[rs stringForColumn:@"class"];
        }
        NSString *qqq;
        if ([caiList.istc intValue]==1) {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,@"1",caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",caiList.pcount];
        }
        else
        {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,caiList.pcount,caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",@""];
        }
        [db executeUpdate:qqq];
        [db close];
    }
    
}
-(void)delectcombo:(NSString *)tpcode andNUM:(NSString *)num
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@' and Tpcode='%@' and TPNUM='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2",tpcode,num];
    NSLog(@"%@",st);
    [db executeUpdate:st];
    [db close];
}
-(void)delectdish:(NSString *)code
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@' and Pcode=%@",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2",code];
    NSLog(@"%@",st);
    [db executeUpdate:st];
    [db close];
}
//缓存
-(void)cache:(NSArray *)ary
{
    [self delectCache];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    int x = 0;
    NSLog(@"%@",ary);
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dict=[ary objectAtIndex:i];
        NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*CNT;
        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
        Fujiacode=[NSMutableString string];
        FujiaName=[NSMutableString string];
        FujiaPrice=[NSMutableString string];
        
        PCname=[dict objectForKey:@"DES"];
        Pcode=[dict objectForKey:@"ITCODE"];
        Price=[dict objectForKey:@"PRICE"];
        pcount=[dict objectForKey:@"total"];
        Weight=[dict objectForKey:@"Weight"];
        Weightflg=[dict objectForKey:@"Weightflg"];
        promonum=[dict objectForKey:@"promonum"];
        isTC=[dict objectForKey:@"ISTC"];
        UNIT=[dict objectForKey:@"UNIT"];
        CNT=[dict objectForKey:@"CNT"];
        Tpcode=[dict objectForKey:@"Tpcode"];
        TPNAME=[dict objectForKey:@"TPNAME"];
        TPNUM=[dict objectForKey:@"TPNUM"];
        //                CLASS=[dict objectForKey:@"CLASS"];
        NSArray *array=[dict objectForKey:@"addition"];
        for (NSDictionary *dict1 in array) {
            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
            [Fujiacode appendString:@"!"];
            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
            [FujiaName appendString:@"!"];
            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
            [FujiaPrice appendString:@"!"];
        }
        if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
            Tpcode=Pcode;
            TPNAME=PCname;
            
        }
        else
        {
            if ([dict objectForKey:@"CLASS"]==nil||[[dict objectForKey:@"CLASS"] isEqualToString:@"(null)"])
            {
                NSLog(@"%@",dict);
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                //                TPNUM=[dict objectForKey:@"TPNUM"];
            }
            else
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                //                Tpcode=@"";
                //                TPNAME=@"";
                TPNUM=0;
                x++;
            }
        }
        //        if ([dict objectForKey:@"CNT"]!=nil) {
        //            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
        //            TPNUM=[dict objectForKey:@"TPNUM"];
        //            CNT=[dict objectForKey:@"CNT"];
        //            isTC=@"1";
        //            TPNAME=[dict objectForKey:@"TPNANE"];
        //            Tpcode=[dict objectForKey:@"Tpcode"];
        //        }
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            NSLog(@"数据库打开失败");
        }
        else
        {
            NSLog(@"数据库打开成功");
        }
        NSString *qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,PKID,Pcode,PCname,Tpcode,TPNAME,TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,@"0",@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"2",promonum,CNT];
        NSLog(@"%@",qqq);
        [db executeUpdate:qqq];
        [db close];
    }
}
- (NSArray *)getAdditions:(NSString *)pcode{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = [NSString stringWithFormat:@"select * from FoodFuJia where pcode=%@",pcode];
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *attachKey = (char *)sqlite3_column_name(stat, i);
                    char *attachValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (attachKey)
                        strKey = [NSString stringWithUTF8String:attachKey];
                    if (attachValue)
                        strValue = [NSString stringWithUTF8String:attachValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        if ([ary count]==0) {
            sqlcmd = @"select * from FoodFuJia where length(PCODE)=0 OR pcode like '%PCODE%'";
            if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
                while (sqlite3_step(stat)==SQLITE_ROW) {
                    int count = sqlite3_column_count(stat);
                    NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                    for (int i=0;i<count;i++){
                        char *attachKey = (char *)sqlite3_column_name(stat, i);
                        char *attachValue = (char *)sqlite3_column_text(stat, i);
                        NSString *strKey = nil,*strValue = nil;
                        if (attachKey)
                            strKey = [NSString stringWithUTF8String:attachKey];
                        if (attachValue)
                            strValue = [NSString stringWithUTF8String:attachValue];
                        if (strKey && strValue)
                            [mutDC setObject:strValue forKey:strKey];
                    }
                    [ary addObject:mutDC];
                }
            }
            
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:ary];
    
}
-(NSArray *)chkCodesql{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from ERRORCUSTOM where STATE=1";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *attachKey = (char *)sqlite3_column_name(stat, i);
                    char *attachValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (attachKey)
                        strKey = [NSString stringWithUTF8String:attachKey];
                    if (attachValue)
                        strValue = [NSString stringWithUTF8String:attachValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:ary];
}
//查缓存的菜品
-(NSMutableArray *)selectCache
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
    //    [self delectCache];
    NSString *qqq=[NSString stringWithFormat:@"select * from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='2'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time];
    NSLog(@"%@",qqq);
    FMResultSet *rs=[db executeQuery:qqq];
    NSMutableArray *ary10=[[NSMutableArray alloc] init];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setValue:[rs stringForColumn:@"CLASS"] forKey:@"CLASS"];
        [dict setValue:[rs stringForColumn:@"Pcode"] forKey:@"ITCODE"];
        [dict setValue:[rs stringForColumn:@"ISTC"] forKey:@"ISTC"];
        [dict setValue:[rs stringForColumn:@"price"] forKey:@"PRICE"];
        [dict setValue:[rs stringForColumn:@"PCname"] forKey:@"DES"];
        [dict setValue:[rs stringForColumn:@"TPNAME"] forKey:@"TPNAME"];
        [dict setValue:[rs stringForColumn:@"TPNUM"] forKey:@"TPNUM"];
        [dict setValue:[rs stringForColumn:@"Tpcode"] forKey:@"Tpcode"];
        NSLog(@"%@",[rs stringForColumn:@"Tpcode"]);
        [dict setValue:[rs stringForColumn:@"unit"] forKey:@"UNIT"];
        [dict setValue:[rs stringForColumn:@"Weight"] forKey:@"Weight"];
        [dict setValue:[rs stringForColumn:@"Weightflg"] forKey:@"Weightflg"];
        NSString *str=[rs stringForColumn:@"fujiacode"];
        NSArray *ary=[str componentsSeparatedByString:@"!"];
        NSString *str1=[rs stringForColumn:@"fujianame"];
        NSArray *ary1=[str1 componentsSeparatedByString:@"!"];
        NSString *str2=[rs stringForColumn:@"fujiaprice"];
        NSArray *ary2=[str2 componentsSeparatedByString:@"!"];
        NSMutableArray *ary3=[NSMutableArray array];
        for (int i=0; i<[ary count]-1; i++) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setValue:[ary objectAtIndex:i] forKey:@"FOODFUJIA_ID"];
            [dict1 setValue:[ary1 objectAtIndex:i] forKey:@"FoodFuJia_Des"];
            [dict1 setValue:[ary2 objectAtIndex:i] forKey:@"FoodFujia_Checked"];
            [ary3 addObject:dict1];
        }
        
        [dict setValue:ary3 forKey:@"addition"];
        [dict setValue:[rs stringForColumn:@"pcount"] forKey:@"total"];
        [dict setValue:[rs stringForColumn:@"CNT"] forKey:@"CNT"];
        if ([dict objectForKey:@"CNT"]==nil||[[dict objectForKey:@"CNT"] isEqualToString:@"(null)"]) {
            [array addObject:dict];
            if ([[dict objectForKey:@"ISTC"] intValue]==1) {
                ary10=[[NSMutableArray alloc] init];
            }
        }else
        {
            [ary10 addObject:dict];
            [[array lastObject] setObject:ary10 forKey:@"combo"];
        }
        
    }
    [db close];
    return array;
    
}
//清除缓存
-(void)delectCache
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
    NSLog(@"%@",st);
    [db executeUpdate:st];
    [db close];
}
-(NSArray *)soldOut
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]]];
    NSDictionary *dict = [self bsService:@"soldOut" arg:strParam];
    NSMutableArray *array=[NSMutableArray array];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:soldOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            for (int i=1; i<[ary count]; i++) {
                [array addObject:[ary objectAtIndex:i]];
            }
        }
    }
    return array;
}
//预打印
-(NSDictionary *)priPrintOrder
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",pdanum,user,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    
    NSDictionary *dict = [self bsService:@"PrintOrder" arg:strParam];
    
    return dict;
}
//催菜成功修改数据库
-(void)gogoOrderUpData:(NSDictionary *)info
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([[info objectForKey:@"ISTC"] intValue]==1&&[[info objectForKey:@"Pcode"] isEqualToString:[info objectForKey:@"Tpcode"]])
    {
        NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and PKID='%@' and TPNUM='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"PKID"],[info objectForKey:@"TPNUM"]];
        NSLog(@"%@",str1);
        FMResultSet *rs=[db executeQuery:str1];
        int i;
        while ([rs next]) {
            i=[[rs stringForColumn:@"Urge"] intValue];
            NSString *name=[rs stringForColumn:@"ID"];
            NSLog(@"%d",i);
            NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and ID='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name];
            NSLog(@"%@",str);
            [db executeUpdate:str];
        }
        
    }else
    {
        NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and ID='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"ID"]];
        FMResultSet *rs=[db executeQuery:str1];
        int i;
        while ([rs next]) {
            i=[[rs stringForColumn:@"Urge"] intValue];
        }
        NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and ID='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"ID"]];
        NSLog(@"%@",str);
        [db executeUpdate:str];
    }
    [db close];
    
}
-(void)gogoOrderUpData:(NSString *)name withCode:(NSString *)code withTPNUM:(NSString *)TPNUM
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and PKID='%@' and Pcode='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name,code];
    FMResultSet *rs=[db executeQuery:str1];
    int i;
    while ([rs next]) {
        i=[[rs stringForColumn:@"Urge"] intValue];
    }
    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and PKID='%@' and Pcode='%@' and TPNUM='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name,code,TPNUM];
    NSLog(@"%@",str);
    [db executeUpdate:str];
    [db close];
}
-(void)updatecombineTable:(NSDictionary *)dict :(NSString *)cheak
{
    NSMutableArray *array=[NSMutableArray array];
    [array addObject:[dict objectForKey:@"newtable"]];
    [array addObject:[dict objectForKey:@"oldtable"]];
    for (int i=0; i<[array count]; i++) {
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            return;
        }
        
        //    NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum='%@' and Time='%@'"
        NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET orderId = '%@' WHERE tableNum = '%@' and Time='%@'",cheak,[array objectAtIndex:i],[Singleton sharedSingleton].Time];
        NSLog(@"%@",str);
        [db executeUpdate:str];
        [db close];
    }
}
//换台更改数据库
-(void)updateChangTable:(NSDictionary *)info :(NSString *)cheak
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET tableNum = '%@' WHERE tableNum = '%@' and orderId='%@'",[info objectForKey:@"newtable"],[info objectForKey:@"oldtable"],cheak];
    NSLog(@"%@",str);
    [db executeUpdate:str];
    [db close];
}
//数据库划菜
-(int)updata:(NSDictionary *)dict withNum:(NSString *)num withOver:(NSString *)over
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([over isEqualToString:@"0"]) {
        NSLog(@"%@",dict);
        NSLog(@"%@",num);
        NSLog(@"%@",[dict objectForKey:@"Over"]);
        NSString *str=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"Over"] intValue]+[num intValue]];
        NSLog(@"%@",str);
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=? and TPNUM=?",str,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[dict objectForKey:@"PKID"],[dict objectForKey:@"Pcode"],[dict objectForKey:@"TPNUM"]];
    }
    else
    {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=? and TPNUM=?",@"0",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[dict objectForKey:@"PKID"],[dict objectForKey:@"Pcode"],[dict objectForKey:@"TPNUM"]];
    }
    FMResultSet *rs=[db executeQuery:@"select * from AllCheck where Over=0 and tableNum = ? and orderId=? and Time=?",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time];
    int i=0;
    while ([rs next]) {
        i++;
    }
    [db close];
    return i;
}
-(NSString *)scratch:(NSDictionary *)info andtag:(int)tag
{
    NSMutableString *fanfood=[NSMutableString string];
    if ([info objectForKey:@"fujiacode"]==nil) {
        [info setValue:@"" forKey:@"fujiacode"];
    }
    if ([info objectForKey:@"Weightflg"]==nil) {
        [info setValue:@"" forKey:@"Weightflg"];
    }
    [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"count"],[info objectForKey:@"PKID"]];
    [fanfood appendString:@";"];
    if (tag==0) {
        //        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
        //        NSString *str2;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //        NSArray *ary = [result componentsSeparatedByString:@"@"];
        //        if ([ary count]==1) {
        //            str2=[ary objectAtIndex:0];
        //        }else
        //        {
        //            str2=[ary objectAtIndex:1];
        //        }
        return result;
    }else
    {
        //        NSString *str;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //        NSArray *ary = [result componentsSeparatedByString:@"@"];
        //        if ([ary count]==1) {
        //            str=[ary objectAtIndex:0];
        //        }else
        //        {
        //            str=[ary objectAtIndex:1];
        //        }
        return result;
    }
}
//接口划菜
-(NSString *)scratch:(NSArray *)dish
{
    //    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    //    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    NSMutableString *fanfood=[NSMutableString string];
    for (NSDictionary *info in dish) {
        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"Over"],[info objectForKey:@"PKID"]];
            [fanfood appendString:@";"];
        }
        else
        {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%d@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[[info objectForKey:@"pcount"] intValue]-[[info objectForKey:@"Over"] intValue],[info objectForKey:@"PKID"]];
            [mutfood appendString:@";"];
        }
    }
    NSLog(@"%@",mutfood);
    NSString *str1;
    if (![mutfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        str1=result;
    }
    if (![fanfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if (str1==nil) {
            str1=result;
        }
    }
    return str1;
}
-(NSArray *)specialremark//查询全单附加项
{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from specialremark";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *attachKey = (char *)sqlite3_column_name(stat, i);
                    char *attachValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (attachKey)
                        strKey = [NSString stringWithUTF8String:attachKey];
                    if (attachValue)
                        strValue = [NSString stringWithUTF8String:attachValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:ary];
}
-(NSArray *)presentreason
{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from presentreason";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *attachKey = (char *)sqlite3_column_name(stat, i);
                    char *attachValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (attachKey)
                        strKey = [NSString stringWithUTF8String:attachKey];
                    if (attachValue)
                        strValue = [NSString stringWithUTF8String:attachValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:ary];
}
+(int)updata:(NSString *)table orderID:(NSString *)order pkid:(NSString *)pkid code:(NSString *)code Over:(NSString *)over;{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([over isEqualToString:@"0"]) {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"1",table,order,pkid,code];
    }
    else
    {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"0",table,order,pkid,code];
    }
    FMResultSet *rs=[db executeQuery:@"select * from AllCheck where Over=0 and tableNum = ? and orderId=?",table,order];
    int i=0;
    while ([rs next]) {
        i++;
    }
    [db close];
    return i;
}
//改变台位状态
-(NSDictionary *)changTableState:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    //    NSString *tableNum=[info objectForKey:@"tableNum"];
    NSString *currentState=[info objectForKey:@"currentState"];
    NSString *nextState=[info objectForKey:@"nextState"];
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&currentState=%@&nextState=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,currentState,nextState];
    NSDictionary *dict = [self bsService:@"changTableState" arg:api];
    NSLog(@"%@",dict);
    return dict;
}
//
//台位操作
- (NSDictionary *)pChangeTable:(NSDictionary *)info{
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n")},//6.换台changetable
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n
    NSString *pdaid,*user,*oldtable,*newtable,*pwd,*orderId;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    NSLog(@"%@",user);
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tablenumSource=%@&tablenumDest=%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"pSignTeb" arg:strParam];
    //    if (dict) {
    //        NSString *result = [[[dict objectForKey:@"ns:changeTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    //        NSArray *ary=[result componentsSeparatedByString:@"@"];
    //        if ([[ary objectAtIndex:0] isEqualToString:@"-1"]) {
    //            NSLog(@"%@",[ary objectAtIndex:1]);
    //            return [NSDictionary dictionaryWithObjectsAndKeys:result,@"Message",nil];
    //        }
    //        else
    //        {
    //            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil];
    //        }
    //    }
    return dict;
}

//并台
-(NSDictionary *)combineTable:(NSDictionary *)info
{
    NSString *pdaid,*user,*oldtable,*newtable,*pwd;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    NSLog(@"%@",user);
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableList=%@@%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"combineTable" arg:strParam];
    NSLog(@"%@",dict);
    return dict;
    //    if (dict) {
    //        NSString *result = [[[dict objectForKey:@"ns:combineTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    //        NSArray *ary=[result componentsSeparatedByString:@"@"];
    //        if ([[ary objectAtIndex:0] isEqualToString:@"-1"]) {
    //            NSLog(@"%@",[ary objectAtIndex:1]);
    //            return [NSDictionary dictionaryWithObjectsAndKeys:result,@"Message",nil];
    //        }
    //        else
    //        {
    //            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil];
    //        }
    //    }
    //    return nil;
}

//查询台位菜品
-(NSMutableArray *)queryProduct:(NSString *)seat
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *tableNum=seat;
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@&orderId=%@&chkCode=%@&comOrDetach=%@",pdanum,user,tableNum,@"",@"",@"",@"",@"0"];
    NSDictionary *dict = [self bsService:@"queryProduct" arg:api];
    NSString *result = [[[dict objectForKey:@"ns:queryProductResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    if ([[[result componentsSeparatedByString:@"@"] objectAtIndex:0] intValue]==0) {
        [Singleton sharedSingleton].CheckNum=[[result componentsSeparatedByString:@"@"] objectAtIndex:1];
        
    }
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    NSArray *ary1 = [result componentsSeparatedByString:@"#"];
    NSLog(@"%@",ary1);
    for (int i=0;i<[ary1 count];i++) {
        if (i==0) {
            NSArray *ary2=[[ary1 objectAtIndex:0] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (NSString *result2 in array2) {
                NSLog(@"%@",result2);
                
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                NSLog(@"%@",ary3);
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsCanDanListClass *candan=[[AKsCanDanListClass alloc] init];
                    if ([[ary3 objectAtIndex:3] isEqualToString:[ary3 objectAtIndex:5]]||[[ary3 objectAtIndex:5]isEqualToString:@""]) {
                        candan.pcname=[ary3 objectAtIndex:4];
                    }
                    else
                    {
                        candan.pcname=[NSString stringWithFormat:@"--%@",[ary3 objectAtIndex:4]];
                    }
                    [Singleton sharedSingleton].CheckNum=[ary3 objectAtIndex:1];
                    candan.tpname=[ary3 objectAtIndex:6];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.fujianame=[ary3 objectAtIndex:7];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.promonum=[ary3 objectAtIndex:9];
                    NSArray *ary4=[[ary3 objectAtIndex:11] componentsSeparatedByString:@"!"];
                    NSMutableString *FujiaName =[NSMutableString string];
                    for (NSString *str in ary4) {
                        [FujiaName appendFormat:@"%@ ",str];
                    }
                    float addtition=0.0f;
                    NSArray *ary5=[[ary3 objectAtIndex:13] componentsSeparatedByString:@"!"];
                    for (NSString *str in ary5) {
                        addtition+=[str floatValue];
                    }
                    candan.fujiaprice=[NSString stringWithFormat:@"%.2f",addtition];
                    candan.fujianame=FujiaName;
                    candan.price=[ary3 objectAtIndex:12];
                    candan.unit=[ary3 objectAtIndex:16];
                    candan.istc=[ary3 objectAtIndex:17];
                    [array addObject:candan];
                    NSLog(@"%@",array);
                }
                else
                {
                    return nil;
                }
                
            }
            [array1 addObject:array];
        }
        else if(i==1)
        {
            NSArray *ary2=[[ary1 objectAtIndex:1] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            NSLog(@"%@",ary);
            for (NSString *result2 in array2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsYouHuiListClass *youhui=[[AKsYouHuiListClass alloc] init];
                    youhui.youName=[ary3 objectAtIndex:2];
                    youhui.youMoney=[ary3 objectAtIndex:3];
                    [ary addObject:youhui];
                }
            }
            [array1 addObject:ary];
        }
        else if(i==2)
        {
            NSArray *ary2=[[ary1 objectAtIndex:2] componentsSeparatedByString:@"@"];
            if ([[ary2 objectAtIndex:0] intValue]==0) {
                [Singleton sharedSingleton].man=[ary2 objectAtIndex:1];
                [Singleton sharedSingleton].woman=[ary2 objectAtIndex:2];
            }
        }
        else{
            NSArray *ary2=[[ary1 objectAtIndex:3] componentsSeparatedByString:@";"];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            NSMutableString *str=[NSMutableString string];
            NSLog(@"%@",ary);
            for (NSString *result2 in ary2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([ary3 count]==2) {
                    //                    [ary stringByAppendingString:[ary3 objectAtIndex:1]];
                    [str appendFormat:@"%@ ",[ary3 objectAtIndex:1]];
                }
                //                [ary addObject:[ary3 objectAtIndex:1]];
            }
            [ary addObject:str];
            [array1 addObject:ary];
        }
    }
    if ([array1 count]==3) {
        [array1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
    NSLog(@"%@",array1);
    return array1;
}
//根据台位号查账单
-(NSDictionary *)getOrdersBytabNum1:(NSString *)str{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],str];
    NSDictionary *dict = [self bsService:@"getOrdersBytabNum" arg:strParam];
    NSLog(@"%@",dict);
    NSString *str1=[[[dict objectForKey:@"ns:getOrdersBytabNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary = [str1 componentsSeparatedByString:@"@"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    if ([ary count]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return  nil;
    }
    else
    {
        [dataDic setValue:[ary objectAtIndex:0] forKey:@"tag"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            NSArray *valuearray = [str1 componentsSeparatedByString:@"#"];
            if([[valuearray objectAtIndex:1]isEqualToString:@"1"])
            {
                AKsNetAccessClass *netAccess =[AKsNetAccessClass sharedNetAccess];
                NSArray *cardValue=[[valuearray objectAtIndex:2]componentsSeparatedByString:@"@"];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                
                [dict setObject:@"" forKey:@"zhangdanId"];
                [dict setObject:[cardValue objectAtIndex:0] forKey:@"phoneNum"];
                [dict setObject:[Singleton sharedSingleton].Time forKey:@"dateTime"];
                [dict setObject:[cardValue objectAtIndex:1] forKey:@"cardNum"];
                [dict setObject:[cardValue objectAtIndex:4] forKey:@"IntegralOverall"];
                
                
                netAccess.JiFenKeYongMoney=[cardValue objectAtIndex:4];
                netAccess.ChuZhiKeYongMoney=[cardValue objectAtIndex:3];
                netAccess.VipCardNum=[cardValue objectAtIndex:1];
                
                NSArray *VipJuan=[[NSArray alloc]initWithArray:[[cardValue objectAtIndex:7]componentsSeparatedByString:@";" ]];
                NSLog(@"%@",VipJuan);
                NSMutableArray *cardJuanArray=[[NSMutableArray alloc]init];
                for (int i=0; i<[VipJuan count]-1; i++)
                {
                    NSArray *values=[[VipJuan objectAtIndex:i] componentsSeparatedByString:@","];
                    CardJuanClass *cardJuan=[[CardJuanClass alloc]init];
                    cardJuan.JuanId=[values objectAtIndex:0];
                    cardJuan.JuanMoney=[NSString stringWithFormat:@"%.2f",[[values objectAtIndex:1]floatValue]/100.0];
                    cardJuan.JuanName=[values objectAtIndex:2];
                    cardJuan.JuanNum=[values objectAtIndex:3];
                    [cardJuanArray addObject:cardJuan];
                    
                }
                netAccess.CardJuanArray=cardJuanArray;
                netAccess.showVipMessageDict=dict;
            }
            NSArray *array=[[ary objectAtIndex:1] componentsSeparatedByString:@";"];
            
            [dataDic setValue:array forKey:@"message"];
            return [NSDictionary dictionaryWithDictionary:dataDic];
        }
        else
        {
            [dataDic setValue:[ary objectAtIndex:1] forKey:@"message"];
            return [NSDictionary dictionaryWithDictionary:dataDic];
        }
    }
}
//登出
-(NSArray *)logout
{
    NSString *strParam=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict=[self bsService:@"logout" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:loginOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return ary1;
}
//编号注册
-(NSString *)registerDeviceId:(NSString *)str
{
    NSString *strParam =[NSString stringWithFormat:@"?&handvId=%@",str];
    NSDictionary *dict = [self bsService:@"registerDeviceId" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:registerDeviceIdResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return [ary1 objectAtIndex:1];
}
//授权
-(NSDictionary *)checkAuth:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[info objectForKey:@"user"];
    NSString *pass=[info objectForKey:@"pwd"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&userPass=%@",pdanum,user,pass];
    NSDictionary *dict = [self bsService:@"checkAuth" arg:strParam];
    return dict;
    
}
//全单附加项
-(NSDictionary *)specialRemark:(NSArray *)ary
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *userCode=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *orderId=[Singleton sharedSingleton].CheckNum;
    NSLog(@"%@",ary);
    NSMutableString *remarkId=[NSMutableString string];
    NSMutableString *remark=[NSMutableString string];
    for (NSDictionary *dict in ary) {
        [remarkId appendFormat:@"%@",[dict objectForKey:@"Id"]];
        [remarkId appendString:@"!"];
        [remark appendFormat:@"%@",[dict objectForKey:@"DES"]];
        [remark appendString:@"!"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&remarkIdList=%@&remarkList=%@&flag=%@",pdanum,userCode,orderId,remarkId,remark,@"1"];
    NSDictionary *dict1 = [self bsService:@"specialRemark" arg:strParam];
    NSLog(@"%@",dict1);
    return dict1;
}
//全单
//查询全单
- (NSDictionary *)queryCompletely{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"queryWholeProducts" arg:strParam];
    
    if (dict) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSString *result = [[[dict objectForKey:@"ns:queryWholeProductsResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        NSMutableArray *aryResult = [NSMutableArray array];
        if ([[ary objectAtIndex:0] isEqualToString:@"0"]) {
            //获取男人数、女人数、账单号、台位等基本信息
            NSArray *aryInfo = [result componentsSeparatedByString:@"#"];
            NSArray *aryInfoRes =[[aryInfo objectAtIndex:[aryInfo count]-2] componentsSeparatedByString:@"@"];
            [Singleton sharedSingleton].man=[aryInfoRes objectAtIndex:1];
            [Singleton sharedSingleton].woman=[aryInfoRes objectAtIndex:2];
            NSArray *ary = [[aryInfo objectAtIndex:0] componentsSeparatedByString:@";"];
            NSArray *array=[[aryInfo lastObject] componentsSeparatedByString:@";"];
            NSMutableString *Common=[NSMutableString string];
            for (int i=0; i<[array count]-1; i++) {
                NSString *str=[array objectAtIndex:i];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                [Common appendFormat:@"%@ ",[itemAry objectAtIndex:1]];
            }
            [dic setValue:Common forKey:@"Common"];
            //            NSMutableDictionary *dicResult = [NSMutableDictionary dictionary];
            
            int c = [ary count];
            for (int z=0; z<c-1; z++) {
                NSString *str = [ary objectAtIndex:z];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setValue:[itemAry objectAtIndex:1]  forKey:@"orderId"];
                [mutDic setValue:[itemAry objectAtIndex:2]  forKey:@"PKID"];
                [mutDic setValue:[itemAry objectAtIndex:3]  forKey:@"Pcode"];
                [mutDic setValue:[itemAry objectAtIndex:4]  forKey:@"PCname"];
                [mutDic setValue:[itemAry objectAtIndex:5]  forKey:@"Tpcode"];
                [mutDic setValue:[itemAry objectAtIndex:6]  forKey:@"TPNAME"];
                [mutDic setValue:[itemAry objectAtIndex:7]  forKey:@"TPNUM"];
                [mutDic setValue:[itemAry objectAtIndex:8]  forKey:@"pcount"];
                [mutDic setValue:[itemAry objectAtIndex:9]  forKey:@"promonum"];
                [mutDic setValue:[itemAry objectAtIndex:10] forKey:@"fujiacode"];
                [mutDic setValue:[itemAry objectAtIndex:11] forKey:@"fujianame"];
                [mutDic setValue:[itemAry objectAtIndex:12]  forKey:@"talPreice"];
                [mutDic setValue:[itemAry objectAtIndex:13]  forKey:@"fujiaPrice"];
                
                [mutDic setValue:[itemAry objectAtIndex:14]  forKey:@"weight"];
                [mutDic setValue:[itemAry objectAtIndex:15]  forKey:@"weightflg"];
                [mutDic setValue:[itemAry objectAtIndex:16]  forKey:@"unit"];
                [mutDic setValue:[itemAry objectAtIndex:17]  forKey:@"ISTC"];
                [mutDic setValue:[itemAry objectAtIndex:18]  forKey:@"Urge"];//催菜次数
                [mutDic setValue:[itemAry objectAtIndex:19]  forKey:@"Over"];//划菜数量
                [mutDic setValue:[itemAry objectAtIndex:20]  forKey:@"IsQuit"];//推菜标志（0为退菜，1为正常）
                [mutDic setValue:[itemAry objectAtIndex:21]  forKey:@"QuitCause"];//退菜原因
                [mutDic setValue:[itemAry objectAtIndex:22]  forKey:@"CLASS"];
                [mutDic setValue:[itemAry objectAtIndex:23] forKey:@"price"];
                [aryResult addObject:mutDic];
            }
            
        }
        [dic setValue:aryResult forKey:@"data"];
        return dic;
    }else
    {
        return nil;
    }
}
//退菜
-(NSDictionary *)chkCode:(NSArray *)array info:(NSDictionary *)info{
    NSLog(@"%@",array);
    NSArray *dataArray=array;
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        int count=[[info objectForKey:@"pcount"] intValue]-[[info objectForKey:@"Over"] intValue];
        if([[info objectForKey:@"ISTC"] intValue]==1&&![[info objectForKey:@"Pcode"] isEqualToString:[info objectForKey:@"Tpcode"]]){
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%@",[info objectForKey:@"CNT"]] ,[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
        else
        {
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%d",count],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
    }
    NSLog(@"%@",mutfood);
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"INIT"]];
    NSDictionary *dict1 = [self bsService:@"checkFoodAvailable" arg:strParam];
    NSLog(@"%@",dict1);
    if (dict1) {
        NSString *result = [[[dict1 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSLog(@"%@",ary1);
        if ([[ary1 objectAtIndex:0] intValue]==0) {
            for (NSDictionary *dict in dataArray) {
                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
                if(![db open])
                {
                    NSLog(@"数据库打开失败");
                    return nil;
                }
                else
                {
                    NSLog(@"数据库打开成功");
                }
                FMResultSet *rs=[db executeQuery:@"select * from AllCheck where PKID=?",[dict objectForKey:@"PKID"]];
                NSString *pcount,*over;
                while ([rs next]) {
                    pcount=[rs stringForColumn:@"pcount"];
                    over=[rs stringForColumn:@"Over"];
                }
                NSLog(@"%@",dict);
                int count=[pcount intValue]-[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue];
                int count1=[over intValue]-[[dict objectForKey:@"pcount"] intValue];
                if (count<1) {
                    NSString *qqq=[NSString stringWithFormat:@"delete from AllCheck WHERE PKID='%@'",[dict objectForKey:@"PKID"]];
                    NSLog(@"%@",qqq);
                    [db executeUpdate:qqq];
                }
                else
                {
                    NSLog(@"------%d   %d",count,count1);
                    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET pcount = '%d',Over='%d' WHERE PKID = '%@'",count,count1,[dict objectForKey:@"PKID"]];
                    NSLog(@"%@",str);
                    [db executeUpdate:str];
                }
                
                
                NSLog(@"%d",[db commit]);
                [db close];
                
            }
        }
    }
    return dict1;
}
//菜齐
-(void)suppProductsFinish
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    
    NSDictionary *dict = [self bsService:@"ProductsFinish" arg:strParam];
    NSLog(@"%@",dict);
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:suppProductsFinishResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSLog(@"%@",[ary1 lastObject]);
    }
    
}
//请求连接
- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict = [agent GetData:api arg:arg];
    return dict;
}
//查台
- (NSDictionary *)pListTable:(NSDictionary *)info{
    //+listtable<user:%s;pdanum:%s;floor:%s;area:%s;status:%s;>\r\n
    //'全部状态' '空闲' '开台点菜' '开台未点' '预订' '预结'全部楼层=ALLFLOOR全部区域=ALLAREA全部状态=ALLSTA
    /*
     '空闲'=A
     '开台点菜'=B
     '开台未点'=C
     '预订'=D
     '预结'=E
     */
    NSLog(@"%@",info);
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    NSString *user,*pdanum,*floor,*area,*status,*tableNum;
    NSString *cmd;
    //   user = [NSString stringWithFormat:@"%@-%@",[info objectForKey:@"user"],[info objectForKey:@"pwd"]];
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    floor = [info objectForKey:@"floor"];
    if (!floor)
        floor = @"";
    area = [info objectForKey:@"area"];
    if (!area)
        area = @"";
    status = [info objectForKey:@"state"];
    if (!status)
        status = @"";
    tableNum = [info objectForKey:@"tableNum"];
    if (!tableNum)
        tableNum = @"";
    
    //    cmd = [NSString stringWithFormat:@"+listtable<user:%@;pdanum:%@;floor:%@;area:%@;status:%@;>\r\n",user,pdanum,floor,area,status];
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&area=%@&floor=%@&state=%@&tableNum=%@",pdanum,user,area,floor,status,tableNum];
    NSLog(@"%@",strParam);
    NSDictionary *dict = [self bsService:@"pListTable" arg:strParam];
    return dict;
}

//发送菜
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag{
    NSLog(@"%@",ary);
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    NSMutableString *mutfood = [NSMutableString string];
    int x = 0;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dict=[ary objectAtIndex:i];
        NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*promoReason;
        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
        Fujiacode=[NSMutableString string];
        FujiaName=[NSMutableString string];
        FujiaPrice=[NSMutableString string];
        //        PCname=@"";
        //        TPNAME=@"";
        //        PCname=[dict objectForKey:@"DES"];
        Pcode=[dict objectForKey:@"ITCODE"];
        Price=[dict objectForKey:@"PRICE"];
        Tpcode=[dict objectForKey:@"Tpcode"];
        
        //        TPNAME=[dict objectForKey:@"TPNANE"];
        pcount=[dict objectForKey:@"total"];
        Weight=[dict objectForKey:@"Weight"];
        Weightflg=[dict objectForKey:@"Weightflg"];
        promonum=[dict objectForKey:@"promonum"];
        promoReason=[dict objectForKey:@"promoReason"];
        isTC=[dict objectForKey:@"ISTC"];
        TPNUM=[dict objectForKey:@"TPNUM"];
        UNIT=[dict objectForKey:@"UNIT"];
        NSArray *array=[dict objectForKey:@"addition"];
        for (NSDictionary *dict1 in array) {
            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
            [Fujiacode appendString:@"!"];
            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
            [FujiaName appendString:@"!"];
            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
            [FujiaPrice appendString:@"!"];
        }
        if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,x];
            Tpcode=Pcode;
            //            TPNAME=PCname;
            //            TPNUM=[dict objectForKey:@"TPNUM"];
            x++;
        }
        else
        {
            if ([dict objectForKey:@"CNT"]!=nil&&![[dict objectForKey:@"CNT"] isEqualToString:@"(null)"])
            {
                NSLog(@"%@",dict);
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,x-1];
                pcount=[dict objectForKey:@"total"];
                isTC=@"1";
            }
            else
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,i];
                x++;
            }
        }
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,Pcode,@"",Tpcode,@"",TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,promoReason];
        [mutfood appendString:@";"];
    }
    NSLog(@"%@",mutfood);
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=&immediateOrWait=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"immediateOrWait"]];
    
    NSDictionary *dict3 = [self bsService:@"checkFoodAvailable" arg:strParam];
    
    if (dict3 && [Singleton sharedSingleton].isYudian==NO) {
        NSString *result = [[[dict3 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSString *str=[ary1 objectAtIndex:0];
        if ([str isEqualToString:@"0"]) {
            x=0;
            for (int i=0; i<ary.count; i++) {
                NSDictionary *dict=[ary objectAtIndex:i];
                NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*CNT;
                NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
                Fujiacode=[NSMutableString string];
                FujiaName=[NSMutableString string];
                FujiaPrice=[NSMutableString string];
                
                PCname=[dict objectForKey:@"DES"];
                Pcode=[dict objectForKey:@"ITCODE"];
                Price=[dict objectForKey:@"PRICE"];
                Tpcode=[dict objectForKey:@"Tpcode"];
                TPNAME=[dict objectForKey:@"TPNANE"];
                pcount=[dict objectForKey:@"total"];
                Weight=[dict objectForKey:@"Weight"];
                Weightflg=[dict objectForKey:@"Weightflg"];
                promonum=[dict objectForKey:@"promonum"];
                isTC=[dict objectForKey:@"ISTC"];
                UNIT=[dict objectForKey:@"UNIT"];
                CNT=[dict objectForKey:@"CNT"];
                TPNUM=[dict objectForKey:@"TPNUM"];
                NSArray *array=[dict objectForKey:@"addition"];
                for (NSDictionary *dict1 in array) {
                    [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
                    [Fujiacode appendString:@"!"];
                    [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
                    [FujiaName appendString:@"!"];
                    [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
                    [FujiaPrice appendString:@"!"];
                }
                if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
                    PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                    Tpcode=Pcode;
                    TPNAME=PCname;
                    x++;
                }
                else
                {
                    if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                        Tpcode=Pcode;
                        //            TPNAME=PCname;
                        //            TPNUM=[dict objectForKey:@"TPNUM"];
                        x++;
                    }
                    else
                    {
                        if ([dict objectForKey:@"CLASS"]==nil)
                        {
                            NSLog(@"%@",dict);
                            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x-1];
                            pcount=[dict objectForKey:@"total"];
                            isTC=@"1";
                        }
                        else
                        {
                            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                            x++;
                        }
                    }
                    //                    if ([dict objectForKey:@"CLASS"]==nil||[[dict objectForKey:@"CLASS"] isEqualToString:@"(null)"])
                    //                    {
                    //                        NSLog(@"%@",dict);
                    //                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                    //                        TPNUM=[dict objectForKey:@"TPNUM"];
                    //                        CNT=[dict objectForKey:@"CNT"];
                    //                        isTC=@"1";
                    //                    }
                    //                    else
                    //                    {
                    //                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                    //
                    //                        TPNUM=0;
                    //                        x++;
                    //                    }
                }
                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
                if(![db open])
                {
                    NSLog(@"数据库打开失败");
                    return nil;
                }
                else
                {
                    NSLog(@"数据库打开成功");
                }
                NSString *qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,PKID,Pcode,PCname,Tpcode,TPNAME,TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",[info objectForKey:@"immediateOrWait"],CNT];
                NSLog(@"%@",qqq);
                [db executeUpdate:qqq];
                NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
                [db executeUpdate:st];
                NSLog(@"%d",[db commit]);
                [db close];
            }
        }
    }
    else
    {
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            NSLog(@"数据库打开失败");
            return nil;
        }
        else
        {
            NSLog(@"数据库打开成功");
        }
        NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
        [db executeUpdate:st];
        [db close];
    }
    return dict3;
}
// SQLite相关
+ (NSString *)sqlitePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BookSystem.sqlite"];
    return path;
}
//查找本地的发送的菜
+(NSArray *)tableNum:(NSString *)table orderID:(NSString *)order
{
    NSMutableArray *ary = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = [NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@'and orderId='%@' and send='%@'",table,order,@"1"];
        NSLog(@"%@",sqlcmd);
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    return ary;
}
-(NSArray *)AllCheak{
    NSMutableArray *ary = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = [NSString stringWithFormat:@"select Pcode,PCname,sum(Over),sum(pcount),ISTC from AllCheck where tableNum='%@' AND orderId = '%@' AND Time='%@' AND ISTC='%@' AND Send='%@' GROUP BY Pcode;",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"0",@"1"];
        NSLog(@"%@",sqlcmd);
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = [NSString stringWithFormat:@"select Pcode,PCname,pcount,ISTC,Over,Tpcode,CNT from AllCheck where tableNum='%@' AND orderId = '%@' AND Time='%@' AND ISTC='%@' AND Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"1",@"1"];
        NSLog(@"%@",sqlcmd);
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    NSLog(@"%@",ary);
    return ary;
}
-(NSString *)UUIDString{
    NSString *uuid = nil;
    //    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0){
    uuid =[OpenUDID value];
    ////        [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    //    }else{
    //        uuid = [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
    //    }
    return uuid;
}
//登陆
- (NSDictionary *)pLoginUser:(NSDictionary *)info{
    NSString *user,*pwd;
    
    user = [info objectForKey:@"userCode"];
    pwd = [info objectForKey:@"usePass"];
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    //    UIDevice *myDevice = [UIDevice currentDevice];
    //    NSString *deviceID = [myDevice uniqueIdentifier];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&handvId=%@&userCode=%@&userPass=%@",pdaid,[self UUIDString],user,pwd];
    
    NSDictionary *dict = [[self bsService:@"pLoginUser" arg:strParam] objectForKey:@"ns:loginResponse"];
    
    return dict;
}
//开台
- (NSDictionary *)pStart:(NSDictionary *)info{
    //"+start<pdaid:%s;user:%s;table:%s;peoplenum:%s;waiter:%s;acct:%s;>\r\n")},//3.开台start
    NSString *pdaid,*user,*table,*mancount,*womancounts,*pwd;
    //    NSString *cmd;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    //NSLog(@"<#string#>")
    NSDictionary *dict1=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    user = [dict1 objectForKey:@"name"];
    pwd = [dict1 objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    table = [info objectForKey:@"table"];
    NSLog(@"%@",table);
    mancount = [info objectForKey:@"man"];
    womancounts = [info objectForKey:@"woman"];
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@&ktKind=%@&openTablemwyn=%@",pdaid,user,table,mancount,womancounts,@"1",[info objectForKey:@"tag"]];
    NSLog(@"%@",strParam);
    NSDictionary *dict = [[self bsService:@"pStart" arg:strParam] objectForKey:@"ns:startcResponse"];
    NSLog(@"%@",dict);
    return dict;
}


- (NSArray *)getArea{//根据区域区分
    NSMutableArray *ary = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from storearear_mis";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return ary;
}

- (NSArray *)getFloor{//根据楼层区分
    NSMutableArray *ary = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from codedesc where code = 'LC'";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return ary;
}

- (NSArray *)getStatus{//根据状态区分
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    
    NSString *langCode = [langSetting localizedString:@"LangCode"];
    
    if ([langCode isEqualToString:@"en"])
        return [NSArray arrayWithObjects:@"Idle",@"Ordered",@"No order",nil];
    else if ([langCode isEqualToString:@"cn"])
        return [NSArray arrayWithObjects:@"空闲",@"开台未点",@"开台点餐",@"结账",@"已封台",@"换台",@"子台位",@"挂单",@"菜齐",nil];
    else
        return [NSArray arrayWithObjects:@"空閒",@"開台點菜",@"開台未點",nil];
    
}

- (NSDictionary *)dictFromSQL{
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    NSMutableArray *mutAds = [NSMutableArray array];
    NSMutableArray *mutFileList = [NSMutableArray array];
    
    NSMutableArray *mutClass = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        //Generate Ads & FileList
        //1 Ads
        sqlcmd = @"select * from ads";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *name = (char *)sqlite3_column_text(stat, 0);
                [mutAds addObject:[NSString stringWithUTF8String:name]];
            }
        }
        sqlite3_finalize(stat);
        [ret setObject:mutAds forKey:@"Ads"];
        //2 FileList
        sqlcmd = @"select * from imageFile";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *name = (char *)sqlite3_column_text(stat, 0);
                [mutFileList addObject:[NSString stringWithUTF8String:name]];
            }
        }
        sqlite3_finalize(stat);
        [ret setObject:mutFileList forKey:@"FileList"];
        
        
        //Generate Main Menu
        //1. Get image,name of MainMenu
        sqlcmd = @"select * from class";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *background = (char *)sqlite3_column_text(stat,0);
                int type = sqlite3_column_int(stat, 1);
                char *image = (char *)sqlite3_column_text(stat,2);
                char *name = (char *)sqlite3_column_text(stat, 3);
                char *recommend = (char *)sqlite3_column_text(stat, 4);
                
                NSMutableDictionary *mut = [NSMutableDictionary dictionary];
                [mut setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                if (background)
                    [mut setObject:[NSString stringWithUTF8String:background] forKey:@"background"];
                if (image)
                    [mut setObject:[NSString stringWithUTF8String:image] forKey:@"image"];
                if (name)
                    [mut setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
                if (recommend)
                    [mut setObject:[NSString stringWithUTF8String:recommend] forKey:@"recommend"];
                
                [mutClass addObject:mut];
            }
        }
        sqlite3_finalize(stat);
        
        //2. Genereate by Food
        for (int i=0;i<[mutClass count];i++){
            NSMutableDictionary *mutC = [mutClass objectAtIndex:i];
            NSString *strOrder;
            NSString *strPrice = [[NSUserDefaults standardUserDefaults] stringForKey:@"price"];
            if ([strPrice isEqualToString:@"PRICE"])
                strOrder = @"ITEMNO";
            else if ([strPrice isEqualToString:@"PRICE"])
                strOrder = @"ITEMNO2";
            else
                strOrder = @"ITEMNO3";
            sqlcmd = [NSString stringWithFormat:@"select * from food where GRPTYP = %d and HSTA = 'Y' order by %@",[[[mutClass objectAtIndex:i] objectForKey:@"type"] intValue],strOrder];
            NSMutableArray *foods = [NSMutableArray array];
            if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
                while (sqlite3_step(stat)==SQLITE_ROW) {
                    int count = sqlite3_column_count(stat);
                    NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                    for (int i=0;i<count;i++){
                        char *foodKey = (char *)sqlite3_column_name(stat, i);
                        char *foodValue = (char *)sqlite3_column_text(stat, i);
                        NSString *strKey = nil,*strValue = nil;
                        strKey = nil;
                        strValue = nil;
                        if (foodKey)
                            strKey = [NSString stringWithUTF8String:foodKey];
                        if (foodValue)
                            strValue = [NSString stringWithUTF8String:foodValue];
                        if (strKey && strValue)
                            [mutDC setObject:strValue forKey:strKey];
                    }
                    [foods addObject:mutDC];
                }
            }
            sqlite3_finalize(stat);
            
            if (foods && [foods count]>0)
                [mutC setObject:foods forKey:@"SubMenu"];
        }
        
        if (mutClass && [mutClass count]>0)
            [ret setObject:mutClass forKey:@"MainMenu"];
    }
    sqlite3_close(db);
    return ret;
}
NSInteger intSort2(id num1,id num2,void *context){
    int v1 = [[(NSDictionary *)num1 objectForKey:@"ITCODE"] intValue];
    int v2 = [[(NSDictionary *)num2 objectForKey:@"ITCODE"] intValue];
    
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
//查询全部菜品
+ (NSMutableArray *)getFoodList:(NSString *)cmd{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = [NSString stringWithFormat:@"select * from food where %@",cmd];
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    strKey = nil;
                    strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSMutableArray arrayWithArray:[ary sortedArrayUsingFunction:intSort2 context:NULL]];
}

//查套餐明细
-(NSMutableArray *)combo:(NSString *)tag{
    NSString *path1=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:path1];
    if(![db open])
    {
        return Nil;
    }
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSString *str=[NSString stringWithFormat:@"SELECT PRODUCTTC_ORDER FROM products_sub WHERE PCODE = '%@' AND defualtS = '0' GROUP BY PRODUCTTC_ORDER ORDER BY CAST(PRODUCTTC_ORDER as SIGNED) ASC",tag];
    NSLog(@"%@",str);
    FMResultSet *rs = [db executeQuery:str];
    while ([rs next]){
        [array addObject:[rs stringForColumn:@"PRODUCTTC_ORDER"]];
    }
    NSString *str2=[NSString stringWithFormat:@"SELECT * from food where itcode='%@'",tag];
    FMResultSet *rs2 = [db executeQuery:str2];
    NSString *PKID,*pcode,*pcname,*TCMONEYMODE;
    while ([rs2 next]){
        PKID=[rs2 stringForColumn:@"item"];
        pcode=[rs2 stringForColumn:@"itcode"];
        pcname=[rs2 stringForColumn:@"DES"];
        TCMONEYMODE=[rs2 stringForColumn:@"TCMONEYMODE"];
    }
    NSMutableArray *array2=[[NSMutableArray alloc] init];
    for(int j=0;j<[array count];j++){
        NSString *str1=[NSString stringWithFormat:@"SELECT * from products_sub where pcode='%@' and PRODUCTTC_ORDER =%@ ORDER BY defualtS ASC",tag,[array objectAtIndex:j]];
        NSLog(@"%@",str1);
        FMResultSet *rs1 = [db executeQuery:str1];
        NSMutableArray *array1=[[NSMutableArray alloc] init];
        NSString *min,*max;
        while([rs1 next]) {
            if ([[rs1 stringForColumn:@"defualtS"] intValue]==0) {
                min=[rs1 stringForColumn:@"MINCNT"];
                max=[rs1 stringForColumn:@"MAXCNT"];
            }
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];;
            //            //food.PKID=PKID;
            [dict setObject:PKID forKey:@"PKID"];
            [dict setValue:pcode forKey:@"Tpcode"];
            [dict setValue:pcname forKey:@"TPNANE"];
        
            [dict setValue:[rs1 stringForColumn:@"pcode1"] forKey:@"ITCODE"];
            NSLog(@"%@",[rs1 stringForColumn:@"min"]);
            [dict setValue:[rs1 stringForColumn:@"pname"] forKey:@"DES"];
            NSLog(@"%@",[rs1 stringForColumn:@"pname"]);
            [dict setValue:min forKey:@"tpmin"];
            [dict setValue:max forKey:@"tpmax"];
            if (![[rs1 stringForColumn:@"NADJUSTPRICE"] isEqualToString:@"~_NADJUSTPRICE_~"]) {
                [dict setValue:[rs1 stringForColumn:@"NADJUSTPRICE"] forKey:@"addprice"];
            }else
            {
                [dict setValue:@"0.0" forKey:@"addprice"];
            }
            if (![[rs1 stringForColumn:@"GROUPTITLE"] isEqualToString:@"~_GROUPTITLE_~"]) {
                [dict setValue:[rs1 stringForColumn:@"GROUPTITLE"] forKey:@"GROUPTITLE"];
            }else
            {
                [dict setValue:@"" forKey:@"GROUPTITLE"];
            }

//            [dict setValue:[rs1 stringForColumn:@"GROUPTITLE"] forKey:@"GROUPTITLE"];
            [dict setValue:[rs1 stringForColumn:@"MINCNT"] forKey:@"pmin"];
            [dict setValue:[rs1 stringForColumn:@"MAXCNT"] forKey:@"pmax"];
            [dict setValue:[rs1 stringForColumn:@"unit"] forKey:@"UNIT"];
            [dict setValue:[rs1 stringForColumn:@"price1"] forKey:@"PRICE"];
            [dict setValue:[rs1 stringForColumn:@"CNT"] forKey:@"CNT"];
            [dict setValue:TCMONEYMODE forKey:@"TCMONEYMODE"];
            NSString *str1=[NSString stringWithFormat:@"SELECT UNITCUR from food where ITCODE='%@'",[rs1 stringForColumn:@"pcode1"]];
            FMResultSet *rs2 = [db executeQuery:str1];
            while ([rs2 next]) {
                [dict setValue:[rs2 stringForColumn:@"UNITCUR"] forKey:@"Weightflg"];
            }
            [array1 addObject:dict];
        }
        if ([array1 count]>1) {
            [array1 removeObjectAtIndex:0];
        }
        [array2 addObject:array1];
    }
    [db close];
    return array2;
}
-(NSMutableArray *)allCombo{
    NSString *path1=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:path1];
    if(![db open])
    {
        return Nil;
    }
    
    NSString *str=@"SELECT PCODE from products_sub where defualtS = '0' AND PRODUCTTC_ORDER=1 ORDER BY pcode ASC";
    FMResultSet *rs = [db executeQuery:str];
    NSMutableArray *arry=[NSMutableArray array];
    while ([rs next]) {
        NSString *str10=[NSString stringWithFormat:@"SELECT * from food where itcode='%@'",[rs stringForColumn:@"pcode"]];
        FMResultSet *rs10 = [db executeQuery:str10];
        NSString *pcname,*TCMONEYMODE,*price;
        while ([rs10 next]){
            pcname=[rs10 stringForColumn:@"DES"];
            price=[rs10 stringForColumn:@"PRICE"];
            TCMONEYMODE=[rs10 stringForColumn:@"TCMONEYMODE"];
        }

        NSString *str2=[NSString stringWithFormat:@"select PRODUCTTC_ORDER producttc_order from products_sub where pcode=%@ and defualtS='0' ORDER BY PRODUCTTC_ORDER ASC",[rs stringForColumn:@"pcode"]];
        NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
        [dict1 setObject:[rs stringForColumn:@"pcode"] forKey:@"pcode"];
        NSMutableArray *ary=[NSMutableArray array];
        FMResultSet *rs2 = [db executeQuery:str2];
        while ([rs2 next]) {
            NSString *str1=[NSString stringWithFormat:@"select * from products_sub where pcode=%@ and PRODUCTTC_ORDER=%@ ORDER BY defualtS ASC",[rs stringForColumn:@"pcode"],[rs2 stringForColumn:@"PRODUCTTC_ORDER"]];
            FMResultSet *rs1 = [db executeQuery:str1];
            NSMutableArray *array1=[[NSMutableArray alloc] init];
            NSString *min,*max;
            while([rs1 next]) {
                if ([[rs1 stringForColumn:@"defualtS"] intValue]==0) {
                    min=[rs1 stringForColumn:@"MINCNT"];
                    max=[rs1 stringForColumn:@"MAXCNT"];
                }
                if ([[rs1 stringForColumn:@"defualtS"] intValue]==1) {
                    [array1 removeObjectAtIndex:[array1 count]-1];
                }
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                [dict setValue:price forKey:@"tpprice"];
                [dict setValue:[rs1 stringForColumn:@"pcode"] forKey:@"Tpcode"];
                [dict setValue:pcname forKey:@"tpname"];
                [dict setValue:[rs1 stringForColumn:@"ADDPRICE"] forKey:@"addprice"];
                [dict setValue:TCMONEYMODE forKey:@"TCMONEYMODE"];
                [dict setValue:[rs1 stringForColumn:@"PRODUCTTC_ORDER"] forKey:@"producttc"];
                [dict setValue:[rs1 stringForColumn:@"pcode1"] forKey:@"ITCODE"];
                [dict setValue:[rs1 stringForColumn:@"pname"] forKey:@"DES"];
                [dict setValue:min forKey:@"tpmin"];
                [dict setValue:max forKey:@"tpmax"];
                [dict setValue:[rs1 stringForColumn:@"MINCNT"] forKey:@"pmin"];
                [dict setValue:[rs1 stringForColumn:@"MAXCNT"] forKey:@"pmax"];
                [dict setValue:[rs1 stringForColumn:@"unit"] forKey:@"UNIT"];
                [dict setValue:[rs1 stringForColumn:@"price1"] forKey:@"PRICE"];
                [dict setValue:[rs1 stringForColumn:@"CNT"] forKey:@"CNT"];
                if (![[rs1 stringForColumn:@"NADJUSTPRICE"] isEqualToString:@"~_NADJUSTPRICE_~"]) {
                    [dict setValue:[rs1 stringForColumn:@"NADJUSTPRICE"] forKey:@"addprice"];
                }else
                {
                    [dict setValue:@"0.0" forKey:@"addprice"];
                }
                [array1 addObject:dict];
            }
            [ary addObject:array1];
        }
        [dict1 setObject:ary forKey:@"combo"];
        [arry addObject:dict1];
    }
    return arry;
}

//催菜
- (NSDictionary *)pGogo:(NSArray *)array{
    NSString *user;
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],@"",[info objectForKey:@"Tpcode"],@"",[info objectForKey:@"TPNUM"],[info objectForKey:@"pcount"],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],@"",[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],@"",[info objectForKey:@"ISTC"]];
        [mutfood appendString:@";"];
    }
    NSLog(@"%@",mutfood);
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",pdaid,user,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
    
    NSDictionary *dict = [self bsService:@"pGogo" arg:strParam];
    return dict;
}

//=============================================================================================

////当前订单
//+ (NSDictionary *)currentOrder{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentOrder"];
//    if (!dict){
//        if (aryOrders.count>0){
//            dict = [NSDictionary dictionaryWithObjectsAndKeys:aryOrders,@"foods",[NSDate date],@"date", nil];//查询
//            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentOrder"];
//        }
//    }
//
//    return dict;
//}
////缓存菜单
//+ (NSDictionary *)allCachedOrder{
//    return [NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]];
//}
////退菜
//+ (void)removeOrderOfName:(NSString *)name{
//    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
//    [cacheDict removeObjectForKey:name];
//    [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
//    NSDictionary *current = [BSDataProvider currentOrder];
//    if ([name isEqualToString:[current objectForKey:@"name"]]){
//        [aryOrders removeAllObjects];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderedNumber" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderStatus" object:nil];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentOrder"];
//    }
//}
////加菜
//+ (void)importOrderOfName:(NSString *)name{
//    NSDictionary *order = [[BSDataProvider allCachedOrder] objectForKey:name];
//    [aryOrders release];
//    aryOrders = [[order objectForKey:@"foods"] retain];
//    if (!aryOrders)
//        aryOrders = [[NSMutableArray array] retain];
//    [[BSDataProvider sharedInstance] saveOrders];
//
//    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:order];
//    [mut setObject:name forKey:@"name"];
//
//    [[NSUserDefaults standardUserDefaults] setObject:mut forKey:@"CurrentOrder"];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderedNumber" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderStatus" object:nil];
//}
////保存菜
//- (void)saveOrders{
//    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *docPath = [docPaths objectAtIndex:0];
//    NSString *path = [docPath stringByAppendingPathComponent:kOrdersFileName];
//    NSArray *aryOrd = [NSArray arrayWithArray:aryOrders];
//    if ([aryOrd count]>0){
//        NSMutableArray *ary = [NSMutableArray array];
//        for (NSDictionary *dic in aryOrd){
//            if ([[dic objectForKey:@"total"] intValue]!=0)
//                [ary addObject:dic];
//        }
//        if ([ary count]>0){
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:ary forKey:@"orders"];
//            [dict writeToFile:path atomically:NO];
//        }
//    }
//    else{
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:path error:nil];
//    }
//
//    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentOrder"]];
//    [mut setObject:aryOrders forKey:@"foods"];
//    [mut setObject:[NSDate date] forKey:@"date"];
//
//    [[NSUserDefaults standardUserDefaults] setObject:mut forKey:@"CurrentOrder"];//当前订单
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderedNumber" object:nil];
//    //更新点餐数
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderStatus" object:nil];
//    //更新状态
//}
////缓存的菜单
//+ (NSArray *)cachedFoodList{
//    NSDictionary *dict = [BSDataProvider allCachedOrder];
//    //得到缓存的菜单
//    NSMutableArray *mut = [NSMutableArray array];
//
//    for (NSString *key in dict.allKeys){
//        NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:key]];
//        [mutdict setObject:key forKey:@"name"];//菜单名
//        [mut addObject:mutdict];
//    }
//
//    [mut sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSDictionary *dict1 = (NSDictionary *)obj1;
//        NSDictionary *dict2 = (NSDictionary *)obj2;
//
//        double interval = [[dict1 objectForKey:@"date"] timeIntervalSinceDate:[dict2 objectForKey:@"date"]];
//        //时间
//        return interval>0?NSOrderedAscending:(interval<0?NSOrderedDescending:NSOrderedSame);
//    }];
//
//    return mut;
//}
////确认缓存的名称
//+ (BOOL)isCacheNameExist:(NSString *)name{
//    BOOL bExist = NO;
//    NSArray *ary = [BSDataProvider cachedFoodList];
//    for (NSDictionary *cache in ary){
//        if ([[cache objectForKey:@"name"] isEqualToString:name]){
//            bExist = YES;
//            break;
//        }
//    }
//
//    return bExist;
//}
////缓存的食物和名称
//+ (void)saveFoods:(NSArray *)foods withName:(NSString *)name{
//    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:foods,@"foods",[NSDate date],@"date", nil];
//    [cacheDict setObject:dict forKey:name];
//
//    [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
//
//    [aryOrders removeAllObjects];
//    [[BSDataProvider sharedInstance] saveOrders];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderStatus" object:nil userInfo:nil];
//}
//
//+ (void)loadConfig{
//    //  配置文件列表
//    NSArray *ary = [NSArray arrayWithContentsOfFile:[@"PageConfigList.plist" documentPath]];
//    if (!ary)
//        ary = [NSArray arrayWithContentsOfFile:[@"PageConfigListDemo.plist" bundlePath]];
//    NSMutableArray *mut = [NSMutableArray array];
//    for (int i=0;i<ary.count;i++){
//        NSDictionary *dict = [ary objectAtIndex:i];
//        NSString *pathLayout = [dict objectForKey:@"layout"];
//        NSString *pathSQLite = [dict objectForKey:@"sqlite"];
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        BOOL layoutExist = ([fileManager fileExistsAtPath:[pathLayout documentPath]] || [fileManager fileExistsAtPath:[pathLayout bundlePath]]);
//        BOOL sqliteExist = ([fileManager fileExistsAtPath:[pathSQLite documentPath]] || [fileManager fileExistsAtPath:[pathSQLite bundlePath]]);
//        if (layoutExist && sqliteExist)
//            [mut addObject:dict];
//    }
//    aryPageConfigList = mut>0?[[NSArray arrayWithArray:mut] retain]:nil;
//
//    //  当前选择的配置
//    NSDictionary *pageConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentPageConfig"];
//    if (!pageConfig){
//        NSArray *ary = aryPageConfigList;
//        if (ary.count>0)
//            pageConfig = [ary objectAtIndex:0];
//        if (!pageConfig){
//            pageConfig = [NSDictionary dictionaryWithObjectsAndKeys:@"PageConfigDemo.plist",@"layout",@"BookSystem.sqlite",@"sqlite",@"Demo",@"name",@"1",@"number", nil];
//            [[NSUserDefaults standardUserDefaults] setObject:pageConfig
//                                                      forKey:@"CurrentPageConfig"];
//        }
//    }
//    dicCurrentPageConfig = [pageConfig retain];
//
//
//    //  当前选择的配置的详细
//    NSDictionary *dict = dicCurrentPageConfig;
//    NSString *layout = [dict objectForKey:@"layout"];
//
//    NSString *path = [layout documentPath];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
//        path = [layout bundlePath];
//
//    dict = [NSDictionary dictionaryWithContentsOfFile:path];
//
//
//    //  当前选择的页面配置的所有主页面列表
//    ary = [dict objectForKey:@"PageList"];
//
//    NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    NSMutableArray *mutary = [NSMutableArray arrayWithArray:ary];
//    NSArray *recommends = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecommendList"];
//    if (recommends.count>0){
//        int index = -1;
//        for (int i=0;i<mutary.count;i++){
//            if ([[[mutary objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"推荐菜"]){
//                index = i;
//                break;
//            }
//        }
//
//        if (index>=0){
//            for (int i=mutary.count-1;i>=0 && i<mutary.count;i--){
//                NSDictionary *dict = [mutary objectAtIndex:i];
//                if ([[dict objectForKey:@"type"] isEqualToString:@"推荐菜"])
//                    [mutary removeObject:dict];
//            }
//
//            for (int i=recommends.count;i>=0 && i<recommends.count;i--){
//                [mutary insertObject:[recommends objectAtIndex:i] atIndex:index];
//            }
//        }
//    }
//
//    [mutdict setObject:mutary forKey:@"PageList"];
//    aryAllPages = [[NSArray arrayWithArray:mutary] retain];
//    dicCurrentPageConfigDetail = [[NSDictionary dictionaryWithDictionary:mutdict] retain];
//
//    //  当前选择的页面配置的详情页面列表
//    ary = [dicCurrentPageConfigDetail objectForKey:@"PageList"];
//    mut = [NSMutableArray array];
//
//    for (int i=0;i<[ary count];i++){
//        NSDictionary *dict = [ary objectAtIndex:i];
//
//        if ([[dict objectForKey:@"type"] isEqualToString:@"菜品列表"]){
//            NSArray *foods = [dict objectForKey:@"foods"];
//            for (int j=0;j<[foods count];j++){
//                NSArray *itcodes = [[[foods objectAtIndex:j] objectForKey:@"ITCODE"] componentsSeparatedByString:@","];
//                NSString *itcode = [itcodes objectAtIndex:0];
//
//                NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where ITCODE = '%@'",itcode]]];
//                [mutdict setObject:@"菜品详情" forKey:@"type"];
//                [mutdict setObject:[dict objectForKey:@"classid"] forKey:@"classid"];
//                NSDictionary *video = [[foods objectAtIndex:j] objectForKey:@"video"];
//                if (video)
//                    [mutdict setObject:video forKey:@"video"];
//                NSString *bg = [[foods objectAtIndex:j] objectForKey:@"background"];
//                if (!bg)
//                    bg = [dict objectForKey:@"background"];
//
//                if (bg)
//                    [mutdict setObject:bg forKey:@"background"];
//
//                [mut addObject:mutdict];//添加一页
//            }
//        }
//
//    }
//    aryAllDetailPages = [mut count]>0?[[NSArray arrayWithArray:mut] retain]:nil;
//}
////重新配置文件
//+ (void)reloadConfig{
//    [dicCurrentPageConfigDetail release];
//    dicCurrentPageConfigDetail = nil;
//
//    [dicCurrentPageConfig release];
//    dicCurrentPageConfig = nil;
//
//    [aryPageConfigList release];
//    aryPageConfigList = nil;
//
//    [aryAllPages release];
//    aryAllPages = nil;
//
//    [aryAllDetailPages release];
//    aryAllDetailPages = nil;
//}
////zhang
////+(NSMutableArray *)selectFood:(int)tag
////{
////    NSString *path = [BSDataProvider sqlitePath];
////    FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
////    if(![db open])
////    {
////        [db release];
////        return nil;
////    }
////    NSMutableArray *array=[[NSMutableArray alloc] init];
////    NSString *str=[NSString stringWithFormat:@"select * from food where CLASS=%d and GRPTYP=%d",tag,tag];
////    FMResultSet *rs = [db executeQuery:str];
////    NSLog(@"rs=%@",rs);
////    while ([rs next]){
////        AKFood *article = [[AKFood alloc]init];
////        article.name =[rs stringForColumn:@"DES"];
////        NSLog(@"name%@",article.name);
////        //name=_name,itcode=_itcode,item=_item,price=_price,unit=_unit;
////        article.itcode=[rs stringForColumn:@"ITCODE"];
////        article.item=[rs stringForColumn:@"ITEM"];
////        article.price=[[rs stringForColumn:@"price"] intValue];
////        article.unit=[rs stringForColumn:@"UNIT"];
////        [array addObject:article];
////        [article release];
////    }
////    [db close];
////    [db release];
////    return array;
////}
//
////载入当前页的配置
//+ (void)reloadCurrentPageConfig{
//    [dicCurrentPageConfigDetail release];
//    dicCurrentPageConfigDetail = nil;
//
//    [dicCurrentPageConfig release];
//    dicCurrentPageConfig = nil;
//
//    [aryAllPages release];
//    aryAllPages = nil;
//
//    [aryAllDetailPages release];
//    aryAllDetailPages = nil;
//
//    NSDictionary *pageConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentPageConfig"];
//    if (!pageConfig){
//        NSArray *ary = aryPageConfigList;
//        if (ary.count>0)
//            pageConfig = [ary objectAtIndex:0];
//        if (!pageConfig){
//            pageConfig = [NSDictionary dictionaryWithObjectsAndKeys:@"PageConfigDemo.plist",@"layout",@"BookSystem.sqlite",@"sqlite",@"Demo",@"name",@"1",@"number", nil];
//            [[NSUserDefaults standardUserDefaults] setObject:pageConfig
//                                                      forKey:@"CurrentPageConfig"];
//        }
//    }
//    dicCurrentPageConfig = [pageConfig retain];
//
//    NSDictionary *dict = dicCurrentPageConfig;
//    NSString *layout = [dict objectForKey:@"layout"];
//
//    NSString *path = [layout documentPath];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
//        path = [layout bundlePath];
//
//    dict = [NSDictionary dictionaryWithContentsOfFile:path];
//
//    NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:dict];
//    NSMutableArray *mutary = [NSMutableArray arrayWithArray:[mutdict objectForKey:@"PageList"]];
//    NSArray *ary = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecommendList"];
//    if (ary.count>0){
//        int index = -1;
//        for (int i=0;i<mutary.count;i++){
//            if ([[[mutary objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"推荐菜"]){
//                index = i;
//                break;
//            }
//        }
//
//        if (index>=0){
//            for (int i=mutary.count-1;i>=0 && i<mutary.count;i--){
//                NSDictionary *dict = [mutary objectAtIndex:i];
//                if ([[dict objectForKey:@"type"] isEqualToString:@"推荐菜"])
//                    [mutary removeObject:dict];
//            }
//
//            for (int i=ary.count-1;i>=0 && i<ary.count;i--){
//                [mutary insertObject:[ary objectAtIndex:i] atIndex:index];
//            }
//        }
//    }
//
//    [mutdict setObject:mutary forKey:@"PageList"];
//
//    dicCurrentPageConfigDetail = [mutdict retain];
//
//    aryAllPages = [mutary retain];
//
//    //  当前选择的页面配置的详情页面列表
//    ary = aryAllPages;
//    NSMutableArray *mut = [NSMutableArray array];
//
//    for (int i=0;i<[ary count];i++){
//        NSDictionary *dict = [ary objectAtIndex:i];
//
//        if ([[dict objectForKey:@"type"] isEqualToString:@"菜品列表"]){
//            NSArray *foods = [dict objectForKey:@"foods"];
//            for (int j=0;j<[foods count];j++){
//                NSArray *itcodes = [[[foods objectAtIndex:j] objectForKey:@"ITCODE"] componentsSeparatedByString:@","];
//                NSString *itcode = [itcodes objectAtIndex:0];
//
//                NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where ITCODE = '%@'",itcode]]];
//                [mutdict setObject:@"菜品详情" forKey:@"type"];
//                [mutdict setObject:[dict objectForKey:@"classid"] forKey:@"classid"];
//                NSDictionary *video = [[foods objectAtIndex:j] objectForKey:@"video"];
//                if (video)
//                    [mutdict setObject:video forKey:@"video"];
//                NSString *bg = [[foods objectAtIndex:j] objectForKey:@"background"];
//                if (!bg)
//                    bg = [dict objectForKey:@"background"];
//
//                if (bg)
//                    [mutdict setObject:bg forKey:@"background"];
//
//                [mut addObject:mutdict];//添加一页
//            }
//        }
//
//    }
//    aryAllDetailPages = [mut count]>0?[[NSArray arrayWithArray:mut] retain]:nil;
//}
////共享
//+ (BSDataProvider *)sharedInstance {
//    @synchronized(self) {
//        if (sharedInstance == nil) {
//            sharedInstance = [[super allocWithZone:NULL] init];
//
//            [BSDataProvider loadConfig];
//            //		CVDataProviderSetting *s = [CVDataProviderSetting sharedInstance];
//			_loadingMutex = [[NSLock alloc] init];
//            aryOrders = [[NSMutableArray alloc] init];
//            NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docPath = [docPaths objectAtIndex:0];
//            NSString *path = [docPath stringByAppendingPathComponent:kOrdersFileName];
//            NSDictionary *dicOrders = [NSDictionary dictionaryWithContentsOfFile:path];
//            NSArray *ary = [dicOrders objectForKey:@"orders"];
//
//            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:kOrdersCountFileName]];
//            if (!dic){
//                dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"count"];
//                [dic writeToFile:[docPath stringByAppendingPathComponent:kOrdersCountFileName] atomically:NO];
//            }
//
//
//
//            dSendCount = [[dic objectForKey:@"count"] intValue];
//            [aryOrders addObjectsFromArray:ary];
//
//
//            dic = [NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"pdaid.plist"]];
//            if (!dic){
//                dic = [NSDictionary dictionaryWithObject:@"8" forKey:@"pdaid"];
//                [dic writeToFile:[docPath stringByAppendingPathComponent:@"pdaid.plist"] atomically:NO];
//            }
//        }
//    }
//    return sharedInstance;
//}
//
//
//
//+ (id)allocWithZone:(NSZone *)zone {
//    return [[self sharedInstance] retain];
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}
//
//- (id)retain {
//    return self;
//}
//
//- (unsigned)retainCount {
//    return UINT_MAX;  //denotes an object that cannot be released
//}
//
//- (oneway void)release {
//	//[_cache release];
//}
//
//- (id)autorelease {
//    return self;
//}
//
///*
// #pragma mark -  Upload Using FTP
// -(void) requestCompleted:(WRRequest *) request{
//
// //called if 'request' is completed successfully
// NSLog(@"%@ completed!", request);
// [request release];
//
// }
//
// -(void) requestFailed:(WRRequest *) request{
//
// //called after 'request' ends in error
// //we can print the error message
// NSLog(@"%@", request.error.message);
// [request release];
//
// }
//
// -(BOOL) shouldOverwriteFileWithRequest:(WRRequest *)request {
//
// //if the file (ftp://xxx.xxx.xxx.xxx/space.jpg) is already on the FTP server,the delegate is asked if the file should be overwritten
// //'request' is the request that intended to create the file
// return YES;
//
// }
// */
////- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag{
////    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
////    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
////    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
////    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
////    //PKID=_PKID,Pcode=_Pcode,PCname=_PCname,Tpcode=_Tpcode,TPNAME=_TPNAME,TPNUM=_TPNUM,pcount=_pcount,Fujiacode=_Fujiacode,Price=_Price,Weight=_Weight,Weightflg=_Weightflg
////    NSMutableString *mutfood = [NSMutableString string];
////    int x;
////    for (int i=0; i<ary.count; i++) {
////        NSDictionary *dict=[[ary objectAtIndex:i] objectForKey:@"food"];
////        NSLog(@"%@",dict);
////        NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum;
////        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice,*UNIT;
////        Fujiacode=[NSMutableString string];
////        FujiaName=[NSMutableString string];
////        FujiaPrice=[NSMutableString string];
////        if ([dict objectForKey:@"CLASS"]) {
////            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
////            Pcode=[dict objectForKey:@"ITCODE"];
////            PCname=[dict objectForKey:@"DES"];
////            Tpcode=[dict objectForKey:@"Tpcode"];
////            TPNAME=[dict objectForKey:@"TPNANE"];
////            if ([[dict objectForKey:@"ISTC"] intValue]==1) {
////                Tpcode=Pcode;
////                TPNAME=PCname;
////                x=i;
////            }
////        }
////        else
////        {
////            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
////            Pcode=[dict objectForKey:@"ITCODE"];
////            PCname=[dict objectForKey:@"DES"];
////            Tpcode=[dict objectForKey:@"Tpcode"];
////            TPNAME=[dict objectForKey:@"TPNAME"];
////            isTC=@"1";
////        }
////        [dict setValue:@"1" forKey:@"pcount"];
////
////        NSArray *array=[dict objectForKey:@"addition"];
////        for (NSDictionary *dict1 in array) {
////            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
////            [Fujiacode appendString:@"!"];
////            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
////            [FujiaName appendString:@"!"];
////            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
////            [FujiaPrice appendString:@"!"];
////        }
////        TPNUM=[dict objectForKey:@"TPNUM"];
////        pcount=@"1";
////        Price=[dict objectForKey:@"PRICE"];
////        Weight=[dict objectForKey:@"Weight"];
////        promonum=[dict objectForKey:@"promonum"];
////        Weightflg=[dict objectForKey:@"Weightflg"];
////        UNIT=[dict objectForKey:@"UNIT"];
////        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,Pcode,PCname,Tpcode,TPNAME,TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC];
////        [mutfood appendString:@";"];
////    }
////    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood];
////
////    NSDictionary *dict = [self bsService:@"checkFoodAvailable" arg:strParam];
////    if (dict) {
////        NSString *result = [[[dict objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
////        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
////        NSString *str=[ary1 objectAtIndex:0];
////        if ([str isEqualToString:@"0"]) {
////            for (int i=0; i<ary.count; i++) {
////                NSDictionary *dict1=[[ary objectAtIndex:i] objectForKey:@"food"];
////                NSLog(@"%@",dict1);
////                NSString *PKID1,*Pcode1,*PCname1,*Tpcode1,*TPNAME1,*TPNUM1,*pcount1,*Price1,*Weight1,*Weightflg1,*isTC1,*promonum1,*class1;
////                NSMutableString *Fujiacode1,*FujiaName1,*FujiaPrice1,*UNIT1;
////                Fujiacode1=[NSMutableString string];
////                FujiaName1=[NSMutableString string];
////                FujiaPrice1=[NSMutableString string];
////                if ([dict1 objectForKey:@"CLASS"]) {
////                    PKID1=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
////                    Pcode1=[dict1 objectForKey:@"ITCODE"];
////                    PCname1=[dict1 objectForKey:@"DES"];
////                    Tpcode1=[dict1 objectForKey:@"Tpcode"];
////                    TPNAME1=[dict1 objectForKey:@"TPNAME"];
////                    class1=[dict1 objectForKey:@"CLASS"];
////                    if ([[dict1 objectForKey:@"ISTC"] intValue]==1) {
////                        Tpcode1=Pcode1;
////                        TPNAME1=PCname1;
////                        x=i;
////                    }
////                }
////                else
////                {
////                    PKID1=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
////                    Pcode1=[dict objectForKey:@"ITCODE"];
////                    PCname1=[dict objectForKey:@"DES"];
////                    Tpcode1=[dict objectForKey:@"Tpcode"];
////                    TPNAME1=[dict objectForKey:@"TPNAME"];
////                    isTC1=@"1";
////
////                }
////                [dict setValue:@"1" forKey:@"pcount"];
////
////                NSArray *array=[dict1 objectForKey:@"addition"];
////                for (NSDictionary *dict2 in array) {
////                    [Fujiacode1 appendFormat:@"%@",[dict2 objectForKey:@"FOODFUJIA_ID"]];
////                    [Fujiacode1 appendString:@"!"];
////                    [FujiaName1 appendFormat:@"%@",[dict2 objectForKey:@"FoodFuJia_Des"]];
////                    [FujiaName1 appendString:@"!"];
////                    [FujiaPrice1 appendFormat:@"%@",[dict2 objectForKey:@"FoodFujia_Checked"]];
////                    [FujiaPrice1 appendString:@"!"];
////                }
////                TPNUM1=[dict1 objectForKey:@"TPNUM"];
////                pcount1=@"1";
////                Price1=[dict1 objectForKey:@"PRICE"];
////                Weight1=[dict1 objectForKey:@"Weight"];
////                promonum1=[dict1 objectForKey:@"promonum"];
////                Weightflg1=[dict1 objectForKey:@"Weightflg"];
////                UNIT1=[dict1 objectForKey:@"UNIT"];
////                isTC1=[dict1 objectForKey:@"ISTC"];
////                if ([isTC1 isEqualToString:@"1"]) {
////                    Tpcode1=Pcode1;
////                    TPNAME1=PCname1;
////                    TPNUM1=[dict1 objectForKey:@"TPNUM"];
////                }
////                else
////                {
////                    TPNUM1=@"0";
////                }
////                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
////                if(![db open])
////                {
////                    [db release];
////                    NSLog(@"数据库打开失败");
////                    return nil;
////                }
////                else
////                {
////                    NSLog(@"数据库打开成功");
////                }
////                NSString *qqq=[NSString stringWithFormat:@"insert into AllCheck values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,PKID1,Pcode1,PCname1,Tpcode1,TPNAME1,@"0",pcount1,promonum1,Fujiacode1,FujiaName1,Price1,FujiaPrice1,Weight1,Weightflg1,UNIT1,isTC1,@"0",@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",class1];
////                NSLog(@"%@",qqq);
////                [db executeUpdate:qqq];
////                NSString *st=[NSString stringWithFormat:@"delete AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
////                [db executeUpdate:st];
////                NSLog(@"%d",[db commit]);
////                [db close];
////                [db release];
////            }
////        }
////    }
////    return dict;
////}
//
////上传菜
///*
// - (void)uploadFood:(NSString *)str{
// bs_dispatch_sync_on_main_thread(^{
// NSString *settingPath = [@"setting.plist" documentPath];
// NSDictionary *didict= [NSDictionary dictionaryWithContentsOfFile:settingPath];
// NSString *ftpurl = nil;
// if (didict!=nil)
// ftpurl = [didict objectForKey:@"url"];
//
// if (!ftpurl)
// ftpurl = kPathHeader;
// WRRequestUpload *uploader = [[WRRequestUpload alloc] init];
// uploader.delegate = self;
// uploader.hostname = [ftpurl hostName];
// uploader.username = [[ftpurl account] objectForKey:@"username"];
// uploader.password = [[ftpurl account] objectForKey:@"password"];
//
// uploader.sentData = [str dataUsingEncoding:NSUTF8StringEncoding];
//
// NSString *filename = [NSString stringWithFormat:@"%@%lf",[NSString UUIDString],[[NSDate date] timeIntervalSince1970]];
// uploader.path = [NSString stringWithFormat:@"/orders/%@.order",[filename MD5]];
//
// [uploader start];
// });
// }
// */
//#pragma mark -
//#pragma mark Data Get & Refresh
//
//
////更新配置
//- (void)updateData{
//
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *docPath = [docPaths objectAtIndex:0];
//    //    NSDictionary *attribute;
//    NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
//    NSDictionary *didict= [[NSDictionary alloc] initWithContentsOfFile:settingPath];
//    NSString *ftpurl = nil;
//    if (didict!=nil)
//        ftpurl = [didict objectForKey:@"url"];
//
//    if (!ftpurl)
//        ftpurl = kPathHeader;
//    ftpurl = [ftpurl stringByAppendingPathComponent:@"BookSystem.sqlite"];
//
//    NSURL *url = nil;
//	NSURLRequest *request;
//	url = [NSURL URLWithString:ftpurl];
//	request = [[NSURLRequest alloc] initWithURL:url
//									cachePolicy:NSURLRequestUseProtocolCachePolicy
//								timeoutInterval:2.0];
//
//
//	// retreive the data using timeout
//	NSURLResponse* response;
//	NSError *error;
//
//
//	error = nil;
//	response = nil;
//	NSData *serviceData = [NSURLConnection sendSynchronousRequest:request
//                                                returningResponse:&response
//                                                            error:&error];
//	[request release];
//	// 1001 is the error code for a connection timeout
//	if (!serviceData) {
//		NSLog( @"Server timeout!" );
//        [didict release];
//        return;
//	}
//
//
//    NSData *sqldata = [[NSData alloc] initWithContentsOfURL:url];
//
//
//    //   NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:url];
//
//    if (sqldata){
//        [sqldata writeToFile:[docPath stringByAppendingPathComponent:@"BookSystem.sqlite"] atomically:NO];
//        [sqldata release];
//        infoDict = [[NSDictionary alloc] initWithDictionary:[self dictFromSQL]];
//    }
//    else{
//        [sqldata release];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Download Data Failed,Please check your ftp setting and re-lanuch the app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//
//        [didict release];
//        return;
//    }
//
//
//    NSArray *fileNames = [BSDataProvider getDataFromSQLByCommand:@"select * from FileList" sqlName:@"BookSystem.sqlite"];
//    int count = [fileNames count];
//
//
//
//    for (int i=0;i<count;i++){
//        NSString *fileName = [[fileNames objectAtIndex:i] objectForKey:@"name"];
//        NSString *path = [docPath stringByAppendingPathComponent:fileName];
//
//        BOOL bFileExist = [fileManager fileExistsAtPath:path];
//
//        if (!bFileExist){
//            NSString *strURL = [[ftpurl stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
//            NSData *sqldata = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//            [sqldata writeToFile:path atomically:NO];
//        }
//    }
//
//    [didict release];
//}
//
//- (NSArray *)getADNames{
//    return [infoDict objectForKey:@"Ads"];
//}
//
//- (void)refreshFiles{
//    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *docPath = [docPaths objectAtIndex:0];
//    NSArray *fileNames = nil;
//    NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
//    NSDictionary *didict= [NSDictionary dictionaryWithContentsOfFile:settingPath];
//    NSString *ftpurl = nil;
//    if (didict!=nil)
//        ftpurl = [didict objectForKey:@"url"];
//
//    if (!ftpurl)
//        ftpurl = kPathHeader;
//    ftpurl = [ftpurl stringByAppendingPathComponent:@"BookSystem.sqlite"];
//
//
//    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ftpurl]];
//    [imgData writeToFile:[docPath stringByAppendingPathComponent:@"BookSystem.sqlite"] atomically:NO];
//    [imgData release];
//    infoDict = [self dictFromSQL];
//    fileNames = [BSDataProvider getDataFromSQLByCommand:@"select * from FileList" sqlName:@"BookSystem.sqlite"];
//    int count = [fileNames count];
//    for (int i=0;i<count;i++){
//        NSString *fileName = [[fileNames objectAtIndex:i] objectForKey:@"name"];
//        NSString *path = [docPath stringByAppendingPathComponent:fileName];
//        NSString *strURL = [[ftpurl stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
//        imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//        [imgData writeToFile:path atomically:NO];
//    }
//}
////得到全部的菜
//- (NSArray *)getAllFoods{
//    NSMutableArray *ary = [NSMutableArray array];
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from food";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//                    strKey = nil;
//                    strValue = nil;
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
//

//
//
//- (NSMutableArray *)getCodeDesc{
//    NSMutableArray *ary = [NSMutableArray array];
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from codedesc";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
//- (NSMutableArray *)getClassList{
//    NSMutableArray *ary = [NSMutableArray array];
//
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from class";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
//- (NSDictionary *)getClassByID:(NSString *)classid{
//    NSMutableArray *ary = [NSMutableArray array];
//
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = [NSString stringWithFormat:@"select * from class where GRP = %@",classid];
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return [ary count]>0?[ary objectAtIndex:0]:nil;
//}
//
//- (NSArray *)getCovers{
//    NSMutableArray *ary = [NSMutableArray array];
//
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from cover";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey=nil,*strValue=nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
////获得logo
//- (NSArray *)getCaptions{
//    NSMutableArray *ary = [NSMutableArray array];
//
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from caption";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey=nil,*strValue=nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
//
//- (NSArray *)getAccounts{
//    NSMutableArray *ary = [NSMutableArray array];
//
//    NSString *path = [BSDataProvider sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        sqlcmd = @"select * from user";
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    return ary;
//}
//- (NSDictionary *)dataDict{
//    return infoDict;
//}
//
//- (void)getCachedFile{
//    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *docPath = [docPaths objectAtIndex:0];
//    NSArray *fileNames = nil;
//    NSString *ftpurl = nil;
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:[docPath stringByAppendingPathComponent:@"BookSystem.sqlite"]])
//    {
//        NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
//        NSDictionary *didict= [[NSDictionary alloc] initWithContentsOfFile:settingPath];
//
//        if (didict!=nil)
//            ftpurl = [didict objectForKey:@"url"];
//
//        if (!ftpurl)
//            ftpurl = kPathHeader;
//        ftpurl = [ftpurl stringByAppendingPathComponent:@"BookSystem.sqlite"];
//
//        NSData *sqldata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ftpurl]];
//        [sqldata writeToFile:[docPath stringByAppendingPathComponent:@"BookSystem.sqlite"] atomically:NO];
//        [didict release];
//        [sqldata release];
//    }
//
//    fileNames = [BSDataProvider getDataFromSQLByCommand:@"select * from FileList" sqlName:@"BookSystem.sqlite"];
//    if (![fileNames isKindOfClass:[NSArray class]]){
//        NSString *fileName = (NSString *)fileNames;
//        NSString *path = [docPath stringByAppendingPathComponent:fileName];
//        if (![fileManager fileExistsAtPath:path]){
//            NSString *strURL = [[ftpurl stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
//            NSData *sqldata = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//            [sqldata writeToFile:path atomically:NO];
//        }
//    }else{
//        int count = [fileNames count];
//        for (int i=0;i<count;i++){
//            NSString *fileName = [[fileNames objectAtIndex:i] objectForKey:@"name"];
//            NSString *path = [docPath stringByAppendingPathComponent:fileName];
//            if (![fileManager fileExistsAtPath:path]){
//                NSString *strURL = [[ftpurl stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
//                NSData *sqldata = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//                [sqldata writeToFile:path atomically:NO];
//            }
//
//        }
//    }
//
//}
//
//- (void)writeToServer:(const uint8_t *)buf{
//    [oStream write:buf maxLength:strlen((char*)buf)];
//}
//
//
//
//#pragma mark -
//#pragma mark 上传菜品，催菜，退菜，查询订单
//- (void)orderFood:(NSDictionary *)info{
//    //info包括菜品信息＋数量＋附加项
//    //增加价格和单位信息
//    if ([info objectForKey:@"food"]){
//        int i = [[NSUserDefaults standardUserDefaults] integerForKey:@"OrderTimeCount"];
//        i++;
//        NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:info];
//        if (![mut objectForKey:@"unitKey"]){
//            [mut setObject:@"UNIT" forKey:@"unitKey"];
//            [mut setObject:@"PRICE" forKey:@"priceKey"];
//        }
//        [mut setObject:[NSNumber numberWithInt:i] forKey:@"OrderTimeCount"];
//        [mut setObject:[NSNumber numberWithBool:NO] forKey:@"isPack"];
//        [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"OrderTimeCount"];
//        info = [NSDictionary dictionaryWithDictionary:mut];
//        [aryOrders addObject:info];
//    }else if ([info objectForKey:@"foods"]){
//        NSArray *ary = [info objectForKey:@"foods"];
//        int j = [[NSUserDefaults standardUserDefaults] integerForKey:@"OrderTimeCount"];
//        j++;
//        NSMutableArray *foods = [NSMutableArray array];
//        for (int i=0;i<[ary count];i++){
//            NSDictionary *dict = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where ITEM = %@",[[ary objectAtIndex:i] objectForKey:@"ITEM"]]];
//
//            if (dict){
//                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dict];
//                [mut setObject:[info objectForKey:@"food"] forKey:@"ITCODE"];
//                [mut setObject:@"1" forKey:@"PACKCNT"];
//                [mut setObject:@"1" forKey:@"total"];
//
//
//                //                info = [NSDictionary dictionaryWithDictionary:mut];
//
//                [foods addObject:mut];
//            }
//
//        }
//        NSMutableDictionary *mutdict = [NSMutableDictionary dictionaryWithDictionary:info];
//        [mutdict setObject:[NSNumber numberWithInt:j] forKey:@"OrderTimeCount"];
//        [mutdict setObject:foods forKey:@"foods"];
//        [mutdict setObject:[NSNumber numberWithBool:YES] forKey:@"isPack"];
//        if (![mutdict objectForKey:@"unitKey"]){
//            [mutdict setObject:@"UNIT" forKey:@"unitKey"];
//            [mutdict setObject:@"PRICE" forKey:@"priceKey"];
//        }
//        [aryOrders addObject:mutdict];
//
//        [[NSUserDefaults standardUserDefaults] setInteger:j forKey:@"OrderTimeCount"];
//    }
//    [self saveOrders];
//
//}
////-(NSMutableArray *)combo:(NSString *)tag{
////    NSString *path = [BSDataProvider sqlitePath];
////    FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
////    if(![db open])
////    {
////        [db release];
////        return Nil;
////    }
////    NSMutableArray *array=[[NSMutableArray alloc] init];
////    //    SELECT PRODUCTTC_ORDER FROM products_sub WHERE PCODE = '%1' AND defualtS = '0' GROUP BY PRODUCTTC_ORDER
////    NSString *str=[NSString stringWithFormat:@"SELECT * from products_sub where pcode='%@' GROUP BY producttc_order",tag];
////    FMResultSet *rs = [db executeQuery:str];
////    int i=0;
////    while ([rs next]){
////        i++;
////        NSLog(@"%d",i);
////    }
////    NSString *str2=[NSString stringWithFormat:@"SELECT * from food where itcode='%@'",tag];
////    FMResultSet *rs2 = [db executeQuery:str2];
////    NSString *PKID,*pcode,*pcname;
////    while ([rs2 next]){
////        PKID=[rs2 stringForColumn:@"item"];
////        pcode=[rs2 stringForColumn:@"itcode"];
////        pcname=[rs2 stringForColumn:@"des"];
////    }
////    for(int j=0;j<i;j++){
////        NSString *str1=[NSString stringWithFormat:@"SELECT * from products_sub where pcode='%@' and producttc_order =%d",tag,j+1];
////        FMResultSet *rs1 = [db executeQuery:str1];
////        NSMutableArray *array1=[[NSMutableArray alloc] init];
////        while([rs1 next]) {
////            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];;
////            //food.PKID=PKID;
////            [dict setValue:PKID forKey:@"PKID"];
////            [dict setValue:pcode forKey:@"Tpcode"];
////            [dict setValue:pcname forKey:@"TPNANE"];
////            [dict setValue:[rs1 stringForColumn:@"pcode1"] forKey:@"ITCODE"];
////            NSLog(@"%@",[rs1 stringForColumn:@"subid"]);
////            [dict setValue:[rs1 stringForColumn:@"pname"] forKey:@"DES"];
////            NSLog(@"%@",[rs1 stringForColumn:@"pname"]);
////            [dict setValue:[rs1 stringForColumn:@"producttc_order"] forKey:@"TPNUM"];
////            [dict setValue:[rs1 stringForColumn:@"unit"] forKey:@"UNIT"];
////            [dict setValue:[rs1 stringForColumn:@"price1"] forKey:@"PRICE"];
////            //            food.Tpcode=[rs1 stringForColumn:@"subid"];
////            //            food.TPNAME=[rs1 stringForColumn:@"pname"];
////            //            //NSString *str2=[rs1 stringForColumn:@"pcode1"];
////            //            food.TPNUM=[rs1 stringForColumn:@"producttc_order"];
////            //            food.Weightflg=[rs1 stringForColumn:@"unit"];
////            //            food.Price=[rs1 stringForColumn:@"price1"];
////            //            food.pcount=@"1";
////            [array1 addObject:dict];
////            NSLog(@"%@",dict);
////        }
////        [array addObject:array1];
////        NSLog(@"%@",array);
////        [array1 release];
////    }
////    [db close];
////    [db release];
////    return array;
////}
//
//- (NSMutableArray *)orderedFood{
//    return aryOrders;
//}
//


//
////结账
//- (NSDictionary *)pQuery:(NSDictionary *)info{
//    NSMutableDictionary *dicMut = [NSMutableDictionary dictionary];
//
//    NSString *user,*pwd;
//    NSString *pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//    user = [info objectForKey:@"user"];
//    pwd = [info objectForKey:@"pwd"];
//    if (pwd)
//        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
//    NSString *table = [info objectForKey:@"table"];
//
//    NSString *strParam = [NSString stringWithFormat:@"?PdaID=%@&User=%@&TblInit=%@&iRecNo=0",pdaid,user,table];
//
//    NSDictionary *dict = [self bsService:@"pQuery" arg:strParam];
//    NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"Buffer"] objectForKey:@"text"];//[[[[[[dict objectForKey:@"string"] objectForKey:@"text"]  componentsSeparatedByString:@"<Buffer>"] objectAtIndex:1] componentsSeparatedByString:@"</Buffer>"] objectAtIndex:0];
//    NSArray *ary = [result componentsSeparatedByString:@"<"];
//
//    if ([result rangeOfString:@"error"].location!=NSNotFound){
//        [dicMut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
//        [dicMut setObject:[[[[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] forKey:@"Message"];
//    }else{
//        if (![result isEqualToString:@"+query<end>"]){
//
//            NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
//
//            NSArray *aryFenhao = [content componentsSeparatedByString:@";"];
//            if ([aryFenhao count]>3){
//                NSString *tab = [[[aryFenhao objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1];
//                NSString *total = [[[aryFenhao objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1];
//                NSString *people = [[[aryFenhao objectAtIndex:2] componentsSeparatedByString:@":"] objectAtIndex:1];
//
//                [dicMut setObject:tab forKey:@"tab"];
//                [dicMut setObject:total forKey:@"total"];
//                [dicMut setObject:people forKey:@"people"];
//
//                NSString *account = [[[aryFenhao objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1];
//                NSArray *aryAcc = [account componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
//                int countAcc = [aryAcc count];
//
//                NSMutableArray *aryMut = [NSMutableArray array];
//                for (int i=0;i<countAcc;i++){
//                    NSMutableDictionary *mutFood = [NSMutableDictionary dictionary];
//                    NSString *strAcc = [aryAcc objectAtIndex:i];
//                    NSArray *aryStr = [strAcc componentsSeparatedByString:@"^"];
//
//                    if ([aryStr count]>8){
//                        [mutFood setObject:[aryStr objectAtIndex:0] forKey:@"num"];
//                        [mutFood setObject:[aryStr objectAtIndex:1] forKey:@"name"];
//                        [mutFood setObject:[aryStr objectAtIndex:2] forKey:@"total"];
//                        [mutFood setObject:[aryStr objectAtIndex:3] forKey:@"price"];
//                        [mutFood setObject:[aryStr objectAtIndex:4] forKey:@"unit"];
//                        [mutFood setObject:[aryStr objectAtIndex:5] forKey:@"add1"];
//                        [mutFood setObject:[aryStr objectAtIndex:6] forKey:@"add2"];
//                        [mutFood setObject:[[[aryStr objectAtIndex:7] componentsSeparatedByString:@"#"] objectAtIndex:1] forKey:@"waiter"];
//                        [mutFood setObject:[aryStr objectAtIndex:8] forKey:@"PACKID"];
//                        [aryMut addObject:mutFood];
//                    }
//
//                }
//
//                [dicMut setObject:aryMut forKey:@"account"];
//
//
//            }
//
//
//
//
//        }
//    }
//
//
//    return dicMut;
//
//
//}
////退菜
//- (NSDictionary *)pChuck:(NSDictionary *)info{
//    NSString *user,*userid,*pwd,*tab,*reason,*foodnum;
//    /*
//     function pChuck(PdaID,User,GrantEmp,GrantPass,oSerial,Rsn,Cnt,oStr:PChar):PChar; stdcall; //退菜
//
//     参数说明：
//     PdaID       :PDA号 //格式'1-1'第一个1为PDA编码，第二个为餐厅号 ，默认为1
//     USER        :工号
//     GrantEmp    :授权人工号
//     GrantPass   :授权人密码
//     oSerial     :菜品流水号
//     Rsn         :退菜原因码
//     Cnt         :退菜数量
//     oStr        :返回值
//     */
//    NSString *pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//    userid = [info objectForKey:@"user"];
//    pwd = [info objectForKey:@"pwd"];
//    user = [info objectForKey:@"user"];
//    if (pwd)
//        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
//
//    tab = [[[info objectForKey:@"account"] objectAtIndex:0] objectForKey:@"num"];
//    reason = [info objectForKey:@"rsn"];
//    foodnum = [info objectForKey:@"total"];
//
//    NSString *strParam = [NSString stringWithFormat:@"?PdaID=%@&User=%@&GrantEmp=%@&GrantPass=%@&oSerial=%@&Rsn=%@&Cnt=%@",pdaid,user,userid,pwd,tab,reason,foodnum];
//
//
//    NSDictionary *dict = [self bsService:@"pChuck" arg:strParam];
//    //    NSString *strValue = [[dict objectForKey:@"string"] objectForKey:@"text"];
//    if (dict){
//        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];//[[[[strValue componentsSeparatedByString:@"<oStr>"] objectAtIndex:1] componentsSeparatedByString:@"</oStr>"] objectAtIndex:0];
//        NSArray *ary = [result componentsSeparatedByString:@"<"];
//        NSRange range = [[ary objectAtIndex:1] rangeOfString:@"ok"];
//        if (range.location!=NSNotFound){
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result", nil];
//        }
//        else{
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",
//                    [[[[[ary objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",nil];
//        }
//    }
//    return nil;
//}
////消费
//- (NSArray *)expendList:(NSArray *)ary{
//    NSMutableArray *mut = [NSMutableArray array];
//    for (int i=0;i<[ary count];i++){
//        NSDictionary *dict = [ary objectAtIndex:i];
//        BOOL isPack = [[dict objectForKey:@"isPack"] boolValue];
//        if (isPack){
//            NSArray *foods = [dict objectForKey:@"foods"];
//            for (int j=0;j<[foods count];j++){
//                NSDictionary *food = [foods objectAtIndex:j];
//                NSMutableDictionary *mutfood = [NSMutableDictionary dictionaryWithObject:food forKey:@"food"];
//                [mutfood setObject:@"PRICE" forKey:@"priceKey"];
//                [mutfood setObject:@"1.00" forKey:@"total"];
//                [mutfood setObject:@"UNIT" forKey:@"unitKey"];
//                [mut addObject:mutfood];
//
//            }
//        }else
//            [mut addObject:dict];
//    }
//
//    return [NSArray arrayWithArray:mut];
//}
////折扣
//- (NSArray *)foldList:(NSArray *)ary{
//    NSMutableArray *mut = [NSMutableArray array];
//    NSMutableArray *mutpack = [NSMutableArray array];
//    for (int i=0;i<[ary count];i++){
//        NSDictionary *food = [ary objectAtIndex:i];
//        if ([[food objectForKey:@"PACKID"] intValue]>0)
//            [mutpack addObject:food];
//        else
//            [mut addObject:food];
//    }
//
//    NSMutableSet *mutset = [NSMutableSet set];
//
//    for (int i=0;i<[mutpack count];i++){
//        if (![mutset containsObject:[[mutpack objectAtIndex:i] objectForKey:@"PACKID"]])
//            [mutset addObject:[[mutpack objectAtIndex:i] objectForKey:@"PACKID"]];
//    }
//    return mut;
//}
//
//- (NSString *)pSendTab:(NSArray *)ary options:(NSDictionary *)info{
//    if (ary && [ary count]>0){
//        ary = [self expendList:ary];
//
//        NSString *user,*acct,*tb,*usr,*pn,*type,*cmd,*pwd;
//        NSMutableString *addition = [NSMutableString string];
//        NSMutableString *tablist = [NSMutableString string];
//        int tabid,foodnum;
//
//        NSString *pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//        user = [info objectForKey:@"user"];
//        pwd = [info objectForKey:@"pwd"];
//        if (pwd)
//            user = [NSString stringWithFormat:@"%@-%@",user,pwd];
//        tabid = dSendCount++;
//        acct = @"0";
//        tb = [info objectForKey:@"table"];
//        usr = [info objectForKey:@"usr"];
//        usr = usr?usr:user;
//        pn = [info objectForKey:@"pn"];//@"4";
//        if (0==[pn intValue])
//            pn = @"4";
//        foodnum = [ary count];
//        type = [info objectForKey:@"type"];
//
//
//        [addition appendString:@"|"];
//
//
//
//        for (int i=0;i<foodnum;i++){
//            NSDictionary *dic = [ary objectAtIndex:i];
//            NSMutableArray *aryMut = [NSMutableArray array];
//
//            if ([info objectForKey:@"common"])
//                [aryMut addObjectsFromArray:[info objectForKey:@"common"]];
//            if ([dic objectForKey:@"addition"])
//                [aryMut addObjectsFromArray:[dic objectForKey:@"addition"]];
//
//            int additionCount = [aryMut count];
//            for (int i=0;i<10;i++){
//                if (i%2==0){
//                    int index = i/2;
//                    if (index<additionCount)
//                        [addition appendString:[[aryMut objectAtIndex:index] objectForKey:@"DES"]];
//                    [addition appendString:@"|"];
//                }
//                else{
//                    int index = (i-1)/2;
//                    if (index<additionCount){
//                        NSString *additionprice = [[aryMut objectAtIndex:index] objectForKey:@"PRICE1"];
//                        if (!additionprice)
//                            additionprice = @"0.0";
//                        [addition appendString:additionprice];
//                    }
//
//                    [addition appendString:@"|"];
//                }
//
//            }
//
//            int packid = [[[dic objectForKey:@"food"] objectForKey:@"PACKID"] intValue];
//            int packcnt = [[[dic objectForKey:@"food"] objectForKey:@"PACKCNT"] intValue];
//            packid = 0==packid?-1:packid;
//            //            packcnt = 0==packcnt?-1:packcnt;
//
//            float fTotal = [[[dic objectForKey:@"food"] objectForKey:[dic objectForKey:@"priceKey"]?[dic objectForKey:@"priceKey"]:[[NSUserDefaults standardUserDefaults] stringForKey:@"price"]] floatValue];
//            //            [tablist appendFormat:@"-1|0|%@|%@|%@|%@|0.00%@0|\n",[[dic objectForKey:@"food"] objectForKey:@"ITCODE"],[dic objectForKey:@"total"],[[dic objectForKey:@"food"] objectForKey:@"UNIT"],[NSString stringWithFormat:@"%.2f",fTotal],addition];
//            [tablist appendFormat:@"%d|%d|%@|%@|%@|%@|0.00%@0|^",packid,packcnt,[[dic objectForKey:@"food"] objectForKey:@"ITCODE"],[dic objectForKey:@"total"],[[dic objectForKey:@"food"] objectForKey:[dic objectForKey:@"unitKey"]],[NSString stringWithFormat:@"%.2f",fTotal],addition];
//
//            addition = [NSMutableString string];
//            [addition appendFormat:@"|"];
//        }
//
//
//        cmd = [NSString stringWithFormat:@"+sendtab<pdaid:%@;user:%@;tabid:%d;acct:%@;tb:%@;usr:%@;pn:%@;foodnum:%d;type:%@;tablist:%@;>^",pdaid,user,tabid,acct,tb,usr,pn,foodnum,type,tablist];
//
//        return cmd;
//        [self uploadFood:cmd];
//
//
//
//        NSString *strParam = [NSString stringWithFormat:@"?PdaID=%@&User=%@&PdaSerial=%d&Acct=%@&TblInit=%@&Waiter=%@&Pax=%@&zCnt=%d&Typ=%@&sbBuffer=%@",pdaid,user,tabid,acct,tb,usr,pn,foodnum,type,tablist];
//
//
//
//
//        NSDictionary *dict;
//        dict = [self bsService:@"pSendTab" arg:strParam];
//        if (dict) {
//
//            NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
//            NSArray *ary = [result componentsSeparatedByString:@"<"];
//            NSRange range = [[ary objectAtIndex:1] rangeOfString:@"ok"];
//            if (range.location != NSNotFound) {
//                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",
//                        [[[[[ary objectAtIndex:1] componentsSeparatedByString:@"msg:"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",[[[[[ary objectAtIndex:1] componentsSeparatedByString:@"msg"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1],@"tab", nil];
//            } else {
//                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",
//                        [[[[[ary objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",nil];
//            }
//        }
//    }
//
//    return nil;
//}
//
//- (NSString *)cachedOrder:(NSDictionary *)order{
//    NSArray *ary = [order objectForKey:@"foods"];
//    NSString *name = [order objectForKey:@"name"];
//
//    if (ary && [ary count]>0){
//        ary = [self expendList:ary];
//
//
//        NSMutableString *addition = [NSMutableString string];
//        NSMutableString *tablist = [NSMutableString string];
//        int foodnum;
//
//        NSString *pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//        foodnum = [ary count];
//
//        [addition appendString:@"|"];
//
//
//
//        for (int i=0;i<foodnum;i++){
//            NSDictionary *dic = [ary objectAtIndex:i];
//            NSMutableArray *aryMut = [NSMutableArray array];
//
//            if ([dic objectForKey:@"addition"])
//                [aryMut addObjectsFromArray:[dic objectForKey:@"addition"]];
//
//            int additionCount = [aryMut count];
//            for (int i=0;i<10;i++){
//                if (i%2==0){
//                    int index = i/2;
//                    if (index<additionCount)
//                        [addition appendString:[[aryMut objectAtIndex:index] objectForKey:@"DES"]];
//                    [addition appendString:@"|"];
//                }
//                else{
//                    int index = (i-1)/2;
//                    if (index<additionCount){
//                        NSString *additionprice = [[aryMut objectAtIndex:index] objectForKey:@"PRICE1"];
//                        if (!additionprice)
//                            additionprice = @"0.0";
//                        [addition appendString:additionprice];
//                    }
//
//                    [addition appendString:@"|"];
//                }
//
//            }
//
//            int packid = [[[dic objectForKey:@"food"] objectForKey:@"PACKID"] intValue];
//            int packcnt = [[[dic objectForKey:@"food"] objectForKey:@"PACKCNT"] intValue];
//            packid = 0==packid?-1:packid;
//            //            packcnt = 0==packcnt?-1:packcnt;
//
//            float fTotal = [[[dic objectForKey:@"food"] objectForKey:[dic objectForKey:@"priceKey"]?[dic objectForKey:@"priceKey"]:[[NSUserDefaults standardUserDefaults] stringForKey:@"price"]] floatValue];
//            //            [tablist appendFormat:@"-1|0|%@|%@|%@|%@|0.00%@0|\n",[[dic objectForKey:@"food"] objectForKey:@"ITCODE"],[dic objectForKey:@"total"],[[dic objectForKey:@"food"] objectForKey:@"UNIT"],[NSString stringWithFormat:@"%.2f",fTotal],addition];
//            [tablist appendFormat:@"%d|%d|%@|%@|%@|%@|0.00%@0|^",packid,packcnt,[[dic objectForKey:@"food"] objectForKey:@"ITCODE"],[dic objectForKey:@"total"],[[dic objectForKey:@"food"] objectForKey:[dic objectForKey:@"unitKey"]],[NSString stringWithFormat:@"%.2f",fTotal],addition];
//
//            addition = [NSMutableString string];
//            [addition appendFormat:@"|"];
//        }
//
//
//        return [NSString stringWithFormat:@"+gettempfolio<pdaid:%@;name:%@;foodnum:%d;tablist:%@;>^",pdaid,name,foodnum,tablist];//pdaid,名，数量，桌号
//    }else
//        return nil;
//}
//// 取消台位
//- (NSDictionary *)pOver:(NSDictionary *)info{
//    //+over<pdaid:%s;user:%s;table:%s;>\r\n")},4.取消开台
//    NSString *pdaid,*user,*table,*pwd;
//
//    pdaid = [NSString stringWithFormat:@"%@%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//    user = [info objectForKey:@"user"];
//    pwd = [info objectForKey:@"pwd"];
//    if (pwd)
//        user = [NSString stringWithFormat:@"%@%@",user,pwd];
//
//    table = [info objectForKey:@"table"];
//
//    NSString *strParam = [NSString stringWithFormat:@"?PdaId=%@&User=%@&TblInit=%@",pdaid,user,table];
//    NSDictionary *dict = [self bsService:@"pOver" arg:strParam];
//    if (dict) {
//        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
//        NSArray *ary = [result componentsSeparatedByString:@"<"];
//        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
//        NSArray *aryContent = [content componentsSeparatedByString:@":"];
//        NSRange range = [content rangeOfString:@"error"];
//        if (range.location!=NSNotFound){
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
//        }
//        else
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
//    }
//    return nil;
//}
//
////台位
//- (NSDictionary *)pPrintQuery:(NSDictionary *)info{
//    //+printquery<pdaid:%s;user:%s;tab:%s;type:%s;>\r\n"
//    NSString *pdaid,*user,*tab,*type,*pwd;
//    pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//    user = [info objectForKey:@"user"];
//    pwd = [info objectForKey:@"pwd"];
//    if (pwd)
//        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
//    tab = [info objectForKey:@"tab"];
//    type = [info objectForKey:@"type"];
//
//
//    NSString *strParam = [NSString stringWithFormat:@"?PdaId=%@&User=%@&Acct=%@&Typ=%@",pdaid,user,tab,type];
//
//    NSDictionary *dict = [self bsService:@"pPrintQuery" arg:strParam];
//    if (dict) {
//        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
//        NSArray *ary = [result componentsSeparatedByString:@"<"];
//        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
//        NSArray *aryContent = [content componentsSeparatedByString:@":"];
//        NSRange range = [content rangeOfString:@"error"];
//        if (range.location!=NSNotFound){
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent objectAtIndex:2],@"Message", nil];
//        }
//        else
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent objectAtIndex:2],@"Message", nil];
//    }
//    return nil;
//}
//
//- (NSDictionary *)pListSubscribeOfTable:(NSDictionary *)info{
//    NSString *pdaid,*user,*table;
//
//    pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
//    user = [info objectForKey:@"user"];
//    table = [info objectForKey:@"table"];
//
//    NSString *strParam = [NSString stringWithFormat:@"?PdaId=%@&User=%@&TblInit=%@",pdaid,user,table];
//
//    NSDictionary *dict = [self bsService:@"pListSubscribeOfTable" arg:strParam];
//
//    if (dict) {
//        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
//        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        NSArray *ary = [result componentsSeparatedByString:@"<"];
//        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
//        NSArray *aryContent = [content componentsSeparatedByString:@"^"];
//
//
//        NSMutableDictionary *mut = [NSMutableDictionary dictionary];
//        for (NSString *subcontent in aryContent){
//            NSArray *arysub = [subcontent componentsSeparatedByString:@":"];
//            NSString *key = [arysub objectAtIndex:0];
//
//            NSMutableString *strsub = [NSMutableString string];
//            for (int i=1;i<[arysub count];i++){
//                [strsub appendString:[arysub objectAtIndex:i]];
//                if (i!=[arysub count]-1)
//                    [strsub appendString:@":"];
//            }
//            NSString *value = [strsub length]>0?strsub:nil;
//
//            if (value)
//                [mut setObject:value forKey:key];
//        }
//
//        NSArray *arary = [result componentsSeparatedByString:@"account:"];
//        NSMutableString *mutstr = [NSMutableString string];
//        if ([arary count]>1){
//            NSString *account = [arary objectAtIndex:1];
//            NSArray *foodsary = [account componentsSeparatedByString:@"^"];
//            int foodcount = [foodsary count]/8;
//            for (int j=0;j<foodcount;j++){
//                [mutstr appendString:@"\n"];
//                for (int k=0;k<8;k++){
//                    [mutstr appendFormat:@"%@ ",[foodsary objectAtIndex:8*j+k]];
//                }
//            }
//        }
//        if ([mutstr length]>0){
//            [mut setObject:mutstr forKey:@"account"];
//        }
//
//        dict = [NSDictionary dictionaryWithDictionary:mut];
//    }
//
//
//    return dict;
//}
//
////- (NSArray *)pListResv:(NSDictionary *)info{
////    NSString *pdaid,*user;
////
////    pdaid = [NSString stringWithFormat:@"%@-%d",[self padID],[[[self currentPageConfig] objectForKey:@"number"] intValue]];
////    user = [info objectForKey:@"user"];
////
////    NSString *strParam = [NSString stringWithFormat:@"?PdaID=%@&User=%@",pdaid,user];
////
////    NSDictionary *dict = [self bsService:@"pListResv" arg:strParam];
////
////    NSMutableArray *mut = [NSMutableArray array];
////
////    if (dict) {
////        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
////        NSArray *ary = [result componentsSeparatedByString:@"<"];
////        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
////        content = [content stringByReplacingOccurrencesOfString:@"acct:" withString:@""];
////        NSArray *aryContent = [content componentsSeparatedByString:@"|"];
////
////
////
////        for (NSString *subcontent in aryContent){
////            NSArray *arysub = [subcontent componentsSeparatedByString:@"^"];
////
////
////            if ([arysub count]>7){
////
////                NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
////                [mutdict setObject:[arysub objectAtIndex:0] forKey:@"acct"];
////                for (int i=1;i<8;i++){
////                    NSArray *kv = [[arysub objectAtIndex:i] componentsSeparatedByString:@":"];
////                    NSString *key = [kv objectAtIndex:0];
////                    NSMutableString *strsub = [NSMutableString string];
////                    for (int i=1;i<[kv count];i++){
////                        [strsub appendString:[kv objectAtIndex:i]];
////                        if (i!=[kv count]-1)
////                            [strsub appendString:@":"];
////                    }
////                    NSString *value = [strsub length]>0?strsub:nil;
////
////                    if (value)
////                        [mutdict setObject:value forKey:key];
////                }
////
////                [mut addObject:mutdict];
////            }
////        }
////
////        dict = [NSDictionary dictionaryWithObjectsAndKeys:mut,@"Result", nil];
////    }
////
////    return [mut count]>0?mut:nil;
////}
//
//
//
//
//
//#pragma mark -
//#pragma mark Process Received Data
////- (void)getQueryResult:(NSString *)result{
////    if ([result length]>0){
////        NSArray *ary = [result componentsSeparatedByString:@"<"];
////        if ([ary count]>1){
////            //+sendtab
////            NSString *cmd = [ary objectAtIndex:0];
////            if ([cmd isEqualToString:@"+sendtab"]){
////                NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
////
////                NSMutableDictionary *mut = [NSMutableDictionary dictionary];
////                NSRange range = [content rangeOfString:@"ok"];
////                if (range.location!=NSNotFound){
////                    [mut setObject:[NSNumber numberWithBool:YES] forKey:@"Result"];
////                    [mut setObject:[[content componentsSeparatedByString:@"msg:"] objectAtIndex:1] forKey:@"Message"];
////                    [mut setObject:[[[[content componentsSeparatedByString:@"msg:"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] forKey:@"tab"];
////
////                    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////                    NSString *docPath = [docPaths objectAtIndex:0];
////                    [[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:dSendCount] forKey:@"count"]
////                     writeToFile:[docPath stringByAppendingPathComponent:kOrdersCountFileName] atomically:NO];
////                }
////                else{
////                    [mut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
////                    [mut setObject:[[content componentsSeparatedByString:@"error:"] objectAtIndex:1] forKey:@"Message"];
////                }
////
////                [[NSNotificationCenter defaultCenter] postNotificationName:msgSendTab object:nil userInfo:mut];
////            }
////            else if ([cmd isEqualToString:@"+printquery"]){
////                //Recived Data:+printquery<error:台号错误或已结帐或未定义查询单打印机!>
////                NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
////                NSArray *aryContent = [content componentsSeparatedByString:@":"];
////                NSRange range = [content rangeOfString:@"error"];
////                if (range.location!=NSNotFound){
////                    [[NSNotificationCenter defaultCenter] postNotificationName:msgPrint
////                                                                        object:nil
////                                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent objectAtIndex:1],@"Message", nil]];
////                }
////                else{
////                    int dCocount = [aryContent count];
////                    if (dCocount>1)
////                        [[NSNotificationCenter defaultCenter] postNotificationName:msgPrint object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent objectAtIndex:1],@"Message", nil]];
////                    else
////                        [[NSNotificationCenter defaultCenter] postNotificationName:msgPrint object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil]];
////                }
////            }
////
////        }
////    }
////}
//
//
//
//
//
////- (UIImage *)backgroundImage{
////    if (!imgBG){
////        NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////        NSString *docPath = [docPaths objectAtIndex:0];
////        NSString *path = [docPath stringByAppendingPathComponent:kBGFileName];
////        NSString *imgpath = nil;
////
////        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
////
////        if (!dic){
////            NSArray *ary = [self getAllBG];
////            if (ary>0)
////                dic = [ary objectAtIndex:0];
////            else
////                dic = [NSDictionary dictionaryWithObject:@"defaultbg.jpg" forKey:@"name"];
////            [dic writeToFile:path atomically:NO];
////        }
////
////        imgpath = [docPath stringByAppendingPathComponent:[dic objectForKey:@"name"]];
////
////        imgBG = [[UIImage alloc] initWithContentsOfFile:imgpath];
////    }
////
////
////    return imgBG;
////
////}
////
////- (void)setBackgroundImage:(NSDictionary *)info{
////    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *docPath = [docPaths objectAtIndex:0];
////    NSString *path = [docPath stringByAppendingPathComponent:kBGFileName];
////    [info writeToFile:path atomically:NO];
////
////    [imgBG release];
////    imgBG = nil;
////}
//
////- (NSArray *)getAllBG{
////    NSMutableArray *ary = [NSMutableArray array];
////
////    NSString *path = [BSDataProvider sqlitePath];
////    sqlite3 *db;
////    sqlite3_stmt *stat;
////    NSString *sqlcmd;
////
////    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
////        sqlcmd = @"select * from background";
////        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
////            while (sqlite3_step(stat)==SQLITE_ROW) {
////                int count = sqlite3_column_count(stat);
////                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
////                for (int i=0;i<count;i++){
////                    char *foodKey = (char *)sqlite3_column_name(stat, i);
////                    char *foodValue = (char *)sqlite3_column_text(stat, i);
////                    NSString *strKey = nil,*strValue = nil;
////
////                    if (foodKey)
////                        strKey = [NSString stringWithUTF8String:foodKey];
////                    if (foodValue)
////                        strValue = [NSString stringWithUTF8String:foodValue];
////                    if (strKey && strValue)
////                        [mutDC setObject:strValue forKey:strKey];
////                }
////                [ary addObject:mutDC];
////            }
////        }
////        sqlite3_finalize(stat);
////    }
////    sqlite3_close(db);
////
////    return ary;
////}
//
//
////- (NSString *)bsService_string:(NSString *)api arg:(NSString *)arg{
////    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
////    [agent GetData:api arg:arg];
////    NSString *str = agent.strData;
////
////    [agent release];
////
////    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
////    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
////
////    return str;
////}
////List Table
//
//- (BOOL)pCommentFood:(NSDictionary *)info{
//    NSString *itcode = [info objectForKey:@"itcode"];
//    NSString *level = [info objectForKey:@"level"];
//    NSString *comment = [info objectForKey:@"comment"];
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"comments.plist"];
//
//    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    if (!mut)
//        mut = [NSMutableDictionary dictionary];
//
//    NSArray *ary = [mut objectForKey:itcode];
//    NSMutableArray *mutary = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:itcode,@"itcode",level,@"level",comment,@"comment", nil]];
//    [mutary addObjectsFromArray:ary];
//
//    [mut setObject:mutary forKey:itcode];
//
//    [mut writeToFile:path atomically:NO];
//
//    return YES;
//
//
//    /*
//     NSString *param = [NSString stringWithFormat:@"?itcode=%@&level=%@&comment=%@",itcode,level,comment];
//
//     NSDictionary *dict = [self bsService:@"pCommentFood" arg:param];
//
//     NSString *OStr = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
//
//     NSRange range = [OStr rangeOfString:@"提交成功"];
//
//     return (range.location!=NSNotFound);
//     */
//}
////
////- (NSArray *)pGetFoodComment:(NSDictionary *)info{
////    NSString *itcode = [info objectForKey:@"itcode"];
////
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"comments.plist"];
////
////    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithContentsOfFile:path];
////
////
////    return [mut objectForKey:itcode];
////
////    /*
////     NSString *itcode = [info objectForKey:@"itcode"];;
////
////
////     NSString *param = [NSString stringWithFormat:@"?itcode=%@",itcode];
////
////     NSDictionary *dict = [self bsService:@"pGetFoodComment" arg:param];
////
////     NSArray *ary = [[[[dict objectForKey:@"DataTable"] objectForKey:@"diffgr:diffgram"] objectForKey:@"NewDataSet"] objectForKey:@"ds"];
////     if ([ary isKindOfClass:[NSDictionary class]])
////     ary = [NSArray arrayWithObject:ary];
////
////     NSMutableArray *mut = [NSMutableArray array];
////
////     for (int i=0;i<[ary count];i++){
////     NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
////
////     NSDictionary *dictcomment = [ary objectAtIndex:i];
////     NSString *strcomment = [[dictcomment objectForKey:@"comment"] objectForKey:@"text"];
////     const char *cstr = [strcomment cStringUsingEncoding:NSUTF8StringEncoding];
////
////     BOOL bchar = NO;
////
////     NSMutableString *mutstr = [NSMutableString string];
////     for (int j=0;j<strlen(cstr);j++){
////     if (cstr[j]!='\n' && cstr[j]!=' ')
////     bchar = YES;
////
////     if (bchar)
////     [mutstr appendFormat:@"%c",cstr[j]];
////
////     }
////
////     if ([mutstr length]>0)
////     [mutdict setObject:mutstr forKey:@"comment"];
////
////     NSString *level = [[dictcomment objectForKey:@"lv"] objectForKey:@"text"];
////     for (int k=1;k<=5;k++){
////     if ([level rangeOfString:[NSString stringWithFormat:@"%d",k]].location!=NSNotFound){
////     level = [NSString stringWithFormat:@"%d",k];
////     break;
////     }
////     }
////     if ([level intValue]!=0)
////     [mutdict setObject:level forKey:@"level"];
////
////     if ([mutdict count]>0)
////     [mut addObject:mutdict];
////     }
////
////     return [mut count]>0?[NSArray arrayWithArray:mut]:nil;
////
////     */
////}
//
////- (NSString *)pGetFoodVideo:(NSDictionary *)info{
////    NSString *itcode = [info objectForKey:@"itcode"];;
////    return @"http://www.5stan.com/test.mov";
////    NSString *param = [NSString stringWithFormat:@"?itcode=%@",itcode];
////
////    NSDictionary *dict = [self bsService:@"pGetFoodVideo" arg:param];
////
////    NSString *path = [[[dict objectForKey:@"video"] objectForKey:@"Videopath"] objectForKey:@"text"];
////    [path stringByReplacingOccurrencesOfString:@"\n" withString:@""];
////    [path stringByReplacingOccurrencesOfString:@" " withString:@""];
////
////
////    return [path length]>0?path:nil;
////}
////
////
////#pragma mark - Template Functions
////- (NSArray *)pageConfigList{
////    return aryPageConfigList;
////}
////
////- (NSDictionary *)currentPageConfig{
////    return dicCurrentPageConfig;
////}
////
////- (NSDictionary *)currentPageConfigDetail{
////    return dicCurrentPageConfigDetail;
////}
////
////- (NSArray *)pageList{
////    NSArray *ary = [[self currentPageConfigDetail] objectForKey:@"PageList"];
////
////    return ary;
////}
////
////- (NSDictionary *)resourceConfig{
////    NSDictionary *dict = [[self currentPageConfigDetail] objectForKey:@"ResourceConfig"];
////
////    return dict;
////}
////
////- (NSDictionary *)foodDetailConfig{
////    return [[self currentPageConfigDetail] objectForKey:@"FoodDetail"];
////}
////
////- (NSDictionary *)buttonConfig{
////    NSDictionary *dict = [[self currentPageConfigDetail] objectForKey:@"ButtonConfig"];
////
////    return dict;
////}
////
////- (NSArray *)menuItemList{
////    NSArray *ary = [[self currentPageConfigDetail] objectForKey:@"MenuItemList"];
////
////    return ary;
////}
////
////- (NSUInteger)totalPages{
////    NSArray *ary = [self pageList];
////
////    int total = 0;
////    for (NSDictionary *info in ary){
////        if ([[info objectForKey:@"type"] isEqualToString:@"类别"]){
////            NSArray *foods = [self foodListForClass:[info objectForKey:@"classid"]];
////            int page = (int)([foods count]/9)+[foods count]%9==0?0:1;
////            total += page;
////        }
////        else
////            total++;
////    }
////
////    return total;
////}
////
////- (NSArray *)foodListForClass:(NSString *)classid{
////    return  [self getFoodList:[NSString stringWithFormat:@"GRPTYP = %@",classid]];
////}
////
////- (void)updateRecommendList{
////    @autoreleasepool {
////        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[@"setting.plist" documentPath]];
////
////        NSString *str = [dict objectForKey:@"url"];
////        if ([str length]==0)
////            str = kPathHeader;
////        str = [str stringByAppendingPathComponent:@"RecommendFoods.txt"];
////
////        NSURLRequest *request;
////        NSURL *url = [NSURL URLWithString:str];
////        request = [[NSURLRequest alloc] initWithURL:url
////                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
////                                    timeoutInterval:5.0];
////
////
////        // retreive the data using timeout
////        NSURLResponse* response;
////        NSError *error;
////
////
////        error = nil;
////        response = nil;
////        NSData *serviceData = [NSURLConnection sendSynchronousRequest:request
////                                                    returningResponse:&response
////                                                                error:&error];
////
////        NSMutableArray *mut = [NSMutableArray array];
////
////
////
////        if (serviceData){
////            NSString *recommend = [NSString stringWithCString:[serviceData bytes] encoding:NSUTF8StringEncoding];
////
////
////            NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecommendTxt"];
////
////            if (![current isEqualToString:recommend]){
////                if (recommend)
////                    [[NSUserDefaults standardUserDefaults] setObject:recommend forKey:@"RecommendTxt"];
////                else
////                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RecommendTxt"];
////                NSArray *ary = [recommend componentsSeparatedByString:@","];
////
////                for (int i=0;i<ary.count;i++){
////                    NSString *foodid = nil;
////                    NSString *background = nil;
////
////                    NSArray *items = [[ary objectAtIndex:i] componentsSeparatedByString:@"#"];
////
////
////                    if (1==items.count)
////                        foodid = [items objectAtIndex:0];
////                    else if (2==items.count){
////                        foodid = [items objectAtIndex:0];
////                        background = [items objectAtIndex:1];
////                    }
////
////                    if (foodid){
////                        NSDictionary *recommendDetail = [[self currentPageConfigDetail] objectForKey:@"RecommendDetail"];
////
////                        if (!recommendDetail){
////                            for (NSDictionary *page in [[self currentPageConfigDetail] objectForKey:@"PageList"]){
////                                if ([[page objectForKey:@"type"] isEqualToString:@"推荐菜"]){
////                                    recommendDetail = [page objectForKey:@"frame"];
////                                    break;
////                                }
////                            }
////                        }
////
////                        if (!background)
////                            background = [NSString stringWithFormat:@"%@R.png",foodid];
////
////                        if (recommendDetail){
////                            NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
////                            [mutdict setObject:recommendDetail forKey:@"frame"];
////                            [mutdict setObject:foodid forKey:@"foodid"];
////                            [mutdict setObject:background forKey:@"background"];
////                            [mutdict setObject:@"推荐菜" forKey:@"type"];
////                            [mutdict setObject:[NSNumber numberWithBool:YES] forKey:@"hideButton"];
////                            [mut addObject:mutdict];
////                        }
////
////                    }
////                }
////
////                if (mut.count>0)
////                    [[NSUserDefaults standardUserDefaults] setObject:mut forKey:@"RecommendList"];
////                else
////                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RecommendList"];
////
////
////                NSLog(@"Update Recommend List Finished:%d",mut.count);
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"PageConfigChanged" object:nil];
////            }
////        }
////    }
////}
////
////
////- (NSArray *)topPages{
////    //封面 广告 推荐菜 类别列表
////    //    NSArray *allpages = [self pageConfigList];
////    //    NSMutableArray *mut = [NSMutableArray array];
////    //
////    //    for (int i=0;i<allpages.count;i++){
////    //        NSDictionary *dict = [allpages objectAtIndex:i];
////    //        if ([[dict objectForKey:@"type"] isEqualToString:@"类别"]){
////    //
////    //        }
////    //    }
////    NSMutableArray *mut = [NSMutableArray array];
////
////    NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
////    if ([self getCovers].count>0){
////        [mutdict setObject:[NSMutableArray array] forKey:@"images"];
////        for (NSDictionary *didi in [self getCovers])
////            [[mutdict objectForKey:@"images"] addObject:[didi objectForKey:@"cover"]];
////    }
////
////    [mutdict setObject:@"封面" forKey:@"type"];
////    [mut addObject:mutdict];
////
////    NSArray *ary = [self getClassList];
////
////
////    for (int i=0;i<[ary count];i++){
////        if (i%9==0){
////            mutdict = [NSMutableDictionary dictionaryWithObject:@"类别列表" forKey:@"type"];
////            [mutdict setObject:[NSMutableArray array] forKey:@"categories"];
////            [mut addObject:mutdict];
////        }
////
////        [[mutdict objectForKey:@"categories"] addObject:[ary objectAtIndex:i]];
////    }
////
////    return [NSArray arrayWithArray:mut];
////
////}
////
////- (NSArray *)allPages{
////    return aryAllPages;
////}
////
////- (NSArray *)allDetailPages{
////    return aryAllDetailPages;
////}
////
////- (NSDictionary *)pageInfoAtIndex:(NSUInteger)index{
////    NSArray *ary = [self allPages];
////
////    return index<[ary count]?[ary objectAtIndex:index]:nil;
////}
//////  套餐相关
////- (NSArray *)getFoodListOfPackage:(NSString *)packageid{
////    NSString *cmd = [NSString stringWithFormat:@"select * from PACKDTL where PACKID = %@",packageid];
////
////    return [BSDataProvider getDataFromSQLByCommand:cmd];
////}
////
////- (NSDictionary *)getFoodByCode:(NSString *)itcode{
////    NSString *cmd = [NSString stringWithFormat:@"select * from food where ITCODE = %@",itcode];
////
////    return [BSDataProvider getDataFromSQLByCommand:cmd];
////}
//
//- (NSDictionary *)getPackageDetail:(NSString *)packageid{
//    NSArray *foods = [self getFoodListOfPackage:packageid];
//    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
//    if (foods)
//        [mut setObject:foods forKey:@"foods"];
//    NSString *cmd = [NSString stringWithFormat:@"select * from PACKAGE where PACKID = %@",packageid];
//
//    NSDictionary *dict = [BSDataProvider getDataFromSQLByCommand:cmd];
//
//    if (dict)
//        [mut setValuesForKeysWithDictionary:dict];
//
//    return [mut count]>0?[NSDictionary dictionaryWithDictionary:mut]:nil;
//
//}
//
//- (NSArray *)getShiftFood:(NSString *)foodid ofPackage:(NSString *)packageid{
//    NSString *cmd = [NSString stringWithFormat:@"select * from ITEMPKG where PACKID = %@ and ITEM = %@",packageid,foodid];
//
//    return [BSDataProvider getDataFromSQLByCommand:cmd];
//}
//
//+ (id)getDataFromSQLByCommand:(NSString *)cmd sqlName:(NSString *)sqlname{
//    id ret = nil;
//    NSMutableArray *ary = [NSMutableArray array];
//    NSString *path = [@"BookSystem.sqlite" bundlePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[sqlname documentPath]])
//        path = [sqlname documentPath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd = cmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    if ([ary count]==1){
//        NSDictionary *dict = [ary objectAtIndex:0];
//        if (1==[dict count])
//            ret = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
//        else if ([dict count]>1)
//            ret = dict;
//    }else if ([ary count]>1)
//        ret = ary;
//
//
//    return ret;
//}
//
//+ (id)getDataFromSQLByCommand:(NSString *)cmd{
//    id ret = nil;
//    NSMutableArray *ary = [NSMutableArray array];
//    NSString *path = [self sqlitePath];
//    sqlite3 *db;
//    sqlite3_stmt *stat;
//    NSString *sqlcmd = cmd;
//
//    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
//        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
//            while (sqlite3_step(stat)==SQLITE_ROW) {
//                int count = sqlite3_column_count(stat);
//                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
//                for (int i=0;i<count;i++){
//                    char *foodKey = (char *)sqlite3_column_name(stat, i);
//                    char *foodValue = (char *)sqlite3_column_text(stat, i);
//                    NSString *strKey = nil,*strValue = nil;
//
//                    if (foodKey)
//                        strKey = [NSString stringWithUTF8String:foodKey];
//                    if (foodValue)
//                        strValue = [NSString stringWithUTF8String:foodValue];
//                    if (strKey && strValue)
//                        [mutDC setObject:strValue forKey:strKey];
//                }
//                [ary addObject:mutDC];
//            }
//        }
//        sqlite3_finalize(stat);
//    }
//    sqlite3_close(db);
//
//    if ([ary count]==1){
//        NSDictionary *dict = [ary objectAtIndex:0];
//        if (1==[dict count])
//            ret = [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
//        else if ([dict count]>1)
//            ret = dict;
//    }else if ([ary count]>1)
//        ret = ary;
//
//
//    return ret;
//}
//
#pragma mark -  激活
- (BOOL)checkActivated{
    BOOL bActivated = [[NSUserDefaults standardUserDefaults] boolForKey:@"Activated"];
    
    if (bActivated)
        return YES;
    BOOL bSuceed = NO;
    
    NSString *strRegNo = [NSString UUIDString];
    
    NSArray *urls = [NSArray arrayWithObjects:@"61.174.28.122",@"60.12.218.91",nil];
    for (int i=0;i<2;i++){
        NSString *strUrl = [NSString stringWithFormat:@"http://%@:9100/choicereg.asmx/choicereg?uuid=%@",[urls objectAtIndex:i],strRegNo];
        //        NSLog(@"strUrl = %@",strUrl);
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSMutableURLRequest *request = nil;
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *serviceData = nil;
        
        request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
        [request setHTTPMethod:@"GET"];
        
        serviceData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
        
        
        
        if (!error){
            NSString *str = [[NSString stringWithCString:[serviceData bytes]
                                                encoding:NSUTF8StringEncoding] lowercaseString];
            NSRange range = [str rangeOfString:@"true"];
            if (range.location!=NSNotFound && str){
                bSuceed = YES;
                break;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:bSuceed forKey:@"Activated"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return bSuceed;
}
-(NSString *)consumerCouponCode:(NSDictionary *)info
{
    NSString *vcCode=[[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&userName=%@&token=%@&userEmail=%@&voperator=%@",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"USERNAME"],[info objectForKey:@"TOKEN"],[info objectForKey:@"USEREMAIL"],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    //    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&username=%@&token=&userEmail=",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict = [self bsService:@"consumerCouponCode" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:consumerCouponCodeResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }else
    {
        return [NSString stringWithFormat:@"%@",dict];
    }
}

- (BOOL)activated{
    return [self checkActivated];
}
@end
