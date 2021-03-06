//
//  ParticleUserForgotPasswordViewController.h
//  teacup-ios-app
//
//  Created by Ido on 2/13/15.
//  Copyright (c) 2015 particle. All rights reserved.
//

#import "ParticleSetupUIViewController.h"
#import "ParticleUserLoginViewController.h"

@interface ParticleUserMFAViewController : ParticleSetupUIViewController

@property (nonatomic, strong) id<ParticleUserLoginDelegate> delegate;

@property (nonatomic, strong) NSString *mfaToken;
@property (nonatomic, strong) NSString *username;

@end
