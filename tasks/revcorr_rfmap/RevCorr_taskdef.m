function p = RevCorr_taskdef(p)
% define task parameters for the joystick training task.
% This function will be executed at every trial start, hence it is possible
% to edit it while the experiment is in progress in order to apply online
% modifications of the task.
%
% TODO: - Make sure that changed parameters are kept in the data file, i.e.
%         that there is some log when changes happened
%       - read in only changes in order to allow quicker manipulations via the
%         keyboard without overwriting it every time by calling this routine
%
%
% wolf zinke, Dec. 2016

% ------------------------------------------------------------------------%
%% Condition/Block design
p.trial.task.EqualCorrect = 0; % if set to one, trials within a block are repeated until the same number of correct trials is obtained for all conditions

% ------------------------------------------------------------------------%
%% Reward

% manual reward from experimenter
p.trial.reward.ManDur = 0.05;         % reward duration [s] for reward given by keyboard presses

p.trial.reward.Dur    = 0.05;         % Reward given after each complete stim presentation

p.trial.reward.jackpotDur = 0.3;     % Reward for holding fixation until jackpotTime
p.trial.reward.IncrConsecutive = 1;  % use rewarding scheme that gives more rewards with subsequent correct trials
p.trial.reward.nPulse          = 2;  % number of reward pulses
p.trial.reward.PulseStep       = [2, 3, 4, 5]; % increase number of pulses with this trial number

% ------------------------------------------------------------------------%
%% Timing
p.trial.task.Timing.WaitFix = 2;    % Time to wait for fixation before NoStart

% Main trial timings
p.trial.task.fixLatency       = 0.15; % Time to hold fixation before mapping begins


p.trial.task.stimOnTime       = 0.1;   % How long each stimulus is presented
p.trial.task.stimOffTime      = 0.1;     % Gaps between succesive stimuli

p.trial.task.jackpotTime      = 3;     % How long stimuli are presented before trial ends and jackpot is given

% inter-trial interval
p.trial.task.Timing.MinITI  = 1.0;  % minimum time period [s] between subsequent trials
p.trial.task.Timing.MaxITI  = 2.5;  % maximum time period [s] between subsequent trials

% penalties
p.trial.task.Timing.TimeOut =  0;   % Time [s] out for incorrect responses

% ------------------------------------------------------------------------%
%% RF mapping parameters
p.trial.RF.spatialRes  = 50;  % Number sections to subdivide the possible visual space into
p.trial.RF.maxHistory  = 0.5; % How long before each spike to calculate the reverse correlation
p.trial.RF.temporalRes = 25;  % Number of sections to divide the history into for analysis

% ------------------------------------------------------------------------%
%% fixation spot parameters
p.trial.stim.FIXSPOT.pos    = [0,0];
p.trial.stim.FIXSPOT.type   = 'disc';     % shape of fixation target, options implemented atm are 'disc' and 'rect', or 'off'
p.trial.stim.FIXSPOT.color  = 'dRed';  % color of fixation spot (as defined in the lookup tables)
p.trial.stim.FIXSPOT.size   = 0.15;        % size of the fixation spot
p.trial.stim.FIXSPOT.fixWin = 2.5;

% ------------------------------------------------------------------------%
%% Grating stimuli parameters
p.trial.stim.GRATING.res          = 300;
p.trial.stim.GRATING.fixWin       = 0;

% Will use a grid based layout to display the stimuli
p.trial.stim.coarse.xRange = [-10, -2];
p.trial.stim.coarse.yRange = [-10, -2];
p.trial.stim.coarse.grdStp = 1;

p.trial.stim.fine.xRange = [-7, -4];
p.trial.stim.fine.yRange = [-7, -4];
p.trial.stim.fine.grdStp = 0.5;


% For the following parameters, an array can be specified and all possible combinations
% will be tested.

p.trial.stim.coarse.angle    = [0, 90];
p.trial.stim.fine.angle      = [0, 22.5, 45, 67.5, 90, 112.5, 135, 157.5];   

p.trial.stim.coarse.radius   = 0.75;
p.trial.stim.fine.radius     = 0.75;

% spatial frequency (cycles per degree)
p.trial.stim.coarse.sFreq    = 1.5;
p.trial.stim.fine.sFreq      = 1.5;

% temporal frequency (cycles per second, 0 is stationary)
p.trial.stim.coarse.tFreq    = 0;
p.trial.stim.fine.tFreq      = 0;

% contrast
p.trial.stim.coarse.contrast = 1;
p.trial.stim.fine.contrast   = 1;

% ------------------------------------------------------------------------%
%% Fixation parameters

p.trial.behavior.fixation.BreakTime = 0.050;  % minimum time [ms] to identify a fixation break
p.trial.behavior.fixation.entryTime = 0.150;  % minimum time to stay within fixation window to detect initial fixation start

% ------------------------------------------------------------------------%
%% Task parameters
p.trial.task.breakFixCheck = 0.2; % Time after a stimbreak where if task is marked early or stim break is calculated

% ------------------------------------------------------------------------%
%% Trial duration
% maxTrialLength is used to pre-allocate memory at several initialization
% steps. It specifies a duration in seconds.

p.trial.pldaps.maxTrialLength = 15;
