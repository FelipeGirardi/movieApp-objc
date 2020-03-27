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
@property(nonatomic) UIActivityIndicatorView* loadingIndicator;

// Function to update movie details UI
- (void) updateMovieDetailsUI: (QTMovieDetails*) movieDetails;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _overviewTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    _posterImageView.layer.cornerRadius = 10.0;
    _starImageView.hidden = true;
    _overviewLabel.hidden = true;
    
    [self setLoadingIndicator];
    
    // Call API request for movie details
    [MovieDetailsAPIRequest fetchMovieByID: self.movieId completeBlock:^(QTMovieDetails * movieDetails){

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loadingIndicator stopAnimating];
            self->_starImageView.hidden = false;
            self->_overviewLabel.hidden = false;
            [weakSelf updateMovieDetailsUI: movieDetails];
        });
    }];
    
}

- (void) setLoadingIndicator {
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    _loadingIndicator.center = CGPointMake(self.view.center.x, self.navigationController.navigationBar.frame.size.height + 200);
    CGRect loadingFrame = _loadingIndicator.frame;
    loadingFrame.size.width = 35.0f;
    loadingFrame.size.height = 35.0f;
    _loadingIndicator.frame = loadingFrame;
    _loadingIndicator.hidesWhenStopped = true;
    [_loadingIndicator startAnimating];
    [self.view addSubview: _loadingIndicator];
    [self.view bringSubviewToFront:_loadingIndicator];
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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];
    NSString* ratingString = [formatter stringFromNumber:[NSNumber numberWithFloat:[movieDetails.voteAverage floatValue]]];
    
    self.ratingLabel.text = ratingString;
    self.overviewTextView.text = movieDetails.overview;
}

@end
