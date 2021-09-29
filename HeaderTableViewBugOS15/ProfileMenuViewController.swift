//
//  ProfileMenuViewController.swift
//  BEOneApp
//
//  Created by Alok Sinha on 11/09/2018.
//  Copyright © 2018 ING Group NV. All rights reserved.
//

import UIKit

final class ProfileMenuViewController: UITableViewController {
    
    // MARK: - Internal
    
    enum Layout {
        static let tableFooterHeight: CGFloat = 30.0
        static let popOverWidth: CGFloat = 375.0
        static let verticalPadding: CGFloat = 15.0
    }

    // MARK: - Internal Properties
    
    let trackingPageName: String = "Profile"
    
    private var contentSizeObserver: NSKeyValueObservation?
    
    // MARK: - Private Properties
    
    private let headerView: ProfileMenuHeaderView = {
        let view = ProfileMenuHeaderView()
        view.backgroundColor =  .white
        view.editAvatarButton.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Object Lifecycle
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    deinit {
        contentSizeObserver?.invalidate()
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.bounces = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SettingMenuCell", bundle: nil), forCellReuseIdentifier: "SettingMenuCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Layout.tableFooterHeight))
        tableView.tableHeaderView = headerView
        
        contentSizeObserver = tableView.observe(\.contentSize) { [weak self] tableView, _ in
            self?.popoverPresentationController?.presentedViewController.preferredContentSize = CGSize(width: Layout.popOverWidth, height: tableView.contentSize.height + Layout.verticalPadding)
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 300)))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
        
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView() // Add empty space between sections
    }
    
    /// We need a zero sized section footer to have proper spacing
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    // MARK: - SettingMenuCellDelegate
    
    // MARK: - Internal Functions
    
    func refreshProfileName(_ name: String) {
        refreshHeaderView()
    }
    
    func refreshUserAvatar(_ avatar: UIImage) {
        refreshHeaderView()
    }
    
    func refreshInboxCounter(_ counter: String?) {
        tableView.reloadData()
    }
    
    @objc
    private func editAvatarButtonTapped(sender: UIButton) {
    }
    
    private func refreshHeaderView() {
        headerView.titleLabel.text = "Mr XXX"
        headerView.profileTypeLabel.text = "Private"
        let profileImage = UIImage(systemName: "person")
        if profileImage == nil { print("profileImage == nil") }
        headerView.profileIcon.image = profileImage
        headerView.switchProfileButton.isHidden =  false
        headerView.editAvatarButton.isHidden =  false
        
//        let size = headerView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude),
//                                                      withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//        headerView.frame.size.height = size.height
//        tableView.tableHeaderView = headerView //we need to assign the header view again to make it render properly bacause the table view doesn't use AutoLayout
//        tableView.setAndLayoutTableHeaderView(header: headerView)
        tableView.setTableHeaderView(headerView: headerView)
    }
}

private extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        print("height = \(height)")
        header.frame.size.height = height
        self.tableHeaderView = header
    }
}

private extension UITableView {
    // 1.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        self.tableHeaderView = headerView

        // ** Must setup AutoLayout after set tableHeaderView.
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    // 2.
    func shouldUpdateHeaderViewFrame() -> Bool {
        guard let headerView = self.tableHeaderView else { return false }
        let oldSize = headerView.bounds.size
        // Update the size
        headerView.layoutIfNeeded()
        let newSize = headerView.bounds.size
        return oldSize != newSize
    }
}
