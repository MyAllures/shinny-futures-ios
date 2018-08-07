//
//  QuoteNavigationCollectionViewController.swift
//  shinnyfutures
//
//  Created by chenli on 2018/4/17.
//  Copyright © 2018年 xinyi. All rights reserved.
//

import UIKit

class QuoteNavigationCollectionViewController: UICollectionViewController {
    // MARK: Properties
    var insList = [String]()
    var nameList = [String]()
    var mainViewController: MainViewController!
    let mananger = DataManager.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDatas(index: 1)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(CommonConstants.LatestFileParsedNotification), object: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        mainViewController = self.parent as! MainViewController
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return nameList.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteNavigationCollectionViewCell", for: indexPath) as! QuoteNavigationCollectionViewCell
        cell.quote.text = nameList[indexPath.row]

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var instrument_id = insList[indexPath.row]
        if instrument_id.contains("&"){
            instrument_id = String(instrument_id.split(separator: "&")[0])
        }
        let ins = instrument_id.components(separatedBy: CharacterSet.decimalDigits).joined()
        if let quoteTableViewController = mainViewController.quotePageViewController.viewControllers?.first as? QuoteTableViewController {
            var count = 0
            for instrumentId in quoteTableViewController.insList {
                if instrumentId.contains(ins) {
                    quoteTableViewController.tableView.scrollToRow(at: IndexPath(row: count, section: 0), at: .top, animated: false)
                    quoteTableViewController.sendSubscribeQuotes()
                    break
                }
                count += 1
            }
        }

    }

    // MARK: Public Methods
    func loadDatas(index: Int) {
        insList.removeAll()
        if index >= mananger.sInsListNames.count {
            return
        }

        insList = mananger.sInsListNames[index].sorted(by: {
            if let sortKey0 = (mananger.sSearchEntities[$0.value]?.sort_key), let sortKey1 = (mananger.sSearchEntities[$1.value]?.sort_key){
                if sortKey0 != sortKey1{
                    return sortKey0 < sortKey1
                }else{
                    return $0.value < $1.value
                }
            }
            return $0.value < $1.value
        }).map{$0.value}

        nameList = mananger.sInsListNames[index].sorted(by: {
            if let sortKey0 = (mananger.sSearchEntities[$0.value]?.sort_key), let sortKey1 = (mananger.sSearchEntities[$1.value]?.sort_key){
                if sortKey0 != sortKey1{
                    return sortKey0 < sortKey1
                }else{
                    return $0.value < $1.value
                }
            }
            return $0.value < $1.value
        }).map{$0.key}

        collectionView?.reloadData()
        //collectionView更改数据源清空collectionviewLayout的缓存，让autolayout重新计算UICollectionView的cell的size，防止崩溃
        collectionView?.collectionViewLayout.invalidateLayout()

    }

    //latestFile文件解析完毕后刷新导航列表
    @objc func refresh() {
        insList.removeAll()
        let index = 1
        if index >= mananger.sInsListNames.count {
            return
        }

        insList = mananger.sInsListNames[index].sorted(by: {
            if let sortKey0 = (mananger.sSearchEntities[$0.value]?.sort_key), let sortKey1 = (mananger.sSearchEntities[$1.value]?.sort_key){
                if sortKey0 != sortKey1{
                    return sortKey0 < sortKey1
                }else{
                    return $0.value < $1.value
                }
            }
            return $0.value < $1.value
        }).map{$0.value}

        nameList = mananger.sInsListNames[index].sorted(by: {
            if let sortKey0 = (mananger.sSearchEntities[$0.value]?.sort_key), let sortKey1 = (mananger.sSearchEntities[$1.value]?.sort_key){
                if sortKey0 != sortKey1{
                    return sortKey0 < sortKey1
                }else{
                    return $0.value < $1.value
                }
            }
            return $0.value < $1.value
        }).map{$0.key}

        self.collectionView?.reloadData()
        //collectionView更改数据源清空collectionviewLayout的缓存，让autolayout重新计算UICollectionView的cell的size，防止崩溃
        self.collectionView?.collectionViewLayout.invalidateLayout()

    }

}
