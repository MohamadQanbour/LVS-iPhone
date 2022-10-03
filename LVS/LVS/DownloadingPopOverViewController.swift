//
//  DownloadingPopOverViewController.swift
//  LVS
//
//  Created by Jalal on 12/20/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class DownloadingPopOverViewController: UIViewController, URLSessionDownloadDelegate {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var downloaded: UILabel!
    @IBOutlet weak var downloading: UILabel!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var background: UIView!
    
    
    var attachment: Attachment!
    var session: URLSession!
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        background.backgroundColor = Colors.getInstance().colorBackground
        background.layer.cornerRadius = 3.0
        
        self.downloading.adjustsFontSizeToFitWidth = true
        
        self.downloading.text = NSLocalizedString("downloading", comment: "")
        self.cancel.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        self.showAnimate()
        
        self.progress.progress = 0
        
        self.downloaded.text = "0 %"
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        // Do any additional setup after loading the view.
        downloadFile(url: self.attachment.FilePath)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelDownloading(_ sender: UIButton) {
        
        self.session.invalidateAndCancel()
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }

    func downloadFile(url: String) {
        
        let myUrl = URL(string: url)
        let downloadTask = session.downloadTask(with: myUrl!)
        downloadTask.resume()
        
    }
    
    func storeFileLocally(_ data: Data) {
        // create your document folder url
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        
        // your destination file url
        let destinationUrl = documentsUrl.appendingPathComponent("appLittleVillageSchool/tempAttachment.\(attachment.FileType)")
        
        do {
            try data.write(to: destinationUrl)
        } catch let error as NSError {
            DispatchQueue.main.async {
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: error.localizedDescription)
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            }
        }
        
    }
    
    @objc func removeErrorMessage() {
        if self.errorMessage != nil
        {
            self.errorMessage.removeFromSuperview()
            self.errorMessage = nil
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("download task did resume")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // println("download task did finish")
        
        if let data = try? Data(contentsOf: location) {
            storeFileLocally(data)
            
            DispatchQueue.main.async {
                self.removeAnimate()
                let vc = UIActivityViewController(activityItems: [data ], applicationActivities: [])
                self.parent?.present(vc, animated: true, completion: nil)
                
            }
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // println("download task did write data")
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.progress.progress = progress
            self.downloaded.text = "\(Int(progress * 100)) %"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
