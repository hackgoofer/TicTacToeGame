//
//  ViewController.m
//  TicTacToeObjC
//
//  Created by Sasha Sheng on 5/14/15.
//  Copyright (c) 2015 Sasha Sheng. All rights reserved.
//

// notice all the string might need to be localized
#import "ViewController.h"
#import "Location.h"

static const CGFloat xMarginSeparator = 10.0;
static const CGFloat lineWidth = 2.0;

typedef NS_ENUM(NSUInteger, GameResult) {
    GameResultWin, // yourself
    GameResultTie,
    GameResultOther
};

typedef NS_ENUM(NSUInteger, Player) {
    Player1 = 0,
    Player2
};

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *board;
@property (nonatomic, assign) CGFloat sideLength;

@property (nonatomic, assign) BOOL yourTurn;
@property (nonatomic, assign) NSInteger yourPawnType;

@property (nonatomic, strong) UILabel *status;

@property (nonatomic, strong) NSArray *players;

@property (nonatomic, strong) UIButton *restart;
@property (nonatomic, assign) NSUInteger boardSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.board = [NSMutableArray array];
    
    // We can totally display an alert view and ask the user for a boardsize
    self.boardSize = 3;
    self.sideLength = (self.view.bounds.size.width-2*xMarginSeparator-lineWidth*(self.boardSize-1))/self.boardSize;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.yourPawnType = 1;
    self.status = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-44, CGRectGetWidth(self.view.frame), 44)];
    self.status.text = @"Waiting to Start";
    self.status.textColor = [UIColor whiteColor];
    self.status.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.status];

    self.restart = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44)];
    self.restart.layer.cornerRadius = 2.0;
    self.restart.backgroundColor = [UIColor yellowColor];
    [self.restart addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [self.restart setTitle:@"Restart" forState:UIControlStateNormal];
    [self.restart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.restart];
    
    // could potentially have more users
    self.players = @[@"Player 1", @"Player 2"];
    
    [self setupButtons];
}

- (void)setupButtons
{
    CGFloat xLocation = xMarginSeparator;
    
    for (int i = 0; i < self.boardSize; ++i) {
        NSMutableArray *array = [NSMutableArray array];
        CGFloat yLocation = (self.view.bounds.size.height-self.boardSize*self.sideLength-2*lineWidth)/2;
        
        for (int j = 0; j < self.boardSize; ++j) {
            CGRect rect = CGRectMake(xLocation, yLocation, self.sideLength, self.sideLength);
            Location *aButton = [[Location alloc] initWithFrame:rect];
            aButton.xLocation = i;
            aButton.yLocation = j;
            [aButton.layer setBorderWidth:lineWidth];
            [aButton.layer setBorderColor:[UIColor whiteColor].CGColor];
            [aButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            aButton.pawnType = 0;
            [self.view addSubview:aButton];
            [array addObject:aButton];
            yLocation += (lineWidth + self.sideLength);
        }
        
        xLocation += (lineWidth + self.sideLength);
        [self.board addObject:array];
    }
}

- (void)tapButton:(Location *)button
{
    if (self.yourTurn) {
        if (button.pawnType == 0) {
            button.pawnType = self.yourPawnType;
            self.yourTurn = !self.yourTurn;
            
            [self playPawn:Player1 button:button];
        } else {
            // Product requirement - what do we do there? Alert view to show error?
            NSLog(@"there is already a pawn here!");
        }
    } else {
        if (button.pawnType == 0) {
            button.pawnType = self.opponentPawnType;
            self.yourTurn = !self.yourTurn;
            
            [self playPawn:Player2 button:button];
        } else {
            // Product requirement - what do we do there? Alert view to show error?
            NSLog(@"there is already a pawn here!");
        }
    }
}

- (NSInteger)opponentPawnType
{
    if (self.yourPawnType == 1) {
        return 2;
    } else if (self.yourPawnType == 2) {
        return 1;
    }
    
    return 0;
}

- (void)playPawn:(Player)player button:(Location *)button
{
    GameResult result = [self checkResultWithButton: button];
    if (result == GameResultWin) {
        NSString *statusText = [NSString stringWithFormat:@"%@ has won!", self.players[player]];
        self.status.text = statusText;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:statusText delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Replay!", nil];
        [alert show];
    } else if (result == GameResultOther) {
        self.status.text = [NSString stringWithFormat:@"%@'s turn", self.players[!player]];
    } else if (result == GameResultTie) {
        NSString *statusText = @"You are both really good at this!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay! Tie!" message:statusText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Replay!", nil];
        [alert show];
    }
}

- (GameResult)checkResultWithButton:(Location *)button
{
    NSAssert([button isKindOfClass:Location.class], @"button has to be a Location button");
    
    NSUInteger xLocation = button.xLocation;
    NSUInteger yLocation = button.yLocation;

    NSInteger pawnType = button.pawnType;
    NSLog(@"pawnType: %td", pawnType);
    
    BOOL win = YES;
    
    // check row
    for (int i = 0; i < self.boardSize; ++i) {
        Location *aButton = self.board[xLocation][i];
        if (aButton.pawnType != pawnType) {
            win = NO;
            break;
        }
    }
    if (win) {
        return GameResultWin;
    }
    
    // check col
    win = YES;
    for (int i = 0; i < self.boardSize; ++i) {
        Location *aButton = self.board[i][yLocation];
        if (aButton.pawnType != pawnType) {
            win = NO;
            break;
        }
    }
    if (win) {
        return GameResultWin;
    }
    
    // check diag
    if (button.xLocation == button.yLocation) {
        win = YES;
        for (int i = 0; i < self.boardSize; ++i) {
            Location *aButton = self.board[i][i];
            if (aButton.pawnType != pawnType) {
                win = NO;
                break;
            }
        }
    }
    if (win) {
        return GameResultWin;
    }
    
    for (int i = 0; i < self.boardSize; ++i) {
        for (int j = 0; j < self.boardSize; ++j) {
            Location *aButton = self.board[i][j];
            if (aButton.pawnType == 0) {
                return GameResultOther;
            }
        }
    }
    
    return GameResultTie;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self handleRestart];
    }
}

- (void)restart:(UIButton *)button
{
    [self handleRestart];
}

- (void)handleRestart
{
    for (int i = 0; i < self.boardSize; ++i) {
        for (int j = 0; j < self.boardSize; ++j) {
            Location *aLocation = self.board[i][j];
            [aLocation setPawnType:0];
        }
    }
    
    self.status.text = @"Waiting to restart";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
