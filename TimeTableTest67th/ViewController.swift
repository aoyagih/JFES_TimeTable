//
//  ViewController.swift
//  TimeTableTest67th
//
//  Created by Aoyagi Hiroki on 2020/09/03.
//  Copyright © 2020 aoyagih. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SpreadsheetView

class ViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    let db = Firestore.firestore()
    
    var dictionary: [String:String] = [String:String]()
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    let channels = [
        "Earth Stage", "Galaxy Stage", "Cosmo Stage", "Moon Stage", "Astro Stage"]

    let numberOfRows = 11 * 60 + 1
    var slotInfo = [IndexPath: (Int, Int)]()

    let hourFormatter = DateFormatter()
    let twelveHourFormatter = DateFormatter()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TODO:
        //すべてのドキュメントを見て辞書を作成する
        db.collection("timetableData").whereField("day", isEqualTo: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        print(document.get("artist_name") as! String)
                        self.dictionary[document.documentID] = (document.get("artist_name") as! String)
                    }
                }
        }
        
        //            dictionary["1-1-61"] = "欅坂46"
        //            dictionary["1-1-136"] = "ヤバいTシャツ屋さん"
        //            dictionary["1-1-211"] = "King Gnu"
        //            dictionary["1-1-286"] = "BABYMETAL"
        //            dictionary["1-1-361"] = "Official髭男dism"
        //            dictionary["1-2-61"] = "ゴールデンボンバー"
        
        
//        // Add a new document with a generated ID
//        let docData: [String: Any] = [
//            "artist_name": "ゴールデンボンバー",
//            "day": 1,
//            "end_time": 101,
//            "index": 2,
//            "start_time": 61,
//            "time": "12:00-12:40",
//        ]
//        db.collection("timetableData").document("1-2-61").setData(docData) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//        let docData2: [String: Any] = [
//            "artist_name": "sumika",
//            "day": 2,
//            "end_time": 111,
//            "index": 1,
//            "start_time": 61,
//            "time": "12:00-12:50",
//        ]
//        db.collection("timetableData").document("2-1-61").setData(docData2) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self

        spreadsheetView.register(HourCell.self, forCellWithReuseIdentifier: String(describing: HourCell.self))
        spreadsheetView.register(ChannelCell.self, forCellWithReuseIdentifier: String(describing: ChannelCell.self))
        spreadsheetView.register(UINib(nibName: String(describing: SlotCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SlotCell.self))
        spreadsheetView.register(BlankCell.self, forCellWithReuseIdentifier: String(describing: BlankCell.self))

        spreadsheetView.backgroundColor = .black
        
        let hairline = 1 / UIScreen.main.scale
        spreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
        spreadsheetView.gridStyle = .solid(width: 5, color: .darkGray)
        
        //無限にスクロールする
        //spreadsheetView.circularScrolling = CircularScrolling.Configuration.horizontally.rowHeaderStartsFirstColumn

        hourFormatter.calendar = Calendar(identifier: .gregorian)
        hourFormatter.locale = Locale(identifier: "en_US_POSIX")
        hourFormatter.dateFormat = "h\na"

        twelveHourFormatter.calendar = Calendar(identifier: .gregorian)
        twelveHourFormatter.locale = Locale(identifier: "en_US_POSIX")
        twelveHourFormatter.dateFormat = "H"

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return channels.count + 1
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return numberOfRows
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 30
        }
        return 130
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if row == 0 {
            return 44
        }
        return 3    }

    //動かなくする行と列の数
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    //cellの結合
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        var mergedCells = [CellRange]()

        for row in 0..<11 {
            mergedCells.append(CellRange(from: (60 * row + 1, 0), to: (60 * (row + 1), 0)))
        }
        
        
        //すべてのドキュメントを見てcellの結合場所を得る
        var from_hour: [Int] = [Int]() //開始時間
        var index: [Int] = [Int]()     //column
        var to_hour: [Int] = [Int]()   //終了時間
        
        //時間がかかる処理
        db.collection("timetableData").whereField("day", isEqualTo: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        from_hour.append(document.get("start_time") as! Int)
                        index.append(document.get("index") as! Int)
                        to_hour.append(document.get("end_time") as! Int)
                        print((document.get("start_time") as! Int) + (document.get("index") as! Int))
                        print("count = \(from_hour.count), \(index.count)")
                    }
                    for i in 0..<from_hour.count{
                        mergedCells.append(CellRange(from: (from_hour[i], index[i]), to: (to_hour[i], index[i])))
                        self.slotInfo[IndexPath(row: from_hour[i], column: index[i])] = (from_hour[i]-1, to_hour[i]-from_hour[i])
                    }
                }
                print("先: マージしてから")
                
        }
        
        
        return mergedCells
    }

    //cellのデザイン
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        //一番左上のセル
        if indexPath.column == 0 && indexPath.row == 0 {
            return nil
        }

        //左端の時間のセル
        if indexPath.column == 0 && indexPath.row > 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HourCell.self), for: indexPath) as! HourCell
            //cell.label.text = hourFormatter.string(from: twelveHourFormatter.date(from: "\((indexPath.row - 1) / 60 % 24)")!)
            cell.label.text = String(indexPath.row/60 + 11)
            cell.gridlines.top = .solid(width: 1, color: .white)
            cell.gridlines.bottom = .solid(width: 1, color: .white)
            return cell
        }
        
        //上のチャンネル名のセル
        if indexPath.column > 0 && indexPath.row == 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ChannelCell.self), for: indexPath) as! ChannelCell
            cell.label.text = channels[indexPath.column - 1]
            cell.gridlines.top = .solid(width: 1, color: .black)
            cell.gridlines.bottom = .solid(width: 1, color: .black)
            cell.gridlines.left = .solid(width: 1 / UIScreen.main.scale, color: UIColor(white: 0.3, alpha: 1))
            cell.gridlines.right = cell.gridlines.left
            return cell
        }

        print("後: セルのデザイン生成start")
        print(slotInfo.count)
        print(slotInfo)
        
        //それ以外
        if let (minutes, duration) = slotInfo[indexPath] {
           
            print("indexPath \(indexPath)")
            let name = String(1) + "-" + String(indexPath.column) + "-" + String(indexPath.row)
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: SlotCell.self), for: indexPath) as! SlotCell
            cell.minutes = minutes % 60
            cell.title = dictionary[name] ?? "-"
            cell.tableHighlight = duration > 20 ? "紹介文" : ""
            return cell
        }
        print("後: セルのデザイン生成end")
        
        return spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: BlankCell.self), for: indexPath)
    }

    /// Delegate
    //click時
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        
        print("dictionary count = \(dictionary.count)")
        
        if(!(indexPath.column == 0  ||  indexPath.row == 0)){
            let name = String(1) + "-" + String(indexPath.column) + "-" + String(indexPath.row)
            print(name)
            let artistName = dictionary[name] ?? "-"
            print(artistName)
            
            print("Selected: column: \(indexPath.column), row: \(indexPath.row)")
        
            if(artistName != "-"){
                showAlert(title: "アーティスト名", message: artistName)
            }
        
        }
    }
    
    func showAlert(title: String, message: String)  {
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}



