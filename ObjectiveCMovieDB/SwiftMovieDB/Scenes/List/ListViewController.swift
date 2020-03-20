//
//  ListViewController.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewControllerDelegate: class {

    func receivePopularMovies(movies: [Movie.Popular])

    func receivePlayingNowMovies(movies: [Movie.NowPlaying])

    func receiveMovieDetails(movie: Movie.Details)

    func receiveViewControllerState(viewControllerState: ViewControllerState)

}

class ListViewController: UITableViewController {
    
    
    let moviesCellID = "moviesCellID"
    
    lazy var interactorTest: ListInteractorDelegate? = ListInteractor(presenterDelegate: self)
    var viewControllerState: ViewControllerState?
    var listRouter: ListRouterDelegate? = ListRouter()
    // MARK: - Variavel migue para controlar qual a celula a ser passada para as proximas telas
    var selectedPopularMovie: Int = 1
    
    var popularMoviesList: [Movie.Popular] = []
    var playingNowMoviesList: [Movie.NowPlaying] = []
    var movieDetails: Movie.Details?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        interactorTest?.receiveViewController(viewController: self)
        interactorTest?.load()
        
    }
    
//    @IBAction func testButton(_ sender: UIButton) {
//        listRouter?.transitionToMovieDetails(from: self)
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.nowPlayingText.rawValue) as? NowPlayingTextCell{
                cell.nowPlayingLabel.text = "Now Playing"
                cell.seeAllButton.setTitle("See All", for: .normal)
                
                return cell
            }

        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.nowPlayingCollectionView.rawValue) as? NowPlayingCollectionView {
                
                cell.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, forRow: indexPath.row)
                return cell
            }
        
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.separator.rawValue) as? SeparatorCell{
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
                
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.popularMovieText.rawValue) as? PopularMovieTextCell{
                cell.popularMoviesLabel.text = "Popular Movies"
                
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.popularMovie.rawValue) as? PopularMovieCell{
                if let firstPopularMovie = self.popularMoviesList.first {
                    cell.movieImage.image = UIImage(data: firstPopularMovie.image)
                    cell.movieTitleLabel.text = firstPopularMovie.title
                    cell.movieRatingLabel.text = "\(firstPopularMovie.rating)"
                    cell.movieDescription.text = firstPopularMovie.overview
                    cell.movieImage.layer.cornerRadius = 10
                }
                
                //cell.movieImage = firstPopularMovie?.image
            
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.popularMovie.rawValue) as? PopularMovieCell{
                if self.popularMoviesList.count > 2 {
                    let secondPopularMovie = self.popularMoviesList[1]
                    
                    cell.movieImage.image = UIImage(data: secondPopularMovie.image)
                    cell.movieTitleLabel.text = secondPopularMovie.title
                    cell.movieRatingLabel.text = "\(secondPopularMovie.rating)"
                    cell.movieDescription.text = secondPopularMovie.overview
                    cell.movieImage.layer.cornerRadius = 10
                }
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsScreen = segue.destination as? MovieDetailViewController {
            listRouter?.receivePopularMovieInformation(destination: movieDetailsScreen, movie: self.popularMoviesList[selectedPopularMovie])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 || indexPath.row == 5 {
            selectedPopularMovie = indexPath.row - 4
            listRouter?.transitionToMovieDetails(from: self)
        }
    }
}

extension ListViewController: ListViewControllerDelegate {
    
    func receivePopularMovies(movies: [Movie.Popular]) {
        self.popularMoviesList = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        //tableView.reloadData()
    }
    
    func receivePlayingNowMovies(movies: [Movie.NowPlaying]) {
        self.playingNowMoviesList = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            let collectionViewCell = self.tableView.dequeueReusableCell(withIdentifier: Cell.nowPlayingCollectionView.rawValue)
            
            collectionViewCell?.reloadInputViews()
        }
        //tableView.reloadData()
    }
    
    func receiveMovieDetails(movie: Movie.Details) {
        print(movie)
    }
    
    func receiveViewControllerState(viewControllerState: ViewControllerState) {
        self.viewControllerState = viewControllerState
    }
    
}

extension ListViewController: ListPresenterDelegate {
    func receiveRequestState(viewControllerState: ViewControllerState) {
        print(viewControllerState)
    }
    
    func receiveViewController(viewController: ListViewController) {
        print(viewController)
    }
}

extension ListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.playingNowMoviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.nowPlayingCell.rawValue, for: indexPath) as? CollectionViewCell {
            
            cell.movieTitle.text = playingNowMoviesList[indexPath.row].title
            cell.movieRating.text = "\(playingNowMoviesList[indexPath.row].rating)"
            cell.movieImage.layer.cornerRadius = 10
            cell.movieImage.image = UIImage(data: playingNowMoviesList[indexPath.row].image)
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    
}

extension ListViewController : UICollectionViewDelegate {
    
}

extension ListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let nowPlayingMovieCellWidth = collectionView.frame.size.width * 0.42
        let nowPlayingMovieCellHeight = collectionView.frame.size.height * 0.9
        
        return CGSize(width: nowPlayingMovieCellWidth, height: nowPlayingMovieCellHeight)
    }
}
