//
//  MDConstants.swift
//  Moodles
//
//  Created by VladislavEmets on 1/25/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

// MARK: - VendorInfo

struct MDVendorInfo {
    static let applicationName = "Moodles"
    static let supportMail = "support@getmoodles.com"
}


// MARK: - URL Scheme

struct MDURLScheme {
    static let moodles = "moodles"
    static let file = "file"
    struct Host {
        static let resetPass = "resetPassword"
    }
    struct Key {
        static let resetCode = "resetCode"
        static let mail = "mail"
    }
}


// MARK: - Storyboards

struct MDStoryboards {
    static let main = "Main"
    static let authentication = "Authentication"
}


// MARK: - Notifications

struct MDNotification {
    struct Name {
        static let openSharedMidiFile   = "mdNotificationOpenSharedMusicFile"
        static let openFIRStorageFile   = "mdNotificationOpenFIRStorageFile"
        static let ensembleDidSync      = "MDNotificationEnsembleDidSync"
    }
    struct Key {
        static let musicName   = "music_name"
        static let musicFolder = "uniq_folder"
    }
}


// MARK: - FileSystem

struct MDFileSystem {
    struct MimeType {
        static let audiomidi = "audio/midi"
        static let imagejpeg = "image/jpeg"
    }
    struct Extension {
        static let midi = "midi"
        static let mid  = "mid"
        static let json = "json"
        static let png  = "png"
    }
    struct Folder {
        static let midis = "MIDIs"
        static let musicJSON = "MusicJSON"
    }
}

// MARK: - MusicJSON

struct MusicJSON {
    static let name = "name"
    static let events = "events"
    
    static let NotePropertiesCount = 5
    
    struct  NoteInfoKeys {
        //representation of note event like [time, "note", number, velocity, duration]
        static let time = 0
        static let type = 1
        static let number = 2
        static let velocity = 3
        static let duration = 4
    }
}


// MARK: - THIRD PARTY COMPONENTS


// MARK: - Firebase

struct MDFirebase {
    struct Storage {
        static let share = "Share"
        static let images = "Images"
        static var maxFileSize: Int64 {
            return 5 * 1024 * 1024
        }
    }
    struct Database {
        static let purchases    = "purchases"
        static let itemID       = "itemId"
        static let title        = "title"
        static let desciption   = "description"
    }
}


// MARK: - Mixpanel

struct MDMixpanel {
    static let token = "770b414bce1c71622d198a814e0c83dc"
    
    struct Event {
        static let sessionTime       = "Session Time"
        static let musicSaved        = "Music Saved"
        static let recordSong        = "Record Song"
        static let trackPurchased    = "Track Purchased"
        static let sendMusicToFriend = "Send Music To Friend"
        static let listenTimDemo     = "Listen Demo"
        static let downloadedFromFB  = "Downloaded From FB"
        static let musicUploadedToICloud = "Upload To iCloud"
    }
    struct Property {
        static let userId   = "user_id"
        static let lastLogin = "$last_login"
    }
}


// MARK: - Listenloop

struct MDListenloop {
    static let featureID = "2086"
    static let userID = "204"
    struct Key {
        static let successStatus = "success"
        static let message = "message"
        static let overlayURL = "overlay_url"
    }
}


// MARK: - Branch

struct MDDeeplink {
    static let feature = "sharing"
    static let channel = "facebook"
    struct MetaKey {
        static let folder   = "$uniq_folder"
        static let filename = "$music_name"
        static let referrer = "+referrer"
    }
}

// MARK: - Ensemble

struct MDEnsemble {
    static let identifier = "MoodlesTest10"
    static let ICloudContainerIdentifier = "iCloud.org.uscradiogroup.Moodles";
}
