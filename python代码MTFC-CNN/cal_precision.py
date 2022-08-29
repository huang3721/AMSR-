#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# @Time    : 2022/8/16 15:55
# @Author  : huangxiaohan
# @Site    : 
# @File    : cal_precision.py
# @Software: PyCharm
import cv2 as cv
import os
import xlsxwriter as xw
import model
from tools_cal_precision import *

def test():

    input1_path = 'E:/AMSR_E_Data/test/T1/'
    input2_path = 'E:/AMSR_E_Data/test/T2/'
    input3_path = 'E:/AMSR_E_Data/test/T3/'
    ori2_path = 'E:/AMSR_E_Data/test/T2_label/'

    mask1_path = 'E:/AMSR_E_Data/mask/mask1.tif'
    mask2_path = 'E:/AMSR_E_Data/mask/mask2.tif'
    mask3_path = 'E:/AMSR_E_Data/mask/mask3.tif'
    mask4_path = 'E:/AMSR_E_Data/mask/mask4.tif'
    mask5_path = 'E:/AMSR_E_Data/mask/mask5.tif'
    mask6_path = 'E:/AMSR_E_Data/mask/mask6.tif'

    model_path = 'E:/delete/'     #模型参数路径，需要修改

    out_path = 'E:/delete/'
    sta_path = 'E:/AMSR_E_Data/test/result_sta9.xlsx'

    image_size = 24
    t1_names = os.listdir(input1_path)
    t2_names = os.listdir(input2_path)
    t3_names = os.listdir(input3_path)
    ori2_names = os.listdir(ori2_path)
    sum = len(t1_names)

    sess = tf.Session()
    x1 = tf.placeholder(tf.float32, [1, image_size, image_size, 1])
    x2 = tf.placeholder(tf.float32, [1, image_size, image_size, 1])
    x3 = tf.placeholder(tf.float32, [1, image_size, image_size, 1])
    pred = model.lst_unet(x1, x2, x3, 5, False)
    checkpoint_dir = model_path
    ckpt = tf.train.get_checkpoint_state(checkpoint_dir)
    saver = tf.train.Saver()
    if ckpt and ckpt.model_checkpoint_path:
        ckpt_name = os.path.basename(ckpt.model_checkpoint_path)
        saver.restore(sess, os.path.join(checkpoint_dir, ckpt_name))

    mask1 = cv.imread(mask1_path, cv.IMREAD_UNCHANGED)
    mask2 = cv.imread(mask2_path, cv.IMREAD_UNCHANGED)
    mask3 = cv.imread(mask3_path, cv.IMREAD_UNCHANGED)
    mask4 = cv.imread(mask4_path, cv.IMREAD_UNCHANGED)
    mask5 = cv.imread(mask5_path, cv.IMREAD_UNCHANGED)
    mask6 = cv.imread(mask6_path, cv.IMREAD_UNCHANGED)

    workbook = xw.Workbook(sta_path)
    worksheet1 = workbook.add_worksheet('mask1')
    worksheet2 = workbook.add_worksheet('mask2')
    worksheet3 = workbook.add_worksheet('mask3')
    worksheet4 = workbook.add_worksheet('mask4')
    worksheet5 = workbook.add_worksheet('mask5')
    worksheet6 = workbook.add_worksheet('mask6')

    worksheet1.write(0, 0, 'day')
    worksheet1.write(0, 2, 'RMSE')
    worksheet1.write(0, 4, 'R2')
    worksheet1.write(0, 6, 'SSIM')
    worksheet1.write(0, 8, 'rmse2')

    worksheet2.write(0, 0, 'day')
    worksheet2.write(0, 2, 'RMSE')
    worksheet2.write(0, 4, 'R2')
    worksheet2.write(0, 6, 'SSIM')
    worksheet2.write(0, 8, 'rmse2')

    worksheet3.write(0, 0, 'day')
    worksheet3.write(0, 2, 'RMSE')
    worksheet3.write(0, 4, 'R2')
    worksheet3.write(0, 6, 'SSIM')
    worksheet3.write(0, 8, 'rmse2')

    worksheet4.write(0, 0, 'day')
    worksheet4.write(0, 2, 'RMSE')
    worksheet4.write(0, 4, 'R2')
    worksheet4.write(0, 6, 'SSIM')
    worksheet4.write(0, 8, 'rmse2')

    worksheet6.write(0, 0, 'day')
    worksheet6.write(0, 2, 'RMSE')
    worksheet6.write(0, 4, 'R2')
    worksheet6.write(0, 6, 'SSIM')
    worksheet6.write(0, 8, 'rmse2')

    worksheet6.write(0, 0, 'day')
    worksheet6.write(0, 2, 'RMSE')
    worksheet6.write(0, 4, 'R2')
    worksheet6.write(0, 6, 'SSIM')
    worksheet6.write(0, 8, 'rmse2')


    m1 = 1
    m2 = 1
    m3 = 1
    m4 = 1
    m5 = 1
    m6 = 1

    mask = mask1
    for i in range(sum):
        t1_name = t1_names[i]
        t2_name = t2_names[i]
        t3_name = t3_names[i]
        ori2_name = ori2_names[i]

        if t2_name[-5] == '1':
            mask = mask1
        elif t2_name[-5] == '2':
            mask = mask2
        elif t2_name[-5] == '3':
            mask = mask3
        elif t2_name[-5] == '4':
            mask = mask4
        elif t2_name[-5] == '5':
            mask = mask5
        elif t2_name[-5] == '6':
            mask = mask6

        t1_path = input1_path + t1_name
        t2_path = input2_path + t2_name
        t3_path = input3_path + t3_name
        t2ori_path = ori2_path + ori2_name

        input1 = cv.imread(t1_path, cv.IMREAD_UNCHANGED)
        input2 = cv.imread(t2_path, cv.IMREAD_UNCHANGED)
        input3 = cv.imread(t3_path, cv.IMREAD_UNCHANGED)
        ori2 = cv.imread(t2ori_path, cv.IMREAD_UNCHANGED)

        sum_num = len(ori2)*len(ori2)

        #mask = mask / 255.0

        input1 = input1.reshape([1, image_size, image_size, 1])
        input2 = input2.reshape([1, image_size, image_size, 1])
        input3 = input3.reshape([1, image_size, image_size, 1])
        mask_temp = mask.reshape([1, image_size, image_size, 1])

        tmp_result = sess.run([pred], feed_dict={x1: input1, x2: input2, x3: input3})
        tmp_result = np.array(tmp_result)
        result = tmp_result.squeeze()  # 去除维度为1的轴

        mask = mask_temp.squeeze()
        ori2 = ori2.squeeze()
        input2 = input2.squeeze()

        image = result*(1-mask) + input2   # 预测图像

        res = (image-ori2)*130   #重建结果与标签的温度差值,放大110倍   缩放到原先DN值 *130

        res_nz =res[res.nonzero()]  # 返回非0的下标，即预测不同的部分 [,,,,,]


        # RMSE 均方根误差
        # R2 决定系数
        # SSIM 结构相似性参数

        num_nz = len(res_nz)

        sqrtt = 0.0

        for j in range(num_nz):
            sqrtt = sqrtt + res_nz[j]*res_nz[j]  # 计算均方根误差

        sqrtt = sqrtt/num_nz
        RMSE= np.sqrt(sqrtt)                 # 仅仅计算预测缺失区域的rmse

        # ssim = compute_ssim(image , ori2)   #结构相似性计算

        result= quantitative_evalu(image,ori2)
        R2 = performance_metric(ori2,image)  # 决定系数
        ssim =compute_ssim(image,ori2)

        rmse2 = lst_evalu(image,ori2,100)   # 计算整张24*24影像的rmse

        if t2_name[-5] == '1':
            worksheet1.write(m1, 0, t2_name)
            worksheet1.write(m1, 2,RMSE)  #RMSE
            worksheet1.write(m1, 4, R2)   # R2 决定系数
            worksheet1.write(m1, 6, ssim)  # SSIM
            worksheet1.write(m1, 8, rmse2) #
            m1 = m1+1
            t1_namep = t2_name

        elif t2_name[-5] == '2':
            worksheet2.write(m2, 0, t2_name)
            worksheet2.write(m2, 2, RMSE)
            worksheet2.write(m2, 4, R2)   #SSIM
            worksheet2.write(m2, 6, ssim)  # SSIM
            worksheet2.write(m2, 8, rmse2)
            m2 = m2 + 1
            t1_namep = t2_name

        elif t2_name[-5] == '3':
            worksheet3.write(m3, 0, t2_name)
            worksheet3.write(m3, 2, RMSE)
            worksheet3.write(m3, 4, R2)   #SSIM
            worksheet3.write(m3, 6, ssim)  # SSIM
            worksheet3.write(m3, 8, rmse2)
            m3 = m3 + 1
            t1_namep = t2_name

        elif t2_name[-5] == '4':
            worksheet4.write(m4, 0, t2_name)
            worksheet4.write(m4, 2, RMSE)
            worksheet4.write(m4, 4, R2)   #SSIM
            worksheet4.write(m4, 6, ssim)  # SSIM
            worksheet4.write(m4, 8, rmse2)
            m4 = m4 + 1
            t1_namep = t2_name

        elif t2_name[-5] == '5':
            worksheet5.write(m5, 0, t2_name)
            worksheet5.write(m5, 2, RMSE)
            worksheet5.write(m5, 4, R2)   #SSIM
            worksheet5.write(m5, 6, ssim)  # SSIM
            worksheet5.write(m5, 8, rmse2)
            m5 = m5 + 1
            t1_namep = t2_name

        elif t2_name[-5] == '6':
            worksheet6.write(m6, 0, t2_name)
            worksheet6.write(m6, 2, RMSE)
            worksheet6.write(m6, 4, R2)   #SSIM
            worksheet6.write(m6, 6, ssim)  # SSIM
            worksheet6.write(m6, 8, rmse2)
            m6 = m6 + 1
            t1_namep = t2_name

        out_pathtmp = out_path + '/'
        out_path1 = out_pathtmp + t1_namep
        cv.imwrite(out_path1, image)
    workbook.close()

if __name__ == '__main__':
    pass