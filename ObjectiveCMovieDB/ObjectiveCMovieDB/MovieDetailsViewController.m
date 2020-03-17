//
//  MovieDetailsViewController.m
//  ObjectiveCMovieDB
//
//  Created by Felipe Girardi on 16/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;

// Método pra requisição de API que busca um filme pelo ID (esse método vai ficar na classe de Data Service/API)
- (void) exampleFetchMovieByID: (int) id;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _overviewTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    
    //[self exampleFetchMovieByID: 2];
    
}

- (void) exampleFetchMovieByID: (int) id {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d?api_key=fb61737ab2cdee1c07a947778f249e7d&language=en-US", id];
        [request setURL:[NSURL URLWithString: urlString]];
        [request setHTTPMethod:@"GET"];
    
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Request reply: %@", requestReply);
        }] resume];
}


@end
