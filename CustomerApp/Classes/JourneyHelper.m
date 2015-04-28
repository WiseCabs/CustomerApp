//
//  JourneyHelper.m
//  WiseCabs
//
//  Created by Nagraj G on 13/12/11.
//  Copyright 2011 Apppli Consulting Pvt Ltd. All rights reserved.
//

#import "JourneyHelper.h"
#import "Journey.h"
#import	"Common.h"
#import "WebServiceHelper.h"
#import "SQLHelper.h"

@implementation JourneyHelper
@synthesize resultArray;

-(NSArray *)getMyBookings{
	if ([Common isNetworkExist]>0)
	{	
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		Journey *jny=[[Journey alloc]init];
		servicehelper.objEntity=jny;
		//NSInteger userid=91;
		NSInteger userID=[[[Common loggedInUser] ID] intValue];
		NSArray *myBookingsKeys = [NSArray arrayWithObjects:@"cid",@"sid",nil];
		NSArray *myBookingsObjects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",userID],[NSString stringWithFormat:@"%@", [[Common loggedInUser] suppID]], nil];
		NSDictionary *jmyBookingsParams = [NSDictionary dictionaryWithObjects:myBookingsObjects forKeys:myBookingsKeys];
		NSString *myBookingsURL=[NSString stringWithFormat:@"%@customer/customerjourney",[Common webserviceURL]];
		self.resultArray=[servicehelper callWebService:myBookingsURL pms:jmyBookingsParams];
		[jny release];
		[servicehelper release];

		return self.resultArray;
		
	}
	else {
		return nil;
		//[Common showNetwokAlert];
	}
	
}

-(NSArray*)getJourneySupplier:(NSInteger)journeyID{
	//TODO get supplier by journeyID, return nil if no supplier assigned yet
	if ([Common isNetworkExist]>0)
	{
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		SupplierDetails *suppDetails=[[SupplierDetails alloc]init];
		servicehelper.objEntity=suppDetails;
		[suppDetails release];
		
		self.resultArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/supplierallocation/journeyId/%d",[Common webserviceURL],journeyID] pms:nil];
		[servicehelper release];
		return self.resultArray;
	}else {
		[Common showNetwokAlert];
		return nil;
	}

}
-(NSArray*)getCoPassenger:(NSInteger)journeyID{
	if ([Common isNetworkExist]>0)
	{
		
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		UserJourney *userJny=[[UserJourney alloc]init];
		servicehelper.objEntity=userJny;
		[userJny release];
	
		self.resultArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/allocation/journeyId/%d",[Common webserviceURL],journeyID] pms:nil];
		[servicehelper release];
		return self.resultArray;
		
	}else {
		[Common showNetwokAlert];
		return nil;
	}
	
}

-(BOOL)cancelJourney:(NSInteger)journeyID {
	
	BOOL flag=NO;
	if ([Common isNetworkExist]>0)
	{
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		servicehelper.objEntity=[[[NSObject alloc]init]  autorelease];
		NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@customer/canceljourney/journeyId/%d",[Common webserviceURL],journeyID] pms:nil];
		[servicehelper release];
		if (result!=nil) {
			flag= YES;
		}
		else {
			flag= NO;
		}
		
	}else {
		[Common showNetwokAlert];
		flag= NO;
	}
	return flag;
}


-(BOOL)convertToDedicatedJourney:(NSInteger)journeyID {

	BOOL flag=NO;
	if ([Common isNetworkExist]>0)
	{
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		servicehelper.objEntity=[[[NSObject alloc]init]  autorelease];
		NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/dedicatedtype/journeyId/%d",[Common webserviceURL],journeyID] pms:nil];

		[servicehelper release];
		if (result!=nil) {
			flag= YES;
		}
		else {
			flag= NO;
		}

	}else {
		[Common showNetwokAlert];
		flag= NO;
	}
	return flag;
}

-(BOOL)confirmJourney:(NSString*)journeyID firstName:(NSString*)fname lastName:(NSString*)lname userEmail:(NSString*)email userMobile:(NSString*)mobile supplierID:(NSString*)suppID distance:(NSString*)distance fare:(NSString*)fare journeyDict:(NSDictionary*)jnyDict
{
	BOOL flag=NO;
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	if ([Common isNetworkExist]>0)
	{
		
		servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
        
                
        NSString *fromPlaceKeyName;
        NSString *toPlaceKeyName;
        
        if ([[jnyDict objectForKey:@"srcFrom"] isEqualToString:@"city" ]) {
            fromPlaceKeyName=@"srcStreetName";
        }
        else{
            fromPlaceKeyName=@"src";
        }
        
        if ([[jnyDict objectForKey:@"dstFrom"] isEqualToString:@"city"] ) {
            toPlaceKeyName=@"dstStreetName";
        }
        else{
            toPlaceKeyName=@"dst";
        }
      
        
        
		NSArray *keys = [NSArray arrayWithObjects:@"email",@"mobile_no",@"first_name",@"last_name",@"supid",@"srcFrom",@"dstFrom",@"srcPostcode",@"dstPostcode",@"vehicleType",fromPlaceKeyName,toPlaceKeyName,@"srcId",@"dstId",@"distance",@"fare",@"time",@"noOfBag",@"noOfPassenger",@"date",nil];
        
        NSArray *sdObjects=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", email],[NSString stringWithFormat:@"%@", mobile],[NSString stringWithFormat:@"%@", fname],[NSString stringWithFormat:@"%@", lname],[NSString stringWithFormat:@"%@", suppID],[[jnyDict objectForKey:@"srcFrom"] lowercaseString],[[jnyDict objectForKey:@"dstFrom"] lowercaseString] ,[jnyDict objectForKey:@"srcPostcode"],[jnyDict objectForKey:@"dstPostcode"],[jnyDict objectForKey:@"vehicleType"],[jnyDict objectForKey:fromPlaceKeyName],[jnyDict objectForKey:toPlaceKeyName],[jnyDict objectForKey:@"srcId"],[jnyDict objectForKey:@"dstId"],distance,fare,[jnyDict objectForKey:@"time"],[jnyDict objectForKey:@"noOfBag"],[jnyDict objectForKey:@"noOfPassenger"],[jnyDict objectForKey:@"date"],nil];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjects:sdObjects forKeys:keys];
		
		NSArray *confirmArray=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/savecustappjourney",[Common webserviceURL]] pms:params];
		
        NSDictionary* confirmJnyResult= [confirmArray objectAtIndex:0];
		if ([[confirmJnyResult objectForKey:@"success"] isEqualToString:@"true"] ) {
            
             [Common setSearchedJourneyID:[confirmJnyResult objectForKey:@"joid"]];
			
            NSDictionary* customerDict= [confirmJnyResult objectForKey:@"customer"];
			NSLog(@"data:%@",customerDict);
			//NSString *abc=[result objectForKey:@"isParked"];
			//NSString *abc = [NSString stringWithFormat:@"%@", [result valueForKey:@"isParked"]];
			
			//NSDictionary *dict = [result objectAtIndex:0];
			
			
			//[Common setLoggedInUser:nil];
			//sucess
           
			User *user=[[User alloc] init];
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"First_Name"] && [customerDict objectForKey:@"First_Name"]!=nil &&   [customerDict objectForKey:@"First_Name"]!=nil && [[[customerDict objectForKey:@"First_Name"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.FirstName=[customerDict objectForKey:@"First_Name"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"Last_Name"] && [customerDict objectForKey:@"Last_Name"]!=nil &&   [customerDict objectForKey:@"Last_Name"]!=nil && [[[customerDict objectForKey:@"Last_Name"]stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.LastName=[customerDict objectForKey:@"Last_Name"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"UD_ID"] && [customerDict objectForKey:@"UD_ID"]!=nil &&   [customerDict objectForKey:@"UD_ID"]!=nil && [[[customerDict objectForKey:@"UD_ID"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.ID=[customerDict objectForKey:@"UD_ID"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"Email_Id"] && [customerDict objectForKey:@"Email_Id"]!=nil &&   [customerDict objectForKey:@"Email_Id"]!=nil && [[[customerDict objectForKey:@"Email_Id"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.Email=[customerDict objectForKey:@"Email_Id"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"Contact_Number"] && [customerDict objectForKey:@"Contact_Number"]!=nil &&   [customerDict objectForKey:@"Contact_Number"]!=nil && [[[customerDict objectForKey:@"Contact_Number"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.MobileNumber=[customerDict objectForKey:@"Contact_Number"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"UD_SD_ID"] && [customerDict objectForKey:@"UD_SD_ID"]!=nil &&   [customerDict objectForKey:@"UD_SD_ID"]!=nil && [[[customerDict objectForKey:@"UD_SD_ID"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.suppID=[customerDict objectForKey:@"UD_SD_ID"];
            }
            
            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"UD_Username"] && [customerDict objectForKey:@"UD_Username"]!=nil &&   [customerDict objectForKey:@"UD_Username"]!=nil && [[[customerDict objectForKey:@"UD_Username"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.userName=[customerDict objectForKey:@"UD_Username"];
            }

            if ((NSString *)[NSNull null]!=[customerDict objectForKey:@"UD_Password"] && [customerDict objectForKey:@"UD_Password"]!=nil &&   [customerDict objectForKey:@"UD_Password"]!=nil && [[[customerDict objectForKey:@"UD_Password"] stringByReplacingOccurrencesOfString:@" " withString:@"" ] length]>0)
            {
                user.password=[customerDict objectForKey:@"UD_Password"];
            }
			
			
			
			
            
			flag= YES;
            SQLHelper *sqlHelper= [[SQLHelper alloc] init];
            
            //if ([sqlHelper isSavedUser]) {
            NSArray *updateArray=[NSArray arrayWithObjects:user.ID,user.FirstName,user.LastName,user.password,user.Email,user.MobileNumber,user.suppID,user.userName,nil];
            //NSArray *updateArraykeys=[NSArray arrayWithObjects:@"CM_ID",@"CM_First_name",@"CM_Last_Name",@"CM_Mobile_Number",@"CM_Email",nil];
            NSArray *updateArraykeys=[NSArray arrayWithObjects:@"UD_ID",@"First_Name",@"Last_Name",@"UD_Password",@"Email_Id",@"MobileNo",@"suppID",@"UserName",nil];
            NSDictionary *updateUserDictionary=[NSDictionary  dictionaryWithObjects:updateArray forKeys:updateArraykeys];
            [sqlHelper insertNewUserDetails:updateUserDictionary];
            [sqlHelper release];
			
			[Common setLoggedInUser:user];
		}
		else {
			flag= NO;
		}
		
	}else {
		[Common showNetwokAlert];
		flag= NO;
	}
	[servicehelper release];
	return flag;
}


-(BOOL)confirmParkedJourney:(NSInteger)journeyID  userId:(NSString*)uid
{
	BOOL flag=NO;
	WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
	if ([Common isNetworkExist]>0)
	{
		
		servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
		NSArray *keys = [NSArray arrayWithObjects:@"journeyId",@"uid",nil];
		NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", journeyID],uid, nil];
		NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/parkedconfirm",[Common webserviceURL]] pms:params];
		
		[servicehelper release];
		if (result!=nil) {
			flag= YES;
		}
		else {
			flag= NO;
		}
		
	}else {
		[Common showNetwokAlert];
		flag= NO;
	}
	return flag;
}

-(BOOL)markAsFavourite:(NSString *)journeyID{
	
	BOOL flag=NO;
	if ([Common isNetworkExist]>0)
	{
		WebServiceHelper *servicehelper=[[WebServiceHelper alloc] init];
		servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
		NSArray *keys = [NSArray arrayWithObjects:@"journeyId",@"uid",nil];
		NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", journeyID],[[Common loggedInUser] ID], nil];
		NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/fav",[Common webserviceURL]] pms:params];
		[servicehelper release];
		if (result!=nil) {
			flag= YES;
		}
		else {
			flag= NO;
		}
		
	}else {
		[Common showNetwokAlert];
		flag= NO;
	}
	return flag;
}



-(NSArray*)addSearchedJourney:(UserJourney*)searchedJourney{

}

    

-(NSInteger)addJourney:(UserJourney*)searchedJourney{
    
    //JO_id   is journey id....
	NSInteger journeyID=0;
	if ([Common isNetworkExist]>0)
	{
		WebServiceHelper *servicehelper=[[[WebServiceHelper alloc] init] autorelease];
		servicehelper.objEntity=[[[NSObject alloc]init] autorelease];
		NSString *journeyType=[[searchedJourney JourneyType] lowercaseString];
		//NSString *dateString = [[searchedJourney JourneyDate] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//NSString *timeString = [[searchedJourney JourneyTime] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSLog(@"date:%@, time:%@",searchedJourney.JourneyDate,searchedJourney.JourneyTime);
		NSString *FromLocationId;
		NSString *ToLocationId;
		NSLog(@"%@",[searchedJourney IsFromAirport]);
		//Setting values for Airport Search
		if ([[searchedJourney IsFromAirport]isEqualToString:@"true"])
		{
			[searchedJourney FromAddress].LocalityName=@"";
			[searchedJourney FromAddress].LocalityId=@"-1";
			[searchedJourney FromAddress].PostalCode=@"";
			[searchedJourney FromAddress].HouseNumber=@"";
			[searchedJourney FromAddress].StreetNumber=@"";
			FromLocationId=@"from_airport_id";
					
		}
		else {
				FromLocationId=@"from_location";
			 }

		if ([[searchedJourney IsToAirport]isEqualToString:@"true"])
		{
			[searchedJourney ToAddress].LocalityName=@"";
			[searchedJourney ToAddress].LocalityId=@"-1";
			[searchedJourney ToAddress].PostalCode=@"";
		    [searchedJourney ToAddress].HouseNumber=@"";
			[searchedJourney ToAddress].StreetNumber=@"";
			ToLocationId=@"to_airport_id";
		}
		else {
			ToLocationId=@"to_location";
		}
        
        
		
		NSLog(@"[journey FromAddress].LocationId=%@",[searchedJourney FromAddress].LocationId);
		
		NSArray *keys = [NSArray arrayWithObjects:@"date",@"bags_no",@"from_house_no",@"from_locality",[NSString stringWithFormat:@"%@", FromLocationId],@"from_postcode",@"from_street_no",@"gender",@"journey_time",@"passengers_no",@"shared",@"to_house_no",@"to_locality",[NSString stringWithFormat:@"%@", ToLocationId],@"to_postcode",@"to_street_no",@"from_airport",@"to_airport",nil];
		//NSArray *keys = [NSArray arrayWithObjects:@"date",@"bags_no",@"from_house_no",@"from_locality",@"from_airport_id",@"from_postcode",@"from_street_no",@"gender",@"journey_time",@"passengers_no",@"shared",@"to_house_no",@"to_locality",@"to_airport_id",@"to_postcode",@"to_street_no",@"from_airport",@"to_airport",nil];
		//NSLog(@"all keys %@",keys);
		NSArray *objects = [NSArray arrayWithObjects:searchedJourney.JourneyDate,[NSString stringWithFormat:@"%d", searchedJourney.NumberOfBags],[searchedJourney FromAddress].HouseNumber,[searchedJourney FromAddress].LocalityId,[searchedJourney FromAddress].LocationId,[searchedJourney FromAddress].PostalCode,@"",
							@"",searchedJourney.JourneyTime,[NSString stringWithFormat:@"%d",searchedJourney.NumberOfPassenger],journeyType,[searchedJourney ToAddress].HouseNumber,[searchedJourney ToAddress].LocalityId,[searchedJourney ToAddress].LocationId,[searchedJourney ToAddress].PostalCode,@"",searchedJourney.IsFromAirport,searchedJourney.IsToAirport,nil];
		//NSLog(@"all keys %@",objects);
		NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		NSLog(@"all keys %@",params);
		
        
        NSArray *result=[servicehelper callWebService:[NSString stringWithFormat:@"%@search/addairportjourney",[Common webserviceURL]] pms:params];
		//[keys release];
		//[objects release];
		//[params release];
		//[servicehelper release];
		if (result!=nil) {
			journeyID=[[[result objectAtIndex:0] objectForKey:@"journeyId"] intValue];
		}
		else {
			journeyID=0;
		}
		
	}else {
		[Common showNetwokAlert];
		journeyID=0;
	}
	return journeyID;
}
-(void)dealloc{
	[resultArray release];
	[super dealloc];
}
@end
