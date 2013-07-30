//
//  ShoppingItemDetailedViewController.h
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemDetailView.h"
#import "ShoppingItem.h"
#import "MOGlassButton.h"

@interface ShoppingItemDetailedViewController :UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UITableView  *itemDescriptionTableView;
	ShoppingItem *newItem;
	MOGlassButton* commentsBtn;
	MOGlassButton* cartBtn;
	id delegate;
	
	id cartDelegate;
}
@property (nonatomic, retain) 	id cartDelegate;
@property (nonatomic, retain) UIButton *commentsBtn;
@property (nonatomic, retain) UIButton *cartBtn;
@property (nonatomic, retain) ShoppingItem *newItem;
-(id)initWithShoppingItem:(ShoppingItem *)item withViewController:(UIViewController*)controller cartDelegate:(id)cartDel;
@end
