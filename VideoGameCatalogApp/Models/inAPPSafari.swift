//
//  inAPPSafari.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 11/1/23.
//

import SwiftUI
import SafariServices
// Represents a SwiftUI View that wraps SFSafariViewController to display a web page.
struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    // Creates and returns a SFSafariViewController with the specified URL.
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    // Updates the SFSafariViewController with the specified URL.
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}
