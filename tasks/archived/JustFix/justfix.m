function p = justfix(p, state)
% Main trial function for initial fixation training.
%
%
%
% wolf zinke, Apr. 2017

% ####################################################################### %
%% define the task name that will be used to create a sub-structure in the trial struct

if(~exist('state', 'var'))
    state = [];
end

% ####################################################################### %
%% Call standard routines before executing task related code
% This carries out standard routines, mainly in respect to hardware interfacing.
% Be aware that this is done first for each trial state!
p = ND_GeneralTrialRoutines(p, state);

% ####################################################################### %
%% Initial call of this function. Use this to define general settings of the experiment/session.
% Here, default parameters of the pldaps class could be adjusted if needed.
% This part corresponds to the experimental setup file and could be a separate
% file. In this case p.defaultParameters.pldaps.trialFunction needs to be 
% defined here to refer to the file with the actual trial.
% At this stage, p.trial is not yet defined. All assignments need
% to go to p.defaultparameters
if(isempty(state))

    % --------------------------------------------------------------------%
    %% define ascii output file
    % call this after ND_InitSession to be sure that output directory exists!
    Trial2Ascii(p, 'init');

    % --------------------------------------------------------------------%
    %% Color definitions of stuff shown during the trial
    % PLDAPS uses color lookup tables that need to be defined before executing pds.datapixx.init, hence
    % this is a good place to do so. To avoid conflicts with future changes in the set of default
    % colors, use entries later in the lookup table for the definition of task related colors.

    p.trial.task.Color_list = Shuffle({'white', 'red', 'green', 'blue', 'orange', 'yellow', 'cyan', 'magenta'});  
    
    % --------------------------------------------------------------------%
    %% Determine conditions and their sequence
    % define conditions (conditions could be passed to the pldaps call as
    % cell array, or defined here within the main trial function. The
    % control of trials, especially the use of blocks, i.e. the repetition
    % of a defined number of trials per condition, needs to be clarified.

    maxTrials_per_BlockCond = 10;
    maxBlocks = 1000;

    % condition 1
    c1.Nr = 1;
    c1.reward.MinWaitInitial  = 0.05; % min wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c1.reward.MaxWaitInitial  = 0.1;  % max wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c1.reward.InitialRew      = 0.1;  % duration for initial reward pulse
    
    % condition 2
    c2.Nr = 2;
    c2.reward.MinWaitInitial  = 0.1;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c2.reward.MaxWaitInitial  = 0.25; % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c2.reward.InitialRew      = 0.2;  % duration for initial reward pulse

    % condition 3
    c3.Nr = 3;
    c3.reward.MinWaitInitial  = 0.25; % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c3.reward.MaxWaitInitial  = 0.5;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c3.reward.InitialRew      = 0.4;  % duration for initial reward pulse

    % condition 4
    c4.Nr = 4;
    c4.reward.MinWaitInitial  = 0.5;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c4.reward.MaxWaitInitial  = 1.0;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c4.reward.InitialRew      = 0.6;  % duration for initial reward pulse

    % condition 5
    c5.Nr = 5;
    c5.reward.MinWaitInitial  = 1.0;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c5.reward.MaxWaitInitial  = 1.5;  % wait period for initial reward after arriving in FixWin (in s, how long to hold for first reward)
    c5.reward.InitialRew      = 0.8;  % duration for initial reward pulse
    
    
    %conditions = {c2, c3, c4, c5};
    conditions = {c1, c1, c1, c2, c2, c3, c4};

    p = ND_GetConditionList(p, conditions, maxTrials_per_BlockCond, maxBlocks);

else
% ####################################################################### %
%% Subsequent calls during actual trials
% execute trial specific commands here.

    switch state
% ------------------------------------------------------------------------%
% DONE BEFORE MAIN TRIAL LOOP:
        % ----------------------------------------------------------------%
        case p.trial.pldaps.trialStates.trialSetup
        %% trial set-up
        % prepare everything for the trial, including allocation of stimuli
        % and all other more time demanding stuff.
            TaskSetUp(p);
            
        % ----------------------------------------------------------------%
        case p.trial.pldaps.trialStates.trialPrepare
        %% trial preparation
        % just prior to actual trial start, use it for time sensitive preparations;
            p.trial.EV.TrialStart = p.trial.CurTime;
            
% ------------------------------------------------------------------------%
% DONE DURING THE MAIN TRIAL LOOP:
        % ----------------------------------------------------------------%
        case p.trial.pldaps.trialStates.framePrepareDrawing
        %% Get ready to display
        % prepare the stimuli that should be shown, do some required calculations
            if(~isempty(p.trial.LastKeyPress))
                KeyAction(p);
            end
            TaskDesign(p);
            
        % ----------------------------------------------------------------%
        case p.trial.pldaps.trialStates.frameDraw
        %% Display stuff on the screen
        % Just call graphic routines, avoid any computations
            TaskDraw(p)
            
% ------------------------------------------------------------------------%
% DONE AFTER THE MAIN TRIAL LOOP:
        % ----------------------------------------------------------------%
        case p.trial.pldaps.trialStates.trialCleanUpandSave
        %% trial end
            Task_Finish(p);
            Trial2Ascii(p, 'save');
                        
    end  %/ switch state
end  %/  if(nargin == 1) [...] else [...]

% ------------------------------------------------------------------------%
%% Task related functions

% ####################################################################### %
function TaskSetUp(p)
%% main task outline
% Determine everything here that can be specified/calculated before the actual trial start
    p.trial.task.Timing.ITI   = ND_GetITI(p.trial.task.Timing.MinITI,  ...
                                          p.trial.task.Timing.MaxITI,  [], [], 1, 0.10);
                                     
    p.trial.task.CurRewDelay  = ND_GetITI(p.trial.reward.MinWaitInitial,  ...
                                          p.trial.reward.MaxWaitInitial,  [], [], 1, 0.001);

    p.trial.task.InitRewDelay = p.trial.task.CurRewDelay;  
    
    p.trial.CurrEpoch         = p.trial.epoch.TrialStart;
        
    p.trial.reward.Curr  = p.trial.reward.InitialRew; % determine reward amount based on number of previous correct trials
        
    p.trial.task.Good                = 1;  % assume no error until error occurs
    p.trial.reward.cnt          = 0;  % counter for received rewards
    p.trial.behavior.fixation.GotFix = 0;
     
    p.trial.task.FixCol = p.trial.task.Color_list{mod(p.trial.blocks(p.trial.pldaps.iTrial), length(p.trial.task.Color_list))+1};
    
% ####################################################################### %
function TaskDesign(p)
%% main task outline
% The different task stages (i.e. 'epochs') are defined here.
    switch p.trial.CurrEpoch

        case p.trial.epoch.TrialStart
        %% trial starts with onset of fixation spot    
            
            tms = pds.datapixx.strobe(p.trial.event.TASK_ON); 
            p.trial.EV.DPX_TaskOn = tms(1);
            p.trial.EV.TDT_TaskOn = tms(2);

            p.trial.EV.TaskStart = p.trial.CurTime;
            p.trial.EV.TaskStartTime = datestr(now,'HH:MM:SS:FFF');
            
            if(p.trial.datapixx.TTL_trialOn)
                pds.datapixx.TTL(p.trial.datapixx.TTL_trialOnChan, 1);
            end
        
            p.trial.Timer.Wait = p.trial.CurTime + p.trial.task.Timing.WaitFix;
            p.trial.CurrEpoch  = p.trial.epoch.WaitFix;            
            
            p.trial.pldaps.draw.ScreenEvent     = p.trial.event.FIXSPOT_ON;       
            p.trial.pldaps.draw.ScreenEventName = 'FixOn';  
            
        % ----------------------------------------------------------------%
        case p.trial.epoch.WaitFix
        %% Fixation target shown, wait until gaze gets in there
        
            if(p.trial.FixState.Current == p.trial.FixState.FixIn)
            % got fixation
                if(p.trial.behavior.fixation.GotFix == 0) % starts to fixate
                    p.trial.behavior.fixation.GotFix = 1;
                    p.trial.Timer.FixBreak = p.trial.CurTime + p.trial.behavior.fixation.entryTime; % start timer to check if it is robust fixation
                    fprintf('Fix in \n');
                    
                elseif(p.trial.FixState.Current == p.trial.FixState.FixOut)
                    p.trial.behavior.fixation.GotFix = 0;
                    fprintf('Fix out \n');
                    
                elseif(p.trial.CurTime > p.trial.Timer.FixBreak) % long enough within FixWin
                    fprintf('Fixating \n');
                    pds.datapixx.strobe(p.trial.event.FIXATION);

                    p.trial.EV.FixStart = p.trial.CurTime - p.trial.behavior.fixation.entryTime;
                    
                    p.trial.Timer.Wait  = p.trial.CurTime + p.trial.task.Timing.MaxFix;
                    p.trial.CurrEpoch   = p.trial.epoch.Fixating;
                    
                    p.trial.outcome.CurrOutcome = p.trial.outcome.fixation; % at least fixation was achieved
                    
                    p.trial.Timer.Reward = p.trial.CurTime + p.trial.task.CurRewDelay; % timer for initial reward
                    
                    fprintf('initial reward: %.4f \n', p.trial.task.CurRewDelay);
                end
                
            elseif(p.trial.CurTime  > p.trial.Timer.Wait)
            % trial offering ended    
                p.trial.task.Good = 0;
                p.trial.CurrEpoch = p.trial.epoch.TaskEnd;  % Go directly to TaskEnd, do not start task, do not collect reward
                p.trial.outcome.CurrOutcome = p.trial.outcome.NoFix;
                
                p.trial.pldaps.draw.ScreenEvent     = p.trial.event.FIXSPOT_OFF;       
                p.trial.pldaps.draw.ScreenEventName = 'FixOff';  
            end
            
        % ----------------------------------------------------------------%
        case p.trial.epoch.Fixating
        %% Animal maintains fixation 
        
            % check current fixation
            if(p.trial.FixState.Current == p.trial.FixState.FixOut) % fixation break          
                
                if(p.trial.behavior.fixation.GotFix == 1)
                % first time break detected    
                    p.trial.behavior.fixation.GotFix = 0;
                    p.trial.Timer.FixBreak = p.trial.CurTime + p.trial.behavior.fixation.BreakTime;
                    
                elseif(p.trial.FixState.Current == p.trial.FixState.FixIn)
                % gaze returned in time to not be a fixation break
                    p.trial.behavior.fixation.GotFix = 1;

                elseif(p.trial.CurTime > p.trial.Timer.FixBreak)
                % out too long, it's a break    
                    pds.datapixx.strobe(p.trial.event.FIX_BREAK);
                    
                    p.trial.EV.FixBreak = p.trial.CurTime - p.trial.behavior.fixation.BreakTime;
                    p.trial.CurrEpoch   = p.trial.epoch.TaskEnd; % Go directly to TaskEnd, do not continue task, do not collect reward
                    

                    p.trial.pldaps.draw.ScreenEvent     = p.trial.event.FIXSPOT_OFF;       
                    p.trial.pldaps.draw.ScreenEventName = 'FixOff';  
                    
                    if(p.trial.outcome.CurrOutcome ~= p.trial.outcome.Correct)
                        p.trial.outcome.CurrOutcome = p.trial.outcome.FixBreak; % only consider break before first reward
                    end
                    
                    p.trial.task.Good = 0;
                end
            % fixation time expired    
            elseif(p.trial.CurTime  > p.trial.Timer.Wait)
                pds.reward.give(p,  p.trial.reward.JackPot);  % long term fixation, deserves something big
                p.trial.CurrEpoch = p.trial.epoch.TaskEnd;
                
                p.trial.pldaps.draw.ScreenEvent     = p.trial.event.FIXSPOT_OFF;       
                p.trial.pldaps.draw.ScreenEventName = 'FixOff';  
            end
            
            % reward if it is about time
            if(p.trial.task.Good == 1 && p.trial.behavior.fixation.GotFix == 1 && ...
               p.trial.CurTime > p.trial.Timer.Reward)
                
                pds.reward.give(p, p.trial.reward.Curr);
                p.trial.reward.cnt = p.trial.reward.cnt + 1;
                
                rs = find(~(p.trial.reward.Step >= p.trial.reward.cnt), 1, 'last');

                p.trial.Timer.Reward = p.trial.CurTime + p.trial.reward.Dur + p.trial.reward.WaitNext(rs);
                
                fprintf('reward cound: %d  --> next reward: %.4f \n', p.trial.reward.cnt, p.trial.reward.WaitNext(rs));
                
                p.trial.reward.Curr = p.trial.reward.Dur;
            end
            
        % ----------------------------------------------------------------%
        case p.trial.epoch.TaskEnd
        %% finish trial and error handling
            fprintf('TaskEnd \n');
        % set timer for intertrial interval            
            tms = pds.datapixx.strobe(p.trial.event.TASK_OFF); 
            p.trial.EV.DPX_TaskOff = tms(1);
            p.trial.EV.TDT_TaskOff = tms(2);

            p.trial.EV.TaskEnd = p.trial.CurTime;

            if(p.trial.datapixx.TTL_trialOn)
                pds.datapixx.TTL(p.trial.datapixx.TTL_trialOnChan, 0);
            end
            
            if(p.trial.reward.cnt > 0)
                p.trial.outcome.CurrOutcome = p.trial.outcome.Correct; % received a reward, hence correct
            end

            % determine ITI
            if(p.trial.outcome.CurrOutcome ~= p.trial.outcome.Correct)
                p.trial.task.Timing.ITI = p.trial.task.Timing.ITI + p.trial.task.Timing.TimeOut;
            end
            
            p.trial.Timer.Wait = p.trial.CurTime + p.trial.task.Timing.ITI;
            
            p.trial.Timer.ITI  = p.trial.Timer.Wait;
            p.trial.CurrEpoch  = p.trial.epoch.ITI;
        
        % ----------------------------------------------------------------%
        case p.trial.epoch.ITI
        %% inter-trial interval: wait before next trial to start
            Task_WaitITI(p);
            
    end  % switch p.trial.CurrEpoch

% ####################################################################### %
function TaskDraw(p)
%% show epoch dependent stimuli
% go through the task epochs as defined in TaskDesign and draw the stimulus
% content that needs to be shown during this epoch.

    switch p.trial.CurrEpoch
        case {p.trial.epoch.TrialStart, p.trial.epoch.WaitFix, p.trial.epoch.Fixating}
        %% delay before response is needed
            Target(p, p.trial.task.FixCol);
    end
    
% ####################################################################### %
function KeyAction(p)
%% task specific action upon key press
    grdX = p.trial.behavior.fixation.FixGridStp(1);
    grdY = p.trial.behavior.fixation.FixGridStp(2);
    
    fixPos = p.trial.behavior.fixation.fixPos;

    switch p.trial.LastKeyPress(1)

        % grid positions
        case KbName('1')
            fixPos = [-grdX,  -grdY];

        case KbName('2')
            fixPos = [    0,  -grdY];

        case KbName('3')
            fixPos = [ grdX,  -grdY];

        case KbName('4')
            fixPos = [-grdX,     0];

        case KbName('5')
            fixPos = [    0,     0];

        case KbName('6')
            fixPos = [ grdX,    0];

        case KbName('7')
            fixPos = [-grdX, grdY];

        case KbName('8')
            fixPos = [    0, grdY];

        case KbName('9')
            fixPos = [ grdX, grdY];

        % steps
        case KbName('RightArrow')
            fixPos(1) = fixPos(1) + p.trial.behavior.fixation.FixWinStp;   
        case KbName('LeftArrow')
            fixPos(1) = fixPos(1) - p.trial.behavior.fixation.FixWinStp;
        case KbName('UpArrow')
            fixPos(2) = fixPos(2) + p.trial.behavior.fixation.FixWinStp;
        case KbName('DownArrow')
            fixPos(2) = fixPos(2) - p.trial.behavior.fixation.FixWinStp;
            
        % Center fixation (define zero)
        case KbName('z')
        % Center fixation (define zero)
        % set current eye position as expected fixation position

            % use a median for recent samples in order to be more robust and not biased by shot noise
            cX = prctile(p.trial.eyeX_hist(1:p.trial.behavior.fixation.NumSmplCtr), 50);
            cY = prctile(p.trial.eyeY_hist(1:p.trial.behavior.fixation.NumSmplCtr), 50);

            p.trial.behavior.fixation.PrevOffset = p.trial.eyeCalib.offset;

            p.trial.eyeCalib.offset    = p.trial.eyeCalib.offset + fixPos - [cX,cY]; 

            fprintf('\n >>> fixation offset changed to [%.4f; %.4f] -- current eye position: [%.4f; %.4f]\n\n', ...
                     p.trial.eyeCalib.offset, cX,cY);
            
        case KbName('BackSpace')
        % update calibration with current eye positions    
            p.trial.eyeCalib.offset = p.trial.behavior.fixation.PrevOffset;
            
    end
    
    if(any((p.trial.behavior.fixation.fixPos == fixPos) == 0))
        p.trial.behavior.fixation.fixPos = fixPos;
        MoveFix(p);
        pds.fixation.move(p);
    end

% ####################################################################### %
function MoveFix(p)
%% displace fixation window and fixation target
p.trial.task.fixrect    = ND_GetRect(p.trial.behavior.fixation.fixPos, ...
                                     p.trial.behavior.fixation.FixWin);  
% target item
p.trial.task.TargetPos  = p.trial.behavior.fixation.fixPos;   % Stimulus diameter in dva

% get dva values into psychtoolbox pixel values/coordinates
p.trial.task.TargetPos  = p.trial.behavior.fixation.fixPos;
p.trial.task.TargetRect = ND_GetRect(p.trial.task.TargetPos, p.trial.task.TargetSz);

% ####################################################################### %
%% additional inline functions that
% ####################################################################### %

% ####################################################################### %
function Target(p, colstate)
%% show the target item with the given color
    Screen('FillOval',  p.trial.display.overlayptr, p.trial.display.clut.(colstate), p.trial.task.TargetRect);

% ####################################################################### %
function Trial2Ascii(p, act)
%% Save trial progress in an ASCII table
% 'init' creates the file with a header defining all columns
% 'save' adds a line with the information for the current trial
%
% make sure that number of header names is the same as the number of entries
% to write, also that the position matches.

    switch act
        case 'init'
            tblptr = fopen(p.trial.session.asciitbl , 'w');

            fprintf(tblptr, ['Date  Time  Secs  Subject  Experiment  Tcnt  Cond  Tstart  FixRT  ', ...
                             'FirstReward  RewCnt  Result  Outcome  FixPeriod  FixColor  ITI  ',   ...
                             'FixWin  fixPos_X  fixPos_Y  FixOn  FixOff\n']);
            fclose(tblptr);

        case 'save'
            if(p.trial.pldaps.quit == 0 && p.trial.outcome.CurrOutcome ~= p.trial.outcome.NoStart && p.trial.outcome.CurrOutcome ~= p.trial.outcome.NoFix)  % we might loose the last trial when pressing esc.
                                
                trltm = p.trial.EV.TaskStart - p.trial.timing.datapixxSessionStart;

                cOutCome = p.trial.outcome.codenames{p.trial.outcome.codes == p.trial.outcome.CurrOutcome};

                tblptr = fopen(p.trial.session.asciitbl, 'a');

                fprintf(tblptr, '%s  %s  %.4f  %s  %s  %d  %d  %.5f  %.5f  %.5f  %d  %d  %s  %.5f  %s  %.5f  %.2f  %.2f  %.2f  %.2f  %.2f \n' , ...
                                datestr(p.trial.session.initTime,'yyyy_mm_dd'), p.trial.EV.TaskStartTime, ...
                                p.trial.EV.DPX_TaskOn, p.trial.session.subject, p.trial.session.experimentSetupFile, ...
                                p.trial.pldaps.iTrial, p.trial.Nr, trltm, p.trial.EV.FixStart-p.trial.EV.TaskStart,  ...
                                p.trial.task.InitRewDelay, p.trial.reward.cnt, p.trial.outcome.CurrOutcome, cOutCome, ...
                                p.trial.EV.FixBreak-p.trial.EV.FixStart, p.trial.task.FixCol, p.trial.task.Timing.ITI, ...
                                p.trial.behavior.fixation.FixWin, p.trial.task.TargetPos(1), p.trial.task.TargetPos(2), ...
                                p.trial.EV.FixOn, p.trial.EV.FixOff);
               fclose(tblptr);
            end
    end
