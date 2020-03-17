//
//  MainScreenNetwork.m
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 17/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainScreenNetwork.h"



@interface MainScreenNetwork ()

@end

@implementation MainScreenNetwork


- (id) initNetwork {
    self = [super init];
    
    return self;
}

+ (instancetype) instantiateNetwork {
    
    MainScreenNetwork *network = [[MainScreenNetwork alloc] initNetwork];
    
    return network;
}


- (NSString *) getDataFrom: (NSString *) url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL: [NSURL URLWithString: url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler: ^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError * error) {
        if (error == nil) {
            printf("a");
        }
        
    }] resume];
    
    return @"a";
}

@end
