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

    @IBOutlet private weak var fromContainerView: UIView!
    @IBOutlet private weak var toContainerView: UIView!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!

    @IBOutlet private weak var fromUnitTableView: UITableView!
    @IBOutlet private weak var toUnitTableView: UITableView!

    // MARK: output

    private let cancelTapSubject: PublishSubject<Void> = PublishSubject()
    lazy var cancelTap: Observable<Void> = { return self.cancelTapSubject.asObservable() }()

    private let doneTapSubject: PublishSubject<(TemperatureUnit, TemperatureUnit)> = PublishSubject()
    lazy var doneTap: Observable<(TemperatureUnit, TemperatureUnit)> = { return self.doneTapSubject.asObservable() }()

    // MARK: private variables

    private let fromSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TemperatureUnit>>()
    private let toSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TemperatureUnit>>()
    private let sections: [AnimatableSectionModel<String, TemperatureUnit>]
    private let disposeBag = DisposeBag()
    private let initialFromUnit: TemperatureUnit
    private let initialToUnit: TemperatureUnit

    // MARK: init

    init(initialFromUnit: TemperatureUnit, initialToUnit: TemperatureUnit, units: [TemperatureUnit]) {
        self.initialFromUnit = initialFromUnit
        self.initialToUnit = initialToUnit
        self.sections = [AnimatableSectionModel(model: "", items: units)]
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

        // from tableview setup
        fromUnitTableView.register(UITableViewCell.self, forCellReuseIdentifier: fromReuseIdentifier)
        let fromSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, TemperatureUnit>>()
        fromSource.configureCell = TemperatureConfigViewController.configureCell(reuseIdentifier: fromReuseIdentifier)
        Observable.just(sections)
            .bindTo(fromUnitTableView.rx.items(dataSource: fromSource))
            .addDisposableTo(disposeBag)

        // to tableview setup
        toUnitTableView.register(UITableViewCell.self, forCellReuseIdentifier: toReuseIdentifier)
        toSource.configureCell = TemperatureConfigViewController.configureCell(reuseIdentifier: toReuseIdentifier)
        Observable.just(sections)
            .bindTo(toUnitTableView.rx.items(dataSource: toSource))
            .addDisposableTo(disposeBag)

        // output boilerplate
        cancelBarButtonItem.rx.tap.subscribe(cancelTapSubject).addDisposableTo(disposeBag)
        let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)> = Observable.combineLatest(
            fromUnitTableView.rx.modelSelected(TemperatureUnit.self).startWith(initialFromUnit),
            toUnitTableView.rx.modelSelected(TemperatureUnit.self).startWith(initialToUnit),
            resultSelector: { (from, to) in (from, to) })
        doneBarButtonItem.rx.tap.withLatestFrom(unitSelection).subscribe(doneTapSubject).addDisposableTo(disposeBag)
    }

    static func configureCell(reuseIdentifier: String) ->
        (TableViewSectionedDataSource<AnimatableSectionModel<String, TemperatureUnit>>, UITableView, IndexPath, TemperatureUnit) -> UITableViewCell {
        return { (ds, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: reuseIdentifier, for: ip)
            return cell
        }
    }

}
