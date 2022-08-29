close all;
clear;
clc;
allimgs_path = 'E:\遥感影像样本研究项目\微波重建相关资料\AMSR-E原始数据\Day\';
allimgs = dir(strcat(allimgs_path,'*.tif'));

out_path = 'G:\AMSR_E_Data\Day_Normalization2\';

for i=1:length(allimgs)
    imgname = strcat(allimgs_path,allimgs(i).name);
    img = imread(imgname);
    max_value = max(max(img));
    min_value = min(min(img));
    out_name = strcat(out_path,allimgs(i).name);
    % 更换归一化的方式
    %img1 = (img-(min_value-1))/(max_value-min_value); % minmax标准化  0-1,这里避免0的出现
    img1 = (img-100)/200; 
    imwrite2tif(img1 ,[],out_name,'single','Copyright','MRI', 'Compression',1);
    disp(i)
    disp(max(max(img1)));
    disp(min(min(img1)));
end

