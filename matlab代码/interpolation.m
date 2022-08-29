close all;
clc;
clear;
warning off;
%% griddata 'nearest'����
% t1_img_path = 'G:\AMSR_E_Data\test5\T1_clip\20100304_Day_84_380_3.tif';% ȱʧ
% t2_img_path = 'G:\AMSR_E_Data\test5\T1\20100304_Day_84_380_3.tif';% ��ǩ
% 
% t3_img = double(imread(t1_img_path));
% t2_img = double(imread(t2_img_path));
% t1_img = double(imread(t1_img_path));
% 
% t3_img(t3_img == 0)= NaN;
% t1_img(t1_img == 0)= NaN;
% 
% s = size(t1_img);
% valid = find(~isnan(t1_img));% �ڼ���
% [i,j] = ind2sub(s,valid);%��NaNֵת��Ϊ�±�
% v = t1_img(valid);% ֵ
% 
% [ii,jj] = ndgrid(1:24,1:24);
% img1 = griddata(i,j,v,ii,jj,'nearest');
% img2 = griddata(i,j,v,ii,jj,'v4');
% img3 = griddata(i,j,v,ii,jj,'linear');
% img4 = griddata(i,j,v,ii,jj,'natural');
% %meshc(ii,jj,img2);
% figure
% subplot(2,3,1);imagesc(t3_img);colorbar;title('griddata-nearest-queshi');% ȱʧͼ��
% subplot(2,3,2);imagesc(t2_img);colorbar;title('griddata-nearest-label');% ��ǩͼ��
% 
% subplot(2,3,3);imagesc(img1);colorbar;title('griddata-nearest-chazhi');% ��ֵͼ��
% subplot(2,3,4);imagesc(img2);colorbar;title('griddata-v4-chazhi');% ȱʧͼ��
% subplot(2,3,5);imagesc(img3);colorbar;title('griddata-linear-chazhi');% ȱʧͼ��
% subplot(2,3,6);imagesc(img4);colorbar;title('griddata-natural-chazhi');% ȱʧͼ��

% ��ֵ����
file_path = 'G:\AMSR_LST_China\Day_S1_crop_2\20100323\chazhi\';
out_path = 'G:\AMSR_LST_China\Day_S1_crop_2\20100323\chazhi2\';

img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);

nameCell = cell(img_num,1);
for i = 1:img_num
    nameCell{i} = img_path_list(i).name;
end
img_path_list = sort_nat(nameCell);% ����
%% griddata
for k=1:1:img_num
    image_name = img_path_list{k};
    image = imread(strcat(file_path,image_name));
    image = double(image);
    
    % ����0�ģ�������ȱʧ����Ľ��в�ֵ
    if any(any(image==0))
        image(image == 0) = nan;%ת��0ֵΪnanֵ
        image(image == -1) = nan;%ת��-1ֵΪnanֵ
        s = size(image);
        valid = find(~isnan(image));
        [i,j] = ind2sub(s,valid);%��NaNֵת��Ϊ�±�
        v = image(valid);
        [ii,jj] = ndgrid(1:s(1),1:s(2));% ����һ����ͬ��С������
        img = griddata(i,j,v,ii,jj,'nearest');
        str2 = strcat(out_path,image_name);
        imwrite2tif(img,[],str2,'single','Copyright','MRI', 'Compression',1);
    end
    

end
%% interp2 ��spline������
% x=[0,0.4 ,0.5,0.75,1];
% y=[620,700,800,900,1000];
% z=[0.00214      0.01025        0.01681        0.02331        0.02644        
%    0.00236        0.01039        0.01717        0.02375        0.02711        
%    0.00286        0.01058        0.01739        0.02411        0.02792        
%    0.00328        0.01072        0.01747        0.02442        0.02878        
%    0.00369        0.0108         0.01761         0.02481        0.0295      ];
% 
% xi=linspace(0,1,100); 
% yi=linspace(600,1000,80);
% 
% [xii,yii]=meshgrid(xi,yi); 
% 
% zii=interp2(x,y,z,xii,yii,'linear');
% zii1=interp2(x,y,z,xii,yii,'spline');
% zii2=interp2(x,y,z,xii,yii,'nearest');
% zii3=griddata(x,y,z,xii,yii,'v4');
% 
% subplot(2,2,1);mesh(xii,yii,zii),title('interp2 ���Բ�ֵ');%��ͼ�����ñ���
% subplot(2,2,2);mesh(xii,yii,zii1),title('interp2 ����������ֵ');
% subplot(2,2,3);mesh(xii,yii,zii2),title('interp2 �ٽ����ֵ');
% subplot(2,2,4);mesh(xii,yii,zii3),title('griddata'); 