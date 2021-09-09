//
//  ErrorPageView.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import Foundation
import SnapKit

class ErrorPageView: UIView {
    
    // MARK: - Properties
    
    private let errorBox = UIStackView()
    private let titleTextLabel = UILabel()
    private let descriptionTextLabel = UILabel()
    private let mainButton = UIButton(type: .system)
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
        mainButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setData(with title: String, message: String, buttonText: String) {
        titleTextLabel.text = title
        descriptionTextLabel.text = message
        mainButton.setTitle(buttonText, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        didPressButton?()
    }
    
    var didPressButton: (() -> Void)?
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(errorBox)
        
        errorBox.snp.makeConstraints { (make) in
            make.leading.equalTo(Constants.Design.basicInset)
            make.trailing.equalTo(-Constants.Design.basicInset)
            make.top.greaterThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.centerY.equalToSuperview()
        }
        
        errorBox.addArrangedSubview(titleTextLabel)
        errorBox.addArrangedSubview(descriptionTextLabel)
        errorBox.addArrangedSubview(mainButton)
        
        mainButton.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Button.height)
            make.width.equalTo(errorBox.snp.width).dividedBy(Constants.Button.divison)
        }
        
    }
    
    private func initializeUI() {
        backgroundColor = .white
        setupErrorBox()
        setupTitleLabel()
        setupDescriptionLabel()
        setupRefreshButton()
    }
    
    private func setupErrorBox() {
        errorBox.alignment = .center
        errorBox.axis = .vertical
        errorBox.spacing = Constants.Design.spacingMain
    }
    
    private func setupTitleLabel() {
        titleTextLabel.font = UIFont.systemFont(ofSize: UIFont.big, weight: .semibold)
        titleTextLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.font = UIFont.systemFont(ofSize: UIFont.standart, weight: .light)
    }
    
    private func setupRefreshButton() {
        mainButton.backgroundColor = .none
        mainButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.standart, weight: .light)
        mainButton.setTitleColor(.systemBlue, for: .normal)
        mainButton.setTitleColor(.black, for: .selected)
        mainButton.layer.cornerRadius = Constants.Design.cornerRadiusError
        mainButton.layer.borderWidth = Constants.Design.borderWidthSecondary
        mainButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
}

// MARK: - Constants

private extension Constants {
    struct Button {
        static let height = CGFloat(45)
        static let divison = CGFloat(1.15)
    }
}
