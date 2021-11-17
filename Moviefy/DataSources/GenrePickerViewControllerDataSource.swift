//
//  GenrePickerViewControllerDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 13.10.21.
//

import UIKit

class GenrePickerViewControllerDataSource: NSObject, UIPickerViewDataSource {
    static var genres: [String] {
        return Array((MoviesService.genres.values)).sorted(by: {$0.compare($1) == .orderedAscending})
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenrePickerViewControllerDataSource.genres.count
    }
}

extension GenrePickerViewControllerDataSource {
    func getGenres() -> [String] {
        return GenrePickerViewControllerDataSource.genres
    }

    func getGenre(at index: Int) -> String? {
        if index < GenrePickerViewControllerDataSource.genres.count && index >= 0 {
            return GenrePickerViewControllerDataSource.genres[index]
        }
        return nil
    }
}
