//
//  MainScreenNetwork.h
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 17/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef MainScreenNetwork_h
#define MainScreenNetwork_h


#endif /* MainScreenNetwork_h */

@interface MainScreenNetwork: NSObject

- (void) getDataFrom: (NSString *) url completion: (void(^)(NSMutableArray * moviesList)) callback;

- (void) downloadImage: (NSString *) imageURL completion: (void(^) (NSData * imageData)) callback;

+ (instancetype) instantiateNetwork;

- (id) initNetwork;

@end
