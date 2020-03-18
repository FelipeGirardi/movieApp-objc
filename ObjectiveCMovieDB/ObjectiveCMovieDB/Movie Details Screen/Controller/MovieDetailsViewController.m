//
//  MovieDetailsViewController.m
//  ObjectiveCMovieDB
//
//  Created by Felipe Girardi on 16/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MovieDetailsModel.h"
#import "MovieDetailsAPIRequest.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;

@property (weak, nonatomic) QTMovieDetails *movieDetails;

- (void) updateMovieDetailsUI;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _overviewTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    
    // Call API request for movie details and store them in self.movieDetails
    [MovieDetailsAPIRequest fetchMovieByID: 2 completeBlock:^(QTMovieDetails * movieDetails){
        self.movieDetails = movieDetails;
        
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self updateMovieDetailsUI];
//        });
    }];
    
}

- (void) updateMovieDetailsUI {
//    self.titleLabel.text = self.movieDetails.title;
//    self.genreLabel.text = self.movieDetails.genres[0].name;
//    self.ratingLabel.text = self.movieDetails.voteAverage.stringValue;
//    self.overviewTextView.text = self.movieDetails.overview;
}

@end
