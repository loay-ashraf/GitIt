//
//  UserBookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit
import Kingfisher
import SVProgressHUD

class UserBookmarksViewController: DPSFDynamicTableViewController<UserBookmarksViewModel> {
    
    // MARK: - Properties
    
    var isEmpty = Observable<Bool>()
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableViewDataSource = UserTableViewDataSource()
        tableViewDelegate = UserBookmarksDelegate(self)
        viewModel = UserBookmarksViewModel()
        emptyViewModel = EmptyConstants.Bookmarks.viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    // MARK: - View Actions
    
    func clear() {
        viewModel.clear()
    }
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        let detailVC = UserDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
    }
    
    func saveImage(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        KingfisherManager.shared.retrieveImage(with: cellViewModelItem.avatarURL) { result in
            if let retreiveResult = try? result.get() {
                UIImageWriteToSavedPhotosAlbum(retreiveResult.image, self, nil, nil)
                SVProgressHUD.showSuccess(withStatus: "Image Saved".localized())
            }
        }
    }
    
    func openInSafari(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        URLHelper.openWebsite(cellViewModelItem.htmlURL)
    }
    
    func share(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        URLHelper.shareWebsite(cellViewModelItem.htmlURL)
    }
    
    // MARK: - Bind to View Model Method
    
    func bindToViewModel() {
        viewModel.bind { [weak self] userBookmarks in
            if let userBookmarks = userBookmarks {
                self?.tableViewDataSource.cellViewModels = userBookmarks
                DispatchQueue.main.async {
                    if userBookmarks.isEmpty {
                        self?.xTableView.transition(to: .empty(self!.emptyViewModel))
                    } else {
                        self?.xTableView.transition(to: .presenting)
                    }
                }
                self?.isEmpty.value = self?.viewModel.isEmpty
            }
        }
    }
    
}
