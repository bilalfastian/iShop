//
//  ShoppingItemListViewController.m
//  Client
//
//  Created by Bilal Nazir on 11/17/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "ShoppingItemListViewController.h"
#import "ShoppingItemListTableViewCell.h"
#import "ShoppingItemFullImageViewController.h"
#import "AsyncImageView.h"
#import "ShoppingItem.h"
#import "BaseDataLoader.h"
#import "BaseDeserializer.h"

#import "Constants.h"

@interface ShoppingItemListViewController ()

@property (nonatomic) DeserializerType currentDataFormat;
@property (nonatomic, retain) BaseDataLoader *dataLoader;
@property (nonatomic, retain) NSArray *data;

@end


@implementation ShoppingItemListViewController

@synthesize dataLoader = _dataLoader;
@synthesize data = _data;
@synthesize currentDataFormat = _currentDataFormat;
@synthesize itemsArray;
@synthesize selectedCellItemName;
@synthesize cartDelegate;
//@synthesize myTableView;

@synthesize filteredListContent;
@synthesize searchDisplayController;

- (id)initWithStyle:(UITableViewStyle)style withSelectedCellItem:(NSString * )cellItemName cartDelegate:(id)cartDel
{
	// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super init])) {
		itemsArray = [[NSMutableArray alloc] init];
		selectedCellItemName = [[NSString alloc] initWithString:cellItemName];
		
		self.cartDelegate = cartDel;
		/*
		myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
		myTableView.delegate = self;
		myTableView.dataSource = self;
		*/
		self.navigationController.navigationBarHidden = NO;
	}
	return self;
	
}


#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

 	self.title = selectedCellItemName;
	self.dataLoader.delegate = self;
	self.currentDataFormat = DeserializerTypeYAML;

	//[self.view addSubview:myTableView];
	
	self.filteredListContent = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
	
	UISearchBar *mySearchBar = [[UISearchBar alloc] init];
	//[mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"All",@"Device",@"Desktop",@"Portable",nil]];
	mySearchBar.delegate = self;
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
	self.tableView.tableHeaderView = mySearchBar;
	/*
	 fix the search bar width problem in landscape screen
	 */
	if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
		UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
	{
		self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 480.f, 44.f);
	}
	else
	{
		self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
	}
	/*
	 set up the searchDisplayController programically
	 */
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	[self setSearchDisplayController:searchDisplayController];
	[searchDisplayController setDelegate:self];
	[searchDisplayController setSearchResultsDataSource:self];
	
	[mySearchBar release];
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
	
	
}



- (void)viewWillAppear:(BOOL)animated {
	/*
	 Hide the search bar
	 */
	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:NO];
	
	
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/**/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark -
#pragma mark DataLoaderDelegate methods
-(void) fill_ItemObjects
{
	NSDictionary *newItem;
	
	
	for (newItem in self.data) {
	 ShoppingItem *shoppingItem = [[ShoppingItem alloc] init];
	 shoppingItem.name = [newItem objectForKey:@"name"];
	 shoppingItem.description = [newItem objectForKey:@"description"];
	 shoppingItem.comments = [newItem objectForKey:@"comments"];
	 shoppingItem.price = [[newItem objectForKey:@"price"] doubleValue];
	 shoppingItem.rating = [[newItem objectForKey:@"rating"] intValue];
	 [itemsArray addObject:shoppingItem];
	 
	 [shoppingItem release];
	 }
	
}
- (void)dataLoader:(BaseDataLoader *)loader didLoadData:(NSArray *)data
{
	/*
	 [self.spinningWheel stopAnimating];
	 */
    self.data = data;
	
	[self fill_ItemObjects];

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

	switch (SelectedCategory) {
		case 0:
			if ([selectedCellItemName isEqualToString:@"Shirts & Tops"]) {
				[self.dataLoader loadDataWithQuery:@"getWomensShirtsAndTops" withCategoryType:@"Womens"];
			}
			else
			{
				[self.dataLoader loadDataWithQuery:[NSString stringWithFormat:@"getWomens%@",selectedCellItemName] withCategoryType:@"Womens"];
			}
			break;
		case 1:

			[self.dataLoader loadDataWithQuery:[NSString stringWithFormat:@"getMens%@",selectedCellItemName] withCategoryType:@"Mens"];
			break;
		case 2:
			[self.dataLoader loadDataWithQuery:[NSString stringWithFormat:@"getChildren%@",selectedCellItemName] withCategoryType:@"Children"];
			break;
			
		default:
			break;
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return [itemsArray count];
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.itemsArray count];
    }
	
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 130;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//ShoppingItem *item = [itemsArray objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"Cell";
	
	ShoppingItemListTableViewCell *cell =(ShoppingItemListTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[ShoppingItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	else {
		UIImageView *imageView;
		for (imageView in cell.starsArray) {
			[imageView removeFromSuperview];
		}
	}
	ShoppingItem *item;
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        item = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        item = [self.itemsArray objectAtIndex:indexPath.row];
    }
	
	
	cell.itemNameLabel.text = item.name;
	cell.priceLabel.text = [NSString stringWithFormat:@"Price: $ %.02f",item.price];
	
	cell.itemImageView = [[AsyncImageView alloc] init];
	cell.itemImageView.frame = CGRectMake(10, 10, 100, 120);
	[cell.contentView addSubview:cell.itemImageView];
	
	int stringLength = [item.name length];
	
	NSRange range;
	range.location = 0;
	range.length = stringLength;
	
	NSString *imageName = [item.name stringByReplacingOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:range];
	

	imageName = [imageName stringByAppendingString:@".jpg"];
	NSString *urlString = [Thumbnail_URL stringByAppendingString:imageName];
	
	NSURL *url = [NSURL URLWithString:urlString];
	[cell.itemImageView loadImageFromURL:url withFrame:CGRectMake(40.0, 50.0, 20.0, 20.0)];
	
	[cell drawRating:item.rating];
	// Configure the cell...

	return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	ShoppingItem *selectedItem = nil;
	int selectedIndex =0;
	if (indexPath.row < [self.filteredListContent count]) {
		selectedItem = [self.filteredListContent objectAtIndex:indexPath.row];
		ShoppingItem *tempItem = nil;
		for(int i=0; i < [itemsArray count]; i++)
		{
			tempItem = [itemsArray objectAtIndex:i];
			if ([tempItem.name isEqualToString:selectedItem.name]) {
				selectedIndex = i;
				break;
			}
		}
	}
	else {
		selectedIndex = indexPath.row;
	}
	//[self.filteredListContent removeAllObjects];
	ShoppingItemFullImageViewController *shoppingItemFullImageViewController = [[ShoppingItemFullImageViewController alloc] initWithItems:itemsArray andSelectedItemIndex:selectedIndex cartDelegate:self.cartDelegate];
	[self.navigationController pushViewController:shoppingItemFullImageViewController animated:YES];
	[shoppingItemFullImageViewController release];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[selectedCellItemName release];
    [super dealloc];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects];// First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (ShoppingItem  *product in itemsArray)
	{
		//if ([scope isEqualToString:@"All"] || [product.name isEqualToString:scope])
		{
			NSComparisonResult result = [product.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:product];
            }
		}
	}
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
	 Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
	 */
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}

#pragma mark -
- (void)searchBarCancelButtonClicked:(UISearchBar *)inSearchBar
{
	[self.filteredListContent removeAllObjects];
}
-(void)searchBar:(id)sender{
	[searchDisplayController setActive:YES animated:YES];
}



@end

