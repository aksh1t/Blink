//
//  PlayViewController.m
//  Blink
//
//  Created by Akshat on 18/09/13.
//  Copyright (c) 2013 Akshat. All rights reserved.
//

#import "PlayViewController.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JDFlipNumberView.h"
#import "SettingsData.h"

@interface PlayViewController ()

@property (nonatomic) BOOL isUsingFrontFacingCamera;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CIDetector *faceDetector;

- (void)setupAVCapture;
- (void)teardownAVCapture;

@end

@implementation PlayViewController

@synthesize videoDataOutput = _videoDataOutput;
@synthesize videoDataOutputQueue = _videoDataOutputQueue;
@synthesize previewView = _previewView;
@synthesize previewLayer = _previewLayer;
@synthesize faceDetector = _faceDetector;
@synthesize isUsingFrontFacingCamera = _isUsingFrontFacingCamera;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    flipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:4];
    flipNumberView.value = 0;
    
    // add to view hierarchy and resize
    [self.view addSubview: flipNumberView];
    flipNumberView.frame = CGRectMake(200,400,100,50);
    
    [self setupAVCapture];
    

    detect = FALSE;
    blinkcount = 0;
    tcount = 0;
    fcount = 0;
    capture = 1;
    drop = 1;
    startframecount = 0;
}

- (void)viewDidDisappear:(BOOL)animated{
    [self teardownAVCapture];
	self.faceDetector = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Start button pressed
-(IBAction)start:(id)sender{
    detect = TRUE;
    tcount = 0;
    startframecount = 0;
    flipNumberView.value = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    [timer fire];
    [resultLabel setText:@""];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
	self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
}

//Method to set up the video capture from camera
- (void)setupAVCapture{
	NSError *error = nil;
    
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPreset640x480];
    
    // Select a video device, make an input
	AVCaptureDevice *device;
    
    // Select frontfacing camera
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
	
    // Find the frontfacing camera
	for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
		if ([d position] == desiredPosition) {
			device = d;
            self.isUsingFrontFacingCamera = YES;
			break;
		}
	}
    // Fall back to the default camera.
    if( nil == device ){
        self.isUsingFrontFacingCamera = NO;
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    // Get the input device
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
	if( !error ) {
        // add the input to the session
        if ( [session canAddInput:deviceInput] ){
            [session addInput:deviceInput];
        }
        
        // Make a video data output
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
        NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                           [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [self.videoDataOutput setVideoSettings:rgbOutputSettings];
        [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked
        
        // create a serial dispatch queue used for the sample buffer delegate
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
        
        if ( [session canAddOutput:self.videoDataOutput] ){
            [session addOutput:self.videoDataOutput];
        }
        
        // get the output for doing face detection.
        [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        self.previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        CALayer *rootLayer = [self.previewView layer];
        [rootLayer setMasksToBounds:YES];
        [self.previewLayer setFrame:[rootLayer bounds]];
        [rootLayer addSublayer:self.previewLayer];
        [session startRunning];

    }
	session = nil;
    
    // Error handling
	if (error) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  [NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
		[alertView show];
		[self teardownAVCapture];
	}
}

// Free up video capture resources
- (void)teardownAVCapture
{
	self.videoDataOutput = nil;
	[self.previewLayer removeFromSuperlayer];
	self.previewLayer = nil;
}

// Method to display error alert if takePicture fails
- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Dismiss"
                                  otherButtonTitles:nil];
        [alertView show];
	});
}

// Method for checking orientation of the device
- (NSNumber *) exifOrientation: (UIDeviceOrientation) orientation
{
	int exifOrientation;
    
	enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1,
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2,
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3,
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4,
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5,
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6,
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7,
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8
	};
	
	switch (orientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
			if (self.isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
			if (self.isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
	}
    return [NSNumber numberWithInt:exifOrientation];
}

// Most important method which captures frames from videoStream and processes them if detect boolean is TRUE
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if(detect){
        startframecount++;
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                        options:(__bridge NSDictionary *)attachments];
        if (attachments) {
            CFRelease(attachments);
        }
    
        // Make sure your device orientation is not locked.
        UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    
        NSDictionary *imageOptions = nil;
        imageOptions = [[NSDictionary alloc]initWithObjectsAndKeys:[self exifOrientation:curDeviceOrientation],CIDetectorImageOrientation,@(YES),CIDetectorEyeBlink,@(YES),CIDetectorSmile,nil];
    
        NSArray *features = [self.faceDetector featuresInImage:ciImage
                                                   options:imageOptions];
    
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            capture++;
            [capdrop setText:[NSString stringWithFormat:@"Capture : %d Drop : %d D/C : %d",capture,drop,(drop/capture)]];
            if(features.count > 0){
                fcount = 0;
                [facedetected setText:@"Face Detected : YES"];
                CIFaceFeature *feature = [features objectAtIndex:0];
            
                if([feature leftEyeClosed]&&[feature rightEyeClosed]){
                    //
                    if(startframecount < 2){
                        [timer invalidate];
                        tcount = 0;
                        
                        //Telling the capture methods to stop procssing frames
                        detect = FALSE;
                        
                        //Reseting the faceDetector
                        self.faceDetector = nil;

                        UIAlertView *closedEyeAlert = [[UIAlertView alloc]initWithTitle:@"Closed Eye!" message:@"You started the game with your eyes closed!" delegate:nil cancelButtonTitle:@"Try Again!" otherButtonTitles:nil];
                        [closedEyeAlert show];
                    }else{
                        [self blinked];
                        blinkcount++;
                        [count setText:[NSString stringWithFormat:@"Blink : %d",blinkcount]];
                    }
                }
            }else{
                fcount++;
                [facedetected setText:[NSString stringWithFormat:@"Face Detected : NO fcount = %d",fcount]];
                if(fcount>2){
                    [self faceTrackLost];
                }
            }
        });
    }
}

//Gets called when video frame is dropped
- (void) captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        drop++;
        [capdrop setText:[NSString stringWithFormat:@"Capture : %d Drop : %d D/C : %d",capture,drop,(drop/capture)]];
    });
}

//Called when face is not detected for 3 consecutive frames
- (void)faceTrackLost{
    
    //Face track lost, so stopping timer and reseting timer counter
    [timer invalidate];
    tcount = 0;
    
    //Telling the capture methods to stop procssing frames
    detect = FALSE;
    
    //Reseting the faceDetector
    self.faceDetector = nil;
    
    //Can reset all the labels optionally
    
    //Showing alert to user
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                              [NSString stringWithFormat:@"Sorry :("]
                                                        message:@"There was something wrong with face detection."
                                                       delegate:nil
                                              cancelButtonTitle:@"Try again!"
                                              otherButtonTitles:nil];
    [alertView show];
}

//Called when user performs blink
- (void)blinked{
    [timer invalidate];
    detect = FALSE;
    [resultLabel setText:[NSString stringWithFormat:@"You blinked after %d.%d seconds!",tcount/100,tcount%100]];
    
	self.faceDetector = nil;
    
    NSMutableArray *scoreList = [SettingsData getScore];
    
    if(scoreList == Nil){
        scoreList = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    [temp setObject:[SettingsData getDefaultPlayer] forKey:@"name"];
    [temp setObject:[NSNumber numberWithInt:tcount] forKey:@"score"];
    [scoreList addObject:temp];

    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [scoreList sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    
    tcount = 0;

    [SettingsData setScore:scoreList];
    [SettingsData saveData];
}

//Timer's tick method
- (void)increaseTimerCount{
    timerCount.text = [NSString stringWithFormat:@"%d", tcount++];
    [flipNumberView animateToNextNumber];
}

-(IBAction)back:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
