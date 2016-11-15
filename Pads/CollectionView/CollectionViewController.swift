//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Chris Mendez on 10/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import AudioKit

private let reuseIdentifier = "CustomCell"

class CollectionViewController: UICollectionViewController {

    // UICollectionView
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let numOfPads    = 16
    let numOfColumns = 4
    var currentIndex = 0
    var selectedCells:NSMutableArray = []
    
    // MIDI
    var conductor:Conductor?
    var soundFontPath:String?
    
    func initConfig(){
        collectionView?.backgroundColor = UIColor.white
        collectionView?.indicatorStyle = UIScrollViewIndicatorStyle.white
        //collectionView?.backgroundView = UIView(frame: (collectionView?.frame)!)
        // This makes tapping on the UICollectionViewCell feel zippy
        collectionView?.delaysContentTouches = false
        // Kill any kind of scrolling
        collectionView?.isScrollEnabled = false
    }
    
    func playSound(index:Int){
        //In Piano C4 = MIDI 60
        let note = 60 + index
        conductor?.play(note: note, velocity: 127, duration: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign the SoundFont path passed from the segue
        conductor = Conductor(path: soundFontPath!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        initConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfPads
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
            tap.delegate = self
            tap.minimumPressDuration = 0
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cell.backgroundColor = Utils.sharedInstance.generateRandomColor()
            cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt", selectedCells)
    }
}

extension CollectionViewController:  UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func tap(gestureReconizer: UITapGestureRecognizer) {
        let tapLocation = gestureReconizer.location(in: self.collectionView)
        //using the tapLocation to get the indexPath
        let indexPath = self.collectionView?.indexPathForItem(at: tapLocation)
        //now we can get the cell for item at indexPath
        let cell = self.collectionView?.cellForItem(at: indexPath!)
        
        let index = indexPath![1]
        
        switch gestureReconizer.state {
            case .began:
                currentIndex = index
                playSound(index: currentIndex)
                //now we can get the cell for item at indexPath
                print("tapDown", currentIndex)
                cell?.backgroundColor = UIColor.white
                break
            case .changed:
                //Only listen to the first real change
                cell?.backgroundColor = UIColor.yellow
                if index != currentIndex {
                    currentIndex = index
                    playSound(index: currentIndex)
                    print("changed", currentIndex)
                    cell?.backgroundColor = UIColor.red
                }
                break
            case .ended:
                print("tapUp", currentIndex)
                //now we can get the cell for item at indexPath
                cell?.backgroundColor = UIColor.clear
                break
            default: break
        }
    }
}


extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    //Main view's dimensions change (on rotation, for example), the collection view is re-laid out
    func adjustForOrientationChange(){
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    //Size for Pad
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numOfRows = numOfPads / numOfColumns
        //print(numOfColumns, numOfPads)
        let w = Int(collectionView.bounds.width) / numOfColumns
        let h = Int(collectionView.bounds.height)  / numOfRows
        
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
