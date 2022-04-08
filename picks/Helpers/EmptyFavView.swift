//
//  EmptyFavView.swift
//  picks
//
//  Created by Elaine Herrera on 8/4/22.
//

import SwiftUI

struct EmptyFavView: View {
    var body: some View {
        VStack{
            Image(systemName: "star")
                .resizable()
                .frame(width: 68, height: 68)
            Text("No Favorites yet")
                .font(.title)
        }
        .foregroundColor(Color(UIColor.tertiaryLabel))
    }
}

struct EmptyFavView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFavView()
    }
}
