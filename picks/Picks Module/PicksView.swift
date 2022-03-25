//
//  PicksView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

struct PicksView: View {
    @ObservedObject var presenter: PicksPresenter
    
    var body: some View {
        NavigationView {
            if presenter.videos.isEmpty && presenter.isLoading(){
                ScrollView(showsIndicators: false){
                    LoadingView()
                }
            }
            else if presenter.failed() {
                ErrorView(error: presenter.getCurrentError()!, retryHandler: presenter.loadData)
            }
            else {
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach (presenter.videos, id: \.id){ video in
                            presenter.presentVideoView(for: video)
                            .onAppear{
                                presenter.loadDataIfNeeded(currentVideo: video)
                            }
                        }
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }
                .searchable(text: $presenter.search, prompt: "Look for something")
                .navigationTitle("Staff Picks")
            }
        }
    }
}

