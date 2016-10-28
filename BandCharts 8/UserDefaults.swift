//
//  UserDefaults.swift
//  BandCharts 8
//
//  Created by Jim Hubbard on 10/24/16.
//  Copyright © 2016 Jim Hubbard. All rights reserved.
//


import Cocoa
import Foundation


enum UserDefaultAction {
    
    case write
    case read
}



enum myDataTypes {
    
    case mString
    case mNumber
    case mDate
    case mArray
    case mDictionary
    case mData
    
}

struct FontStorageStruct {
    var fontName: String = ""
    var fontSize: String = ""
}



//Want to store default font, color, highlight
//More....
let userDefaults = UserDefaults.standard
let prefs = Bundle.main.path(forResource: "PreferenceList", ofType: "plist")
let dict = NSDictionary(contentsOfFile: prefs!)



enum UserDefaultErrors: Error {
    
    case nilValue
    case badValue
}


func StartUpDefaults() {
    
    //Set the plist file for defaults that dont exist yet
    userDefaults.set(dict, forKey: "defaults")
    userDefaults.synchronize()
}

func setUserDefaults(_ value: AnyObject, key: String) {
    
    userDefaults.set(value,forKey: key)
    
}

func getUserDefaults(_ key: String) ->  Int {
    
    if let value = userDefaults.value(forKey: "aBool") as? NSNumber {
        
        print("value =   \(value)" )
        
    }
    
    if let value = userDefaults.value(forKey: key)! as? NSNumber {
        
        print("value =   \(value)" )
        
    }
    
    return 1
}

func writePreferences(_ identity: String, value: AnyObject) {
    
    userDefaults.setValue(value, forKey: identity)
    
}

func writePreferences(_ identity: String, value: [String]) {
    
    //Write an array to User Preferences
    userDefaults.set(value, forKey: identity)
    
}

func readPreferences(_ identity: String, defaultValue: String) -> NSString {
    
    if let value = userDefaults.value(forKey: identity) as! NSString?{
        return value
    }
    return defaultValue as NSString
}

func readPreferences(_ id: String, defaultValue: [String]) -> [NSString] {
    
    if let value = userDefaults.object(forKey: id) {
        return value as! [NSString]
    }
    return defaultValue as [NSString]
}


func SetAColor(_ key: String, color: NSColor) {
    
    //let userSelectedColor : NSData? = (NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData)
    
    //if (userSelectedColor != nil) {
    //let colorToSetAsDefault : NSColor = NSColor.redColor()
    
    let data : Data = NSKeyedArchiver.archivedData(withRootObject: color)
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
    //print("SET DEFAULT USER COLOR TO RED")
    //}
}

func GetAColor(_ key: String) -> NSColor{
    
    let userDefaultColor = NSColor.red
    
    if let userSelectedColorData = UserDefaults.standard.object(forKey: key) as? Data {
        if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData) as? NSColor {
            return userSelectedColor
        }
        return userDefaultColor
    }
    return userDefaultColor
}


func ReadFont(_ key: String) -> NSFont{
    
    //Lets write the font as an array of fontname and size
    let fontArray: [String] = ["OpusChordsStd","13"]
    var fontDesc =  readPreferences(key,defaultValue: fontArray)
    
    let FontName = fontDesc[0] as String
    let FontSize = fontDesc[1] as String
    
    return GetAFont(FontName, Size: FontSize)
}

func ReadFont(_ key: String) -> [String]{
    
    //Lets write the font as an array of fontname and size
    let fontArray: [String] = ["OpusChordsStd","13"]
    let fontDesc =  readPreferences(key,defaultValue: fontArray)
    
    return fontDesc as [String]
}


func WriteFont(_ key: String, FontName: String, FontSize: String) {
    
    //Lets write the font as an array of fontname and size
    var fontArray: [String] = []
    
    fontArray.append(FontName)
    fontArray.append(FontSize)
    
    writePreferences(key, value: fontArray)
    //writePreferences(chordSize.identifier!, value: chordSize.stringValue)
    
}



func GetAFont(_ fontName: String, Size: String) -> NSFont {
    
    let str = Size
    let n = NumberFormatter().number(from: str)
    let f = CGFloat(n!)
    return  NSFont(name: fontName, size: f)!
    
}



