//
//  IPmUnlockCoinAlertV.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit

 

class IPmUnlockCoinAlertV: UIView {

   
   var backBtnClickBlock: (()->Void)?
   var okBtnClickBlock: (()->Void)?
   
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       backgroundColor = .clear
       
       setupView()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   @objc func backBtnClick(sender: UIButton) {
       backBtnClickBlock?()
   }
   
   func setupView() {
       backgroundColor = UIColor.black.withAlphaComponent(0.8)
       //
       let bgBtn = UIButton(type: .custom)
       bgBtn
           .image(UIImage(named: ""))
           .adhere(toSuperview: self)
       bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
       bgBtn.snp.makeConstraints {
           $0.left.right.top.bottom.equalToSuperview()
       }
       
       //
       let contentV = UIView()
           .backgroundColor(.clear)
           .adhere(toSuperview: self)
       contentV.layer.cornerRadius = 30
       contentV.layer.masksToBounds = true
       contentV.snp.makeConstraints {
           $0.centerX.equalToSuperview()
           $0.centerY.equalToSuperview().offset(0)
           $0.width.equalTo(343)
           $0.height.equalTo(472)
       }
       //
       let iconImgV = UIImageView()
           .image("popup_bg")
           .contentMode(.scaleAspectFit)
           .adhere(toSuperview: contentV)
       iconImgV.snp.makeConstraints {
           $0.left.right.top.bottom.equalToSuperview()
       }
       //
       let titLab = UILabel()
           .text("Unlocking the paid item will cost \(IPymCoinManager.default.coinCostCount) coins.")
           .textAlignment(.center)
           .numberOfLines(0)
           .fontName(20, "Didot")
           .color(UIColor.black.withAlphaComponent(0.6))
           .adhere(toSuperview: contentV)
       
       titLab.snp.makeConstraints {
           $0.center.equalToSuperview()
           $0.left.equalToSuperview().offset(50)
           $0.height.greaterThanOrEqualTo(1)
       }
       //
        
       let coinImgV = UIImageView()
           .image("store_coin-1")
           .contentMode(.scaleAspectFit)
           .adhere(toSuperview: contentV)
       coinImgV.snp.makeConstraints {
           $0.centerX.equalToSuperview()
           $0.bottom.equalTo(titLab.snp.top).offset(-20)
           $0.width.height.equalTo(256/2)
       }
       //AvenirNext-DemiBold
       let okBtn = UIButton(type: .custom)
       okBtn
           .backgroundImage(UIImage(named: "all_btn_dark"))
           .text("Yes")
           .font(16, "Didot")
           .titleColor(UIColor(hexString: "#EDDCBA")!)
           .adhere(toSuperview: contentV)
       okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
       okBtn.snp.makeConstraints {
           $0.top.equalTo(titLab.snp.bottom).offset(30)
           $0.centerX.equalToSuperview()
           $0.width.equalTo(526/2)
           $0.height.equalTo(112/2)
       }
       //
       let backBtn = UIButton(type: .custom)
       backBtn
           .text("No")
           .font(16, "Didot")
           .titleColor(UIColor(hexString: "#000000")!.withAlphaComponent(0.6))
           .adhere(toSuperview: contentV)
       
       backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
       
       backBtn.snp.makeConstraints {
           $0.top.equalTo(okBtn.snp.bottom).offset(5)
           $0.centerX.equalToSuperview()
           $0.width.equalTo(526/2)
           $0.height.equalTo(112/2)
       }
       //
   }
   @objc func okBtnClick(sender: UIButton) {
       okBtnClickBlock?()
   }
}
