//
//  TaskTableViewCell.swift
//  TodoListApp
//
//  Created by Phincon on 08/08/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    var toggleCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func completedButtonTapped(_ sender: UIButton) {
        toggleCompletion?()
    }
    
}
