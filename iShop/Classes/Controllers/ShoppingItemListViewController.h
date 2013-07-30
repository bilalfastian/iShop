//
//  ShoppingItemListViewController.h
//  Client
//
//  Created by Bilal Nazir on 11/17/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeserializerType.h"
#import "DataLoader.h"
#import "DataLoaderDelegate.h"

@interface ShoppingItemListViewController : UITableViewController<DataLoaderDelegate,UITableViewDelegate, UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>{

	
	NSString *selectedCellItemName;
	
	id cartDelegate;
	
	//UITableView *myTableView;
	
	NSMutableArray *itemsArray;
	
	NSMutableArray				*filteredListContent;	// The content filtered as a result of a search.
	
	UISearchDisplayController	*searchDisplayController;

	
@private
    DeserializerType _currentDataFormat;
    id<DataLoader> _dataLoader;
    NSArray *_data;
	
	
}

//@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic,retain) id cartDelegate;
@property (nonatomic, retain) NSString *selectedCellItemName;

@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;



- (id)initWithStyle:(UITableViewStyle)style withSelectedCellItem:(NSString * )cellItemName cartDelegate:(id)cartDel;
-(void)refresh:(id)sender;
-(void)fill_ItemObjects;
@end
