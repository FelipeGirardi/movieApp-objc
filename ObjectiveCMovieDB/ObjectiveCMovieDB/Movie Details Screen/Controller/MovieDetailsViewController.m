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

// Function to update movie details UI
- (void) updateMovieDetailsUI: (QTMovieDetails*) movieDetails;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _overviewTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    _posterImageView.layer.cornerRadius = 10.0;
    
    // Call API request for movie details and store them in self.movieDetails (uncomment for request)
    
//    [MovieDetailsAPIRequest fetchMovieByID: 2 completeBlock:^(QTMovieDetails * movieDetails){
//
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [weakSelf updateMovieDetailsUI: movieDetails];
//        });
//    }];
    
}

- (void) updateMovieDetailsUI: (QTMovieDetails*) movieDetails {
    
    // Get poster URL image
    NSString *urlString = [NSString stringWithFormat: @"%s%@", "https://image.tmdb.org/t/p/w500", movieDetails.posterPath];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *posterImageData = [[NSData alloc] initWithContentsOfURL: url];
    self.posterImageView.image = [UIImage imageWithData: posterImageData];
    
    self.titleLabel.text = movieDetails.title;
    
    // Format genre string
    NSString *genresString = @"";
    for(int i=0; i<movieDetails.genres.count-1; i++) {
        NSString *tempGenreString = [NSString stringWithFormat: @"%@%s", movieDetails.genres[i].name, ", "];
        genresString = [genresString stringByAppendingString: tempGenreString];
    }
    genresString = [genresString stringByAppendingString: movieDetails.genres[movieDetails.genres.count-1].name];
    self.genreLabel.text = genresString;
    
    self.ratingLabel.text = movieDetails.voteAverage.stringValue;
    self.overviewTextView.text = movieDetails.overview;
}

@end
