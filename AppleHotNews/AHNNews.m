//
//  AHNNews.m
//  AppleHotNews
//
//  Created by Seva Kukhelny on 24.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

#import "AHNNews.h"

@implementation AHNNews
@synthesize title;
@synthesize description;
@synthesize urlToNews;

- (void)dealloc
{
    [title release];
    [description release];
    [urlToNews release];
    [super dealloc];
}

@end
