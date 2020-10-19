//
//  ViewController.swift
//  stickyTest-uk
//
//  Created by Colin Walsh on 10/19/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    
    private let sectionArr = ["Blah", "Blah", "Blah", "Blah",
                              "Blah", "Blah", "Blah", "Blah",
                              "Blah", "Blah", "Blah", "Blah"]
    
    private let sectionDict = [0 : ["Blah", "Blah"],
                               1 : ["Blah", "Blah"],
                               2 : ["Blah", "Blah"],
                               3 : ["Blah", "Blah"],
                               4 : ["Blah", "Blah"],
                               5 : ["Blah", "Blah"],
                               6 : ["Blah", "Blah"],
                               7 : ["Blah", "Blah"],
                               8 : ["Blah", "Blah"],
                               9 : ["Blah", "Blah"],
                               10 : ["Blah", "Blah"]]
    
    private var updatedOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    @IBAction func touchesBegan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: header)
        updatedOffset = translation.y - 300
        let updatedHeight = headerHeight.constant + updatedOffset
        print(updatedHeight)
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self
            else {return}
            
            self.updateHeader(with: updatedHeight)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionDict[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as? DefaultTableViewCell
        else {return UITableViewCell()}
        
        cell.titleLabel.text = sectionDict[indexPath.section]?[indexPath.row] ?? "Nothing"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: .zero)
        label.text = "Section \(section)"
        label.textColor = .white
        label.backgroundColor = .darkGray
        return label
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updatedOffset = scrollView.contentOffset.y
        let updatedHeight = headerTopConstraint.constant - updatedOffset
        
        print(updatedHeight)
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self
            else {return}
            
            self.updateHeader(with: updatedHeight)
            scrollView.layoutIfNeeded()
        }
    }
    
}

extension ViewController {
    func updateHeader(with updatedHeight: CGFloat) {
        self.headerTopConstraint.constant = updatedHeight <= -235 ? -235 : updatedHeight >= -100 ? 0 : updatedHeight
        self.header.layoutIfNeeded()
    }
}


