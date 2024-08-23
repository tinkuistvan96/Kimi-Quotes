//
//  QuoteCellViewModel.swift
//  KimiQuote
//
//  Created by Tinku István on 23/08/2024.
//

import UIKit

final class QuoteCellViewModel: Hashable {
    let quoteText: String
    let imageName: String
    
    init(quoteText: String, imageName: String) {
        self.quoteText = quoteText
        self.imageName = imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(quoteText)
        hasher.combine(imageName)
    }
    
    static func == (lhs: QuoteCellViewModel, rhs: QuoteCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
