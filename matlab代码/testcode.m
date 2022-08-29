close all;
clear;
clc;

mask_path = 'G:\AMSR_LST_China\china_mask.tif';
mask = double(imread(mask_path));
add_0 = zeros(1,248);
mask = [mask;add_0];
target_path = 'G:\AMSR_LST_China\china_mask2.tif';

imwrite2tif(mask,[],target_path,'single','Copyright','MRI', 'Compression',1);

