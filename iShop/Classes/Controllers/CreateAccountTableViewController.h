//
//  CreateAccountTableViewController.h
//  Client
//
//  Created by Bilal Nazir on 12/9/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGlassButton.h"

@interface CreateAccountTableViewController :UITableViewController  {

	UITextField *emailIDTextField,*userNameTextField,*passwordTextField;
	MOGlassButton* createAccountBtn;
	NSArray *typeArray;
}

@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *emailIDTextField;

@property (nonatomic, retain) UIButton *createAccountBtn;
@end
