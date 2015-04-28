//
//  SearchBarController.m
//  WiseCabs
//
//  Created by Nagraj on 19/12/12.
//
//

#import "SearchBarController.h"
#import "Places.h"
#import "WiseCabsAppDelegate.h"
#import "UserJourney.h"
#import "Journey.h" 
#import "Common.h"
#import "WebServiceHelper.h"

@interface SearchBarController ()

@end

@implementation SearchBarController
@synthesize searchDisplayController,searchTableView,placesArray,mySearchBar,listContent,filteredListContent,myParentIS,placeType, searchedCityString;
static sqlite3 *database = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated{
    //[self.mySearchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filteredListContent = [[[NSMutableArray alloc] init] autorelease];
    
    if(![self.placeType isEqualToString:@"City"])
        [self loadPlacesFromDB:self.placeType];
    
    self.navigationItem.title= [NSString stringWithFormat:@"%@s",placeType];
    mySearchBar.delegate = self;
  // self.navigationItem.hidesBackButton = YES;
   // self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)  ] autorelease];
    
  //  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
    if ([self.placeType isEqualToString:@"City"])
    {
        //NSString *addressName= [self.filteredListContent objectAtIndex:indexPath.row];
        //NSLog(@"selected address--- %@",addressName);
    }
    
    else
    {
        self.mySearchBar.placeholder = [NSString stringWithFormat:@"Search %@..",placeType];
    }
	
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	
	[self setSearchDisplayController:searchDisplayController];
	[searchDisplayController setDelegate:self];
	[searchDisplayController setSearchResultsDataSource:self];
	
	[mySearchBar release];
	
	[self.searchTableView reloadData];
	self.searchTableView.scrollEnabled = YES;
    
        [self.mySearchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}


- (void) loadPlacesFromDB:(NSString*)tableName{
	//m_db = [[SQLHelper alloc] init];
	if (placesArray!=nil) {
		[placesArray release];
		placesArray=nil;
	}
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	WiseCabsAppDelegate *appDelegate = (id)[[UIApplication sharedApplication] delegate];
	NSString *dbpath = [appDelegate getDBPath];
	
	sqlite3_stmt *selectStmt;
	//NSString *selectPlacesQuery=[NSString stringWithFormat:@"SELECT LocationId,LocationName FROM %@ ",tableName];
    NSString *selectPlacesQuery=@"";
    if ([tableName isEqualToString:@"Airport"]) {
       selectPlacesQuery=[NSString stringWithFormat:@"SELECT PlaceId,PlaceName,PostCode,TruncatedName FROM %@ Where LocalityId=69",tableName];
    }else{
        selectPlacesQuery =[NSString stringWithFormat:@"SELECT PlaceId,PlaceName,PostCode,TruncatedName FROM %@ ",tableName];
    }
    NSLog(@"selectPlaceQuerry is %@",selectPlacesQuery);
	
	if(sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) {
		const char *sql = [selectPlacesQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
		
		placesArray=[[NSMutableArray alloc] init];
		
		while(sqlite3_step(selectStmt) == SQLITE_ROW)
		{
			Places *places=[[[Places alloc] init] autorelease];
			places.placeId=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 0)] autorelease];
			places.placeName=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 1)] autorelease];
            places.truncatedPlaceName=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 3)] autorelease];

            NSString *postCode=[[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(selectStmt, 2)] autorelease];
            if([postCode isEqualToString:@"No PostCode"]){
                places.postCode=@" ";
            }
            else{
                places.postCode=[NSString stringWithFormat:@"%@",postCode];
            }
            
            			
			[placesArray addObject:places];
			
		}
		//AirportArray=resultArray;
		
		//[resultArray release];
		sqlite3_finalize(selectStmt);
		
	}
	[pool drain];
	//[airportName release];
}

- (IBAction) cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction) done:(id)sender
{
    
}

- (IBAction) currentLocationSelected:(id)sender
{
    NSString *fromAddress=nil;
    [Common setFromAddress:fromAddress];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
		return 1;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    if ([myParentIS isEqualToString:@"From Address"]) {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 44.0)];
    
    // create the button object
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    headerBtn.backgroundColor =  [UIColor blueColor];
    headerBtn.opaque = NO;
    headerBtn.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
    [headerBtn setTitle:@"   Current Location." forState:UIControlStateNormal];
    [headerBtn addTarget:self action:@selector(currentLocationSelected:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:headerBtn];
    
   
    return customView;
         }
    else{
        return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([myParentIS isEqualToString:@"From Address"]) {
    return 44.0;
    }
    else{
         return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//return (tableView==self.searchTableView)?self.placesArray.count:self.filteredListContent.count;
    NSLog(@"placeArray count is %d",[placesArray count]);
    if(self.placesArray.count>10){
        return (tableView==self.searchTableView)?10:self.filteredListContent.count;
    }
    
    
    if ([self.placeType isEqualToString:@"City"]) {
        NSLog(@"[filteredListContent count] is-- %d",[self.filteredListContent count]);
        return [filteredListContent count];
    }
    return (tableView==self.searchTableView)?self.placesArray.count:self.filteredListContent.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   // Places *places = [self.filteredListContent objectAtIndex:indexPath.row];
    if ([self.placeType isEqualToString:@"City"])
    {
        NSMutableString *addressName= [self.filteredListContent objectAtIndex:indexPath.row];
       // NSLog(@"addressName--- %@",addressName);
       
        [addressName replaceOccurrencesOfString:@"-" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
        
               
        

       // NSLog(@"addressName--- %@",addressName);
        cell.textLabel.text=[NSString stringWithFormat:@"%@",addressName];
    }
    else{
    Places *places = (self.searchTableView==tableView)?[self.placesArray objectAtIndex:indexPath.row] : [self.filteredListContent objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",places.placeName];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",places.placeId];
    }
   // [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

    return cell;
}
    


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UserJourney *journey =[[Journey searchedJourney] userJourney];
    NSMutableDictionary *placeDict=[[NSMutableDictionary alloc] init];
    if ([self.placeType isEqualToString:@"City"])
    {
        NSMutableString *addressName= [self.filteredListContent objectAtIndex:indexPath.row];
        NSLog(@"selected address--- %@",addressName);
                
        [addressName replaceOccurrencesOfString:@"-" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
       // NSLog(@"selected address--- %@",addressName);
        [addressName replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [addressName length])];
       // NSLog(@"selected address--- %@",addressName);
        
        NSArray *splitArray = [addressName componentsSeparatedByString:@","];
        NSString *placeName=@"";
        for (int i=1; i<= [splitArray count]-1; i++) {
           
                placeName=[NSString stringWithFormat:@"%@,%@",placeName,[splitArray objectAtIndex:i]];
                NSLog(@"placeName address--- %@",placeName);
                    }
       placeName = [placeName substringFromIndex:2];
        
      //  NSLog(@"selected address--- %@",addressName);
        //NSLog(@"placeName address--- %@",placeName);
        
        NSString *postCode=[splitArray objectAtIndex:0];
        
        [placeDict setObject:@"0" forKey:@"placeId"];
        [placeDict setObject:placeName forKey:@"placeName"];
        [placeDict setObject:postCode forKey:@"postCode"];
        [placeDict setObject: @"city" forKey:@"placeType"];
        [placeDict setObject:placeName forKey:@"truncatedPlaceName"];
        
        if ([myParentIS isEqualToString:@"From Address"])
            [Common truncatedPlaceNameAddress:placeDict];
        else
            [Common setToAddress:placeDict];
    }

    
    else
    {
    Places *places = (self.searchTableView==tableView)?[self.placesArray objectAtIndex:indexPath.row] : [self.filteredListContent objectAtIndex:indexPath.row];
   // 
    
    [placeDict setObject:places.placeId forKey:@"placeId"];
    [placeDict setObject:places.placeName forKey:@"placeName"];
    [placeDict setObject:places.postCode forKey:@"postCode"];
    [placeDict setObject: [self.placeType  lowercaseString] forKey:@"placeType"];
    [placeDict setObject:places.truncatedPlaceName forKey:@"truncatedPlaceName"];

    }
    if ([myParentIS isEqualToString:@"From Address"])
        [Common setFromAddress:placeDict];
    else
        [Common setToAddress:placeDict];


   [self.navigationController popToRootViewControllerAnimated:YES];
 
}

#pragma mark -
#pragma mark Content Filtering


-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"hi-- cancel button tapped");
    [self.searchTableView reloadData];
}


- (void)filterCityForSearchText:(NSString*)str{
    // for inCaseSensitive search
    str = [str uppercaseString];
    NSMutableArray *tempArray=[self.filteredListContent mutableCopy];
    NSLog(@"tempArray count is %d",[tempArray count]);
    [self.filteredListContent removeAllObjects];
	//arForSearch=[[NSMutableArray alloc] init];
	for (NSString *tempString in tempArray)
	{
        NSComparisonResult result = [tempString compare:str options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:tempString];
        }
		
    }
    NSLog(@"filteredListContent count is %d",[filteredListContent count]);
}



- (void)filterContentForSearchText:(NSString*)str{
    // for inCaseSensitive search
    str = [str uppercaseString];
    [self.filteredListContent removeAllObjects];
	//arForSearch=[[NSMutableArray alloc] init];
	for (Places *place in placesArray)
	{
        NSComparisonResult result = [place.placeName compare:str options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:place];
        }
		
    }
    NSLog(@"filteredListContent count is %d",[filteredListContent count]);
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"self.myParentIS --- %@",self.placeType );
    if ([self.placeType isEqualToString:@"City"]) {
        if ([searchString length]> 1)
        {
            self.searchedCityString=[NSString stringWithFormat:@"%@",searchString];
            NSLog(@"self.searchedCityString--  %@",self.searchedCityString);
            [NSThread detachNewThreadSelector:@selector(getCityAddresses) toTarget:self withObject:nil];
            
        }
        /*else if ([searchString length]> 2)
        {
               [self filterCityForSearchText:searchString];
        }*/
    }
    else{
        [self filterContentForSearchText:searchString];
    }
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void) showIndicator{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


-(void)getCityAddresses{
    //NSAutoreleasePool *authenticateActionPool=[[NSAutoreleasePool alloc] init];
    if(![UIApplication sharedApplication].networkActivityIndicatorVisible)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
    NSObject *obj=[[NSObject alloc]init];
    servicehelper.objEntity=obj;
    [obj release];
    NSString *supplierID;
    if ([[Common loggedInUser] suppID]==nil) {
        supplierID=@"228";
    }
    else{
        supplierID=[[Common loggedInUser] suppID];
    }
    NSLog(@"supplierid is------%@",supplierID);

    
        NSArray *sdkeys = [NSArray arrayWithObjects:@"postcde", @"sup_id",nil];
    NSLog(@"self.searchedCityString--  %@",self.searchedCityString);
    NSArray *sdobjects = [NSArray arrayWithObjects:self.searchedCityString,supplierID, nil];
        NSDictionary *sdparams = [NSDictionary dictionaryWithObjects:sdobjects forKeys:sdkeys];
        
        //NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@customer/customerauth",[Common webserviceURL]] pms:sdparams];
        
        NSString *URL=[NSString stringWithFormat:@"%@search/autopostcode",[Common webserviceURL]];
        NSLog(@"service method get called");
        NSArray *resultArray=[servicehelper callWebService:URL pms:sdparams];
    NSMutableDictionary *userDict=[resultArray objectAtIndex:0];
    [self.filteredListContent removeAllObjects];
    if ([userDict objectForKey:@"success"]) {
         
        self.filteredListContent=[userDict objectForKey:@"city"];
        
        
        //[self filterContentForSearchText:searchString];
    }
    NSLog(@"filteredListContent count is %d",[filteredListContent count]);
    //[authenticateActionPool release];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.searchTableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
	 Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
	 */
	
	//self.searchTableView.tableHeaderView = mySearchBar;
		[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
	//self.searchTableView.tableHeaderView = nil;
	//self.imgView.hidden=NO;
	//self.searchTableView.frame=CGRectMake(0, 20, 320, 350);
	//self.searchTableView.tableHeaderView = nil;
	//[self.searchTableView setContentOffset:CGPointMake(0,44.f) animated:YES];
	//[self.searchTableView setContentOffset:CGPointMake(0,0.f) animated:YES];
}

#pragma mark -

-(void)searchBar:(id)sender{
	
	[searchDisplayController setActive:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem=nil;
}

-(void) dealloc{
    [searchTableView release];
    [searchDisplayController release];
    [placesArray release];
    [mySearchBar release];
    [listContent release];
    [filteredListContent release];
    [myParentIS release];
    [placeType release];
    [searchedCityString release];

    [super dealloc];
}

@end