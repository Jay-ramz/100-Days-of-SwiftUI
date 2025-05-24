//
//  Image+Data.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import Foundation
import SwiftUI
import UIKit

extension Image {
    init?(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
