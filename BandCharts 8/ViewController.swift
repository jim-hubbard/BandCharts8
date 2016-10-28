//
//  ViewController.swift
//  BandCharts 8
//
//  Created by Jim Hubbard on 9/29/16.
//  Copyright © 2016 Jim Hubbard. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBAction func btnLoadFile(_ sender: NSButton) {
        
        let fullPath: String = "/Users/Jim/Dropbox/Songbook/Other Stuff/Test Song - Jim.pro"
        let fileText = contentsOfFileAtPath(fullPath) as String
        
        let parser = DataParser()
        parser.fillLines(song: fileText)


        
        txtSong.attributedStringValue = parser.getLyrics()
        
        
        //Clear the Viewer and reset the viewer
        let range = NSMakeRange(0, 0)
        txtViewSong.textStorage!.mutableString.setString("")
        //txtViewSong.typingAttributes = attributes as! [String : AnyObject]
        txtViewSong.insertText(parser.getLyricsStream(),replacementRange:range)
        txtViewSong.moveToBeginningOfDocument(nil)
        
        
        //This is for the subview exabmple~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ScrollView0.drawsBackground = false
        ScrollView0.wantsLayer      = true
        textViewChords.drawsBackground = false
        //textViewChords.insertText(parser.getChords(), replacementRange: range)
        //txtViewSong.addSubview(textViewChords)
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        
    }
    
    
    @IBOutlet var textViewChords: NSTextView!

    @IBOutlet weak var ScrollView0: NSScrollView!
    
    @IBOutlet weak var txtSong: NSTextField!
    
    @IBOutlet var txtViewSong: NSTextView!
    
    //var textViewChords = NSTextView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

