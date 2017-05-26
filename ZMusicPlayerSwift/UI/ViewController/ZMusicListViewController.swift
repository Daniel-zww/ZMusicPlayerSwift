//
//  ZMusicListViewController.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 歌曲列表VC
class ZMusicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tvMain: ZBaseTV?
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
        tvMain?.dataSource = nil
        tvMain?.delegate = nil
        arrayMusic = nil
    }
    /// 初始化控件
    func innerInit() {
        self.tvMain = ZBaseTV()
        self.tvMain?.delegate = self
        self.tvMain?.dataSource = self
        self.tvMain?.rowHeight = 80
        self.view.addSubview(self.tvMain!)
        
        let backImageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        self.tvMain?.backgroundView = backImageView
        
        self.setViewFrame()
        self.innerData()
    }
    func setViewFrame() {
        self.tvMain?.snp.removeConstraints()
        self.tvMain?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.edges.equalTo(self!.view).inset(UIEdgeInsets.zero)
            }
        })
    }
    func innerData() {
        ZMusicModelTool.loadLocalMusicModelArray { [weak self] (result) in
            /// 设置局部播放列表
            self?.arrayMusic = result
            /// 设置全局播放列表
            ZMusicTool.sharedInstance.arrayMusic = result
            /// 刷新View
            self?.tvMain?.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayMusic = self.arrayMusic else {
            return 0
        }
        return arrayMusic.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellReuseIdentifier"
        var cell: ZMusicListTVC? = tableView.dequeueReusableCell(withIdentifier: cellId) as? ZMusicListTVC
        if cell == nil {
            cell = ZMusicListTVC(reuseIdentifier: cellId)
        }
        if let cell = cell {
            let model = self.arrayMusic?[indexPath.row]
            cell.setCellData(model: model)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.arrayMusic?[indexPath.row]
        if let model = model {
            // 播放视图
            let itemVC = ZMusicViewController.sharedInstance
            // 播放音乐
            ZMusicTool.sharedInstance.playMusic(modelMusic: model)
            // 跳转到播放界面
            self.present(itemVC, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1)
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

}
