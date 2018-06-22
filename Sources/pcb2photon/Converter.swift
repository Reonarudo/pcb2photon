//
//  Converter.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 17.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//

import Foundation
import SGLImage

struct ConversionOptions {
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
    var conversionOptions : ConversionOptions = ConversionOptions()
    var filesToConvert : [String]       = []
    
    func staticMode() {
        do {
            try readParameters()
            
            let files = Array(zip(filesToConvert, conversionOptions.output))
            var allFiles = filesToConvert.map{return ($0, $0)}
            allFiles.replaceSubrange(0..<files.count, with: files)
            try files.forEach{try convert($0,into: $1)}
            
        } catch OptionError.invalidValue(let option) {
            consoleIO.writeMessage("01 Invalid value for \(option).", to: .error)
            exit(EXIT_FAILURE)
        } catch OptionError.invalidOption(let option){
            consoleIO.writeMessage("02 Unknown option \(option)", to: .error)
            consoleIO.printUsage()
            exit(EXIT_FAILURE)
        }catch OptionError.noInputFiles{
            consoleIO.writeMessage("03 No input files specified.", to: .error)
            exit(EXIT_FAILURE)
        }catch ConvertError.fileNotFound(let file){
            consoleIO.writeMessage("04 File not found. \(file)", to: .error)
            exit(EXIT_FAILURE)
        }catch{
            consoleIO.writeMessage("-1 Unexpected error: \(error).", to: .error)
            exit(EXIT_FAILURE)
        }
        
        
        
    }
    
    private func convert(_ fileName:String, into newFile:String?=nil) throws{
        //Get file path
        let fileURL:URL = try getPath(to: fileName)
        //Fetch file data
        //let fileData = try Data(contentsOf: fileURL)
        
        
        let fileData = try SGLImageConverter(fileURL, options: conversionOptions).convert()
        
        if let newFileName:String = newFile {
            let pathURL = fileURL.deletingLastPathComponent()
            try fileData.decodedData.write(to: pathURL.appendingPathComponent(newFileName))
        }else{
            let pathURL = fileURL.deletingPathExtension()
            try fileData.decodedData.write(to:pathURL.appendingPathExtension("photon"))
        }
        
        
    }
    
    //
    private func fileDecoderFactory(_ file:Data) -> ImageFileConverter?{
        return nil
    }
    
    //util function to fetch the file full path
    private func getPath(to file:String) throws ->URL{
        let fileManager = FileManager.default
        let fileURL = URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent(file)
        if !fileManager.fileExists(atPath: fileURL.path){
            throw ConvertError.fileNotFound(fileName: file)
        }
        return fileURL
    }
    
    //Reads the parameters into the conversionOptions struct and filesToConvert list
    func readParameters() throws{
        let argCount = CommandLine.argc
        var i = 1
        while i < argCount {
            let argument = CommandLine.arguments[i]
            if argument.first == "-"{
                let (option, value) = getOption(String(argument.dropFirst().first!))
                switch option {
                case .threshold:
                    guard i+1 < argCount, let arg :Float = Float(CommandLine.arguments[i+1]), arg > 0, arg < 1 else{
                        throw OptionError.invalidValue(option: value)
                    }
                    self.conversionOptions.threshold = arg
                    i+=1
                case .alignment:
                    guard i+1 < argCount else{
                        throw OptionError.invalidValue(option: value)
                    }
                    let arg :ImageAlignment = ImageAlignment(value: CommandLine.arguments[i+1])
                    guard arg != .unknown else{
                        throw OptionError.invalidValue(option: value)
                    }
                    self.conversionOptions.alignment = arg
                    i+=1
                case .scaling:
                    guard i+1 < argCount else{
                        throw OptionError.invalidValue(option: value)
                    }
                    let arg :ImageScaling = ImageScaling(value: CommandLine.arguments[i+1])
                    guard arg != .unknown else{
                        throw OptionError.invalidValue(option: value)
                    }
                    
                    if arg != .scaleBy {
                        self.conversionOptions.scaling = arg
                        i+=1
                    }else{
                        guard i+1 < argCount, let arg :Float = Float(CommandLine.arguments[i+1]), arg > 0, arg < 1 else{
                            throw OptionError.invalidValue(option: value)
                        }
                    }
                    
                case .pcbThickness:
                    guard i+1 < argCount, let arg :Float = Float(CommandLine.arguments[i+1]), arg > 0 else{
                        throw OptionError.invalidValue(option: value)
                    }
                    self.conversionOptions.pcbThickness = arg
                    i+=1
                case .output:
                    guard filesToConvert.count>0 else{
                        throw OptionError.noInputFiles
                    }
                    var newFileNames : [String] = []
                    i+=1
                    while i < min(filesToConvert.count, Int(argCount)){
                        newFileNames.append(CommandLine.arguments[i])
                        i+=1
                    }
                case .exposure:
                    guard i+1 < argCount, let arg :Float = Float(CommandLine.arguments[i+1]), arg > 0 else{
                        throw OptionError.invalidValue(option: option.rawValue)
                    }
                    self.conversionOptions.exposure = arg
                    i+=1
                case .unknown:
                    throw OptionError.invalidOption(option: value)
                }
            }else{
                filesToConvert.append(argument)
            }
            i+=1
        }
    }
    
    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    func readOptions(_ arguments:[String])->ConversionOptions{
        return ConversionOptions()
    }
    
    func isSupported(file type:String)->Bool{
        //TODO
        return false
    }
}
