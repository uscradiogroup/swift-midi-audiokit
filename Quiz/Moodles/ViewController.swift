//
//  ViewController.swift
//  MP3AF
//
//  Created by Tommy Trojan on 8/29/16.
//  Copyright © 2016 Chris Mendez. All rights reserved.
//

import UIKit
import AVFoundation
import Squall
import Firebase

private let reuseIdentifier = "CustomCell"

class ViewController: UIViewController {
    
    //UIX related
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var numOfPads:Int?
    var numOfColumns = 4
    var currentIndex:Int = 0
    
    var gradientView:GradientView?
    var timer:Timer?
    
    //Animation related
    var animations:[SLCoreAnimation] = []
    
    //Audio and Sound related
    var conductor = Conductor()
    
    //In-App Store related
    var currentSoundBank = Config.defaultSoundBank
    
    //Firebase
    var server:Server?
    var track:Track?
    var allKeys:[String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func initCollectionView(){
        gradientView = GradientView(frame: collectionView.frame)
        gradientView?.colors = Config.background.colorWheel;
        gradientView?.animateToNextGradient()
        
        startTimer(interval: Config.background.interval)
        
        collectionView.delegate = self
        //This is to fix the initial "all black" background
        collectionView.backgroundColor = UIColor.white
        collectionView.indicatorStyle = UIScrollViewIndicatorStyle.white
        collectionView.backgroundView?.isUserInteractionEnabled = false
        
        //Gradient background
        collectionView.backgroundView = gradientView
    }
    
    //Create Pads
    func createPads(){
        let numOfAnimations = currentSoundBank.animations?.count
        
        numOfPads = numOfAnimations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTrack()
        server = Server.sharedInstance
        listen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPads()
        initCollectionView()
        createAnimations()
        
        //Play sound on iOS 9 w/ phone in silent mode
        SoundUtils.sharedInstance.modifySilentModePhones()
    }
    
    //This will redraw the square to work
    override func viewWillLayoutSubviews() {
        willAdjustForOrientation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



//MARK: - Timer and time-related items
extension ViewController {
    func startTimer(interval:Double){
        if timer == nil {
            //TODO: Make this more efficient
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.timer = Timer.scheduledTimer(
                    timeInterval: interval,
                    target: self,
                    selector: #selector(self.onTimerHandler),
                    userInfo: nil,
                    repeats: true)
            }
        }
    }
    
    func stopTimer(){
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func onTimerHandler(){
        //print("onTimerHandler")
        gradientView?.animateToNextGradient()
    }
}


//MARK: - Sound & Vision
extension ViewController {
    //A. Create an Array of Custom Animations
    func createAnimations(){
        //B. Target the UICollectionView background view layer
        let stage = (collectionView.backgroundView?.layer)! as CALayer
        //C. Pick the animations from the default sound bank
        let items = currentSoundBank.animations!
        //D. Iterate through all the animations
        for (idx, item) in items.enumerated() {
            //E. Create a SLCoreAnimation which has better performance than SLSquallAnimation
            let a = SLCoreAnimation(fromBundle: item)!
            a.name = String(idx)
            //G. Add the animation to the UICollectionView layer
            stage.addSublayer(a)
            //H. Keep this for record keeping purposes
            animations.append(a)
        }
    }
    
    func playMoodle(index:Int, tapPoint:CGPoint){
        //Play Animation
        playAnimation(index: index, tapPoint: tapPoint)
        
        //Load Sound
        playSound(index: index)
    }
    
    // Squall API Documentation
    // http://www.marcuseckert.com/squall//doc/api/Classes/SLCoreAnimation.html
    func playAnimation(index:Int, tapPoint:CGPoint){
        let stage = (collectionView.backgroundView?.layer)! as CALayer
        //A. Target the current animation based on the cell the user tapped
        //let thisAnimation = animations[index] as SLCoreAnimation
        let thisAnimation = stage.sublayers![index] as! SLCoreAnimation
        //B. Confirm you are getting the animation you want
        //print(thisAnimation.name!)
        //C. IF the animation is currently playing, reset it
        if thisAnimation.isPaused() == false {
            resetAnimation(animation: thisAnimation)
        }
        //D. Postion the animation from where the user tapped
        thisAnimation.position = tapPoint
        //E. Play the animation
        thisAnimation.play()
        //F. Reset the animation once it has played
        thisAnimation.onAnimationEvent = { event in
            if event == .end {
                self.resetAnimation(animation: thisAnimation)
            }
        }
    }
    
    func resetAnimation(animation:SLCoreAnimation){
        animation.time = 0
    }
    
    func playSound(index:Int){
        let note = index + 60
        conductor.play(note: note, velocity: 127, duration: 0)
    }
}

//MARK: - Gestures
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTap(gestureReconizer: UITapGestureRecognizer){
        let tapPoint = gestureReconizer.location(in: collectionView) as CGPoint
        
        //Use the tapLocation to get the indexPath
        if let indexPath = collectionView.indexPathForItem(at: tapPoint) {
            //now we can get the cell for item at indexPath
            //let cell = self.collectionView?.cellForItem(at: indexPath)
            //Indicate that the cell has been previously tapped
            //cell?.backgroundColor = UIColor.clear
            
            //Pick the cell the user is tapping based on the point location
            let index = (indexPath as NSIndexPath).item
            
            switch gestureReconizer.state {
            // Tap Down
            case .began:
                currentIndex = index
                playMoodle(index: currentIndex, tapPoint: tapPoint)
                addToTrack(cellNumber: currentIndex, duration: 0)
                break
            // Finger is dragging across the cells
            case .changed:
                if index != currentIndex {
                    currentIndex = index
                    playMoodle(index: currentIndex, tapPoint: tapPoint)
                    //print("changed", currentIndex)
                }
                break
            // Tap Up
            case .ended: break
            default: break
            }
        }
    }
}


//MARK: - UICollectionView Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout{
    
    //main view's dimensions change (on rotation, for example), the collection view is re-laid out
    func willAdjustForOrientation(){
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //Size of the Pad
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfRows = numOfPads! / numOfColumns
        let w = Int(collectionView.bounds.width) / numOfColumns
        let h = Int(collectionView.bounds.height)  / numOfRows
        
        return CGSize(width: w, height: h)
    }
    
    //Inset of the Pad
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}



//MARK: - UICollectionView Delegate
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //print("shouldSelectItemAtIndexPath", indexPath)
        return false
    }
    
    //Remove the vertical spacing between the squares
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.right
    }
    
    //Remove the horizontal spacing between the squares
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }
}



//MARK: - UICollectionView Data Source
extension ViewController: UICollectionViewDataSource {
    //Number of Pads on the Screen
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfPads!
    }
    
    //Aesthetic Look of the Pads
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tap = UILongPressGestureRecognizer(target: self, action :  #selector(handleTap(gestureReconizer:)))
        tap.minimumPressDuration = 0
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = Utils.sharedInstance.generateRandomColor()
        cell.addGestureRecognizer(tap)
        
        return cell
    }
}


extension ViewController {
    
    
    func initTrack(){
        track = Track(number: 0, duration: 0)
    }
    
    //MARK: - Firebase
    func addToTrack(cellNumber:Int, duration:Float){
        
        track?.addNote(number: cellNumber, duration: 0)
        
        sendDataToServer(shouldSend: true)
    }
    
    //TODO: - Create a way to reset the notes
    func resetNotes(){
        
    }
    
    func sendDataToServer(shouldSend:Bool){
        if shouldSend {
            let returnKey = server?.save(track: track!)
            allKeys.append(returnKey!)
        }
        
    }
    
    //MARK: - Observer Pattern
    func listen(){
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification), name: NSNotification.Name(rawValue: (server?.CALLBACK_NAME)!), object: nil)
    }
    
    @objc func onNotification(sender:Notification){
        //Dictionary of Return data
        if let info = sender.userInfo as? Dictionary<String,FIRDataSnapshot> {
            let data = info["send"]
            print("Conductor::onNotification:data: \(data)")
            //If firebase has a key, store it in firebasekey to prevent duplicates
            if let firebaseKey = data?.key {
                //If it's a new key, get the data
                if !allKeys.contains(firebaseKey) {
                    //Get the data from the key
                    if let data = data?.value as? NSMutableDictionary {
                        let notes = data["notes"] as! NSArray
                        
                        let firstNote = notes.firstObject! as! NSDictionary
                        
                        let pitch = firstNote.value(forKey: "number")! as! Int
                        let duration = firstNote.value(forKey: "duration")! as! Float
                        let fn = Note(pitch: pitch, duration: duration)
                        
                        for note in notes {
                            if let n = note as? NSObject {
                                let number = n.value(forKey: "number")! as! Int
                                let duration = n.value(forKey: "duration")! as! Float
                                let otherNotes = Note(pitch: number, duration: duration)
                                track?.addNote(number: number, duration: duration)
                                
                                playMoodle(index: number, tapPoint: CGPoint(x: 0, y: 0))
                            }
                        }
                    }
                    resetNotes()
                    sendDataToServer(shouldSend: false)
                    
                }
            }
        }
    }
}
