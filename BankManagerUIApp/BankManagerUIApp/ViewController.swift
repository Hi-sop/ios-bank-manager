//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit
import BankManager

final class ViewController: UIViewController, CustomerOnScreen {
    private var bankManager = BankManager(bankName: "Hisop")
    private var mainStackView = UIStackView()
    private var waitingStackView = UIStackView()
    private var workingStackView = UIStackView()
    
    private var workTimeLable = UILabel()
    private var workTime: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankManager.bank.delegate = self
        DispatchQueue.global().async(execute: { self.bankManager.bank.open() })
        
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

        addCustomerButton.addTarget(self, action: #selector(touchUpInsideAddCustomer), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(touchUpInsideReset), for: .touchUpInside)
        
        ButtonStackView.addArrangedSubview(addCustomerButton)
        ButtonStackView.addArrangedSubview(resetButton)
        
        mainStackView.addArrangedSubview(ButtonStackView)
        
        NSLayoutConstraint.activate([
            ButtonStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            ButtonStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    @objc
    private func touchUpInsideAddCustomer() {
        bankManager.bank.clickAddCustomer()
    }
    
    @objc
    private func touchUpInsideReset() {
        bankManager.bank.reset()
        for label in waitingStackView.arrangedSubviews {
            waitingStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
        
        for label in workingStackView.arrangedSubviews {
            workingStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
    }
    
    func addScreen(customer: Customer, screen: Screen) {
        let newLabel = UILabel()
        var stackView: UIStackView
        
        switch screen {
        case .waiting:
            stackView = waitingStackView
        case .working:
            stackView = workingStackView
        }
        
        if customer.business == .loan {
            newLabel.textColor = UIColor.systemPurple
        }
        newLabel.font = UIFont.systemFont(ofSize: 20)
        newLabel.tag = customer.number
        newLabel.text = "\(customer.number) - \(customer.business.rawValue)"
        stackView.addArrangedSubview(newLabel)
        stackView.layoutIfNeeded()
    }
    
    func deleteScreen(customer: Customer, screen: Screen) {
        var stackView: UIStackView
        
        switch screen {
        case .waiting:
            stackView = waitingStackView
        case .working:
            stackView = workingStackView
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(where: { $0.tag == customer.number} ) {
            stackView.arrangedSubviews[index].removeFromSuperview()
        }
        stackView.layoutIfNeeded()
    }
    
    private func initWorkTimeLabel() {
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
    
    private func initStackView() {
        waitingStackView.axis = .vertical
        workingStackView.axis = .vertical
        
        waitingStackView.alignment = .center
        workingStackView.alignment = .center
    }
    
    private func initCustomerStackView() {
        let customerStackView = UIStackView()
        customerStackView.axis = .horizontal
        customerStackView.alignment = .top
        customerStackView.distribution = .fillEqually
        
        initStackView()
        
        customerStackView.addArrangedSubview(waitingStackView)
        customerStackView.addArrangedSubview(workingStackView)
        
        mainStackView.addArrangedSubview(customerStackView)
        
        NSLayoutConstraint.activate([
            customerStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            customerStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
}

