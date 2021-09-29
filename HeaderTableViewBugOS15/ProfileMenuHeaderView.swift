//
//  ProfileMenuHeaderView.swift
//  OneApp
//
//  Created by QU32WG on 29/10/2020.
//  Copyright © 2020 ING Group NV. All rights reserved.
//

import UIKit

final class ProfileMenuHeaderView: UIStackView {
    
    /// To select card
    var didTapSwitchProfile: (() -> Void)?
    // MARK: - Internal
    
    enum Layout {
        static let stackViewInsets = UIEdgeInsets(top: 15, left: 15, bottom: -15, right: -15)
        static let profileIconSquareSize = CGFloat(100.0)
        static let editAvatarButtonSquareSize = CGFloat(36.0)
        static let titleLabelMinimumHeight = CGFloat(24.0)
    }
    
    enum Style {
        static let shadowColor = UIColor.lightGray
        static let shadowOpacity: Float = 1
        static let shadowSpace: CGFloat = 4
        static let shadowRadius: CGFloat = 2
        static let shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Outlets
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mr XXX"
        label.textColor = .blue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var profileTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Private"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var profileIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var editAvatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .darkGray
        button.tintColor = .lightText
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var switchProfileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Switch"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let contentStackview: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 10.0
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 2.0, y: 0.525)
        gradient.locations = [0.0, 0.5, 1]
        return gradient
    }()
    
    let shimmerAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.0
        animation.repeatCount = .greatestFiniteMagnitude
        return animation
    }()
    
    // MARK: - Object Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .fill
        spacing = 15.0
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let containerView = UIView()
        containerView.backgroundColor = .yellow
        containerView.addSubview(profileIcon)
        containerView.addSubview(editAvatarButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, profileTypeLabel, switchProfileButton].forEach { contentStackview.addArrangedSubview($0) }
        contentStackview.backgroundColor = .green
        [containerView, contentStackview].forEach { addArrangedSubview($0) }

        NSLayoutConstraint.activate([
 
            containerView.widthAnchor.constraint(equalToConstant: Layout.profileIconSquareSize),
            containerView.heightAnchor.constraint(equalToConstant: Layout.profileIconSquareSize),
                        
            profileIcon.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            profileIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            editAvatarButton.bottomAnchor.constraint(equalTo: profileIcon.bottomAnchor),
            editAvatarButton.trailingAnchor.constraint(equalTo: profileIcon.trailingAnchor),
            editAvatarButton.heightAnchor.constraint(equalToConstant: Layout.editAvatarButtonSquareSize),
            editAvatarButton.widthAnchor.constraint(equalToConstant: Layout.editAvatarButtonSquareSize)
        ])
        contentStackview.setCustomSpacing(10, after: profileTypeLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow(on: self)
        addShadow(on: editAvatarButton)
        editAvatarButton.layer.cornerRadius = editAvatarButton.frame.size.height / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateShadowColor(on: self)
            updateShadowColor(on: editAvatarButton)
            updateGradientColors(gradient)
        }
    }
    
    // MARK: - Internal functions
    
    func addShadow(on view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = Style.shadowColor.cgColor
        view.layer.shadowOpacity = Style.shadowOpacity
        view.layer.shadowRadius = Style.shadowRadius
        view.layer.shadowOffset = Style.shadowOffset
    }
    
    func updateShadowColor(on view: UIView) {
        view.layer.shadowColor = Style.shadowColor.cgColor
    }
    
    func updateGradientColors(_ gradient: CAGradientLayer) {
        let darkColor = UIColor.darkGray.cgColor
        let lightColor = UIColor.lightGray.cgColor
        gradient.colors = [darkColor, lightColor, darkColor]
    }
    
    func startShimmering() {
        DispatchQueue.main.async {
            self.updateGradientColors(self.gradient)
            self.gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3*self.bounds.size.width, height: self.bounds.size.height)
            self.layer.mask = self.gradient
            self.gradient.add(self.shimmerAnimation, forKey: "shimmer")
        }
    }
    
    func stopShimmering() {
        DispatchQueue.main.async {
            self.layer.mask = nil
        }
    }
    
    @objc private func switchProfileButtonTapped() {
        didTapSwitchProfile?()
    }
}
