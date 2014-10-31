//
//  AHNWebViewNewsViewController.m
//  AppleHotNews
//
//  Created by Seva Kukhelny on 31.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

#import "AHNWebViewNewsViewController.h"

@interface AHNWebViewNewsViewController ()
@property (nonatomic, retain) NSString *url;
@end

@implementation AHNWebViewNewsViewController
@synthesize url;

- (id)initWithURL:(NSString *)aUrl
{
    if (self = [super init])
    {
        self.url = aUrl;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_OS_7_OR_LATER)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = NSLocalizedString(@"Web", @"Web title");
    
    NSURL *aUrl = [NSURL URLWithString:self.url];
    
    NSURLRequest *aUrlRequest = [NSURLRequest requestWithURL:aUrl];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    webView.scalesPageToFit = YES;
    
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [webView loadRequest:aUrlRequest];
    
    [self.view addSubview:webView];
    
    [webView release];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [url release];
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
