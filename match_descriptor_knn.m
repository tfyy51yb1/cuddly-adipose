function [idx, d] = match_descriptor_knn(new_descriptor, ...
                                         descriptors, ...
                                         k,...
                                         disttype)
                                                                          

% This can be done much faster, but is implemented like this to be easily understood,
% This will not be the bottleneck of the system anyway...
switch disttype
    case 'SAD'
        D = zeros(size(descriptors));
        for j = 1:numel(D)
            D(k) = sum(abs(descriptors{k}(:) - new_descriptor(:)));
        end
        minfl = true;
    case 'SSE'
        D = zeros(size(descriptors));
        for j = 1:numel(D)
            D(k) = sum((descriptors{k}(:) - new_descriptor(:)).^2);
        end
        minfl = true;
    case 'Euclidean'
        D = zeros(size(descriptors));
        for j = 1:numel(D)
            D(k) = sqrt(sum((descriptors{k}(:) - new_descriptor(:)).^2));
        end
        minfl = true;
    case 'correlation'
        D = zeros(size(descriptors));
        for j = 1:numel(D)
            D(k) = sum(descriptors{k}(:).*new_descriptor(:));
        end
        minfl = false;
    otherwise
        error(['Unknown distance type: ' disttype]);
end

if minfl
    mode = 'ascend';
else
    mode = 'descend';
end

[d, idx] = sort(D, mode);

idx = idx(1:k);
d = d(1:k);