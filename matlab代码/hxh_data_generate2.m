close all;
clc;
clear;
%将所有影像存放Day_S1_All文件夹中
%遍历Day_S1_All文件夹所有影像
%对于影像20100103_500.tif，若存在20100104_500.tif，20100105_500.tif
%则分别保存三者到T1 T2 T3文件夹中
all_imgs_path = 'G:\AMSR_E_Data\experiment4\Day_S1_345_clip\';
T1_path = 'G:\AMSR_E_Data\experiment4\Day_S1_T1\';
T2_path = 'G:\AMSR_E_Data\experiment4\Day_S1_T2\';
T3_path = 'G:\AMSR_E_Data\experiment4\Day_S1_T3\'; %先构建数据对，后面再进行模拟缺失区域
imgs_list = dir(strcat(all_imgs_path,'*.tif'));
n = 0;
for i = 1:length(imgs_list)
    img1_name = imgs_list(i).name;
    img1_time = img1_name(1:8);%时间编号


    
    [img2_time,tday2] = time_add(img1_time,1);% 后一天T2
    [img3_time,tday3] = time_add(img2_time,1);% 后两天T3
    
    %img2_name1-4,img3_name1-4各自至少存在一个即可组成T1 T2 T3
    img2_name1 = strcat(all_imgs_path,img2_time,img1_name(9:end));
    img3_name1 = strcat(all_imgs_path,img3_time,img1_name(9:end));
    img1_nameall = strcat(all_imgs_path,img1_name);
    
    if exist(img2_name1,'file')&&exist(img3_name1,'file')
        n = n+1;
        disp(['第',num2str(n),'对：',img1_nameall,',',img2_name1,',',img3_name1]);
        disp('***')
        
        %copyfile(img1_nameall,T1_path);
        %copyfile(img2_name1,T2_path);
        %copyfile(img3_name1,T3_path);
    end
end
