//
//  GamiphyBotButton.swift
//  GamiphyCode
//
//  Created by Mohammad Nabulsi on 5/18/19.
//  Copyright © 2019 Mohammad Nabulsi. All rights reserved.
//

import UIKit

/// Gamiphy Bot Button
public class GamiphyBotButton: UIImageView {
    
    let buttonHeightWidth: CGFloat = 50.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add notifications
        self.addNotifications()
        
        // Add width constraints
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: self.buttonHeightWidth).isActive = true
        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        // Add target
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
    /**
     Awake from nib
     */
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set image
        self.loadImage()
    }
    
    private func loadImage() {
    
        // Set image
        let confuguration = GamiphySDK.shared.configuration
        self.setImage(link: confuguration?.style.launcher.icon ?? "", state: UIControl.State.normal) {
            self.setupView()
        }
    }
    
    /**
     Setup view
     */
    private func setupView() {
        let confuguration = GamiphySDK.shared.configuration
        
        // Set background color
        if let brandColor = confuguration?.style.brandColor {
            self.backgroundColor = UIColor(hex: brandColor)
        } else {
            self.backgroundColor = UIColor.white
        }
        
        if confuguration?.style.launcher.shape == BotLauncherShape.rectangle || confuguration?.style.launcher.shape == BotLauncherShape.rounded {
            self.layer.cornerRadius = 5.0
        } else if confuguration?.style.launcher.shape == BotLauncherShape.oval {
            self.layer.cornerRadius = self.buttonHeightWidth / 2
        }
        
        self.clipsToBounds = true
    }
    
    /**
     Layout subviews
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setup view
        self.setupView()
    }
    
    /**
     Did click button
     */
    @objc private func didTapView() {
        if let viewController = UIApplication.shared.delegate?.window??.rootViewController {
            GamiphySDK.shared.open(on: viewController)
        }
    }
}

extension GamiphyBotButton {
    
    /**
     Add notifications
     */
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: GamiphySDK.Notifications.didUpdateBotConfiguration, object: nil)
    }
    
    /**
     Handle notification
     */
    @objc private func handleNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.setupView()
            
            // Set image
            self.loadImage()
        }
    }
}
