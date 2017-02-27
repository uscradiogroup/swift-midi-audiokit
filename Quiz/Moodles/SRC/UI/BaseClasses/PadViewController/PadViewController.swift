//
//  ViewController.swift
//  LoadMIDI
//
//  Created by Artem Chabannyi on 9/13/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import UIKit
import AudioKit
import MagicalRecord
import PromiseKit


class PadViewController:
UIViewController,
ViewControllerRootView,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    typealias RootViewType = PadView
    
    private var cellSzie = CGSize()
    private var settings = MDMetronomeUserSettings()
    private var cachedPadSheetSize = CGSize(width: 4, height: 6)
    
    private var padSheetSize: CGSize {
        get {
            if UIDevice.current.orientation.isPortrait {
                cachedPadSheetSize = CGSize(width: 4, height: 6)
                return cachedPadSheetSize
            }
            if UIDevice.current.orientation.isLandscape {
                cachedPadSheetSize = CGSize(width: 6, height: 4)
                return cachedPadSheetSize
            }
            return cachedPadSheetSize
        }
    }
    
    lazy var notes: [Note] = {
        return Note.LoadNotesFromPList()
    }()
    
    
    // MARK: - Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(redrawPad),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        cellSzie = calcCellSize(rootView.collectionView.frame.size, padSize: padSheetSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        redrawPad()
    }
    
    // MARK: - Interface actions
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                          numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PadCell", for: indexPath) as! PadCell
        cell.fillFrom(model: notes[(indexPath as NSIndexPath).item])
        cell.showNote(settings.showNotes)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cellSizeFor(collectionView, indexPath: indexPath)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, 1)
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    @objc private func redrawPad() {
        cellSzie = calcCellSize(rootView.collectionView.frame.size, padSize: padSheetSize)
        rootView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func cellSizeFor(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        return cellSzie
    }
    
    fileprivate func calcCellSize(_ viewSize: CGSize, padSize: CGSize) -> CGSize {
        let viewWidth = viewSize.width / padSize.width - padSize.width
        let viewHeight = viewSize.height / padSize.height - padSize.height
 
        let size: CGSize = CGSize(width: viewWidth,
                                  height: viewHeight)
        
        return size
    }
    
    
}


extension UIViewController {
    
    func presentAlertWithBlackKeyboard(title: String,
                                   message: String?,
                                   placeholder:String?,
                                   cancel: String,
                                   confirm: String,
                                   onConfirm: @escaping (String?) -> Void,
                                   onCancel: (() -> Void)? = nil) {
        let alertController = alertWithTextField(title: title,
                                                 message: message,
                                                 placeholder: placeholder,
                                                 cancel: cancel,
                                                 confirm: confirm,
                                                 onConfirm: onConfirm,
                                                 onCancel: onCancel)
        alertController.textFields?.first?.keyboardAppearance = UIKeyboardAppearance.dark
        self.present(alertController, animated: true, completion: nil)
    }
    
}
