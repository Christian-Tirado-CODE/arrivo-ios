//
//  UndoToast.swift
//  arrivo
//
//  Created by Christian Tirado on 9/17/26.
//

import SwiftUI

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 8)

            Button(action: onUndo) {
                Text("UNDO")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.arrivoAccent)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(red: 30/255, green: 41/255, blue: 59/255),
                    in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 12, y: 4)
    }
}
