//
//  UICollectionView+Extension.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

extension UICollectionView {
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// Note: withIdentifier must be equal to the Cell Class.
    func dequeueReusableCell<T : UICollectionViewCell>(with cell: T.Type, for indexPath: IndexPath) -> T {
        if let Cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: cell.self), for: indexPath) as? T{
            return Cell
        }
        fatalError(String(describing: cell.self))
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// Nib name must be equal to the Cell Class, and the forCellReuseIdentifier must equal to Cell Class as well.
    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellWithReuseIdentifier: id)
    }
    
    /// Registers a class for use in creating new table cells.
    /// Note: forCellReuseIdentifier must equal to the Cell Class.
    func register(_ cellClass: Swift.AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass.self))
    }
}
