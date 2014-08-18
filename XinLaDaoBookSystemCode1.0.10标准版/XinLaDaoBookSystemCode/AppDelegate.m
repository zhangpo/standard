//
//  AppDelegate.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-4-21.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AppDelegate.h"
#import "AKLogInViewController.h"
#import "CVLocalizationSetting.h"

@implementation AppDelegate
{
    NSString *_strLanguage;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self copyFiles];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
    }
    NSString *language = [[NSUserDefaults standardUserDefaults]
						  stringForKey:@"language"];
    if(!language) {
        [self performSelector:@selector(registerDefaultsFromSettingsBundle)];
    }
	_strLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
    AKLogInViewController *logInVC = [[AKLogInViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logInVC];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            //			NSLog(@"Default %@ value:%@",key,[prefSpecification objectForKey:@"DefaultValue"]);
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}


-(void)checkLanguage{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
	if (![_strLanguage isEqualToString:currentLanguage])
	{
		//	[check invalidate];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"LanguageChangedTitle"]
														message:[langSetting localizedString:@"LanguageChangedMessage"]
													   delegate:nil
											  cancelButtonTitle:[langSetting localizedString:@"OK"]
											  otherButtonTitles:nil];
		[alert show];
	}
	//	else
	//		[check invalidate];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)copyFiles{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
    
    NSString *sqlpath = [docPath stringByAppendingPathComponent:@"BookSystem.plist"];
    
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:sqlpath]){
        NSArray *ary = [NSBundle pathsForResourcesOfType:@"jpg" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"JPG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"png" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"PNG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"sqlite" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
    }
}
@end
