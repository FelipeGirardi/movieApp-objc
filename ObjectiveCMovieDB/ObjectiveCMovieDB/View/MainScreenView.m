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

@interface MainScreenView ()

@end


@implementation MainScreenView

@synthesize moviesTableView = _moviesTableView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _moviesTableView.delegate = self;
    _moviesTableView.dataSource = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MoviesTableCell *cell = (MoviesTableCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"movieCell" owner:self options:nil];
        cell = [nib objectAtIndex: 0];
    }
    
    cell.movieTitleLabel.text = @"Spider-Man: Far from Home";
    cell.movieImage.layer.cornerRadius = 10;
    cell.movieDescriptionLabel.text = @"Peter Parker and his friends go on a summer trip to Europe. However, they will hardly be able to rest - Peter will have to...";
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end

