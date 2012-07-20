//
//  MBNotificationActionHandler.h
//  Mad Ballots
//
//  Created by Jeremy Clark on 7/15/12.
//  Copyright (c) 2012 Uppadada Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@protocol MBNotificationActionHandler <NSObject>

@property (nonatomic, retain) NSArray * actionObjects;

-(id)initWithActionObjects:(NSArray *)actionObjectArray;
-(void)execute;

@end
