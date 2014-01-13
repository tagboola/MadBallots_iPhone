//
//  MBWebAppViewController.m
//  Mad Ballots
//
//  Created by Jeremy Clark on 1/2/14.
//
//

#import "AppDelegate.h"
#import "MBWebAppViewController.h"

@interface MBWebAppViewController ()

@end

@implementation MBWebAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [(UIWebView *)[self view] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUI{
    
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]];
    [(UIWebView*)[self view] loadRequest:req];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"Failed Loading");
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"Should Start Loading");
    return true;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"Finish Loading");
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    NSLog(@"%@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);
    NSLog(@"%i",[(NSHTTPURLResponse*)resp.response statusCode]);

    NSString * urlRelativePath = webView.request.URL.relativePath;
    if ([urlRelativePath isEqualToString:LOGOUT_RELATIVE_URL]){
        [[AppDelegate getInstance] processLogout];
    }
    
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Start Loading");
    
}


@end
