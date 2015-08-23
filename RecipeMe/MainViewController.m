//
//  MainViewController.m
//  RecipeMe
//
//  Created by vsokoltsov on 23.08.15.
//  Copyright (c) 2015 vsokoltsov. All rights reserved.
//

#import "MainViewController.h"
#import "SidebarViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) SidebarViewController *leftViewController;
@end

@implementation MainViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    _leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SidebarViewController"];

        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                     alwaysVisibleOptions:0];
        
        self.leftViewBackgroundImage = [UIImage imageNamed:@"sidebarBg.png"];
        // -----
        
        _leftViewController.tableView.backgroundColor = [UIColor clearColor];
        [_leftViewController.tableView reloadData];
        [self.leftView addSubview:_leftViewController.tableView];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
