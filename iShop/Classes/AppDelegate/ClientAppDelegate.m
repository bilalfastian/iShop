//
//  ClientAppDelegate.m
//  Client
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "ClientAppDelegate.h"
#import "RootViewController.h"
#import "NSUserDefaults+Extensions.h"
#import "CartTableViewController.h"

@interface ClientAppDelegate ()
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@end


@implementation ClientAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSUserDefaults standardUserDefaults] setDefaultValuesIfRequired];
    [UIApplication sharedApplication].idleTimerDisabled = YES;

	RootViewController *rootVC = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	
	//rootVC.title = @"Catalog";
	//rootVC.tabBarItem = [[UITabBarItem alloc] init];
	//rootVC.tabBarItem.title = @"Catalog";
	_navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	
	
	CartTableViewController *cartViewController = [[CartTableViewController alloc] initWithStyle:UITableViewStylePlain];
	
	rootVC.cartDelegate = cartViewController;
	
	UINavigationController *cartNavController = [[UINavigationController alloc] initWithRootViewController:cartViewController];
	[cartViewController release];
	[rootVC release];
	
	_tabBarController.viewControllers = [NSArray arrayWithObjects:_navigationController,cartNavController,nil];
	[cartNavController release];
	[_navigationController release];
	
	[self.window addSubview:[_tabBarController view]];
	//[self.window addSubview:[self.navigationController view]];
	
    [self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
}

- (void)dealloc 
{
	[super dealloc];
}

@end
