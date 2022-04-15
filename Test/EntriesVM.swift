//
//  EntriesVM.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import Combine

class EntriesVM: ObservableObject {
    @Published private(set) var entries: [Entry] = []
    
    private let service: WebService
    init(service: WebService) {
        self.service = service
    }
    
    private var subscriptions = Set<AnyCancellable>()

    func loadData() {
        service
            .getEntries()
            .sink { newData in
                self.entries = newData
            }
            .store(in: &subscriptions)
    }
}
