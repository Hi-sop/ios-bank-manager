//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit
import BankManager

class ViewController: UIViewController {
    private var mainStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMainStackView()
        initButtonStackView()
        initWorkTimeLabel()
        initWaitingStackView()
        initCustomerStackView()
    }

    private func initMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func makeButton(text: String, color: UIColor) -> UIButton {
        let newButton = UIButton()
        
        newButton.setTitle(text, for: .normal)
        newButton.setTitleColor(color, for: .normal)
        newButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return newButton
    }
    
    private func initButtonStackView() {
        let ButtonStackView = UIStackView()
        ButtonStackView.axis = .horizontal
        ButtonStackView.alignment = .center
        ButtonStackView.distribution = .fillEqually

        let addCustomerButton = makeButton(text: "고객 10명 추가", color: UIColor.systemBlue)
        let resetButton = makeButton(text: "초기화", color: UIColor.systemRed)
 
        ButtonStackView.addArrangedSubview(addCustomerButton)
        ButtonStackView.addArrangedSubview(resetButton)
        
        mainStackView.addArrangedSubview(ButtonStackView)
        
        NSLayoutConstraint.activate([
            ButtonStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            ButtonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    private func initWorkTimeLabel() {
        let workTimeLable = UILabel()
        workTimeLable.text = "업무 시간 - 00:00:000"
        workTimeLable.font = UIFont.systemFont(ofSize: 20)
        
        mainStackView.addArrangedSubview(workTimeLable)
    }
    
    private func makeTitleLabel(text: String, color: UIColor) -> UILabel {
        let newLabel = UILabel()
        newLabel.text = text
        newLabel.textColor = UIColor.white
        newLabel.font = UIFont.systemFont(ofSize: 35)
        newLabel.backgroundColor = color
        newLabel.textAlignment = .center
        return newLabel
    }
    
    private func initWaitingStackView() {
        let waitingStackView = UIStackView()
        waitingStackView.axis = .horizontal
        waitingStackView.alignment = .center
        waitingStackView.distribution = .fillEqually

        let waitingLabel = makeTitleLabel(text: "대기중", color: UIColor.systemGreen)
        let workingLabel = makeTitleLabel(text: "업무중", color: UIColor.systemIndigo)
        
        waitingStackView.addArrangedSubview(waitingLabel)
        waitingStackView.addArrangedSubview(workingLabel)
        
        mainStackView.addArrangedSubview(waitingStackView)
        
        NSLayoutConstraint.activate([
            waitingStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            waitingStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    private func makeCustomerStackView() -> UIStackView {
        let newCustomerStackView = UIStackView()
        newCustomerStackView.axis = .vertical
        newCustomerStackView.alignment = .center
        return newCustomerStackView
    }
    
    private func initCustomerStackView() {
        let customerStackView = UIStackView()
        customerStackView.axis = .horizontal
        customerStackView.alignment = .center
        customerStackView.distribution = .fillEqually
        
        let waitingStackView = makeCustomerStackView()
        let tempLabel = UILabel()
        tempLabel.text = "test"
        waitingStackView.addArrangedSubview(tempLabel)
        
        let workingStackView = makeCustomerStackView()
        customerStackView.addArrangedSubview(waitingStackView)
        customerStackView.addArrangedSubview(workingStackView)
        
        mainStackView.addArrangedSubview(customerStackView)
        
        NSLayoutConstraint.activate([
            customerStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            customerStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
}

