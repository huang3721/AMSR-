close all;
clear;
clc;

file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(无NaN)\';%原始数据
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop_3\'; %裁切结果文件夹
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
        image = double(imread(strcat(file_path,image_name)));
        crop_image_directory = strcat(crop_file_dir, image_name(18:end-8));%对应每天的文件路径
        
        if exist(crop_image_directory,'dir')
            rmdir(crop_image_directory,'s');
        end
        mkdir(crop_image_directory);   
        
        % 时间文件夹下分为三个文件夹 edge  chazhi   nochazhi
        sub_path_edge = strcat(crop_image_directory,'\','edge\');
        sub_path_chazhi = strcat(crop_image_directory,'\','chazhi\');
        sub_path_wanzheng = strcat(crop_image_directory,'\','wanzheng\');
        sub_path_T2 = strcat(crop_image_directory,'\','T2\');
        
        if exist(sub_path_edge,'dir')
            rmdir(sub_path_edge,'s');
        end
        mkdir(sub_path_edge);  
        if exist(sub_path_chazhi,'dir')
            rmdir(sub_path_chazhi,'s');
        end
        mkdir(sub_path_chazhi);
        if exist(sub_path_wanzheng,'dir')
            rmdir(sub_path_wanzheng,'s');
        end
        mkdir(sub_path_wanzheng);
        if exist(sub_path_T2,'dir')
            rmdir(sub_path_T2,'s');
        end
        mkdir(sub_path_T2);
        
        [h,w] = size(image);% 248 143
        k = 0;
        for x = 1:4:h-23
            for y = 1:4:w-23
                k=k+1;
                strk=num2str(k);
                str = [strk ,'.tif'];
                str1 = strcat(sub_path_edge,str);
                str2 = strcat(sub_path_chazhi,str);
                str3 = strcat(sub_path_wanzheng,str);
                str4 = strcat(sub_path_T2,str);
                tmp_img = image(x:x+23, y:y+23);
                % 全是-1值，则放到空值文件夹；不存在0值，不需要插值；存在0，需要插值
                if all(all(tmp_img<0))              % 全是-1,写到edge文件夹
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                elseif all(all(tmp_img>0))          % 全部大于0，写到wanzheng文件夹
                    imwrite2tif(tmp_img,[],str3,'single','Copyright','MRI', 'Compression',1);
                elseif any(any(tmp_img == 0)) && (sum(sum(tmp_img > 0))) > 10  % 存在0值和大于0值(个数大于10)，需要插值的影像块,写到chazhi文件夹
                    % 待重建
                    imwrite2tif(tmp_img,[],str4,'single','Copyright','MRI', 'Compression',1);
                    
                    tmp_img(tmp_img == 0) = nan;%转化0值为nan值
                    tmp_img(tmp_img == -1) = nan;%转化-1值为nan值
                    s = size(tmp_img);
                    valid = find(~isnan(tmp_img));
                    [i,p] = ind2sub(s,valid);%把NaN值转换为下标
                    v = tmp_img(valid);
                    [ii,jj] = ndgrid(1:s(1),1:s(2));% 创建一个相同大小的网格
                    img = griddata(i,p,v,ii,jj,'nearest');
                    imwrite2tif(img,[],str2,'single','Copyright','MRI', 'Compression',1);
                else                                % 存在-1值，和正常值，无0值，边缘区域，不需要插值
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                end
            end
        end
    end
end
toc;

