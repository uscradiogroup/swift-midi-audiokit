//
//  MusicToMusicJSON.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation

private let kName = "name"
private let kEvents = "events"
private let kNote = "note"

func musicToMusicJSON(music music: Music) -> String? {
    
    var musicJSON: [String: AnyObject] = [:]
    
    var eventsMusicJSON: [AnyObject] = []
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    if let tracks = music.tracks as? Set<Track> {
        tracks.forEach({ track in
            if let events = track.events as? Set<NoteEvent> {
                events.forEach({ event in
                    let eventItem: [AnyObject] = [numberFormatter.numberFromString(String(format: "%.2f", event.time))!,
                        event.type!,
                        NSNumber(short: event.number),
                        NSNumber(short: event.velocity),
                        numberFormatter.numberFromString(String(format: "%.2f", event.duration))!]
                    eventsMusicJSON.append(eventItem)
                })
            }
        })
    }
    
    musicJSON.updateValue(eventsMusicJSON, forKey: kEvents)
    
    let name = music.name ?? "Undefined"
    musicJSON.updateValue(name, forKey: kName)
    
    let valid = NSJSONSerialization.isValidJSONObject(musicJSON)
    
    var result: String? = nil
    
    if true == valid {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(musicJSON, options: NSJSONWritingOptions())
            result = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as? String
        } catch {
            return result
        }
    }
    
    return result
}

func musicToMusicJSONFile(music music: Music) -> NSURL? {
    let musicJSON = musicToMusicJSON(music: music)
    if let musicJSON = musicJSON {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let fileManager = NSFileManager.defaultManager()
        let folderPath = documentsPath.stringByAppendingString("/MusicJSON")
        if !fileManager.fileExistsAtPath(folderPath) {
            do {
                try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        
        let fileName = (music.name ?? "Undefined") + ".json"
        
        let filePath = NSURL(fileURLWithPath: folderPath).URLByAppendingPathComponent(fileName)
        
        do {
            try musicJSON.writeToURL(filePath!, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            return nil
        }
        
        return filePath
    } else {
        return nil
    }
}
