close all;
clear;
clc;

file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(无NaN)\';%原始数据
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop\'; %裁切结果文件夹
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
        crop_image_directory = strcat(crop_file_dir, image_name(18:end-8));%对应每天的文件路径
        
        if exist(crop_image_directory,'dir')
            rmdir(crop_image_directory,'s');
        end
        mkdir(crop_image_directory);   %每天裁剪结果文件夹 AMSRE_LST_merged_20100101
        
        [h,w] = size(image);% 248 143
        k = 0;
        for x = 1:4:h-23
            for y = 1:4:w-23
                k=k+1;
                strk=num2str(k);
                tmp_img = image(x:x+23, y:y+23);
                % 全是-1值，则放到空值文件夹；不存在0值，不需要插值；存在0，需要插值
                
                if all(all(tmp_img<0))% 全是-1,写到edge文件夹
                    
                elseif all(all(tmp_img>0))% 全部大于0，写到nochazhi文件夹
                    
                else                      % 需要插值的影像块 写到chazhi文件夹   
                    
                end

                str2 = [strk ,'.tif'];
                crop_image_directory = strcat(crop_image_directory,'\');
                str2 = strcat(crop_image_directory,str2);
                imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
            end
        end
    end
end
toc;

