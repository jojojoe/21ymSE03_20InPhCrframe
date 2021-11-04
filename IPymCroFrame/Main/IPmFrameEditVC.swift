//
//  IPmFrameEditVC.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit
import Photos

class IPmFrameEditVC: UIViewController {
    
    var originalImg: UIImage
   
    let backBtn = UIButton(type: .custom)
    let bottomBar = UIView()
    let toolBar = UIView()
    let canvasBgView = UIView()
    let canvasImgBgView = UIView()
    let canvasBgColorImgV = UIImageView()
    let canvasImgV = UIImageView()
    let canvasImgMaskV = UIImageView()
    let canvasFrameBorderV = UIImageView()
    
    var toolBarViews: [UIView] = []
    var bottomBtns: [IPmFrameEditBBtn] = []
    
    let shapeBtn = IPmFrameEditBBtn(frame: .zero, nameStr: "Shape")
    let backgroundBtn = IPmFrameEditBBtn(frame: .zero, nameStr: "Background")
    let frameBtn = IPmFrameEditBBtn(frame: .zero, nameStr: "Frame")
    let stickerBtn = IPmFrameEditBBtn(frame: .zero, nameStr: "Sticker")
    let shapeBar = IPyShapeBar(frame: .zero)
    let backgroundBar = IPyBgColorBar(frame: .zero)
    let frameBar = IPyFrameBar(frame: .zero)
    let stickerBar = IPyStickerBar(frame: .zero)
    let coinAlertView = IPmUnlockCoinAlertV()
    var shouldCostCoin: Bool = false
    var currentShapeItem: IPyStickerItem?
    var currentFrameItem: IPyStickerItem?
    var currentBgColorItem: IPyStickerItem?
    
    
    
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBottomBar()
        setupUnlockAlertView()
        setupCanvasUI()
        
        
        showToolBar(btn: shapeBtn, toolView: shapeBar)
        let aTapGR = UITapGestureRecognizer.init(target: self, action: #selector(editingHandlers))
        canvasBgView.addGestureRecognizer(aTapGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.setupCanvasUI()
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupCanvasUI() {
        
        canvasImgV.image = originalImg
        

    }
    
    func setupView() {
        view
            .backgroundColor(UIColor.white)
        view.clipsToBounds()
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
        
        backBtn
            .image(UIImage(named: "editor_arrow_left"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .text("Next")
            .font(24, "Didot")
            .titleColor(UIColor(hexString: "#EDDCBA")!)
            .adhere(toSuperview: view)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(60)
        }
        
        //
        
        bottomBar
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(64)
        }
        //
        
        toolBar
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        toolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(88)
        }
        //
        let contentBg = UIView()
        contentBg
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        contentBg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        //
        canvasBgView
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
            .clipsToBounds()
        canvasBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(15)
            $0.height.equalTo(UIScreen.main.bounds.width - 15 * 2)
            $0.centerY.equalTo(contentBg.snp.centerY)
        }
        // 用来缩放的view 层

        canvasImgBgView
            .backgroundColor(UIColor.white)
            .adhere(toSuperview: canvasBgView)
        canvasImgBgView.snp.makeConstraints {
            $0.center.equalTo(canvasBgView)
            $0.width.equalTo(canvasBgView.snp.width)
            $0.height.equalTo(canvasBgView.snp.height)
        }
        
        //

        canvasBgColorImgV
            .clipsToBounds(true)
            .contentMode(.scaleAspectFill)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: canvasImgBgView)
        canvasBgColorImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        //

        canvasImgV
            .clipsToBounds(true)
            .contentMode(.scaleAspectFill)
            .backgroundColor(UIColor.orange)
            .adhere(toSuperview: canvasImgBgView)
        canvasImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        canvasImgMaskV
            .clipsToBounds(true)
            .contentMode(.scaleAspectFill)
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: canvasImgBgView)
        canvasImgMaskV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        canvasFrameBorderV
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: canvasBgView)
        canvasFrameBorderV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }

    func setupBottomBar() {
        let btnwidth = UIScreen.main.bounds.width / 4
        
        //
        
        shapeBtn
            .adhere(toSuperview: bottomBar)
        shapeBtn.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(bottomBar)
            $0.width.equalTo(btnwidth)
        }
        shapeBtn.addTarget(self, action: #selector(shapeBtnClick(sender: )), for: .touchUpInside)
        
        //
        //
        
        backgroundBtn
            .adhere(toSuperview: bottomBar)
        backgroundBtn.snp.makeConstraints {
            $0.left.equalTo(shapeBtn.snp.right)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(bottomBar)
            $0.width.equalTo(btnwidth)
        }
        backgroundBtn.addTarget(self, action: #selector(backgroundBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        frameBtn
            .adhere(toSuperview: bottomBar)
        frameBtn.snp.makeConstraints {
            $0.left.equalTo(backgroundBtn.snp.right)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(bottomBar)
            $0.width.equalTo(btnwidth)
        }
        frameBtn.addTarget(self, action: #selector(frameBtnClick(sender: )), for: .touchUpInside)
        //
        
        stickerBtn
            .adhere(toSuperview: bottomBar)
        stickerBtn.snp.makeConstraints {
            $0.left.equalTo(frameBtn.snp.right)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(bottomBar)
            $0.width.equalTo(btnwidth)
        }
        stickerBtn.addTarget(self, action: #selector(stickerBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        shapeBar.adhere(toSuperview: toolBar)
        shapeBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        shapeBar.shapeClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateShape(item: item)
            }
        }
        //
        
        backgroundBar.adhere(toSuperview: toolBar)
        backgroundBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        backgroundBar.itemClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBg(item: item)
            }
        }
        //
        
        frameBar.adhere(toSuperview: toolBar)
        frameBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        frameBar.itemClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateFrame(item: item)
            }
        }
        //
        
        stickerBar.adhere(toSuperview: toolBar)
        stickerBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        stickerBar.stickerClickBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let stickerImage = UIImage(named: item.bigName ?? "") else {return}
            IPyymAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: item, atView: self.canvasBgView)
        }
        
        toolBarViews = [shapeBar, backgroundBar, frameBar, stickerBar]
        bottomBtns = [shapeBtn, backgroundBtn, frameBtn, stickerBtn]
        
        
    }
 
    @objc func editingHandlers() {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
}

extension IPmFrameEditVC {
    func showToolBar(btn: IPmFrameEditBBtn, toolView: UIView) {
        for btn_m in bottomBtns {
            if btn == btn_m {
                btn_m.isCurrentSelect(isSelect: true)
            } else {
                btn_m.isCurrentSelect(isSelect: false)
            }
        }
        for toolView_m in toolBarViews {
            if toolView_m == toolView {
                toolView_m.isHidden = false
            } else {
                toolView_m.isHidden = true
            }
        }
    }
    
    func updateShape(item: IPyStickerItem) {
        currentShapeItem = item
        if item.bigName == "" {
            
            canvasImgMaskV.image = UIImage(named: "color_1_big")
            canvasImgV.layer.mask = canvasImgMaskV.layer
        } else {
            canvasImgMaskV.image = UIImage(named: item.bigName ?? "")
            canvasImgV.layer.mask = canvasImgMaskV.layer
        }
        
    }
    func updateBg(item: IPyStickerItem) {
        currentBgColorItem = item
        canvasBgColorImgV.image = UIImage(named: item.bigName ?? "")
    }
    func updateFrame(item: IPyStickerItem) {
        currentFrameItem = item
        canvasFrameBorderV.image = UIImage(named: item.bigName ?? "")
        if item.bigName == "" {
            canvasImgBgView.transform = CGAffineTransform.identity
        } else {
            canvasImgBgView.transform = CGAffineTransform(scaleX: 2/3, y: 2/3)
        }
        
        
    }
    
    
}


extension IPmFrameEditVC {
    @objc func backBtnClick(sender: UIButton) {
        IPyymAddonManager.default.clearAddonManagerDefaultStatus()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        if checkTopProAlertStatus() {
            shouldCostCoin = true
            showUnlockCoinAlertView()
        } else {
            shouldCostCoin = false
            savePhotoAction()
        }
    }
    
    @objc func shapeBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        showToolBar(btn: shapeBtn, toolView: shapeBar)
    }
    
    @objc func backgroundBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        showToolBar(btn: backgroundBtn, toolView: backgroundBar)
    }
    
    @objc func frameBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        showToolBar(btn: frameBtn, toolView: frameBar)
    }
    
    @objc func stickerBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        showToolBar(btn: stickerBtn, toolView: stickerBar)
    }
    
    func checkTopProAlertStatus() -> Bool {
        var isStickerPro: Bool = false
        
        for stickerView in IPyymAddonManager.default.addonStickersList {
            if stickerView.stikerItem?.isPro == true {
                isStickerPro = true
                break
            }
        }
        
        if let currentShapeItem_m = currentShapeItem, currentShapeItem_m.isPro == true {
            isStickerPro = true
        }
        if let currentFrameItem_m = currentFrameItem, currentFrameItem_m.isPro == true {
            isStickerPro = true
        }
        if let currentBgColorItem_m = currentBgColorItem, currentBgColorItem_m.isPro == true {
            isStickerPro = true
        }
        return isStickerPro
    }
}

extension IPmFrameEditVC {
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    func savePhotoAction() {
        if let img = canvasBgView.screenshot {
            saveToAlbumPhotoAction(images: [img])
        }
    }
    
    func showUnlockCoinAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if IPymCoinManager.default.coinCount >= IPymCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    self.savePhotoAction()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Not enough coins available, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.present(IPmStoreVC(), animated: true, completion: nil)
                            
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                 
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { _ in
                
            }
        }
    }
}

extension IPmFrameEditVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
                        if self.shouldCostCoin {
                            IPymCoinManager.default.costCoin(coin: IPymCoinManager.default.coinCostCount)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo saved successful.")
    }
    
    func showDenideAlert() {
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
    }
    
}

class IPmFrameEditBBtn: UIButton {
    var nameStr: String
    let nameLabel = UILabel()
    let pointV = UIView()
    
    init(frame: CGRect, nameStr: String) {
        self.nameStr = nameStr
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        nameLabel
            .fontName(14, "Didot")
            .color(UIColor(hexString: "#EDDCBA")!)
            .text(nameStr)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-5)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        pointV.backgroundColor(UIColor(hexString: "#EDDCBA")!)
            .adhere(toSuperview: self)
        pointV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.width.height.equalTo(6)
        }
        pointV.layer.cornerRadius = 3
        
    }
    
    func isCurrentSelect(isSelect: Bool) {
        if isSelect == true {
            nameLabel
                .color(UIColor(hexString: "#EDDCBA")!)
            pointV.isHidden = false
        } else {
            nameLabel
                .color(UIColor(hexString: "#EDDCBA")!.withAlphaComponent(0.5))
            pointV.isHidden = true
        }
    }
    
}




