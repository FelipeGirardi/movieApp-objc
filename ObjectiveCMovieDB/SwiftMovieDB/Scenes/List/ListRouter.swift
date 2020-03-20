//
//  ListRouter.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import UIKit


protocol ListRouterDelegate: class {
    
    func transitionToMovieDetails(from controller: UIViewController)
    
    func transitionToShowAll(from controller: UIViewController)
    
    func receivePopularMovieInformation(destination: MovieDetailViewController, movie: Movie.Popular)
}

class ListRouter: UIViewController {
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let movieDetailsScreen = segue.destination as? MovieDetailViewController {
//
//            print("Foi")
//        }
//    }
    
}

extension ListRouter : ListRouterDelegate {
    
    func transitionToMovieDetails(from controller: UIViewController) {
        controller.performSegue(withIdentifier: "movieDetails", sender: nil)
    }
    
    func transitionToShowAll(from controller: UIViewController) {
        controller.performSegue(withIdentifier: "showAll", sender: nil)
    }
    
    func receivePopularMovieInformation(destination: MovieDetailViewController, movie: Movie.Popular) {
        destination.presentedMovieTitle = movie.title
        destination.presentedMovieRating = movie.rating
        destination.presentedMovieImage = movie.image
        destination.presentedMovieOverview = movie.overview
        destination.presentedMovieGenres = movie.genres
    }
    
}
