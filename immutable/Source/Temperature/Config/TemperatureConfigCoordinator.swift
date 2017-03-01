//
//  TemperatureConfigCoordinator.swift
//  immutable
//
//  Created by Matt Fenwick on 1/29/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

class TemperatureConfigCoordinator {

    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>

    let viewController: TemperatureConfigViewController

    private let presenter: TemperatureConfigPresenter

    // MARK: boilerplate

    private let disposeBag = DisposeBag()

    // what if we use a ReplaySubject (or a BehaviorSubject) instead?
    private let debugTextSubject: ReplaySubject<String> // so apparently we need the subscriptions set up
    // before any events come through, else we risk dropping elements off the beginning
    // so maybe do the circular references the other way -- use subjects for the view controller output
    // that needs to go into the presenter -- that *could* work because nothing will come from the VC
    // until after the presenter has been set up

    // MARK: init

    init(initialFromUnit: TemperatureUnit, initialToUnit: TemperatureUnit) {
        let units: [TemperatureUnit] = [.celsius, .fahrenheit, .kelvin]
        let debugTextSubject = ReplaySubject<String>.create(bufferSize: 1)
        let debugText = debugTextSubject
            .asObservable()
            .asDriver(onErrorJustReturn: "")

        viewController = TemperatureConfigViewController(
            initialFromUnit: initialFromUnit,
            initialToUnit: initialToUnit,
            units: units,
            debugText: debugText)

        presenter = TemperatureConfigPresenter(
            initialFromUnit: initialFromUnit,
            fromUnit: viewController.fromUnit,
            initialToUnit: initialToUnit,
            toUnit: viewController.toUnit)

        unitSelection = viewController.doneTap
            .withLatestFrom(presenter.unitSelection)

        // so this subscription causes a side effect: it makes the first
        // event available to the view controller
        // commenting this subscription causes the VC to not receive the
        // first event, presumably because the VC hasn't yet subscribed by
        // the time the first event is produced
//        debugText
////            .debug("debug text driver thingie")
//            .drive(onNext: { n in print("debug text subject next: \(n)") })
//            .addDisposableTo(disposeBag)

        // boilerplate
        presenter.debugText
            .subscribe(debugTextSubject)
            .addDisposableTo(disposeBag)

        self.debugTextSubject = debugTextSubject
    }

    deinit {
        print("deinit TemperatureConfigCoordinator")
    }

}
