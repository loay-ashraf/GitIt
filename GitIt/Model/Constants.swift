//
//  Constants.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

var subViewsOffsetSize: SubviewsOffsetSize!

struct Constants {
    
    struct Model {
       
        static func modelToCellType<Type: GitIt.Model>(type: Type.Type) -> IBTableViewCell.Type? {
            switch type {
            case is UserModel.Type: return UserTableViewCell.self
            case is RepositoryModel.Type: return RepositoryTableViewCell.self
            case is OrganizationModel.Type: return OrganizationTableViewCell.self
            case is CommitModel.Type: return CommitTableViewCell.self
            default: return nil
            }
        }
        
        static func modelToDetailViewControllerType<Type: GitIt.Model>(type: Type.Type) -> IBViewController.Type? {
            switch type {
            case is UserModel.Type: return UserDetailViewController.self
            case is RepositoryModel.Type: return RepositoryDetailViewController.self
            case is OrganizationModel.Type: return OrganizationDetailViewController.self
            case is CommitModel.Type: return CommitDetailViewController.self
            default: return nil
            }
        }
        
        static func modelToContextMenuConfiguration<Type>(type: Type.Type, for model: Type) -> UIContextMenuConfiguration? {
            switch type {
            case is UserModel.Type: return modelContextMenuConfiguration(for: model as! UserModel)
            case is RepositoryModel.Type: return modelContextMenuConfiguration(for: model as! RepositoryModel)
            case is OrganizationModel.Type: return modelContextMenuConfiguration(for: model as! OrganizationModel)
            case is CommitModel.Type: return modelContextMenuConfiguration(for: model as! CommitModel)
            default: return nil
            }
        }
        
        static func modelContextMenuConfiguration(for model: UserModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = CoreDataManager.standard.exists(model)
                switch fetchResult {
                case .success(let exists): bookmark = exists ? ContextMenuActions.unbookmark(model).action : ContextMenuActions.bookmark(model).action
                case .failure(_): bookmark = ContextMenuActions.bookmark(model).action
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: RepositoryModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = CoreDataManager.standard.exists(model)
                switch fetchResult {
                case .success(let exists): bookmark = exists ? ContextMenuActions.unbookmark(model).action : ContextMenuActions.bookmark(model).action
                case .failure(_): bookmark = ContextMenuActions.bookmark(model).action
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: OrganizationModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = CoreDataManager.standard.exists(model)
                switch fetchResult {
                case .success(let exists): bookmark = exists ? ContextMenuActions.unbookmark(model).action : ContextMenuActions.bookmark(model).action
                case .failure(_): bookmark = ContextMenuActions.bookmark(model).action
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: CommitModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var share: UIAction! = nil
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
    }
    
}
