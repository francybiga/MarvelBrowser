//
//  ViewController.m
//  MarvelBrowser
//
//  Created by francesco bigagnoli on 19/01/15.
//  Copyright (c) 2015 francesco bigagnoli. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *timestamp = @"1"; //hard coded for spike
    NSString *keys = [NSString stringWithFormat:@"%@%@%@",timestamp, MARVEL_PRIVATE_KEY, MARVEL_PUBLIC_KEY];
    
    char const *keysString = [keys UTF8String];
    
    //create MD5 hash
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(keysString, (CC_LONG)strlen(keysString), digest);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    //build URL String
    NSString *URLString = [NSString stringWithFormat:@"http://gateway.marvel.com/v1/public/characters?nameStartsWith=Sp&ts=%@&apikey=%@&hash=%@", timestamp, MARVEL_PUBLIC_KEY,hash];
    
    //create data task
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:self
                                                        delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                   NSLog(@"data %@", data);
                                                   NSLog(@"response %@", response);
                                                   NSLog(@"error %@", error);
                                               }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
