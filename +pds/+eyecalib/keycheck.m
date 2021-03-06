function p = keycheck(p)
% pds.eyecalib.keycheck(p) check keyboard for calibrationb relevant presses
% information about eye positions
%
% wolf zinke, april 2017

if(~isempty(p.trial.LastKeyPress))
    
    switch p.trial.LastKeyPress(1)
        
        case p.trial.key.addCalibPoint
            %% accept current fixation
            if(p.trial.behavior.fixation.enableCalib)
                iCalib = size(p.trial.eyeCalib.rawEye, 1) + 1;
                
                % Position of the fixation target
                fixPos = p.trial.behavior.fixation.fix.pos;
                          
                if ~p.trial.mouse.useAsEyepos
                    % Raw eye analog signal. Gets the median X and Y values over a
                    % range of samples to get a better estimate
                    sampleRange = (p.trial.datapixx.adc.dataSampleCount - p.trial.behavior.fixation.calibSamples + 1) : p.trial.datapixx.adc.dataSampleCount;
                    rawEye = [prctile(p.trial.AI.Eye.X(sampleRange), 50)  prctile(p.trial.AI.Eye.Y(sampleRange), 50)];
                else 
                    % Use the mouse coordinates as the raw eye signal
                    iSample = p.trial.mouse.samples;
                    rawEye = p.trial.mouse.cursorSamples(:, iSample);
                end
                
                % Add these samples to the list of calibration points,
                % which will be processed in pds.eyecalib.update
                p.trial.eyeCalib.fixPos(iCalib,:) = fixPos;
                p.trial.eyeCalib.rawEye(iCalib,:) = rawEye;
                
                pds.eyecalib.update(p);
            end
            
            % ----------------------------------------------------------------%
        case p.trial.key.wipeCalibPos
            %% Wipe the calibration points at the current fixPos
            
            % Load from the p struct
            curFixPos = p.trial.behavior.fixation.fix.pos;
            fixPos = p.trial.eyeCalib.fixPos;
            rawEye = p.trial.eyeCalib.rawEye;
            
            % Find the calibration points taken at the current fix position
            wipeRows = ismember(fixPos,curFixPos,'rows');
            
            % Remove those rows
            fixPos(wipeRows,:) = [];
            rawEye(wipeRows,:) = [];
            
            % Save to the p struct
            p.trial.eyeCalib.fixPos = fixPos;
            p.trial.eyeCalib.rawEye = rawEye;
            
            pds.eyecalib.update(p);
            % ----------------------------------------------------------------%
        case p.trial.key.resetCalib
            %% Clear the calibration matrix and reset to default values
            pds.eyecalib.reset(p);
            
            % ----------------------------------------------------------------%
        case p.trial.key.rmLastCalib
            %% Remove the last calibration point from the calculation
            if(p.trial.behavior.fixation.enableCalib)
                
                if size(p.trial.eyeCalib.rawEye,1) <= 1
                    % Reset to defualts if removing one would completely clear
                    % all calibration points
                    pds.eyecalib.reset(p)
                else
                    p.trial.eyeCalib.rawEye = p.trial.eyeCalib.rawEye(1:end-1,:);
                    p.trial.eyeCalib.fixPos = p.trial.eyeCalib.fixPos(1:end-1,:);
                    pds.eyecalib.update(p);
                end
                
            end
            
            % ----------------------------------------------------------------%
        
        %% Tweaking parameters
        case p.trial.key.offsetTweak
            % Toggle between xOffset, yOffset, and off
            switch p.trial.behavior.fixation.calibTweakMode
                case 'xOffset'
                    p.trial.behavior.fixation.calibTweakMode = 'yOffset';
                    disp('tweakMode = yOffset');
                    
                case 'yOffset'
                    p.trial.behavior.fixation.calibTweakMode = 'off';
                    disp('tweakMode = off');
                    
                otherwise
                    p.trial.behavior.fixation.calibTweakMode = 'xOffset';
                    disp('tweakMode = xOffset');
            end
            
            % ----------------------------------------------------------------%
        case p.trial.key.gainTweak
            % Toggle between xGain, yGain, and off
            switch p.trial.behavior.fixation.calibTweakMode
                case 'xGain'
                    p.trial.behavior.fixation.calibTweakMode = 'yGain';
                    disp('tweakMode = yGain');
                    
                case 'yGain'
                    p.trial.behavior.fixation.calibTweakMode = 'off';
                    disp('tweakMode = off');
                    
                otherwise
                    p.trial.behavior.fixation.calibTweakMode = 'xGain';
                    disp('tweakMode = xGain');
            end
            
            % ----------------------------------------------------------------%
        case p.trial.key.tweakUp
            % Tweak parameters based on calibTweakMode
            switch p.trial.behavior.fixation.calibTweakMode
                case 'xOffset'
                    % Tweaking by dva, so need to know gain first
                    xGain = p.trial.eyeCalib.gain(1);
                    
                    tweakVar  = 'offsetTweak';
                    tweakInd  = 1;
                    tweakSize = p.trial.behavior.fixation.offsetTweakSize / xGain;
                    
                 case 'yOffset'
                    % Tweaking by dva, so need to know gain first
                    yGain = p.trial.eyeCalib.gain(2);
                    
                    tweakVar  = 'offsetTweak';
                    tweakInd  = 2;
                    tweakSize = p.trial.behavior.fixation.offsetTweakSize / yGain;
                    
                case 'xGain'                    
                    tweakVar  = 'gainTweak';
                    tweakInd  = 1;
                    tweakSize = p.trial.behavior.fixation.gainTweakSize;
                    
                case  'yGain'                   
                    tweakVar  = 'gainTweak';
                    tweakInd  = 2;
                    tweakSize = p.trial.behavior.fixation.gainTweakSize;
                    
                case 'off'
                    % Don't do anything
                    tweakVar = '';
                    
                otherwise
                    warning('Bad tweak mode');
            end
            
            % Now apply the tweak
            if ~isempty(tweakVar)
                tweakVal = p.trial.eyeCalib.(tweakVar);
                tweakVal(tweakInd) = tweakVal(tweakInd) + tweakSize;
                p.trial.eyeCalib.(tweakVar) = tweakVal;
                pds.eyecalib.update(p);
            end
            
            % ----------------------------------------------------------------%
        case p.trial.key.tweakDown
            % Tweak parameters based on calibTweakMode
            switch p.trial.behavior.fixation.calibTweakMode
                case 'xOffset'
                    % Tweaking by dva, so need to know gain first
                    xGain = p.trial.eyeCalib.gain(1);
                    
                    tweakVar  = 'offsetTweak';
                    tweakInd  = 1;
                    tweakSize = -p.trial.behavior.fixation.offsetTweakSize / xGain;
                    
                 case 'yOffset'
                    % Tweaking by dva, so need to know gain first
                    yGain = p.trial.eyeCalib.gain(2);
                    
                    tweakVar  = 'offsetTweak';
                    tweakInd  = 2;
                    tweakSize = -p.trial.behavior.fixation.offsetTweakSize / yGain;
                    
                case 'xGain'                    
                    tweakVar  = 'gainTweak';
                    tweakInd  = 1;
                    tweakSize = -p.trial.behavior.fixation.gainTweakSize;
                    
                case  'yGain'                   
                    tweakVar  = 'gainTweak';
                    tweakInd  = 2;
                    tweakSize = -p.trial.behavior.fixation.gainTweakSize;
                    
                case 'off'
                    % Don't do anything
                    tweakVar = '';
                    
                otherwise
                    warning('Bad tweak mode');
            end
            
            % Now apply the tweak
            if ~isempty(tweakVar)
                tweakVal = p.trial.eyeCalib.(tweakVar);
                tweakVal(tweakInd) = tweakVal(tweakInd) + tweakSize;
                p.trial.eyeCalib.(tweakVar) = tweakVal;
                pds.eyecalib.update(p);
            end
    end
    
    
end
