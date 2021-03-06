//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Tiffany Madruga on 6/21/17.
//  Copyright © 2017 Tiffany Madruga. All rights reserved.
//

import UIKit
import AlamofireImage


class NowPlayingViewController: UIViewController, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var movieActivityIndicator: UIActivityIndicatorView!
    
    
    var movies: [[String: Any]] = []

    var refreshControl: UIRefreshControl!
    
    let alertController = UIAlertController(title: "Cannot Get Movies", message: "No connection available", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        // Start the activity indicator
        movieActivityIndicator.startAnimating()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        fetchMovies()
        
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMovies()
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            
            //checks if nil --> if not it will go through the curly brackets
            if let error = error {
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                self.alertController.addAction(OKAction)
                
                self.present(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                self.refreshControl.endRefreshing()
                self.movieActivityIndicator.stopAnimating()
                print(error.localizedDescription)
                
                
                
            } else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
        
        task.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        movieActivityIndicator.stopAnimating()
        return cell
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
        let movie = movies[indexPath.row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        }
    }
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
