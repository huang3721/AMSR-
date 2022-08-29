close all;
clear;
clc;

file_path = 'G:\AMSR_LST_China\Day_S1_Normalization(��NaN)\';%ԭʼ����
crop_file_dir = 'G:\AMSR_LST_China\Day_S1_crop2\'; %���н���ļ���
img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);
tic;
for j = 1:1:img_num  %��ѭ��������ÿһ��Ӱ��
    image_name = img_path_list(j).name;
    imagetime = image_name(18:end-8); %��ȡӰ��ʱ�� �ļ�����AMSRE_LST_merged_20100101_Day.tif ��ȡ20100101
    t1_dir = imagetime;%20100101
    t1len = length(t1_dir);
    t1_time = t1_dir(1:t1len);
    [t2_time,t1h] = time_add(t1_time,1); % t1_dir == t1_time
    if  (t1h>=1)&&(t1h<=31) %�����·ݵ�Ҫ��
        image = double(imread(strcat(file_path,image_name)));
        crop_image_directory = strcat(crop_file_dir, image_name(18:end-8));%��Ӧÿ����ļ�·��
        
        if exist(crop_image_directory,'dir')
            rmdir(crop_image_directory,'s');
        end
        mkdir(crop_image_directory);   
        % all_chazhi all_queshi������Ϊ�����ؽ���T2Ӱ�񾭹��ռ��ֵ�Ͳ������ռ��ֵ
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
        
        % ���1��0��ʹ��ȫ����  248 * 144  ��24*24���У�����Ϊ4
        add_0 = zeros(1,248);
        img = [image;add_0];
        k = 0;
        [h,w] = size(img);
        for x = 1:4:h-23
            for y = 1:4:w-23
                k=k+1;
                strk=num2str(k);
                str = [strk ,'.tif'];
                str1 = strcat(sub_path_all_chazhi,str);% �൱��T1 T3
                str2 = strcat(sub_path_all_queshi,str);% ���ؽ� �൱��T2
                tmp_img = img(x:x+23, y:y+23);
                if all(all(tmp_img<0))             
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                    imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
                elseif all(all(tmp_img>0))          
                    imwrite2tif(tmp_img,[],str1,'single','Copyright','MRI', 'Compression',1);
                    imwrite2tif(tmp_img,[],str2,'single','Copyright','MRI', 'Compression',1);
                elseif (sum(sum(tmp_img > 0))) > 10  % ����0ֵ(��������10)����Ҫ��ֵ��Ӱ���,д��chazhi�ļ���
                    tmp_img2 = tmp_img;
                    tmp_img2(tmp_img2==-1)=0;
                    imwrite2tif(tmp_img2,[],str2,'single','Copyright','MRI', 'Compression',1);% queshi
                    tmp_img(tmp_img == 0) = nan;%ת��0ֵΪnanֵ
                    tmp_img(tmp_img == -1) = nan;%ת��-1ֵΪnanֵ
                    s = size(tmp_img);
                    valid = find(~isnan(tmp_img));
                    [i,p] = ind2sub(s,valid);%��NaNֵת��Ϊ�±�
                    v = tmp_img(valid);
                    [ii,jj] = ndgrid(1:s(1),1:s(2));% ����һ����ͬ��С������
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



