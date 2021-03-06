//
//  ViewController.swift
//  Simple_UITalbeView
//
//  Created by Hajime Taniguchi on 2021/12/07.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerXib(name: "OperatorCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "RxSwift Operators"
    }


}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryboard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let selectedOperator = Operators.array.filter({ $0.type.rawValue == indexPath.section })[indexPath.row]
        guard let detailVC = detailStoryboard.instantiateInitialViewController() as? DetailViewController,
              selectedOperator.swiftCompatible else {
            self.tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        detailVC._operator = selectedOperator
        self.tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return OperatorType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let operatorType = OperatorType.init(rawValue: section) else {
            return nil
        }
        let count = Operators.array.filter({ $0.type.rawValue == section }).count
        return operatorType.title + " (\(count))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Operators.array.filter({ $0.type.rawValue == section }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorCell", for: indexPath) as? OperatorCell else {
            return UITableViewCell()
        }
        let data = Operators.array.filter({ $0.type.rawValue == indexPath.section})[indexPath.row]
        cell.bind(data: data)
        return cell
    }
}
