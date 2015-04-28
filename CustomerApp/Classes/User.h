//
//  User.h
//  WiseCabs
//
//  Created by Nagraj Gopalakrishnan on 19/12/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *FirstName;
	NSString *LastName;
	NSString *Email;
	NSString *ID;
	NSString *MobileNumber;
    NSString *suppID;
    NSString *userName;
    NSString *password;
}
@property(nonatomic,retain) NSString *suppID;
@property(nonatomic,retain) NSString *FirstName;
@property(nonatomic,retain)NSString *LastName;
@property(nonatomic,retain)NSString *Email;
@property(nonatomic,retain)NSString *ID;
@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain)NSString *password;
@property(nonatomic,retain)NSString *MobileNumber;
@end
