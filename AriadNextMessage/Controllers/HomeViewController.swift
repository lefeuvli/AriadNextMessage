//
//  HomeViewController.swift
//  AriadNextMessage
//
//  Created by Lea Lefeuvre on 10/04/2022.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    private weak var coordinator: AppCoordinator?
    
    private var viewModel: HomeViewModel?
    private var disposeBag = DisposeBag()
    
    private var messages = [Message]()

    // MARK: - Init

    public static func create(viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController.instantiate(from: .main)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 65
        tableView.allowsSelection = false
        
        sendButton.layer.cornerRadius = 6
        messageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(_:)), name: UIViewController.keyboardWillHideNotification, object: nil)
        
        setupObserver()
    }
    
    private func setupObserver() {
        if let vModel = viewModel {
            _ = vModel.behaviourMessage?.subscribe(
                onNext: { message in
                    if let index = self.messages.firstIndex(where: { $0 == message }) {
                        self.messages[index] = message
                    } else {
                        self.messages.append(message)
                    }
                    
                    self.tableView.reloadData()
                },
                onError: nil,
                onCompleted: nil,
                onDisposed: nil)
            .disposed(by: disposeBag)
        }
    }
    
    @objc func keyboardAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomViewConstraint.constant = keyboardSize.height + 16
        }
    }
    
    @objc func keyboardDisappear(_ notification: Notification) {
        bottomViewConstraint.constant = 16
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        messageTextField.resignFirstResponder()
    }
    
    @IBAction func tapOnSendMessage() {
        // Check message is not empty before send it
        if let message = messageTextField.text, !message.isEmpty {
            viewModel?.didTapOnSendMessage(text: message)
            messageTextField.text = ""
        }
    }
}

// MARK: - Extensions UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.name) as? MessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }
}

// MARK: - Extensions UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
