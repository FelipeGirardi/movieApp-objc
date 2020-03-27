//
//  MainScreenView.m
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 16/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainScreenView.h"
#import "MoviesTableCell.h"
#import "MainScreenNetwork.h"
#import "MoviesList.h"
#import "MovieDetailsViewController.h"
#import "MovieDetailsAPIRequest.h"
#import "MoviesCollectionViewTableCell.h"
#import "MoviesCollectionCell.h"
#import "ButtonCollectionCell.h"

@interface MainScreenView ()

@property(nonatomic, readwrite, assign) BOOL prefersLargeTitle;
@property(nonatomic) int selectedMovieID;
@property(nonatomic) BOOL isSearchActive;
@property(nonatomic) int currentPopularMoviesPage;
@property(nonatomic) int currentNowPlayingMoviesPage;
@property(nonatomic) int currentSearchMoviesPage;
@property(nonatomic) int currentUpcomingMoviesPage;
@property(nonatomic) NSString* currentSearchTerm;
@property(nonatomic) UIActivityIndicatorView* loadingIndicator;
@property(nonatomic) BOOL isShowingFooter;
@property(nonatomic) BOOL isUpcomingMoviesRequestComplete;

- (void) popularMoviesRequest: (int)currentPopularMoviesPage;
- (void) nowPlayingMoviesRequest: (int)currentNowPlayingMoviesPage;
- (void) upcomingMoviesRequest: (int)currentUpcomingMoviesPage;
- (void) searchMoviesRequest: (int)searchMoviesPage searchTerm: (NSString*)term didChangeText: (BOOL)didChangeText;

@end


@implementation MainScreenView

@synthesize moviesTableView = _moviesTableView;
@synthesize moviesSearchBar = _moviesSearchBar;

MainScreenNetwork *network = nil;
NSMutableArray<MainScreenMovie*> *popularMovies = nil;
NSMutableArray<MainScreenMovie*> *playingNowMovies = nil;
NSMutableArray<MainScreenMovie*> *upcomingMovies = nil;
NSMutableArray<MainScreenMovie*> *searchMovies = nil;

- (void) viewDidLoad {
    [super viewDidLoad];

    self->_moviesTableView.delegate = self;
    self->_moviesTableView.dataSource = self;
    _moviesTableView.hidden = true;
    _moviesTableView.sectionHeaderHeight = 50;
    _isShowingFooter = false;
    _moviesSearchBar.delegate = self;
    
    [self setNavigationBar];
    [self setLoadingIndicator];
    
    popularMovies = NSMutableArray.new;
    playingNowMovies = NSMutableArray.new;
    upcomingMovies = NSMutableArray.new;
    searchMovies = NSMutableArray.new;
    network = MainScreenNetwork.instantiateNetwork;
    
    self.isSearchActive = false;
    self.currentPopularMoviesPage = 1;
    self.currentNowPlayingMoviesPage = 1;
    self.currentSearchMoviesPage = 1;
    self.currentUpcomingMoviesPage = 1;
    self.isUpcomingMoviesRequestComplete = false;
    
    // API Requests
    [self popularMoviesRequest: self.currentPopularMoviesPage];
    [self nowPlayingMoviesRequest: self.currentNowPlayingMoviesPage];
    [self upcomingMoviesRequest: self.currentUpcomingMoviesPage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toMovieDetailsScreen"])
    {
        // Get reference to the destination view controller
        MovieDetailsViewController *vc = segue.destinationViewController;

        // Pass any objects to the view controller here, like...
        vc.movieId = self.selectedMovieID;
    }
}

- (void) popularMoviesRequest: (int)currentPopularMoviesPage {
    NSString *urlString  = [NSString stringWithFormat:@"%s%d%s","https://api.themoviedb.org/3/movie/popular?page=",currentPopularMoviesPage,"&language=en-US&api_key=77d63fcdb563d7f208a22cca549b5f3e"];
    
    [network getDataFrom:urlString completion:^ (NSMutableArray * moviesList) {
        
        [popularMovies addObjectsFromArray: moviesList];

        [self downloadPopularMoviesPosters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loadingIndicator stopAnimating];
            self->_moviesSearchBar.userInteractionEnabled = true;
            self->_isShowingFooter = true;
            [self->_moviesTableView reloadData];
        });
        
    }];
}

- (void) nowPlayingMoviesRequest: (int)currentNowPlayingMoviesPage {
    NSString *urlString  = [NSString stringWithFormat:@"%s%d","https://api.themoviedb.org/3/movie/now_playing?api_key=77d63fcdb563d7f208a22cca549b5f3e&language=en-US&page=",currentNowPlayingMoviesPage];
    
    [network getDataFrom:urlString completion:^ (NSMutableArray * moviesList) {
        
        [playingNowMovies addObjectsFromArray: moviesList];

        [self downloadPlayingNowPosters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_moviesTableView reloadData];
        });
    }];
}

- (void) upcomingMoviesRequest: (int)currentUpcomingMoviesPage {
    NSString *urlString  = [NSString stringWithFormat:@"%s%d","https://api.themoviedb.org/3/movie/upcoming?api_key=77d63fcdb563d7f208a22cca549b5f3e&language=en-US&page=", currentUpcomingMoviesPage];
    
    [network getDataFrom:urlString completion:^ (NSMutableArray * moviesList) {
       
        [upcomingMovies addObjectsFromArray: moviesList];
        
        [self downloadUpcomingPosters];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isUpcomingMoviesRequestComplete = true;
            self->_moviesTableView.hidden = false;
            [self->_moviesTableView reloadData];
        });
    }];
}

- (void) setNavigationBar {
    
    self.title = @"Movies";
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _moviesSearchBar.userInteractionEnabled = false;
    _moviesSearchBar.layer.borderWidth = 1;
    _moviesSearchBar.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0].CGColor;
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

- (void) downloadPopularMoviesPosters {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        for (MainScreenMovie * movie in popularMovies) {
            [network downloadImage: [movie posterPath] completion: ^(NSData * imageData) {
                
                movie.posterImageData = imageData;
            }];
        }
    });
}

- (void) downloadPlayingNowPosters {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        for (MainScreenMovie * movie in playingNowMovies) {
            [network downloadImage: [movie posterPath] completion: ^(NSData * imageData) {
                
                movie.posterImageData = imageData;
            }];
        }
    });
}

- (void) downloadUpcomingPosters {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        for (MainScreenMovie * movie in upcomingMovies) {
            [network downloadImage: [movie posterPath] completion: ^(NSData * imageData) {
                
                movie.posterImageData = imageData;
            }];
        }
    });
}
 
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0 && !self.isSearchActive) {
        MoviesCollectionViewTableCell * cell = (MoviesCollectionViewTableCell *) [tableView dequeueReusableCellWithIdentifier:@"upcomingMoviesCollectionCell"];
        
        cell.moviesCollectionView.delegate = self;
        cell.moviesCollectionView.dataSource = self;

        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.moviesCollectionView reloadData];
        });
        
        cell.moviesCollectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
        cell.moviesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        return cell;
    }
    
    else {
        MoviesTableCell *cell = (MoviesTableCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"movieCell" owner:self options:nil];
            cell = [nib objectAtIndex: 0];
        }
        
        MainScreenMovie *newMovie = [[MainScreenMovie alloc] init];
        
        if ([indexPath section] == 1 && self.isSearchActive == false) {
            newMovie = [popularMovies objectAtIndex: [indexPath row]];
        }
        else if ([indexPath section] == 2 && self.isSearchActive == false) {
            newMovie = [playingNowMovies objectAtIndex: [indexPath row]];
        }
        else {
            newMovie = [searchMovies objectAtIndex: [indexPath row]];
        }
        
        NSNumber *voteAverage = [newMovie voteAverage];
        NSString *posterPath = [newMovie posterPath];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        [formatter setRoundingMode:NSNumberFormatterRoundFloor];
        NSString* ratingString = [formatter stringFromNumber:[NSNumber numberWithFloat:[voteAverage floatValue]]];
        
        if (newMovie.posterImageData == nil) {
            NSString *urlString = [NSString stringWithFormat: @"%s%@", "https://image.tmdb.org/t/p/w500", posterPath];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *posterImageData = [[NSData alloc] initWithContentsOfURL: url];
            [[cell movieImage] setImage: [UIImage imageWithData: posterImageData]];
        }
        
        else {
            [[cell movieImage] setImage: [UIImage imageWithData: [newMovie posterImageData]]];
        }

        
        cell.movieId = [newMovie movieId];
        
        [[[cell movieImage] layer] setCornerRadius: 10];
        
        [[cell movieTitleLabel] setText: [newMovie title]];

        [[cell movieDescriptionLabel] setText: [newMovie overview]];
        
        [[cell movieRatingLabel] setText: ratingString];

        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if(!self.isSearchActive) {
            return 1;
        }
        else {
            return [searchMovies count];
        }
    }
    else if (section == 1) {
        if(!self.isSearchActive) {
            return [popularMovies count];
        }
        else {
            return [searchMovies count];
        }
    }
    else {
        return section == 2 && !self.isSearchActive ? [playingNowMovies count] : 0;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isSearchActive == false ? 3 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _moviesTableView.frame.size.width, 20)];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, _moviesTableView.frame.size.width, 25)];
    
    NSString *title = @"";
    
    [sectionLabel setFont: [UIFont boldSystemFontOfSize:20]];
    
    [sectionView addSubview: sectionLabel];
    [sectionView setBackgroundColor: [UIColor whiteColor]];
    
    if (section == 0) {
        if(!self.isSearchActive) {
            title = @"Upcoming Movies";
        }
        else {
            title = @"Search Results";
        }
    }
    
    if (section == 1) {
            title = @"Popular Movies";
    }
    
    else if (section == 2 && !self.isSearchActive) {
         title = @"Playing Now";
    }
    
    [sectionLabel setText: title];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(!self.isShowingFooter || (section == 0 && !self.isSearchActive)) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    else {
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        UIButton *showMoreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [showMoreButton setTitle:@"Show more" forState:UIControlStateNormal];
        
        if(section == 0 || section == 1) {
        [showMoreButton addTarget:self action:@selector(showMorePopularMoviesButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(section == 2) {
            [showMoreButton addTarget:self action:@selector(showMoreNowPlayingMoviesButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [showMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        showMoreButton.frame=CGRectMake(0, 0, 120, 30);
        showMoreButton.center = footerView.center;
        showMoreButton.clipsToBounds = YES;
        showMoreButton.layer.cornerRadius = 10.0f;
        showMoreButton.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:70.0/255.0 blue:33.0/255.0 alpha:1.0].CGColor;
        showMoreButton.layer.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:70.0/255.0 blue:33.0/255.0 alpha:1.0].CGColor;
        showMoreButton.layer.borderWidth = 2.0f;
        
        [footerView addSubview:showMoreButton];
        return footerView;
    }
}

- (void)showMorePopularMoviesButton:(id)sender
{
    // Button for popular and search movies is being reused here
    if(!self.isSearchActive) {
        self.currentPopularMoviesPage += 1;
        [self popularMoviesRequest: self.currentPopularMoviesPage];
    }
    else {
        self.currentSearchMoviesPage += 1;
        [self searchMoviesRequest:self.currentSearchMoviesPage searchTerm:self.currentSearchTerm didChangeText: false];
    }
}

- (void)showMoreNowPlayingMoviesButton:(id)sender
{
    self.currentNowPlayingMoviesPage += 1;
    [self nowPlayingMoviesRequest: self.currentNowPlayingMoviesPage];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainScreenMovie *selectedMovie = nil;
    
    if (indexPath.section != 0) {
        if (indexPath.section == 1) {
            if(!self.isSearchActive) {
                selectedMovie = [popularMovies objectAtIndex: [indexPath row]];
            }
            else {
                selectedMovie = [searchMovies objectAtIndex: [indexPath row]];
            }
        }
        
        else if (indexPath.section == 2) {
            selectedMovie = [playingNowMovies objectAtIndex: [indexPath row]];
        }
        
        NSNumber *movieIdNumber = [selectedMovie movieId];
        self.selectedMovieID = [movieIdNumber intValue];
        
        [self performSegueWithIdentifier:@"toMovieDetailsScreen" sender:nil];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    self.currentSearchMoviesPage = 1;
    _moviesTableView.hidden = true;
    
    if(![searchText  isEqual: @""]) {
        self.isSearchActive = true;
        self.currentSearchTerm = searchText;
        [self setLoadingIndicator];
        
        [self searchMoviesRequest:self.currentSearchMoviesPage searchTerm:searchText didChangeText: true];
        
    } else {
        self.isSearchActive = false;
        self->_moviesTableView.hidden = false;
        [searchMovies removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_moviesTableView reloadData];
        });
    }
}

- (IBAction)showMoreButtonAction:(UIButton *)sender {
    self.currentUpcomingMoviesPage += 1;
    [self upcomingMoviesRequest: self.currentUpcomingMoviesPage];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [upcomingMovies count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.item == upcomingMovies.count) {
        ButtonCollectionCell * cell = (ButtonCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier: @"showMoreButtonCell" forIndexPath:indexPath];
        
        if(self.isUpcomingMoviesRequestComplete) {
            cell.showMoreButton.hidden = false;
            [cell.showMoreButton setTitle:@"Show more" forState:UIControlStateNormal];
            [cell.showMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.showMoreButton.frame = CGRectMake(0, 80, 120, 30);
            cell.showMoreButton.clipsToBounds = YES;
            cell.showMoreButton.layer.cornerRadius = 10.0f;
            cell.showMoreButton.layer.borderColor = [UIColor colorWithRed:241.0/255.0 green:70.0/255.0 blue:33.0/255.0 alpha:1.0].CGColor;
            cell.showMoreButton.layer.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:70.0/255.0 blue:33.0/255.0 alpha:1.0].CGColor;
            cell.showMoreButton.layer.borderWidth = 2.0f;
        }
        else {
            cell.showMoreButton.hidden = true;
        }
        return cell;
    }
    else {
        MoviesCollectionCell * cell = (MoviesCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier: @"upcomingCell" forIndexPath:indexPath];
        
        MainScreenMovie *newMovie = [[MainScreenMovie alloc] init];
        
        newMovie = [upcomingMovies objectAtIndex: [indexPath row]];
        
        [[cell titleLabel] setText: [newMovie title]];

        NSNumber *voteAverage = [newMovie voteAverage];
        NSString *posterPath = [newMovie posterPath];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        [formatter setRoundingMode:NSNumberFormatterRoundFloor];
        NSString* ratingString = [formatter stringFromNumber:[NSNumber numberWithFloat:[voteAverage floatValue]]];
        
        if (newMovie.posterImageData == nil) {
            NSString *urlString = [NSString stringWithFormat: @"%s%@", "https://image.tmdb.org/t/p/w500", posterPath];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *posterImageData = [[NSData alloc] initWithContentsOfURL: url];
            [[cell posterImage] setImage: [UIImage imageWithData: posterImageData]];
        }
        
        else {
            [[cell posterImage] setImage: [UIImage imageWithData: [newMovie posterImageData]]];
        }
        
        cell.movieId = [newMovie movieId];
        
        [[[cell posterImage] layer] setCornerRadius: 10];
        
        [[cell titleLabel] setText: [newMovie title]];
        
        [[cell ratingLabel] setText: ratingString];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(122, 240);
}

- (void) searchMoviesRequest: (int)searchMoviesPage searchTerm: (NSString*)term didChangeText: (BOOL)didChangeText {
    NSString *searchUrlString = [NSString stringWithFormat: @"%s%@%s%d", "https://api.themoviedb.org/3/search/movie?api_key=fb61737ab2cdee1c07a947778f249e7d&query=", term, "&page=", searchMoviesPage];
    
    [network getDataFrom:searchUrlString completion:^ (NSMutableArray * moviesList) {
        
        if(didChangeText) {
            [searchMovies removeAllObjects];
        }
        [searchMovies addObjectsFromArray: moviesList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_moviesTableView.hidden = false;
            [self->_loadingIndicator stopAnimating];
            [self->_moviesTableView reloadData];
        });
    }];
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainScreenMovie *selectedMovie = nil;
    
    if(indexPath.item != upcomingMovies.count) {
        if(!self.isSearchActive) {
            selectedMovie = [upcomingMovies objectAtIndex: [indexPath row]];
        }
        else {
            selectedMovie = [searchMovies objectAtIndex: [indexPath row]];
        }
        
        NSNumber *movieIdNumber = [selectedMovie movieId];
        self.selectedMovieID = [movieIdNumber intValue];
        
        [self performSegueWithIdentifier:@"toMovieDetailsScreen" sender:nil];
    }
}

@end

