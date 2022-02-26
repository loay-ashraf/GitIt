//
//  DPSFViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFViewController: UIViewController {

    // MARK: - Properties
    
    var xView: DPSFView! { return view as? DPSFView }
    
    var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            view = DPSFView(frame: window!.bounds)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        xView.transition(to: .presenting)
    }

}
