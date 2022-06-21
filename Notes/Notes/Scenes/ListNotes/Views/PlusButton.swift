//
//  plusButton.swift
//  Notes
//
//  Created by Nikita Yakovlev on 10.04.2022.
//

import UIKit

class PlusButton: UIButton {
    var stateButton: ItemState = .main {
        didSet {
            changeImageAnimated()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("class PlusButton has been initialized")
        setupSetting()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSetting()
    }

    deinit {
        print("class PlusButton has been deallocated")
    }

    private func setupSetting() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.setImage(UIImage(named: "AddButton"), for: .normal)

        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = .systemFont(ofSize: 36.0)
        self.titleLabel?.textAlignment = .center

        self.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        self.contentVerticalAlignment = .bottom
    }
// на анимации нет ссылок, поэтому в замыкании "animations"
// следовательно нет риска возникновения цикла сильных ссылок,
// тогда нет необходимости использовать [weak self]
    private func changeImageAnimated() {
        let nameImage: String = stateButton == .main ? "AddButton" : "RemoveButton"

        UIView.transition(
            with: self,
            duration: 0.3,
            options: .transitionFlipFromLeft,
            animations: {
                self.setImage(UIImage(named: nameImage), for: .normal)
            },
            completion: nil
        )
    }

    func showButtonAnimated() {
        let initialButtonY = self.frame.minY
        self.frame.origin.y = UIScreen.main.bounds.maxY
        self.isHidden = false

        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                self.frame.origin.y = initialButtonY
            },
            completion: nil
        )
    }

    func hideButtonAnimated(completion: (() -> Void)?) {
        let initialButtonY = self.frame.minY

        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.6,
                    animations: {
                        self.frame.origin.y = initialButtonY - 20
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.6,
                    relativeDuration: 0.4,
                    animations: {
                        self.frame.origin.y = UIScreen.main.bounds.maxY
                    }
                )
            },
            completion: { _ in
                self.isHidden = true
                self.frame.origin.y = initialButtonY
                completion?()
            }
        )
    }
}
