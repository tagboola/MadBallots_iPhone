//
//  MBAuthenticationInfo.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKObjectMapping;

@interface MBAuthenticationInfo : NSObject{
    NSString *name;
    NSString *email;
    NSString *nickname;
    NSString *firstName;
    NSString *lastName;
    NSString *location;
    NSString *description;
    NSString *phone;
    NSDictionary *urls;
    
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSDictionary *urls;

+(RKObjectMapping*)getObjectMapping;

@end
