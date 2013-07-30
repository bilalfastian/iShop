//
//  ShippingDetailedViewController.h
//  Client
//
//  Created by Bilal Nazir on 12/6/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGlassButton.h"

@interface ShippingDetailedViewController : UITableViewController<UITextFieldDelegate> {

	UITextField *countryTextField,*userNameTextField,*passwordTextField;
	UITextField *streetTextField,*cityTextField,*zipCodeTextField;
	MOGlassButton* submitBtn;
}
@property (nonatomic, retain) UIButton *submitBtn;
@property (nonatomic, retain) UITextField *userNameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *countryTextField;

@end
