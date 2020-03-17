//
//  MainScreenView.h
//  ObjectiveCMovieDB
//
//  Created by Henrique Figueiredo Conte on 16/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef MainScreenView_h
#define MainScreenView_h


#endif /* MainScreenView_h */

@interface MainScreenView : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@end
