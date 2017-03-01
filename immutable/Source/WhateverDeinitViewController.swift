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

    @IBOutlet private weak var myTextField: UITextField!

    private let textSubject = PublishSubject<String>()

    lazy private (set) var text: Observable<String> = {
        return self.textSubject.asObservable()
    }()

    init() {
        super.init(nibName: "WhateverDeinitViewController",
                   bundle: Bundle(for: WhateverDeinitViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)

        // boilerplate
        myTextField.rx.text.orEmpty
            .subscribe(textSubject)
            .addDisposableTo(disposeBag)
    }

    deinit {
        print("deinit WhateverDeinitViewController")
    }

}
