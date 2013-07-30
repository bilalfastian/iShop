//
//  CommentsViewController.h
//  Client
//
//  Created by Bilal Nazir on 11/19/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeserializerType.h"
#import "DataLoader.h"
#import "DataLoaderDelegate.h"
#import "ShoppingItem.h"
#import "RateView.h"

@class UIThreePartButton;

@interface CommentsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,DataLoaderDelegate,
									UIAlertViewDelegate,RateViewDelegate,UITextViewDelegate> {
	
	UITableView  *itemDescriptionTableView;
	ShoppingItem *item;
	RateView *qualityRatingView,*comfortRatingView,*appearanceRatingView;
	
	UITextView *commentBox;
	NSMutableArray *dataArray;
	
	NSInteger qualityRating;
	NSInteger comfortRating;
	NSInteger appearanceRating;
	
	UITextField *userNameField,*commentBoxField;
	BOOL isFirstTime;
@private
    DeserializerType _currentDataFormat;
    id<DataLoader> _dataLoader;
    NSArray *_data;
}

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UITableView *itemDescriptionTableView;
-(void)refresh:(id)sender;
-(id) initWithItem:(ShoppingItem*) newItem;
@end