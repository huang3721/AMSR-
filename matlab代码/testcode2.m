close all;
clear;
clc;
% 修改区域外为-1，区域缺失值为0
% mask_path = 'G:\AMSR_LST_China\china_mask.tif';
% mask = double(imread(mask_path));
% 
% file_path = 'G:\AMSR_E_Data\Day_Normalization2(img-100)200\';
% out_path = 'G:\AMSR_LST_China\Day_Normalization(无NaN)\';
% img_list = dir(strcat(file_path,'*.tif'));
% 
% for i = 1:length(img_list)
%     img = double(imread(strcat(file_path,img_list(i).name)));
%     img(isnan(img)) = -2;
%     r = mask.*img;
%     r(r==0)=-1;
%     r(r==-2)=0;
%     imwrite2tif(r ,[],strcat(file_path,img_list(i).name),'single','Copyright','MRI', 'Compression',1);
% end
% 
% 
% 
% img_path = 'G:\AMSR_LST_China\Day_Normalization\AMSRE_LST_merged_20091231_Day.tif';



file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(无NaN)\';%原始数据
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop2\'; %裁切结果文件夹
img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);
tic;
for j = 1:1:img_num  %大循环，遍历每一张影像
    strj = num2str(j);
    image_name = img_path_list(j).name;
    image = double(imread(strcat(file_path,image_name)));
    add_0 = zeros(1,248);
    img = [image;add_0];
    k = 0;
    [h,w] = size(img);
    for x = 1:4:h-23
        for y = 1:4:w-23
            k=k+1;
            strk=num2str(k);
            tmp_img = img(x:x+23, y:y+23);
        end
    end   
end
toc;







% img = double(imread(img_path));
% img(isnan(img)) = -2;
% r = mask.*img;
% r(r==0)=-1;
% r(r==-2)=0;
% 
% figure
% subplot(1,3,1);imagesc(img);
% subplot(1,3,2);imagesc(mask);
% subplot(1,3,3);imagesc(r);


