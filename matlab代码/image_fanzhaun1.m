close all;
clc;
clear;
% image=imread('E:\2010-S1\crop40-day-valid\20100301\88.tif ');%文件名是你自己的哦
% out_path ='C:\Users\wupenghai\Desktop\fanzhuan\';

% % str1 = ['C:\Users\wupenghai\Desktop\bingqing-mask\mask_02--.tif'];
% % str2 = ['C:\Users\wupenghai\Desktop\bingqing-mask\mask_02.tif'];

% % % for k=1:3
% image_H = flipud(image);  %上下翻转flip up and down
% 
% % I2=imnoise(I1,'gaussian'); %添加高斯噪声(改变了像元值）
% % image_L = rot90(image)  %旋转90度
% image_T = imrotate(image,20,'nearest') ; %旋转45度或任意角度
% image_V = fliplr(image);%左右翻转 filp left and right
%  str2=strcat(out_path,image_name);
% imwrite2tif(image_T ,[],str2,'single','Copyright',...
%                         'MRI', 'Compression',1);
% imgdata = im2double(img1);
% P1= 1 * (imgdata .^ 2.0);  %改变像元值进行对比度增强

% imwrite2tif(image_A,[],str1,'single','Copyright','MRI', 'Compression',1);
% imwrite2tif(image_B,[],str2,'single','Copyright','MRI', 'Compression',1);


image_path='I:\小论文1相关资料\AMSR-data-Day\333\';
out_path ='H:\AMSR-E白天数据实验\2010-S1\333-fanzhuan\';

 
if exist(out_path,'dir')
    rmdir(out_path,'s');
end
mkdir(out_path);


degree = 0;

for i =1:1:1
%      out_image_directory = out_path;
     out_image_directory = strcat(out_path, num2str(degree));   %从0度开始,每隔3度旋转一次
     out_image_directory = strcat( out_image_directory,'\');
  
     if exist(out_image_directory,'dir')
        rmdir(out_image_directory,'s');
     end
     mkdir(out_image_directory); 

     img_path_list = dir(strcat(image_path, '*.tif'));
     img_num = length(img_path_list);
     
     for j =1:1:img_num
        image_name = img_path_list(j).name; 
        image = imread(strcat(image_path,image_name));
        image_1=imrotate(image,degree ,'nearest') ;
        str2=strcat(out_image_directory ,image_name(1:end-4), '.tif' );
%       str2=strcat(out_image_directory, image_name(1:end-5), '180', '.tif');
        imwrite2tif(image_1 ,[],str2,'single','Copyright',...
                                'MRI', 'Compression',1);
     end
     degree = degree + 30;
end





 
