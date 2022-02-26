//
//  BookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    // MARK: - Properties

    let bookmarksManager = BookmarksManager.standard
    
    var userBookmarksViewController: UserBookmarksViewController!
    var repositoryBookmarksViewController: RepositoryBookmarksViewController!
    var organizationBookmarksViewController: OrganizationBookmarksViewController!

    // MARK: - View Outlets

    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userBookmarksContainerView: UIView!
    @IBOutlet weak var repositoryBookmarksContainerView: UIView!
    @IBOutlet weak var organizationBookmarksContainerView: UIView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - View Helper Methods

    func configureView() {
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
        userBookmarksContainerView.isHidden = false
        repositoryBookmarksContainerView.isHidden = true
        organizationBookmarksContainerView.isHidden = true
    }

    // MARK: - View Actions

    @IBAction func selectorChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: switchContext(to: .users)
        case 1: switchContext(to: .repositories)
        case 2: switchContext(to: .organizations)
        default: break
        }
    }

    @IBAction func clearBookmarks(_ sender: UIBarButtonItem) {
        AlertHelper.showAlert(alert: .clearBookmarks({ [weak self] in
            self?.clearCurrentContext()
        }))
    }

    // MARK: - Bookmarks Context Methods
    
    func switchContext(to context: BookmarksContext) {
        switch context {
        case .users: userBookmarksContainerView.isHidden = false
                     repositoryBookmarksContainerView.isHidden = true
                     organizationBookmarksContainerView.isHidden = true
                     clearButton.isEnabled = userBookmarksViewController.isEmpty.value! ? false : true
                     bookmarksManager.activeBookmarksContext = .users
        case .repositories: userBookmarksContainerView.isHidden = true
                            repositoryBookmarksContainerView.isHidden = false
                            organizationBookmarksContainerView.isHidden = true
                            clearButton.isEnabled = repositoryBookmarksViewController.isEmpty.value! ? false : true
                            bookmarksManager.activeBookmarksContext = .repositories
        case .organizations: userBookmarksContainerView.isHidden = true
                             repositoryBookmarksContainerView.isHidden = true
                             organizationBookmarksContainerView.isHidden = false
                             clearButton.isEnabled = organizationBookmarksViewController.isEmpty.value! ? false : true
                             bookmarksManager.activeBookmarksContext = .organizations
        default: break
        }
    }

    func clearCurrentContext() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: userBookmarksViewController.clear()
        case 1: repositoryBookmarksViewController.clear()
        case 2: organizationBookmarksViewController.clear()
        default: break
        }
    }
    
    // MARK: - Navigation Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let userBookmarksViewController as UserBookmarksViewController: self.userBookmarksViewController = userBookmarksViewController
        case let repositoryBookmarksViewController as RepositoryBookmarksViewController: self.repositoryBookmarksViewController = repositoryBookmarksViewController
        case let organizationBookmarksViewController as OrganizationBookmarksViewController: self.organizationBookmarksViewController = organizationBookmarksViewController
        default: break
        }
        if userBookmarksViewController != nil,
           repositoryBookmarksViewController != nil,
           organizationBookmarksViewController != nil {
            bindToViewControllers()
        }
    }
    
    // MARK: - Bind to View Controllers Method
    
    func bindToViewControllers() {
        userBookmarksViewController.isEmpty.bind { [weak self] isEmpty in
            if let isEmpty = isEmpty, self?.bookmarksManager.activeBookmarksContext == .users {
                self?.clearButton.isEnabled = isEmpty ? false : true
            }
        }
        repositoryBookmarksViewController.isEmpty.bind { [weak self] isEmpty in
            if let isEmpty = isEmpty, self?.bookmarksManager.activeBookmarksContext == .repositories {
                self?.clearButton.isEnabled = isEmpty ? false : true
            }
        }
        organizationBookmarksViewController.isEmpty.bind { [weak self] isEmpty in
            if let isEmpty = isEmpty, self?.bookmarksManager.activeBookmarksContext == .organizations {
                self?.clearButton.isEnabled = isEmpty ? false : true
            }
        }
    }

}
