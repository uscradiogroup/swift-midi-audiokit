# Example MIDI

* Record a performance
* Load an external MIDI file
* Export a performance as MIDI to iCloud
* Export a performance to MusicJSON

---

## Getting Started



Install libraries and frameworks
```
carthage bootstrap --platform ios --no-use-binaries
```

---


## Package Manager

We like Carthage more than Cocoapods. It's easier to maintain and much clearer to organize. 

---


## Libraries


- [AudioKit](https://github.com/audiokit/AudioKit) - The best framework for managing MIDI, synthesis, and sound using Swift language.
- [MagicalRecord](https://github.com/magicalpanda/MagicalRecord/) - This library is aimed at simplifying CoreData.  It borrows from the simplicity and ActiveRecord found in Ruby on Rails.
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) - ReactiveCocoa is designed to help simplify messaging.
- [Result](https://github.com/antitypical/Result) - Swift 2.0 introduces error handling via throwing and catching ErrorType. Result accomplishes the same goal by encapsulating the result instead of hijacking control flow. The Result abstraction enables powerful functionality such as map and flatMap, making Result more composable than throw