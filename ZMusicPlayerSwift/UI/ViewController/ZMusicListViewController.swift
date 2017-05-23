//
//  ZMusicListViewController.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 歌曲列表VC
class ZMusicListViewController: UITableViewController {

    private var arrayMusic: [ZModelMusic]?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "歌曲列表"
        self.innerInit()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        self.arrayMusic = nil
    }
    /// 初始化控件
    func innerInit() {
        let backImageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        backImageView.isUserInteractionEnabled = false
        self.tableView.backgroundView = backImageView
        self.tableView.backgroundColor = .clear
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        ZMusicModelTool.loadLocalMusicModelArray { [weak self] (result) in
            self?.arrayMusic = result
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayMusic = self.arrayMusic else {
            return 0
        }
        return arrayMusic.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellReuseIdentifier"
        var cell: ZMusicListTVC? = tableView.dequeueReusableCell(withIdentifier: cellId) as? ZMusicListTVC
        if cell == nil {
            cell = ZMusicListTVC(reuseIdentifier: cellId)
        }
        let model = self.arrayMusic?[indexPath.row]
        cell?.setCellData(model: model)
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.arrayMusic?[indexPath.row]
        if let model = model {
            ZMusicTool.sharedInstance.playMusic(modelMusic: model)
            let itemVC = ZMusicViewController.sharedInstance
            self.present(itemVC, animated: true, completion: nil)
        }
    }
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        UIView.animate(withDuration: 0.5) {
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//        }
//    }

}
