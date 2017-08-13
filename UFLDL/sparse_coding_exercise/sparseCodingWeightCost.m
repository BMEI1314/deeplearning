function [cost, grad] = sparseCodingWeightCost(weightMatrix, featureMatrix, visibleSize, numFeatures,  patches, gamma, lambda, epsilon, groupMatrix)
%sparseCodingWeightCost - given the features in featureMatrix, 
%                         computes the cost and gradient with respect to
%                         the weights, given in weightMatrix
% parameters
%   weightMatrix  - the weight matrix. weightMatrix(:, c) is the cth basis
%                   vector.
%   featureMatrix - the feature matrix. featureMatrix(:, c) is the features
%                   for the cth example
%   visibleSize   - number of pixels in the patches
%   numFeatures   - number of features
%   patches       - patches
%   gamma         - weight decay parameter (on weightMatrix)
%   lambda        - L1 sparsity weight (on featureMatrix)
%   epsilon       - L1 sparsity epsilon
%   groupMatrix   - the grouping matrix. groupMatrix(r, :) indicates the
%                   features included in the rth group. groupMatrix(r, c)
%                   is 1 if the cth feature is in the rth group and 0
%                   otherwise.
    if exist('groupMatrix', 'var')
        assert(size(groupMatrix, 2) == numFeatures, 'groupMatrix has bad dimension');
    else
        groupMatrix = eye(numFeatures);
    end

    numExamples = size(patches, 2);

    weightMatrix = reshape(weightMatrix, visibleSize, numFeatures);
    featureMatrix = reshape(featureMatrix, numFeatures, numExamples);
    
    % -------------------- YOUR CODE HERE --------------------
    % Instructions:
    %   Write code to compute the cost and gradient with respect to the
    %   weights given in weightMatrix.     
    % -------------------- YOUR CODE HERE --------------------    
    linearError = weightMatrix * featureMatrix - patches;
    normError = sum(sum(linearError .* linearError))./numExamples;% ��ʽ�д������Ƕ��׷�����ƽ�������Բ����ڿ���
    normWeight = sum(sum(weightMatrix .* weightMatrix));
    
    topoFeature = groupMatrix*(featureMatrix.*featureMatrix);
    smoothFeature = sqrt(topoFeature + epsilon);
    costFeature = sum(sum(smoothFeature));% L1 ����Ϊsum(|x|),��x����ƽ��������,sum(sqrt(x2+epsilon)).���״�дΪsqrt(sum(x2+epsilon))ʵ����L2����
    
%     cost = normError + gamma.*normWeight;
    cost = normError + lambda.*costFeature + gamma.*normWeight;
    grad = 2./numExamples.*(linearError*featureMatrix') + (2*gamma) .* weightMatrix;
%     grad = 2.*(weightMatrix*featureMatrix - patches)*featureMatrix' + 2.*gamma*weightMatrix;
    grad = grad(:);

end

