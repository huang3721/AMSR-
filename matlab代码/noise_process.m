close all;
clc;
clear;
% 对样本数据进行噪声处理
% 对T1 T2 T3 时刻数据进行噪声处理 T2_label保持不变，同时对应增加label影像数量

T1_path = 'G:\AMSR_E_Data\experiment5\T1\'; % 841对
T2_path = 'G:\AMSR_E_Data\experiment5\T2\';
T3_path = 'G:\AMSR_E_Data\experiment5\T3\';  
label_path = 'G:\AMSR_E_Data\experiment5\T2_label\';

t1_imgs = dir(strcat(T1_path,'*.tif'));
t2_imgs = dir(strcat(T2_path,'*.tif'));
t3_imgs = dir(strcat(T3_path,'*.tif'));
label_imgs = dir(strcat(label_path,'*.tif'));

for i = 1:length(t1_imgs)
    t1_img_path = strcat(T1_path,t1_imgs(i).name);
    t2_img_path = strcat(T2_path,t2_imgs(i).name);
    t3_img_path = strcat(T3_path,t3_imgs(i).name);
    label_img_path = strcat(label_path,label_imgs(i).name);
    
    t1_img = imread(t1_img_path);  % 20091231_Day_3_226.tif--->20091231_Day_3_226g1.tif
    t2_img = imread(t2_img_path);  % 20100101_Day_3_226_5.tif--->20100101_Day_3_226_5g1.tif
    t3_img = imread(t3_img_path);  % 20100101_Day_3_226.tif --->20100101_Day_3_226g1.tif
    label_img = imread(label_img_path);
    
    img1_ = imnoise(t1_img,'gaussian',0,0.00007);
    img2_ = imnoise(t2_img,'gaussian',0,0.00007);
    img3_ = imnoise(t3_img,'gaussian',0,0.00007);
    
    str1 =  strcat(t1_img_path(1:end-4),'g','.tif');
    str2 =  strcat(t2_img_path(1:end-4),'g','.tif');
    str3 =  strcat(t3_img_path(1:end-4),'g','.tif');    
    str4 =  strcat(label_img_path(1:end-4),'g','.tif');    
    
    imwrite2tif(img1_ ,[],str1,'single','Copyright','MRI', 'Compression',1);
    imwrite2tif(img2_ ,[],str2,'single','Copyright','MRI', 'Compression',1);
    imwrite2tif(img3_ ,[],str3,'single','Copyright','MRI', 'Compression',1);
    imwrite2tif(label_img ,[],str4,'single','Copyright','MRI', 'Compression',1);
end

% J1 = imnoise(I,'gaussian',0,0.08);
