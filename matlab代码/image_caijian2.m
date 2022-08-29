close all;
clear;
clc;
%裁剪代码。对所有的影像进行滑动裁剪，对像素块进行归一化，剔除含NaN值的像素块

for i = 1:1:1
    file_path = 'G:\AMSR_E_Data\experiment5\Day_S1_enhance\';%原始数据
    crop_image_directory = 'G:\AMSR_E_Data\experiment5\Day_S1_enhance_clip\'; %裁切结果文件夹
%% 裁剪数据
    tic;
    img_path_list = dir(strcat(file_path,'*.tif'));
    img_num = length(img_path_list);
    for j = 1:1:img_num  %大循环，遍历每一张影像
        strj = num2str(j);
        image_name = img_path_list(j).name; % 20091231_Day_0.tif
        imagetime = image_name(1:end-4); 
        t1_dir = imagetime;%20100101
        t1len = length(t1_dir);
        t1_time = t1_dir(1:t1len);
        [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
        if  (t1h>=1)&&(t1h<=31) %满足月份的要求
            image = imread(strcat(file_path,image_name));
            add_0 = zeros(1,248);
            img = [image;add_0];
            [h,w] = size(ime);
            k = 0;
            for x = 1:4:h-23   %248列均被裁剪
                for y = 1:4:w-23
                    k=k+1;
                    strk=num2str(k);
                    tmp_img = img(x:x+23, y:y+23); % 117：117+23 117：140 最后3行未被裁剪。添加一行0即可。248*144
                    col_1 = all(tmp_img>0);  %旋转后填充从背景值为0,去除0
                    no_1 = all(col_1);
                    col_0 = all(~isnan(tmp_img));  %各列无NaN 返回1
                    no_0 = all(col_0);%所有像素点无空值，返回1
                    if  no_0==1&&no_1==1 %满足条件
                            str2 = strcat(crop_image_directory,image_name(1:end-4),'_',strk,'.tif');
                            tmp_img = (tmp_img-100)/200; % “归一化”
                            imwrite2tif(tmp_img,[],str2,'single','Copyright',...
                               'MRI', 'Compression',1);
                            disp(str2)
                     end
                end
            end
        end
    end
    toc;
end
