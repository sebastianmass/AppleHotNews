//
//  AHNNewsViewController.m
//  AppleHotNews
//
//  Created by Seva Kukhelny on 24.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

#define kTitleSize 40

#import "AHNNewsViewController.h"
#import "AHNWebViewNewsViewController.h"
#import "AHNNews.h"

@interface AHNNewsViewController ()
@property (nonatomic, retain) AHNNews *currentNews;
@end

@implementation AHNNewsViewController
@synthesize currentNews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNews:(AHNNews *)news
{
    if (self = [super init])
    {
        self.currentNews = news;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_OS_7_OR_LATER)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = NSLocalizedString(@"News", @"News title");
    
    UILabel *aTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kTitleSize)];
    
    [aTitleLabel setTextColor:[UIColor blackColor]];
    
    [aTitleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [aTitleLabel setBackgroundColor:[UIColor whiteColor]];
    
    [aTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [aTitleLabel setText:self.currentNews.title];
    
    [self.view addSubview:aTitleLabel];
    
    [aTitleLabel release];
    
    UITextView *aNewsTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, kTitleSize, self.view.frame.size.width, self.view.frame.size.height - kTitleSize)];
    
    [aNewsTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [aNewsTextView setText:self.currentNews.description];
    
    [self.view addSubview:aNewsTextView];
    
    [aNewsTextView release];
    
    UIBarButtonItem *aRightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Open web page", @"Open web page") style:UIBarButtonItemStylePlain target:self action:@selector(openWebPageButtonDidPressed)];
    
    [self.navigationItem setRightBarButtonItem:aRightBarItem];
    
    [aRightBarItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [currentNews release];
    [super dealloc];
}

- (void)openWebPageButtonDidPressed
{
    AHNWebViewNewsViewController *webVC = [[AHNWebViewNewsViewController alloc] initWithURL:self.currentNews.urlToNews];

    [self.navigationController pushViewController:webVC animated:YES];
    
    [webVC release];
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
