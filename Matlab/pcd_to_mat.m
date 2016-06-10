%% open the .PCD
fileID = fopen('../OPiT/gnistangtunneln-semifull-voxelized.pcd','r');

%% skip the header
for k=1:11
    tline = fgets(fileID);
end

%% set the format
formatSpec = '%f %f %f';
sizeA = [3 Inf];

A = fscanf(fileID,formatSpec,sizeA);
A = A.';

fclose(fileID);

%% try to put something atop the point cloud
w_cameracenter  = [143425.5458; 6394339.7282; 35.4776];
p_minrange      = 10;
p_maxrange      = 25;
p_range         = (12:0.2:26);
p_sample        = [239.8354; 207.1412];

%% C matrix -- calibration matrix
K = [1432, 0, 640;
     0, 1432, 480;
     0, 0, 1];

T = [0.936168046306955, -0.07229943085008331, 0.3440380522159919, 143425.5458462106; ...
     -0.3475265283978696, -0.04263812010476335, 0.9367002203339428, 6394339.728225683; ...
     -0.0530537570162973, -0.9964711651687098, -0.06504241580514886, 35.47761542402441; ...
     0, 0, 0, 1];
 
%% calculate 
size_t = size(p_range, 2);
counter = 1;
w_samples = zeros(4, size_t);

for i = p_range
    c_samplemin     = K \ [i * p_sample(1,1); i * p_sample(2,1); i];
    w_samplemin     = T * [c_samplemin; 1];
%     c_samplemax     = K \ [p_maxrange * p_sample(1,1); p_maxrange * p_sample(2,1); p_maxrange];
%     w_samplemax     = T * [c_samplemax; 1];  
%     w_samples       = [w_samplemin(1:3,:) w_samplemax(1:3,:)];
    w_samples(:,counter)  = w_samplemin;
    counter = counter+1;
end

% threshold 0.1 delta_z 0.1 range [15..25]
% w_output        = [ 143425.5458 6394339.7282 35.4776; ...
%                     143425.7050 6394339.9528 35.5748; ...
%                     143426.4609 6394340.3759 35.3052; ...
%                     143426.2820 6394341.0865 35.1930; ...
%                     143426.6524 6394342.1847 35.0957; ...
%                     143425.9659 6394342.9679 36.4973; ...
%                     143426.6897 6394343.5866 36.4533; ...
%                     143426.7589 6394344.2610 38.3915; ...
%                     143427.5726 6394345.0818 38.2862];

% threshold 0.5 delta_z 0.5 range [15..25]
% w_output        = [ 143425.5458 6394339.7282 35.4776; ...                
%                     143426.1352 6394339.8483 35.5904; ...
%                     143426.4918 6394340.0238, 35.8172; ...
%                     143426.2570 6394340.3981 35.9104; ...
%                     143426.5593 6394341.3152 35.7641; ...
%                     143428.2513 6394342.6331 35.4329; ...
%                     143428.5748 6394343.3893 35.6713; ...
%                     143424.8591 6394346.1549 39.7465; ...
%                     143424.6530 6394347.5601 37.8629; ...
%                     143424.6043 6394349.4692 41.3363]; 
                
% w_output        = [ 143425.5458 6394339.7282 35.4776; ...
%                     143426.8770 6394340.0674 36.4723; ...
%                     143427.1853 6394341.0884 36.0889; ...
%                     143428.2329 6394341.9921 35.6395; ...
%                     143427.7359 6394342.7898 36.0100; ...
%                     143428.1049 6394343.6650 35.9862; ...
%                     143428.8203 6394345.3527 35.2654; ...
%                     
%                     143428.7359 6394345.7898 36.0100; ...
%                     143429.1049 6394346.6650 35.9862; ...
%                     143429.3203 6394347.3527 35.2654];
                    
% w_output =  [143442.7589514623 6394357.384494003 38.45321393071208; ...
%              143441.7918847976 6394357.552393478 38.51032425370067; ...
%              143442.5353419967 6394355.829716453 37.80889172409661; ...
%              143440.5975704645 6394358.049696548 38.26112341810949; ...
%              143441.1817530273 6394357.207751897 38.00565783248749];                   

% david
% w_output = [143425.7060847757 6394341.809778472 35.8254541795468; ...
% 143425.6213387786 6394342.198790921 36.75738590757828; ...
% 143425.9221553726 6394343.01877762 36.60048429330345; ...
% 143427.0788233937 6394343.496842822 36.2614647737937; ...
% 143426.8203758195 6394344.523917504 37.63974787830375; ...
% 143423.8547148872 6394348.376707423 35.61277460778365; ...
% 143430.5016557599 6394347.117340458 33.6572561514331; ...
% 143428.5327172012 6394346.689451535 37.57156960922293; ...
% 143427.6966898516 6394348.333398648 36.02265979314689; ...
% 143428.1946601435 6394349.555881571 35.58441123308148];

% % radius search
% w_output = [143425.5458, 6394339.728, 35.4776154; ... 
%             143424.8205, 6394340.213, 37.2237907; ...
%             143426.218, 6394341.563, 34.60970189; ...
%             143427.2086, 6394343.55, 35.30602905; ...
%             143427.1342, 6394343.034, 34.0535811; ...
%             143426.6962, 6394344.134, 35.6169112; ... 
%             143426.5533, 6394344.759, 35.1779440; ... 
%             143426.6285, 6394345.894, 35.6635887; ... 
%             143427.2944, 6394346.462, 35.2829628; ... 
%             143427.0441, 6394347.753, 35.0472081; ... 
%             143428.4532, 6394349.698, 34.6800439; ... 
%             143428.175, 6394350.232, 34.50044262];

% with ROI and SIFT contrast increased
w_output = [ 143426.2045 6394335.749 36.90145663; ...
143426.3883 6394336.459 36.87322653; ...
143426.5066 6394337.188 36.62461157; ...
143426.744 6394338 36.64542378; ...
143427.2106 6394339.058 36.42906708; ...
143427.5356 6394340.316 36.2329521; ...
143427.5301 6394340.935 35.99861425; ...
143427.9676 6394341.881 35.92845121; ...
143427.9158 6394342.649 35.84253094; ...
143428.434 6394343.697 35.75300208; ...
143428.6048 6394344.781 35.56446705; ...
143428.8464 6394345.454 35.56084741; ...
143429.3836 6394346.693 35.33380851; ...
143429.6978 6394347.878 35.31996937; ...
143429.8354 6394348.337 35.25471554; ...
143430.0582 6394349.251 35.15372611; ...
143430.3087 6394350.149 35.11419998; ...
143430.2799 6394350.314 35.0894575; ...
143430.4267 6394350.514 35.15446624; ...
143430.5836 6394351.354 34.86298012; ...
143430.2253 6394349.976 35.27176589; ...
143430.2589 6394350.152 35.13078751; ...
143430.3699 6394350.475 35.15179477; ...
143430.4166 6394351.08 35.07675331; ...
143430.7425 6394352.084 34.7533558; ...
143430.3468 6394351.505 35.04204135; ...
143430.3285 6394350.135 35.18189733; ...
143430.6492 6394350.988 35.09656451; ...
143430.7174 6394351.669 35.00636007; ...
143430.6632 6394351.853 34.94334569];


%% plot to pointcloud
tunnel = pointCloud(A);
pcshow (tunnel); hold on;
% plot3 (w_samples(1,:), w_samples(2,:), w_samples(3,:), '.'); hold on;
plot3 (w_output(:,1), w_output(:,2), w_output(:,3), 'x'); hold on;
plot3 (w_output(:,1), w_output(:,2), w_output(:,3));
% plot3 (143424.5954982183, 6394360.846589573, 40.6789214860592, 'x');
% plot3 (143424.0469000000, 6394361.000000000, 40.2150000000000, 'x');
% plot3 (143448.0625, 6394362.5, 41.6405029296875, 'x');
