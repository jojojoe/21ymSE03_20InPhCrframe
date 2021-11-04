//
//  IPyShapeBar.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit
import DeviceKit

class IPyShapeBar: UIView {
  var collection: UICollectionView!
  
  var shapeList: [IPyStickerItem] = []
  var currentItem: IPyStickerItem?
  
  var shapeClickBlock: ((IPyStickerItem)->Void)?
  
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      loadData()
      setupView()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func loadData() {
      shapeList = DataManager.default.shapeList
      currentItem = shapeList.first
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
      collection.register(cellWithClass: IPymShapeCell.self)
  }
  

}

extension IPyShapeBar: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withClass: IPymShapeCell.self, for: indexPath)
      let item = shapeList[indexPath.item]
      cell.contentImgV.image(item.thumbName)
      if currentItem?.thumbName == item.thumbName {
          cell.contentImgV.image("\(item.thumbName ?? "")\("_selected")")
      } else {
          cell.contentImgV.image("\(item.thumbName ?? "")")
      }
      if item.isPro == true {
          cell.proImgV.isHidden = false
      } else {
          cell.proImgV.isHidden = true
      }
      
      return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return shapeList.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }
  
}

extension IPyShapeBar: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
          return CGSize(width: 80, height: 80)
      }
      return CGSize(width: 88, height: 88)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
          return 0
      }
      return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      if Device.current.diagonal == 4.7 || Device.current.diagonal >= 6.9 {
          return 0
      }
      return 2
  }
  
}

extension IPyShapeBar: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let item = shapeList[indexPath.item]
      currentItem = item
      collectionView.reloadData()
      shapeClickBlock?(item)
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      
  }
}



class IPymShapeCell: UICollectionViewCell {
  let bgView = UIView()
//  let selectBgView = UIView()
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
          $0.width.height.equalTo(88)
      }
      
      //
//      selectBgView
//          .backgroundColor(UIColor.clear)
//          .adhere(toSuperview: contentView)
//      selectBgView.layer.cornerRadius = 65/2
//      selectBgView.layer.borderColor = UIColor(hexString: "#EB6601")?.cgColor
//      selectBgView.layer.borderWidth = 2
//      selectBgView.snp.makeConstraints {
//          $0.center.equalToSuperview()
//          $0.width.height.equalTo(65)
//      }
      
      
      //
      contentImgV.contentMode = .scaleAspectFit
      contentImgV.clipsToBounds = true
      contentView.addSubview(contentImgV)
      contentImgV.snp.makeConstraints {
          $0.center.equalTo(contentView)
          $0.width.height.equalTo(54)
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


