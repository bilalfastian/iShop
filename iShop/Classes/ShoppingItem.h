//
//  ShoppingItem.h
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/5/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShoppingItem : NSObject {
	NSString *description;
	NSString *name;
	NSString *comments;
	float price;
	NSInteger rating;
	NSInteger count;
}
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *comments;

@end
