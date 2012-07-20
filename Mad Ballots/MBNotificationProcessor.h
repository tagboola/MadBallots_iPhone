//
//  MBNotificationProcessor.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNotificationProcessor : NSObject <UIAlertViewDelegate> {
    NSDictionary *remoteNotification;
}
@property (nonatomic,retain) NSDictionary *remoteNotification;

-(id)initWithNotification:(NSDictionary *)notification;
-(void)processNotificationWithDialog:(BOOL)showDialog;

@end
