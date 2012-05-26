//
//  MBPlayerSession.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface MBPlayerSession : NSObject{
    NSString *persistenceToken;
}

@property (nonatomic,retain) NSString *persistenceToken;

+(RKObjectMapping*)getObjectMapping;

@end

