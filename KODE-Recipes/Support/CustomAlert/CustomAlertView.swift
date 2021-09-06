//
//  ErrorPageView.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import Foundation
import SnapKit

class CustomAlertView: UIView {
    
    let errorBox = UIStackView()
    let titleTextLabel = UILabel()
    let descriptionTextLabel = UILabel()
    let refreshButton = UIButton(type: .system)
    
    var didPressButton: (() -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        
        backgroundColor = .white
        
        errorBox.alignment = .center
        errorBox.axis = .vertical
        errorBox.spacing = Constants.Design.spacingMain
        
        titleTextLabel.font = UIFont.systemFont(ofSize: Constants.Font.big, weight: .semibold)
        titleTextLabel.numberOfLines = 0
        
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.font = UIFont.systemFont(ofSize: Constants.Font.standart, weight: .light)

        refreshButton.backgroundColor = .none
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        refreshButton.setTitleColor(.black, for: .selected)
        refreshButton.layer.cornerRadius = Constants.Design.cornerRadiusError
        refreshButton.layer.borderWidth = Constants.Design.borderWidthSecondary
        refreshButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        refreshButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }

    @objc func buttonPressed() {
        didPressButton?()
    }
    
    func setData(with title: String, message: String, buttonText: String) {
        titleTextLabel.text = title
        descriptionTextLabel.text = message
        refreshButton.setTitle(buttonText, for: .normal)
    }
    
    private func createConstraints() {
        addSubview(errorBox)
        
        errorBox.snp.makeConstraints { (make) in
        make.leftMargin.equalTo(20)
        make.rightMargin.equalTo(-20)
        make.topMargin.greaterThanOrEqualTo(20)
        make.bottomMargin.lessThanOrEqualTo(-20)
        make.centerY.equalToSuperview() }
        
        errorBox.addArrangedSubview(titleTextLabel)
        errorBox.addArrangedSubview(descriptionTextLabel)
        errorBox.addArrangedSubview(refreshButton)
        
        refreshButton.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.width.equalTo(errorBox.snp.width).dividedBy(1.15)
        }
    }
    
}
