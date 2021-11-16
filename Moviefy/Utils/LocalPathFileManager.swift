//
//  FileManager.swift
//  Moviefy
//
//  Created by A-Team Intern on 15.11.21.
//

import UIKit

class LocalPathFileManager {
    static func getImage(at path: URL) -> UIImage? {
        return try? UIImage(data: Data(contentsOf: path))
    }
    
    static func saveData(path: URL, data: Data) {        
        try? data.write(to: path)
    }
    
}
