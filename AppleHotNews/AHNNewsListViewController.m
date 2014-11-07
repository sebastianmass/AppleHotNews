//
//  AHNNewsListViewController.m
//  AppleHotNews
//
//  Created by Seva Kukhelny on 24.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

#import "AHNNewsListViewController.h"
#import "AHNNewsViewController.h"
#import "AHNNewsParser.h"
#import "AHNNews.h"

@interface AHNNewsListViewController ()
@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, retain) AHNNewsParser *newsParser;
@end

@implementation AHNNewsListViewController
@synthesize newsArray;
@synthesize newsParser;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Apple Hot News", @"Main title");
    
    self.newsParser = [[[AHNNewsParser alloc] initWithDelegate:self] autorelease];
    
    [self loadNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [newsParser release];
    [newsArray release];
    [super dealloc];
}

#pragma mark - Server collaboration methods

- (void)loadNews
{
    NSString *newsURLString = @"http://images.apple.com/main/rss/hotnews/hotnews.rss";
    
    NSURLRequest *newsURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:newsURLString]];
    
    [NSURLConnection sendAsynchronousRequest:newsURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil)
         {
             [self handleError:error];
         }
         else
         {
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             
             if ((([httpResponse statusCode]/100) == 2) && [[response MIMEType] isEqual:@"application/rss+xml"])
             {
                 [self.newsParser parseData:data];
             }
             else
             {
                 NSString *errorString = NSLocalizedString(@"HTTP Error", @"Error HTTP message");
                 NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorString};
                 NSError *reportError = [NSError errorWithDomain:@"HTTP"
                                                            code:[httpResponse statusCode]
                                                        userInfo:userInfo];
                 [self handleError:reportError];
             }
         }
     }];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    NSString *alertTitle = NSLocalizedString(@"Error", @"Error title");
    NSString *okTitle = NSLocalizedString(@"OK", @"OK Button");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:errorMessage delegate:nil cancelButtonTitle:okTitle otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Parser callback handle

- (void)handleNews:(NSArray *)news
{
    self.newsArray = news;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AHNNews *news = self.newsArray[indexPath.row];

    NSString *titleCellText = news.title;
    NSString *descriptionCellText = news.description;
    
    UIFont *titleCellFont = [UIFont fontWithName:@"Helvetica" size:18.0];
    UIFont *descriptionCellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    CGSize constraintSize = CGSizeMake(self.view.bounds.size.width - 50.0f, MAXFLOAT);
    
    CGSize titleLabelSize = [titleCellText sizeWithFont:titleCellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize descriptionLabelSize = [descriptionCellText sizeWithFont:descriptionCellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

    return titleLabelSize.height + descriptionLabelSize.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"NewsCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    
    AHNNews *news = self.newsArray[indexPath.row];
    
    [cell.textLabel setNumberOfLines:0];
    
    [cell.detailTextLabel setNumberOfLines:0];
    
    cell.textLabel.text = news.title;
    
    cell.detailTextLabel.text = news.description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AHNNews *news = self.newsArray[indexPath.row];
    
    AHNNewsViewController *newsVC = [[AHNNewsViewController alloc] initWithNews:news];
    
    [self.navigationController pushViewController:newsVC animated:YES];
    
    [newsVC release];
}

@end
