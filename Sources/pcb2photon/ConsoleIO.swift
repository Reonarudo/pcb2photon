//
//  ConsoleIO.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 17.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//
//  Created based on https://www.raywenderlich.com/163134/command-line-programs-macos-tutorial-2

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO{
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) [-h] [-t threshold-value] [-a alignment-options] [-s image-scaling] [-pcb thickness] [-e exposure-time] filename [filename2 [...]] [output_filename] [-o output_filename2 [...]]")
        writeMessage("\(executableName) filename will automatically convert the image")
        writeMessage("Please check https://github.com/Reonarudo/pcb2photon for more detailed usage information.")
    }
}
