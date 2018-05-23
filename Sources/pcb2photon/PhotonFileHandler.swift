//
//  PhotonFileHandler.swift
//  SGLImage
//
//  Created by Leonardo Marques on 21.05.18.
//

import Foundation

extension Float{
    var asData:Data{
        get{
            var value = self
            let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
            return data
        }
    }
    func asByteArray() -> [UInt8] {
        return [UInt8](self.asData)
    }
}

extension UInt16{
    var asData:Data{
        get{
            var value = self
            let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
            return data
        }
    }
    func asByteArray() -> [UInt8] {
        return [UInt8](self.asData)
    }
}

extension UInt32{
    var asData:Data{
        get{
            var value = self
            let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
            return data
        }
    }
    func asByteArray() -> [UInt8] {
        return [UInt8](self.asData)
    }
}

class PhotonFile {
    private var templatePhotonFile1440x2560:Data {
        return try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "template", ofType: "photon") ?? ""))
    }
    private var header:Data{
        get{
            var sig:[UInt8] = [0x19,0x00,0xFD,0x12,0x01,0x00,0x00,0x00]
            
            let pcbThickness : Float        = 1.6 //mm
            let exposure : Float            = 15.0 //seconds
            
            let printSizeX:Float = 68.04
            let printSizeY:Float = 120.96
            let printSizeZ:Float = 5
            
            let bottomExposureTime:Float = 0.0
            let offTime:Float = 0.0
            let numberOfBottomLayers:UInt32 = 0
            let sizeX:UInt32 = 1440
            let sizeY:UInt32 = 2560
            
            let numberOfLayers:UInt32 = 1
            
            sig.append(contentsOf: printSizeX.asByteArray())
            sig.append(contentsOf: printSizeY.asByteArray())
            sig.append(contentsOf: printSizeZ.asByteArray())
            
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00]) // padding
            
            sig.append(contentsOf: pcbThickness.asByteArray())
            
            sig.append(contentsOf: exposure.asByteArray())
            
            sig.append(contentsOf: bottomExposureTime.asByteArray())
            
            sig.append(contentsOf: offTime.asByteArray())
            
            sig.append(contentsOf: numberOfBottomLayers.asByteArray())
            
            sig.append(contentsOf: sizeX.asByteArray())
            sig.append(contentsOf: sizeY.asByteArray())
            
            sig.append(contentsOf: [0x6C,0x00,0x00,0x00,0xAC,0xF0,0x00,0x00])
            
            sig.append(contentsOf: numberOfLayers.asByteArray())
            

            sig.append(contentsOf: [0xD0,0xE0,0x00,0x00,0x00,0x00,0x00,0x00])
            sig.append(contentsOf: [0x01,0x00,0x00,0x00])
            
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) // padding
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) // padding
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) // padding
            
            sig.append(contentsOf: [0x33,0x04,0x00,0x00,0xE6,0x00,0x00,0x00])
            sig.append(contentsOf: [0x8C,0x00,0x00,0x00,0x44,0xE0,0x00,0x00])
            
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) // padding
            sig.append(contentsOf: [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) // padding
            
            return Data(bytes: sig)
        }
    }
    
    func data() -> Data{
        var fileData:Data = self.header
        fileData.append(self.templatePhotonFile1440x2560)
        return fileData
    }

}
