#!/usr/bin/env python 
# -*- coding: utf-8 -*-
# @Time    : 2022/8/16 15:52
# @Author  : HuangXiaohan
# @File    : tools_cal_precision.py
# @Software: PyCharm
# for quantitative comparison of two images result_img and ori_img
import math
from math import sqrt
import numpy as np
import tensorflow as tf

from scipy.signal import convolve2d
from sklearn.metrics import r2_score

def matlab_style_gauss2D(shape=(3,3),sigma=0.5):
    """
    2D gaussian mask - should give the same result as MATLAB's
    fspecial('gaussian',[shape],[sigma])
    """
    m, n = [(ss-1.)/2. for ss in shape]
    y, x = np.ogrid[-m:m+1, -n:n+1]
    h = np.exp(-(x*x + y*y) / (2.*sigma*sigma) )
    h[h < np.finfo(h.dtype).eps*h.max()] = 0
    sumh = h.sum()
    if sumh != 0:
        h /= sumh
    return h

def filter2(x, kernel, mode='same'):
    return convolve2d(x, np.rot90(kernel, 2), mode=mode)

def compute_ssim(im1, im2, k1=0.01, k2=0.03, win_size=11, L= 1.0):

    if not im1.shape == im2.shape:
        raise ValueError("Input Imagees must have the same dimensions")
    if len(im1.shape) > 2:
        raise ValueError("Please input the images with 1 channel")

    M, N = im1.shape
    C1 = (k1*L)**2
    C2 = (k2*L)**2
    window = matlab_style_gauss2D(shape=(win_size, win_size), sigma=1.5)
    window = window/np.sum(np.sum(window))

    if im1.dtype == np.uint8:
        im1 = np.double(im1)
    if im2.dtype == np.uint8:
        im2 = np.double(im2)

    mu1 = filter2(im1, window, 'valid')
    mu2 = filter2(im2, window, 'valid')
    mu1_sq = mu1 * mu1
    mu2_sq = mu2 * mu2
    mu1_mu2 = mu1 * mu2
    sigma1_sq = filter2(im1*im1, window, 'valid') - mu1_sq
    sigma2_sq = filter2(im2*im2, window, 'valid') - mu2_sq
    sigmal2 = filter2(im1*im2, window, 'valid') - mu1_mu2

    ssim_map = ((2*mu1_mu2+C1) * (2*sigmal2+C2)) / ((mu1_sq+mu2_sq+C1) * (sigma1_sq+sigma2_sq+C2))

    return np.mean(np.mean(ssim_map))

def lst_evalu(result_img, ori_img, fac):
    RC = ori_img.shape
    R = RC[0]
    C = RC[1]
    # RMSE
    rmse = 0.0
    for ri in range(R):
        for ci in range(C):
            dif2 = (result_img[ri][ci] - ori_img[ri][ci])
            rmse = rmse + dif2 * dif2
    rmse = rmse / (R * C)
    rmse = math.sqrt(rmse) * fac
    return rmse

def quantitative_evalu(result_img, ori_img):
    RC = ori_img.shape
    R = RC[0]
    C = RC[1]
    # RMSE
    rmse = 0.0
    #print(R,C)
    for ri in range(R):
        for ci in range(C):
            #print(ri, ci)
            rmse = rmse + (result_img[ri][ci] - ori_img[ri][ci]) *\
                   (result_img[ri][ci] - ori_img[ri][ci])
    rmse = rmse / (R*C)
    rmse = sqrt(rmse)
    # SSIM
    ssim = compute_ssim(result_img, ori_img)
    # CC
    temp1 = 0.0
    temp2 = 0.0
    temp3 = 0.0
    result_img_mean = np.mean(result_img)
    ori_img_mean = np.mean(ori_img)
    for rk in range(R):
        for ck in range(C):
            temp1 = (result_img[rk][ck] - result_img_mean) * \
                    (ori_img[rk][ck] - ori_img_mean) + temp1
            temp2 = (result_img[rk][ck] - result_img_mean) * \
                    (result_img[rk][ck] - result_img_mean) + temp2
            temp3 = (ori_img[rk][ck] - ori_img_mean) * \
                    (ori_img[rk][ck] - ori_img_mean) + temp3
    cc = temp1 / math.sqrt(temp2 * temp3)
    # result_img = result_img.reshape([1, 800, 800, 1])
    # ori_img = ori_img.reshape([1, 800, 800, 1])
    # result_img = tf.convert_to_tensor(result_img)
    # ori_img = tf.convert_to_tensor(ori_img)
    # tfssim = tf.image.ssim(result_img, ori_img, max_val=1.0)

    return rmse, ssim , cc

def compute_psnr(target, ref, max_valu=1.0):

    # psnr(target, ref, max, scale):# 后面两个参数是什么意思：返回target与ref的PSNR值，一般情况下max_val＝255（图像数值的动态范围）
    # assume RGB image
    # 其中 MAX2IMAXI*2 为图片可能的最大像素值。如果每个像素都由 8 位二进制来表示，那么就为 255。通常，如果像素值由 BB 位二进制来表示，那么 MAXI=2B−1MAXI=2B−1。
    # scale += 6
    target_data = np.array(target, dtype=np.float32)
    # target_data = target_data[scale:-scale-1, scale:-scale-1]

    ref_data = np.array(ref, dtype=np.float32)
    # ref_data = ref_data[scale:-scale-1, scale:-scale-1]

    diff = (ref_data - target_data) ** 2
    diff = diff.flatten('C')  # flatten()可以将二维的array展成一维的,flatten('C')和flatten('F')的区别在于行row向量和列column向量。
    # 图像的超分辨率重建中，计算PSNR的时候，需要将矩阵形式的二维数据变成向量形式的一维向量，这样方便计算。
    rmse = math.sqrt(np.mean(diff))

    return 20 * math.log10(max_valu / rmse)

def performance_metric(ori, result):  #计算决定系数R2
    score = r2_score(ori, result)
    return score

def performance_metric2(y_true, y_predict):
    """计算并返回预测值相比于预测值的分数"""
    import numpy as np
    arr_true = np.array(y_true)
    y_mean = np.mean(arr_true)

    ssreg = 0
    sstotal = 0
    ssres = 0
    for item in y_predict:
        ssreg += (item - y_mean)**2
    for item in y_true:
        sstotal += (item - y_mean)**2
    for index,item in enumerate(y_true):
        ssres += (item - y_predict[index])**2

    score = 1-(ssres/sstotal)

    return score