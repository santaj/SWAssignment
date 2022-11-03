//
//  LoadingViewController.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-11-02.
//

import UIKit

class LoadingView: UIView {
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        return blurEffectView
    }()
    
    public func setupSpinner() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurEffectView.frame = self.bounds
        self.insertSubview(blurEffectView, at: 0)
        loadingActivityIndicator.center = CGPoint(
            x: self.bounds.midX,
            y: self.bounds.midY
        )
        self.addSubview(loadingActivityIndicator)
    }
}
