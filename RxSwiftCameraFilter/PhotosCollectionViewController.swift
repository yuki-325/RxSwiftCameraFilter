//
//  PhotosCollectionViewController.swift
//  RxSwiftCameraFilter
//
//  Created by 中野勇貴 on 2021/06/23.
//

import Foundation
import UIKit
import Photos
import RxSwift


class PhotosCollectionViewController: UICollectionViewController {
    
    //フォトライブラリから取得した画像を入れる配列
    private var images = [PHAsset]()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
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
                
                //取得した画像をimagesに格納
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = self.images[indexPath.row]
        
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300.0, height: 300.0), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let _info = info else { return }
            
            //取得した画像がデグレードされたものかどうか
            let isDegradedImage = _info["PHImageResultIsDegradedKey"] as! Bool
            
            if let _image = image {
                
                if !isDegradedImage {
                    self?.selectedPhotoSubject.onNext(_image)
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell is not found.")
        }
        
        let asset = self.images[indexPath.row]
        let maneger = PHImageManager.default()
        
        maneger.requestImage(for: asset, targetSize: CGSize(width: 120.0, height: 120.0), contentMode: .aspectFit, options: nil) { image, _ in
            
            //画像取得後collectionViewCellのimageViewに画像をセット
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
            
        }
        
        return cell
    }
}
