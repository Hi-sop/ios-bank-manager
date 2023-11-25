//
//  Bank.swift
//
//
//  Created by Hisop on 2023/11/17.
//

import Foundation

public protocol CustomerOnScreen {
    func addScreen(customer: Customer, screen: Screen)
    func deleteScreen(customer: Customer, screen: Screen)
    var timerStatus: Bool { get set }
}

public final class Bank {
    private var name: String
    private var customerCount: Int = 0
    private(set) var workTime: Double = 0
    private var customerNumber: Int = 1
    private var isOpen: Bool = true
    
    private let customerQueue = CustomerQueue<Customer>()
    private let depositQueue = CustomerQueue<Customer>()
    private let loanQueue = CustomerQueue<Customer>()
    
    private let depositSemaphore = DispatchSemaphore(value: 1)
    private let loanSemaphore = DispatchSemaphore(value: 1)
    private let BankSemaphore = DispatchSemaphore(value: 1)
    private let group = DispatchGroup()
    
    private var employeesList: [Employees] = []
    public var delegate: CustomerOnScreen?
    
    init(name: String, chargeDepositCount: Int, chargeLoanCount: Int) {
        self.name = name
        for _ in 1...chargeDepositCount {
            employeesList.append(Employees(business: .deposit, semaphore: depositSemaphore))
        }
        for _ in 1...chargeLoanCount {
            employeesList.append(Employees(business: .loan, semaphore: loanSemaphore))
        }
    }
    
    public func open() {
        employeesWork()
        endWork()
    }
    
    public func clickAddCustomer() {
        addCustomer()
        addQueue()
    }
    
    private func addQueue() {
        while customerQueue.isEmpty() == false {
            guard let customer = customerQueue.dequeue() else {
                return
            }
            switch customer.business {
            case .deposit:
                depositSemaphore.wait()
                depositQueue.enqueue(value: customer)
                depositSemaphore.signal()
            case .loan:
                loanSemaphore.wait()
                loanQueue.enqueue(value: customer)
                loanSemaphore.signal()
            }
        }
    }
    
    private func employeesWork() {
        for employees in employeesList {
            DispatchQueue.global().async(group: group, execute: makeWork(employees: employees))
        }
        group.wait()
    }
    
    private func makeWork(employees: Employees) -> DispatchWorkItem {
        DispatchWorkItem(block: { [self] in
            var queue: CustomerQueue<Customer>
            switch employees.business {
            case .deposit:
                queue = depositQueue
            case .loan:
                queue = loanQueue
            }
            while isOpen {
                employees.semaphore.wait()
                guard let customer = queue.dequeue() else {
                    employees.semaphore.signal()
                    continue
                }
                employees.semaphore.signal()

                DispatchQueue.main.sync(execute: {
                    delegate?.deleteScreen(customer: customer, screen: .waiting)
                    delegate?.addScreen(customer: customer, screen: .working)
                })
                
                WorkReport.startWork(customer: customer)
                
                delegate?.timerStatus = true
                Thread.sleep(forTimeInterval: employees.business.workTime)
                
                BankSemaphore.wait()
                workTime += employees.business.workTime
                customerCount += 1
                BankSemaphore.signal()
                
                delegate?.timerStatus = false
                WorkReport.endWork(customer: customer)
                
                DispatchQueue.main.sync(execute: {
                    delegate?.deleteScreen(customer: customer, screen: .working)
                })
            }
        })
    }
    
    private func endWork() {
        WorkReport.endWorkString(customerCount: customerCount, workTime: workTime)
        customerCount = 0
        workTime = 0
    }
    
    private func addCustomer() {
        let count = 10
        for number in customerNumber...customerNumber + count - 1 {
            let newCustomer = Customer(number: number)
            customerQueue.enqueue(value: newCustomer)
            delegate?.addScreen(customer: newCustomer, screen: .waiting)
        }
        customerNumber += count
    }
    
    public func reset() {
        customerCount = 0
        customerNumber = 1
        workTime = 0
        delegate?.timerStatus = false
        customerQueue.clear()
        depositQueue.clear()
        loanQueue.clear()
    }
}
