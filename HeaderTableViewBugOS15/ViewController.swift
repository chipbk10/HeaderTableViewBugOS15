//
//  ViewController.swift
//  HeaderTableViewBugOS15
//
//  Created by Hieu Luong on 29/09/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .magenta
        
        let button = UIButton(type:.system)
        button.setTitle("Tap Me", for: .normal)
        button.backgroundColor = .systemOrange
        
        button.addTarget(self, action: #selector(tapMe), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100)
        ])
        
        view.layoutIfNeeded()
    }
    
    var counts: Int = 0

    @objc func tapMe() {
        let vc = ProfileMenuViewController()
        dismiss(animated: true, completion: nil)
        present(vc, animated: true, completion: nil)
    }

}

