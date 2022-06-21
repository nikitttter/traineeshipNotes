//
//  TableViewMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 19.06.2022.
//

import Foundation
import UIKit

final class TableViewMock: UITableView {
    private (set) var reloadDataWasCalled = false

    override func reloadData() {
        super.reloadData()
        reloadDataWasCalled = true
    }
}
