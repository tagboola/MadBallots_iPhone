//
//  MBPlayerViewControllerViewController.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBPlayerViewController.h"
#import "Player.h"
#import "MBAuthentication.h"
#import "MBAuthenticationInfo.h"
#import "MBAuthenticationCredentials.h"
#import "RestKit.h"
#import "AppDelegate.h"

@interface MBPlayerViewController ()

@end

@implementation MBPlayerViewController
@synthesize nameTextField;
@synthesize usernameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize commitButton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil    
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(BOOL) playerIsValid{
    if([self.usernameTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Username is required" message:@"Please enter a username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    
    if([self.passwordTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Password is required" message:@"Please enter a password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    
    if( ![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text] ){
        [[[UIAlertView alloc] initWithTitle:@"Passwords don't match" message:@"Please enter and confirm password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    
    return YES;
}



#pragma mark - Actions

-(IBAction)commitPlayer:(id)sender
{
    if(![self playerIsValid])
        return;
    
    //Create an authentication
    MBAuthentication * auth = [[MBAuthentication alloc] init];
    auth.provider = MAD_BALLOTS_AUTH_PROVIDER_STRING;
    auth.uid = [self.usernameTextField text];
    auth.credentials.secret = [self.passwordTextField text];
    auth.credentials.secretConfirmation = [self.confirmPasswordTextField text];
    auth.info.name = [self.nameTextField text];
    auth.info.email = [self.emailTextField text];
    
    //Request the authentication
    [[RKObjectManager sharedManager] postObject:auth usingBlock:^ (RKObjectLoader *loader) {
        loader.targetObject = [[Player alloc] init];
        loader.delegate = self;
    }];
        
}


-(IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    NSLog(@"Did create player: %@", objects);
    Player *player = [objects objectAtIndex:0];
    if (player){
        [AppDelegate getInstance].currentPlayer = player;
        [[NSUserDefaults standardUserDefaults] setValue:player.persistenceToken forKey:PERSISTENCE_TOKEN_KEY];
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        //[self dismissModalViewControllerAnimated:YES];
        //[AppDelegate dismissLogin];
    }else{ //display an alert or something
        
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);    
}



@end
