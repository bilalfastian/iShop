//
//  ShoppingItem.m
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/5/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "ShoppingItem.h"


@implementation ShoppingItem

@synthesize description, name, comments;
@synthesize price;
@synthesize rating;
@synthesize count;

-(id)init
{
	if (self = [super init]) {
		rating = 0;
		count = 0;
		price = -1;
		description = [[NSString alloc] init];
		name = [[NSString alloc] init];
		comments = [[NSString alloc] init];
	}
	
	return self;
}

-(void)dealloc
{
	[description release];
	[name release];
	[comments release];
	[super dealloc];
}

@end
