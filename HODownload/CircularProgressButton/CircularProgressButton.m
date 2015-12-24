
#import "CircularProgressButton.h"

@interface CircularProgressButton ()

//@property (nonatomic) NSTimer *timer;
//@property (nonatomic) AVAudioPlayer *player;//an AVAudioPlayer instance

@property (assign, nonatomic) CGFloat angle;//angle between two lines

@end

@implementation CircularProgressButton

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
////    if (self.delegate && [self.delegate respondsToSelector:@selector(updateProgressViewWithProgress:)]) {
////        [self.delegate updateProgressViewWithProgress:self.progress];
////    }
}

- (void)initButton
{
    UIImage *imgPause = [UIImage imageNamed:@"file_pause_normal.png"];
    UIImage *imgDown =[UIImage imageNamed:@"file_download_normal.png"];
    [self setBackgroundImage:imgPause forState:UIControlStateNormal];
    [self setBackgroundImage:imgDown  forState:UIControlStateSelected];
    self.progressColor = [UIColor blueColor];
    self.lineWidth = 2;
    self.backColor = [UIColor lightGrayColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
                                                              radius:(CGRectGetWidth(self.bounds) - self.lineWidth ) / 2
                                                          startAngle:(CGFloat) - M_PI_2
                                                            endAngle:(CGFloat)(1.5 * M_PI)
                                                           clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle stroke];
    
    if (self.progress) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                                      radius:(CGRectGetWidth(self.bounds) - self.lineWidth ) / 2
                                                                  startAngle:(CGFloat) - M_PI_2
                                                                    endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                                   clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        [progressCircle stroke];
    }
}

@end
