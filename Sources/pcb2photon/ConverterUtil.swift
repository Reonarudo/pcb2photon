//
//  ConverterUtil.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 17.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//

import Foundation

enum OptionError: Error{
    case invalidValue(option:String)
    case invalidOption(option:String)
    case noInputFiles
}

enum ConvertError: Error{
    case fileNotFound(fileName:String)
    case fileTypeNotSupported(file:String)
}

enum OptionType: String {
    case threshold      = "t"
    case alignment      = "a"
    case scaling        = "s"
    case pcbThickness   = "p"
    case output         = "o"
    case exposure       = "e"
    case unknown
    
    init(value: String) {
        switch value {
        case "t": self  = .threshold
        case "a": self  = .alignment
        case "s": self  = .scaling
        case "p": self  = .pcbThickness
        case "o": self  = .output
        case "e": self  = .exposure
        default: self   = .unknown
        }
    }
}

enum ImageAlignment: String {
    case center      = "c"
    case upperLeft   = "ul"
    case lowerLeft   = "ll"
    case upperRight  = "ur"
    case lowerRight  = "lr"
    case centerLeft  = "cl"
    case centerRight = "cr"
    case centerUp    = "cu"
    case centerDown  = "cd"
    case unknown
    
    init(value: String) {
        switch value {
        case "c": self   = .center
        case "ul": self  = .upperLeft
        case "ll": self  = .lowerLeft
        case "ur": self  = .upperRight
        case "lr": self  = .lowerRight
        case "cl": self  = .centerLeft
        case "cr": self  = .centerRight
        case "cu": self  = .centerUp
        case "cd": self  = .centerDown
            
        default: self   = .unknown
        }
    }
}

enum ImageScaling: String {
    case original       = "o"
    case verticalFit    = "v"
    case horizontalFit  = "h"
    case stretchFit     = "f"
    case scaleBy        = "n"
    case unknown
    
    init(value: String) {
        switch value {
        case "o": self  = .original
        case "v": self  = .verticalFit
        case "h": self  = .horizontalFit
        case "f": self  = .stretchFit
        case "n": self  = .scaleBy
            
        default: self   = .unknown
        }
    }
}
