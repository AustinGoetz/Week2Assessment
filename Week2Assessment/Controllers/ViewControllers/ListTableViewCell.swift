//
//  ListTableViewCell.swift
//  Week2Assessment
//
//  Created by Austin Goetz on 9/27/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func buttonTapped(_ sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    weak var delegate: ListTableViewCellDelegate?
    
    // MARK: Actions
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(self)
    }
    
    func updateViews(list: List) {
        itemLabel.text = list.itemName
        if list.completed {
            completeButton.setImage(UIImage (named: "incomplete"), for: .normal)
        } else {
            completeButton.setImage(UIImage (named: "complete"), for: .normal)
        }
    }
}
