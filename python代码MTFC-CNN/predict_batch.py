#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# @Time    : 2022/8/26 17:37
# @Author  : huangxiaohan
# @Site    : 
# @File    : predict_batch.py
# @Software: PyCharm
from PIL import Image
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt

'''
批量重建不同日期影像
'''
from model import *
import cv2 as cv
import os

def get_data(path,name):
    img_size = 24
    t1_names = os.listdir(path+name)
    t1_names.sort(key=lambda x: int(x[:-4]))
    T1 = []
    num = len(t1_names)
    for i in range(num):
        t1_name = t1_names[i]
        t1_img = cv.imread(path+name+t1_name, cv.IMREAD_UNCHANGED)
        t1_img = t1_img.reshape([img_size, img_size,1])
        T1.append(t1_img)
    T1 = np.array(T1)
    return T1

# 返回时间文件夹列表
def get_dir(path):
    file_list = []
    dir_list = os.listdir(path)
    for file in dir_list:
        file_list.append(os.path.join(path,file))
    return file_list



path = 'G:/AMSR_LST_China/Day_S1_crop/'
dir_list =get_dir(path)
num = len(dir_list)

checkpoint_save_path = "./checkpoint/07.ckpt"
model = MTFC_model()
model.load_weights(checkpoint_save_path)

for n in range(1,num-1):
    print('{}处理中...'.format(dir_list[n]))
    t1_path = dir_list[n - 1]
    t2_path = dir_list[n]
    t3_path = dir_list[n + 1]

    t1_imgs = get_data(t1_path, '/all_chazhi/')
    t2_imgs = get_data(t2_path, '/all_queshi/')
    t3_imgs = get_data(t3_path, '/all_chazhi/')

    concat_1 = tf.concat([t1_imgs, t3_imgs], 3)
    add_1 = tf.concat([concat_1, t2_imgs], 3)
    add_2 = concat_1 + t2_imgs
    test = tf.concat([add_1, add_2], 3)
    test_img = np.array(test)


    result = model.predict(test_img)  # (,24,24,1)

    out_path = t2_path+'/all_pred/'

    f_list = os.listdir(t2_path+'/all_queshi/')
    f_list.sort(key=lambda x: int(x[:-4]))

    # 保存预测图像
    for i in range(len(result)):
        # 使用掩膜!  T2影像进行掩膜
        name = out_path + f_list[i]
        pred_img = result[i]
        t2_img = t2_imgs[i]
        np.where(t2_img > 0, 1, 0)  # 制作掩膜,缺失部分为0,无缺失部分为1
        img = (1 - t2_img) * pred_img + t2_imgs[i] * t2_img
        cv.imwrite(name, img)













