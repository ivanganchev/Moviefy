//
//  GenrePickerHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 20.10.21.
//

import Foundation

class GenrePickerHelper {
    static func getUnselectedGenre(rowNumber: Int, allGenres: [String], selectedGenres: [String]) -> Int? {
        guard selectedGenres.count < allGenres.count else {
            return 0
        }
        
        var index: Int? = nil
        let firstHalf: [Int] = Array(0..<rowNumber).reversed()
        let secondHalf: [Int] = Array((rowNumber + 1)...allGenres.count)
        
        if selectedGenres.contains(allGenres[rowNumber]) {
            for(firstHalfIndex, secondHalfIndex) in zip(firstHalf, secondHalf) {
                if !(selectedGenres.contains(allGenres[firstHalfIndex])) {
                    index = firstHalfIndex
                    break
                } else if !(selectedGenres.contains(allGenres[secondHalfIndex])) {
                    index = secondHalfIndex
                    break
                }
            }
            
            if index == nil {
                if firstHalf.count < secondHalf.count {
                    for i in (secondHalf[firstHalf.count]...secondHalf.count) {
                        if !(selectedGenres.contains(allGenres[i])) {
                            index = i
                            break
                        }
                    }
                } else {
                    for i in (0...firstHalf[secondHalf.count]).reversed() {
                        if !(selectedGenres.contains(allGenres[i])) {
                            index = i
                            break
                        }
                    }
                }
            }
        } else {
            index = rowNumber
        }
        
        return index
    }
}
