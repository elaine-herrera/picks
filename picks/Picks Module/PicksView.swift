//
//  PicksView.swift
//  picks
//
//  Created by Elaine Herrera on 25/3/22.
//

import SwiftUI

struct PicksView: View {
    @ObservedObject var presenter: PicksPresenter
    @State var query = ""
    
    var body: some View {
        NavigationView {
            if presenter.videos.isEmpty && presenter.isLoading(){
                if query.isEmpty {
                    ScrollView(showsIndicators: false){
                        LoadingView()
                    }
                }
                else{
                    ScrollView(showsIndicators: false){
                        LoadingView()
                    }
                    .navigationTitle("Searching ...")
                }
            }
            else if presenter.failed() {
                ErrorView(error: presenter.getCurrentError()!, retryHandler: presenter.loadData)
            }
            else {
                ScrollView {
                    if !presenter.query.isEmpty {
                        SearchFilter(query: presenter.query){
                            query = ""
                            presenter.submitCurrentSearchQuery(for: query)
                        }
                    }
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
                .searchable(text: $query, prompt: "Look for something")
                .navigationTitle( !presenter.query.isEmpty ? "Search Results" : "Staff Picks")
                .onSubmit(of: .search) {
                    presenter.submitCurrentSearchQuery(for: query)
                }
            }
        }
    }
}

