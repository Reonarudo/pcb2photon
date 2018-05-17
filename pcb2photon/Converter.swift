//
//  Converter.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 17.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//

import Foundation

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

struct FileOptions {
    //                              defaults:
    var threshold : Float           = 0.5
    var alignment : ImageAlignment  = .center
    var scaling : ImageScaling      = .original
    var scale : Float?              = nil
    var pcbThickness : Float        = 1.6 //mm
    var output : [String]           = []
    var exposure : Float            = 5.0 //seconds
}

class Converter{
    let consoleIO : ConsoleIO           = ConsoleIO()
    var conversionOptions : FileOptions = FileOptions()
    var filesToConvert : [String]       = []
    
    func staticMode() {
        let argCount = CommandLine.argc
        var i = 1
        while i < argCount {
            let argument = CommandLine.arguments[i]
            if argument.first == "-"{
                let (option, value) = getOption(String(argument.dropFirst().first!))
                switch option {
                    case .threshold:
                        guard i+1 < argCount, let val :Float = Float(CommandLine.arguments[i+1]), val>0, val<1 else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        self.conversionOptions.threshold = val
                        i+=1
                    case .alignment:
                        guard i+1 < argCount else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        let val :ImageAlignment = ImageAlignment(value: CommandLine.arguments[i+1])
                        guard val != .unknown else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        self.conversionOptions.alignment = val
                        i+=1
                    case .scaling:
                        guard i+1 < argCount else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        let val :ImageScaling = ImageScaling(value: CommandLine.arguments[i+1])
                        guard val != .unknown else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        
                        if val != .scaleBy {
                            self.conversionOptions.scaling = val
                            i+=1
                        }else{
                            guard i+1 < argCount, let val :Float = Float(CommandLine.arguments[i+1]), val>0, val<1 else{
                                consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                                break
                            }
                        }
                    
                    case .pcbThickness:
                        guard i+1 < argCount, let val :Float = Float(CommandLine.arguments[i+1]), val>0 else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        self.conversionOptions.pcbThickness = val
                        i+=1
                    case .output:
                        guard filesToConvert.count>0 else{
                            consoleIO.writeMessage("Error 02: No input files specified.")
                            break
                        }
                        var newFileNames : [String] = []
                        i+=1
                        while i < min(filesToConvert.count, Int(argCount)){
                            newFileNames.append(CommandLine.arguments[i])
                            i+=1
                        }
                    case .exposure:
                        guard i+1 < argCount, let val :Float = Float(CommandLine.arguments[i+1]), val>0 else{
                            consoleIO.writeMessage("Error 01: Invalid value for \(option).")
                            break
                        }
                        self.conversionOptions.exposure = val
                        i+=1
                    case .unknown:
                        consoleIO.writeMessage("Unknown option \(value)")
                        consoleIO.printUsage()
                }
            }else{
                filesToConvert.append(argument)
            }
            i+=1
            //consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
        }
        
    }
    
    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    func readOptions(_ arguments:[String])->FileOptions{
        return FileOptions()
    }
    
    func isSupported(file type:String)->Bool{
        //TODO
        return false
    }
}
