//
//  TemperatureConfigViewController.swift
//  immutable
//
//  Created by Matt Fenwick on 1/29/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TemperatureConfigViewController: UIViewController {

    // MARK: ui elements

    @IBOutlet private weak var fromContainerView: UIView!
    @IBOutlet private weak var toContainerView: UIView!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!

    @IBOutlet private weak var fromUnitTableView: UITableView!
    @IBOutlet private weak var toUnitTableView: UITableView!

    // MARK: output

    private let cancelTapSubject: PublishSubject<Void> = PublishSubject()
    lazy var cancelTap: Observable<Void> = { return self.cancelTapSubject.asObservable() }()

    private let doneTapSubject: PublishSubject<Void> = PublishSubject()
    lazy var doneTap: Observable<Void> = { return self.doneTapSubject.asObservable() }()

    // MARK: private variables

    private let disposeBag = DisposeBag()

    // MARK: init

    init() {
        super.init(nibName: "TemperatureConfigViewController",
                   bundle: Bundle(for: TemperatureConfigViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // bar buttons
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
        // boilerplate
        cancelBarButtonItem.rx.tap.subscribe(cancelTapSubject).addDisposableTo(disposeBag)
        doneBarButtonItem.rx.tap.subscribe(doneTapSubject).addDisposableTo(disposeBag)
    }

}
