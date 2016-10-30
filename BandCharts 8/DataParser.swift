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

let chordFont: NSFont = GetAFont("Arial", Size: "16")
let lyricFont: NSFont = GetAFont("Arial", Size: "20")

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
            self.setChordCloseFlag()
            
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
         
            mString = NSMutableAttributedString(string: data.lineFormated, attributes: lyricAttr)
            for (x ,chr) in mString.string.characters.enumerated() {
                
            
            
            }
            
            
            

            returnLyrics.append(mString)
            returnLyrics.append(lineFeed)
            
        }
        
        return returnLyrics
    }
    
    func getLyrics(withAttributes: Bool) -> NSAttributedString {
        
        let lineFeed: NSAttributedString = NSAttributedString(string: "\n")
        let space: NSAttributedString = NSAttributedString(string: " ")
        let returnLyrics = NSMutableAttributedString()
        var mString: NSMutableAttributedString!
        
        var vLastChordPosition = -1
        
        
        for data in lyrics {
            //Traverse each line and parse out the word and chords
            
            switch data.lineType {
                
            case .Lyrics:
                
                //Set the string to the unformatted line
                mString = NSMutableAttributedString(string: data.lineFormated, attributes: lyricAttr)
                var vChordOffset = 0 //Used to adjust chord position in case spacess are needed
                if data.lineChords.count > 0 { //Add the chords back into the lyrics
                    
                    for chord in data.lineChords {

                        //print ("Chord \(chord.chord) Above Char \(chord.chordAboveChar) Chord Abv Size \(chord.chordAboveCharSize) Chord Width \(chord.chordWidth)")
                        
                        let chString = NSMutableAttributedString(string: chord.chord) //, attributes: chordAttr)
                        //chString.append(space)
                        
                        let raisedLetter = chord.chordAboveChar // + chord.chord.characters.count
                        let lastRaisedLetter = chord.chordAboveChar + chord.chord.characters.count - 1
                        
            
                        //Insert the chord into the line and set the attributes
                        
                        //This is for testing only
                        let aboveChord = (subStringByRange(myString: mString.string, begin: chord.chordAboveChar + vChordOffset, length: 1))
                        
                        //If you are at the end of the lyric line chords need to be appended not inserted
                        if mString.length < chord.chordAboveChar + vChordOffset {
                            mString.append(chString)
                        } else {
                            mString.insert(chString, at: chord.chordAboveChar + vChordOffset)
                        }

                        print ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                        print ("Chord \(chord.chord)")
                        print ("Chord Close \(chord.nextChordClose)")
                        print ("mString Length \(mString.length)")
                        print ("Chord Above \(chord.chordAboveChar)")
                        print ("Chord Above Letter \(aboveChord)")
                        print ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

                        //Set the attribute for the chord - Font and baseline (all the characters)
                        //mString.addAttributes([NSBaselineOffsetAttributeName:25,NSFontAttributeName:chordFont], range: NSRange(location:chord.chordAboveChar,length:chord.chord.characters.count))
                        
                        //NO CHORD KERNING
                        //Set the attributes for the chord - Kerning (Just the first character)
                        //mString.addAttributes([NSKernAttributeName:-chord.chordWidth], range: NSRange(location:chord.chordAboveChar+1,length:1))
                        
                        

                        

                        

                        //print ("Lyric Length \(mString.length)")
                        //print ("Raised Letters \(raisedLetter,length:chord.chord.characters.count)")
                        
                        //print ("Chord Width \(chord.chordWidth)")
                        //Add the kerning adjustment to the remainder of the line after the chord
                        //mString.addAttributes([NSKernAttributeName:-chord.chordWidth,NSFontAttributeName:chordFont,NSBaselineOffsetAttributeName:25], range: NSRange(location:raisedLetter-1,length:1))
                        if withAttributes {
                            //Let try all of the attribute at once
                            mString.addAttributes([NSFontAttributeName:chordFont,NSBaselineOffsetAttributeName:25, NSForegroundColorAttributeName: NSColor.red], range: NSRange(location:raisedLetter + vChordOffset,length:chord.chord.characters.count))
                            //Need to add the kerning adjustment right after the last character of the chord
                            mString.addAttributes([NSKernAttributeName:-chord.chordWidth], range: NSRange(location:lastRaisedLetter + vChordOffset,length:1))
                        } //End with Atrtribute
                        
                        
                        if chord.nextChordClose {

                            let (vSpaces, vIntSpaces) = self.spacesNeeded(len:chord.chordWidth)
                            mString.insert(NSAttributedString(string:(vSpaces)), at: raisedLetter+1)
                            print ("Inserting \(vIntSpaces) at \(raisedLetter+1)")
                            vChordOffset += vIntSpaces
                        }
                        
                        //Hold the previous chord position
                        vLastChordPosition = chord.chordAboveChar
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

        
    func seperateChordsFromLyrics(_ myLyric: String) -> (Array<LyricChords>, String) {
        
            var inChordBuild = false
            var chordName = ""
            var lyricLine = ""
            var chords  = [LyricChords]()
        
            var vChordAboveChar: Int = 0
            var vNextChordPosition :Int = 0 //Holder for the chord position upon discovery
            //var vChordAboveCharSize:CGFloat = 0
            var vChordWidth:CGFloat = 0
            var vLastChordPosition = -1



            for chr in myLyric.characters {
                
                if inChordBuild {
                    if chr == "]" || chr == " "  { //Chord end
                        
                        //See if we are to close to the last chord??

                        
                        let vChord = chordName //NO - PUT A SPACE IN FRONT OF THE CHORD ?????
                        vChordWidth = SizeOfString(myString: vChord,font: chordFont)

                        //Subtract on from the vChordAboceChar to force the insert before the character above
                        let currentChord = LyricChords(chord: vChord, chordAboveChar: vNextChordPosition,chordAboveCharSize: 0 ,chordWidth: vChordWidth, nextChordClose: false)
                        
                        chords.append(currentChord)
                        inChordBuild = false
                        
                        //Reset the chord name
                        chordName = ""
                        
                    } else { //Create the chord name, add all the charaters between [ and ] (or a space)
                        chordName.append(chr)
                        //Need to add one to the location to account for each character
                        vChordAboveChar += 1
                    }
                }else { // Not building a chord
                    if chr == "[" {
                        inChordBuild = true
                        vNextChordPosition = vChordAboveChar //Holder for the chord position upon discovery
                        
                    }else {// Here is where we create the unformatted lyrics (no chords)
                        //Need to add one to the location to account for each character
                        vChordAboveChar += 1
                        lyricLine.append(chr)
                    }
                }
  
            }
        //print (lyricLine)
        return (chords, lyricLine)
            
    }
    
    
    func setChordCloseFlag() {
        
        for data in lyrics {
            for x in data.lineChords.indices.reversed() {
                
                if x > 0 {
                    let chord = data.lineChords[x]
                    let previousChord = data.lineChords[x-1]
                    
                    if chord.chordAboveChar <= previousChord.chordAboveChar + chord.chord.characters.count {
                        previousChord.nextChordClose = true
                    }
                }
                
            }
        }
    }
    
    
    func spacesNeeded(spaceCount: Int) -> String {
        
        let space = ""
        let paddedSpace = space.padding(toLength: spaceCount, withPad: "@", startingAt: 0)
        return paddedSpace
        
        
    }

    func spacesNeeded(len:CGFloat) -> (String, Int) {
        //Return a string of spaces and a number of spaces
        
        var spaceNeeded = 0
        let NewSpace = NSMutableAttributedString(string: " ", attributes: lyricAttr)
        let width = (NewSpace as NSMutableAttributedString).size().width
        

        spaceNeeded = Int(len / width)
        let eString = ""
        
        let paddedString = eString.padding(toLength: spaceNeeded, withPad: "@", startingAt: 0)
        
        return (paddedString, spaceNeeded)
        
        
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
    func subStringByRange(myString: String, begin:Int, length: Int) -> String {

        if myString.characters.count > begin+length { // We are out of range
        
            let start = try myString.index(myString.startIndex, offsetBy: begin)
            let end = try myString.index(myString.startIndex, offsetBy: begin+length)
            let range = start..<end
            return myString.substring(with: range)
        } else {
        return ""
    }
    
        
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

