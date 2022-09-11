//
//  UITableView+Extension.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

extension UITableView {
    
    public func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClassIdentifier cell: T.Type, for indexPath: IndexPath) -> T {
        if let Cell = self.dequeueReusableCell(withIdentifier: String(describing: cell.self), for: indexPath) as? T{
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    func dequeueReusableCell<T : UITableViewCell>(withClassIdentifier cell: T.Type) -> T {
        if let Cell = dequeueReusableCell(withIdentifier: String(describing: cell.self)) as? T {
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    func registerNib(_ cellClass: UITableViewCell.Type) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
    
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }
}
