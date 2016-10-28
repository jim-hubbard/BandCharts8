//
//  DirectoryData.swift
//  BandCharts
//
//  Created by Jim Hubbard on 11/13/15.
//  Copyright © 2015 Jim Hubbard. All rights reserved.
//

import Foundation
import AppKit


class DirectoryData: NSObject {
    var fileName: String
    
    override init() {
        self.fileName = String()
    }
    
    init(fileName: String) {
        self.fileName = fileName
    }
}