//
//  GKPeopleViewController.m
//  GKContactExchange
//
//  Created by georgkitz on 8/29/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKPeopleViewController.h"
#import "GKPeoplePickerNavigationController.h"

#import "GKAddressBook.h"
#import "GKContact.h"
#import "GKGroup.h"

#import "GKPeopleCell.h"

#import <AddressBookUI/AddressBookUI.h>

@interface GKPeopleViewController ()<UISearchDisplayDelegate>{
    GKAddressBook *_addressBook;
    
    NSMutableArray *_usedData;
//    NSMutableArray *_data;
    NSMutableArray *_filteredData;
    NSMutableArray *_index;
    
    //Search
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayCtr;
    
    //Views
    UIView *_topView;
    UILabel *_footerView;
    
    //Preselect
    NSIndexPath *_preIndexPath;
}

@property (nonatomic) NSMutableArray *data;

@end

@implementation GKPeopleViewController

# pragma mark -
# pragma mark Properties

- (void)setPreselectedContact:(GKContact *)preselectedContact
{
    _preselectedContact = preselectedContact;
    [self selectPreselectedContact];
}

# pragma mark -
# pragma mark Private

- (void)addSection:(NSMutableArray *)section identifier:(NSString *)identifier
{
    NSDictionary *dict = @{ @"identifier": identifier, @"items":section };
    [_data addObject:dict];
    [_index addObject:identifier];
}

- (void)intialLoadAddressBook
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *contacts = (_filterGroup != nil ? [_filterGroup allMembersSorted] : [_addressBook allContactsSorted]);
        _usedData = [NSMutableArray arrayWithArray:contacts];
        
        NSMutableArray *section = [NSMutableArray array];
        NSString *lastIdentifier = nil;
        
        for (GKContact *contact in contacts) {
            
            //check if last identifier is equal to the current one
            //otherwise it is a new section
            NSString *identifier = [self identifierForName:[contact name]];
            if (lastIdentifier != nil && ![lastIdentifier isEqualToString:identifier]) {
                
                [self addSection:section identifier:lastIdentifier];
                
                section = [NSMutableArray array];
            }
            
            lastIdentifier = identifier;
            [section addObject:contact];
        }
        
        //last section has also an item
        if ([section count] > 0) {
            [self addSection:section identifier:lastIdentifier];
        }
        
        //search thingy on first position
        [_index insertObject:UITableViewIndexSearch atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _footerView.text = [NSString stringWithFormat:@"%d %@", [_usedData count], NSLocalizedString(@"GKContacts", @"")];
            [self.tableView reloadData];
            
            [self selectPreselectedContact];
        });
    });
}

- (void)selectPreselectedContact
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *identifierForName = [self identifierForName:[self.preselectedContact name]];
        NSInteger section = 0;
        NSInteger row = 0;

        for (NSDictionary *dict in self.data) {
            
            NSString *identifier = dict[@"identifier"];
            if (![identifierForName isEqualToString:identifier]) {
                section++;
                continue;
            }
            
            for (GKContact *contact in dict[@"items"]) {
                if ([contact isEqual:self.preselectedContact]) {
                    _preIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadRowsAtIndexPaths:@[_preIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView scrollToRowAtIndexPath:_preIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    });
                    return;
                }
                row++;
            }
            
            return;
        }
    });
}

- (NSString *)identifierForName:(NSString *)name
{
    //checks if the identifier for this section contains a printable
    //char otherwise we add the whole thing to the # section
    NSString *uppercase = name.uppercaseString;
    NSUInteger length = uppercase.length;
    for (NSInteger count = 0; count < length; count++) {
        
        unichar currentChar = [uppercase characterAtIndex:count];
        if ((currentChar >= 65 && currentChar <= 90)) {
            return [NSString stringWithCharacters:&currentChar length:1];
        }
        
    }
    return @"#";
}

- (void)setupSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView setTableHeaderView:_searchBar];
    
    _searchDisplayCtr = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayCtr.delegate = self;
    _searchDisplayCtr.searchResultsDataSource = self;
    _searchDisplayCtr.searchResultsDelegate = self;
}

- (void)setupTopView
{
    UIView *back = [[UIView alloc] initWithFrame:CGRectZero];
    back.backgroundColor = [UIColor colorWithRed:0.886 green:0.906 blue:0.929 alpha:1];
    [self.tableView addSubview:back];
}

- (void)setupBottomView
{
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    wrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _footerView.textColor = [UIColor grayColor];
    _footerView.backgroundColor = [UIColor clearColor];
    _footerView.font = [UIFont systemFontOfSize:20];
    _footerView.textAlignment = NSTextAlignmentCenter;
    
    [wrapper addSubview:_footerView];
    [self.tableView setTableFooterView:wrapper];
}

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
}

# pragma mark -
# pragma mark Action Methods

- (void)actionCancel:(id)sender
{
    GKPeoplePickerNavigationController *nCtr = (GKPeoplePickerNavigationController *)self.parentViewController;
    if ([nCtr.peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidCancel:)]) {
        [nCtr.peoplePickerDelegate peoplePickerNavigationControllerDidCancel:nCtr];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark ViewController Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _data = [NSMutableArray array];
        _index = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self intialLoadAddressBook];
    [self setupSearchBar];
    [self setupNavigationBar];
    [self setupTopView];
    [self setupBottomView];
    
    self.title = self.filterGroup ? [self.filterGroup name] : NSLocalizedString(@"GKAllContacts", @"");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_prefilledSearchTerm) {
        [_searchBar becomeFirstResponder];
        _searchBar.text = _prefilledSearchTerm;
    }
}

- (void)viewWillLayoutSubviews
{
    _topView.frame = CGRectMake(0, -CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark -
# pragma mark TableView Delegate & Datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.tableView == tableView) {
        return _index;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
        return NSNotFound;
    }
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        NSDictionary *dict = _data[section];
        return dict[@"identifier"];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableView == tableView) {
        return [_data count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        NSDictionary *dict = _data[section];
        NSArray *items = dict[@"items"];
        return [items count];
    }
    
    return [_filteredData count];
}

- (GKContact *)contactAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    GKContact *contact = nil;
    if (self.tableView == tableView) {
        
        NSDictionary *dict = _data[indexPath.section];
        NSArray *items = dict[@"items"];
        
        contact = items[indexPath.row];
        
    } else {
        
        contact = [_filteredData objectAtIndex:indexPath.row];
    }
    return contact;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GKPeopleCell *cell = (GKPeopleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[GKPeopleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
 
    GKContact *contact;
    contact = [self contactAtIndexPath:indexPath tableView:tableView];
    
    //check if we have first or lastname otherwise it's a company
    if ([contact.firstname length] == 0 && [contact.lastname length] == 0) {
        cell.textLabel.text = contact.companyName;
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = contact.firstname;
        cell.detailTextLabel.text = contact.lastname;
    }
    
    cell.preselectedCell = (self.tableView == tableView && [indexPath isEqual:_preIndexPath]);
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKPeoplePickerNavigationController *nCtr = (GKPeoplePickerNavigationController *)self.parentViewController;
    GKContact *contact = [self contactAtIndexPath:indexPath tableView:tableView];
    
    //checks the delegate stuff, if no we return, if yes we show the ABPersonViewController
    if ([nCtr.peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationController:shouldContinueAfterSelectingPerson:)]) {
     
        if (![nCtr.peoplePickerDelegate peoplePickerNavigationController:nCtr shouldContinueAfterSelectingPerson:contact.record]) {
            return;
        }
    }
    
    //show person view ctr
    ABPersonViewController *ctr = [[ABPersonViewController alloc] init];
    ctr.displayedPerson = contact.record;
    ctr.allowsActions = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}

# pragma mark -
# pragma mark UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (!_filteredData) {
        _filteredData = [NSMutableArray array];
    }
    
    [_filteredData removeAllObjects];
    
    for (GKContact *contact in _usedData){
        if ([contact.name rangeOfString:searchString].location != NSNotFound) {
            [_filteredData addObject:contact];
        }
    }
    return YES;
}

@end
