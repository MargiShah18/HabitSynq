//
//  LoggedInHomeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-28.
//

import Foundation
import SwiftUI

struct LoggedInHomeView: View {
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("My Habits")
                Spacer()
                Button(action:{
                    //Add action here
                })
                {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            .padding()
            .background(Color.white)
            
            Spacer()
            Text("welcome to loggein page")
            Spacer()
            
        }
        .background(Color(.systemGroupedBackground))
    }
}
#Preview{
    LoggedInHomeView()
}
