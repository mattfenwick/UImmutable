//
//  FlowController.swift
//  immutable
//
//  Created by Matt Fenwick on 1/27/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

private let initialUnits: (TemperatureUnit, TemperatureUnit) = (.celsius, .fahrenheit)

class TemperatureFlowController {

    let componentViewController: TemperatureComponentViewController

    lazy private (set) var didTapDone: Observable<Void> = {
        return self.didTapDoneSubject.asObservable()
    }()

    private let navController: UINavigationController

    // MARK: coordinators
    private let conversionCoordinator: TemperatureConversionCoordinator

    // MARK: boilerplate

    private let didTapDoneSubject = PublishSubject<Void>()

    private let unitSelectionSubject: PublishSubject<(TemperatureUnit, TemperatureUnit)>
    private let disposeBag = DisposeBag()

    private var configCoordinator: TemperatureConfigCoordinator? = nil

    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>

    // MARK: init

    init() {
        unitSelectionSubject = PublishSubject()
        unitSelection = unitSelectionSubject.asObservable().startWith(initialUnits)
        conversionCoordinator = TemperatureConversionCoordinator(units: unitSelection)

        // initial state setup
        componentViewController = TemperatureComponentViewController()
        navController = UINavigationController(rootViewController: conversionCoordinator.viewController)
        navController.launchIn(containerViewController: componentViewController)

        // flow
        conversionCoordinator.configTap
            .withLatestFrom(unitSelection)
            .subscribe(onNext: { [unowned self] (units) in self.showConfig(currentUnits: units) })
            .addDisposableTo(disposeBag)

        conversionCoordinator.doneTap
            .subscribe(didTapDoneSubject)
            .addDisposableTo(disposeBag)
    }

    private func showConfig(currentUnits: (TemperatureUnit, TemperatureUnit)) {
        let configCoordinator = TemperatureConfigCoordinator(
            initialFromUnit: currentUnits.0,
            initialToUnit: currentUnits.1)

        configCoordinator
            .unitSelection
            .debug("config coordinator -- from flow controller")
            .subscribe(onNext: { [unowned self] (units) in
                self.updateConfig(newUnits: units)
            })
            .addDisposableTo(disposeBag)

        self.navController.pushViewController(configCoordinator.viewController, animated: true)

        self.configCoordinator = .some(configCoordinator)
    }

    private func updateConfig(newUnits: (TemperatureUnit, TemperatureUnit)) {
        unitSelectionSubject.onNext(newUnits)
        self.navController.popViewController(animated: true)
        configCoordinator = nil
    }

    deinit {
        print("deinit TemperatureFlowController")
    }
}
