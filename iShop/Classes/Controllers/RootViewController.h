//
//  RootViewController.h
//  Client
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "DeserializerType.h"
#import "DataLoader.h"
#import "DataLoaderDelegate.h"

@interface RootViewController : UITableViewController <DataLoaderDelegate>
{
	
	id cartDelegate;
	
@private
    DeserializerType _currentDataFormat;
    id<DataLoader> _dataLoader;
    NSArray *_data;
}

@property (nonatomic, retain) id cartDelegate;
@end
