//
//  StoryPartViewController.m
//  AVStoryBoard
//
//  Created by Javier Xing on 2017-11-17.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "StoryPartViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface StoryPartViewController ()  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioRecorder *recorder;



@end

@implementation StoryPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.image.image = self.model.image;
    
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.model.recordingPath = [NSURL fileURLWithPath:[[documentsPaths firstObject] stringByAppendingPathComponent:@"recorded.mp4"]];
    
}

- (IBAction)cameraButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // not running on simulator, take a picture
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    NSLog(@"Picking media of types %@", mediaTypes);
    picker.mediaTypes = mediaTypes;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{}];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"info %@", info);
    self.image.image = info[UIImagePickerControllerOriginalImage];
    self.model.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{}];
}




- (IBAction)microphoneButton:(id)sender {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        return;
    }
    [sender setTitle:@"Stop" forState:UIControlStateNormal];
    
    NSError *err = nil;
    self.recorder = [[AVAudioRecorder alloc]initWithURL:self.model.recordingPath
                                               settings:@{AVNumberOfChannelsKey: @(2),
                                                          AVSampleRateKey: @(44100),
                                                          AVFormatIDKey: @(kAudioFormatMPEG4AAC)}
                                              error:&err];
    if (err != nil) {
        NSLog(@"Error creating recorder: %@", err.localizedDescription);
        return;
    }
    [self.recorder record];
}

- (IBAction)tapImage:(id)sender {
    if ([self.player isPlaying]) {
        [self.player stop];
        return;
    }
    
    NSError *err = nil;
    self.player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:self.model.recordingPath
                   error:&err];
    if (err != nil) {
        NSLog(@"Error creating player: %@", err.localizedDescription);
        return;
    }
    [self.player play];
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
