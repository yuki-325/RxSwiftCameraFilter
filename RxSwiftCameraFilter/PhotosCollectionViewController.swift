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
    
    //フォトライブラリから取得した画像を入れる配列
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatePhotos()
    }
    
    private func populatePhotos() {
        //フォトライブラリへのアクセス許可
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            if status == .authorized {
                //accese the photos form photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                
                assets.enumerateObjects { object, count, stop in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            }
            
        }
    }
}

extension PhotosCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found.")
        }
        
        let asset = self.images[indexPath.row]
        let maneger = PHImageManager.default()
        
        maneger.requestImage(for: asset, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFill, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
}
