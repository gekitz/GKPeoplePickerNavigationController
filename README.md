### GKPeoplePickerNavigationController

Ever wanted to customize Apple's ABPeoplePickerNavigationController in some way? You probably figured out that it's quite impossible to do it. I ran into the same issue that's why I wrote a dead simple drop in replacement for it. 

It supports **pre selecting a contact** and can **pre fill the search bar**.

### How to use it

- just drag and drop the files under "GKClasses" into your project.
- add the `AddressBook.framework` and `AddressBookUI.framework` to your project
- look at the sample code below.
- this project contains a sample project as well, just have a look at the implementation of `ViewController.m` 
- have fun and follow [@gekitz](http://www.twitter.com/gekitz).


### Sample Code

How to preselect a contact:
	
	ABRecordRef person = <# retrieve person from somewhere #>

    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            ctr.preselectedPerson = person;
            [self presentViewController:ctr animated:YES completion:nil];
            
        }
    }];
    
This results in:
![preselect person image](https://dl.dropbox.com/u/311618/GKPeoplePickerNavigationController/preselect_contact.png)

How to prefill the UISearchBar:
	
	    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            ctr.prefilledSearchTerm = @"Georg";
            [self presentViewController:ctr animated:YES completion:nil];

        }
    }];

This results in:
![prefilled search image](https://dl.dropbox.com/u/311618/GKPeoplePickerNavigationController/prefilled_search.png)     

### License
Under MIT.



    