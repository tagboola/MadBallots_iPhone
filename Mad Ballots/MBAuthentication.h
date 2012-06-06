//
//  MBAuthentication.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBAuthenticationInfo;
@class MBAuthenticationCredentials;
@class RKObjectMapping;
@class Facebook;

@interface MBAuthentication : NSObject{
    NSString *provider;
    NSString *uid;
    MBAuthenticationInfo *info;
    MBAuthenticationCredentials *credentials;
}

@property (nonatomic,retain) NSString *provider;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) MBAuthenticationInfo *info;
@property (nonatomic,retain) MBAuthenticationCredentials *credentials;

+(RKObjectMapping*)getObjectMapping;

@end
