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
import RxDataSources

extension TemperatureUnit: IdentifiableType {
    typealias Identity = TemperatureUnit
    var identity: TemperatureUnit {
        return self
    }
}

private let fromReuseIdentifier = "fromTableViewCell"
private let toReuseIdentifier = "toTableViewCell"

class TemperatureConfigViewController: UIViewController {

    // MARK: ui elements

    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!

    @IBOutlet private weak var fromUnitTableView: UITableView!
    @IBOutlet private weak var toUnitTableView: UITableView!

    @IBOutlet private weak var debugLabel: UILabel!

    // MARK: output

    private let doneTapSubject = PublishSubject<Void>()
    private let fromUnitSubject = PublishSubject<TemperatureUnit>()
    private let toUnitSubject = PublishSubject<TemperatureUnit>()

    lazy private (set) var doneTap: Observable<Void> = {
        return self.doneTapSubject.asObservable()
    }()

    lazy private (set) var fromUnit: Observable<TemperatureUnit> = {
        return self.fromUnitSubject.asObservable()
    }()

    lazy private (set) var toUnit: Observable<TemperatureUnit> = {
        return self.toUnitSubject.asObservable()
    }()

    // MARK: private variables

    private let fromSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TemperatureUnit>>()
    private let toSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TemperatureUnit>>()
    private let sections: [AnimatableSectionModel<String, TemperatureUnit>]
    private let disposeBag = DisposeBag()
    private let initialFromUnit: TemperatureUnit
    private let initialToUnit: TemperatureUnit
    private let debugText: Driver<String>

    // MARK: init

    init(initialFromUnit: TemperatureUnit,
         initialToUnit: TemperatureUnit,
         units: [TemperatureUnit],
         debugText: Driver<String>) {
        self.initialFromUnit = initialFromUnit
        self.initialToUnit = initialToUnit
        self.sections = [AnimatableSectionModel(model: "", items: units)]
        self.debugText = debugText
        super.init(nibName: "TemperatureConfigViewController",
                   bundle: Bundle(for: TemperatureConfigViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: deinit

    deinit {
        print("deinit TemperatureConfigViewController")
    }

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose units"

        // bar buttons
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = doneBarButtonItem

        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        navigationItem.leftBarButtonItem = cancelBarButtonItem

        cancelBarButtonItem.rx.tap
            .subscribe(onNext: { print("left button tap") })
            .addDisposableTo(disposeBag)

        // from tableview setup
        fromUnitTableView.register(UITableViewCell.self, forCellReuseIdentifier: fromReuseIdentifier)
        fromSource.configureCell = configureFromCell
        Driver.just(sections)
            .drive(fromUnitTableView.rx.items(dataSource: fromSource))
            .addDisposableTo(disposeBag)

        // to tableview setup
        toUnitTableView.register(UITableViewCell.self, forCellReuseIdentifier: toReuseIdentifier)
        toSource.configureCell = configureToCell
        Driver.just(sections)
            .drive(toUnitTableView.rx.items(dataSource: toSource))
            .addDisposableTo(disposeBag)

        // debug text
        debugText
            .drive(debugLabel.rx.text)
            .addDisposableTo(disposeBag)

        // output boilerplate
        doneBarButtonItem.rx.tap
            .subscribe(doneTapSubject)
            .addDisposableTo(disposeBag)

        fromUnitTableView.rx.modelSelected(TemperatureUnit.self)
            .subscribe(fromUnitSubject)
            .addDisposableTo(disposeBag)

        toUnitTableView.rx.modelSelected(TemperatureUnit.self)
            .subscribe(toUnitSubject)
            .addDisposableTo(disposeBag)
    }

    private func configureFromCell(ds: TableViewSectionedDataSource<AnimatableSectionModel<String, TemperatureUnit>>,
                                   tv: UITableView,
                                   ip: IndexPath,
                                   item: TemperatureUnit) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: fromReuseIdentifier, for: ip)
        cell.textLabel?.text = "\(item)"
        cell.selectionStyle = .blue
        if item == initialFromUnit {
            tv.selectRow(at: ip, animated: false, scrollPosition: .none)
        }
        return cell
    }

    private func configureToCell(ds: TableViewSectionedDataSource<AnimatableSectionModel<String, TemperatureUnit>>,
                                 tv: UITableView,
                                 ip: IndexPath,
                                 item: TemperatureUnit) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: toReuseIdentifier, for: ip)
        cell.textLabel?.text = "\(item)"
        cell.selectionStyle = .blue
        if item == initialToUnit {
            tv.selectRow(at: ip, animated: false, scrollPosition: .none)
        }
        return cell
    }

}
