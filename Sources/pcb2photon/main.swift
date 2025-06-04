//
//  main.swift
//  pcb2photon
//
//  Created by Leonardo Marques on 17.05.18.
//  Copyright © 2018 LeMa. All rights reserved.
//
// Image to .photon file converter

import Foundation
import pcb2photonlib

let converter = Converter()

if CommandLine.argc < 2 {
    //TODO: Handle interactive mode
} else {
    converter.staticMode()
}


