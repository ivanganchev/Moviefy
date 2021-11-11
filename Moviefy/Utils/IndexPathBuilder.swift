//
//  IndexPathBuilder.swift
//  Moviefy
//
//  Created by A-Team Intern on 10.11.21.
//

import Foundation

class IndexPathBuilder {
    static func getIndexPathForHiddenContent(oldCount: Int, newCount: Int) -> [IndexPath] {
        var paths = [IndexPath]()
        for item in oldCount..<newCount {
            let indexPath = IndexPath(row: item, section: 0)
            paths.append(indexPath)
        }
//        print("getIndexPathForPrefetchedMovies - old - ", oldMoviesCount)
//        print("getIndexPathForPrefetchedMovies - new - ", newMoviesCount)
//        print("getIndexPathForPrefetchedMovies - current - ", self.categoryCollectionViewDataSource.getFilteredMovies().count)
        return paths
    }
}
