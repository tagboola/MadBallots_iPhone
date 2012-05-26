//
//  MBAuthenticationCredentials.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKObjectMapping;

@interface MBAuthenticationCredentials : NSObject{
    NSString *token;
    NSString *secret;
    NSString *secretConfirmation;
}

@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) NSString *secret;
@property (nonatomic,retain) NSString *secretConfirmation;



+(RKObjectMapping*)getObjectMapping;


@end
