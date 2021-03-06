% clear

% XX(:, :, 1)= [ 1 2 3; 4 5 6; 7 8 9];
% XX(:, :, 2)= [ 11 12 13; 14 15 16; 17 18 19];

% features = single(zeros(size(XX,1),size(XX,2)*size(XX,3)));
% for i = 1 : size(XX,1)
%     temp = squeeze(XX(i,:,:))';
%     features(i,:) = temp(:); 
% end


%% ===========
function [features] = createFeatures(XX,tmin, tmax, sfreq,tmin_original)

disp('Applying the desired time window.')
beginning = (tmin - tmin_original) * sfreq+1;
e = (tmax - tmin_original) * sfreq;
XX = XX(:, :, beginning:e);
disp('2D Reshaping: concatenating all 306 timeseries.');
features_h = single(zeros(size(XX,1),size(XX,2)*size(XX,3)));
features = single(zeros(size(XX,1),size(XX,2)*size(XX,3)));
wname = 'db3';
lev = 5 ;

for i = 1 : size(XX,1)
    temp = squeeze(XX(i,:,:))';
    features_h(i,:) = temp(:); 
    [c,l] = wavedec( features_h(i,:),lev,wname);
    
    alpha = 1.5; m = l(1);
    [thr, nkeep] = wdcbm (c,l,alpha,m);
    [xd,xcd,lxd,perf0,perl2] = wdencmp('lvd',c,l,wname,lev,thr,'h');
    features(i,:) = xd(:);
    
end
disp('Features Normalization.');
for i = 1 : size(features,2)
    features(:,i) = features(:,i)-mean(features(:,i));
    features(:,i) = features(:,i)./std(features(:,i));
end
end
