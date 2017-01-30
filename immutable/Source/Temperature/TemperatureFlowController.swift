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
    private let navController: UINavigationController

    // MARK: coordinators
    private let conversionCoordinator: TemperatureConversionCoordinator
    private let configCoordinator: TemperatureConfigCoordinator

    // MARK: boilerplate

    private let unitSelectionSubject: PublishSubject<(TemperatureUnit, TemperatureUnit)>
    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>
    private let disposeBag = DisposeBag()

    // MARK: init

    init() {
        unitSelectionSubject = PublishSubject()
        unitSelection = unitSelectionSubject.asObservable()
        let units = unitSelection.startWith(initialUnits) // TODO read from NSUserDefaults, perhaps
        conversionCoordinator = TemperatureConversionCoordinator(units: units)
        configCoordinator = TemperatureConfigCoordinator()

        // initial state setup
        componentViewController = TemperatureComponentViewController()
        navController = UINavigationController(rootViewController: conversionCoordinator.viewController)
        navController.launchIn(containerViewController: componentViewController)

        // flow
        let updateUnitSelection: Observable<(TemperatureUnit, TemperatureUnit)> = configCoordinator.unitSelection.shareReplay(1)
        updateUnitSelection.subscribe(onNext: { _ in
            self.updateConfig()
        }).addDisposableTo(disposeBag)
        updateUnitSelection.subscribe(unitSelectionSubject).addDisposableTo(disposeBag)

        conversionCoordinator.configTap.subscribe(onNext: {
            self.showConfig() // TODO weak self? unowned?
        }).addDisposableTo(disposeBag)
    }

    private func showConfig() {
        self.navController.pushViewController(self.configCoordinator.viewController, animated: true)
    }

    private func updateConfig() {
        self.navController.popViewController(animated: true)
    }
}
