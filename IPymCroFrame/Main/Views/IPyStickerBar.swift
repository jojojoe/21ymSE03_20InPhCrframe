//
//  IPyStickerBar.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit

 

class IPyStickerBar: UIView {
    var collection: UICollectionView!
    
    var stickerList: [IPyStickerItem] = []
    var currentItem: IPyStickerItem?
    
    var stickerClickBlock: ((IPyStickerItem)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        stickerList = DataManager.default.stickerList
        
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: IPymStickerCell.self)
    }
    

}

extension IPyStickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IPymStickerCell.self, for: indexPath)
        let item = stickerList[indexPath.item]
        cell.contentImgV.image(item.thumbName)
        if currentItem?.thumbName == item.thumbName {
            cell.selectBgView.isHidden = false
        } else {
            cell.selectBgView.isHidden = true
        }
        if item.isPro == true {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension IPyStickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension IPyStickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = stickerList[indexPath.item]
        currentItem = item
        collectionView.reloadData()
        stickerClickBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class IPymStickerCell: UICollectionViewCell {
    let bgView = UIView()
    let selectBgView = UIView()
    let contentImgV = UIImageView()
    let proImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgView
            .backgroundColor(UIColor(hexString: "#F2DEAA")!)
            .adhere(toSuperview: contentView)
        bgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(72)
        }
        bgView.layer.cornerRadius = 8
        //
//        selectBgView
//            .backgroundColor(UIColor.clear)
//            .adhere(toSuperview: contentView)
//        selectBgView.layer.cornerRadius = 65/2
//        selectBgView.layer.borderColor = UIColor(hexString: "#EB6601")?.cgColor
//        selectBgView.layer.borderWidth = 2
//        selectBgView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.height.equalTo(65)
//        }
        
        
        //
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalTo(contentView)
            $0.width.height.equalTo(56)
        }
        //
        proImgV
            .image("editor_coin")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        proImgV.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(-6.5)
            $0.right.equalTo(bgView).offset(6.5)
            $0.width.height.equalTo(13)
        }
        
    }
}


