//
//  VideoFooterView.swift
//  picks
//
//  Created by Elaine Herrera on 28/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoFooterView: View {
    @ObservedObject var presenter: VideoPresenter
    
    var body: some View {
        HStack {
            let video = presenter.video
            VStack(alignment: .leading){
                Text("\(video.name ?? "Some")")
                    .font(.headline)
                    .lineLimit(1)
                HStack{
                    WebImage(url: URL(string: (video.user?.pictures?.sizes.first(where: { $0.height >= 100 })?.link ?? "")!))
                        .resizable()
                        .placeholder {
                            Color.gray
                        }
                        .scaledToFit()
                        .transition(.fade(duration: 1))
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                        .shadow(color: .gray, radius: 2, x: 0, y: 0)
                    VStack(alignment: .leading){
                        Text("By \(video.user?.name ?? "Unknown") ")
                        Text("\(Date().offset(from: video.releaseTime!)) - \(video.metadata.connections.likes.total.formatToViews()) Likes")
                    }
                    Spacer()
                    favoriteButton(video: video)
                }
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(UIColor.secondaryLabel))
            }
            Spacer()
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 16)
    }
    
    func favoriteButton(video: Video) -> some View {
        Group {
            let isFavorite = presenter.isFavorite()
            Button(action: {
                if isFavorite {
                    presenter.removeFromFavorites()
                }
                else {
                    presenter.saveToFavorites()
                }
            }){
                HStack{
                    Image(systemName: isFavorite ? "star.fill" : "star")
                    Text(isFavorite ? "Favorite" : "Add")
                }
                    .padding(10)
                    .background(isFavorite ? Color("AccentColor") : .clear)
                    .foregroundColor(isFavorite ? .white : Color("AccentColor"))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(isFavorite ? .clear : Color("AccentColor"), lineWidth: 2))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}
