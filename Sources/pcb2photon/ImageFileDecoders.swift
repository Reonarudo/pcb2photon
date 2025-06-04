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

struct PCBImage {
    var decodedData:Data
}

protocol ImageFileConverter {
    func convert() -> PCBImage;
}


class SGLImageConverter: ImageFileConverter {
    let config : ConversionOptions
    /// Width of the generated photon image in pixels.
    let outImageWidth = Int(PhotonConstants.imageWidth)
    /// Height of the generated photon image in pixels.
    let outImageHeight = Int(PhotonConstants.imageHeight)
    
    var loader:SGLImageLoader
    
    init(_ fileURL : URL, options opt: ConversionOptions) throws {
        self.loader = SGLImageLoader(fromFile: fileURL.path)
        config = opt
        guard loader.error == nil else {
            throw ConvertError.internalConverterError(error: loader.error ?? "Unknown error")
        }
    }
    
    class Bucket{
        var byte:UInt8 = 0
        var color:Int{
            get{
                return Int((byte&0x80)>>7)
            }}
        init(color:Int) {
            if(color == 1){
                byte=0x81
            }else{
                byte=0x01
            }
        }

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
    
    func convert() -> PCBImage {
        let img = SGLImageGreyscale<UInt8>(loader)
        let totalPixels = img.width * img.height
        var buckets:[Bucket] = []
        img.withUnsafeMutableBufferPointer { (bufferPt) in
            let tresholdValue = UInt8(255*config.threshold)
            var processedPixels = 0
            
            while processedPixels < totalPixels{
                bufferPt.forEach({ (pixelValue) in
                    let currTreshColor =  (pixelValue < tresholdValue ? 1 : 0)
                    if let lastBucket = buckets.last{
                        if lastBucket.color == currTreshColor{
                            if !lastBucket.add(){
                                buckets.append(Bucket(color: currTreshColor))
                            }
                        }else{
                            buckets.append(Bucket(color: currTreshColor))
                        }
                    }else{
                        buckets.append(Bucket(color: currTreshColor))
                    }
                    processedPixels+=1
                })
            }
            
        }
        let imageData:Data = Data(bytes: buckets.map{$0.byte})
        var fileData:Data = PhotonFile().data()
        
        //Prepare and append imag array metadata
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
        return PCBImage(decodedData: fileData)
    }
    
    
}

