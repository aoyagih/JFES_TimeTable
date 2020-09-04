//
//  Cells.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 5/11/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView

class HourCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds

        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = UIColor(red: 0.220, green: 0.471, blue: 0.871, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ChannelCell: Cell {
    let label = UILabel()

    var channel = "" {
        didSet {
            label.text = String(channel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 2

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SlotCell: Cell {
    @IBOutlet private weak var minutesLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableHighlightLabel: UILabel!
    
    @IBOutlet private weak var notificationImage: UIButton!
    private var pushed = 0
    @IBAction func enableNotification(_ sender: Any) {
        pushed += 1
        print(pushed)
        if(pushed % 2 == 0){
            print("\(title)の通知をOFFにしました")
            if #available(iOS 13.0, *) {
                let offImage = UIImage(systemName: "bell.slash.fill")
                let state = UIControl.State.normal

                notificationImage.tintColor = .black
                notificationImage.setImage(offImage, for: state)
            } else {
                // Fallback on earlier versions
            }
            
        }else{
            print("\(title)の通知をONにしました")
            if #available(iOS 13.0, *) {
                let onImage = UIImage(systemName: "bell.fill")
                let state = UIControl.State.normal

                notificationImage.tintColor = .red
                notificationImage.setImage(onImage, for: state)
                
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    var minutes = 0 {
        didSet {
            minutesLabel.text = String(format: "%02d", minutes)
        }
    }
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var tableHighlight = "" {
        didSet {
            tableHighlightLabel.text = tableHighlight
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class BlankCell: Cell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
