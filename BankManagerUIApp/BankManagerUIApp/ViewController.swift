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
    }

    func initMainStackView() {
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
    
    func initButtonStackView() {
        let ButtonStackView = UIStackView()
        ButtonStackView.axis = .horizontal
        ButtonStackView.alignment = .center
        ButtonStackView.distribution = .equalSpacing
        ButtonStackView.spacing = 120

        let addCustomerButton = UIButton()
        addCustomerButton.setTitle("고객 10명 추가", for: .normal)
        addCustomerButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addCustomerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        let resetButton = UIButton()
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(UIColor.systemRed, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
 
        ButtonStackView.addArrangedSubview(addCustomerButton)
        ButtonStackView.addArrangedSubview(resetButton)
        
        mainStackView.addArrangedSubview(ButtonStackView)
    }
    
    func initWorkTimeLabel() {
        let workTimeLable = UILabel()
        workTimeLable.text = "업무 시간 - 00:00:000"
        workTimeLable.font = UIFont.systemFont(ofSize: 20)
        
        mainStackView.addArrangedSubview(workTimeLable)
    }
    
    func titleLabel(text: String, color: UIColor) -> UILabel {
        let newLabel = UILabel()
        newLabel.text = text
        newLabel.textColor = UIColor.white
        newLabel.font = UIFont.systemFont(ofSize: 35)
        newLabel.backgroundColor = color
        newLabel.textAlignment = .center
        return newLabel
    }
    
    func initWaitingStackView() {
        let waitingStackView = UIStackView()
        waitingStackView.axis = .horizontal
        waitingStackView.alignment = .center
        waitingStackView.distribution = .fillEqually

        let waitingLabel = titleLabel(text: "대기중", color: UIColor.systemGreen)
        let workingLabel = titleLabel(text: "업무중", color: UIColor.systemIndigo)
        
        waitingStackView.addArrangedSubview(waitingLabel)
        waitingStackView.addArrangedSubview(workingLabel)
        
        mainStackView.addArrangedSubview(waitingStackView)
        
        NSLayoutConstraint.activate([
            waitingStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            waitingStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
}

