close all;
clear;
clc;
int = 0;
num=0;
%裁剪代码。对所有的影像进行滑动裁剪，对像素块进行归一化，提出含NaN值的像素块

max_value = 0;
min_value = 0;


for i = 1:1:1
    file_path = 'E:\AMSR_E_Data\Day_S1\';%原始数据
    crop_file_dir = 'E:\AMSR_E_Data\test\day1_crop\'; %裁切结果文件夹

%% 裁剪数据
    img_path_list = dir(strcat(file_path,'*.tif'));
    img_num = length(img_path_list);
    tic;
    for j = 1:1:img_num  %大循环，遍历每一张影像
        strj = num2str(j);
        image_name = img_path_list(j).name;
        imagetime = image_name(18:end-8); %截取影像时间 文件名：AMSRE_LST_merged_20100101_Day.tif 获取20100101
        t1_dir = imagetime;%20100101
        t1len = length(t1_dir);
        t1_time = t1_dir(1:t1len);
        [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
        if  (t1h>=1)&&(t1h<=31) %满足月份的要求
            image = imread(strcat(file_path,image_name));
            max_value = max(max(image));
            min_value = min(min(image));
            crop_image_directory = strcat(crop_file_dir, image_name(1:end-8));%对应每天的文件路径            
            if exist(crop_image_directory,'dir')
                rmdir(crop_image_directory,'s');
            end
            mkdir(crop_image_directory);   %每天裁剪结果文件夹 AMSRE_LST_merged_20100101   
            [h,w] = size(image);
            k = 0;
            for x = 1:4:h-23   %步长为4,若影像无缺失值，像素块数量应为
                for y = 1:4:w-23
                    k=k+1;
                    strk=num2str(k);
                    tmp_img = image(x:x+23, y:y+23);
                    col_0 = all(~isnan(tmp_img));  %各列无NaN 返回1
                    %col_1 = all(tmp_img>218);%各像素值大于218，去除温度较低的异常值
                    no_0 = all(col_0);%所有像素点无空值，返回1
                    %no_1 = all(col_1);%所有像素值大于218 返回1
                    if  no_0 ==1
                        tmp_img =single(tmp_img-170)/(336-178);  %“归一化”
                        str2 = [strk ,'.tif'];
                        crop_image_directory = strcat(crop_image_directory,'\');
                        str2 = strcat(crop_image_directory,str2);
                        imwrite2tif(tmp_img,[],str2,'single','Copyright',...
                            'MRI', 'Compression',1);%保存（分日期保存，24*24像素块均无空值）
                    end
                    %tmp_img =single(tmp_img-213)/130;  %“归一化” 
                end
            end
         end

    end
    toc;
end
