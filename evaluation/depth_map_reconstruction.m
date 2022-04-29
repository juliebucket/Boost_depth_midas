clc;
clear

%% 
evaluation_name ='R0';


%% Fill in the needed path and flags for evaluation
estimation_path =sprintf('./output_for_matlab_all_crop/no_PSF/crop_after/%s',evaluation_name)

gt_depth_path = './gt/gt_crop'; 
evaluation_matfile_save_dir = './results/no_PSF/crop_after';
dataset_disp_gttype = false; %% (True) for gt disparity (False) for gt depth 
superpixel_scale = 1; % use 0.2 for middleburry and 1 for ibims1 and NYU %Used for rescaling the image before extracting superpixel centers for D3R error metric. smaller scale for high res images results in a faster evaluation.
%%

imglist = dir(fullfile(gt_depth_path,'*.png'));
fprintf('Estimation path: %s\nGT path: %s\nGT type:%d (0:depth 1:disparity)\nTotal number of images: %d \n',estimation_path,gt_depth_path,dataset_disp_gttype,numel(imglist))

for img=1:numel(imglist)
    imagename = imglist(img).name;
    gt_depth = im2double(imread(fullfile(gt_depth_path,sprintf('%s',imagename))));
        %depth=imread(fullfile(gt_depth_path,sprintf('%s',imagename)));
    depth=rgb2gray(gt_depth);
        
    gt_depth(gt_depth==0)=nan;
    
    
    m=min(gt_depth,[],'all') 
    me=mean(gt_depth(isnan(gt_depth)==false),'all')
    Max=max(gt_depth,[],'all') 
    gt_disp = 1./gt_depth;
    %gt_disp(isnan(gt_disp)==true)=0;
    %I=imcomplement(gt_depth);
    %figure;imshow(I);
    
    M=max(gt_disp,[],'all')   
        
    gt_disp = gt_disp / max(gt_disp(:));
    figure; histogram(gt_disp)
        
    gt_depth(gt_disp>1)=nan;
    gt_disp(gt_disp>1)=nan;
    max_gt_disp = max(gt_disp(:))
    min_gt_disp = min(gt_disp(:))
    min_gt_disp = min(gt_disp(:));
    
    gt_disp = rescale(gt_disp,0,1);
    
    median_gt_disp = median(gt_disp(isnan(gt_disp)==false))
        
    save_path=fullfile('./gt/gt_crop_disp',sprintf('%s',imagename))
        

    imwrite(gt_disp,save_path);
    gt_disp = rescale(gt_disp,0,1);
    gt_depth = rescale(gt_depth,0,1);
        
        
    
        
    estimate_disp = im2double(imread(fullfile(estimation_path,sprintf('%s',imagename))));
    %estimate_disp = cat(3,estimate_disp1,estimate_disp1,estimate_disp1);
    
end
