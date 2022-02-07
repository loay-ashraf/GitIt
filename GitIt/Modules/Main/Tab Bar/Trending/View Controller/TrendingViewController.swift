//
//  TrendingViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 26/01/2022.
//

import UIKit

class TrendingViewController: RepositoryViewController {

    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: RepositoryContext) {
        fatalError("init(coder:context:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, context: .trending)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
    }

}
