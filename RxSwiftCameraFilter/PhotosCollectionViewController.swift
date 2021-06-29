//
//  PhotosCollectionViewController.swift
//  RxSwiftCameraFilter
//
//  Created by 中野勇貴 on 2021/06/23.
//

import Foundation
import UIKit
import Photos

class PhotosCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }
    
    private func populatePhotos() {
        //フォトライブラリへのアクセス許可
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                //accese the photos form photo library
                
            }
        }
    }
}
