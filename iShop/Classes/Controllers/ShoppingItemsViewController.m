    //
//  ShoppingItemsViewController.m
//  Cart2Mobile
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import "ShoppingItemsViewController.h"
#import "ShoppingItemsTableViewCell.h"
#import "ShoppingItemListViewController.h"
#import "BaseDataLoader.h"
#import "BaseDeserializer.h"
#import "Constants.h"

@interface ShoppingItemsViewController ()

@property (nonatomic) DeserializerType currentDataFormat;
@property (nonatomic, retain) BaseDataLoader *dataLoader;
@property (nonatomic, retain) NSArray *data;

@end


@implementation ShoppingItemsViewController

@synthesize dataLoader = _dataLoader;
@synthesize data = _data;
@synthesize currentDataFormat = _currentDataFormat;
@synthesize itemsArray;
@synthesize cartDelegate;

- (id)initWithStyle:(UITableViewStyle)style withSelectedCell:(NSInteger )cellIndex CartDelegate:(id)cartdel
{
	// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		
		selectedCellIndex = cellIndex;
		self.cartDelegate = cartdel;
	}
	return self;
	
}

/*
-(void) dataReceived:(NSData*)data
{
	itemsArray = [[NSArray alloc] initWithArray:[[FlickrRemoteCaller sharedRemoteManager] shoppingItemsList]];
	//[[[FlickrRemoteCaller sharedRemoteManager] shoppingItemsList] retain];
	[self.tableView reloadData];
}*/


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	switch (selectedCellIndex) {
		case 0:
			self.title = @"Women's Products";
			break;
		case 1:
			self.title = @"Men's Products";
			break;
		case 2:
			self.title = @"Children's Products";
			break;
			
		default:
			break;
	}
	self.dataLoader.delegate = self;
	self.currentDataFormat = DeserializerTypeYAML;
}
#pragma mark -
#pragma mark DataLoaderDelegate methods

- (void)dataLoader:(BaseDataLoader *)loader didLoadData:(NSArray *)data
{
	/*
	 [self.spinningWheel stopAnimating];
	 */
    self.data = data;
	itemsArray = [[NSMutableArray alloc] initWithArray:self.data];
	[self.tableView reloadData];
	
}
- (IBAction)refresh:(id)sender
{
    self.data = nil;
    [self.tableView reloadData];
	// [self.spinningWheel startAnimating];
	
    if (self.currentDataFormat == DeserializerTypeSOAP)
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismSOAP];
    }
    else
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismASIHTTPRequest];
    }
    self.dataLoader.delegate = self;
    self.dataLoader.deserializer = [BaseDeserializer deserializerForFormat:self.currentDataFormat];
	
	switch (selectedCellIndex) {
		case 0:
			[self.dataLoader loadDataWithQuery:@"getWomensCategory" withCategoryType:@"Womens"];
			break;
		case 1:
		    [self.dataLoader loadDataWithQuery:@"getMensCategory" withCategoryType:@"Mens"];
			break;
		case 2:
			[self.dataLoader loadDataWithQuery:@"getChildrenCategory" withCategoryType:@"Children"];
			break;
			
		default:
			break;
	}
	
	

	//[self.dataLoader loadDataWithQuery:@"getMensShirts" withCategoryType:@"Mens"];
	//[self.dataLoader loadDataWithQuery:@"getMensPants" withCategoryType:@"Mens"];
	//[self.dataLoader loadDataWithQuery:@"getMensJackets" withCategoryType:@"Mens"];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [itemsArray count];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 130;
	
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	NSDictionary *item = [itemsArray objectAtIndex:indexPath.row];
	
	ShoppingItemsTableViewCell *cell =(ShoppingItemsTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ShoppingItemsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.itemNameLabel.text = [item objectForKey:@"fieldName"];
	NSString *itemName = [item objectForKey:@"name"];

	cell.itemImageView = [[AsyncImageView alloc] init];
	cell.itemImageView.frame = CGRectMake(10, 10, 100, 120);
	[cell.contentView addSubview:cell.itemImageView];
	
	int stringLength = [itemName length];
	
	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	
	imageName = [imageName stringByAppendingString:@".jpg"];
	NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
	
	NSURL *url = [NSURL URLWithString:urlString];
	[cell.itemImageView loadImageFromURL:url withFrame:CGRectMake(40.0, 50.0, 20.0, 20.0)];
  	
    // Configure the cell...
	
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *item = [itemsArray objectAtIndex:indexPath.row];
	
	ShoppingItemListViewController *shoppingItemListViewController = [[ShoppingItemListViewController alloc] 
																	  initWithStyle:UITableViewCellStyleDefault withSelectedCellItem:[item objectForKey:@"fieldName"] cartDelegate:self.cartDelegate];
	[self.navigationController pushViewController:shoppingItemListViewController animated:YES];
	[shoppingItemListViewController refresh:nil];
	[shoppingItemListViewController release];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    self.data = nil;
    self.dataLoader = nil;
    [super dealloc];
}

@end
