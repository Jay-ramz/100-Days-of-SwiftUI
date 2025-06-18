//
//  FileManager-DocumentsDirectory.swift
//  FlashZilla
//
//  Created by Jay Ramirez on 6/17/25.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
