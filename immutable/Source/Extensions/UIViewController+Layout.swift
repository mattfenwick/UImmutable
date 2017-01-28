//
//  UIViewController+Layout.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func launchIn(containerViewController: UIViewController, animated: Bool = true) {
        containerViewController.addChildViewController(self)
        containerViewController.view.addAndFillWithSubview(subview: view)
        didMove(toParentViewController: containerViewController)

        if animated {
            view.animateFadeIn()
        }
    }

}
