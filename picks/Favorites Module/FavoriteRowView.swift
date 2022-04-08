//
//  FavoriteRowView.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteRowView: View {
    var video: Video
    let width: CGFloat = (60 * 640) / 360
    var body: some View {
        HStack {
            let link = video.pictures?.sizes.first(where: { $0.height == 360 })?.link ?? ""
            WebImage(url: URL(string: link))
                .resizable()
                .placeholder {
                    Color.gray
                        .frame(width: width, height: 60)
                }
                .scaledToFit()
                .transition(.fade(duration: 1))
                .frame(width: width, height: 60)
            VStack(alignment: .leading) {
                Text("\(video.name ?? "Some")")
                    .lineLimit(2)
                    .font(.headline)
                Text("By \(video.user?.name ?? "Unknown") ")
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }
    }
}
