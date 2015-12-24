
#import <UIKit/UIKit.h>

@protocol CircularProgressButtonDelegate <NSObject>

@optional

- (void)updateProgressViewWithProgress:(float)progress;

@end

@interface CircularProgressButton : UIButton
@property (nonatomic) float progress;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) id <CircularProgressButtonDelegate> delegate;

- (void)setProgress:(float)progress;
- (void)initButton;

@end