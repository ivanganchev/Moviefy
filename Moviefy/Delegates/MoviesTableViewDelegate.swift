//
//  MoviesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 2.09.21.
//

import Foundation
import UIKit

protocol MoviesTableViewButtonTapDelegate: AnyObject {
    func switchView(path: EndPoint.MovieCategoryEndPoint, categoryType: String)
    func setClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie)
}

class MoviesTableViewDelegate: NSObject, UITableViewDelegate, MoviesTableViewCellDelegate {
    var moviesSections: [String] = ["Top Rated", "Popular", "Upcoming", "Now Playing"]
    weak var delegate: MoviesTableViewButtonTapDelegate?
    var movieCategoryCases: [EndPoint.MovieCategoryEndPoint] = EndPoint.MovieCategoryEndPoint.allCases
    var path: EndPoint.MovieCategoryEndPoint?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = ThumbnailImageProperties.getSize()
        return size.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let moviesTableViewHeader = MoviesTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        moviesTableViewHeader.textLabel = self.moviesSections[section]
        moviesTableViewHeader.button.addTarget(self, action: #selector(MoviesTableViewDelegate.headerButtonTapped), for: .touchUpInside)
        moviesTableViewHeader.button.tag = section
        
        return moviesTableViewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    @objc func headerButtonTapped(sender: UIButton) {
        delegate?.switchView(path: self.movieCategoryCases[sender.tag], categoryType: self.moviesSections[sender.tag])
    }
    
    func getClickedCollectionViewCell(cell: MoviesCollectionViewCell?, movie: Movie) {
        self.delegate?.setClickedCollectionViewCell(cell: cell, movie: movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? MoviesTableViewCell
        cell?.delegate = self
    }
}
