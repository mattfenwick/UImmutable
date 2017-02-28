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

    // MARK: boilerplate

    private let unitSelectionSubject: PublishSubject<(TemperatureUnit, TemperatureUnit)>
    private let disposeBag = DisposeBag()

    private var configResources: (coordinator: TemperatureConfigCoordinator, disposeBag: DisposeBag)? = nil

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
            .subscribe(onNext: showConfig)
            .addDisposableTo(disposeBag)

        conversionCoordinator.doneTap
            .subscribe(onNext: didTapDone)
            .addDisposableTo(disposeBag)
    }

    private func didTapDone() {
        conversionCoordinator.viewController.dismiss(animated: true, completion: nil)
    }

    private func showConfig(currentUnits: (TemperatureUnit, TemperatureUnit)) {
        let configCoordinator = TemperatureConfigCoordinator(initialFromUnit: currentUnits.0, initialToUnit: currentUnits.1)

        let localDisposeBag = DisposeBag()

        configCoordinator
            .unitSelection
            .subscribe(onNext: updateConfig)
            .addDisposableTo(localDisposeBag)

        self.navController.pushViewController(configCoordinator.viewController, animated: true)

        configResources = .some((coordinator: configCoordinator, disposeBag: localDisposeBag))
    }

    private func updateConfig(newUnits: (TemperatureUnit, TemperatureUnit)) {
        unitSelectionSubject.onNext(newUnits)
        self.navController.popViewController(animated: true)
        configResources = nil
    }

    deinit {
        print("deinit TemperatureFlowController")
    }
}
