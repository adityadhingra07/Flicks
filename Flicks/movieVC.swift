//
//  movieVC.swift
//  Flicks
//
//  Created by Aditya Dhingra on 2/7/17.
//  Copyright © 2017 Aditya Dhingra. All rights reserved.
//

import UIKit

class movieVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoview: UIView!
    
    var movie: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoview.frame.size.height + infoview.frame.origin.y)
        
        titleLabel.text = movie["title"] as! String
        overview.text = movie["overview"] as! String
        overview.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterpath = movie?["poster_path"] as? String {
            let imageURL = URL(string: baseURL + posterpath)
            posterImg.setImageWith(imageURL!)
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
