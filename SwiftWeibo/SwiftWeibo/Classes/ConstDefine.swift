
import Foundation

// MARK: - 应用程序信息

let WBAppKey      = "3309402497"
let WBAppSecret   = "e478275f44f4c2276328536cd455d64a"
let WBRedirectURI = "http://"

// MARK: - 全局通知名称

let WBUserLoginNeededNotification    = "WBUserLoginNeededNotification"
let WBUserLoginSuccessedNotification = "WBUserLoginSuccessedNotification"

// MARK: - 微博配图视图常量

let WBStatusPictureViewOutterMargin = CGFloat(12) // 配图视图外侧的间距
let WBStatusPictureViewInnerMargin  = CGFloat(3)  // 配图视图内部图像视图的间距

let WBStatusPictureViewWidth = UIScreen.sr_screenWidth() - 2 * WBStatusPictureViewOutterMargin
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureViewInnerMargin) / 3
