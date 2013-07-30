//
//  ShoppingItemsViewController.h
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DeserializerType.h"
#import "DataLoader.h"
#import "DataLoaderDelegate.h"

@interface ShoppingItemsViewController : UITableViewController <DataLoaderDelegate>{
		
	
	NSInteger selectedCellIndex;
	NSMutableArray *itemsArray;
	
	
	id cartDelegate;
@private
    DeserializerType _currentDataFormat;
    id<DataLoader> _dataLoader;
    NSArray *_data;

}
@property (nonatomic, retain) 	id cartDelegate;
@property (nonatomic, retain) NSMutableArray *itemsArray;

- (id)initWithStyle:(UITableViewStyle)style withSelectedCell:(NSInteger )cellIndex CartDelegate:(id)cartdel;

-(void)refresh:(id)sender;

@end
