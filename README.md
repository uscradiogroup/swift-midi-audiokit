```language-powerbash
|  | | | |  |  | | | | | |  |  | | | |  | 
|  | | | |  |  | | | | | |  |  | | | |  | 
|  | | | |  |  | | | | | |  |  | | | |  | 
|  |_| |_|  |  |_| |_| |_|  |  |_| |_|  | 
|   |   |   |   |   |   |   |   |   |   | 
|   |   |   |   |   |   |   |   |   |   | 
|___|___|___|___|___|___|___|___|___|___| 
```

# Swift + AudioKit :heart: MIDI


[READ ME => Wiki](https://github.com/uscradiogroup/swift-midi-audiokit/wiki)

## Getting Started

The team uses [Carthage](https://github.com/Carthage/Carthage) for package management. You can install [Carthage](https://github.com/Carthage/Carthage) through [Homebrew](http://brew.sh/).

**Step 1** - Install Homebrew

[Homebrew](http://brew.sh/)


**Step 2** - Install Carthage

```language-powerbash
brew install carthage
```

**Step 3** - Install libraries and frameworks

```language-powerbash
carthage update --platform ios
```

---


## Libraries

- [AudioKit](https://github.com/audiokit/AudioKit) - The best library for managing MIDI, synthesis, and sound.
- [MagicalRecord](https://github.com/magicalpanda/MagicalRecord/) - This library is aimed at simplifying CoreData.  It borrows from the simplicity of ActiveRecord found in Ruby on Rails.
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) - ReactiveCocoa is designed to help simplify messaging.

---

## Troubleshooting

If Carthage update is not working, try this.
```language-powerbash
carthage bootstrap --platform ios  --no-use-binaries
```

---

# About USC Radio Labs

USC Radio Labs is a department of [USC Radio Group](http://uscradiogroup.org) dedicated to producing new music products, services, and experiences for listeners, musicians, tastemakers and arts partners worldwide. The team develops websites, apps, API services, and new forms of interactive media that promote both music and story-driven listening. 



### What do we do? 

* We produce high quality media for listeners worldwide. 
* We pioneer new forms of music discovery and creation.
* We promote learning such as the art of listening, music history, and music theory.
* We provide new platforms for dialog and discussion.

```language-powerbash
  _    _  _____  _____   _____           _ _         _           _         
 | |  | |/ ____|/ ____| |  __ \         | (_)       | |         | |        
 | |  | | (___ | |      | |__) |__ _  __| |_  ___   | |     __ _| |__  ___ 
 | |  | |\___ \| |      |  _  // _` |/ _` | |/ _ \  | |    / _` | '_ \/ __|
 | |__| |____) | |____  | | \ \ (_| | (_| | | (_) | | |___| (_| | |_) \__ \
  \____/|_____/ \_____| |_|  \_\__,_|\__,_|_|\___/  |______\__,_|_.__/|___/
```
