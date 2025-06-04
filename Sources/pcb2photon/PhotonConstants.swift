import Foundation

/// Common constants used throughout the photon file generation.
enum PhotonConstants {
    /// Default photon image width in pixels.
    static let imageWidth: UInt32 = 1440
    /// Default photon image height in pixels.
    static let imageHeight: UInt32 = 2560

    /// Default PCB thickness in millimeters.
    static let pcbThickness: Float = 1.6

    /// Default exposure time for a layer in seconds.
    static let exposure: Float = 15.0

    /// Default printer volume sizes in millimeters.
    static let printSizeX: Float = 68.04
    static let printSizeY: Float = 120.96
    static let printSizeZ: Float = 5.0

    /// Additional header configuration.
    static let bottomExposureTime: Float = 0.0
    static let offTime: Float = 0.0
    static let numberOfBottomLayers: UInt32 = 0
    static let numberOfLayers: UInt32 = 1

    /// Prefix bytes for photon headers.
    static let headerMagic: [UInt8] = [0x19,0x00,0xFD,0x12,0x01,0x00,0x00,0x00]

    /// Generic 8 and 12 byte padding blocks.
    static let padding8 = [UInt8](repeating: 0x00, count: 8)
    static let padding12 = [UInt8](repeating: 0x00, count: 12)

    /// Blocks of bytes with unknown meaning kept for completeness.
    static let unknownBlock1: [UInt8] = [0x6C,0x00,0x00,0x00,0xAC,0xF0,0x00,0x00]
    static let unknownBlock2: [UInt8] = [0xD0,0xE0,0x00,0x00,0x00,0x00,0x00,0x00]
    static let unknownBlock3: [UInt8] = [0x01,0x00,0x00,0x00]
    static let unknownBlock4: [UInt8] = [0x33,0x04,0x00,0x00,0xE6,0x00,0x00,0x00]
    static let unknownBlock5: [UInt8] = [0x8C,0x00,0x00,0x00,0x44,0xE0,0x00,0x00]
}
