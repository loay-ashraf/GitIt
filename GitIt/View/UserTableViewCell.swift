//
//  UserTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/10/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"
    static var nib: UINib { return UINib(nibName: "UserTableViewCell", bundle: nil) }
    
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var userImageView: AsynchronousUIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.cornerRadius = 32.0
        userImageView.cornerCurve = .continuous
        userImageView.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLoginLabel.text = nil
        userImageView.image = nil
        userImageView.cancel()
    }
    
    func configure(user: UserModel) {
        userLoginLabel.text = user.login
        userImageView.load(at: user.avatarURL)
        setNeedsLayout()
    }

}

class ImageLoader {
    
    static let standard = ImageLoader()
    
    private var cache: NSCache<NSURL, UIImage>!
    private var runningRequests: [UUID: URLSessionDataTask]
    
    private init() {
        cache = NSCache()
        cache.countLimit = 70
        runningRequests = [UUID: URLSessionDataTask]()
    }
    
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = cache.object(forKey: url as NSURL) {
            completion(.success(image))
            return nil
        }
        
        let taskUUID = UUID()
        
        let task = GitClient.standard.downloadUserAvatar(url: url) { data, error in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)
                completion(.success(image))
                return
            }
            guard let error = error else {
                return
            }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        
        runningRequests[taskUUID] = task
        
        return taskUUID
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
}

class AsynchronousUIImageView: UIImageView {
    
    var loadingSpinner: UIActivityIndicatorView!
    var runningRequestUUID: UUID!
    
    required init?(coder: NSCoder) {
        loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.isUserInteractionEnabled = false
        super.init(coder: coder)
        loadingSpinner!.frame = bounds
        addSubview(loadingSpinner!)
    }
    
    func load(at url: URL) {
        if runningRequestUUID != nil { cancel() }
        loadingSpinner.startAnimating()
        runningRequestUUID = ImageLoader.standard.loadImage(url) { [weak self] result in
            do {
                let image = try result.get()
                self?.image = image
                self?.loadingSpinner.stopAnimating()
            } catch {
                fatalError("Failed to load image \(self?.description)")
            }
        }
    }
    
    func cancel() {
        if runningRequestUUID != nil {
            ImageLoader.standard.cancelLoad(runningRequestUUID)
            runningRequestUUID = nil
            loadingSpinner.stopAnimating()
        }
    }
    
}

extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var cornerCurve: CALayerCornerCurve {
        get { return layer.cornerCurve }
        set { layer.cornerCurve = newValue }
    }
    
    var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
}
