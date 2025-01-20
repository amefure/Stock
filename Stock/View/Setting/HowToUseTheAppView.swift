//
//  HowToUseTheAppView.swift
//  Stock
//
//  Created by t&a on 2023/09/13.
//

import SwiftUI

struct HowToUseTheAppView: View {
    var body: some View {
        List {
             
            Section(L10n.howToUseTitle){
                AccordionBoxView(question: L10n.howToUseQ1Title, answer:  L10n.howToUseQ1Text)
                AccordionBoxView(question: L10n.howToUseQ2Title, answer:  L10n.howToUseQ2Text)
                AccordionBoxView(question: L10n.howToUseQ3Title, answer:  L10n.howToUseQ3Text)
                AccordionBoxView(question: L10n.howToUseQ4Title, answer:  L10n.howToUseQ4Text)
                AccordionBoxView(question: L10n.howToUseQ5Title, answer:  L10n.howToUseQ5Text)
                AccordionBoxView(question: L10n.howToUseQ6Title, answer:  L10n.howToUseQ6Text)
                AccordionBoxView(question: L10n.howToUseQ7Title, answer:  L10n.howToUseQ7Text)
             }
        }.scrollContentBackground(.hidden)
            .gradientBackground()
            .fontWeight(.bold)
    }
}

struct HowToUseTheAppView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseTheAppView()
    }
}
