//
//  ButtonPanelView.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/24.
//

import UIKit

protocol ButtonPanelDelegate: class {
    func didTapButtonWithText(_ text: String)
}

class ButtonPanelView: UIView {
    private let buttonSize: CGFloat = 50
    weak var delegate: ButtonPanelDelegate?
    
    @objc func FirstButtonClick(_ sender: Any){
        First()
    }
    @objc func SecondButtonClick(_ sender: Any) {
        Second()
    }
    
    var First : (() -> ()) = {}
    var Second : (() -> ()) = {}
    
    lazy var menuButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("⭕️", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = buttonSize / 2
        button.addTarget(
            self, action: #selector(tappedPanelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var firstButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("1️⃣", for: .normal)
        button.layer.cornerRadius = buttonSize / 2
        button.isHidden = true
        button.addTarget(
            self, action: #selector(FirstButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("2️⃣", for: .normal)
        button.layer.cornerRadius = buttonSize / 2
        button.isHidden = true
        button.addTarget(
            self, action: #selector(SecondButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isHidden = true
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        return stackView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(expandedStackView)
        stackView.addArrangedSubview(menuButton)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = buttonSize / 2
        addSubview(containerStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor).isActive = true
    }
}

extension ButtonPanelView {
  @objc private func tappedPanelButton(_ sender: UIButton) {
    let willExpand = expandedStackView.isHidden
    let menuButtonNewTitle = willExpand ? "❌" : "➕"
    UIView.animate(
      withDuration: 0.3, delay: 0, options: .curveEaseIn,
      animations: {
        self.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
        self.expandedStackView.isHidden = !self.expandedStackView.isHidden
        if willExpand {
          self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
        }
    }, completion: { _ in
      // When collapsing, wait for animation to finish before changing from "x" to "+"
      if !willExpand {
        self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
      }
    })
  }
}
