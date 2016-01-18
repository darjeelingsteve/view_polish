//
//  NumberViewController.swift
//  View Polish
//
//  Created by Stephen Anthony on 18/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var spellOutLabel: UILabel!
    var number = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        numberLabel.text = numberFormatter.stringFromNumber(number)
        numberFormatter.numberStyle = .CurrencyStyle
        currencyLabel.text = numberFormatter.stringFromNumber(number)
        numberFormatter.numberStyle = .SpellOutStyle
        spellOutLabel.text = numberFormatter.stringFromNumber(number)
    }
}
