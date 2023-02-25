//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 22.02.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    
    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBAction private func didTapeBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: AccessKey),
        URLQueryItem(name: "redirect_uri", value: RedirectURI),
        URLQueryItem(name: "response_type", value: "code"),
        URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
           return nil
        }
    }
}

protocol WebViewViewControllerDelegate: AnyObject {
    func  webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

