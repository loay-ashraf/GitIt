//
//  UserViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 08/11/2021.
//

import UIKit
import Kingfisher
import SVProgressHUD

class UserViewController: SFDynamicTableViewController<UserViewModel>, StoryboardableViewController {

    // MARK: - Properties
    
    static var storyboardIdentifier = "UserVC"
    
    private var context: UserContext
    
    private var searchCoordinator: SearchCoordinator<UserSearchModule>!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: UserContext) {
        self.context = context
        super.init(coder: coder)
        tableViewDataSource = UserTableViewDataSource()
        tableViewDelegate = UserTableViewDelegate(self)
        viewModel = UserViewModel(context: context)
        emptyViewModel = EmptyConstants.Users.viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        if let userContext = context as? UserContext {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserViewController in
                        self.init(coder: coder, context: userContext)!
            })
        } else {
            return UIViewController()
        }
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()

        title = context.title
        switch context {
        case .main: navigationItem.largeTitleDisplayMode = .always
        default: navigationItem.largeTitleDisplayMode = .never
        }
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        switch context {
        case .main: searchCoordinator = SearchCoordinator(self)
        default: searchCoordinator = nil
        }
    }
    
    // MARK: - View Actions
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        let detailVC = UserDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
    }
    
    func saveImage(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        KingfisherManager.shared.retrieveImage(with: cellViewModelItem.avatarURL) { result in
            if let retreiveResult = try? result.get() {
                UIImageWriteToSavedPhotosAlbum(retreiveResult.image, self, nil, nil)
                SVProgressHUD.showSuccess(withStatus: "Image Saved".localized())
            }
        }
    }
    
    func openInSafari(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        URLHelper.openWebsite(cellViewModelItem.htmlURL)
    }
    
    func share(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        URLHelper.shareWebsite(cellViewModelItem.htmlURL)
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: viewModel?.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: viewModel?.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: viewModel?.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
}
