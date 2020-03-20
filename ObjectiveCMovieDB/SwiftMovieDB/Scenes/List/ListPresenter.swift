//
//  ListPresenter.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation


// Presenter receives information from Interactor
protocol ListPresenterDelegate: class {
    
    func receivePopularMovies(movies: [Movie.Popular])
    
    func receivePlayingNowMovies(movies: [Movie.NowPlaying])
    
    func receiveMovieDetails(movie: Movie.Details)
    
    func receiveRequestState(viewControllerState: ViewControllerState)
    
    func receiveViewController(viewController: ListViewController)
}

class ListPresenter {
    
    weak var delegate: ListPresenterDelegate?
    var popularMoviesList: [Movie.Popular] = [] {
        didSet {
            updateViewControllerStatus()
            sendPopularMoviesToViewController()
        }
    }
    
    var nowPlayingMoviesList: [Movie.NowPlaying] = [] {
        didSet {
            updateViewControllerStatus()
            sendNowPlayingMoviesToViewController()
        }
    }
    
    var requestState: ViewControllerState?
    var listViewController: ListViewController?
   // var listViewController: ListViewControllerDelegate? = ListViewController()
    
    func updateViewControllerStatus(){
        if (popularMoviesList.count > 0) /*&& nowPlaying.count > 0*/{
            requestState = ViewControllerState.bothRequestsSucceeded
        } else if popularMoviesList.count > 0 {
            requestState = ViewControllerState.popularMoviesSucceeded
        } else {
            requestState = ViewControllerState.noRequestSucceeded
        }
        
        listViewController?.receiveViewControllerState(viewControllerState: requestState ?? ViewControllerState.noRequestSucceeded)
        
    }

    func checkPopularMoviesReceivement(popularMovies: [Movie.Popular]) {
        if popularMovies.count > 0 {
            // Methods called if Presenter receives the popular movies correctly
        }
        else {
            // Methods called if Presenter receives the popular movies incorrectly
        }
    }
    
    func sendPopularMoviesToViewController() {
        listViewController?.receivePopularMovies(movies: self.popularMoviesList)
    }
    
    func sendNowPlayingMoviesToViewController() {
        listViewController?.receivePlayingNowMovies(movies: self.nowPlayingMoviesList)
    }
    
}

extension ListPresenter: ListPresenterDelegate {
    
    func receivePopularMovies(movies: [Movie.Popular]) {
        self.popularMoviesList = movies
    }
    
    func receivePlayingNowMovies(movies: [Movie.NowPlaying]) {
        self.nowPlayingMoviesList = movies
    }
    
    func receiveMovieDetails(movie: Movie.Details) {
        print(movie)
    }
    
    func receiveRequestState(viewControllerState: ViewControllerState) {
        print(viewControllerState)
    }
    
    func receiveViewController(viewController: ListViewController) {
        self.listViewController = viewController
    }
    
}
//
//extension ListPresenter: ListViewControllerDelegate {
//    func receivePopularMovies(movies: [Movie.Popular]) {
//        <#code#>
//    }
//
//    func receivePlayingNowMovies(movies: [Movie.NowPlaying]) {
//        print(movies)
//    }
//
//    func receiveMovieDetails(movie: Movie.Details) {
//        print(movie)
//    }
//
//    func receiveViewControllerState(viewControllerState: ViewControllerState) {
//        print(viewControllerState)
//    }
//
//
//}
