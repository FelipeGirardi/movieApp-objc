//
//  PopularMovie.h
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 18/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef PopularMovie_h
#define PopularMovie_h

#endif /* PopularMovie_h */


@interface MainScreenMovie : NSObject

@property (nonatomic, assign)   NSString *posterPath;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign)   NSArray<NSNumber *> *genreIDS;
@property (nonatomic, assign)   NSString *title;
@property (nonatomic, assign)  NSNumber * voteAverage;
@property (nonatomic, assign)   NSString *overview;

-(instancetype) initMovie: (NSString *) title overview: (NSString *) currentOverview posterPath: (NSString *) currentPosterPath voteAverage: (NSNumber *) currentVoteAverage;

@end

@interface MoviesList : NSObject

@property (nonatomic, assign) NSInteger *page;
@property (nonatomic, assign) NSInteger *totalResults;
@property (nonatomic, assign) NSInteger *totalPages;
@property (nonatomic, copy)   NSArray<MainScreenMovie *> *results;

@end
