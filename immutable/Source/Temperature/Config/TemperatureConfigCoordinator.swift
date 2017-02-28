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
    private let debugTextSubject = PublishSubject<String>()

    // MARK: init

    init(initialFromUnit: TemperatureUnit, initialToUnit: TemperatureUnit) {
        let units: [TemperatureUnit] = [.celsius, .fahrenheit, .kelvin]
        viewController = TemperatureConfigViewController(
            initialFromUnit: initialFromUnit,
            initialToUnit: initialToUnit,
            units: units,
            debugText: debugTextSubject.asDriver(onErrorJustReturn: ""))
        presenter = TemperatureConfigPresenter(
            initialFromUnit: initialFromUnit,
            fromUnit: viewController.fromUnit,
            initialToUnit: initialToUnit,
            toUnit: viewController.toUnit)
        unitSelection = viewController.doneTap
            .debug("done tap -- coordinator")
            .withLatestFrom(presenter.unitSelection)

        // boilerplate
        presenter.debugText
            .debug("debug text -- coordinator")
            .subscribe(debugTextSubject)
            .addDisposableTo(disposeBag)
    }

    deinit {
        print("deinit TemperatureConfigCoordinator")
    }

}
