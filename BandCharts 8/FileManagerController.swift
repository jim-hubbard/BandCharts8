//
//  FileManagerController.swift
//  BandCharts
//
//  Created by Jim Hubbard on 11/13/15.
//  Copyright © 2015 Jim Hubbard. All rights reserved.
//

import Foundation

// Get contents of directory at specified path, returning (filenames, nil) or (nil, error)
let fm = FileManager.default

func contentsOfDirectoryAtPath(_ PassedPath: String) ->[String]? {
    
    //
    do {
        let items = try fm.contentsOfDirectory(atPath: PassedPath)
        
        
        return items
        
    } catch {
        // failed to read
    }
    //If you get this far
    return nil
}

    // Get all the files in a directory and filter by extension
    func contentsOfDirectoryAtPath(_ passedPath: String, Extension:String) ->[String]? {
        
        let fm = FileManager.default
        //let path = NSBundle.init(path: PassedPath)
        do {
            let items = try fm.contentsOfDirectory(atPath: passedPath)
            
            let names = items.filter { $0.hasSuffix("." + Extension) }
            return names
            
        } catch {
            // failed to read directory
            
        }
        //If you get this far
        return nil
        
    }


func contentsOfFileAtPath(_ passedPath: String) -> String

{

if fm.fileExists(atPath: passedPath) {
    //print("File exists")
    do {
        let readFile = try String(contentsOfFile: passedPath, encoding: String.Encoding.utf8)
        
        return readFile
        
        //print("\(readFile)")
        // the above prints "some text"
    } catch let error as NSError {
        print("Error: \(error)")
    }
}
else {
        print("File does not exist")

    }
        return "File Does Not Exist"
    
}


