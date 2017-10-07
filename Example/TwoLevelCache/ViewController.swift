//
//  ViewController.swift
//  TwoLevelCache
//
//  Created by Yoshihiro Sawa on 10/06/2017.
//  Copyright (c) 2017 Yoshihiro Sawa. All rights reserved.
//

import UIKit
import TwoLevelCache

fileprivate let ViewControllerImagePath = "https://nzigen.com/static/img/common/logo.png"

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var cache: TwoLevelCache<UIImage>!

    func startLoading() {
        do {
            cache = try TwoLevelCache<UIImage>("cache")
            cache.downloader = { (key, callback) in
                let url = URL(string: key)!
                URLSession.shared.dataTask(with: url) { data, response, error in
                    callback(data)
                    }.resume()
                }
            cache.objectDecoder = { (data) in
                return UIImage(data: data)
            }
            cache.objectEncoder = { (object) in
                return UIImagePNGRepresentation(object)
            }
        } catch {
            
        }
        let text = NSMutableAttributedString(string: "Cache initialized.\n")
        text.append(NSAttributedString(string: "Loading an image.\n"))
        textView.attributedText = text
        cache.loadObjectForKey(ViewControllerImagePath) { (image) in
            if let image = image {
                let textAttachment = NSTextAttachment()
                textAttachment.image = image
                let size = image.size
                let width: CGFloat = 240
                textAttachment.bounds = CGRect(x: 0, y: 0, width: width, height: width * size.height / size.width)
                text.append(NSAttributedString(string: "Success.\n"))
                text.append(NSAttributedString(attachment: textAttachment))
                DispatchQueue.main.sync {
                    self.textView.attributedText = text
                }
            } else {
                text.append(NSAttributedString(string: "Failed.\n"))
                DispatchQueue.main.sync {
                    self.textView.attributedText = text
                }
            }
        }
    }
}

extension ViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
