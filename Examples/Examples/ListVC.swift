//
//  ListVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD
import SnapKit

// MARK: - Model
struct Row {
    var title: String
    var action: () -> Void
}

struct Section {
    var title: String
    var rows = [Row]()
    mutating func add(title: String, action: @escaping () -> Void) {
        rows.append(.init(title: title, action: action))
    }
}

struct ListModel {

    var sections = [Section]()
    
    mutating func add(title: String, rows: (_ section: inout Section) -> Void) {
        var sec = Section(title: title)
        rows(&sec)
        sections.append(sec)
    }
    
}
// MARK: - View
class TableHeaderView: UIView {
    
    lazy var textLabel: UILabel = {
        let lb = UILabel(frame: .init(x: 0, y: 24, width: UIScreen.main.bounds.width, height: 24))
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.textAlignment = .justified
        lb.numberOfLines = 0
        lb.text = ""
        return lb
    }()
    
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(8)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - Controller
class ListVC: UIViewController {

    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .insetGrouped)
        v.dataSource = self
        v.delegate = self
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return v
    }()
    
    var list = ListModel()
    
    lazy var header: TableHeaderView = TableHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.tableHeaderView = header
        tableView.sectionHeaderHeight = 32
        tableView.sectionFooterHeight = 8
        
    }
    
    
    @objc func onTappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://github.com/xaoxuu/Liberators") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func onTappedRightBarButtonItem(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://xaoxuu.com/wiki/liberators/") else { return }
        UIApplication.shared.open(url)
    }
    
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        list.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        list.sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        list.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list.sections[indexPath.section].rows[indexPath.row].title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AppContext.workspace = self
        list.sections[indexPath.section].rows[indexPath.row].action()
    }
    
}
