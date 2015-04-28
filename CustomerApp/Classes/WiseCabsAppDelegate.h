//
//  WiseCabsAppDelegate.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 05/12/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <sqllite3.h>
#import "SQLHelper.h"

@interface WiseCabsAppDelegate : NSObject <UIApplicationDelegate,UITabBarDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *maintabBarController;
	SQLHelper *m_db;
	NSDictionary *cityDictionary;
	NSDictionary *localitiesDictionary;
	NSDictionary *locationDictionary;
	//NSArray *paths;
	//UIImageView *splashView ;
	
	NSString *documentsDirectory ;
}
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *maintabBarController;
//@property (nonatomic, retain) 	NSArray *paths;
//@property (nonatomic, retain) UIImageView *splashView ;
//@property (nonatomic, retain) 	NSString *documentsDirectory ;
- (NSString *) getDBPath; 
- (void) copyDatabaseIfNeeded; 
-(void)loadTabBarController;
-(void)isUserloggedIn;
@end


