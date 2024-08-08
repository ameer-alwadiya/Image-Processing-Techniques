%% Load the Digits dataset
digitDatasetPath = fullfile(toolboxdir('nnet'), 'nndemos', 'nndatasets', 'DigitDataset');

imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imds.ReadFcn = @(loc)imresize(imread(loc), [32, 32]);

% Split the data into training and validation datasets
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7, 'randomized');

disp(size(imdsTrain.Files));

% Plot some samples from the training dataset
figure;
numSamples = 10; % Number of samples to plot
for i = 1:numSamples
    subplot(2, numSamples/2, i);
    idx = randi(numel(imdsTrain.Files)); % Randomly select an image index
    img = readimage(imdsTrain, idx);
    imshow(img);
end

%% Define the LeNet-5 architecture
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,6,'Padding','same','Name','conv_1')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')
    
    fullyConnectedLayer(120,'Name','fc_1')
    fullyConnectedLayer(84,'Name','fc_2')
    fullyConnectedLayer(10,'Name','fc_3')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% (1.a) L2 regulariztion
layers = [
    imageInputLayer([32 32 1],'Name','input')
    
    convolution2dLayer(5,6,'Padding','same','Name','conv_1')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_1')
    
    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')
    
    fullyConnectedLayer(120,'Name', 'fc_1', 'WeightL2Factor', 0.1)
    fullyConnectedLayer(84,'Name', 'fc_2', 'WeightL2Factor', 0.1)
    fullyConnectedLayer(10,'Name', 'fc_3', 'WeightL2Factor', 0.1)
    
    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% (1.b) Drop-out layer
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,6,'Padding','same','Name','conv_1')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')
    
    fullyConnectedLayer(120,'Name','fc_1')

    fullyConnectedLayer(84,'Name','fc_2')
    dropoutLayer(0.15,'Name','dropout_fc2') % Adjust dropout rate as needed

    fullyConnectedLayer(10,'Name','fc_3')

    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% (2.a) Define the layers with sigmoid activation
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,6,'Padding','same','Name','conv_1')
    reluLayer('Name','relu_1')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    reluLayer('Name','relu_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')

    fullyConnectedLayer(120,'Name', 'fc_1', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_2')

    fullyConnectedLayer(84,'Name', 'fc_2', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_2')

    % dropoutLayer(0.15,'Name','dropout_fc1') % Adjust dropout rate as needed

    fullyConnectedLayer(10,'Name','fc_3')

    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];


%% (2.b) Define the layers with sigmoid activation
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,6,'Padding','same','Name','conv_1')
    sigmoidLayer('Name','sigmoid_1')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    sigmoidLayer('Name','sigmoid_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')

    fullyConnectedLayer(120,'Name', 'fc_1', 'WeightL2Factor', 0.1)
    sigmoidLayer('Name','sigmoid_3')

    fullyConnectedLayer(84,'Name', 'fc_2', 'WeightL2Factor', 0.1)
    sigmoidLayer('Name','sigmoid_4')

    % dropoutLayer(0.15,'Name','dropout_fc1') % Adjust dropout rate as needed

    fullyConnectedLayer(10,'Name','fc_3')

    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% (3.a) advance model (my own)
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,8,'Padding','same','Name','conv_1')
    reluLayer('Name','relu_1')
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    reluLayer('Name','relu_2')
    averagePooling2dLayer(2,'Stride',2,'Name','avgpool_2')

    convolution2dLayer(3,32,'Padding','same','Name','conv_3')
    reluLayer('Name','relu_3')
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool_3')

    fullyConnectedLayer(256,'Name','fc_1', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_4')

    fullyConnectedLayer(128,'Name','fc_2', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_5')

    % dropoutLayer(0.15,'Name','dropout_fc1')

    fullyConnectedLayer(10,'Name','fc_4')

    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% (3.b) advance model 
layers = [
    imageInputLayer([32 32 1],'Name','input')

    convolution2dLayer(5,8,'Padding','same','Name','conv_1')
    reluLayer('Name','relu_1')
    maxPooling2dLayer(2,'Name','maxpool_1')

    convolution2dLayer(5,16,'Padding','same','Name','conv_2')
    reluLayer('Name','relu_2')
    averagePooling2dLayer(2,'Name','avgpool_2')

    convolution2dLayer(3,32,'Padding','same','Name','conv_3')
    reluLayer('Name','relu_3')
    maxPooling2dLayer(2,'Name','maxpool_3')

    fullyConnectedLayer(256,'Name','fc_1', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_4')

    fullyConnectedLayer(128,'Name','fc_2', 'WeightL2Factor', 0.1)
    reluLayer('Name','relu_5')

    dropoutLayer(0.15,'Name','dropout_fc1')

    fullyConnectedLayer(10,'Name','fc_4')

    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% Specify the training options
options = trainingOptions('sgdm', ...
 'InitialLearnRate',0.0001, ...
 'MaxEpochs',10, ...
 'Shuffle','every-epoch', ...
 'ValidationData',imdsValidation, ...
 'ValidationFrequency',30, ...
 'Verbose',false, ...
 'Plots','training-progress');

%% Train the network
net = trainNetwork(imdsTrain, layers, options);

%% Classify validation images and compute accuracy
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation);
fprintf('Accuracy of the network on the validation images: %f\n', accuracy)

%% Precision, Recall, and the F1 score
% Calculate confusion matrix
C = confusionmat(YValidation, YPred);
confusionchart(C);

% Calculate precision, recall, and F1 score
num_classes = size(C, 1);
precision = zeros(num_classes, 1);
recall = zeros(num_classes, 1);
f1_score = zeros(num_classes, 1);

for i = 1:num_classes
    tp = C(i, i); % True Positives
    fp = sum(C(:, i)) - tp; % False Positives
    fn = sum(C(i, :)) - tp; % False Negatives
    
    precision(i) = tp / (tp + fp);
    recall(i) = tp / (tp + fn);
    
    f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

% Average precision, recall, and F1 score
avg_precision = mean(precision);
avg_recall = mean(recall);
avg_f1_score = mean(f1_score);

% Display results
fprintf('Average Precision: %f\n', avg_precision);
fprintf('Average Recall: %f\n', avg_recall);
fprintf('Average F1 Score: %f\n', avg_f1_score);
