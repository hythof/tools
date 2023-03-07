import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let file = Bundle.main.url(forResource: "index", withExtension: "html")!
        let dir = file.deletingLastPathComponent()
        webView.loadFileURL(file, allowingReadAccessTo: dir)
        webView.configuration.userContentController.add(self, name: "pl")
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

extension ViewController: WKScriptMessageHandler {
    // JavaScriptからNativeの呼び出し
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let command = message.body as? String {
            if (command == "chrome") {
                
            }
            print("\(command) is not found")
        }
        print("\(message.body) is not a string")
    }
}
