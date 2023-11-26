//
//  YoutubeVideoFormat.swift
//  VideoGameCatalogApp
//
//  Created by brian waobikeze on 10/31/23.
//

import SwiftUI
import WebKit
// Represents a SwiftUI View that displays a WKWebView.
struct WebView: UIViewRepresentable {
    let urlString: String
    // Creates and returns a WKWebView.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    // Updates the WKWebView with the specified YouTube URL.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(urlString)?autoplay=1&playsinline=1") else {return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url:youtubeURL))
 
    }
}
