//
//  TemperatureConversionCoordinator.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

class TemperatureConversionCoordinator {

    let viewController: TemperatureConversionViewController
    
    private let presenter: TemperatureConversionPresenter

    // private properties

    private let disposeBag = DisposeBag()
    private let fromText = PublishSubject<String>()

    // MARK: init

    init(units: Observable<(TemperatureUnit, TemperatureUnit)>) {
        let eventProvider = TemperatureConversionEventProvider(fromText: fromText.asObservable())
        presenter = TemperatureConversionPresenter(units: units, eventProvider: eventProvider)
        viewController = TemperatureConversionViewController(inputUnit: presenter.fromUnit, outputUnit: presenter.toUnit, viewState: presenter.viewState)
        // tie up circular references
        viewController.fromText.subscribe(fromText).addDisposableTo(disposeBag)
    }
}
