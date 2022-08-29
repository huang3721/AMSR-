close all;
clear;
clc;

file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(无NaN)\';%原始数据
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop2\'; %裁切结果文件夹
img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);
tic;
for j = 1:1:img_num  %大循环，遍历每一张影像
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
        % all_chazhi all_queshi的区别为，待重建的T2影像经过空间插值和不经过空间插值
        sub_path_all_chazhi = strcat(crop_image_directory,'\','all_chazhi\');
        sub_path_all_queshi = strcat(crop_image_directory,'\','all_queshi\');
        sub_path_all_pred = strcat(crop_image_directory,'\','all_pred\');
        
        if exist(sub_path_all_chazhi,'dir')
            rmdir(sub_path_all_chazhi,'s');
        end
        mkdir(sub_path_all_chazhi);  
        if exist(sub_path_all_queshi,'dir')
            rmdir(sub_path_all_queshi,'s');
        end
        mkdir(sub_path_all_queshi);
        if exist(sub_path_all_pred,'dir')
            rmdir(sub_path_all_pred,'s');
        end
        mkdir(sub_path_all_pred);
        
        % 添加1行0，使完全裁切  248 * 144  按24*24裁切，步长为4
        add_0 = zeros(1,248);
        img = [image;add_0];
        k = 0;
        [h,w] = size(img);
        for x = 1:4:h-23
            for y = 1:4:w-23
                k=k+1;
                strk=num2str(k);
                str = [strk ,'.tif'];
                str1 = strcat(sub_path_all_chazhi,str);% 相当于T1 T3
                str2 = strcat(sub_path_all_queshi,str);% 待重建 相当于T2
                tmp_img = img(x:x+23, y:y+23);
                if all(all(tmp_img<0))             
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                    imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
                elseif all(all(tmp_img>0))          
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                    imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
                elseif (sum(sum(tmp_img > 0))) > 10  % 大于0值(个数大于10)，需要插值的影像块,写到chazhi文件夹
                    tmp_img2 = tmp_img;
                    tmp_img2(tmp_img2==-1)=0;
                    imwrite2tif(tmp_img2,[],str2,'single','Copyright','MRI', 'Compression',1);% queshi
                    tmp_img(tmp_img == 0) = nan;%转化0值为nan值
                    tmp_img(tmp_img == -1) = nan;%转化-1值为nan值
                    s = size(tmp_img);
                    valid = find(~isnan(tmp_img));
                    [i,p] = ind2sub(s,valid);%把NaN值转换为下标
                    v = tmp_img(valid);
                    [ii,jj] = ndgrid(1:s(1),1:s(2));% 创建一个相同大小的网格
                    chazhi_img = griddata(i,p,v,ii,jj,'nearest');
                    imwrite2tif(chazhi_img,[],str1,'single','Copyright','MRI', 'Compression',1);%chazhi
                else                                
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                    imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
                end
            end
        end
    end
end
toc;



