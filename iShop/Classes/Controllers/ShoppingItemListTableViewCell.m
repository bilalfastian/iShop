//
//  ShoppingItemListTableViewCell.m
//  Client
//
//  Created by Bilal Nazir on 11/17/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ShoppingItemListTableViewCell.h"


@implementation ShoppingItemListTableViewCell

@synthesize itemNameLabel, priceLabel;
@synthesize itemImageView;
@synthesize starsArray;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		starsArray = [[NSMutableArray alloc] init];
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		itemNameLabel = [[UILabel alloc] init];
		itemNameLabel.font = [UIFont systemFontOfSize:14];
		itemNameLabel.numberOfLines = 0;
		
		priceLabel	  =	[[UILabel alloc] init];
		priceLabel.font = [UIFont systemFontOfSize:12];
		priceLabel.textColor = [UIColor redColor];
		[self.contentView addSubview:itemNameLabel];
		
		[self.contentView addSubview:priceLabel];
		
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	itemNameLabel.frame = CGRectMake(120, 10, 180, 40);
	priceLabel.frame = CGRectMake(120, 70, 100, 25);
}
-(void) drawRating:(NSInteger) ratingValue
{
	float x = 120.0, y = 100.0;
	UIImageView *starImageView;
	if (ratingValue > 0) {
		
		for (int i=0; i < ratingValue; i++) {
		
			starImageView = [[UIImageView alloc] init];
			//starImageView.image = [UIImage	imageNamed:@"star-selected.png"];//Star-Full.png
			starImageView.image = [UIImage	imageNamed:@"keditbookmarks.png"];
			starImageView.frame = CGRectMake(x, y, 16, 16);
			[starsArray addObject:starImageView];
			[self.contentView addSubview:starImageView];
			[starImageView release];
			x+=20;
		}
	}
	ratingValue = 5 - ratingValue;
	for (int i=0; i < ratingValue; i++) {
		
		starImageView = [[UIImageView alloc] init];
		starImageView.image = [UIImage	imageNamed:@"star_none.png"];
		starImageView.frame = CGRectMake(x, y-4, 22, 22);
		[starsArray addObject:starImageView];
		[self.contentView addSubview:starImageView];
		[starImageView release];
		x+=20;
	}
	


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[starsArray release];
	[priceLabel release];
	[itemNameLabel release];
    [super dealloc];
}


@end
