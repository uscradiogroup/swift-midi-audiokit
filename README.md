# Swift + AudioKit :heart: MIDI

Demos, examples, [code kata's](http://codekata.com/) and etudes.

---

The USC Radio Labs team is excited to see the arrival of two new technologies for music, [Swift](https://swift.org/) lang and [AudioKit](http://audiokit.io/). These two technologies make it easier to create new instruments for musicians and push the needle forward on music. 


To share our excitement and commitment to helping create new products and platforms for music, we're open sourcing a few demos for software engineers interested in working with [MIDI](https://en.wikipedia.org/wiki/MIDI). 


### Why MIDI?

We are excited to see MIDI go through a [renaissance online](http://arstechnica.com/information-technology/2015/05/google-chrome-gains-midi-support-enables-web-based-synths-and-daws/) (thank you [Chrome team](https://blog.chromium.org/2015/04/chrome-43-beta-web-midi-and-upgrading.html)!). As part of our mission to help promote classical music online, we felt it was best to provide developers with examples of how to work with MIDI performances using AudioKit and Swift. 


### MIDI? Really? Isn't there something better?

Although the MIDI spec could use more regular updates, it's still the best technology for musicians who want to mix and match different digital instruments. It's also the best standard for digital instrument makers to create new products that can interface with instruments dating back to the 1980's. If you think instruments like [this](http://www.vintagesynth.com/roland/jup6.php) look cool, then it's worth it to continue embracing MIDI. 


USC Radio Interactive is excited to help make music creation more accessible.  We feel the best way to do that is by providing software engineers with examples of how MIDI can work with iOS. 

---

## Getting Started

The team prefers [Carthage](https://github.com/Carthage/Carthage) more than Cocoapods. You will need [Homebrew](http://brew.sh/) to install [Carthage](https://github.com/Carthage/Carthage).

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

# Resources


### MIDI performances from the community

- [Classical Archives](http://www.classicalarchives.com/midi.html)
- [Kunst der Fuge](http://www.kunstderfuge.com/)
- [AM Classical MIDI](http://www.amclassical.com/midi/)
- [MIDI World](http://www.midiworld.com/classic.htm/)
- [Classical Piano](http://www.piano-midi.de/)


### MIDI tech from the community

- [Web Audio Demos](http://webaudiodemos.appspot.com/)
- [MIDI Converter](http://tonejs.github.io/MidiConvert/)
- [MIDI Synth](https://github.com/cwilso/midi-synth)
- [Web MIDI API Polyfill](https://github.com/cwilso/WebMIDIAPIShim)
- [MIDI JSON Parser](https://www.npmjs.com/package/midi-json-parser)
- [Pg MIDI](https://github.com/petegoodliffe/PGMidi)

### Other useful links and resources

- [Timing in MIDI](http://sites.uci.edu/camp2014/2014/05/19/timing-in-midi-files/)
- [MIDI](http://www.deluge.co/?q=core-midi-core-audio-useful-links)
- [Handling MIDI events](http://www.slideshare.net/invalidname/core-midi-and-friends)
- [MIDI for games](http://www.indiegamemusic.com/help.php?id=3)


### Noteworthy SoundFonts

- [Ultimate MIDI tutorial](http://www.deluge.co/?q=ultimate-midi-tutorial-iphone-ipad)
- [Sound Fonts](http://www.root.immersiondesign.co.uk/Downloads/sound_font.tar.gz)
- [Soundfont Library](http://www.hammersound.com/cgi-bin/soundlink.pl)

---

# About USC Radio Labs

USC Radio Labs is a department of [USC Radio Group](http://uscradiogroup.org) dedicated to producing new music products, services, and experiences for listeners, musicians, tastemakers and arts partners worldwide. The team develops websites, apps, API services, and new forms of interactive media that promote both music and story-driven listening. 


### What do we do? 

* We produce high quality media for listeners worldwide. 
* We pioneer new forms of music discovery and creation.
* We promote learning such as the art of listening, music history, and music theory.
* We provide new platforms for dialog and discussion.

