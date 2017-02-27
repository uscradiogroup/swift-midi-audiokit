//
//  MusicToMusicJSON.swift
//  ExampleMIDI
//
//  Created by Artem Chabannyi on 10/24/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation


func musicToMusicJSON(music: Music) -> String? {
    var musicJSON: [String: AnyObject] = [:]
    var eventsMusicJSON: [AnyObject] = []
    
    if let tracks = music.tracks as? Set<Track> {
        tracks.forEach({ track in
            if let events = track.events as? Set<NoteEvent> {
                
                events.sorted(by: {(firstNote, secondNote) in
                    return firstNote.time < secondNote.time
                }).forEach({ event in
                    if let eventItem: [AnyObject] = event.json() {
                        eventsMusicJSON.append(eventItem as AnyObject)
                    }
                })
                
            }
        })
    }
    
    musicJSON.updateValue(eventsMusicJSON as AnyObject, forKey: MusicJSON.events)
    let name = music.name ?? "Undefined"
    musicJSON.updateValue(name as AnyObject, forKey: MusicJSON.name)
    let valid = JSONSerialization.isValidJSONObject(musicJSON)
    var result: String?
    
    if true == valid {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: musicJSON, options: JSONSerialization.WritingOptions())
            result = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String
        } catch {
            return result
        }
    }
    
    let track = GameTrack.fromMusicJSON(music: result!)
    
    return result
}


func musicToMusicJSONFile(music: Music) -> URL? {
    let (_, path) = localFolder(.musicJSON)
    if let folderPath = path,
        let musicJSON = musicToMusicJSON(music: music) {
        let fileName = (music.name ?? "Undefined") + "." + MDFileSystem.Extension.json
        let filePath = URL(fileURLWithPath: folderPath).appendingPathComponent(fileName)
        
        do {
            try musicJSON.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            return nil
        }
        
        return filePath
    } else {
        return nil
    }
}


fileprivate extension NoteEvent {
    
    func json() -> [AnyObject]? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = Locale(identifier: "en")
        
        guard let eTime = numberFormatter.number(from: String(format: "%.2f", time)),
            let eDuration = numberFormatter.number(from: String(format: "%.2f", duration)),
            let eType = type else {
            return nil
        }
        
        return [eTime,
                eType as AnyObject,
                NSNumber(value: self.number as Int16),
                NSNumber(value: 1.0),
                eDuration]
    }
    
}
