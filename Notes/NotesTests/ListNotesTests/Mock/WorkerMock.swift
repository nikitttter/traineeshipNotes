//
//  WorkerMock.swift
//  NotesTests
//
//  Created by Nikita Yakovlev on 17.06.2022.
//

import Foundation
@testable import Notes

final class WorkerMock: WorkerType {
    private (set) var fetchDataWasCalled = false
    let notes = [Note(title: "testTitle", text: "testBody", date: .now)]

    func fetchData(_ completion: @escaping ([Note]) -> Void) {
        fetchDataWasCalled = true
        completion(notes)
    }
}
