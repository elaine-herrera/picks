//
//  SearchFilter.swift
//  picks
//
//  Created by Elaine Herrera on 18/4/22.
//

import SwiftUI

struct SearchFilterView: View {
    var query:String
    let clearHandler: () -> Void
    
    var body: some View {
        HStack{
            Button(action: clearHandler){
                HStack{
                    Text(query)
                    Image(systemName: "xmark.circle")
                }
                .padding(6)
            }
            .foregroundColor(Color(uiColor: UIColor.label))
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .cornerRadius(12)
            
            Spacer()
        }.padding()
    }
}

struct SearchFilter_Previews: PreviewProvider {
    static var previews: some View {
        SearchFilterView(query: "Searched text to discard", clearHandler: {})
    }
}
