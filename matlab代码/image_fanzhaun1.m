close all;
clc;
clear;
% image=imread('E:\2010-S1\crop40-day-valid\20100301\88.tif ');%�ļ��������Լ���Ŷ
% out_path ='C:\Users\wupenghai\Desktop\fanzhuan\';

% % str1 = ['C:\Users\wupenghai\Desktop\bingqing-mask\mask_02--.tif'];
% % str2 = ['C:\Users\wupenghai\Desktop\bingqing-mask\mask_02.tif'];

% % % for k=1:3
% image_H = flipud(image);  %���·�תflip up and down
% 
% % I2=imnoise(I1,'gaussian'); %��Ӹ�˹����(�ı�����Ԫֵ��
% % image_L = rot90(image)  %��ת90��
% image_T = imrotate(image,20,'nearest') ; %��ת45�Ȼ�����Ƕ�
% image_V = fliplr(image);%���ҷ�ת filp left and right
%  str2=strcat(out_path,image_name);
% imwrite2tif(image_T ,[],str2,'single','Copyright',...
%                         'MRI', 'Compression',1);
% imgdata = im2double(img1);
% P1= 1 * (imgdata .^ 2.0);  %�ı���Ԫֵ���жԱȶ���ǿ

% imwrite2tif(image_A,[],str1,'single','Copyright','MRI', 'Compression',1);
% imwrite2tif(image_B,[],str2,'single','Copyright','MRI', 'Compression',1);


image_path='I:\С����1�������\AMSR-data-Day\333\';
out_path ='H:\AMSR-E��������ʵ��\2010-S1\333-fanzhuan\';

 
if exist(out_path,'dir')
    rmdir(out_path,'s');
end
mkdir(out_path);


degree = 0;

for i =1:1:1
%      out_image_directory = out_path;
     out_image_directory = strcat(out_path, num2str(degree));   %��0�ȿ�ʼ,ÿ��3����תһ��
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





 
