close all;
clc;
clear;
%使用真实掩膜集，对T2时刻的完整影像进行掩膜，模拟缺失数据
%先使用一幅mask进行掩膜
T1_img_path = 'G:\AMSR_E_Data\experiment6\T1\';
T2_img_path = 'G:\AMSR_E_Data\experiment6\T2\';
T3_img_path = 'G:\AMSR_E_Data\experiment6\T3\';
label_img_path = 'G:\AMSR_E_Data\experiment6\T2_label\';

mask_path = 'E:\AMSR_E_Data\mask\';

res_path_t1 = 'G:\AMSR_E_Data\experiment6\Day_S1_T1\';
res_path_t2 = 'G:\AMSR_E_Data\experiment6\Day_S1_T2\';
res_path_t3 = 'G:\AMSR_E_Data\experiment6\Day_S1_T3\';
res_path_label ='G:\AMSR_E_Data\experiment6\Day_S1_T2_label\';

res_path_t1_clip = 'G:\AMSR_E_Data\experiment6\Day_S1_T1_clip\';
res_path_t3_clip = 'G:\AMSR_E_Data\experiment6\Day_S1_T3_clip\';

img_list_T1 = dir(strcat(T1_img_path,'*.tif'));
img_list_T2 = dir(strcat(T2_img_path,'*.tif'));
img_list_T3 = dir(strcat(T3_img_path,'*.tif'));
img_list_label = dir(strcat(label_img_path,'*.tif'));

mask_list = dir(strcat(mask_path,'*.tif'));  % 6幅

%使用多幅掩膜影像遍历（随机）掩膜  6幅
tic
for i=1:length(img_list_T2)
    img_name1 = img_list_T1(i).name;
    img_name2 = img_list_T2(i).name;% 需要掩膜
    img_name3 = img_list_T3(i).name;
    img_name4 = img_list_label(i).name;
    t1_img = double(imread(strcat(T1_img_path,img_name1)));
    t2_img = double(imread(strcat(T2_img_path,img_name2)));
    t3_img = double(imread(strcat(T3_img_path,img_name3)));
    label_img = double(imread(strcat(label_img_path,img_name4)));
    
    for j=1:length(mask_list)
        mask_img = double(imread(strcat(mask_path,mask_list(j).name))); 
        mask_res1 = t1_img.*mask_img;% 点乘
        mask_res2 = t2_img.*mask_img;% 点乘
        mask_res3 = t3_img.*mask_img;% 点乘
        
        
        out_path1 = strcat(res_path_t1,img_name1(1:end-4),'_',num2str(j),'.tif');
        out_path2 = strcat(res_path_t2,img_name2(1:end-4),'_',num2str(j),'.tif');
        out_path3 = strcat(res_path_t3,img_name3(1:end-4),'_',num2str(j),'.tif');
        out_path4 = strcat(res_path_label,img_name4(1:end-4),'_',num2str(j),'.tif');
        
        out_path5 = strcat(res_path_t1_clip,img_name1(1:end-4),'_',num2str(j),'.tif');
        out_path6 = strcat(res_path_t3_clip,img_name3(1:end-4),'_',num2str(j),'.tif');
%       
        % 模拟掩膜
        imwrite2tif(t1_img,[],out_path1,'single','Copyright','MRI', 'Compression',1); 
        imwrite2tif(mask_res2,[],out_path2,'single','Copyright','MRI', 'Compression',1); % 模拟缺失 t2
        imwrite2tif(t3_img,[],out_path3,'single','Copyright','MRI', 'Compression',1); 
        imwrite2tif(label_img,[],out_path4,'single','Copyright','MRI', 'Compression',1); 
        
        imwrite2tif(mask_res1,[],out_path5,'single','Copyright','MRI', 'Compression',1); 
        imwrite2tif(mask_res3,[],out_path6,'single','Copyright','MRI', 'Compression',1); 
        
        disp(i);
        disp(out_path1);
        disp(out_path2);
        disp(out_path3);
        disp(out_path4);
        disp('*****')
    end
end
toc