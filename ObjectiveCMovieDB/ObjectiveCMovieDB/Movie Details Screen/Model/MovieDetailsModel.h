//
//  MovieDetailsModel.h
//  ObjectiveCMovieDB
//
//  Created by Felipe Girardi on 18/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef MovieDetailsModel_h
#define MovieDetailsModel_h

// To parse this JSON:
//
//   NSError *error;
//   QTMovieDetails *movieDetails = [QTMovieDetails fromJSON:json encoding:NSUTF8Encoding error:&error];

#import <Foundation/Foundation.h>

@class QTMovieDetails;
@class QTGenre;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface QTMovieDetails : NSObject
@property (nonatomic, nullable, copy)   NSArray<QTGenre *> *genres;
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, copy)   NSString *overview;
@property (nonatomic, nullable, copy)   NSString *posterPath;
@property (nonatomic, nullable, copy)   NSString *title;
@property (nonatomic, nullable, strong) NSNumber *voteAverage;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTGenre : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, copy)   NSString *name;
@end

NS_ASSUME_NONNULL_END

#endif /* MovieDetailsModel_h */
