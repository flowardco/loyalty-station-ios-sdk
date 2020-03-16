//
//  ImageView+UrlImage.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/18/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import UIKit

extension UIButton {
    func setImage(link: String, state: UIControl.State, completion: @escaping () -> Void) {
        self.showLoadingView()
        guard let url = URL(string: link) else { return }
        self.downloaded(from: url, state: state, completion: completion)
    }
    
    func downloaded(from url: URL, state: UIControl.State, completion: @escaping () -> Void) {
        let requet = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: requet) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    self.hideLoadingView()
                    return
            }
            
            DispatchQueue.main.async() {
                self.hideLoadingView()
                self.setImage(image, for: state)
                self.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                completion()
            }
        }
        
        task.resume()
    }
    
    func showLoadingView() {
        let activityInficator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityInficator.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        activityInficator.startAnimating()
        activityInficator.tag = 4589
        activityInficator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityInficator)
        self.bringSubviewToFront(activityInficator)
        
        activityInficator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        activityInficator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        activityInficator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        activityInficator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func hideLoadingView() {
        self.viewWithTag(4589)?.removeFromSuperview()
    }
}



extension UIImageView {
    func setImage(link: String, state: UIControl.State, completion: @escaping () -> Void) {
        self.showLoadingView()
        guard let url = URL(string: link) else { return }
        self.downloaded(from: url, state: state, completion: completion)
    }
    
    func downloaded(from url: URL, state: UIControl.State, completion: @escaping () -> Void) {
        let requet = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: requet) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    
                    DispatchQueue.main.async {
                        self.hideLoadingView()
                    }
                    
                    return
            }
            
            DispatchQueue.main.async() {
                self.hideLoadingView()
                self.image = image
                self.contentMode = UIView.ContentMode.scaleAspectFill
                completion()
            }
        }
        
        task.resume()
    }
    
    func showLoadingView() {
        let activityInficator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityInficator.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        activityInficator.startAnimating()
        activityInficator.tag = 4589
        activityInficator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityInficator)
        self.bringSubviewToFront(activityInficator)
        
        activityInficator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        activityInficator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        activityInficator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        activityInficator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func hideLoadingView() {
        self.viewWithTag(4589)?.removeFromSuperview()
    }
}
