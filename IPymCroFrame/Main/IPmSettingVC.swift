//
//  IPmSettingVC.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//

import UIKit
import SwifterSwift
import MessageUI

class IPmSettingVC: UIViewController {

    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "editor_arrow_left"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        let iconImgV = UIImageView()
        iconImgV
            .image("setting_img")
            .adhere(toSuperview: view)
            .contentMode(.scaleAspectFit)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(35)
            $0.width.equalTo(516/2)
            $0.height.equalTo(516/2)
        }
        
        
        //
        //
        feedbackBtn
            .title("Feedback")
            .backgroundImage(UIImage(named: "all_btn_default"))
            .titleColor(UIColor(hexString: "#EDDCBA")!)
            .font(16, "Didot")
            .adhere(toSuperview: view)
        
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(526/2)
            $0.height.equalTo(114/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(45)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        //
        privacyBtn
            .title("Privacy Policy")
            .backgroundImage(UIImage(named: "all_btn_default"))
            .titleColor(UIColor(hexString: "#EDDCBA")!)
            .font(16, "Didot")
            .adhere(toSuperview: view)
        
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(526/2)
            $0.height.equalTo(114/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(20)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        termsBtn
            .title("Terms of use")
            .backgroundImage(UIImage(named: "all_btn_default"))
            .titleColor(UIColor(hexString: "#EDDCBA")!)
            .font(16, "Didot")
            .adhere(toSuperview: view)
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(526/2)
            $0.height.equalTo(114/2)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(20)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func privacyBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        let vc = HighLightingViewController(contentUrl: nil)
        vc.pushSaferiVC(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: TermsofuseURLStr)
        let vc = HighLightingViewController(contentUrl: nil)
        vc.pushSaferiVC(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
}

extension IPmSettingVC: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}
