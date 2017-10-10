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
    var count = 0
    
    func load() {
        let text = self.textView.attributedText.mutableCopy() as! NSMutableAttributedString
        self.count += 1
        text.append(NSAttributedString(string: String(format: "%d) Loading an image.\n", count)))
        textView.attributedText = text

        cache.object(forKey: ViewControllerImagePath) { (image, status) in
            DispatchQueue.main.sync {
                let text = self.textView.attributedText.mutableCopy() as! NSMutableAttributedString
                if let image = image {
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = image
                    let size = image.size
                    let width: CGFloat = 240
                    textAttachment.bounds = CGRect(x: 0, y: 0, width: width, height: width * size.height / size.width)
                    text.append(NSAttributedString(string: "Success.\n"))
                    switch status {
                    case .memory:
                        text.append(NSAttributedString(string: "Loaded from memory.\n"))
                    case .file:
                        text.append(NSAttributedString(string: "Loaded from file.\n"))
                    case .downloader:
                        text.append(NSAttributedString(string: "Loaded by downloader.\n"))
                    default:
                        break
                    }
                    text.append(NSAttributedString(attachment: textAttachment))
                    text.append(NSAttributedString(string: "\n\n"))
                    self.textView.attributedText = text
                } else {
                    text.append(NSAttributedString(string: "Failed.\n\n"))
                    self.textView.attributedText = text
                }
                if self.count < 3 {
                    sleep(5)
                    self.load()
                }
            }
        }
    }

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
        let text = NSMutableAttributedString(string: "Cache initialized.\n\n")
        textView.attributedText = text
        load()
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
