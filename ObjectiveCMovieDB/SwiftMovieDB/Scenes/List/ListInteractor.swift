//
//  ListInteractor.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation
import UIKit

protocol ListBusinessLogic {
    func fetchPopularMovies()
}

protocol ListInteractorDelegate: class {
    func receivePopularMovies(popularMovies: [Movie.Popular])
    
    func receiveViewController(viewController: ListViewController)
    
    func load()
    
    
}
// Receives information made by Worker and sends to Presenter
class ListInteractor {

    var popularMovies: [Movie.Popular]?
    var playingNowMovies: [Movie.NowPlaying]?
    var movieDetails: Movie.Details?
    
    var listWorker: ListWorker = ListWorker()
    var listPresenter: ListPresenterDelegate?// = ListPresenter()
    var listViewController: ListViewController?
    
    init(presenterDelegate: ListPresenterDelegate?) {
//        listPresenter?.
        let listPresenter = ListPresenter()
        listPresenter.delegate = presenterDelegate
        self.listPresenter = listPresenter
    }
    
    func receiveMovieDetails(movie: Movie.Details) {
        movieDetails = movie
    }

    func receivePopularMovies(movies: [Movie.Popular]) {
        self.popularMovies = movies
    }

    func receivePlayingNowMovies(movies: [Movie.NowPlaying]) {
        self.playingNowMovies = movies
    }
    
}

extension ListInteractor: ListWorkerDelegate {

    func getPopularMovies(didFinishGettingPopularMovies movies: [Movie.Popular]) {
        receivePopularMovies(movies: movies)
    }

    func getPlayingNowMovies(didFinishGettingPlayingNowMovies movies: [Movie.NowPlaying]) {
        receivePlayingNowMovies(movies: movies)
    }

    func getMovieDetails(didFinishGettingMovieDetails movie: Movie.Details) {
        receiveMovieDetails(movie: movie)
    }

}

extension ListInteractor: ListInteractorDelegate {
    func receiveViewController(viewController: ListViewController) {
        self.listViewController = viewController
    }
    
    func receivePopularMovies(popularMovies: [Movie.Popular]) {
        print(popularMovies)
    }

    func load() {
        listWorker.delegate = self
        listWorker.getPopularMoviesRequest() { (data, error) in
            // Receiving asynchronous information
            self.listPresenter?.receiveViewController(viewController: self.listViewController ?? ListViewController())
            self.listPresenter?.receivePopularMovies(movies: self.popularMovies ?? [])

        }
        
        listWorker.getPlayingNowRequest() { (data, error) in
            
            self.listPresenter?.receiveViewController(viewController: self.listViewController ?? ListViewController())
            self.listPresenter?.receivePlayingNowMovies(movies: self.playingNowMovies ?? [])
        }
    }
}

