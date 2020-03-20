//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Rafael Ferreira on 15/08/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import UIKit


class MovieDetailViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presentedMovieTitle: String?
    var presentedMovieRating: Double?
    var presentedMovieImage: Data?
    var presentedMovieOverview: String?
    var presentedMovieGenres: [Int]?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //moviePoster = presentedMovieImage
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell
            cell!.movieTitle.text = presentedMovieTitle
            cell!.movieTitle.lineBreakMode = .byWordWrapping
            cell!.movieTitle.numberOfLines = 0
            cell!.movieRatings.text = "\(presentedMovieRating ?? 0.0)"
            cell!.movieGenres.text = "\(presentedMovieGenres ?? [])"
            //cell.movieImage.image = UIImage(data: playingNowMoviesList[indexPath.row].image)
            cell!.moviePoster.image = UIImage(data: presentedMovieImage!)
            cell?.moviePoster.layer.cornerRadius = 10
            
            return cell!
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "overviewTitleCell", for: indexPath) as? overviewTitleCell
            
            return cell!
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as? overviewCell
            cell!.movieOverview.text = presentedMovieOverview
            cell!.movieOverview.lineBreakMode = .byWordWrapping
            cell!.movieOverview.numberOfLines = 0
            
            return cell!
        }
        return UITableViewCell()
    }
    
    
}
