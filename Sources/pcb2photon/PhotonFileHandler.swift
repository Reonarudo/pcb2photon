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
    private var templatePhotonFile1440x2560: Data {
        guard let path = Bundle.main.path(forResource: "template", ofType: "photon"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return Data()
        }
        return data
    }
    private var header:Data{
        get{
            var sig:[UInt8] = PhotonConstants.headerMagic

            let pcbThickness : Float        = PhotonConstants.pcbThickness
            let exposure : Float            = PhotonConstants.exposure

            let printSizeX:Float = PhotonConstants.printSizeX
            let printSizeY:Float = PhotonConstants.printSizeY
            let printSizeZ:Float = PhotonConstants.printSizeZ

            let bottomExposureTime:Float = PhotonConstants.bottomExposureTime
            let offTime:Float = PhotonConstants.offTime
            let numberOfBottomLayers:UInt32 = PhotonConstants.numberOfBottomLayers
            let sizeX:UInt32 = PhotonConstants.imageWidth
            let sizeY:UInt32 = PhotonConstants.imageHeight

            let numberOfLayers:UInt32 = PhotonConstants.numberOfLayers
            
            sig.append(contentsOf: printSizeX.asByteArray())
            sig.append(contentsOf: printSizeY.asByteArray())
            sig.append(contentsOf: printSizeZ.asByteArray())
            
            sig.append(contentsOf: PhotonConstants.padding12)
            
            sig.append(contentsOf: pcbThickness.asByteArray())
            
            sig.append(contentsOf: exposure.asByteArray())
            
            sig.append(contentsOf: bottomExposureTime.asByteArray())
            
            sig.append(contentsOf: offTime.asByteArray())
            
            sig.append(contentsOf: numberOfBottomLayers.asByteArray())
            
            sig.append(contentsOf: sizeX.asByteArray())
            sig.append(contentsOf: sizeY.asByteArray())
            
            sig.append(contentsOf: PhotonConstants.unknownBlock1)
            
            sig.append(contentsOf: numberOfLayers.asByteArray())
            

            sig.append(contentsOf: PhotonConstants.unknownBlock2)
            sig.append(contentsOf: PhotonConstants.unknownBlock3)
            
            sig.append(contentsOf: PhotonConstants.padding8) // padding
            sig.append(contentsOf: PhotonConstants.padding8) // padding
            sig.append(contentsOf: PhotonConstants.padding8) // padding
            
            sig.append(contentsOf: PhotonConstants.unknownBlock4)
            sig.append(contentsOf: PhotonConstants.unknownBlock5)
            
            sig.append(contentsOf: PhotonConstants.padding8) // padding
            sig.append(contentsOf: PhotonConstants.padding8) // padding
            
            return Data(bytes: sig)
        }
    }
    
    func data() -> Data{
        var fileData:Data = self.header
        fileData.append(self.templatePhotonFile1440x2560)
        return fileData
    }

}
