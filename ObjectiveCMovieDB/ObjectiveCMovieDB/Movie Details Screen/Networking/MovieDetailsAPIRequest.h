//
//  MovieDetailsAPIRequest.h
//  ObjectiveCMovieDB
//
//  Created by Felipe Girardi on 18/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef MovieDetailsAPIRequest_h
#define MovieDetailsAPIRequest_h
#import "MovieDetailsModel.h"

@interface MovieDetailsAPIRequest : NSObject

+ (void) fetchMovieByID: (int)movieID completeBlock:(void(^)(QTMovieDetails *)) completeBlock;

@end

#endif /* MovieDetailsAPIRequest_h */
