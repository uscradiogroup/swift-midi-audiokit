//
//  ViewController.swift
//  CollectionView
//
//  Created by Tommy Trojan on 10/14/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Get Path to SoundFont found in Assets.plist
    func onLoad(){
        self.performSegue(withIdentifier: "onLoadSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CollectionViewController
            vc.soundFontPath = Config().soundFontPath()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

