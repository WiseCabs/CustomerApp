//
//  WebServiceHelper.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
//

#import "WebServiceHelper.h"
#import "JSONParser.h"

@implementation WebServiceHelper

@synthesize objEntity,resultArray;

/*- (WebServiceHelper *) initWebServerHelper{
	
	[super init];
	self.objEntity = [[NSObject alloc] init];
	return self;
}
*/
-(NSArray *) callWebService: (NSString *)webServiceURL pms:(NSDictionary *)params{

	NSMutableURLRequest *request = [self getWebServiceURL:webServiceURL pms:params];
	NSLog(@"%@",request);
	NSLog(@"webservice data:%@",request);
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
      NSLog(@" data is:-%@",data);
    NSLog(@" webServiceURL is:-%@",webServiceURL);
	//NSLog([NSString stringWithFormat:@"data is:-%@",data]);
    if([data length]>0)
	{
	  JSONParser *jsonParser = [[JSONParser alloc] init];
      jsonParser.objEntity = self.objEntity;
	//return array parsed by xml parser.
        
        if ([webServiceURL rangeOfString:@"maps/api/geocode/jso"].location == NSNotFound) {
            self.resultArray=[jsonParser getParsedEntities:data];
        } else {
            self.resultArray=[jsonParser getUserLocationParsedEntities:data];
        }      
	  
	 // [self.objEntity release];
	  [jsonParser release];
	}else {
		self.resultArray=nil;
	}
	[data release];
	return self.resultArray;
	
}

-(NSMutableURLRequest *) getWebServiceURL: (NSString *)webServiceURL pms:(NSDictionary *)params{
	 NSString *post=@"";
	 NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	 [request setURL:[NSURL URLWithString:webServiceURL]];
	 [request setHTTPMethod:@"POST"];
		
    for (id key in params) {
        NSLog(@"key: %@, value: %@ \n", key, [params objectForKey:key]);
    }
    
	for (NSString *key in params)
	{
		NSString *value = [params objectForKey:key];
		post = [post stringByAppendingString:@"&"];
		post = [post stringByAppendingString:key];
		post = [post stringByAppendingString:@"="];
		post = [post stringByAppendingString:value];
	}
	NSLog(@"post is %@",post);

	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	return request;
}

-(void) dealloc{
	[resultArray release];
	[objEntity release];
	[super dealloc];
}

@end
