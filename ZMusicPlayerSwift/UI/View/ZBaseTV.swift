//
//  ZBaseTV.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 25/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZBaseTV: UITableView {

    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: UITableViewStyle.plain)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.innerInit()
    }
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    public convenience init(style: UITableViewStyle) {
        self.init(frame: CGRect.zero, style: style)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.innerInit()
    }
    open func innerInit() {
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
}
