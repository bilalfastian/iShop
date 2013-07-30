//
//  ItemDetailView.h
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemDetailView : UIView {
	UIImageView *shopItemImage;
	UILabel		*itemName;
	UILabel		*itemPrice;
	UILabel		*itemNameLabel;
	UILabel		*descriptionLabel;
	UILabel		*ratingLabel;
}
@property (nonatomic, retain) UILabel *ratingLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UILabel *itemPrice;
@property (nonatomic, retain) UILabel *itemName;
@property (nonatomic, retain) UIImageView *shopItemImage;

-(void) drawRating:(NSInteger) ratingValue;

@end
