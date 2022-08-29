close all;
clear;
clc;

file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(��NaN)\';%ԭʼ����
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop\'; %���н���ļ���
img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);
tic;
for j = 1:1:img_num  %��ѭ��������ÿһ��Ӱ��
    strj = num2str(j);
    image_name = img_path_list(j).name;
    imagetime = image_name(18:end-8); %��ȡӰ��ʱ�� �ļ�����AMSRE_LST_merged_20100101_Day.tif ��ȡ20100101
    t1_dir = imagetime;%20100101
    t1len = length(t1_dir);
    t1_time = t1_dir(1:t1len);
    [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
    if  (t1h>=1)&&(t1h<=31) %�����·ݵ�Ҫ��
        image = imread(strcat(file_path,image_name));
        crop_image_directory = strcat(crop_file_dir, image_name(18:end-8));%��Ӧÿ����ļ�·��
        
        if exist(crop_image_directory,'dir')
            rmdir(crop_image_directory,'s');
        end
        mkdir(crop_image_directory);   %ÿ��ü�����ļ��� AMSRE_LST_merged_20100101
        
        [h,w] = size(image);% 248 143
        k = 0;
        for x = 1:4:h-23
            for y = 1:4:w-23
                k=k+1;
                strk=num2str(k);
                tmp_img = image(x:x+23, y:y+23);
                % ȫ��-1ֵ����ŵ���ֵ�ļ��У�������0ֵ������Ҫ��ֵ������0����Ҫ��ֵ
                
                if all(all(tmp_img<0))% ȫ��-1,д��edge�ļ���
                    
                elseif all(all(tmp_img>0))% ȫ������0��д��nochazhi�ļ���
                    
                else                      % ��Ҫ��ֵ��Ӱ��� д��chazhi�ļ���   
                    
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

