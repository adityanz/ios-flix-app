//
//  MoviesViewController.swift
//  flix
//
//  Created by Aditya Dixit on 9/26/20.
//

import UIKit

import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Properties= kind of like acessiable global variables
    
    //arrray of dictionary objects
    //create dictionary by defining string and values and the paranthesis for new/
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        //this function is run the first time the screen is loaded
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=33e2026c74eedd8ad0f0d75516adb826")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              // TODO: Get the array of movies
            self.movies = dataDictionary["results"] as! [[String:Any]]

            self.tableView.reloadData()
            print(dataDictionary)

            //access of the results
            //Cast as an array of dictionary
                // Get the list of movies and save in the view controller
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        //swift options,
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string:baseURL+posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Loading up the detail screen")
        //Casting as the UI table view sell
        let cell = sender as! UITableViewCell
        //Tableview gets the index from the cell
        let indexPath = tableView.indexPath(for: cell)!
        //get specific view for the movie.
        let movie = movies[indexPath.row]
        
        //segway controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        //deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

