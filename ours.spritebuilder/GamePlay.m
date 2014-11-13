//
//  GamePlay.m
//  ours
//
//  Created by Dante Fan on 10/18/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "Player.h"
#import "Gameover.h"
#import "Cliff.h"
#import "Shark.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "commonHelper.h"

Shark* globalshark;
Player* globalplayer;
OALSimpleAudio *globalaudio;
CCButton* globalrush;
NSString* deadcause;
unsigned long int scores=0;

@implementation GamePlay
{
    CCPhysicsNode *_phynode;
    CCNode* _Levels,*_levelnode;
    float _velocity;
    Player* _player;
    CCNode* _bgnode;
    CCSprite *lifebar;
    Shark* _gameshark;
    CCButton* _brush;
    
    OALSimpleAudio *audio;
    //NSArray* _AllChildren;
    
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    _Levels=[CCBReader load:@"Levels/Level0"];
    _velocity=3;
    //_phynode.debugDraw = YES;
    //lifebar.scaleX=200;
    [_levelnode addChild:_Levels];
    globalshark=_gameshark;
    globalplayer=_player;
    globalrush=_brush;
    _brush.enabled=NO;
    _gameshark.opacity=0.0;
    //audio
    audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"bgMusic5.mp3" loop:TRUE];
    [audio preloadEffect:@"shark.wav"];
    [audio preloadEffect:@"jump1.wav"];
    [audio preloadEffect:@"rush.mp3"];
    [audio preloadEffect:@"Lose.mp3"];
    [audio preloadEffect:@"hitStar.wav"];
    globalaudio=audio;
    lifebar=[CCSprite spriteWithImageNamed:@"characterpics/lifebar.png"];
    [self addChild:lifebar];
    lifebar.position=ccp(240,300);
    lifebar.scaleX=80;
    lifebar.scaleY=0.3;
    
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(Paused)
    {
        [_player.physicsBody applyImpulse:ccp(0,10000.f)];
        [_player jumpRise];
    }
}

-(void) rush
{
    if(Paused)
        [_player Rushnofish];
}

- (void)retry {
    // reload this level
    if(!Paused)
        [self pause];
    [audio stopAllEffects];
    [[CCDirector sharedDirector]replaceScene:[CCBReader loadAsScene:@"Scences/GamePlay"]];
}


bool Paused=true;

-(void)pause{
    
    //CCScene * pauseScene = [CCBReader loadAsScene:@"PauseScene"];
    Paused=!Paused;
    if(Paused)
        [[CCDirector sharedDirector] startAnimation];
    else
        [[CCDirector sharedDirector] stopAnimation];
    //[[CCDirector sharedDirector] pushScene:pauseScene];
}


- (int)Gameover
{
    scores=_player.score/50;
    [_player die:self withSelector:@selector(finish)];
    return 0;
    
}

-(void)finish
{
    GameOver *gameplayScene =(GameOver*)[CCBReader loadAsScene:@"Scences/GameOver"];
    [[CCDirector sharedDirector]replaceScene:(CCScene*)gameplayScene];

}



- (void)update:(CCTime)delta
{
    if(_player.life>0)
    {
        if(_bgnode.position.x<=-390)
            _bgnode.position=ccp(0, 0);
        id con2=[CCActionMoveBy actionWithDuration:delta position:ccp(-_player.velocity,0)];
        id con=[CCActionMoveBy actionWithDuration:delta position:ccp(-_velocity,0)];
        [_bgnode runAction:con];
        [_Levels runAction:con2];
        //[_lvlhlp check_stars:_player Level:_levels];
        
        [commonHelper CheckCollision:_Levels Player:_player];
        lifebar.scaleX=_player.life*0.4;
        _player.score++;
    }
    else
        [self Gameover];
    return;
}

- (void) Pause
{
    
}

@end


