#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# @Time    : 2022/8/23 15:32
# @Author  : huangxiaohan
# @Site    : 
# @File    : test_sydata.py
# @Software: PyCharm
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2022/8/21 15:21
# @Author  : huangxiaohan
# @File    : cal_precision2.py
# @Software: PyCharm
import time

import cv2 as cv
import os
import xlsxwriter as xw
from tools_cal_precision import *


def getfilename(path, suffix):
    """ 获取指定目录下的所有指定后缀的文件名 """
    file_list = []
    f_list = os.listdir(path)
    f_list.sort(key=lambda x: str(x[:-4]))  # .tif 按照命名进行排序   key=lambda x: int(x[:-4]) 按照大小排序
    # print f_list
    for file in f_list:
        # os.path.splitext():分离文件名与扩展名
        if os.path.splitext(file)[1] == suffix:
            file_list.append(os.path.join(path, file))
    return file_list


def test():
    '''
    输入两个文件夹路径，计算对应影像的r2 rmse
    需要缩放到原图像的DN值范围 单位为K
    rmse = rmse*(max-min)
    '''

    predict_path = 'G:/sy_data/AMSR-E-DAY/2010-S1-test-size24/01-31/dataset1h/temporal2-spline/'
    label_path = 'G:/sy_data/AMSR-E-DAY/2010-S1-test-size24/01-31/dataset1h/origin2/'
    sta_path = 'E:/delete/result.xlsx'

    mask1_path = 'E:/AMSR_E_Data/mask2h/001.tif'
    mask2_path = 'E:/AMSR_E_Data/mask2h/002.tif'
    mask3_path = 'E:/AMSR_E_Data/mask2h/003.tif'
    mask4_path = 'E:/AMSR_E_Data/mask2h/004.tif'
    mask5_path = 'E:/AMSR_E_Data/mask2h/005.tif'
    mask6_path = 'E:/AMSR_E_Data/mask2h/006.tif'
    mask7_path = 'E:/AMSR_E_Data/mask2h/007.tif'
    mask8_path = 'E:/AMSR_E_Data/mask2h/008.tif'
    mask9_path = 'E:/AMSR_E_Data/mask2h/009.tif'


    mask1 = cv.imread(mask1_path, cv.IMREAD_UNCHANGED)
    mask2 = cv.imread(mask2_path, cv.IMREAD_UNCHANGED)
    mask3 = cv.imread(mask3_path, cv.IMREAD_UNCHANGED)
    mask4 = cv.imread(mask4_path, cv.IMREAD_UNCHANGED)
    mask5 = cv.imread(mask5_path, cv.IMREAD_UNCHANGED)
    mask6 = cv.imread(mask6_path, cv.IMREAD_UNCHANGED)
    mask7 = cv.imread(mask7_path, cv.IMREAD_UNCHANGED)
    mask8 = cv.imread(mask8_path, cv.IMREAD_UNCHANGED)
    mask9 = cv.imread(mask9_path, cv.IMREAD_UNCHANGED)

    workbook = xw.Workbook(sta_path)
    worksheet1 = workbook.add_worksheet('mask1')
    worksheet2 = workbook.add_worksheet('mask2')
    worksheet3 = workbook.add_worksheet('mask3')
    worksheet4 = workbook.add_worksheet('mask4')
    worksheet5 = workbook.add_worksheet('mask5')
    worksheet6 = workbook.add_worksheet('mask6')
    worksheet7 = workbook.add_worksheet('mask7')
    worksheet8 = workbook.add_worksheet('mask8')
    worksheet9 = workbook.add_worksheet('mask9')

    worksheet1.write(0, 0, 'predict_img')
    worksheet1.write(0, 1, 'label_img')
    worksheet1.write(0, 3, 'RMSE')
    worksheet1.write(0, 4, 'R2')
    worksheet1.write(0, 5, 'RMSE_area')
    worksheet1.write(0, 6, 'mean_RMSE')
    worksheet1.write(0, 7, 'mean_RMSE_area')
    worksheet1.write(0, 8, 'mean_R2')

    worksheet2.write(0, 0, 'predict_img')
    worksheet2.write(0, 1, 'label_img')
    worksheet2.write(0, 3, 'RMSE')
    worksheet2.write(0, 4, 'R2')
    worksheet2.write(0, 5, 'RMSE_area')
    worksheet2.write(0, 6, 'mean_RMSE')
    worksheet2.write(0, 7, 'mean_RMSE_area')
    worksheet2.write(0, 8, 'mean_R2')

    worksheet3.write(0, 0, 'predict_img')
    worksheet3.write(0, 1, 'label_img')
    worksheet3.write(0, 3, 'RMSE')
    worksheet3.write(0, 4, 'R2')
    worksheet3.write(0, 5, 'RMSE_area')
    worksheet3.write(0, 6, 'mean_RMSE')
    worksheet3.write(0, 7, 'mean_RMSE_area')
    worksheet3.write(0, 8, 'mean_R2')

    worksheet4.write(0, 0, 'predict_img')
    worksheet4.write(0, 1, 'label_img')
    worksheet4.write(0, 3, 'RMSE')
    worksheet4.write(0, 4, 'R2')
    worksheet4.write(0, 5, 'RMSE_area')
    worksheet4.write(0, 6, 'mean_RMSE')
    worksheet4.write(0, 7, 'mean_RMSE_area')
    worksheet4.write(0, 8, 'mean_R2')

    worksheet5.write(0, 0, 'predict_img')
    worksheet5.write(0, 1, 'label_img')
    worksheet5.write(0, 3, 'RMSE')
    worksheet5.write(0, 4, 'R2')
    worksheet5.write(0, 5, 'RMSE_area')
    worksheet5.write(0, 6, 'mean_RMSE')
    worksheet5.write(0, 7, 'mean_RMSE_area')
    worksheet5.write(0, 8, 'mean_R2')

    worksheet6.write(0, 0, 'predict_img')
    worksheet6.write(0, 1, 'label_img')
    worksheet6.write(0, 3, 'RMSE')
    worksheet6.write(0, 4, 'R2')
    worksheet6.write(0, 5, 'RMSE_area')
    worksheet6.write(0, 6, 'mean_RMSE')
    worksheet6.write(0, 7, 'mean_RMSE_area')
    worksheet6.write(0, 8, 'mean_R2')

    worksheet7.write(0, 0, 'predict_img')
    worksheet7.write(0, 1, 'label_img')
    worksheet7.write(0, 3, 'RMSE')
    worksheet7.write(0, 4, 'R2')
    worksheet7.write(0, 5, 'RMSE_area')
    worksheet7.write(0, 6, 'mean_RMSE')
    worksheet7.write(0, 7, 'mean_RMSE_area')
    worksheet7.write(0, 8, 'mean_R2')

    worksheet8.write(0, 0, 'predict_img')
    worksheet8.write(0, 1, 'label_img')
    worksheet8.write(0, 3, 'RMSE')
    worksheet8.write(0, 4, 'R2')
    worksheet8.write(0, 5, 'RMSE_area')
    worksheet8.write(0, 6, 'mean_RMSE')
    worksheet8.write(0, 7, 'mean_RMSE_area')
    worksheet8.write(0, 8, 'mean_R2')

    worksheet9.write(0, 0, 'predict_img')
    worksheet9.write(0, 1, 'label_img')
    worksheet9.write(0, 3, 'RMSE')
    worksheet9.write(0, 4, 'R2')
    worksheet9.write(0, 5, 'RMSE_area')
    worksheet9.write(0, 6, 'mean_RMSE')
    worksheet9.write(0, 7, 'mean_RMSE_area')
    worksheet9.write(0, 8, 'mean_R2')

    m1 = 1
    m2 = 1
    m3 = 1
    m4 = 1
    m5 = 1
    m6 = 1
    m7 = 1
    m8 = 1
    m9 = 1

    avg_m1_rmse1 = 0
    avg_m2_rmse1 = 0
    avg_m3_rmse1 = 0
    avg_m4_rmse1 = 0
    avg_m5_rmse1 = 0
    avg_m6_rmse1 = 0
    avg_m7_rmse1 = 0
    avg_m8_rmse1 = 0
    avg_m9_rmse1 = 0

    avg_m1_rmse2 = 0
    avg_m2_rmse2 = 0
    avg_m3_rmse2 = 0
    avg_m4_rmse2 = 0
    avg_m5_rmse2 = 0
    avg_m6_rmse2 = 0
    avg_m7_rmse2 = 0
    avg_m8_rmse2 = 0
    avg_m9_rmse2 = 0

    avg_m1_r2 = 0
    avg_m2_r2 = 0
    avg_m3_r2 = 0
    avg_m4_r2 = 0
    avg_m5_r2 = 0
    avg_m6_r2 = 0
    avg_m7_r2 = 0
    avg_m8_r2 = 0
    avg_m9_r2 = 0

    pred_imgs_names = getfilename(predict_path, '.tif')
    label_imgs_names = getfilename(label_path, '.tif')

    num = len(pred_imgs_names)

    for i in range(num):
        pred_name = pred_imgs_names[i]
        label_name = label_imgs_names[i]
        pred_img = cv.imread(pred_name, cv.IMREAD_UNCHANGED)
        label_img = cv.imread(label_name, cv.IMREAD_UNCHANGED)

        if pred_name[77] == '1':
            mask = mask1
        elif pred_name[77] == '2':
            mask = mask2
        elif pred_name[77] == '3':
            mask = mask3
        elif pred_name[77] == '4':
            mask = mask4
        elif pred_name[77] == '5':
            mask = mask5
        elif pred_name[77] == '6':
            mask = mask6
        elif pred_name[77] == '7':
            mask = mask7
        elif pred_name[77] == '8':
            mask = mask8
        elif pred_name[77] == '9':
            mask = mask9

        image = (1 - mask) * pred_img + label_img * mask  # 有问题
        res = (image - label_img) * 130  # 缩放到原影像的DN值范围
        res_nz = res[res.nonzero()]
        num_nz = len(res_nz)
        sqrtt = 0.0
        for j in range(num_nz):
            sqrtt = sqrtt + res_nz[j] * res_nz[j]  # 计算均方根误差
        sqrtt = sqrtt / num_nz
        RMSE_area = np.sqrt(sqrtt)  # 仅仅计算预测缺失区域的rmse


        R2 = performance_metric(label_img, pred_img)  # 决定系数
        RMSE = lst_evalu(pred_img, label_img, 130)  #放大到 K

        if pred_name[77] == '1':
            worksheet1.write(m1, 0, pred_name)
            worksheet1.write(m1, 1, label_name)
            worksheet1.write(m1, 3, RMSE)  # RMSE
            worksheet1.write(m1, 4, R2)  # R2 决定系数
            worksheet1.write(m1, 5, RMSE_area)  # SSIM

            m1 = m1 + 1
            avg_m1_rmse1 += RMSE
            avg_m1_rmse2 += RMSE_area
            avg_m1_r2 += R2

        elif pred_name[77] == '2':
            worksheet2.write(m2, 0, pred_name)
            worksheet2.write(m2, 1, label_name)
            worksheet2.write(m2, 3, RMSE)  # RMSE
            worksheet2.write(m2, 4, R2)  # R2 决定系数
            worksheet2.write(m2, 5, RMSE_area)  # SSIM
            m2 = m2 + 1
            avg_m2_rmse1 += RMSE
            avg_m2_rmse2 += RMSE_area
            avg_m2_r2 += R2

        elif pred_name[77] == '3':
            worksheet3.write(m3, 0, pred_name)
            worksheet3.write(m3, 1, label_name)
            worksheet3.write(m3, 3, RMSE)  # RMSE
            worksheet3.write(m3, 4, R2)  # R2 决定系数
            worksheet3.write(m3, 5, RMSE_area)  # SSIM
            m3 = m3 + 1
            avg_m3_rmse1 += RMSE
            avg_m3_rmse2 += RMSE_area
            avg_m3_r2 += R2

        elif pred_name[77] == '4':
            worksheet4.write(m4, 0, pred_name)
            worksheet4.write(m4, 1, label_name)
            worksheet4.write(m4, 3, RMSE)  # RMSE
            worksheet4.write(m4, 4, R2)  # R2 决定系数
            worksheet4.write(m4, 5, RMSE_area)  # SSIM
            m4 = m4 + 1
            avg_m4_rmse1 += RMSE
            avg_m4_rmse2 += RMSE_area
            avg_m4_r2 += R2

        elif pred_name[77] == '5':
            worksheet5.write(m5, 0, pred_name)
            worksheet5.write(m5, 1, label_name)
            worksheet5.write(m5, 3, RMSE)  # RMSE
            worksheet5.write(m5, 4, R2)  # R2 决定系数
            worksheet5.write(m5, 5, RMSE_area)  # SSIM
            m5 = m5 + 1
            avg_m5_rmse1 += RMSE
            avg_m5_rmse2 += RMSE_area
            avg_m5_r2 += R2

        elif pred_name[77] == '6':
            worksheet6.write(m6, 0, pred_name)
            worksheet6.write(m6, 1, label_name)
            worksheet6.write(m6, 3, RMSE)  # RMSE
            worksheet6.write(m6, 4, R2)  # R2 决定系数
            worksheet6.write(m6, 5, RMSE_area)  # SSIM
            m6 = m6 + 1
            avg_m6_rmse1 += RMSE
            avg_m6_rmse2 += RMSE_area
            avg_m6_r2 += R2

        elif pred_name[77] == '7':
            worksheet7.write(m7, 0, pred_name)
            worksheet7.write(m7, 1, label_name)
            worksheet7.write(m7, 3, RMSE)  # RMSE
            worksheet7.write(m7, 4, R2)  # R2 决定系数
            worksheet7.write(m7, 5, RMSE_area)  # SSIM
            m7 = m7 + 1
            avg_m7_rmse1 += RMSE
            avg_m7_rmse2 += RMSE_area
            avg_m7_r2 += R2

        elif pred_name[77] == '8':
            worksheet8.write(m8, 0, pred_name)
            worksheet8.write(m8, 1, label_name)
            worksheet8.write(m8, 3, RMSE)  # RMSE
            worksheet8.write(m8, 4, R2)  # R2 决定系数
            worksheet8.write(m8, 5, RMSE_area)  # SSIM
            m8 = m8 + 1
            avg_m8_rmse1 += RMSE
            avg_m8_rmse2 += RMSE_area
            avg_m8_r2 += R2

        elif pred_name[77] == '9':
            worksheet9.write(m9, 0, pred_name)
            worksheet9.write(m9, 1, label_name)
            worksheet9.write(m9, 3, RMSE)  # RMSE
            worksheet9.write(m9, 4, R2)  # R2 决定系数
            worksheet9.write(m9, 5, RMSE_area)  # SSIM
            m9 = m9 + 1
            avg_m9_rmse1 += RMSE
            avg_m9_rmse2 += RMSE_area
            avg_m9_r2 += R2

    avg_m1_rmse1 = avg_m1_rmse1 / (m1 - 1)
    avg_m2_rmse1 = avg_m2_rmse1 / (m2 - 1)
    avg_m3_rmse1 = avg_m3_rmse1 / (m3 - 1)
    avg_m4_rmse1 = avg_m4_rmse1 / (m4 - 1)
    avg_m5_rmse1 = avg_m5_rmse1 / (m5 - 1)
    avg_m6_rmse1 = avg_m6_rmse1 / (m6 - 1)
    avg_m7_rmse1 = avg_m7_rmse1 / (m7 - 1)
    avg_m8_rmse1 = avg_m8_rmse1 / (m8 - 1)
    avg_m9_rmse1 = avg_m9_rmse1 / (m9 - 1)

    avg_m1_rmse2 = avg_m1_rmse2 / (m1 - 1)
    avg_m2_rmse2 = avg_m2_rmse2 / (m2 - 1)
    avg_m3_rmse2 = avg_m3_rmse2 / (m3 - 1)
    avg_m4_rmse2 = avg_m4_rmse2 / (m4 - 1)
    avg_m5_rmse2 = avg_m5_rmse2 / (m5 - 1)
    avg_m6_rmse2 = avg_m6_rmse2 / (m6 - 1)
    avg_m7_rmse2 = avg_m7_rmse2 / (m7 - 1)
    avg_m8_rmse2 = avg_m8_rmse2 / (m8 - 1)
    avg_m9_rmse2 = avg_m9_rmse2 / (m9 - 1)

    avg_m1_r2 = avg_m1_r2 / (m1 - 1)
    avg_m2_r2 = avg_m2_r2 / (m2 - 1)
    avg_m3_r2 = avg_m3_r2 / (m3 - 1)
    avg_m4_r2 = avg_m4_r2 / (m4 - 1)
    avg_m5_r2 = avg_m5_r2 / (m5 - 1)
    avg_m6_r2 = avg_m6_r2 / (m6 - 1)
    avg_m7_r2 = avg_m7_r2 / (m7 - 1)
    avg_m8_r2 = avg_m8_r2 / (m8 - 1)
    avg_m9_r2 = avg_m9_r2 / (m9 - 1)

    worksheet1.write(1, 6, avg_m1_rmse1)
    worksheet1.write(1, 7, avg_m1_rmse2)
    worksheet1.write(1, 8, avg_m1_r2)

    worksheet2.write(1, 6, avg_m2_rmse1)
    worksheet2.write(1, 7, avg_m2_rmse2)
    worksheet2.write(1, 8, avg_m2_r2)

    worksheet3.write(1, 6, avg_m3_rmse1)
    worksheet3.write(1, 7, avg_m3_rmse2)
    worksheet3.write(1, 8, avg_m3_r2)

    worksheet4.write(1, 6, avg_m4_rmse1)
    worksheet4.write(1, 7, avg_m4_rmse2)
    worksheet4.write(1, 8, avg_m4_r2)

    worksheet5.write(1, 6, avg_m5_rmse1)
    worksheet5.write(1, 7, avg_m5_rmse2)
    worksheet5.write(1, 8, avg_m5_r2)

    worksheet6.write(1, 6, avg_m6_rmse1)
    worksheet6.write(1, 7, avg_m6_rmse2)
    worksheet6.write(1, 8, avg_m6_r2)

    worksheet7.write(1, 6, avg_m7_rmse1)
    worksheet7.write(1, 7, avg_m7_rmse2)
    worksheet7.write(1, 8, avg_m7_r2)

    worksheet8.write(1, 6, avg_m8_rmse1)
    worksheet8.write(1, 7, avg_m8_rmse2)
    worksheet8.write(1, 8, avg_m8_r2)

    worksheet9.write(1, 6, avg_m9_rmse1)
    worksheet9.write(1, 7, avg_m9_rmse2)
    worksheet9.write(1, 8, avg_m9_r2)

    workbook.close()


if __name__ == '__main__':
    print('运行中....')
    start = time.time()
    test()
    end = time.time()
    print('\n运行结束.耗时:{}s'.format(end-start))
