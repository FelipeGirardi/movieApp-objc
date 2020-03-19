//
//  PopularMovie.m
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 18/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoviesList.h"

@implementation MainScreenMovie

-(instancetype) initMovie: (NSString *) title movieId: (NSNumber *) currentMovieID overview: (NSString *) currentOverview posterPath: (NSString *) currentPosterPath voteAverage: (NSNumber *) currentVoteAverage {

    self = [super init];
    if (self) {
        self.title = title;
        self.overview = currentOverview;
        self.posterPath = currentPosterPath;
        self.voteAverage = currentVoteAverage;
        self.movieId = currentMovieID;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Title: %@, Overview: %@", self.title, self.overview];
}

@end
