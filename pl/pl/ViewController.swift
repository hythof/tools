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
            if let item = tryActive(command) {
                print("\(item) is activated")
                hit()
                return
            }
            //if let item = tryLaunch(command) {
            //    print("\(item) is launched")
            //    return
            //}
            print("\(command) is not found")
        } else {
            print("\(message.body) is not a string")
        }
    }
    
    private func hit() {
        self.webView.reload()
        NSRunningApplication().hide()
    }
    
    private func tryLaunch(_ keyword: String) -> String? {
        let dirs = FileManager.default.urls(for: .applicationDirectory, in: .systemDomainMask)
        var candidate: URL?
        for dir in dirs {
            do {
                for file in try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) {
                    if file.lastPathComponent == "Launchpad.app" {
                        continue
                    }
                    if file.lastPathComponent == "Time Machine.app" {
                        continue
                    }
                    if !file.lastPathComponent.lowercased().contains(keyword) {
                        continue
                    }
                    if candidate != nil {
                        return nil
                    }
                    candidate = file
                }
            } catch {
                print(error)
            }
        }
        if let url = candidate {
            if NSWorkspace.shared.open(url) {
                return url.lastPathComponent
            }
        }
        return nil
    }
    
    private func tryActive(_ keyword: String) -> String? {
        let apps = NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == NSApplication.ActivationPolicy.regular }
        var distance = Int.max
        var candidate: NSRunningApplication?
        for app in apps {
            if app.bundleURL?.lastPathComponent.lowercased().contains(keyword) == true {
                let d = ld(app.bundleURL!.lastPathComponent, keyword)
                if d < distance {
                    candidate = app
                    distance = d
                }
            }
        }
        if let app = candidate {
            app.activate()
            return app.bundleURL!.lastPathComponent
        }
        return nil
    }
    
    private func ld(_ word1: String, _ word2: String) -> Int {
        let w1 = word1.map({ String($0) })
        let w2 = word2.map({ String($0) })
        var dp = [[Int]](repeating: [Int](repeating: Int.max, count: w2.count+1), count: w1.count+1)
        dp[0][0] = 0

        for i in 0..<w1.count+1 {
            for j in 0..<w2.count+1 {
                if i-1 >= 0 && j-1 >= 0 {
                    if w1[i-1] == w2[j-1] {
                        dp[i][j] = min(dp[i][j], dp[i-1][j-1])
                    }
                    else {
                        dp[i][j] = min(dp[i][j], dp[i-1][j-1]+1)
                    }
                }
                if i-1 >= 0 {
                    dp[i][j] = min(dp[i][j], dp[i-1][j]+1)
                }
                if j-1 >= 0 {
                    dp[i][j] = min(dp[i][j], dp[i][j-1]+1)
                }
            }
        }

        return dp[w1.count][w2.count]
    }
}
