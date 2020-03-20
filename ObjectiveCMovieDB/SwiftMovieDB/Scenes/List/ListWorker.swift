//
//  ListWorker.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation


protocol ListWorkerDelegate: class {
    func getPopularMovies(didFinishGettingPopularMovies movies: [Movie.Popular])
    
    func getPlayingNowMovies(didFinishGettingPlayingNowMovies movies: [Movie.NowPlaying])
    
    func getMovieDetails(didFinishGettingMovieDetails movie: Movie.Details)
}


// Makes the API Request, puts the information on the Model template and sends back to the Interactor
class ListWorker {
    
    var popularMovieList: [Movie.Popular] = []
    var playingNowMovieList: [Movie.NowPlaying] = []
    
    typealias finishedGettingPopularMovies = (_ data: [Movie.Popular]?, _ error: Error?) -> Void
    typealias finishedGettingPlayingNowMovies = (_ data: [Movie.NowPlaying]?, _ error: Error?) -> Void
    
    weak var delegate: ListWorkerDelegate?
    weak var interactorDelegate: ListInteractorDelegate?
    
    func getPopularMoviesRequest(completion: @escaping finishedGettingPopularMovies){
        let objcNetwork = MainScreenNetwork()
        
    objcNetwork.getDataFrom("https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&api_key=77d63fcdb563d7f208a22cca549b5f3e") { (moviesListData) in
    
            for element in moviesListData ?? [] {
                if let newMovie = element as? MainScreenMovie {
                    
                    let popularMovie = Movie.Popular(title: newMovie.title,
                                                     rating: Double(truncating: newMovie.voteAverage),
                                                     image: self.getMovieImage(posterPath: newMovie.posterPath) ?? Data(),
                                                     overview: newMovie.overview,
                                                     genres: [])
                    
                    self.popularMovieList.append(popularMovie)
                }
            }
            
            self.delegate?.getPopularMovies(didFinishGettingPopularMovies: self.popularMovieList)
            completion(self.popularMovieList, nil)
        }
        
    }
    
    func getPlayingNowRequest(completion: @escaping finishedGettingPlayingNowMovies) {
        
        let objcNetwork = MainScreenNetwork()
    objcNetwork.getDataFrom("https://api.themoviedb.org/3/movie/now_playing?api_key=77d63fcdb563d7f208a22cca549b5f3e&language=en-US&page=1") { (moviesListData) in
            
            for element in moviesListData ?? [] {
                
                if let newMovie = element as? MainScreenMovie {
                    
                    let playingNowMovie = Movie.NowPlaying(title: newMovie.title,
                                                           rating: Double(truncating: newMovie.voteAverage),
                                                           image: self.getMovieImage(posterPath: newMovie.posterPath) ?? Data())
                    
                    self.playingNowMovieList.append(playingNowMovie)
                }
            }
            
            self.delegate?.getPlayingNowMovies(didFinishGettingPlayingNowMovies: self.playingNowMovieList)
            completion(self.playingNowMovieList, nil)
        }
    }
    
    func getMovieImage(posterPath: String?) -> Data? {
        if posterPath == nil {
            return nil
        }
        else {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)") {
                do {
                    let data = try Data(contentsOf: url)
                    return data
                } catch {
                    return nil
                }
            }
            else {
                return nil
            }
        }
    }
    
    
    // Inserts information on Popular Movie model
    func preparePopularMovieInformation(apiReturn: APIReturn) {
        
        for movie in apiReturn.results {
            
            let movieTitle = movie.title
            let movieRating = movie.voteAverage
            let movieImage = getMovieImage(posterPath: movie.posterPath)!
            let movieOverview = movie.overview
            let movieGenres = movie.genreIDS
            
            let popularMovie = Movie.Popular(title: movieTitle!, rating: movieRating!, image: movieImage, overview: movieOverview, genres: movieGenres)
            
            popularMovieList.append(popularMovie)
        }
        
        
        // CHAMA O DELEGATE
        self.delegate?.getPopularMovies(didFinishGettingPopularMovies: popularMovieList)
    }
    
    func preparePlayingNowMovieInformation(apiReturn: APIReturn) {
        
        for movie in apiReturn.results {
            
            
            let movieTitle = movie.title
            let movieRating = movie.voteAverage
        
            let movieImage = getMovieImage(posterPath: movie.posterPath)!
            //let movieImage = Data()
            
            let nowPlayingMovie = Movie.NowPlaying(title: movieTitle!, rating: movieRating!, image: movieImage)
        
            playingNowMovieList.append(nowPlayingMovie)
        }
        
        self.delegate?.getPlayingNowMovies(didFinishGettingPlayingNowMovies: playingNowMovieList)
    }
    


}
