//
//  MoviesCollectionCell.h
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 24/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#ifndef MoviesCollectionCell_h
#define MoviesCollectionCell_h
#import <UIKit/UIKit.h>


@interface MoviesCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


@end

#endif /* MoviesCollectionCell_h */
