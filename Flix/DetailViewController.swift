//
//  DetailViewController.swift
//  Flix
//
//  Created by Tiffany Madruga on 6/22/17.
//  Copyright © 2017 Tiffany Madruga. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
//Outlets
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var ratingValueLabel: UILabel!

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    var movie: [String:Any]?
    
    
    
//Start
    override func viewDidLoad() {
        super.viewDidLoad()

    //passing in 
        
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            titleLabel.layer.masksToBounds = false
            titleLabel.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 3)
            titleLabel.shadowOffset = CGSize(width: 1 , height: 0)
            titleLabel.layer.shadowOpacity = 1
            titleLabel.layer.shadowRadius = 2
            titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            titleLabel.adjustsFontSizeToFitWidth = true
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            overviewLabel.sizeToFit()
            
            ratingValueLabel.text = "\(movie["vote_average"]!)/10"
            
            let backdropPathString = movie["backdrop_path"] as! String
            let posterPathString = movie["poster_path"] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backdropImageView.af_setImage(withURL: backdropURL)
            
            let posterpathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterpathURL)
            posterImageView.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0).cgColor
            posterImageView.layer.borderWidth = 3
            posterImageView.contentMode = .scaleAspectFit
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
