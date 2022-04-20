//
//  VideoDetailsView.swift
//  picks
//
//  Created by Elaine Herrera on 28/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoDetailsView: View {
    @ObservedObject var presenter: VideoDetailsPresenter
    
    var body: some View {
        ScrollView {
            let video = presenter.video
            VStack(spacing: 0){
                NavigationLink(destination: WebView(request: URLRequest(url: URL(string: video.link!)!))){
                    let link = video.pictures?.sizes.first(where: { $0.height == 360 })?.link ?? ""
                    WebImage(url: URL(string: link))
                        .resizable()
                        .placeholder {
                            Color.gray
                                .frame(width: UIScreen.main.bounds.size.width, height: 200)
                        }
                        .scaledToFit()
                }
                .buttonStyle(.plain)
                presenter.presentVideoFooterView()
                Divider()
                VStack{
                    Text("\(video.description ?? " ")")
                        .font(.subheadline)
                }
                .padding([.top, .bottom], 32)
                .padding([.leading, .trailing], 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
