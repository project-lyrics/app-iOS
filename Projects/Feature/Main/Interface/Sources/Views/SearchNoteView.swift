//
//  SearchNoteView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/3/24.
//

import UIKit

import Shared

final class SearchNoteView: UIView {
    
    // MARK: - UIComponents
    
    let noteSearchBar = FeelinSearchBar(placeholder: "노래 검색")
    
    private (set) var searchNoteTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(cellType: SearchNoteCell.self)
        
        return tableView
    }()
    
    private var flexContainer = UIView()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.background
        
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin
            .top(self.pin.safeArea)
            .horizontally()
            .bottom()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            flex.addItem(noteSearchBar)
                .margin(16, 20)
            
            flex.addItem(searchNoteTableView)
                .grow(1)
        }
    }
}
