//
//  ListenloopPresenter.swift
//  Moodles
//
//  Created by VladislavEmets on 1/13/17.
//  Copyright © 2017 USC Radio Group. All rights reserved.
//

import Foundation
import WebKit


protocol ListenloopPresenterSource {
    func presentationControllerFor(presenter: ListenloopPresenter) -> UIViewController?
}


class ListenloopPresenter {
    
    var delegate: ListenloopPresenterSource?

    private let navigationControllerID = "ListenLoopNavigation"
    private let storyboard = UIStoryboard.init(name: "Listenloop", bundle: Bundle.main)
    private let requestPathFormat = "https://app.listenloop.com/api/v1/public/show_overlay?feature_id=%@&visitor_hash=%@&user_id=%@&remote_ip=%@"
    
    private var dataTask: URLSessionDataTask?
    
    private lazy var webView = {
        return WKWebView()
    }()
    
    
    // MARK: -  Class methods
    
    // MARK: -  Initializations
    
    // MARK: -  Overriden methods
    
    // MARK: -  Public methods
    
    func showOverlayIsAvailable() {
        let urlString = String(format: requestPathFormat,
                               MDListenloop.featureID,
                               UUID().uuidString,
                               MDListenloop.userID,
                               getIFAddresses().first ?? "0.0.0.0") 
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        dataTask?.cancel()
        dataTask = session.dataTask(with: urlRequest, completionHandler: {
            [weak self] (data, response, error) in
            print(error ?? "")
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    return
                }
                let success = result[MDListenloop.Key.successStatus]?.boolValue
                if let urlString = result[MDListenloop.Key.overlayURL] as? String,
                    success == true {
                    DispatchQueue.main.async(execute: {
                        self?.showOverlay(url: URL(string: urlString))
                    })
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        })
        dataTask?.resume()
    }
    
    
    // MARK: -  Private methods
    
    private func showOverlay(url: URL?) {
        guard let overlayUrl = url,
            let presentationController = delegate?.presentationControllerFor(presenter: self),
            let navigation = storyboard.instantiateViewController(withIdentifier: navigationControllerID) as? UINavigationController,
            let feedbackVC = navigation.viewControllers.first as? FeedbackViewController
            else {
                return
        }
        
        presentationController.present(navigation, animated: true) { [weak self] in
            if let webView = self?.webView {
                webView.load(URLRequest(url: overlayUrl))
                webView.frame = feedbackVC.webViewContainer.bounds
                feedbackVC.webViewContainer.addSubview(webView)
            }
        }
    }
    
    
    private func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) { //only IPv4, without AF_INET6 for IPv6
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }
    
    
    //MARK: - FeedbackViewController
}


class FeedbackViewController: UIViewController {
    @IBOutlet weak var webViewContainer: UIView!
    @IBAction func onCancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
