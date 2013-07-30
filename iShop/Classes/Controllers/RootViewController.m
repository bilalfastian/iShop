//
//  RootViewController.m
//  Client
//
//  Created by Bilal Nazir on 11/14/10.
//  Copyright 2010 iBeamBack. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "RootViewController.h"
#import "BaseDataLoader.h"
#import "BaseDeserializer.h"
#import "NSDictionary+Extensions.h"
#import "NSUserDefaults+Extensions.h"
#import "CategoryTableViewCell.h"
#import "ShoppingItemsViewController.h"
#import "Constants.h"

@interface RootViewController ()

@property (nonatomic) DeserializerType currentDataFormat;
@property (nonatomic, retain) BaseDataLoader *dataLoader;
@property (nonatomic, retain) NSArray *data;
 
- (void)updateTitle;
@end


@implementation RootViewController

@synthesize dataLoader = _dataLoader;
@synthesize data = _data;
@synthesize currentDataFormat = _currentDataFormat;
@synthesize cartDelegate;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		self.title = @"Categories";
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Catalog" image:[UIImage imageNamed:@"openbookwp4.png"] tag:1];
	}
    return self;
}

- (void)dealloc
{
    self.data = nil;
    self.dataLoader = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)refresh:(id)sender
{
    self.data = nil;
    [self.tableView reloadData];

    if (self.currentDataFormat == DeserializerTypeSOAP)
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismSOAP];
    }
    else
    {
        self.dataLoader = [BaseDataLoader loaderWithMechanism:LoaderMechanismASIHTTPRequest];
    }
    self.dataLoader.deserializer = [BaseDeserializer deserializerForFormat:self.currentDataFormat];
    self.dataLoader.limit = 60;

    [self updateTitle];
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];

	
	
	
    self.currentDataFormat = DeserializerTypeYAML;
	 
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark DataLoaderDelegate methods

- (void)dataLoader:(BaseDataLoader *)loader didLoadData:(NSArray *)data
{

    self.data = data;
    [self.tableView reloadData];
	 
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 150;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"ControllerCell";
	CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    cell.cellNumber = [indexPath row];
	
	switch ([indexPath row]) {
		case 0:
			
			[cell setText:@"Women"];
			cell.women1ImageView.image = [UIImage imageNamed:@"Women.png"];
			cell.women2ImageView.image = [UIImage imageNamed:@"Women_2.png"];
			[cell.contentView addSubview:cell.women2ImageView];
			[cell.contentView addSubview:cell.women1ImageView];
			break;
		case 1:
			[cell setText:@"Men"];
			cell.man1ImageView.image = [UIImage imageNamed:@"Man1.png"];
			cell.man2ImageView.image = [UIImage imageNamed:@"Man_1.png"];
			[cell.contentView addSubview:cell.man1ImageView];
			[cell.contentView addSubview:cell.man2ImageView];
			break;
		case 2:
			[cell setText:@"Children"];
			cell.childImageView1.image = [UIImage imageNamed:@"BoyChild2.png"];
			cell.childImageView2.image = [UIImage imageNamed:@"Child.png"];
			[cell.contentView addSubview:cell.childImageView1];
			[cell.contentView addSubview:cell.childImageView2];
			break;
			
		default:
			break;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath row]) {
		case 0:
			SelectedCategory = WOMENS;
			break;
		case 1:
			SelectedCategory = MENS;
			break;
		case 2:
			SelectedCategory = CHILDREN;
			break;
		default:
			break;
	}
	ShoppingItemsViewController *shoppingItemsViewController = [[ShoppingItemsViewController alloc] 
																initWithStyle:UITableViewCellStyleDefault withSelectedCell:[indexPath row] CartDelegate:self.cartDelegate];
	[self.navigationController pushViewController:shoppingItemsViewController animated:YES];
	[shoppingItemsViewController refresh:nil];
	[shoppingItemsViewController release];
}

#pragma mark -
#pragma mark Private methods

- (void)updateTitle
{
}
@end
