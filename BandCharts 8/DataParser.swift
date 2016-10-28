//
//  DataParser.swift
//  BandCharts 8
//
//  Created by Jim Hubbard on 9/30/16.
//  Copyright © 2016 Jim Hubbard. All rights reserved.
//

import Foundation
import Cocoa

//Calibri

let chordFont: NSFont = GetAFont("Arial", Size: "18")
let lyricFont: NSFont = GetAFont("Arial", Size: "24")

class DataParser {


    let chordAttr: [String: AnyObject] = [NSFontAttributeName: chordFont,
                                          NSForegroundColorAttributeName: NSColor.red]
    let lyricAttr: [String: AnyObject] = [NSFontAttributeName: lyricFont,
                                          NSForegroundColorAttributeName: NSColor.blue]
    var lyrics = [LyricLine]()
    
    func fillLines(song: String) {

        var vLineType = LyricLine.lineType.Lyrics
        var vUnformatedLyric = ""
        
        // Enumerate lines in the string.
        song.enumerateLines { (line, stop) -> () in
            
            vLineType = self.getLineDirective(line)
            vUnformatedLyric = line
            
            let (chords, justWords) = self.seperateChordsFromLyrics(vUnformatedLyric)
            let words = self.seperateWordsFromLyric(_myLyric: justWords)
            
            let currentLyric = LyricLine(lineType: vLineType, lineUnformated: vUnformatedLyric,lineFormated: justWords, lineChords: chords, lineWords: words)
            self.lyrics.append(currentLyric)

            //print (currentLyric.lineUnformated)
            
            
        }


    }
    func getLyricsStream() -> NSAttributedString {
        
        let lineFeed: NSAttributedString = NSAttributedString(string: "\n")
        let space: NSAttributedString = NSAttributedString(string: " ")
        let returnLyrics = NSMutableAttributedString()
        var mString: NSMutableAttributedString!
        
        for data in lyrics {
         
            mString = NSMutableAttributedString(string: data.lineUnformated, attributes: lyricAttr)
            for (x ,chr) in mString.string.characters.enumerated() {
                
            
            
            }
            
            
            
            
            returnLyrics.append(mString)
            returnLyrics.append(lineFeed)
            
        }
        
        return returnLyrics
    }
    
    func getLyrics() -> NSAttributedString {
        
        let lineFeed: NSAttributedString = NSAttributedString(string: "\n")
        let space: NSAttributedString = NSAttributedString(string: " ")
        let returnLyrics = NSMutableAttributedString()
        var mString: NSMutableAttributedString!
        
        
        for data in lyrics {
            //Traverse each line and parse out the word and chords
            
            switch data.lineType {
                
            case .Lyrics:
                
                
                if data.lineChords.count > 0 { //Add the chords back into the lyrics
                
                    //Set the string to the unformatted line
                    mString = NSMutableAttributedString(string: data.lineFormated, attributes: lyricAttr)
                    
                    for chord in data.lineChords {

                        //print ("Chord \(chord.chord) Above Char \(chord.chordAboveChar) Chord Abv Size \(chord.chordAboveCharSize) Chord Width \(chord.chordWidth)")
                        
                        let chString = NSMutableAttributedString(string: chord.chord, attributes: chordAttr)
                        //chString.append(space)
                        
                        //Insert the chord into the line and set the attributes
                        
                        //THIS IS WRONG - IT IS INSERTING AFTER THE CHORD AND SHOULD BE BEFORE
                        //MAYBE SHOULD SET THE CHORDABOVECHAR (-1)?????
                        mString.insert(chString, at: chord.chordAboveChar)
                        
                        
                        //print (chString)
                        //Set the attribute for the chord - Font and baseline (all the characters)
                        mString.addAttributes([NSBaselineOffsetAttributeName:25,NSFontAttributeName:chordFont], range: NSRange(location:chord.chordAboveChar,length:chord.chord.characters.count))
                        
                        //NO CHORD KERNING
                        //Set the attributes for the chord - Kerning (Just the first character)
                        //mString.addAttributes([NSKernAttributeName:-chord.chordWidth], range: NSRange(location:chord.chordAboveChar+1,length:1))
                        
                        let raisedLetter = chord.chordAboveChar + chord.chord.characters.count
                        //print ("Raised Letters \(raisedLetter)")
                        //print ("Chord Width \(chord.chordWidth)")
                        //Add the kerning adjustment to the remainder of the line after the chord
                        mString.addAttributes([NSKernAttributeName:-chord.chordWidth,NSFontAttributeName:chordFont,NSBaselineOffsetAttributeName:25], range: NSRange(location:raisedLetter-1,length:1))
                        
                    }
                    
                    
                    
                    
                }
                
                print (mString)
                returnLyrics.append(mString)
                returnLyrics.append(lineFeed)

            case .Title:
                returnLyrics.append(lineFeed)
            case .SubTitle:
                returnLyrics.append(lineFeed)
            default:
                returnLyrics.append(lineFeed)
                
            }
            
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.0
        //paragraphStyle.lineSpacing = 20
        returnLyrics.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, returnLyrics.length))
        
        return returnLyrics
        
    }

    
    
    
    func seperateWordsFromLyric(_myLyric: String) -> (Array<LyricWords>) {

        enum wordBuild {
            
            case beginWord
            case buildingWord
        }
        
        var words  = [LyricWords]()
        var vWordPosition:CGFloat = 0
        var wordProcedure: wordBuild = .beginWord
        var wordName = ""
        var lyricLine = ""
        
        for chr in _myLyric.characters {
            
            switch wordProcedure {
            case .beginWord:
                
                if chr == " "  { //spaces at the beginning skip them
                    
                }else {
                    wordName.append(chr) //Beging the word
                    vWordPosition = SizeOfString(myString: lyricLine,font: lyricFont) //for now
                    wordProcedure = .buildingWord
                }
            case .buildingWord:
                if (chr == " ")  { //Word End
                    
                    let currentWord = LyricWords(word: wordName, wordPosition: vWordPosition)
                    words.append(currentWord)
                    
                    //print(wordName)
                    wordName = ""
                    wordProcedure = .beginWord
                }else { //Build the word
                    wordName.append(chr)
                }
                
            }
            //Always append the lyric line for position
            lyricLine.append(chr)
            
        }
         
        //Flush the last word -
        //print(wordName)
        if wordName.characters.count > 0 {
            let currentWord = LyricWords(word: wordName, wordPosition: vWordPosition)
            words.append(currentWord)
        }

        return (words)
            
        }
        
        
    func seperateChordsFromLyrics(_ myLyric: String) -> (Array<LyricChords>, String) {
        
            var inChordBuild = false
            var chordName = ""
            var lyricLine = ""
            var chords  = [LyricChords]()
            var vChordAboveChar: Int = 0
            var vChordAboveCharSize:CGFloat = 0
            var vChordWidth:CGFloat = 0
            var vChordPosition:CGFloat = 0
            var vChordEndPosition:CGFloat = 0
            var vPreviousChordEndPosition:CGFloat = 0


            for (x ,chr) in myLyric.characters.enumerated() {
                
                if inChordBuild {
                    if chr == "]" || chr == " "  { //Chord end
                        let vChord = chordName //NO - PUT A SPACE IN FRONT OF THE CHORD ?????
                        vChordWidth = SizeOfString(myString: vChord,font: chordFont)

                        
                        let currentChord = LyricChords(chord: vChord, chordAboveChar: vChordAboveChar,chordAboveCharSize: vChordAboveCharSize ,chordWidth: vChordWidth,chordPosition: vChordPosition, chordEndPosition:vChordEndPosition)
                        
                        chords.append(currentChord)
                        inChordBuild = false
                        
                        //This is the chord
                        //The is the line up to the point where the chord goes
                        chordName = ""
                        
                    } else { //Create the chord name, add all the charaters between [ and ] (or a space)
                        chordName.append(chr)
                        vChordAboveChar += 1
                    }
                }else { // Not building a chord
                    if chr == "[" {
                        inChordBuild = true
                        vPreviousChordEndPosition = vChordEndPosition
                        vChordPosition = SizeOfString(myString: lyricLine,font: lyricFont) //for now
                    }else {// Here is where we create the unformatted lyrics (no chords)
                        vChordAboveChar += 1
                        lyricLine.append(chr)
                    }
                }
  
            }
        //print (lyricLine)
        return (chords, lyricLine)
            
    }
    
    func spacesNeeded(pos:CGFloat,endPos:CGFloat, chordLine: String) -> String {
        
        var spaceNeeded = 0
        let NewSpace = NSMutableAttributedString(string: " ", attributes: chordAttr)
        let width = (NewSpace as NSMutableAttributedString).size().width

        if pos >= endPos {
            spaceNeeded = Int((pos-endPos) / width)
        }else {
            spaceNeeded = 1 //Add at least on space for now
        }
        let chord = ""

        let paddedChord = chord.padding(toLength: spaceNeeded, withPad: " ", startingAt: 0)
        
        return paddedChord
        
        
    }
    
    func subStringByRange(myString: String, begin:Int, length: Int) -> String {
        
        let start = myString.index(myString.startIndex, offsetBy: begin)
        let end = myString.index(myString.startIndex, offsetBy: begin+length)
        let range = start..<end
        
        return myString.substring(with: range)  // play
        
        
    }
    func SizeOfString(myString: String, font: NSFont) -> CGFloat {
        
        let attr = [NSFontAttributeName: font] as [String : Any]
        let sizeOfString = (myString as NSString).size(withAttributes: attr)
        return sizeOfString.width
        
    }
    
    
    
    func getLineDirective(_ myString: String) -> LyricLine.lineType {
        
        //Need to read the next character to see what to do. Directive Found
        //t : title
        //su: subtitle
        //soc: start of chorus
        //eoc: end of chorus
        //sot: start of tab
        //eot: end of tab
        //gc: guitar comment
        //ns: new song
        //np: new page
        //soh: start of highlight
        //eoh: end of highlight
        
        if myString.hasPrefix("{title") {
            return LyricLine.lineType.Title
        }else if myString.hasPrefix("{subtitle") {
            return LyricLine.lineType.SubTitle
        }else if myString.hasPrefix("{soc}") {
            return LyricLine.lineType.StartOfChorus
        }else if myString.hasPrefix("{eoc}") {
            return LyricLine.lineType.StartOfChorus
        }else {
            return LyricLine.lineType.Lyrics
        }
    }
}


//    func getLyrics() -> NSAttributedString {
//
//        let lineFeed: NSAttributedString = NSAttributedString(string: "\n")
//        let returnLyrics = NSMutableAttributedString()
//        var mString: NSMutableAttributedString!
//
//
//        for data in lyrics {
//            //Traverse each line and parse out the word and chords
//
//            switch data.lineType {
//
//            case .Lyrics:
//
//
////                if data.lineChords.count > 0 { //Write the chord line
////
////                    var vPreviousChordEnd: CGFloat = 0
////                    var chordLine = ""
////                    for chord in data.lineChords {
////                        //print ("Chord Pos: \(chord.chordPosition, chord.chord)")
////                        //print ("Chord End Pos: \(chord.chordEndPosition, chord.chord)")
////                        chordLine.append(spacesNeeded(pos: chord.chordPosition,endPos: vPreviousChordEnd,chordLine: chordLine))
////                        chordLine.append(chord.chord)
////                        vPreviousChordEnd = chord.chordEndPosition //Save the ending position of the chord for the next chords position
////                    }
////
////                    mString = NSMutableAttributedString(string: chordLine, attributes: chordAttr)
////                    returnLyrics.append(mString)
////                    returnLyrics.append(lineFeed)
////
////
////                }
//
//                    mString = NSMutableAttributedString(string: data.lineFormated, attributes: lyricAttr)
//                    returnLyrics.append(lineFeed)
//                    returnLyrics.append(mString)
//
//
//
//
//            case .Title:
//                    returnLyrics.append(lineFeed)
//            case .SubTitle:
//                    returnLyrics.append(lineFeed)
//            default:
//                    returnLyrics.append(lineFeed)
//
//            }
//
//        }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        //paragraphStyle.lineHeightMultiple = 2.0
//        paragraphStyle.lineSpacing = 20
//        returnLyrics.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, returnLyrics.length))
//
//        return returnLyrics
//
//    }
//
//    func getChords() -> NSAttributedString {
//
//        let lineFeed: NSAttributedString = NSAttributedString(string: "\n")
//        let returnChords = NSMutableAttributedString()
//        var mString: NSMutableAttributedString!
//
//
//        for data in lyrics {
//            //Traverse each line and parse out the word and chords
//
//            switch data.lineType {
//
//            case .Lyrics:
//
//
//                if data.lineChords.count > 0 { //Write the chord line
//
//                    var vPreviousChordEnd: CGFloat = 0
//                    var chordLine = ""
//                    for chord in data.lineChords {
//                        //print ("Chord Pos: \(chord.chordPosition, chord.chord)")
//                        //print ("Chord End Pos: \(chord.chordEndPosition, chord.chord)")
//                        chordLine.append(spacesNeeded(pos: chord.chordPosition,endPos: vPreviousChordEnd,chordLine: chordLine))
//                        chordLine.append(chord.chord)
//                        vPreviousChordEnd = chord.chordEndPosition //Save the ending position of the chord for the next chords position
//                    }
//
//                    mString = NSMutableAttributedString(string: chordLine, attributes: chordAttr)
//                    returnChords.append(mString)
//                    //Added a char to the line to make it equal to the length of the lyric line
//
//                    returnChords.append(lineFeed)
//
//
//
//                }
//
//            case .Title:
//                returnChords.append(lineFeed)
//            case .SubTitle:
//                returnChords.append(lineFeed)
//            default:
//                returnChords.append(lineFeed)
//
//            }
//
//        }
//
//
//
//        let d = lyricFont.pointSize / chordFont.pointSize
//        let paragraphStyle = NSMutableParagraphStyle()
//        //paragraphStyle.lineHeightMultiple = 2.0
//        paragraphStyle.lineSpacing = d * 20
//        returnChords.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, returnChords.length))
//
//        return returnChords
//
//    }


