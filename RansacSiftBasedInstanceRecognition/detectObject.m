%%% Skeleton script for 395T Visual Recognition Assignment 1%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kristen Grauman, UT-Austin
%%% Using the VLFeat library.  http://www.vlfeat.org.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ****Be sure to add vl feats to the search path: ****
% >>> run('VLFEATROOT/toolbox/vl_setup');
% where VLFEATROOT is the directory where the code was downloaded.
% See http://www.vlfeat.org/install-matlab.html
run('../vlfeat-0.9.20/toolbox/vl_setup.m');
fprintf('Be sure to add VLFeat path.\n');

clear;
close all;


% Some flags
DISPLAY_PATCHES = 0;
SHOW_ALL_MATCHES_AT_ONCE = 1;

% Constants
N = 50;  % how many SIFT features to display for visualization of features


templatename = 'object-template.jpg';
scenenames = {'object-template-rotated.jpg', 'scene1.jpg', 'scene2.jpg'};
% templatename = 'taj1.jpg';
% scenenames = {'taj2.jpg', 'taj3.jpg'};
%templatename = 'taj1.jpg';
%scenenames = {'taj2.jpg', 'taj3.jpg'};
%scenenames = {'colosseum.jpg'};
%scenenames = { 'scene1.jpg', 'scene2.jpg'};
%scenenames = { 'scene1.jpg'};

% Read in the object template image.  This is the thing we'll search for in
% the scene images.
im1 = im2single(rgb2gray(imread(templatename)));
[w,h] = size(im1);


% Extract SIFT features from the template image.
%
% 'f' refers to a matrix of "frames".  It is 4 x n, where n is the number
% of SIFT features detected.  Thus, each column refers to one SIFT descriptor.  
% The first row gives the x positions, second row gives the y positions, 
% third row gives the scales, fourth row gives the orientations.  You will
% need the x and y positions for this assignment.
%
% 'd' refers to a matrix of "descriptors".  It is 128 x n.  Each column 
% is a 128-dimensional SIFT descriptor.
%
% See VLFeats for more details on the contents of the frames and
% descriptors.
[f1, d1] = vl_sift(im1);



% count number of descriptors found in im1
n1 = size(d1,2);


% Loop through the scene images and do some processing
for scenenum = 1:length(scenenames)
    
    fprintf('Reading image %s for the scene to search....\n', scenenames{scenenum});
    im2 = im2single(rgb2gray(imread(scenenames{scenenum})));
    
    
    % Extract SIFT features from this scene image
    [f2, d2] = vl_sift(im2);
    n2 = size(d2,2);
    
    % Show a random subset of the SIFT patches for the two images
    if(DISPLAY_PATCHES)
        
        displayDetectedSIFTFeatures(im1, im2, f1, f2, d1, d2, N);
        
        fprintf('Showing a random sample of the sift descriptors.  Type dbcont to continue.\n');
        
        keyboard;
    end
    
    detectObjectHelper

end