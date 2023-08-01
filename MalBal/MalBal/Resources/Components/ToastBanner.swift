//
//  ToastBanner.swift
//  MalBal
//
//  Created by Joy on 2023/08/01.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    @Binding var toastMessage: String
    
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                toast
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
    
    private var toast: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(toastMessage)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(16)
            Spacer().frame(height:144)
            
        }
        .padding()
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, toastMessage: Binding<String>, duration: TimeInterval) -> some View {
        modifier(ToastModifier(isShowing: isShowing, toastMessage: toastMessage, duration: duration))
    }
}
