**蜂鸣器实验**

### 一、硬件原理图分析

![image-20230812160548560](https://github.com/Scholar618/I.MX6ULL-ALPHA/blob/main/pictures/image-20230812160548560.png)

BEEP控制IO为SNVS_TAMPER1，**当输出低电平时蜂鸣器响，输出高电平时蜂鸣器不响**

### 二、实验程序编写

1.初始化SNVS_TAMPER1这个IO复用为GPIO5_IO01

2.设置SNVS_TAMPER1这个IO的电气属性

3.初始化GPIO

4.控制GPIO输出高低电平

