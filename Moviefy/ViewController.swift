//
//  ViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var moviesCollectionView: UICollectionView?
    var moviesTableViewDataSource: MoviesTableViewDataSource?
    var movies: Array<Movie> = []
    var moviesTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moviesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        self.moviesTableViewDataSource = MoviesTableViewDataSource()
        self.moviesTableView?.dataSource = self.moviesTableViewDataSource
        self.moviesTableView?.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        self.view.addSubview(self.moviesTableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesTableViewDataSource?.fetchMovies(completion: {
            DispatchQueue.main.async {
                self.moviesTableView?.reloadData()
            }
        })
    }
}

//MARK: Server side
    
extension ViewController {
}

//MARK: UI Update

extension ViewController {
    func updateCollectionView() {
    }
}

