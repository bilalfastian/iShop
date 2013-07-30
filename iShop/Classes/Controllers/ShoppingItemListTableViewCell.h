//
//  ShoppingItemListTableViewCell.h
//  Client
//
//  Created by Bilal Nazir on 11/17/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ShoppingItemListTableViewCell : UITableViewCell {
	UILabel *itemNameLabel;
	UILabel *priceLabel;
	AsyncImageView *itemImageView;
	NSMutableArray *starsArray;
}
@property (nonatomic, retain) NSMutableArray *starsArray;
@property (nonatomic, retain) UILabel *itemNameLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) AsyncImageView *itemImageView;

-(void) drawRating:(NSInteger) ratingValue;
@end
