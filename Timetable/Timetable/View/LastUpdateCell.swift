//
//  LastUpdateCell.swift
//  TimeTable
//
//  Created by ar_ko on 10/02/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class LastUpdateCell: UITableViewCell {
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    func configure(from viewModel: LastUpdateCellViewModel) {
        self.lastUpdateLabel.text = viewModel.lastUpdate
    }
}
