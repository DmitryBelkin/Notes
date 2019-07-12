//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Dmitry Belkin on 29/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = colorImageView.backgroundColor

        super.setSelected(selected, animated: animated)

        if selected {
            colorImageView.backgroundColor = color
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = colorImageView.backgroundColor

        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            colorImageView.backgroundColor = color
        }
    }

}
