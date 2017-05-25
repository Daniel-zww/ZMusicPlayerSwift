//
//  ZBaseTVC.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import SnapKit

class ZBaseTVC: UITableViewCell {

    public let space: CGFloat = 10
    public let lbH: CGFloat = 22
    
    public var cellW: CGFloat = 0
    public var cellH: CGFloat = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.innerInit()
    }
    public convenience init(reuseIdentifier: String?) {
        self.init(style: .`default`, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cellW = self.contentView.width
        self.cellH = self.contentView.height
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    open func innerInit() {
        self.selectionStyle = .none
        self.accessoryType = .none
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentView.backgroundColor = UIColor.white
        self.contentView.isUserInteractionEnabled = true
    }

}
