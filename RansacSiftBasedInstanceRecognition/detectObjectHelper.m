OBJECT_DETECTION_INLIER_THRESHHOLD = 6
EIGEN_VALUE_THRESHHOLD = 1e-4

no_of_template_features = size(d1, 2)
no_of_scene_features = size(d2,2);
dists = dist2(double(d1)', double(d2)');
meanDistance = sum(sum(dists))/(no_of_template_features*no_of_scene_features);

% Nearest Neighbors with Threshholds
% Sort those distances
[sortedDists, sortedIndices] = sort(dists, 2, 'ascend');
matchedIndices = sortedIndices(:,1)';
matchedDistances = sortedDists(:,1)';
% Apply the Threshold
lessThanThresholdNN = matchedDistances < (0.6*meanDistance);
% Create Match Matrix
matchMatrix = zeros(3, sum(lessThanThresholdNN));
j = 1;
for i = 1:no_of_template_features
   if(lessThanThresholdNN(i) == 1)
       matchMatrix(:, j) = [i matchedIndices(i) matchedDistances(i)]';
       j = j+1;
   end
end



% Lowe's Test
lessThanThresholdAndRatioNN = (matchedDistances < (0.8*meanDistance)) & (matchedDistances < 0.6*sortedDists(:,2)');
% Create Match Matrix 
matchMatrix = zeros(3, sum(lessThanThresholdAndRatioNN));
j = 1;
for i = 1:no_of_template_features
   if(lessThanThresholdAndRatioNN(i) == 1)
       matchMatrix(:, j) = [i matchedIndices(i) matchedDistances(i)]';
       j = j+1;
   end
end



% RANSAC
currentTemplateImagePositions = f1([1 2], matchMatrix(1,:))';
currentQueryImagePositions = f2([1 2], matchMatrix(2,:))';
% Find affine parameters and matches using ransac 
[best_affine_pars, ransac_matches] = ransac( currentTemplateImagePositions, currentQueryImagePositions);
% Test for Detection. If detection returns true we display bounding box
no_of_matching_inliers = size(ransac_matches, 2);
eigenValues = eigs(best_affine_pars(1:2, 1:2),2); 
if(no_of_matching_inliers >= OBJECT_DETECTION_INLIER_THRESHHOLD & min(abs(eigenValues)) >= EIGEN_VALUE_THRESHHOLD)
    fprintf('Template image detected in scene image.\n Showing bounding box in scene.\n');
    % Generate Corners of Bounding Box
    boundingBoxCornors =  applyAffinePars([1 1; 1 w;  h 1; h w], best_affine_pars);
    imshow(im2);
    drawRectangle(boundingBoxCornors', 'b');
else
    fprintf('Template image not present in scene image \n');
end
fprintf(' Type dbcont to continue.\n');
keyboard;
fprintf('scenenum=%d\n', scenenum);