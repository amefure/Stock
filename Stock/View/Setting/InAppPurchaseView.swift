//
//  InAppPurchaseView.swift
//  Stock
//
//  Created by t&a on 2025/01/20.
//

import SwiftUI

struct InAppPurchaseView: View {
    @StateObject private var viewModel = InAppPurchaseViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {

            Text(L10n.settingInAppPurchaseTitle)
                .fontL(bold: true)
                .padding(.vertical)

            Text(L10n.settingInAppPurchaseMessage)
                .fontS()
                .padding(.horizontal)

            if viewModel.fetchError {
                Spacer()

                VStack {
                    Text("ERROR")
                        .fontL(bold: true)

                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.vertical)

                    Text(L10n.settingInAppPurchaseFetchError)
                        .fontM(bold: true)

                }.frame(width: DeviceSizeUtility.deviceWidth)
                    .padding(.bottom, 30)

                Spacer()
            } else {
                List {
                    ForEach(viewModel.products) { product in
                        Section {
                            VStack(spacing: 8) {
                                Text(product.displayName)
                                    .fontM(bold: true)
                                    .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                                Text("・\(product.description)")
                                    .fontS()
                                    .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                                Text(product.displayPrice)
                                    .fontM(bold: true)

                                Button {
                                    viewModel.purchase(product: product)
                                } label: {
                                    if viewModel.isPurchasingId == product.id {
                                        ProgressView()
                                            .tint(.black)
                                            .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                            .background(.white)
                                            .foregroundStyle(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                    } else {
                                        Text(viewModel.isPurchased(product.id) ? L10n.settingInAppPurchased : L10n.settingInAppPurchase)
                                            .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                            .background(.white)
                                            .foregroundStyle(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                    }

                                }.buttonStyle(.plain)
                                    .disabled(viewModel.isPurchased(product.id))
                                    .disabled(viewModel.isPurchasingId == product.id)
                            }
                        }
                    }

                    VStack(spacing: 8) {
                        Text(L10n.settingInAppPurchaseRestoreTitle)
                            .fontM(bold: true)
                            .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                        Text(L10n.settingInAppPurchaseRestoreMsg)
                            .fontS()
                            .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                        Button {
                            viewModel.restore()
                        } label: {
                            Text(L10n.settingInAppPurchaseRestore)
                                .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                .background(.white)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .gray, radius: 3, x: 4, y: 4)
                        }.buttonStyle(.plain)
                    }
                }.scrollContentBackground(.hidden)
            }

        }.onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
            .ignoresSafeArea(.keyboard)
            .fontM()
            .gradientBackground()
            .alert(
                isPresented: $viewModel.purchaseError,
                title: "Error",
                message: L10n.settingInAppPurchaseError,
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    viewModel.purchaseError = false
                },
                negativeAction: {}
            )
    }
}

#Preview {
    InAppPurchaseView()
}
