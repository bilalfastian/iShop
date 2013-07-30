//
//  ShoppingItemFullImageViewController.h
//  Client
//
//  Created by Bilal Nazir on 11/18/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThumbImageView.h"
#import "TapDetectingImageView.h"
#import "ShoppingItemDetailedViewController.h"
#import "ShoppingItemListViewController.h"

@interface ShoppingItemFullImageViewController : UIViewController<ThumbImageViewDelegate,UIScrollViewDelegate,TapDetectingImageViewDelegate>  {

	NSMutableArray *itemsArray;
	NSInteger selectedIndex;
	
	UIScrollView *reelScrollView;
	UIScrollView *imageScrollView;
	UIView *slideUpView;

	BOOL thumbViewShowing;
	NSTimer *autoscrollTimer;  // Timer used for auto-scrolling.
    float autoscrollDistance;  // Distance to scroll the thumb view when auto-scroll timer fires.
	ShoppingItemDetailedViewController *detailedViewController;
	ShoppingItemListViewController *listViewController;
	NSMutableArray *imagesNames;
	
	id cartdelegate;
}
@property (nonatomic, retain) id cartdelegate;
@property (nonatomic, retain) NSMutableArray *imagesNames;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, retain) ShoppingItemListViewController *listViewController;
@property (nonatomic, retain) ShoppingItemDetailedViewController *detailedViewController;
- (id)initWithItems:(NSArray*)itemsdata	andSelectedItemIndex:(NSInteger) index cartDelegate:(id)cartDel;
@end
