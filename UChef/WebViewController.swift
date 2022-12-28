//
//  WebViewController.swift
//  UChef
//
//  Created by Vicky Liu on 7/19/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var link: String = ""
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLink()
    }
    
    
    func loadLink(){
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

}
