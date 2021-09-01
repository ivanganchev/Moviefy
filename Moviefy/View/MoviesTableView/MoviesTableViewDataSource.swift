//

import Foundation
import UIKit

class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    var movies: Array<Movie> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as! MoviesTableViewCell
        cell.movies = self.movies
        return cell
    }
}

//Mark: Data fetching

extension MoviesTableViewDataSource {
    func fetchMovies(completion: @escaping () ->()) {
        MoviesService().fetchMoviesByCategory(page: "1", completion: { result in
            switch result {
            case .success(let moviesResponse):
                self.movies = moviesResponse.movies!
                completion()
            case .failure(let err):
                print(err)
            }
        })
    }
}

    
