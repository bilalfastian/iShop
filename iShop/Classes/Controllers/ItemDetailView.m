//
//  ItemDetailView.m
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/7/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "ItemDetailView.h"


@implementation ItemDetailView

@synthesize itemName, itemPrice, shopItemImage;
@synthesize ratingLabel;
@synthesize descriptionLabel;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.

		shopItemImage = [[UIImageView alloc] init];
		itemName = [[UILabel alloc] init];
		itemPrice = [[UILabel alloc] init];
		descriptionLabel = [[UILabel alloc] init];
		itemNameLabel = [[UILabel alloc] init];
		ratingLabel = [[UILabel alloc] init];
		
		ratingLabel.text = @"Rating:";
		ratingLabel.font = [UIFont systemFontOfSize:14];
		ratingLabel.textColor = [UIColor redColor];
		
		descriptionLabel.text = @"Description:";
		descriptionLabel.font = [UIFont systemFontOfSize:16];
		descriptionLabel.textColor = [UIColor grayColor];
		
		itemNameLabel.text = @"Item Name:";
		itemNameLabel.font = [UIFont systemFontOfSize:14];
		itemNameLabel.textColor = [UIColor redColor];
		
		itemPrice.textColor = [UIColor redColor];
		itemPrice.font =  [UIFont systemFontOfSize:14];
		itemName.font = [UIFont systemFontOfSize:14];
		itemName.numberOfLines = 0;
		
		[self addSubview:ratingLabel];
		
		[self addSubview:shopItemImage];
		[self addSubview:itemName];
		[self addSubview:itemNameLabel];
		[self addSubview:itemPrice];
		
	
		[ratingLabel release];
		[itemNameLabel release];
	}
    return self;
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	itemNameLabel.frame = CGRectMake(120, 5, 150, 20);
	shopItemImage.frame = CGRectMake(10, 10, 100, 130);
	itemName.frame = CGRectMake(120, 25, 170, 50);
	itemPrice.frame = CGRectMake(120, 80, 150, 20);
	descriptionLabel.frame = CGRectMake(5, 148, 150, 20);
	ratingLabel.frame = CGRectMake(120, 110, 150, 20);
}
-(void) drawRating:(NSInteger) ratingValue
{
	float x = 170.0, y = 113.0;
	UIImageView *starImageView;
	if (ratingValue > 0) {
		
		for (int i=0; i < ratingValue; i++) {
			
			starImageView = [[UIImageView alloc] init];
			//starImageView.image = [UIImage	imageNamed:@"star-selected.png"];//Star-Full.png
			starImageView.image = [UIImage	imageNamed:@"keditbookmarks.png"];
			starImageView.frame = CGRectMake(x, y, 16, 16);
			[self addSubview:starImageView];
			[starImageView release];
			x+=20;
		}
	}
	ratingValue = 5 - ratingValue;
	for (int i=0; i < ratingValue; i++) {
		
		starImageView = [[UIImageView alloc] init];
		starImageView.image = [UIImage	imageNamed:@"star_none.png"];
		starImageView.frame = CGRectMake(x, y-4, 22, 22);
		[self addSubview:starImageView];
		[starImageView release];
		x+=20;
	}
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	
	[descriptionLabel release];
	[shopItemImage release];
	[itemName release];
	[itemPrice release];
    [super dealloc];
}


@end
