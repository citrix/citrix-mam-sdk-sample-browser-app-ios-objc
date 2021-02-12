//
//  ViewController.h
//  SimpleBrowserApp
//
//  Created by Daniel Romano on 3/21/19.
//  Copyright © 2019 Citrix Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton *btGo;
@property (weak, nonatomic) IBOutlet UIWebView *wvMain;
@property (weak, nonatomic) IBOutlet WKWebView *wkMain;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UIWebViewSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *WKWebViewSpinner;

- (IBAction)btGoPressed:(id)sender;

@end

