//
//  ShoppingItemsTableViewCell.h
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ShoppingItemsTableViewCell : UITableViewCell {
	UILabel *itemsCountLabel,*itemNameLabel;
	AsyncImageView *itemImageView;
	
}
@property (nonatomic, retain) UILabel *itemNameLabel;
@property (nonatomic, retain) UILabel *itemsCountLabel;
@property (nonatomic, retain) AsyncImageView *itemImageView;

@end