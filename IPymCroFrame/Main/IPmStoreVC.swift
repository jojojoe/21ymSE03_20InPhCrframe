//
//  IPmStoreVC.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit
import NoticeObserveKit
import ZKProgressHUD

class IPmStoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    var collection: UICollectionView!
    let topCoinLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupView()
        addNotificationObserver()
        
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = ( "\(IPymCoinManager.default.coinCount)")
            }
        }
        .invalidated(by: pool)
        
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
        
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "editor_arrow_left"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
         
        //
        let iconImgV = UIImageView()
        iconImgV
            .image("store_coin-1")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.width.height.equalTo(100)
        }
        
        //
        
        topCoinLabel
            .color(UIColor(hexString: "#EDDCBA")!)
            .text("\(IPymCoinManager.default.coinCount)")
            .fontName(24, "Didot")
            .adhere(toSuperview: view)
        topCoinLabel.snp.makeConstraints {
            $0.top.equalTo(iconImgV.snp.bottom).offset(10)
            $0.centerX.equalTo(iconImgV.snp.centerX)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
         
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: IpymStoreCell.self)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }

}


extension IPmStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IpymStoreCell.self, for: indexPath)
        let item = IPymCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "x \(item.coin)"
        if let localPrice = item.localPrice {
            cell.priceLabel.text = item.localPrice
        } else {
            cell.priceLabel.text = "$\(item.price)"
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IPymCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension IPmStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let cellwidth: CGFloat = UIScreen.main.bounds.width
        let cellHeight: CGFloat = 100
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 22
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 12
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 12
        return padding
    }
    
}

extension IPmStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = IPymCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func selectCoinItem(item: IPyStoreItem) {
        // core
        PurchaseManagerLink.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                ZKProgressHUD.showSuccess("Purchase successful.")
            } else {
                ZKProgressHUD.showError("Purchase failed.")
            }
        }
        //
        
//        IPymCoinManager.default.purchaseIapId(item: item) { (success, errorString) in
//
//            if success {
//                ZKProgressHUD.showSuccess("Purchase successful.")
//            } else {
//                ZKProgressHUD.showError("Purchase failed.")
//            }
//        }
    }
    
}

class IpymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var iconImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear //UIColor(hexString: "#149CF5")?.withAlphaComponent(0.2)
        bgView.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        iconImageV.backgroundColor = .clear
        iconImageV.contentMode = .scaleAspectFit
        iconImageV.image = UIImage(named: "store_coin")
        contentView.addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(60)
            $0.width.equalTo(38)
            $0.height.equalTo(38)
            
        }
         
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel
            .color(UIColor(hexString: "#EDDCBA")!)
            .numberOfLines(1)
            .fontName(16, "AvenirNext-Bold")
            .textAlignment(.left)
            .adhere(toSuperview: bgView)

        coinCountLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageV.snp.right).offset(13)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        //
        bgView.addSubview(priceBgImgV)
        priceBgImgV
            .contentMode(.scaleToFill)
            .image("Subtract")
//        priceBgImgV.layer.cornerRadius = 8
//        priceBgImgV.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        priceBgImgV.layer.shadowOffset = CGSize(width: 0, height: 2)
//        priceBgImgV.layer.shadowRadius = 2
//        priceBgImgV.layer.shadowOpacity = 0.8
//
        
        priceBgImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-56)
            $0.width.equalTo(187/2)
            $0.height.equalTo(66/2)
        }
        
        //
        priceLabel.textColor = UIColor(hexString: "#1B3837")
        priceLabel.font = UIFont(name: "Didot", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.center.equalTo(priceBgImgV)
            $0.height.greaterThanOrEqualTo(22)
            $0.left.equalTo(priceBgImgV.snp.left).offset(6)
        }
        
        //
        let bottomLine = UIView()
        bottomLine
            .backgroundColor(UIColor(hexString: "#EDDCBA")!)
            .adhere(toSuperview: contentView)
        bottomLine.snp.makeConstraints {
            $0.left.equalTo(56)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
     
}

