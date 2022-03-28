//
//  VideoView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoView: View {
    @ObservedObject var presenter: VideoPresenter
    let height = (UIScreen.main.bounds.size.width * 360) / 640
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            let video = presenter.video
            let link = video.pictures?.sizes.first(where: { $0.height == 360 })?.link ?? ""
            NavigationLink(destination: WebView(request: URLRequest(url: URL(string: video.link!)!))){
                ZStack{
                    WebImage(url: URL(string: link)!)
                        .resizable()
                        .placeholder {
                            Color.gray
                                .frame(height: height)
                        }
                        .scaledToFill()
                        .transition(.fade(duration: 1))
                        .frame(height: height)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Group{
                                Text(video.duration.formatFromMinutes())
                                    .foregroundColor(.white)
                                    .padding(8)
                            }
                            .background(Color.black.opacity(0.6))
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            presenter.linkBuilder(for: video){
                VideoFooterView(presenter: presenter)
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

