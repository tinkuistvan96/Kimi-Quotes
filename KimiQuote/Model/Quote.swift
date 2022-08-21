//
//  Quote.swift
//  KimiQuote
//
//  Created by Tinku István on 2022. 04. 24..
//

import Foundation
import UIKit

struct Quote: Codable {
    let id: Int
    let quote: String
    let year: Int?
}

struct QuoteViewModel {
    let quote: String
    let image: UIImage?
}

struct KimiImages {
    static let images = [
            UIImage(named: "kimi1"),
            UIImage(named: "kimi2"),
            UIImage(named: "kimi3"),
            UIImage(named: "kimi4"),
            UIImage(named: "kimi5"),
            UIImage(named: "kimi6"),
            UIImage(named: "kimi7")
    ]
    
    static func getImage() -> UIImage? {
        return images.randomElement() ?? nil
    }
}
