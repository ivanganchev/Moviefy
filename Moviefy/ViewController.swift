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
    var moviesColelctionViewHelper: MoviesCollectionViewHelper?
    var movies: Array<Movie> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.moviesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 500), collectionViewLayout: layout)
        self.view.addSubview(self.moviesCollectionView!)
        self.moviesColelctionViewHelper = MoviesCollectionViewHelper()
        self.moviesCollectionView?.dataSource = self.moviesColelctionViewHelper
        self.moviesCollectionView?.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesColelctionViewHelper?.fetchMovies()
        DispatchQueue.main.async {
            self.moviesCollectionView?.reloadData()
        }
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

