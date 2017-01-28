//
//  TemperatureConverterTests.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import XCTest
@testable import immutable

class TemperatureConverterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFahrenheitNormalization() {
        let fahrenheit = TemperatureUnit.fahrenheit
        XCTAssertEqualWithAccuracy(fahrenheit.normalize(scalar: 0), 255.372, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(fahrenheit.normalize(scalar: 10), 260.928, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(fahrenheit.normalize(scalar: 20), 266.483, accuracy: 0.001)
    }

    func testFahrenheitDenormalization() {
        let fahrenheit = TemperatureUnit.fahrenheit
        XCTAssertEqualWithAccuracy(fahrenheit.denormalize(scalar: 255.372), 0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(fahrenheit.denormalize(scalar: 260.928), 10, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(fahrenheit.denormalize(scalar: 266.483), 20, accuracy: 0.001)
    }

    func testFahrenheitToKelvin() {
        XCTAssertEqualWithAccuracy(Temperature(unit: .fahrenheit, scalar: 0).convertTo(unit: .kelvin).scalar, 255.372, accuracy: 0.001)
    }

}
