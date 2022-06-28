function MPmoments = calculate_moments(MP)

% Input: microstructure profiles (MP), with cortical depths as
% rows and vertices/parcels as columns.
%
% Values (i.e. staining or imaging intensities) input must be integers
%
% Output: mean amplitude (intensity) of profile, as well as the mean, sd, skewness and kurtosis (m1-4) treating the profile as a
% frequency distribution
%
% author: Casey Paquola, 2022


depth_sampled = [1:size(MP,1)]';

mean_amplitude = mean(MP);

parfor ii = 1:size(MP,2)
    if rem(ii,1000) == 0
        disp(ii)
    end
    raw_data = repelem(depth_sampled, MP(:,ii));
    m1(ii) = mean(raw_data); % depth centre of gravity 
    m2(ii) = std(raw_data); % typical deviation of bumps from the centre of gravity,  
    m3(ii) = skewness(raw_data); 
    m4(ii) = kurtosis(raw_data);
end

MPmoments = [mean_amplitude; m1; m2; m3; m4];