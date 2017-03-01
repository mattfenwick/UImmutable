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

    private var temperatureFlowController: TemperatureFlowController?
    
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
        let temperatureFlowController = TemperatureFlowController()
        present(temperatureFlowController.componentViewController, animated: true, completion: nil)

        temperatureFlowController.didTapDone
            .subscribe(onNext: { [unowned self] in self.dismissFlowController() })
            .addDisposableTo(disposeBag)

        self.temperatureFlowController = temperatureFlowController
    }

    private func dismissFlowController() {
        dismiss(animated: true, completion: nil)
        temperatureFlowController = nil
    }

    private func presentVC() {
        let vc = WhateverDeinitViewController()
        let navC = UINavigationController(rootViewController: vc)
        present(navC, animated: true, completion: nil)
    }

}
