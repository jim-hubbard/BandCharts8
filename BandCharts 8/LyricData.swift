//
//  LyricData.swift
//  BandCharts 8
//
//  Created by Jim Hubbard on 9/29/16.
//  Copyright © 2016 Jim Hubbard. All rights reserved.
//

import Foundation


class LyricLine {
    
    
    /*The purpose of this class is to hold the parsed lyric sheet into many parts.
     Lines
     Words
     Chords
     Positions of Chords
     Line Type - Title, Subtitle, Lyric, Chord, Comment, Whatever else I need
     Font (Sizing info)
     */
    
    enum lineType {
        
        case Title
        case SubTitle
        case Lyrics
        case Chords
        case Comment
        case StartOfChorus
        case EndOfChorus
        
    }
    
    // Data encapsulation
    fileprivate(set) var lineType:lineType
    fileprivate(set) var lineLength: CGSize
    fileprivate(set) var lineUnformated:String
    //fileprivate(set) var lineFormated:NSMutableAttributedString
    fileprivate(set) var lineFormated:String
    fileprivate(set) var lineWords:[LyricWords]
    fileprivate(set) var lineChords:[LyricChords]
    
    
    init(lineType:lineType, lineUnformated:String, lineFormated: String, lineChords:[LyricChords],lineWords:[LyricWords]) {
        
        
        self.lineType = lineType
        self.lineLength = lineUnformated.size()
        self.lineUnformated = lineUnformated
        self.lineFormated = lineFormated
        self.lineWords = lineWords
        self.lineChords = lineChords
        
        
    }
    
    
}


class LyricChords {
    
    //This class stores all the chords found in a line and the position in the line
    //Position is based on the font width (CGSize)
    
    fileprivate(set) var chord:String
    fileprivate(set) var chordAboveChar: Int
    fileprivate(set) var chordAboveCharSize: CGFloat
    fileprivate(set) var chordWidth: CGFloat
    fileprivate(set) var chordPosition: CGFloat
    fileprivate(set) var chordEndPosition: CGFloat
    
    init(chord:String, chordAboveChar:Int, chordAboveCharSize: CGFloat, chordWidth: CGFloat, chordPosition:CGFloat,chordEndPosition:CGFloat) {
        
        self.chord = chord
        self.chordAboveChar = chordAboveChar
        self.chordAboveCharSize = chordAboveCharSize
        self.chordWidth = chordWidth
        self.chordPosition = chordPosition
        self.chordEndPosition = chordEndPosition

        
    }
}

class LyricWords {
    
    //This class stores all the words found in a line and the position in the line
    //Position is based on the font width (CGSize)
    
    fileprivate(set) var word:String
    fileprivate(set) var spacesBefore: String
    fileprivate(set) var wordPosition: CGFloat
    
    init(word:String, wordPosition:CGFloat) {
        
        self.word = word
        self.spacesBefore = ""
        self.wordPosition = wordPosition
        
        
    }
}

