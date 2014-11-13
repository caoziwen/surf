//
//  commonHelper.m
//  ours
//
//  Created by Cao Ziwen on 10/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "commonHelper.h"
#import "Cliff.h"
#import "Shark.h"

extern Shark* globalshark;
extern OALSimpleAudio* globalaudio;
@implementation commonHelper

+(bool) Collision:(CCNode *) A B:(CCNode *)B
{
    CGPoint PosA=[A convertToWorldSpaceAR: A.position];
    CGPoint PosB=[B convertToWorldSpaceAR:B.position];
    CGSize SizeA={A.contentSize.width*A.scaleX,A.contentSize.height*A.scaleY};
    CGSize SizeB={B.contentSize.width*B.scaleX,B.contentSize.height*B.scaleY};
    CGRect RectA={PosA,SizeA};
    CGRect RectB={PosB,SizeB};
    return CGRectIntersectsRect(RectA, RectB);
}

+(bool) Collision:(CCNode *) A B:(CCNode *)B level:(CCNode*)_Level
{
    CGPoint PosA=A.position;
    CGPoint PosB;
    PosB.x=B.position.x+_Level.position.x;
    PosB.y=B.position.y+_Level.position.y;
    CGSize SizeA={A.contentSize.width*A.scaleX,A.contentSize.height*A.scaleY};
    CGSize SizeB={B.contentSize.width*B.scaleX,B.contentSize.height*B.scaleY};
    CGRect RectA={PosA,SizeA};
    CGRect RectB={PosB,SizeB};
    return CGRectIntersectsRect(RectA, RectB);
}

//+(bool) ISAONB:(CCNode *) A B:(CCNode *)B
//{
//    CGPoint PosA=[A convertToWorldSpaceAR: A.position];
//    CGPoint PosB=[B convertToWorldSpaceAR:B.position];
//    //CGSize SizeA={A.contentSize.width*A.scaleX,A.contentSize.height*A.scaleY};
//    //CGSize SizeB={B.contentSize.width*B.scaleX,B.contentSize.height*B.scaleY};
//    //CGRect RectA={PosA,SizeA};
//    //CGRect RectB={PosB,SizeB};
//    if(PosA.y<PosB.y)
//        return false;
//    return true;
//}

+(CCParticleSystem*) particle:(NSString*) path
{
    CCParticleSystem* hit=(CCParticleSystem*)[CCBReader load:path];
    hit.autoRemoveOnFinish=TRUE;
    return hit;
}

+(void) CheckCollision:(CCNode*) _Levels Player:(Player*) _Player;
{
    NSArray* All=[_Levels children];
    for(int i=0;i<[All count];i++)
    {
        CCNode* this_i=(CCNode*)All[i];
        if([self Collision:_Player B:All[i] level:_Levels])
        {
            //NSLog(@"Peng Peng with %@",((CCNode*)All[i]).name);
            if([this_i.name isEqualToString:@"Monster"])
            {
                int Case=[_Player knockout];
                if(Case==0)
                {
                    [this_i removeFromParent];
                    CCParticleSystem* monsterhit=[self particle:@"Particle/hitstar"];
                    monsterhit.position=ccpAdd(_Player.position,ccp(20,20));
                    [[_Player parent]addChild:monsterhit];
                }
                else if(Case==1)
                {
                    [globalshark showup];
                }
                else
                    [globalshark bite];
                this_i.name=@"XXXX";
                break;
            }
            if([this_i.name isEqual:@"Cliff"])
            {
                int Case=[_Player knockout];
                if(Case==0)
                {
                    [this_i removeFromParent];
                    CCParticleSystem* cliffhit=[self particle:@"Particle/hitcliff"];
                    cliffhit.position=ccpAdd(_Player.position,ccp(20,20));
                    [[_Player parent]addChild:cliffhit];
                }
                else
                {
                    [((Cliff*)this_i) hitplayer];
                    if(Case==1) [globalshark showup];
                    else
                        [globalshark bite];
                }
                this_i.name=@"XXXX";
                break;
            }
            if([this_i.name isEqual:@"Star"])
            {
                
                CCParticleSystem* starhit=[self particle:@"Particle/hitstar"];
                starhit.position=ccpAdd(_Player.position,ccp(20,20));
                [[_Player parent]addChild:starhit];
                [globalaudio playEffect:@"hitStar.wav"];
                [_Player eatstars];
                [(CCNode*)All[i] removeFromParent];
                break;
            }
            if([this_i.name isEqual:@"Fish"])
            {
                // check position
                if(this_i.position.y<_Player.position.y)
                {
                    [this_i removeFromParent];
                    [_Player Rushfish];
                }
                else
                {
                    BOOL Case=[_Player hitbyfish];
                    if(!Case)
                    {
                        [this_i removeFromParent];
                    }
                }
                break;
            }
            
        }
    }
    
}


@end
