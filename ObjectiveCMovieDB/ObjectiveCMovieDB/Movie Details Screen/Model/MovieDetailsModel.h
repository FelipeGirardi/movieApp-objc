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
@class QTProductionCompany;
@class QTProductionCountry;
@class QTSpokenLanguage;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface QTMovieDetails : NSObject
@property (nonatomic, nullable, strong) NSNumber *adult;
@property (nonatomic, nullable, copy)   NSString *backdropPath;
@property (nonatomic, nullable, copy)   id belongsToCollection;
@property (nonatomic, nullable, strong) NSNumber *budget;
@property (nonatomic, nullable, copy)   NSArray<QTGenre *> *genres;
@property (nonatomic, nullable, copy)   id homepage;
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, copy)   NSString *imdbID;
@property (nonatomic, nullable, copy)   NSString *originalLanguage;
@property (nonatomic, nullable, copy)   NSString *originalTitle;
@property (nonatomic, nullable, copy)   NSString *overview;
@property (nonatomic, nullable, strong) NSNumber *popularity;
@property (nonatomic, nullable, copy)   NSString *posterPath;
@property (nonatomic, nullable, copy)   NSArray<QTProductionCompany *> *productionCompanies;
@property (nonatomic, nullable, copy)   NSArray<QTProductionCountry *> *productionCountries;
@property (nonatomic, nullable, copy)   NSString *releaseDate;
@property (nonatomic, nullable, strong) NSNumber *revenue;
@property (nonatomic, nullable, strong) NSNumber *runtime;
@property (nonatomic, nullable, copy)   NSArray<QTSpokenLanguage *> *spokenLanguages;
@property (nonatomic, nullable, copy)   NSString *status;
@property (nonatomic, nullable, copy)   NSString *tagline;
@property (nonatomic, nullable, copy)   NSString *title;
@property (nonatomic, nullable, strong) NSNumber *video;
@property (nonatomic, nullable, strong) NSNumber *voteAverage;
@property (nonatomic, nullable, strong) NSNumber *voteCount;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTGenre : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, copy)   NSString *name;
@end

@interface QTProductionCompany : NSObject
@property (nonatomic, nullable, strong) NSNumber *identifier;
@property (nonatomic, nullable, copy)   id logoPath;
@property (nonatomic, nullable, copy)   NSString *name;
@property (nonatomic, nullable, copy)   NSString *originCountry;
@end

@interface QTProductionCountry : NSObject
@property (nonatomic, nullable, copy) NSString *iso3166_1;
@property (nonatomic, nullable, copy) NSString *name;
@end

@interface QTSpokenLanguage : NSObject
@property (nonatomic, nullable, copy) NSString *iso639_1;
@property (nonatomic, nullable, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END

#endif /* MovieDetailsModel_h */
