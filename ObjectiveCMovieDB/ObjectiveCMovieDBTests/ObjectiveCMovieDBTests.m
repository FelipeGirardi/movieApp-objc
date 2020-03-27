//
//  ObjectiveCMovieDBTests.m
//  ObjectiveCMovieDBTests
//
//  Created by Henrique Figueiredo Conte on 27/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainScreenNetwork.h"
#import "MovieDetailsAPIRequest.h"


@interface ObjectiveCMovieDBTests : XCTestCase

@property MainScreenNetwork *mainNetwork;
@property MovieDetailsAPIRequest *movieDetailsNetwork;

@end

@implementation ObjectiveCMovieDBTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    
    _mainNetwork = [[MainScreenNetwork alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void) testApiActivity {
    
    [_mainNetwork getDataFrom:@"https://api.themoviedb.org/3/movie/upcoming?api_key=77d63fcdb563d7f208a22cca549b5f3e&language=en-US&page=1" completion: ^(NSMutableArray * moviesList) {
       
        XCTAssertFalse([moviesList count] == 0);
        
    }];
}

- (void) testMovieByIDRequest {
    [MovieDetailsAPIRequest fetchMovieByID: 123 completeBlock:^ (QTMovieDetails * movieDetails){
    
        XCTAssertTrue(movieDetails != nil);
    }];
}

@end
