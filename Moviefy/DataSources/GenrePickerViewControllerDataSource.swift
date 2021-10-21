//
//  GenrePickerViewControllerDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 13.10.21.
//

import Foundation
import UIKit

class GenrePickerViewControllerDataSource: NSObject, UIPickerViewDataSource {
    var genres = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genres.count
    }
}
