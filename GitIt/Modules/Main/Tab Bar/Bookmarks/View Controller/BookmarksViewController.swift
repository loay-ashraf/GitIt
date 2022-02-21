//
//  BookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    // MARK: - Properties

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch segmentedControl.selectedSegmentIndex {
        case 0: userBookmarksViewController.synchronize()
        case 1: repositoryBookmarksViewController.synchronize()
        case 2: organizationBookmarksViewController.synchronize()
        default: break
        }
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
                     userBookmarksViewController.synchronize()
                     BookmarksManager.standard.activeBookmarksContext = .users
        case .repositories: userBookmarksContainerView.isHidden = true
                            repositoryBookmarksContainerView.isHidden = false
                            organizationBookmarksContainerView.isHidden = true
                            repositoryBookmarksViewController.synchronize()
                            BookmarksManager.standard.activeBookmarksContext = .repositories
        case .organizations: userBookmarksContainerView.isHidden = true
                             repositoryBookmarksContainerView.isHidden = true
                             organizationBookmarksContainerView.isHidden = false
                             organizationBookmarksViewController.synchronize()
                             BookmarksManager.standard.activeBookmarksContext = .organizations
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
        if userBookmarksViewController != nil, repositoryBookmarksViewController != nil, organizationBookmarksViewController != nil {
            userBookmarksViewController.bookmarksViewController = self
            repositoryBookmarksViewController.bookmarksViewController = self
            organizationBookmarksViewController.bookmarksViewController = self
        }
    }

}
