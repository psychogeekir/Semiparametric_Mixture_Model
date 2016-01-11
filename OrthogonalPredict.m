function Z = OrthogonalPredict( NewData, degree, alpha, norm2 )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

NewData = NewData(:);
Z = zeros(length(NewData), degree+1);
Z(:,1) = 1;

if degree>0
    Z(:,2) = NewData - alpha(1);
end

if degree>1
    for i = 2:degree
        Z(:,i+1) = (NewData - alpha(i)).*Z(:,i) - (norm2(i+1)/norm2(i))*Z(:,i-1);
    end
end

Z = bsxfun(@rdivide,Z,sqrt(norm2(2:end)));
Z = Z(:,2:degree+1);

end

