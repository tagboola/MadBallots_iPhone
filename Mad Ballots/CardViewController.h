//
//  CardViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewWithPaging.h"

@interface CardViewController : ScrollViewWithPaging {
    NSArray *dataArray;

}

@property (nonatomic,retain) NSArray *dataArray;



@end
