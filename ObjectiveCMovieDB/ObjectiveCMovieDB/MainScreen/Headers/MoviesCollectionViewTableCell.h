//
//  MoviesCollectionCell.h
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 24/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef MoviesCollectionViewTableCell_h
#define MoviesCollectionViewTableCell_h
#import <UIKit/UIKit.h>

@interface MoviesCollectionViewTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;

@end

#endif /* MoviesCollectionCell_h */
