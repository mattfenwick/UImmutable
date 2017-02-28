//
//  RootViewController.swift
//  immutable
//
//  Created by Matt Fenwick on 2/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: UIViewController {

    @IBOutlet private weak var presentFlowControllerButton: UIButton!
    @IBOutlet private weak var presentVCButton: UIButton!

    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "RootViewController",
                   bundle: Bundle(for: RootViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presentFlowControllerButton.rx.tap
            .subscribe(onNext: {
                self.presentFlowController()
            })
            .addDisposableTo(disposeBag)

        presentVCButton.rx.tap
            .subscribe(onNext: {
                self.presentVC()
            })
            .addDisposableTo(disposeBag)
    }

    private func presentFlowController() {
        let temperatureComponent = TemperatureFlowController()
        present(temperatureComponent.componentViewController, animated: true, completion: nil)
    }

    private func presentVC() {
        let vc = WhateverDeinitViewController()
        let navC = UINavigationController(rootViewController: vc)
        present(navC, animated: true, completion: nil)
    }

}
