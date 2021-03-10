//
//  ViewController.m
//  SimpleBrowserApp
//
//  Created by Daniel Romano on 3/21/19.
//  Copyright © 2019 Citrix Systems, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txtAddress.delegate = self;
    _wvMain.delegate = self;
    _wkMain.navigationDelegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btGoPressed:(id)sender
{
    if(_txtAddress.text.length > 0)
    {
        NSURLRequest * request = [self createRequestFromStringURL:_txtAddress.text];
        _txtAddress.text = [[request URL] absoluteString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_wvMain loadRequest:request];
        });
    }
}

- (NSURLRequest *) createRequestFromStringURL:(NSString *)stringURL
{
    NSURLRequest * result = nil;
    NSString * strAddress = [NSString stringWithString:stringURL];
    NSURL * urlToFollow = nil;
    if(![self validateUrl:strAddress])
    {
        NSURL * url = [NSURL URLWithString:[strAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        if([self validateUrl:[url absoluteString]])
        {
            urlToFollow = url;
        }
    }
    else
    {
        if(![strAddress hasPrefix:@"https"] && ![strAddress containsString:@"://"])
        {
            urlToFollow = [NSURL URLWithString:[@"https://" stringByAppendingString:strAddress]];
        }
        else
        {
            urlToFollow = [NSURL URLWithString:strAddress];
        }
    }
    result = [[NSURLRequest alloc] initWithURL:urlToFollow];
    return result;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_UIWebViewSpinner setHidden:NO];
        [self->_WKWebViewSpinner setHidden:NO];
        [self->_UIWebViewSpinner startAnimating];
        [self->_WKWebViewSpinner startAnimating];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_UIWebViewSpinner stopAnimating];
        [self->_UIWebViewSpinner setHidden:YES];
        NSURLRequest * request = [self createRequestFromStringURL:self->_txtAddress.text];
        [self->_wkMain loadRequest:request];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_WKWebViewSpinner stopAnimating];
        [self->_WKWebViewSpinner setHidden:YES];
    });
}

- (BOOL) validateUrl: (NSString *) urlString
{
    NSString *urlRegEx = @"((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:urlString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    BOOL bResult = NO;
    if([string containsString:@"\n"])
    {
        [textField resignFirstResponder];
        [self btGoPressed:self];
    }
    else
    {
        bResult = YES;
    }
    return bResult;
}

@end
