//
//  TemperatureConfigPresenter.swift
//  immutable
//
//  Created by Matt Fenwick on 1/29/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private func make2Tuple<A, B>(a: A, b: B) -> (A, B) {
    return (a, b)
}

class TemperatureConfigPresenter {

    let debugText: Observable<String>
    let unitSelection: Observable<(TemperatureUnit, TemperatureUnit)>

    init(initialFromUnit: TemperatureUnit,
         fromUnit: Observable<TemperatureUnit>,
         initialToUnit: TemperatureUnit,
         toUnit: Observable<TemperatureUnit>) {
        unitSelection = Observable.combineLatest(
            fromUnit.startWith(initialFromUnit),
            toUnit.startWith(initialToUnit),
            resultSelector: make2Tuple)
        debugText = unitSelection
            .map { tuple in "\(tuple)" }
    }

    deinit {
        print("deinit TemperatureConfigPresenter")
    }
}
