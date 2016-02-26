function[X] = applyAffinePars(U, tform)
[n, m] = size(U);
XO = [U ones(n,1)]*tform;
X = XO(:, [1 2]);
end

