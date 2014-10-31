//
//  AHNNewsParser.m
//  AppleHotNews
//
//  Created by Seva Kukhelny on 24.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

static NSString * const kEntryElementName = @"item";
static NSString * const kTitleElementName = @"title";
static NSString * const kDescriptionElementName = @"description";
static NSString * const kLinkElementName = @"link";

#import "AHNNewsParser.h"
#import "AHNNews.h"

@interface AHNNewsParser () <NSXMLParserDelegate>
@property (nonatomic, assign) id <NewsTableProtocol> delegate;
@property (nonatomic, retain) AHNNews *currentNews;
@property (nonatomic, retain) NSMutableString *currentStringData;
@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *newsArray;
@end

@implementation AHNNewsParser
{
    BOOL _handleNode;
}

@synthesize delegate;
@synthesize currentNews;
@synthesize newsArray;
@synthesize currentStringData;
@synthesize parser;

- (id)initWithDelegate:(id)aDelegate
{
    if (self = [super init])
    {
        self.delegate = aDelegate;
        self.newsArray = [NSMutableArray array];
        self.currentStringData = [NSMutableString string];
    }
    return self;
}

- (void)dealloc
{
    [newsArray release];
    [currentNews release];
    [currentStringData release];
    [parser release];
    [super dealloc];
}

- (void)parseData:(NSData *)data
{
    NSXMLParser *aParser = [[NSXMLParser alloc] initWithData:data];
    
    [aParser setDelegate:self];
    
    self.parser = aParser;
    
    [aParser release];
    
    [self.parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kEntryElementName])
    {
        AHNNews *news = [[AHNNews alloc] init];
        self.currentNews = news;
        [news release];
    }
    else if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kDescriptionElementName] || [elementName isEqualToString:kLinkElementName])
    {
        _handleNode = YES;
        self.currentStringData = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:kEntryElementName])
    {
        [self.newsArray addObject:self.currentNews];
    }
    else if ([elementName isEqualToString:kTitleElementName])
    {
        self.currentNews.title = self.currentStringData;
    }
    else if ([elementName isEqualToString:kDescriptionElementName])
    {
        self.currentNews.description = self.currentStringData;
    }
    else if ([elementName isEqualToString:kLinkElementName])
    {
        self.currentNews.urlToNews = self.currentStringData;
    }
    
    _handleNode = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_handleNode)
    {
        [self.currentStringData appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate handleNews:self.newsArray];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate handleError:parseError];
}

@end
