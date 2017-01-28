//
//  TemperatureConversionEventProvider.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxSwift

struct TemperatureConversionEventProvider {
    let fromText: Observable<String>
}
