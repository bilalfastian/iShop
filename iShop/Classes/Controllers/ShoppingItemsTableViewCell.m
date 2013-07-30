//
//  ShoppingItemsTableViewCell.m
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "ShoppingItemsTableViewCell.h"


@implementation ShoppingItemsTableViewCell

@synthesize itemsCountLabel,itemNameLabel;
@synthesize itemImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		itemNameLabel = [[UILabel alloc] init];
		itemNameLabel.font = [UIFont systemFontOfSize:14];
		
		/*itemsCountLabel = [[UILabel alloc] init];
		itemsCountLabel.font = [UIFont systemFontOfSize:14];
		itemsCountLabel.textColor = [UIColor grayColor];*/
		
		[self.contentView addSubview:itemNameLabel];
		
    }
    return self;
}


-(void) layoutSubviews
{
	[super layoutSubviews];
	itemsCountLabel.frame = CGRectMake(150, 80, 20, 20);
	itemNameLabel.frame = CGRectMake(150, 20, 200, 20);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	[itemImageView release];
	[itemNameLabel release];
	//[itemsCountLabel release];
    [super dealloc];
}

@end
