//
//  GenrePickerViewControllerDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 13.10.21.
//

import UIKit

class GenrePickerViewControllerDataSource: NSObject, UIPickerViewDataSource {
    private var genres = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genres.count
    }
}

extension GenrePickerViewControllerDataSource {
    func getGenres() -> [String] {
        return self.genres
    }
    
    func getGenre(at index: Int) -> String? {
        if index < self.genres.count {
            return self.genres[index]
        }
        return nil
    }
    
    func setGenres(genres: [String]) {
        self.genres = genres
    }
}
