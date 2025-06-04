//
//  ImageFileDecoders.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 18.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//

import Foundation
import SGLImage

enum ImageDecoderType{
    case png
}

/// Result of an image conversion containing the raw Photon file bytes.
struct PhotonEncodedData {
    /// Encoded binary data for the Photon file.
    var decodedData: Data
}

/// Defines an interface for converting image files into Photon data.
protocol PhotonImageConverter {
    func convert() -> PhotonEncodedData
}


/// Image converter using the SwiftGL library for decoding image data.
class SwiftGLPhotonConverter: PhotonImageConverter {
    let config : ConversionOptions
    let outImageWidth = 1440
    let outImageHeight = 2560
    
    var loader:SGLImageLoader
    
    /// Creates a new converter for the image at `fileURL`.
    /// - Parameters:
    ///   - fileURL: Location of the source image file.
    ///   - opt: Conversion configuration options.
    init(_ fileURL: URL, options opt: ConversionOptions) throws {
        self.loader = SGLImageLoader(fromFile: fileURL.path)
        config = opt
        guard loader.error == nil else {
            throw ConvertError.internalConverterError(error : loader.error!)
        }
    }
    
    /// Helper used for run-length encoding of monochrome image data.
    class RunLengthBucket {
        /// Encoded byte storing the run length and pixel color.
        var byte: UInt8 = 0

        /// Current pixel color represented by the bucket (0 or 1).
        var color: Int {
            return Int((byte & 0x80) >> 7)
        }

        init(color: Int) {
            if color == 1 {
                byte = 0x81
            } else {
                byte = 0x01
            }
        }

        /// Increments the run length counter.
        /// - Returns: `true` when the bucket can still be increased, `false` when full.
        func add() -> Bool {
            let head = byte&0x80
            let body = byte&0x7F
            if(body<125){
                byte = head|(body+1)
                return true
            }else{
                return false
            }
        }
    }
    
    /// Converts the loaded image into Photon-encoded data.
    func convert() -> PhotonEncodedData {
        let img = SGLImageGreyscale<UInt8>(loader)
        let totalPixels = img.width * img.height
        var buckets:[RunLengthBucket] = []
        img.withUnsafeMutableBufferPointer { (bufferPt) in
            let tresholdValue = UInt8(255*config.threshold)
            var processedPixels = 0
            
            while processedPixels < totalPixels{
                bufferPt.forEach({ (pixelValue) in
                    let currTreshColor =  (pixelValue < tresholdValue ? 1 : 0)
                    if let lastBucket = buckets.last{
                        if lastBucket.color == currTreshColor{
                            if !lastBucket.add(){
                                buckets.append(RunLengthBucket(color: currTreshColor))
                            }
                        }else{
                            buckets.append(RunLengthBucket(color: currTreshColor))
                        }
                    }else{
                        buckets.append(RunLengthBucket(color: currTreshColor))
                    }
                    processedPixels+=1
                })
            }
            
        }
        let imageData:Data = Data(bytes: buckets.map{$0.byte})
        var fileData: Data = PhotonFile().fileContent()
        
        // Prepare and append image array metadata
        var layerHeight = config.pcbThickness
        let layerHeightData = Data(buffer: UnsafeBufferPointer(start: &layerHeight, count: 1))
        fileData.append(layerHeightData)
        
        var expTime = config.exposure
        let expTimeData = Data(buffer: UnsafeBufferPointer(start: &expTime, count: 1))
        fileData.append(expTimeData)
        
        var offTime = UInt32(0)
        let offTimeData = Data(buffer: UnsafeBufferPointer(start: &offTime, count: 1))
        fileData.append(offTimeData)
        
        var startPos = UInt32(fileData.count+24)
        let startPosData = Data(buffer: UnsafeBufferPointer(start: &startPos, count: 1))
        fileData.append(startPosData)
        
        var size = UInt32(imageData.count)
        let sizeData = Data(buffer: UnsafeBufferPointer(start: &size, count: 1))
        fileData.append(sizeData)
        
        let padding = [UInt32(0),UInt32(0),UInt32(0),UInt32(0)]
        padding.forEach{
            var val = $0
            let data = Data(buffer: UnsafeBufferPointer(start: &val, count: 1))
            fileData.append(data)
        }
        //Append image data
        fileData.append(imageData)
        return PhotonEncodedData(decodedData: fileData)
    }
    
    
}

