//
//  AHNNewsParser.h
//  AppleHotNews
//
//  Created by Seva Kukhelny on 24.10.14.
//  Copyright (c) 2014 Seva. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsTableProtocol <NSObject>
- (void)handleNews:(NSArray *)news;
- (void)handleError:(NSError *)error;
@end

@interface AHNNewsParser : NSObject
- (id)initWithDelegate:(id)aDelegate;
- (void)parseData:(NSData *)data;
@end
