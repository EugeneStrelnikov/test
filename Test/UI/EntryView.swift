//
//  EntryView.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import SwiftUI

struct EntryView: View {
    var entry: Entry
    
    var imageTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //HEADER
            HStack {
    //            Image() group image
                Text(entry.group)
                    .fontWeight(Font.Weight.medium)
                Text(entry.authorName)
                    .fontWeight(Font.Weight.regular)
                Text(entry.date.timeAgo)
                    .fontWeight(Font.Weight.regular)
                    .foregroundColor(Color.black.opacity(0.65))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            
            Text(entry.title)
                .fontWeight(.semibold)
                .font(.system(size: 17))
                .padding(.horizontal, 20)
            Text(entry.description)
                .font(.system(size: 14))
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)

            if let imageLink = entry.imageLink {
                AsyncImage(url: URL(string: imageLink)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Text("Loading")
                }
                    .frame(height: 200)
                    .onTapGesture(perform: imageTapped)
            }
            
            //FOOTER
            HStack {
    //            Image() comments image
                Text(String(entry.commentsCount))
                    .foregroundColor(Color.black.opacity(0.65))
                Spacer()
                Text(String(entry.rating))
                    .foregroundColor(Color(hex: "00AA11"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.white)
        .padding(.vertical, 10)
    }
}
