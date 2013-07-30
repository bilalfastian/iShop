//
//  ClientAppDelegate.h
//  Client
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

@interface ClientAppDelegate : NSObject <UIApplicationDelegate> 
{
@private
    IBOutlet UIWindow *_window;
    UINavigationController *_navigationController;
	
	IBOutlet UITabBarController *_tabBarController;
	
}

@end

