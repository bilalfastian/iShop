//
//  CartViewController.h
//  Client
//
//  Created by Bilal Nazir on 12/5/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface CartViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate, UITableViewDataSource> {
	
	UITableView  *itemCartTableView;
	ShoppingItem *item;
	UIPickerView *pickerView;
	
	NSMutableArray *arrayNo;
	NSMutableArray *sizeArray;
	NSArray *sizeAndCountPickerArray;
	
	UILabel *numOfItemsLabel,*sizeLabel,*priceLabel; 
}

@property (nonatomic, retain) UILabel *numOfItemsLabel;
@property (nonatomic, retain) UILabel *sizeLabel;
@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UITableView *itemCartTableView;
-(id) initWithItem:(ShoppingItem*) newItem;
@end
