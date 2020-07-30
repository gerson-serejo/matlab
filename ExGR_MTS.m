% Algorithm ExGR_MTS:  ExGR(Excess Green minus Excess Red Vegetation Index)
% With Manual Threshold Selection (MTS) Value 

clear;

% System variables
NumberOccurrences = 60.0; % Manual Threshold Selection (MTS)
TotalNumberPixels = 255.0;
StartPixelCloud = 10.0;
ManualCountingProcess = 251.0;
Percentage = 100.0;

% Read image from graphics file
Im = imread('plantacao2.png'); 

%1) Preprocessing procedures------------------------------------------------
% Resize image
ScaleImageResize=0.55;
ImageResize = imresize(Im,ScaleImageResize);    

% Convert RGB image to chosen color space.
R = ImageResize(:,:,1); % channel Red             
G = ImageResize(:,:,2); % channel Green            
B = ImageResize(:,:,3); % channel Blue

% Vegetation index.
ExG = 2*G-R-B;     
ExR = 1.4*R-G;
ExGR = ExG - ExR;

%2) Create threshold -------------------------------------------------------
%Threshold value
ValueThreshold = NumberOccurrences/TotalNumberPixels;

% Create a binary image (0s and 1s)
imBinarized = imbinarize(ExGR,ValueThreshold); 

% Remove all connected components 
imRemovesConnectedComponents = bwareaopen(imBinarized, StartPixelCloud);

%Fill image regions and holes
imFillImageRegions = imfill(imRemovesConnectedComponents, 'holes'); 

%3) Counting rate calculation ----------------------------------------------

% Find connected components in binary image
FindConnectedComponents = bwconncomp(imFillImageRegions);

%Count the number of plants
CountPlants  = FindConnectedComponents.NumObjects;

% Plant count rate
CountingRate = ((CountPlants/ManualCountingProcess))*Percentage;

%4) Results ----------------------------------------------------------------
subplot(2,2,1); imhist(ExGR); title(['Threshold value:P=(',num2str(NumberOccurrences), '/',num2str(TotalNumberPixels), ')=',num2str(ValueThreshold)]);
subplot(2,2,2); imshow(imBinarized); title('binary Image (ExGR MTS)');
subplot(2,2,3); imshow(imFillImageRegions); title('Fill image regions and holes.');
subplot(2,2,4); imshow(imFillImageRegions); title(['Number plants: ',num2str(CountPlants), ', Counting rate: ' num2str(CountingRate) ,' %' ]);
