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
    
    var imageName: String {
        guard let year = year else { return "kimiDefault" }
        
        switch year {
        case 2002..<2006:
            return "kimiMclaren"
        case 2007..<2009:
            return "kimiFerrari"
        case 2012..<2013:
            return "kimiLotus"
        case 2014..<2018:
            return "kimiFerrari"
        case 2019..<2021:
            return "kimiAlfa"
        default:
            return "kimiDefault"
        }
    }
}
