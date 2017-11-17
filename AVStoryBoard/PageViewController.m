//
//  PageViewController.m
//  AVStoryBoard
//
//  Created by Javier Xing on 2017-11-17.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "PageViewController.h"
#import "Model.h"
#import "StoryPartViewController.h"

@interface PageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong)NSArray <Model *>*modelArray;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    
    Model *model1 = [[Model alloc]init];
    Model *model2 = [[Model alloc]init];
    Model *model3 = [[Model alloc]init];
    Model *model4 = [[Model alloc]init];
    Model *model5 = [[Model alloc]init];
    self.modelArray = @[model1, model2, model3, model4, model5];
    
    StoryPartViewController *firstPage =  [self.storyboard instantiateViewControllerWithIdentifier:@"initialPage"];
    [firstPage setModel:self.modelArray[0]];
    NSArray *viewControllers = @[firstPage];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

#pragma mark -PageViewController DataModel
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    StoryPartViewController *SPviewController = (StoryPartViewController*)viewController;
    NSInteger index = [self.modelArray indexOfObject:SPviewController.model];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    
    StoryPartViewController *passedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialPage"];
    passedViewController.model = self.modelArray[index];
    
    return passedViewController;
    
    
    return nil;
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    StoryPartViewController *SPviewController = (StoryPartViewController*)viewController;
    NSInteger index = [self.modelArray indexOfObject:SPviewController.model];
    if ((index == 5) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    
    StoryPartViewController *passedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialPage"];
    passedViewController.model = self.modelArray[index];
    
    return passedViewController;
    
    
    
    return nil;
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
