function p = ND_EventDef(p)
% Defines numeric values for 16 bit codes of trial events
%
% The encodes defined in 'event' will be sent during the course of a trial
% to mark the time when this event happened.
%
% The fields in 'EV' should be used to save the times of these events
% to the pldaps data file.
%
% wolf zinke, Feb. 2017

disp('****************************************************************')
disp('>>>>  ND:  Defining Event Codes <<<<')
disp('****************************************************************')
disp('');

% ------------------------------------------------------------------------%
%% initialize event times as NaN
% This should be used to store times when these events happened (to data
% file or if needed for later use in the task program)

p.defaultParameters.EV.TrialStart  = NaN; % Trial start time
p.defaultParameters.EV.TaskStart   = NaN; % actual task start after animal got ready (i.e. joystick is in released state)
p.defaultParameters.EV.TaskEnd     = NaN; % actual task start after animal got ready (i.e. joystick is in released state)
p.defaultParameters.EV.Initiated   = NaN; % animal intiated the task
p.defaultParameters.EV.GoCue       = NaN; % Onset of Go-signal
p.defaultParameters.EV.Reward      = NaN; % time of reward delivery
p.defaultParameters.EV.StartRT     = NaN; % response time to start trial after active cue
p.defaultParameters.EV.RespRT      = NaN; % reaction time
p.defaultParameters.EV.DPX_TaskOn  = NaN; % Synch time with datapixx for task on
p.defaultParameters.EV.DPX_TaskOff = NaN; % Synch time with datapixx for task off
p.defaultParameters.EV.TDT_TaskOn  = NaN; % Synch time with datapixx for task on
p.defaultParameters.EV.TDT_TaskOff = NaN; % Synch time with datapixx for task off

% if joystick is used for behavior
if(p.defaultParameters.behavior.joystick.use)
    p.defaultParameters.EV.JoyRelease = NaN; % time of joystick release
    p.defaultParameters.EV.JoyPress   = NaN; % Press time to start task
end

% if fixation is used
if(p.defaultParameters.behavior.fixation.use)
    p.defaultParameters.EV.FixStart   = NaN; % start of fixation
    p.defaultParameters.EV.FixBreak   = NaN; % fixation break detected
    p.defaultParameters.EV.Saccade    = NaN; % response saccade detected
end

% ------------------------------------------------------------------------%
%% Task encodes
% it is the responsibility of the person programming tasks to use these encodes
% in a responsible way to keep as much information about the task as possible.

% task markers
p.defaultParameters.event.TASK_ON       = 10;   % start of task (should happen after pldaps encodes a trial start)
p.defaultParameters.event.TASK_OFF      = 11;   % end of task (should happen before pldaps encodes a trial end)
p.defaultParameters.event.TC_CORR       = 1004; % trial complete, correct
p.defaultParameters.event.TC_ERR        = 3010; % trial complete, incorrect
p.defaultParameters.event.NO_TC         = 3011; % trial incomplete

% response related
p.defaultParameters.event.RESP_CORR     = 1110; % correct response occurred
p.defaultParameters.event.RESP_EARLY    = 1111; % early response occurred
p.defaultParameters.event.RESP_PREMAT   = 1112; % premature (early) response occurred, after go signal but too early to be true
p.defaultParameters.event.RESP_FALSE    = 1113; % false response occurred
p.defaultParameters.event.RESP_LATE     = 1114; % late response occurred

% fixation related
p.defaultParameters.event.FIXSPOT_ON    = 110;  % onset of fixation spot
p.defaultParameters.event.FIXSPOT_OFF   = 111;  % offset of fixation spot
p.defaultParameters.event.FIXATION      = 1000; % valid fixation acquired
p.defaultParameters.event.EYE_GO        = 1001; % eye movement required, eye leaves current fixation window
p.defaultParameters.event.TGT_FIX       = 1002; % fixation of target item
p.defaultParameters.event.FIX_BREAK     = 1003; % fixation of target item

% refinement of fixation break times
% ToDo: WZ - need to check what encodes should/need to be used as events and
%            what should be used as outcome encoded in the trial header
p.defaultParameters.event.FIX_BRK_BSL   = 3000; % fixation break during the pre-stimulus period
p.defaultParameters.event.FIX_BRK_CUE   = 3001; % fixation break while the cue is on
p.defaultParameters.event.FIX_BRK_STIM  = 3002; % fixation break during stimulus presentation
p.defaultParameters.event.FIX_BRK_SPEED = 3003;

% separate encode of reward delivered?

% joystick related
p.defaultParameters.event.JOY_PRESS     = 2100;    % joystick press detected
p.defaultParameters.event.JOY_RELEASE   = 2101;    % joystick release detected

% visual stimulus
p.defaultParameters.event.STIM_ON       = 130;     % stimulus onset
p.defaultParameters.event.STIM_CHNG     = 132;     % stimulus change (e.g. dimming)
p.defaultParameters.event.STIM_OFF      = 151;     % stimulus offset

% stimulus movement
p.defaultParameters.event.START_MOVE    = 131;     % movement onset
p.defaultParameters.event.SPEED_UP      = 140;     % movement acceleration
p.defaultParameters.event.SPEED_Down    = 141;     % movement deceleration
p.defaultParameters.event.STOP_MOVE     = 150;     % movement offset

% task cues
p.defaultParameters.event.CUE_ON        = 120;     % onset of cue to select task relevant stimulus
p.defaultParameters.event.CUE_OFF       = 121;     % onset of cue to select task relevant stimulus
p.defaultParameters.event.GOCUE         = 170;     % cue to give a response

% auditory stimulus
p.defaultParameters.event.SOUND_ON      = 180;     % stimulus onset

% stimulations (etc. drug delivery)
p.defaultParameters.event.MICROSTIM     = 666;     % microstimulation pulse onset
p.defaultParameters.event.INJECT        = 667;     % start of pressure injection
p.defaultParameters.event.IONTO         = 668;     % start of iontophoretic drug delivery

% ------------------------------------------------------------------------%
%% System encodes
% encoded by running PLDAPS, can be ignored for task development. These
% events have to be defined otherwise PLDAPS will produce errors!
p.defaultParameters.event.TRIALSTART = 1;         % begin of a trial according to PLDAPS (could differ from task begin)
p.defaultParameters.event.TRIALEND   = 2;         % end of a trial according to PLDAPS (could differ from task end)

p.defaultParameters.event.FIX_IN     = 2000;      % gaze enters fixation window
p.defaultParameters.event.FIX_OUT    = 2001;      % gaze leaves fixation window

p.defaultParameters.event.JOY_ON     = 2110;      % joystick elevation above pressing threshold
p.defaultParameters.event.JOY_OFF    = 2111;      % joystick elevation below releasing threshold

p.defaultParameters.event.PDFLASH    = 2010;      % onset of photo diode flash

% feedback
p.defaultParameters.event.REWARD     = 1005;      % reward delivery, irrespective if earned in task or manually given by experimenter
p.defaultParameters.event.AUDIO_REW  = 1500;

% analog output
p.defaultParameters.event.AO_1       = 2311;
p.defaultParameters.event.AO_2       = 2312;
p.defaultParameters.event.AO_3       = 2313;
p.defaultParameters.event.AO_4       = 2314;

% digital output
p.defaultParameters.event.DO_1       = 2321;
p.defaultParameters.event.DO_2       = 2322;
p.defaultParameters.event.DO_3       = 2323;
p.defaultParameters.event.DO_4       = 2324;
p.defaultParameters.event.DO_5       = 2325;
p.defaultParameters.event.DO_6       = 2326;
p.defaultParameters.event.DO_7       = 2327;
p.defaultParameters.event.DO_8       = 2328;

% marker to select start and end of trial header
p.defaultParameters.event.TRIAL_HDR_ON  = 99001;
p.defaultParameters.event.TRIAL_HDR_OFF = 99000;

% TODO: encode trial states (and task epochs)?

%% task/stimulus parameters (NIY!)
% #define	X_RF			5000
% # define Y_RF		     	5100
% #define	DIR_TGT_BASE	6000
% #define	COND_NUM_BASE	7000
% #define	UNCUE_TRL		8000
% #define	CUE_TRL			8100
