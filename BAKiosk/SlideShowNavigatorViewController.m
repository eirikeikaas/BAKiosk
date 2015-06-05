//
//  SlideShowNavigatorViewController.m
//  BAKiosk
//
//  Created by Eirik Eikås on 20.05.15.
//  Copyright (c) 2015 Evil Corp ENK. All rights reserved.
//

#import "SlideShowNavigatorViewController.h"
#import "TVViewController.h"

@interface SlideShowNavigatorViewController ()

@property UIButton *previous;
@property UIButton *next;
@property UIButton *back;
@property UITextView *text;
@property NSUInteger textIndex;
@property NSUInteger breakIndex;

@end

@implementation SlideShowNavigatorViewController

@synthesize dataObject;
@synthesize previous;
@synthesize next;
@synthesize back;
@synthesize text;
@synthesize textIndex;
@synthesize breakIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect nextRect;
    
    // Check for video
    if(dataObject[@"videos"] != nil){
        nextRect = CGRectMake(50, height-190, width-100, 150);
        [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowLoadVideo object:dataObject[@"videos"]];
    }else{
        nextRect = CGRectMake((width*0.5)+10, height-190, 320, 150);
        [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowLoadImageSet object:dataObject[@"images"]];
    }
    
    // Buttons
    previous = [[UIButton alloc] initWithFrame:CGRectMake((width*0.5)-330, height-190, 320, 150)];
    next = [[UIButton alloc] initWithFrame:nextRect];
    back = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 100, 50)];
    
    if(nextRect.size.width > 320){ [next.titleLabel setFont:[UIFont systemFontOfSize:36]]; }
    
    [previous setTitle:@"Forrige" forState:UIControlStateNormal];
    [next setTitle:@"Neste" forState:UIControlStateNormal];
    [back setTitle:@"Tilbake" forState:UIControlStateNormal];
    
    [previous setBackgroundColor:[UIColor colorWithRed:0.14 green:0.22 blue:0.32 alpha:1]];
    [next setBackgroundColor:[UIColor colorWithRed:0.14 green:0.22 blue:0.32 alpha:1]];
    [back setBackgroundColor:[UIColor colorWithRed:0.14 green:0.22 blue:0.32 alpha:1]];
    
    [previous setHidden:(dataObject[@"videos"] != nil)];
    
    
    // Targets
    [previous addTarget:self action:@selector(prevImage:) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(nextImage:) forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Transcript
    text = [[UITextView alloc] initWithFrame:CGRectMake(50, 170, width-100, height-430)];
    [text setFont:[UIFont fontWithName:@"Helvetica" size:36]];
    [text setEditable:NO];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setText:[dataObject[@"description"] objectAtIndex:0]];
    
    [text sizeToFit];
    
    float compY = ((height-430)/2)-(text.frame.size.height/2);
    
    [text setFrame:CGRectMake(50, 170+compY, width-100, text.frame.size.height)];
    
    // Add childs
    if(![dataObject[@"navigationDisabled"] boolValue]){
        [self.view addSubview:next];
        [self.view addSubview:previous];
    }
    
    [self.view addSubview:back];
    [self.view addSubview:text];
}

- (void)nextImage:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowNextImage object:nil];
    [self updateText:1];
    [self nextBreakpoint:1];
}

- (void)prevImage:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowPrevImage object:nil];
    [self updateText:-1];
    [self nextBreakpoint:-1];
}

- (void)dismiss:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowStandby object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateText:(int)index {
    if(dataObject[@"description"] != nil){
        NSUInteger total = [dataObject[@"description"] count]-1;
        if(textIndex == 0 && index == -1){ // Go to last
            textIndex = total;
        }else if(textIndex == total && index == 1){ // Go to first
            textIndex = 0;
        }else if(index == 1){ // Next
            textIndex++;
        }else if(index == -1){ // Prev
            textIndex--;
        }else {
            NSLog(@"Uh oh.");
        }
        
        float width = [UIScreen mainScreen].bounds.size.width;
        float height = [UIScreen mainScreen].bounds.size.height;
        
        [text setText:[dataObject[@"description"] objectAtIndex:textIndex]];
        [text sizeToFit];
        
        float compY = ((height-430)/2)-(text.frame.size.height/2);
        
        [text setFrame:CGRectMake(50, 170+compY, width-100, text.frame.size.height)];
    }
}

- (void)nextBreakpoint:(int)index {
    if(dataObject[@"videos"] != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:KioskSlideshowPlayForBreakpointIndex object:nil];
    }
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
