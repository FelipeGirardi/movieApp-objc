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

@property (nonatomic, strong)   NSString *posterPath;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong)   NSArray<NSNumber *> *genreIDS;
@property (nonatomic, strong)   NSString *title;
@property (nonatomic, strong)  NSNumber * voteAverage;
@property (nonatomic, strong)   NSString *overview;
@property (nonatomic, strong) NSNumber *movieId;
@property (nonatomic, strong) NSData *posterImageData;

-(instancetype) initMovie: (NSString *) title movieId: (NSNumber *) currentMovieID overview: (NSString *) currentOverview posterPath: (NSString *) currentPosterPath voteAverage: (NSNumber *) currentVoteAverage;

@end

@interface MoviesList : NSObject

@property (nonatomic, assign) NSInteger *page;
@property (nonatomic, assign) NSInteger *totalResults;
@property (nonatomic, assign) NSInteger *totalPages;
@property (nonatomic, copy)   NSArray<MainScreenMovie *> *results;

@end
