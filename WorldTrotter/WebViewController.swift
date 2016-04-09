import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        
        if let url = NSURL(string: "https://www.bignerdranch.com") {
            webView.loadRequest(NSURLRequest(URL: url))
        }
        view = webView
    }
}