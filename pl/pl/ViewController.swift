//
//  ViewController.swift
//  pl
//
//  Created by Hiroshi Tadokoro on 2023/03/07.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let file = Bundle.main.url(forResource: "index", withExtension: "html")!
        let dir = file.deletingLastPathComponent()
        webView.loadFileURL(file, allowingReadAccessTo: dir)
    }
}

extension ViewController: WKUIDelegate {
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       print("*** didFail: \(error)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("*** didFailProvisionalNavigation: \(error)")
    }
}

