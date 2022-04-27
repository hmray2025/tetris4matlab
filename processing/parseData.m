%% Parsing Tetris Data
clear;clc;
%% Import Subject Responses
data1 = readtable('finalData.csv');
nSubs = height(data1);
newLabels = {'Timestamp','Age','Gender','Proficiency','LearnStyle',...
    'TetrisXP','WorkloadXP','SubmitForm','TrialNumT','ScoreT','WordsT',...
    'TrialNumA','ScoreA','WordsA','TrialNumB','ScoreB','WordsB',...
    'TrialNumC','ScoreC','WordsC','TrialNumD','ScoreD','WordsD',...
    'WorkloadT','WorkloadA','WorkloadB','WorkloadC','WorkloadD'};

for i = 1:width(data1)
    data1.Properties.VariableNames{i} = newLabels{i};
end

%% Import Correct word list
wordList = readtable('WordsList.xlsx','Range','A1:J37','PreserveVariableNames',true);
newLabels = {'TrainingX','AlphaX','BetaX','GammaX','DeltaX'};
for i = 6:10
    wordList.Properties.VariableNames{i} = newLabels{i-5};
end

% capitalize the wordlist
for i = 1:10
    for j = 1:36
        if ~isempty(wordList{j,i}{:})
            wordList{j,i}{:}(1) = wordList{j,i}{:}(1)-32;
        end
    end
end


%% Count # Correct Selections
nCorrect = zeros(nSubs,5);
nTotal = 10*ones(nSubs,5);
nIncorrect = zeros(nSubs,5);
for i = 1:nSubs                                             % iterate through all subjects
    for j = 1:5                                             % iterate through 5 trials [T,A,B,C,D]
        tempResponses = data1{i,8+3*j};                     % jumps 4 columns each time
        if j==1||j==2||j==4                                 % training, alpha, & gamma have 18 words
            for k = 1:18
                if strfind(tempResponses{:},wordList{k,j}{:})   % count # correct words in response
                    nCorrect(i,j) = nCorrect(i,j)+1;
                end
                if strfind(tempResponses{:},wordList{k,j+5}{:}) % count # incorrect words in response
                    nIncorrect(i,j) = nIncorrect(i,j)+1;
                end
            end
        elseif j==3||j==5                                   % beta & delta have 36 words
            for k = 1:36
                if strfind(tempResponses{:},wordList{k,j}{:})   % count # correct words in response
                    nCorrect(i,j) = nCorrect(i,j)+1;
                end
                if strfind(tempResponses{:},wordList{k,j+5}{:}) % count # incorrect words in response
                    nIncorrect(i,j) = nIncorrect(i,j)+1;
                end
            end
        end
    end
end

nMissed = nTotal-nCorrect;

%% Convert Trial Number to Num
trialNums = zeros(nSubs,5);
for i = 1:5
    tempNums = data1(:,6+3*i);
    for j = 1:nSubs
        if strcmp(tempNums{j,1}{:},'Training')
            trialNums(j,i) = 0;
        else
            trialNums(j,i) = str2double(tempNums{j,1}{:}(end:end));
        end
    end
end

%% Calculate Precision and Recall
precision = nCorrect./(nCorrect+nIncorrect);
recall = nCorrect./(nCorrect+nMissed);

%% generate csv
precisionT = precision(:,1); recallT = recall(:,1);
precisionA = precision(:,2); recallA = recall(:,2);
precisionB = precision(:,3); recallB = recall(:,3);
precisionC = precision(:,4); recallC = recall(:,4);
precisionD = precision(:,5); recallD = recall(:,5);

wordScores = table(precisionT,precisionA,precisionB,precisionC,precisionD,...
    recallT,recallA,recallB,recallC,recallD);
data2 = [data1(:,1:7) data1(:,9:end) wordScores];
data2.TrialNumT = trialNums(:,1); 
data2.TrialNumA = trialNums(:,2);
data2.TrialNumB = trialNums(:,3);
data2.TrialNumC = trialNums(:,4);
data2.TrialNumD = trialNums(:,5);

writetable(data2,'processedData.csv')