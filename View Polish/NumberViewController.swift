//
//  NumberViewController.swift
//  View Polish
//
//  Created by Stephen Anthony on 18/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {
    @IBOutlet fileprivate weak var numberLabel: UILabel!
    @IBOutlet fileprivate weak var currencyLabel: UILabel!
    @IBOutlet fileprivate weak var spellOutLabel: UILabel!
    var number = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberLabel.text = numberFormatter.string(from: NSNumber(value: number))
        numberFormatter.numberStyle = .currency
        currencyLabel.text = numberFormatter.string(from: NSNumber(value: number))
        numberFormatter.numberStyle = .spellOut
        spellOutLabel.text = numberFormatter.string(from: NSNumber(value: number))
    }
}
