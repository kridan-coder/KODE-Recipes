//
//  ErrorPageView.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import Foundation
import SnapKit

class ErrorPageView: UIView {
    
    let errorBox = UIStackView()
    let titleTextLabel = UILabel()
    let descriptionTextLabel = UILabel()
    let refreshButton = UIButton(type: .system)
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUI() {
        backgroundColor = .white
        
        errorBox.alignment = .center
        errorBox.axis = .vertical
        errorBox.spacing = Constants.Design.spacingMain
        
        titleTextLabel.font = UIFont.systemFont(ofSize: Constants.Font.big, weight: .semibold)
        titleTextLabel.numberOfLines = 0
        
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.font = UIFont.systemFont(ofSize: Constants.Font.standart, weight: .light)


        
        addSubview(errorBox)
        
//        errorBox.addSubview(titleTextLabel)
//        errorBox.addSubview(descriptionTextLabel)
//        errorBox.addSubview(refreshButton)
//        errorBox.subviews.a
        
        //errorBox.backgroundColor = .blue
//        errorBox.didAddSubview(titleTextLabel)
//        errorBox.didAddSubview(descriptionTextLabel)
//        errorBox.didAddSubview(refreshButton)
        
        
        refreshButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        

        
        refreshButton.backgroundColor = .none
       
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        
        refreshButton.setTitleColor(.black, for: .selected)
        
        refreshButton.layer.cornerRadius = Constants.Design.cornerRadiusError
        refreshButton.layer.borderWidth = Constants.Design.borderWidthSecondary
        refreshButton.layer.borderColor = UIColor.systemBlue.cgColor
        
    }

    @objc func buttonPressed() {
        print("pressed!")
    }
    
    func createConstraints() {
        errorBox.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(-20)
            make.topMargin.greaterThanOrEqualTo(20)
            make.bottomMargin.lessThanOrEqualTo(-20)
            make.centerY.equalToSuperview()
        }
        
        errorBox.addArrangedSubview(titleTextLabel)
        errorBox.addArrangedSubview(descriptionTextLabel)
        errorBox.addArrangedSubview(refreshButton)
        
        
        refreshButton.snp.makeConstraints { (make) in
            make.leftMargin.rightMargin.equalToSuperview()
            make.height.equalTo(45)
        }
        
//        titleTextLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//
//        descriptionTextLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//
//        refreshButton.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
    }
    
}
