//
//  DatePickerContentView.swift
//  Today
//
//  Created by Tom Choi on 2/19/26.
//

import UIKit

final class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        func makeContentView() -> any UIView & UIContentView {
            return DatePickerContentView(configuration: self)
        }

        var date: Date = .now
    }

    let datePicker = UIDatePicker()

    var configuration: any UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        datePicker.preferredDatePickerStyle = .inline
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
