//
//  MovieDetailsAPIRequest.m
//  ObjectiveCMovieDB
//
//  Created by Felipe Girardi on 18/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieDetailsAPIRequest.h"
#import "MovieDetailsModel.h"

@interface MovieDetailsAPIRequest ()

@end

@implementation MovieDetailsAPIRequest

// Method to get movie details from API using the movie's ID

+ (void) fetchMovieByID: (int)movieID completeBlock:(void(^)(QTMovieDetails *)) completeBlock {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d?api_key=fb61737ab2cdee1c07a947778f249e7d&language=en-US", movieID];
            [request setURL:[NSURL URLWithString: urlString]];
            [request setHTTPMethod:@"GET"];
        
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSError *error1;
                QTMovieDetails *movieDetails = [QTMovieDetails fromData:data error:&error1];
                
                //NSLog(@"Request reply: %@", movieDetails);
                
                if(completeBlock)
                    completeBlock(movieDetails);
                
            }] resume];
}

@end
