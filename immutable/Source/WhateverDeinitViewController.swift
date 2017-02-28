//
//  WhateverDeinitViewController.swift
//  immutable
//
//  Created by Matt Fenwick on 2/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift

class WhateverDeinitViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

    deinit {
        print("deinit WhateverDeinitViewController")
    }

}
