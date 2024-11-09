//
//  BRCaptchWebView.swift
//  BeeRacing
//
//  Created by Inna Chystiakova on 09/11/2024.
//

import SwiftUI
import WebKit

struct BRCaptchWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
