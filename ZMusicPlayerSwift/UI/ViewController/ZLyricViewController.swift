//
//  ZLyricViewController.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 歌词VC
class ZLyricViewController: UITableViewController {

    /// 外界传递过来的歌词数据源, 负责展示
    public var arrayLyric: [ZModelLyric]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 根据外界传递过来的行号, 负责滚动
    public var scrollRow: Int = 0 {
        didSet {
            let indexPath: IndexPath = IndexPath(row: self.scrollRow, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    /// 根据外界传递过来的歌词进度, 展示歌词进度
    public var progress: CGFloat = 0 {
        didSet {
            let indexPath: IndexPath = IndexPath(row: self.scrollRow, section: 0)
            let cell: ZLyricTVC? = self.tableView.cellForRow(at: indexPath) as? ZLyricTVC
            if let cell = cell {
                cell.progress = self.progress
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.innerInit()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 设置tableview内边距, 可以让第一行和最后一行歌词显示到中间位置
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0)
    }
    deinit {
        self.arrayLyric = nil
    }
    /// 初始化控件
    func innerInit() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.showsVerticalScrollIndicator = false
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayLyric = self.arrayLyric else {
            return 0
        }
        return arrayLyric.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "reuseIdentifier"
        var cell: ZLyricTVC? = tableView.dequeueReusableCell(withIdentifier: cellId) as? ZLyricTVC
        if cell == nil {
            cell = ZLyricTVC(reuseIdentifier: cellId)
        }
        let model = self.arrayLyric?[indexPath.row]
        cell?.setCellData(model: model)
        if indexPath.row == self.scrollRow {
            cell?.progress = self.progress
        } else {
            cell?.progress = 0
        }
        return cell!
    }

}
