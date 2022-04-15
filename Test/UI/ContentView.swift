//
//  ContentView.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var entriesVM = EntriesVM(service: WebService())
    
    @State var selectedImageLink: String?
    
    var body: some View {
        ZStack {
            EntryListView(
                vm: entriesVM,
                imageTap: { imageLink in
                    selectedImageLink = imageLink
                }
            )
                .onAppear {
                    entriesVM.loadData()
                }
                .background(Color(hex: "E5E5E5"))
            
            if let selectedImageLink = selectedImageLink {
                Color.black.ignoresSafeArea()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


