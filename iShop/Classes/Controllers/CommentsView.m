//
//  CommentsView.m
//  Client
//
//  Created by Bilal Nazir on 11/20/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "CommentsView.h"



@implementation CommentsView

@synthesize userNameLabel;
@synthesize commentText;
@synthesize qualityLabel;
@synthesize comfortLabel;
@synthesize appearanceLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.

		userNameLabel = [[UILabel alloc] init];
		qualityLabel = [[UILabel alloc] init];
		comfortLabel = [[UILabel alloc] init];
		appearanceLabel = [[UILabel alloc] init];
		
		qualityLabel.text = @"Quality :";
		comfortLabel.text = @"Comfort :";
		appearanceLabel.text = @"Appearance :";
		qualityLabel.font = [UIFont systemFontOfSize:14];
		comfortLabel.font = [UIFont systemFontOfSize:14];
		appearanceLabel.font = [UIFont systemFontOfSize:14];
		
	
		commentText = [[UITextView alloc] init];
		commentText.font = [UIFont systemFontOfSize:14];
		commentText.scrollEnabled = NO;
		commentText.editable = NO;
		//qualityLabel.backgroundColor = [UIColor grayColor];
		[self addSubview:qualityLabel];
		[self addSubview:comfortLabel];
		[self addSubview:appearanceLabel];
		[self addSubview:userNameLabel];
		[self addSubview:commentText];
    }
    return self;
}
-(void) layoutSubviews
{
	[super layoutSubviews];
	userNameLabel.frame = CGRectMake(5, 5, 250, 20);
	qualityLabel.frame = CGRectMake(5, 30, 60, 20);
	comfortLabel.frame = CGRectMake(5, 50, 80, 20);
	appearanceLabel.frame = CGRectMake(5, 70, 90, 20);
}


-(void) drawRating:(NSInteger) ratingValue  withXPoint:(NSInteger)x andYPoint:(NSInteger) y
{
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
	
//	y+=20;
	//x+=10;
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
