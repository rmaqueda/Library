//
//  AppDelegate.m
//  Library
//
//  Created by María Jesús Senosiain Caamiña on 14/03/15.
//  Copyright (c) 2015 María Jesús Senosiain Caamiña. All rights reserved.
//

#import "AppDelegate.h"

#import "MJSCLibraryTableViewController.h"
#import "MJSCLibraryCollectionViewController.h"
#import "MJSCBookDetailsViewController.h"
#import "MJSCLibraryViewController.h"

#import "UIViewController+Combinators.h"

#import "MJSCLibrary.h"
//#import "MJSCBook.h"

#define LAST_SELECTED_BOOK_KEY @"LAST_BOOK"

@interface AppDelegate ()

@property (nonatomic,strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MJSCStyles configureAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MJSCLibrary *library = [[MJSCLibrary alloc] initWithBooks];
    UIDevice *dev = [UIDevice currentDevice];

    if ([dev userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureForiPadWithModel:library];
    } else {
        [self configureForiPhoneWithModel:library];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma park -- App Configuration

-(void)configureForiPadWithModel:(MJSCLibrary*)library {
    MJSCBook *book = [self lastBookSelectedInLibrary:library];
    MJSCLibraryViewController *libraryVC = [[MJSCLibraryViewController alloc] initWithModel:library];
    MJSCBookDetailsViewController *bookDetailsVC = [[MJSCBookDetailsViewController alloc] initWithBook:book];
    
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[[libraryVC wrappedInNavigation], [bookDetailsVC wrappedInNavigation]];
    [splitVC setDelegate:bookDetailsVC];
    
    //[libraryVC setDelegate:bookDetailsVC];
    
    self.window.rootViewController = splitVC;
}

-(void)configureForiPhoneWithModel:(MJSCLibrary*)library {
    MJSCLibraryViewController *libraryVC = [[MJSCLibraryViewController alloc] initWithModel:library];
    UINavigationController *navVC = [libraryVC wrappedInNavigation];
    self.window.rootViewController = navVC;
}

# pragma mark - Utils

-(MJSCBook*)lastBookSelectedInLibrary:(MJSCLibrary*)library {
    // Obtain the last book selected
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // Is the first time that app starts, assign defaul book (the first one)
    if (![def objectForKey:LAST_SELECTED_BOOK_KEY]) {
        [def setObject:@[@0,@0] forKey:LAST_SELECTED_BOOK_KEY];
        [def synchronize];
    }
    
    NSArray *coords = [def objectForKey:LAST_SELECTED_BOOK_KEY];
    NSUInteger section = [[coords objectAtIndex:0] integerValue];
    NSUInteger row = [[coords objectAtIndex:1] integerValue];
    
    MJSCBook *book = [library bookAtSection:section index:row];
    
    return book;
}

@end