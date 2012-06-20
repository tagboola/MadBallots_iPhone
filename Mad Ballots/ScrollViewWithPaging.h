//
//  ScrollViewWithPaging.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollViewWithPagingDelegate <NSObject>
-(void)nextPage;
-(void)firstPage;
-(void)changePage:(int)page;
@end

@interface ScrollViewWithPaging : UIViewController <UIScrollViewDelegate,ScrollViewWithPagingDelegate>{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UILabel *titleLabel;
    NSMutableArray *viewControllers;
    BOOL pageControlBeingUsed;
}

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIPageControl *pageControl;

-(IBAction)changePage;

@end


