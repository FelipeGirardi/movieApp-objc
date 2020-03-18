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


@interface MainScreenView ()

@property(nonatomic, readwrite, assign) BOOL prefersLargeTitle;

@end


@implementation MainScreenView

@synthesize moviesTableView = _moviesTableView;

MainScreenNetwork *network = nil;
NSMutableArray<MainScreenMovie*> *popularMovies = nil;

//NSMutableArray<NSString*> *titleList = nil;


- (void) viewDidLoad {
    [super viewDidLoad];

    _moviesTableView.delegate = self;
    _moviesTableView.dataSource = self;
    _moviesTableView.sectionHeaderHeight = 50;
    
    [self setNavigationBar];
    
    //titleList = NSMutableArray.new;
    popularMovies = NSMutableArray.new;
    network = MainScreenNetwork.instantiateNetwork;
    
    [network getDataFrom:@"https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&api_key=77d63fcdb563d7f208a22cca549b5f3e" completion:^ (NSMutableArray * moviesList) {
        
        for (MainScreenMovie * movie in moviesList) {
            NSLog([movie description]);
            //[titleList addObject: [movie title]];
        }
        popularMovies = [[NSMutableArray alloc] initWithArray:moviesList];
        
        for (MainScreenMovie * movie in popularMovies) {
            NSLog([movie description]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_moviesTableView reloadData];
        });
        
    }];
}

- (void) setNavigationBar {
    
    self.title = @"Movies";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
}
 
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MoviesTableCell *cell = (MoviesTableCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"movieCell" owner:self options:nil];
        cell = [nib objectAtIndex: 0];
    }
    
//    cell.movieTitleLabel.text = @"Spider-Man: Far from Home";
//    cell.movieImage.layer.cornerRadius = 10;
//    cell.movieDescriptionLabel.text = @"Peter Parker and his friends go on a summer trip to Europe. However, they will hardly be able to rest - Peter will have to...";
    MainScreenMovie *newMovie = [[MainScreenMovie alloc] init];

    newMovie = [popularMovies objectAtIndex: [indexPath row]];
    
//    cell.movieTitleLabel.text = newMovie.title;
    
    for (MainScreenMovie * movie in popularMovies) {
        printf("");
    }
    
    [[cell movieTitleLabel] setText: [[popularMovies objectAtIndex: [indexPath row]] title]];
    
    //[[cell movieTitleLabel] setText: [titleList objectAtIndex:[indexPath row]]];
     
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [popularMovies count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"filmes";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, _moviesTableView.frame.size.width, 20)];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, _moviesTableView.frame.size.width, 25)];
    
    NSString *title = @"Popular Movies";
    
    [sectionLabel setText: title];
    [sectionLabel setFont: [UIFont boldSystemFontOfSize:20]];
    
    [sectionView addSubview: sectionLabel];
    [sectionView setBackgroundColor: [UIColor whiteColor]];
    
    return sectionView;
}

@end

