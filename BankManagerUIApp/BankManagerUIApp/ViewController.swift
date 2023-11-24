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
            //mainStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
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
    
    func initWaitingTitle() {
        
    }
}

