//
//  ImageFileDecoders.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 18.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//

import Foundation

struct PCBImage {
    var decodedData:Data
}

protocol ImageFileDecoder {
    func decode(_ fileData:Data) -> PCBImage;
}
