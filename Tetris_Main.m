%% Tetris for MATLAB
%Authors: 
% 1: lp18692 (2022). Tetris for MATLAB 
% (https://www.mathworks.com/matlabcentral/fileexchange/78501-tetris-for-matlab),
% MATLAB Central File Exchange. Retrieved March 30, 2022.
% 2: Cody Watson, 108988282
% See options below. Press F5 to play.
clear
close all
clc
beep off

%%
% Randomize The Game difficuly and files played
rng('shuffle');
Game_Difficulty_Order = randperm(4);
easy_6_used = false;
hard_6_used = false;
audio_index = 1;
Audio_File_Order = zeros([1 5]);
%Begin training script
wide_trial = 1;
while wide_trial < 7
fprintf('------------- \n')
fprintf('------------- \n\n')

%% Define Trial s
trial_order=[1,1:4];
list = cell(1,1);

%%
%Updating the set of completed trials
if wide_trial == 1
training_done = 0;
trials_completed = [0, 0, 0, 0];

elseif wide_trial == 2
training_done = 1;
trials_completed = [0, 0, 0, 0];

elseif wide_trial == 3
training_done = 1;
trials_completed = [1, 0, 0, 0];

elseif wide_trial == 4
training_done = 1;
trials_completed = [1, 1, 0, 0];

elseif wide_trial == 5
training_done = 1;
trials_completed = [1, 1, 1, 0];
end

% Make dialog box
line = 1;
% Update dialog box
if training_done == 0
    str = sprintf('Training Game');
    list(line) = {str};
    line = line +1;
else
    for trial = 1:4
        if trials_completed(trial) == 0
            str = sprintf('Trial Game %d',trial);
            list(line) = {str};
            % Set trial_number
            test_trial_num = trial;
            break
        else
            str = sprintf('Trial Game %d [X]',trial);
        end
%         n = n+1;
%         list(n+x) = {str};
    end
end


%%


 
%%   
[trial_num,tf] = listdlg('ListString',list);

if tf == 0
    iquit = 1;
    break
end

%Command line output
if (trial_num <= 1) && (training_done==0) 
    fprintf('Running Training %d...\n\n', trial_num)
    train = true;
else
    fprintf('Running Trial %d...\n\n', test_trial_num)
    train = false;
end

fprintf('Good luck, have fun! Game will start in 5 seconds :) \n\n')
pause(0.1)

startLoop = tic;
Total_Session_Time = 180; %seconds

if train == true
    level = 5;
    [y, Fs] = audioread('6 WPM Training Set.mp3');
    sound(y, Fs, 16);
    audio_file_number = 5;
    test_name = 'Training';
    Total_Session_Time = 60; % Training trial is shorter
else
    
    if test_trial_num == 1
        if Game_Difficulty_Order(1) < 3
            level = 5;            
        else
            level = 10;

        end
        
    elseif test_trial_num == 2
        if Game_Difficulty_Order(2) < 3
            level = 5;
        else
            level = 10;
        end
        
    elseif test_trial_num == 3
        if Game_Difficulty_Order(3) < 3
            level = 5;
        else
            level = 10;
        end
         
    elseif test_trial_num == 4
        
        if Game_Difficulty_Order(4) < 3
            level = 5;
        else
            level = 10;
        end
    end
end


if level == 5 && train == false
    if easy_6_used == false
    [y, Fs] = audioread('6 WPM Set 1.mp3');
    sound(y, Fs, 16);
    easy_6_used = true;
    audio_file_number = 1;
    test_name = 'Alpha';
    else
    [y, Fs] = audioread('12 WPM Set 1.mp3');
    sound(y, Fs, 16);
    audio_file_number = 3;
    test_name = 'Beta';
    end
elseif level == 10
    if hard_6_used == false
    [y, Fs] = audioread('6 WPM Set 2.mp3');
    sound(y, Fs, 16);
    hard_6_used = true; 
    audio_file_number = 2;
    test_name = 'Gamma';
    else
    [y, Fs] = audioread('12 WPM Set 2.mp3');
    sound(y, Fs, 16);
    audio_file_number = 4;
    test_name = 'Delta';
    end
end

Audio_File_Order(audio_index) = audio_file_number;
audio_index = audio_index+1;

%%

showghost  = 1;    % 1: show ghost of harddrop position
shownext   = 1;    % 1: indicate next piece in upper right corner; I, L, J, Z, S, O, or T
icol       = 2;    % color scheme; 1: MATLAB default colors, 2: Original Tetris colors; 3: Black-White
boxheight  = 20;   % height of game area (default=20)
boxwidth   = 10;   % width of game area (default=10)
%keys:
leftkey    = 'leftarrow';  % move left
rightkey   = 'rightarrow';  % move right
downkey    = 'downarrow';  % soft drop
hdropkey   = 'space';  % hard drop
rrotatekey = 'uparrow';  % rotate piece clockwise
lrotatekey = 'control';  % rotate piece counter-clockwise
pausekey   = 'escape';  % pause (then press any key to unpause)
restartkey = 'r';       % restart game (at end of or during game)
quitkey    = 'q';       % quit game (at end of or during game)
%% TO-DO
% - "Standard Rotation System" (SRS); rotation around fixed point to allow T-spinning
% - Highscore system
% - Drop tets from hidden layer above
%% Initialise game area
bbox=int8(zeros(boxheight,boxwidth));
shownext=min(max(shownext,0),1);
scrsize=get(0,'ScreenSize');
boxfig=figure('KeyPressFcn',{@Key_Down,leftkey,rightkey,downkey,hdropkey,rrotatekey,lrotatekey,pausekey,restartkey,quitkey},...
    'KeyReleaseFcn',{@Key_Up,leftkey,rightkey,downkey,hdropkey,rrotatekey,lrotatekey},'Menu','none','ToolBar','none','Position',...
    [ceil(scrsize(3)/2)-15*boxwidth,ceil(scrsize(4)/2)-15*boxheight,30*boxwidth,30*boxheight+30*2*shownext+30]);
% Make Fullscreen
% set the figure to full screen
set(boxfig,'units','normalized','outerposition',[0 0.05 1 .95]);
% hide the toolbar
set(boxfig,'menubar','none')
% to hide the title
set(boxfig,'NumberTitle','off');

% else
h2=axes('Position',[0 ,0,1,1-2/boxheight*shownext-1/30]);
set(h2,'YTick',[]);
set(h2,'XTick',[]);
axis equal
hold on
box off
xlim([0 boxwidth+.5])
ylim([0 boxheight])
axis tight
if shownext==1 %new axes for next tet
    h1=axes('Position',[0 1-2/boxheight-1/30 1  2/boxheight]);
    set(h1,'YTick',[]);
    set(h1,'XTick',[]);
    axis equal
    hold on
    box off
    xlim([0 boxwidth+.5])
    ylim([0 2])
    nbox=zeros(2,boxwidth);
    axis tight
end
% make intials tets
halfboxw=floor(boxwidth/2);
tetind2=zeros([7 4]);
%I-piece
tetind(1,:)=[halfboxw,boxheight];
tetind(2,:)=[halfboxw-1,boxheight];
tetind(3,:)=[halfboxw+2,boxheight];
tetind(4,:)=[halfboxw+1,boxheight];
tetind2(1,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(1,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));
%L
tetind(1,:)=[halfboxw+1,boxheight];
tetind(2,:)=[halfboxw+1,boxheight-1];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw-1,boxheight-1];
tetind2(2,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(2,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

%J
tetind(1,:)=[halfboxw-1,boxheight];
tetind(2,:)=[halfboxw-1,boxheight-1];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw+1,boxheight-1];
tetind2(3,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(3,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

%Z
tetind(1,:)=[halfboxw-1,boxheight];
tetind(2,:)=[halfboxw,boxheight];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw+1,boxheight-1];
tetind2(4,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(4,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

%S
tetind(1,:)=[halfboxw+1,boxheight];
tetind(2,:)=[halfboxw,boxheight];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw-1,boxheight-1];
tetind2(5,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(5,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

%O
tetind(1,:)=[halfboxw,boxheight];
tetind(2,:)=[halfboxw+1,boxheight];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw+1,boxheight-1];
tetind2(6,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(6,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

%T
tetind(1,:)=[halfboxw,boxheight];
tetind(2,:)=[halfboxw-1,boxheight-1];
tetind(3,:)=[halfboxw,boxheight-1];
tetind(4,:)=[halfboxw+1,boxheight-1];
tetind2(7,:)=sub2ind([boxheight,boxwidth],tetind(:,2),tetind(:,1));
tetindnext(7,:)=sub2ind([2,boxwidth],tetind(:,2)-boxheight+2,tetind(:,1));

score1=0;
nclearedtot=0;nclearedcurr=0;nn=1;
level=min(max(level,0),9);

AxesH = axes('Units', 'normalized', 'Position', [0,0,1,1], 'visible', 'off', ...
    'YLimMode', 'manual', 'YLim',  [0, 1], ...
    'XTick',    [],       'YTick', [], ...
    'NextPlot', 'add', ...
    'HitTest',  'off'); %axis for alignment of score text
tt=text(0.5,1,['Lines: ' num2str(nclearedtot) ' Level: ' num2str(level)...
    ' Score: ' num2str(score1)  ' Time Left: ' num2str(toc(startLoop))],'units','normalized','FontSize',12,'HorizontalAlignment',...
    'Center','VerticalAlignment','top','Parent',AxesH);
%colors
colmap{1}=...       % default MATLAB colors
    [0.6 0.6 0.6    % ghost
    0. 0. 0.        % background
    0.3 0.75 0.93   % I
    0.85 0.33 0.1   % L
    0 0.45 0.74     % J
    0.64 0.08 0.18  % Z
    0.47 0.67 0.19  % S
    0.93 0.69 0.13  % O
    0.49 0.18 0.56];% T

colmap{2}=...       % original Tetris colors
    [0.6 0.6 0.6
    0. 0. 0.
    0 1 1
    1 0.55 0
    0 0 1
    1 0 0
    0 1 0
    1 1 0
    0.5 0 0.5];

colmap{3}=...       % Black-White
    [0.5 0.5 0.5
    0 0 0
    ones(7,3)];

icol=min(max(icol,1),numel(colmap));
if shownext==1
    axes(h1)
    caxis([-1 7])
    colormap(colmap{icol});
end
axes(h2)
caxis([-1 7])
colormap(colmap{icol});
mm=1;
while mm<3 %mm==3 -> end game
    %dt=1; %time step for level 0
    dt=1; %time step for level 0
    ddt=.06; %time decrement per level (until level 10)
    dt=dt-level*ddt;
    figupdate=[];
    tets=1:7;
    tets=tets(randperm(length(tets))); %create set of all tets in random order
    tet=tets(1); %first tet
    tet2=tets(2); %next tet
    jj=1;
    
    %% Main loop        
    while nn<2 %nn==2 -> gameover
        movebox=0*bbox;
        movebox(tetind2(tet,:))=tet;
        % Value initialization
        downl=0;downr=0;downd=0;downb=0;downr1=0;downr2=0;upl=1;upr=1;upd=1;upb=1;upr1=1;upr2=1;ipause=0;
        lrshift=0;dshift=0;movbott=0;irestart=0;iquit=0;rrot=0;
        if sum(bbox(tetind2(tet,:)))>0 %check for space above (no space->automatic restart)
        % Enable for true game over
            % clear sound
            % break;
        % Enable for automatic restart
            irestart = 1;
            kk=1;nn=1;
        else
            kk=1;nn=1;
        end
        rotate=0;rot=0;itime=0;idown=0;
        if shownext==1 %show next tet on top axis
            nbox=0*nbox;
            nbox(tetindnext(tet2,:))=tet2;
            figure(boxfig)
            axes(h1)
            image(nbox,'CDataMapping','scaled');
            drawnow
            axes(h2)
        end

        while kk<2 %kk==2 -> new tet
            figure(boxfig)
            set(tt,'String',['Lines: ' num2str(nclearedtot) ' Level: ' num2str(level)...
            ' Score: ' num2str(score1)  ' Time Left: ' num2str(round(Total_Session_Time - toc(startLoop)))]);
            if downl==1 && upl==1
                lrshift=-1;downl=0;
            end
            
            if downr==1 && upr==1
                lrshift=1;downr=0;
            end
            
            if downd==1 && upd==1
                dshift=1;downd=0;
            end
            
            if downb==1 && upb==1
                movbott=1;downb=0;
            end
            
            if downr1==1 && upr1==1
                rotate=1;downr1=0;
            end
            
            if downr2==1 && upr2==1
                rotate=-1;downr2=0;
            end
            
            if ipause==1
                waitforbuttonpress;ipause=0;
            end
            
            if irestart==1
                score1=0;level=0;dt=dt-level*ddt;nclearedtot=0;nclearedcurr=0;bbox=0*bbox;movebox=bbox;
                set(tt,'String',['Lines: ' num2str(nclearedtot) ' Level: ' num2str(level)...
                    ' Score: ' num2str(score1) ' Time Left: ' num2str(round(Total_Session_Time - toc(startLoop)))]);
                break
            end
            
            if iquit==1
                mm=3;nn=2;
                break
                clear sound;
            end
            
            tic
            [movebox,bbox,ghostbox,kk,rot,rrot]=boxmove(movebox,bbox,tet,lrshift,dshift,movbott,rotate,boxwidth,boxheight,idown,showghost,rrot); %call to boxmove function
            
            if kk==2
                break;
            end
            totbox=bbox+movebox+ghostbox;
            endLoop = toc(startLoop);
            
            %END SESSION WHEN TIME EXPIRES
              if endLoop > Total_Session_Time
           
%                   savescore(trial_num) = score1;
%                   savedifficulty(trial_num) = level;
                  if level == 5
                      easy_or_hard = 'Easy';
                  else
                      easy_or_hard = 'Hard';
                  end
                  clear sound
                  uiwait(msgbox(sprintf('1.PLEASE DO NOT CLOSE OUT OF THIS WINDOW YET \n\n2. Input the selection as: %s \n\n3. Input your score into the Google Form as: %d \n\n4. Select the words that you recognize from the test you just performed \n\n5. Move onto the next page of the Google Form \n\n6. Click "Ok" on this dialog box and proceed to the next test',test_name, score1)))
                  fprintf("Selection: %s, Game Score: %d\n",test_name,score1)
                  iquit = 1;
              end
              
            %UPDATE SESSION
            figupdate=updatebox(totbox,boxfig); %call to plot function
            itime=itime+toc;
            if itime>=dt %don't move down until timestep reached
                idown=1;itime=0;
            else
                idown=0;
            end
            lrshift=0;movbott=0;rotate=0;dshift=0;
        end %kk
        jj=jj+1;
        if jj==7
            tetsnew=tets(randperm(length(tets))); %draw new set of 7 tets
            tet2=tetsnew(1);
        elseif jj<7
            tet2=tets(jj+1); %next tet
        elseif jj==8
            tets=tetsnew;
            jj=1;
            tet2=tets(2);
        end
        
        
        tet=tets(jj);
        %check for finished lines, update score, level, and game area
        boolbox=bbox==0;
        indfin=~any(boolbox,2);
        bbox(indfin,:)=[];
        bbox=[bbox; zeros([sum(indfin),boxwidth])];
        ncleared=sum(indfin);
        if ncleared==1
            score1=score1+1; %Modified scoring system
        elseif ncleared==2
            score1=score1+2;
        elseif ncleared==3
            score1=score1+3;
        elseif ncleared==4
            score1=score1+4;
        end
        nclearedtot=nclearedtot+ncleared;
        nclearedcurr=nclearedcurr+ncleared;
        set(tt,'String',['Lines: ' num2str(nclearedtot) ' Level: ' num2str(level)...
            ' Score: ' num2str(score1)  ' Time Left: ' num2str(round(Total_Session_Time - toc(startLoop)))]);
    end %nn   
    
    totbox=movebox+bbox;
    updatebox(totbox,boxfig);
    et=text(halfboxw+.5,boxheight-2,sprintf(['GAME OVER \n Press ' restartkey ' to play again. \n Press ' quitkey ' to quit.']),...
        'FontSize',20,'HorizontalAlignment','Center','BackGroundColor','w');
    
    
    while irestart~=1 && iquit~=1
    waitforbuttonpress
    clear sound
    end
    
    
    if irestart==1
        delete(et);
        score1=0;level=0;dt=dt-level*ddt;nclearedtot=0;bbox=0*bbox;movebox=bbox;nclearedcurr=0;
        set(tt,'String',['Lines: ' num2str(nclearedtot) ' Level: ' num2str(level)...
            ' Score: ' num2str(score1)  ' Time Left: ' num2str(round(Total_Session_Time - toc(startLoop)))]);
        nn=1;
        clear sound
    end
    
    
    if iquit==1
        mm=3;
        close(boxfig)
        break
        clear sound
    end  
   
end %mm

wide_trial = wide_trial + 1;
if wide_trial == 6
    %msgbox(sprintf('Thank you so much for playing! :) \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Please Input These Numbers into the Google Form: \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Training Game Score: %d \n\n Training Game Level: %d \n\n Training Game Sound File: %d \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Trial 1 Score: %d\n\n Trial 1 Level: %d \n\n Trial 1 Sound File: %d \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Trial 2 Score: %d\n\n Trial 2 Level: %d \n\n Trial 2 Sound File: %d \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Trial 3 Score: %d\n\n Trial 3 Level: %d \n\n Trial 3 Sound File: %d \n\n xxxxxxxxxxxxxxxxxxxxxxxxxx \n\n Trial 4 Score: %d\n\n Trial 4 Level: %d \n\n Trial 4 Sound File: %d', savescore(1), savedifficulty(1), Audio_File_Order(1), savescore(2), savedifficulty(2), Audio_File_Order(2), savescore(3), savedifficulty(3), Audio_File_Order(3), savescore(4), savedifficulty(4), Audio_File_Order(4), savescore(5), savedifficulty(5), Audio_File_Order(5)))
iquit = 1;
break
end

end
























%% Functions
function [boxmove1,box1,ghostbox1,kk,rot,rrot]=boxmove(movebox,box,tet,lrshift,dshift,movbott,rotate,boxwidth,boxheight,idown,showghost,rrot)
%main function for handling tet movement
[idtety, idtetx]=find(movebox);
idown=idown+dshift;
boxindcurr=sub2ind(size(box),idtety,idtetx); %current position

if min(idtety)-idown<1
    boxinddown=boxindcurr; %bottom reached
else
    boxinddown=sub2ind(size(box),idtety-idown,idtetx); %position below
end


rot=0;
if min(idtetx)==1 && lrshift==-1 %check for left out of bounds
    lrshift=0;
end


if max(idtetx)==boxwidth && lrshift==1 %check for right out of bounds
    lrshift=0;
end


if movbott==1 || showghost==1
    topid = ones(1, boxwidth);
    for col = 1 : size(box, 2)
        itop= find(box(1:min(idtety), col), 1, 'last'); %find bottommost possible position below current tet
        if isempty(itop)
            topid(col)=0;
        else
            topid(col) = itop;
        end
        
    end
    bottind=sub2ind(size(box),idtety-min(idtety-topid(idtetx)')+1,idtetx);
    
end


ghostbox1=0*box;


if showghost==1
    ghostbox1(bottind)=-1;
end


if lrshift==-1
    boxindnext=sub2ind(size(box),max(1,idtety-idown),max(idtetx+lrshift,1)); %next position to left
elseif lrshift==1
    boxindnext=sub2ind(size(box),max(1,idtety-idown),min(idtetx+lrshift,boxwidth)); %next position to right
elseif rotate==1 || rotate==-1
    rrot=mod(rrot+rotate,4);
    boxindnext=dorotate(movebox,boxwidth,boxheight,rotate,rrot,tet); %rotated position
    rot=0; %0:rotation performed
elseif movbott==1 %hard drop to bottom
    boxindnext=bottind; %set to bottomost possible position
else
    boxindnext=boxinddown; %no input: next position below
end


box1=box;
boxmove1=0*box;
%check for bottom/illegal positions
if movbott==0
    if (sum(box(boxindnext))>0 && sum(box(boxinddown))>0) || min(idtety)-idown<1 %nowhere left to go: stop
        kk=2;
        box1(boxindcurr)=tet;
    elseif sum(box(boxindnext))==0 %next legal position
        kk=1;
        boxmove1(boxindnext)=tet;
    else %move down only
        kk=1;
        boxmove1(boxinddown)=tet;
        rot=1; %no rotation performed
    end
    
    
elseif movbott==1 %hard drop; move to bottom
    box1(boxindnext)=tet;
    kk=2;
end


if showghost==1
    ghostbox1(intersect(bottind,boxindnext))=0; %make sure tet overlaps ghost
end


end


function figupdate=updatebox(box,boxfig)
%function to draw game area
figure(boxfig)
figupdate=image(box,'CDataMapping','scaled');
drawnow
end


function movebox=dorotate(movebox,boxwidth,boxheight,irot,rott,tet)
%function to rotate tets 90 or 270 deg
movebox1=movebox;
movebox(:)=0;
[idtety, idtetx]=find(movebox1); %find current position
htetmin=min(idtety);
xtetmin=min(idtetx);
htetmax=max(idtety);
xtetmax=max(idtetx);
currmat=movebox1(htetmin:htetmax,xtetmin:xtetmax);%cut out matrix containing tet
newmat=rot90(currmat,irot); %rotate
xtetnewmax=min(boxwidth,xtetmin+(htetmax-htetmin)); %keep within play area
xtetnewmin=xtetnewmax-(htetmax-htetmin);
movebox(htetmax-(xtetmax-xtetmin):htetmax,xtetnewmin:xtetnewmax)=newmat; %paste rotated matrix to game area
[idtety, idtetx]=find(movebox); %find rotated position
movebox=sub2ind(size(movebox),idtety,idtetx);


end

% Functions to handle input
function Key_Down(~,event,leftkey,rightkey,downkey,hdropkey,lrotatekey,rrotatekey,pausekey,restartkey,quitkey)
if strcmp(event.Key,leftkey)   ,  assignin('base','downl',1);   end
if strcmp(event.Key,rightkey)  ,  assignin('base','downr',1);   end
if strcmp(event.Key,downkey)   ,  assignin('base','downd',1);   end
if strcmp(event.Key,hdropkey)  ,  assignin('base','downb',1);   end
if strcmp(event.Key,pausekey)  ,  assignin('base','ipause',1);  end
if strcmp(event.Key,lrotatekey),  assignin('base','downr1',1);  end
if strcmp(event.Key,rrotatekey),  assignin('base','downr2',1);  end
if strcmp(event.Key,restartkey),  assignin('base','irestart',1);end
if strcmp(event.Key,quitkey)   ,  assignin('base','iquit',1);   end
end


function Key_Up(~,event,leftkey,rightkey,downkey,hdropkey,lrotatekey,rrotatekey)
if strcmp(event.Key,leftkey)   ,  assignin('base','upl',1);  end
if strcmp(event.Key,rightkey)  ,  assignin('base','upr',1);  end
if strcmp(event.Key,downkey)   ,  assignin('base','upd',1);  end
if strcmp(event.Key,hdropkey)  ,  assignin('base','upb',1);  end
if strcmp(event.Key,lrotatekey),  assignin('base','upr1',1); end
if strcmp(event.Key,rrotatekey),  assignin('base','upr2',1); end
end