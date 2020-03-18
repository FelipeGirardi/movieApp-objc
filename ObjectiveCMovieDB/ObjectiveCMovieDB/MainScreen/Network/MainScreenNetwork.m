//
//  MainScreenNetwork.m
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 17/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainScreenNetwork.h"
#import "MoviesList.h"


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


- (void) getDataFrom: (NSString *) url completion: (void(^) (NSMutableArray * moviesList)) callback {
    
    NSMutableArray *popularMoviesList = [NSMutableArray array];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL: [NSURL URLWithString: url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler: ^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError * error) {
        if (error == nil) {
            
            NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            
            NSArray *moviesDataArray = [jsonData objectForKey: @"results"];
            
            for (NSDictionary * movie in moviesDataArray) {
                
                MainScreenMovie *popularMovie = [[MainScreenMovie alloc] initMovie: [movie objectForKey:@"title"]
                                                                          overview: [movie objectForKey:@"overview"]
                                                                        posterPath: [movie objectForKey:@"poster_path"]
                                                                       voteAverage: [movie objectForKey:@"vote_average"]];
                
                [popularMoviesList addObject: popularMovie];
            }
            
            callback(popularMoviesList);
        }
        
    }] resume];
    
    
}

@end
