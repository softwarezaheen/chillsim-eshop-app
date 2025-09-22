//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Raed Nakour on 28/03/2025.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        // Handle Firebase Cloud Messaging format
        var imageUrl: String?
        
        // Check multiple possible locations for image URL
        if let fcmOptions = bestAttemptContent.userInfo["fcm_options"] as? [String: Any],
           let attachmentUrlAsString = fcmOptions["image"] as? String {
            imageUrl = attachmentUrlAsString
        } else if let aps = bestAttemptContent.userInfo["aps"] as? [String: Any],
                  let alert = aps["alert"] as? [String: Any],
                  let attachmentUrlAsString = alert["attachment-url"] as? String {
            imageUrl = attachmentUrlAsString
        } else if let attachmentUrlAsString = bestAttemptContent.userInfo["image"] as? String {
            imageUrl = attachmentUrlAsString
        } else if let attachmentUrlAsString = bestAttemptContent.userInfo["attachment-url"] as? String {
            imageUrl = attachmentUrlAsString
        }
        
        let mediaInfo = bestAttemptContent.userInfo
        print("media info for push is: \(mediaInfo)")
        
        // Download image if URL is available
        if let imageUrlString = imageUrl, let attachmentUrl = URL(string: imageUrlString) {
            downloadImageFrom(url: attachmentUrl) { (attachment) in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        } else {
            // No image to download, deliver the notification as-is
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

extension NotificationService {
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            // 1. Test url and escape if url has problem
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            
            // 2. Create unique temporary file path
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            
            do {
                // Move downloaded file to temporary location
                try FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
                
                // Create notification attachment
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                completionHandler(attachment)
            } catch {
                print("Error creating notification attachment: \(error)")
                completionHandler(nil)
            }
        }
        task.resume()
    }
}
