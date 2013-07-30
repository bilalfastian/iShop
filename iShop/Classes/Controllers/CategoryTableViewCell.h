//
//  TableViewCell.h
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface CategoryTableViewCell : UITableViewCell {
	NSString * text;
	NSInteger cellNumber;
	UIImageView *man2ImageView;
	UIImageView *man1ImageView;
	UIImageView *women1ImageView;
	UIImageView *women2ImageView;
	UIImageView *childImageView1;
	UIImageView *childImageView2;

}
@property (nonatomic, assign) NSInteger SelectedCategory;
@property (nonatomic, assign) NSInteger cellNumber;
@property (nonatomic, copy, setter=setText:) NSString * text;
@property (nonatomic, retain) UIImageView *man1ImageView;
@property (nonatomic, retain) UIImageView *man2ImageView;
@property (nonatomic, retain) UIImageView *women1ImageView;
@property (nonatomic, retain) UIImageView *women2ImageView;
@property (nonatomic, retain) UIImageView *childImageView1;
@property (nonatomic, retain) UIImageView *childImageView2;


@end