//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Aditya Dhingra on 1/31/17.
//  Copyright © 2017 Aditya Dhingra. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTable: UITableView!
    var movies: [NSDictionary]?
    var endpoint = "now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTable.dataSource = self
        movieTable.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies(_:)), for: UIControlEvents.valueChanged)
        movieTable.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
        
        //Send API request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //ProgressHUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.movieTable.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func refreshMovies(_ refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //ProgressHUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.movieTable.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTable.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies?[indexPath.row]
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterpath = movie?["poster_path"] as? String {
            let imageURL = URL(string: baseURL + posterpath)
            cell.posterView.setImageWith(imageURL!)
        }
        
        
        cell.titleLabel.text = title
        cell.overview.text = overview
        
        print("row \(indexPath.row)")
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexpath = movieTable.indexPath(for: cell)
        let movie = movies?[(indexpath?.row)!]
        let detailVC = segue.destination as! movieVC
        detailVC.movie = movie
    }

}
