//
//  ViewController.swift
//  pushnotification
//
//  Created by user on 20.12.2021.
//

import UIKit

class ViewController: UIViewController {
    var pushText: String = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .blue
        $0.font = .init(.systemFont(ofSize: 22, weight: .semibold))
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.text = "Пушей не видно еще"
        return $0
    }(UILabel())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.width / 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
