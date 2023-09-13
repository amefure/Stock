//
//  AccordionBoxView.swift
//  Stock
//
//  Created by t&a on 2023/09/13.
//

import SwiftUI

struct AccordionBoxView: View {
    
    public let question:String
    public let answer:String
    @State private var isClick:Bool = false
    
    var body: some View {
        HStack{
            Image(systemName: "questionmark")
                .opacity(0.5)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(question)
                .font(.system(size: 15))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                isClick.toggle()
            } label: {
                Image(systemName: isClick ? "minus" : "plus")
                    .foregroundColor(isClick ? Color.red : Color.green)
                    .fontWeight(.bold)
                    .opacity(0.8)
            }
        }
        if isClick {
            Text(answer)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .padding(.vertical)
                .padding(.leading)
        }
    }
}

struct AccordionBoxView_Previews: PreviewProvider {
    static var previews: some View {
        AccordionBoxView(question: "", answer: "")
    }
}
