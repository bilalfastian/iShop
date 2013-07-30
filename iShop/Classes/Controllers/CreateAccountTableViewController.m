//
//  CreateAccountTableViewController.m
//  Client
//
//  Created by Bilal Nazir on 12/9/10.
//  Copyright 2010 iShop. All rights reserved.
//

#import "CreateAccountTableViewController.h"
#define SectionHeaderHeight 30


@implementation CreateAccountTableViewController

@synthesize createAccountBtn;
@synthesize emailIDTextField;
@synthesize passwordTextField;
@synthesize userNameTextField;



-(void) createAccountBtnClicked:(id) sender
{
	if ( [userNameTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] ||[emailIDTextField.text isEqualToString:@""]
		 )
	{
		UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Requare data is not completed" 
														 message:@"Please fill all the data first" // IMPORTANT
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil,nil];
		
		[prompt show];
		[prompt release];
		
		
	}else {
		UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Account Created Successfully" 
														 message:@"Based on selection type your account created" // IMPORTANT
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil,nil];
		
		[prompt show];
		[prompt release];
		
		userNameTextField.text = @"";
		passwordTextField.text = @"";
		emailIDTextField.text = @"";
		
	}

	
}

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization.
		
		
		userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 10.0, 190.0, 28.0)];
		[userNameTextField setBorderStyle:UITextBorderStyleRoundedRect];
		
			
		passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 45.0, 190.0, 28.0)];
		passwordTextField.secureTextEntry = YES;
		[passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
		
		emailIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 85.0, 190.0, 28.0)];
		[emailIDTextField setBorderStyle:UITextBorderStyleRoundedRect];

		userNameTextField.text = @"";
		passwordTextField.text = @"";
		emailIDTextField.text = @"";
		
		createAccountBtn = [[MOGlassButton alloc] initWithFrame:CGRectMake(100, 325, 130, 35)];
		[createAccountBtn setupAsGreenButton];
		createAccountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
		[createAccountBtn setTitle:@"Create Account" forState:UIControlStateNormal];
		[createAccountBtn addTarget:self action:@selector(createAccountBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

		typeArray = [[NSArray alloc] initWithObjects:@"Student",@"Business Man",@"Commen Man",nil];
		//typeArray = [NSArray arrayWithObjects:@"Student",@"Business Man",@"Commen Man",nil];
		
	}
    return self;
}
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}


-(void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) saveBtn_Clicked:(id) sender
{
    [self.emailIDTextField resignFirstResponder];
	[self.userNameTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
											   target:self action:@selector(saveBtn_Clicked:)] autorelease];
	
	[self.view addSubview:createAccountBtn];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.tableView.frame = CGRectMake(0.0, 0.0, 320, 400);
}*/

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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return SectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Account Information";
	}
	if(section == 1) {
		sectionHeader = @"Seclect one Account Type";
	}  
	return sectionHeader; 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

	if (section == 0) {
		
		return 1;
	}
	
	return 3;

}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (indexPath.section == 0) {

				return 130;
	}
		
  return 40;

	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (indexPath.section == 0) {
	
		UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 20)];
		userNameLabel.text = @"Username :";
		userNameLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:userNameLabel];
		[userNameLabel release];
		
		UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 80, 20)];
		passwordLabel.text = @"Password :";
		passwordLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:passwordLabel];
		[passwordLabel release];
		
		UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 80, 20)];
		emailLabel.text = @"Email ID :";
		emailLabel.font =[UIFont systemFontOfSize:14];
		[cell.contentView addSubview:emailLabel];
		[emailLabel release];
		
		
		[cell.contentView addSubview:userNameTextField];
		
		[cell.contentView addSubview:passwordTextField];
		[cell.contentView addSubview:emailIDTextField];
	}
	else {
		 cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.text = [typeArray objectAtIndex:indexPath.row];
	}

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
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (indexPath.section ==1) {
		if (cell.accessoryType == UITableViewCellAccessoryNone) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}

	}
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
    [super dealloc];
}


@end

