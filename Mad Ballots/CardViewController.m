//
//  CardViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "GameViewController.h"
#import "Candidate.h"
#import "TableViewTextField.h"

#define TABLEVIEW_CELL_HEIGHT 88

@implementation CardViewController

@synthesize candidates;
@synthesize cardId;
@synthesize category;
@synthesize tableView;
@synthesize titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//- (void) setupUI{
//    pageControl.numberOfPages = dataArray.count + 1;
//    pageControl.currentPage = 0;
//    pageControlBeingUsed = NO;
//    scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*pageControl.numberOfPages, self.scrollView.frame.size.height);
//    scrollView.contentOffset = CGPointMake(0, 0);
//    CandidateOverviewController *firstView = [[CandidateOverviewController alloc] initWithStyle:UITableViewStylePlain];
//    firstView.candidates = dataArray;
//    firstView.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//    firstView.tableView.frame = firstView.view.frame;
//    firstView.delegate = self;
//    [self.scrollView addSubview:firstView.view];
//    viewControllers = [NSMutableArray array];
//    [viewControllers addObject:firstView];
//    CandidateViewController *candidateView;
//    for(int ii=0;ii < [dataArray count]; ii++){
//        candidateView = [[CandidateViewController alloc] initWithNibName:@"CandidateViewController" bundle:nil andCandidate:[dataArray objectAtIndex:ii]];
//        candidateView.view.frame = CGRectMake(self.scrollView.frame.size.width * (ii+1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//        candidateView.delegate = self;
//        [self.scrollView addSubview:candidateView.view];
//        [viewControllers addObject:candidateView];
//    }
//    candidateView.valueTextField.returnKeyType = UIReturnKeyDone;
//}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Fill Card";
    self.titleLabel.text = [NSString stringWithFormat:@"What %@ is...",category];
    //TODO:Set title with category information
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"cards/%@/candidates.json",cardId] usingBlock:^(RKObjectLoader *loader){
        loader.delegate = self;
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)submit:(id)sender{
    for(Candidate *candidate in candidates){
        if([candidate.value length] == 0){
            [[[UIAlertView alloc] initWithTitle:@"Card is incomplete" message:@"Please fill out a each candidate before submitting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
    }
    for(Candidate *candidate in candidates){
        [[RKObjectManager sharedManager] putObject:candidate delegate:self];
    
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [candidates count] + ceil(216/TABLEVIEW_CELL_HEIGHT)+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CardCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    TableViewTextField *valueTextfield = (TableViewTextField*)[cell viewWithTag:4];
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:3];

    if(indexPath.row >= [candidates count]){
        label.text = @"";
        valueTextfield.text = @"";
        imageView.image = nil;
        return cell;
    }
    
    Candidate *candidate = [candidates objectAtIndex:indexPath.row];
    label.text = candidate.player.name;
    valueTextfield.row = indexPath.row;
    valueTextfield.text = candidate.value ? candidate.value : @"";
    if(indexPath.row == ([candidates count] - 1))
        valueTextfield.returnKeyType = UIReturnKeyDone;
    else
        valueTextfield.returnKeyType = UIReturnKeyNext;
    //TODO: Add image support
    imageView.image = [UIImage imageNamed:@"default_list_user.png"];
    
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLEVIEW_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    cell.selected = NO;
    TableViewTextField *valueTextfield = (TableViewTextField*)[cell viewWithTag:4];
    [valueTextfield becomeFirstResponder];
}


#pragma mark Object loader delegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Did get objects: %@", objects);
    if(objectLoader.method == RKRequestMethodGET){
        self.candidates = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
        return;
    }
    //TODO: Duplicated Code
    if(objectLoader.method == RKRequestMethodPUT){
        RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
        if(queue.count == 1)
            
            [self.navigationController popViewControllerAnimated:YES];
        
    }

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    //TODO: Display Errors
    //TODO: Duplicated Code
    if(objectLoader.method == RKRequestMethodPUT){
        RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
        if(queue.count == 1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Texfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    TableViewTextField *returnedTextField = (TableViewTextField*)textField;
    [textField resignFirstResponder];
    if(textField.returnKeyType == UIReturnKeyNext){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:returnedTextField.row+1 inSection:0]];
        TableViewTextField *valueTextfield = (TableViewTextField*)[cell viewWithTag:4];
        [valueTextfield becomeFirstResponder]; 
    }
    else if(textField.returnKeyType == UIReturnKeyDone){
        [returnedTextField resignFirstResponder];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    TableViewTextField *selectedTextField = (TableViewTextField*)textField;
    Candidate *candidate = [candidates objectAtIndex:selectedTextField.row];
    candidate.value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
