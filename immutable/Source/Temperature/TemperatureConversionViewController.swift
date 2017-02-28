//
//  TemperatureConversionViewController.swift
//  immutable
//
//  Created by Matt Fenwick on 1/28/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private func outputText(conversionText: String, outputUnit: String) -> String {
    return "is \(conversionText) in \(outputUnit)"
}

func viewStateDisplayText(state: TemperatureConversionViewState) -> String {
    switch state {
        case .empty: return "?"
        case .invalid: return "?"
        case .valid(let scalar):
            let rounded = Int(scalar.rounded())
            return "\(rounded)"
    }
}

class TemperatureConversionViewController: UIViewController {

    // MARK: UI elements
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var inputUnitLabel: UILabel!
    @IBOutlet private weak var outputLabel: UILabel!

    // MARK: output

    private let fromTextSubject = PublishSubject<String>()
    lazy var fromText: Observable<String> = { return self.fromTextSubject.asObservable() }()

    private let configTapSubject = PublishSubject<Void>()
    lazy var configTap: Observable<Void> = { return self.configTapSubject.asObservable() }()

    private let doneTapSubject = PublishSubject<Void>()
    lazy private (set) var doneTap: Observable<Void> = { return self.doneTapSubject.asObservable() }()

    // MARK: private

    private let disposeBag = DisposeBag()
    private let inputUnit: Observable<String>
    private let outputUnit: Observable<String>
    private let viewState: Observable<TemperatureConversionViewState>

    // MARK: init

    init(inputUnit: Observable<String>, outputUnit: Observable<String>, viewState: Observable<TemperatureConversionViewState>) {
        self.inputUnit = inputUnit
        self.outputUnit = outputUnit
        self.viewState = viewState
        super.init(nibName: "TemperatureConversionViewController",
                   bundle: Bundle(for: TemperatureConversionViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Converter"

        textField.rx.text.orEmpty.subscribe(fromTextSubject).addDisposableTo(disposeBag)
        inputUnit.bindTo(inputUnitLabel.rx.text).addDisposableTo(disposeBag)
        let conversionText: Observable<String> = viewState.map(viewStateDisplayText)
        Observable.combineLatest(conversionText, self.outputUnit, resultSelector: outputText)
            .bindTo(outputLabel.rx.text).addDisposableTo(disposeBag)

        let configButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        navigationItem.rightBarButtonItem = configButton
        configButton.rx.tap.subscribe(configTapSubject).addDisposableTo(disposeBag)

        let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = dismissButton
        dismissButton.rx.tap.subscribe(doneTapSubject).addDisposableTo(disposeBag)
    }

    deinit {
        print("deinit TemperatureConversionViewController")
    }

}
