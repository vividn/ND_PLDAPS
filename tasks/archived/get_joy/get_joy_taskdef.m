function p = get_joy_taskdef(p)
% define task parameters for the joystick training task.
% This function will be executed at every trial start, hence it is possible
% to edit it while the experiment is in progress in order to apply online
% modifications of the task.
%
% TODO: - Make sure that changed parameters are kept in the data file, i.e.
%         that there is some log when changes happened
%
%
% wolf zinke, Feb. 2016

% ------------------------------------------------------------------------%
%% Condition/Block design
p.trial.task.EqualCorrect = 0; % if set to one, trials within a block are repeated until the same number of correct trials is obtained for all conditions

% ------------------------------------------------------------------------%
%% Reward
p.trial.reward.Pull    = 0;          % If 1 then give reward for pulling the joystick
p.trial.reward.PullRew = 0.05;        % reward amount for pulling joystick (if p.trial.reward.Pull == 1)

p.trial.reward.RewTrain  =   1;      % give a series of rewards during hold time
p.trial.reward.TrainRew  = 0.25;      % reward amount for during the burst train (if p.trial.reward.RewTrain == 1)
p.trial.reward.RewGapMin = 0.25;     % spacing between subsequent reward pulses
p.trial.reward.RewGapMax = 1.0;     % spacing between subsequent reward pulses
p.trial.reward.Timer     = NaN;      % initialize timer to control subsequent rewards

p.trial.reward.IncrConsecutive = 0;  % increase reward for subsequent correct trials. Otherwise reward will increase with the number of hits
p.trial.reward.Dur  = [0.65, 0.75];   % reward duration [s], user vector to specify values used for incremental reward scheme
p.trial.reward.Step = [2, 4];        % define the number of trials when to increase reward. Vector length can not be longer than p.trial.reward.Dur

p.trial.reward.ManDur = 0.2;         % reward duration [s] for reward given by keyboard presses

% ------------------------------------------------------------------------%
%% Task Timings
p.trial.task.Timing.WaitStart   = 2.50;  % maximal time period [s] in seconds to press the lever in order to start a trial.
p.trial.task.Timing.WaitResp    = 2.50;  % Only response times [s] after this wait period will be considered stimulus driven responses

p.trial.task.Timing.minRT       = 0.15;  % If a response occurs prior this time it is considered an early response
p.trial.task.Timing.MinRel      = 0.75;    % minimum time to consider a bar released prior trial start

% inter-trial interval
p.trial.task.Timing.MinITI      = 0.25;    % minimum time period [s] between subsequent trials
p.trial.task.Timing.MaxITI      =  1.5;    % maximum time period [s] between subsequent trials

% penalties
p.trial.task.Timing.TimeOut     =  0;     % Time [s] out for incorrect responses
p.trial.task.Timing.PullTimeOut =  0;     % Minimum time [s] passed before a trial starts after random lever presses (NIY!)

% ------------------------------------------------------------------------%
%% Stimulus parameters

% Frame indicating active trial
p.trial.task.FrameWdth  = 0.25; % hard-coded for now, make it more flexible
p.trial.task.FrameSize  = [18, 18]; % hard-coded for now, make it more flexible

p.trial.task.FrameRect  = ND_GetRect([0,0], p.trial.task.FrameSize);

% target item
p.trial.task.TargetSz   = 4;          % Stimulus diameter in dva
p.trial.task.TargetPos  = [0, 0];     % Stimulus diameter in dva25seconds

p.trial.task.TargetRect = ND_GetRect(p.trial.task.TargetPos, p.trial.task.TargetSz);

% ------------------------------------------------------------------------%
%% Joystick parameters
p.trial.behavior.joystick.use     = 1;    % Use the joystick
p.trial.behavior.joystick.PullThr = 1.5;  % threshold to detect a joystick press
p.trial.behavior.joystick.RelThr  = 1.0;  % threshold to detect a joystick release

% ------------------------------------------------------------------------%
%% Trial duration
% maxTrialLength is used to pre-allocate memory at several initialization
% steps. It specifies a duration in seconds.
p.trial.pldaps.maxTrialLength = 60; % this parameter is used to pre-allocate memory at several initialization steps. Unclear yet, how this terminates the experiment if this number is reached.
