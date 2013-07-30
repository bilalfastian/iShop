//
//  CartTableViewController.h
//  Client
//
//  Created by Bilal Nazir on 12/5/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface CartTableViewController : UITableViewController {

	NSMutableSet *cartListSet;
	NSMutableArray *cartListArray;
	float totalPrice;

}


-(void)showCartViewControllerWithCartItem:(ShoppingItem *)cartItem;
@end
