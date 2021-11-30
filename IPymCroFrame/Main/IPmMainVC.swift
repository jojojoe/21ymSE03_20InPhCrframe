//
//  IPmMainVC.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit
import SwifterSwift
import SnapKit
import Photos
import YPImagePicker
import DeviceKit

class IPmMainVC: UIViewController, UINavigationControllerDelegate {
    
    var isEnterFrame: Bool = false
    var isLock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AFlyerLibManage.event_LaunchApp()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isLock = false
    }
    
    func setupView() {
        view
            .backgroundColor(UIColor.white)
        //
        let bgImgV = UIImageView()
        bgImgV
            .image("homepage_bg")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let settingBtn = UIButton(type: .custom)
        settingBtn
            .image(UIImage(named: "homepage_info"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        //
        let storeBtn = UIButton(type: .custom)
        storeBtn
            .image(UIImage(named: "homepage_coin"))
            .adhere(toSuperview: view)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender: )), for: .touchUpInside)
        //
        //
        let coverImgV = UIImageView()
        coverImgV
            .image("homepage_img")
            .backgroundColor(UIColor.clear)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        
        if Device.current.diagonal >= 5.8 && Device.current.diagonal <= 6.7 {
            coverImgV.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-40)
                $0.left.equalTo(25)
                $0.height.equalTo(UIScreen.main.bounds.width - 25 * 2)
            }
        } else {
            coverImgV.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-40)
                $0.left.equalTo(25)
                $0.height.equalTo(UIScreen.main.bounds.width - 25 * 2)
            }
        }
        
        //
        let frameEditBtn = UIButton(type: .custom)
        frameEditBtn
            .backgroundImage(UIImage(named: "all_btn_primary"))
            .adhere(toSuperview: view)
        frameEditBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            $0.width.equalTo(526/2)
            $0.height.equalTo(114/2)
            
        }
        frameEditBtn.addTarget(self, action: #selector(createnowBtnClick(sender: )), for: .touchUpInside)
        //
        let createnowLabel = UILabel()
        createnowLabel
            .text("Frame")
            .color(UIColor(hexString: "#1B3837")!)
            .fontName(16, "Didot")
            .adhere(toSuperview: view)
        createnowLabel.snp.makeConstraints {
            $0.center.equalTo(frameEditBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let cropEditBtn = UIButton(type: .custom)
        cropEditBtn
            .backgroundImage(UIImage(named: "all_btn_primary"))
            .adhere(toSuperview: view)
        cropEditBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(frameEditBtn.snp.top).offset(-25)
            $0.width.equalTo(526/2)
            $0.height.equalTo(114/2)
            
        }
        cropEditBtn.addTarget(self, action: #selector(cropBtnClick(sender: )), for: .touchUpInside)
        //
        let cropEditLabel = UILabel()
        cropEditLabel
            .text("Crop")
            .color(UIColor(hexString: "#1B3837")!)
            .fontName(16, "Didot")
            .adhere(toSuperview: view)
        cropEditLabel.snp.makeConstraints {
            $0.center.equalTo(cropEditBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
    }

    @objc func settingBtnClick(sender: UIButton) {
        let vc = IPmSettingVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func storeBtnClick(sender: UIButton) {
        let vc = IPmStoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func createnowBtnClick(sender: UIButton) {
        isEnterFrame = true
        checkAlbumAuthorization()
    }
    @objc func cropBtnClick(sender: UIButton) {
        isEnterFrame = false
        checkAlbumAuthorization()
    }
}


extension IPmMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
//                            self.presentPhotoPickerController()
                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
//                                self.presentPhotoPickerController()
                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        picker.navigationBar.backgroundColor = UIColor.white
//        self.navigationController?.pushViewController(picker, animated: true)
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        
        
        if isLock == true {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
            }
        } else {
            isLock = true
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if self.isEnterFrame == true {
                    let vc = IPmFrameEditVC(originalImg: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    
                    let vc = IPmCropEditVC(originalImg: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        
        

    }

}

