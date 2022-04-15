//
//  EntryListView.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import SwiftUI

struct EntryListView: View {
    @ObservedObject var vm: EntriesVM
    var imageTap: (String) -> Void
    
    var body: some View {
        List {
            ForEach(vm.entries) { entry in
                EntryView(entry: entry, imageTapped: {
                    imageTap(entry.imageLink!)
                })
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color(hex: "E5E5E5"))
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}
