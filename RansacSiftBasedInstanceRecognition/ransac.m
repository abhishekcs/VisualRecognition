function [ best_affine_fit_pars, final_matches ] = ransac( d1, d2 )
INLIER_DISTANCE_THRESHOLD = sqrt(5);
NO_OF_ITERATIONS = 300;
[n1, m1] = size(d1);
max_match_count = 0;
for i = 1:NO_OF_ITERATIONS
    % Sample
    candidates = sampleCandidates(3, n1);
    X = d1(candidates, :);
    Y = d2(candidates, :);
    
    % Find affine fit using the samples
    affine_pars = findAffinePars(X, Y);
    
    % Find inliers for this affine transform
    current_count = 0;
    for j = 1:n1
        candidateY = d2(j, :);
        affineTransformY = applyAffinePars( d1(j,:), affine_pars);
        if(norm(candidateY - affineTransformY) <= INLIER_DISTANCE_THRESHOLD)
            current_count = current_count + 1;
            candidates(current_count) = j;
        end
    end
    
    % Update the max_match_count if current inlier count is correct
    if(current_count >= max_match_count)
        max_match_count = current_count;
        final_matches = candidates;
    end
end

% Improve estimate of affine parameters using final inliers that we have
X = d1(final_matches, :);
Y = d2(final_matches, :);
best_affine_fit_pars = findAffinePars(X, Y);
end

% Sample no_of_candidates candidate inliers from range
function [candidates] = sampleCandidates(no_of_candidates, range)
candidates = randperm(range, no_of_candidates);
end

% Find affine transformation given list of input and output coordinates
function [affine_pars] = findAffinePars(X, Y)
[n, m] = size(X);
XP = [];
XP(1:2:2*n, [1 2]) = X;
XP(2:2:2*n, [3 4]) = X;
XP(1:2:2*n, 5) = ones(n,1);
XP(2:2:2*n, 6) = ones(n,1);
YP = [];
YP(1:2:2*n, 1) = Y(:,1);
YP(2:2:2*n, 1) = Y(:,2);
affine_par_vector = pinv(XP)*YP;
affine_pars = [ affine_par_vector(1) affine_par_vector(3) 0;
               affine_par_vector(2) affine_par_vector(4) 0;
               affine_par_vector(5) affine_par_vector(6) 1];
end