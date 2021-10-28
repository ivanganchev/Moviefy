//

import UIKit

class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    private var moviesSections: [String] = ["Top Rated", "Popular", "Upcoming", "Now Playing"]
    private var movieCategoryCases: [EndPoint.MovieCategoryEndPoint] = EndPoint.MovieCategoryEndPoint.allCases
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as? MoviesTableViewCell else {
            return MoviesTableViewCell()
        }
        
        cell.movieCategoryPath = movieCategoryCases[indexPath.section].rawValue
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moviesSections.count
    }
}
