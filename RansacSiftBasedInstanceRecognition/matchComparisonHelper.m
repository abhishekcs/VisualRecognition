no_of_template_features = size(d1, 2)
no_of_scene_features = size(d2,2);
dists = dist2(double(d1)', double(d2)');
meanDistance = sum(sum(dists))/(no_of_template_features*no_of_scene_features);

% Nearest Neighbors
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
%%% Visualize Nearest Neighbor test survivors
clf;
showLinesBetweenMatches(im1, im2, f1, f2, matchMatrix);
fprintf('Showing the nearest neigbors with threshhold survivors.  Type dbcont to continue.\n');
keyboard;
fprintf('scenenum=%d\n', scenenum);



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
% Visualize survivors after nearest neighbors and Lowe's Test
clf;
showLinesBetweenMatches(im1, im2, f1, f2, matchMatrix);
fprintf('Showing the lowe test survivors.  Type dbcont to continue.\n');
keyboard;
fprintf('scenenum=%d\n', scenenum);



% RANSAC
currentTemplateImagePositions = f1([1 2], matchMatrix(1,:))';
currentQueryImagePositions = f2([1 2], matchMatrix(2,:))';
% Find affine parameters and matches using ransac 
[best_affine_pars, ransac_matches] = ransac( currentTemplateImagePositions, currentQueryImagePositions);
% Visualize survivors after all 3 tests
showLinesBetweenMatches(im1, im2, f1, f2, matchMatrix(:,ransac_matches));
fprintf('Showing the ransac survivors.  Type dbcont to continue.\n');
keyboard;
fprintf('scenenum=%d\n', scenenum);