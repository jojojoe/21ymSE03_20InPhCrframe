//
//  IPyBgColorBar.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit

 
class IPyBgColorBar: UIView {
   var collection: UICollectionView!
   
   var itemList: [IPyStickerItem] = []
   var currentItem: IPyStickerItem?
   
   var itemClickBlock: ((IPyStickerItem)->Void)?
   
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       loadData()
       setupView()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   func loadData() {
       itemList = DataManager.default.backgroundList
       currentItem = itemList.first
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
       collection.register(cellWithClass: IPymColorCell.self)
   }
   

}

extension IPyBgColorBar: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withClass: IPymColorCell.self, for: indexPath)
       let item = itemList[indexPath.item]
       cell.contentImgV.image(item.thumbName)
       cell.bgView.layer.cornerRadius = cell.bounds.size.width / 2
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
       return itemList.count
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
   }
   
}

extension IPyBgColorBar: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width: CGFloat = (UIScreen.main.bounds.width - 16 * 2 - 8 * 7 - 1) / 8
       
       return CGSize(width: width, height: width)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 8
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 8
   }
   
}

extension IPyBgColorBar: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let item = itemList[indexPath.item]
       currentItem = item
       collectionView.reloadData()
       itemClickBlock?(item)
   }
   
   func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
   }
}



class IPymColorCell: UICollectionViewCell {
   let bgView = UIView()
   let selectBgView = UIImageView()
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
           .backgroundColor(UIColor.clear)
           .adhere(toSuperview: contentView)
       bgView.snp.makeConstraints {
           $0.center.equalToSuperview()
           $0.left.top.equalToSuperview()
       }
       bgView.clipsToBounds = true
       
       //
       selectBgView
           .backgroundColor(UIColor.clear)
           .image("editor_select")
           .adhere(toSuperview: contentView)
       
       
       selectBgView.snp.makeConstraints {
           $0.center.equalToSuperview()
           $0.left.top.equalToSuperview()
       }
       
       
       //
       contentImgV.contentMode = .scaleAspectFit
       contentImgV.clipsToBounds = true
       bgView.addSubview(contentImgV)
       contentImgV.snp.makeConstraints {
           $0.center.equalTo(contentView)
           $0.left.top.equalToSuperview()
       }
       //
       proImgV
           .image("editor_coin")
           .contentMode(.scaleAspectFit)
           .adhere(toSuperview: contentView)
       proImgV.snp.makeConstraints {
           $0.top.right.equalTo(bgView)
           $0.width.height.equalTo(13)
       }
       
   }
}


