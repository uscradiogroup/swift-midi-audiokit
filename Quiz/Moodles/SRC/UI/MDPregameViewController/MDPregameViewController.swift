//
//  MDPregameViewController.swift
//  Moodles
//
//  Created by VladislavEmets on 2/10/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation

class MDPregameViewController: UIViewController {
    
    @IBAction func onBackToRecord(_ sender: Any) {
        self.navigationController?.withSlider()?.switchTo(screen: MDRootScreen.Record)
    }
    
    @IBAction func onPlay(_ sender: Any) {
        guard let gameVC = storyboard?.instantiateViewController(describedByType: MDQuizViewController.self) else {
            return
        }
        gameVC.game = prepareGame()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func prepareGame() -> MDGame {
        let track1 = GameTrack(name: "first", tempo: MDDefaultMetronomeSettings.bpm, notes: [
            GameNoteEvent(time: 2.51458334922791, number: 69, duration: 1.00208330154419),
            GameNoteEvent(time: 3.51666665077209, number: 69, duration: 0.966666698455811),
            GameNoteEvent(time: 4.48333311080933, number: 69, duration: 5.00208377838135),
            GameNoteEvent(time: 5.13333320617676, number: 71, duration: 5.00208330154419),
            GameNoteEvent(time: 5.45416688919067, number: 73, duration: 5.00208330154419)
            ])
        let track2 = GameTrack(name: "second", tempo: MDDefaultMetronomeSettings.bpm,  notes: [
            GameNoteEvent(time: 1.1854162216187, number: 69, duration: 0.883333802223206),
            GameNoteEvent(time: 2.0687503814697, number: 69, duration: 0.849999606609344),
            GameNoteEvent(time: 2.9187498092651, number: 69, duration: 5.0),
            GameNoteEvent(time: 3.5687503814697, number: 71, duration: 1.86666631698608),
            GameNoteEvent(time: 3.8874998092651, number: 73, duration: 0.914583504199982),
            GameNoteEvent(time: 4.8020830154419, number: 73, duration: 0.972916960716248),
            GameNoteEvent(time: 5.4354162216187, number: 71, duration: 5.00208377838135),
            GameNoteEvent(time: 5.7749996185303, number: 73, duration: 5.00416707992554),
            GameNoteEvent(time: 6.4208335876465, number: 74, duration: 5.00416660308838),
            GameNoteEvent(time: 6.7666664123535, number: 76, duration: 5.00416707992554)
            ])
        let track3 = GameTrack(name: "third", tempo: MDDefaultMetronomeSettings.bpm, notes: [
            GameNoteEvent(time: 1.9020824432373, number: 69, duration: 0.918750882148743),
            GameNoteEvent(time: 2.8208332061768, number: 69, duration: 0.918750107288361),
            GameNoteEvent(time: 3.7395839691162, number: 69, duration: 4.99999952316284),
            GameNoteEvent(time: 4.3541660308838, number: 71, duration: 1.71875059604645),
            GameNoteEvent(time: 4.6749992370605, number: 73, duration: 0.812500774860382),
            GameNoteEvent(time: 5.4874992370605, number: 73, duration: 0.925000786781311),
            GameNoteEvent(time: 6.0729160308838, number: 71, duration: 5.00208377838135),
            GameNoteEvent(time: 6.4125003814697, number: 73, duration: 4.07499980926514),
            GameNoteEvent(time: 6.9770832061768, number: 74, duration: 5.00208330154419),
            GameNoteEvent(time: 7.3624992370605, number: 76, duration: 2.27500081062317)
            ])
        let track4 = GameTrack(name: "fourth", tempo: MDDefaultMetronomeSettings.bpm,  notes: [
            GameNoteEvent(time: 1.71875, number: 81, duration: 5.00208330154419),
            GameNoteEvent(time: 2.6375007629395, number: 76, duration: 2.56874918937683),
            GameNoteEvent(time: 3.4874992370605, number: 73, duration: 2.55000066757202),
            GameNoteEvent(time: 4.341667175293, number: 69, duration: 2.6479160785675),
            GameNoteEvent(time: 5.2062492370605, number: 76, duration: 5.00208425521851),
            GameNoteEvent(time: 5.7562484741211, number: 74, duration: 4.4958348274231),
            GameNoteEvent(time: 6.0374984741211, number: 73, duration: 4.2145848274231),
            GameNoteEvent(time: 6.625, number: 71, duration: 3.62708330154419),
            GameNoteEvent(time: 6.9895820617676, number: 69, duration: 3.26250123977661)
            ])
        
        let game = MDGame(tours: [
                MDSimonGame(track: track1),
                MDSimonGame(track: track2),
                MDSimonGame(track: track3),
                MDSimonGame(track: track4)
            ])
        return game!
    }
    
}
