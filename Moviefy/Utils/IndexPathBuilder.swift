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
        
        guard oldCount < newCount, oldCount >= 0, newCount >= 0 else {
            return paths
        }
        
        for item in oldCount..<newCount {
            let indexPath = IndexPath(row: item, section: 0)
            paths.append(indexPath)
        }
        
        return paths
    }
}
