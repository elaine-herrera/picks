//
//  LoadingView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

struct LoadingView: View {
    @State var show = false
    let height = (UIScreen.main.bounds.size.width * 360) / 640
    
    var body: some View {
        ZStack{
            list()
                .opacity(self.show ? 0.2 : 1)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)){
                self.show.toggle()
            }
        }
    }
    
    func list() -> some View {
        VStack(spacing: 32) {
            ForEach (0..<2){ _ in
                card()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    func card() -> some View {
        VStack(alignment: .leading, spacing: 0){
            Image(systemName: "photo")
                .resizable()
                .frame(height: height)
              HStack{
                  VStack(alignment: .leading){
                      Text("Placeholder for video name")
                      HStack{
                          Image(systemName: "person")
                              .resizable()
                              .scaledToFit()
                              .clipShape(Circle())
                              .frame(width: 38, height: 38)
                          VStack(alignment: .leading){
                              Text("By User Name Placeholder")
                              Text("Published - Likes")
                          }
                          Spacer()
                      }
                  }
              }
              .padding([.leading, .trailing], 8)
              .padding([.top, .bottom], 16)
        }
        .redacted(reason: .placeholder)
        .background(Color(UIColor.systemBackground))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portraitUpsideDown)
            LoadingView()
        }
    }
}
