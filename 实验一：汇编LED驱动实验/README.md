# 正点原子I.MX6ULL-ALPHA实验

## 实验一

汇编LED驱动实验

### 一、汇编LED原理分析

为什么要学习Cortex-A汇编？

1. 需要用汇编初始化一些SOC外设
2. 使用汇编初始化DDR、I.MX6U不需要
3. 设置sp指针，一般指向DDR，设置好C语言运行环境

SOC外设（System On Chip，片上系统）：**整体的一个电路系统，完成一个具体功能的东西**，是一种集成了处理器核心、内存、输入/输出接口和其他系统组件的芯片，例如一些常见的SOC外设：<u>SPI、I2C、USB、GPIO</u>等。

DDR（Double Data Rate）：是一种内存技术，用于<u>存储和读取计算机系统中的数据</u>。

#### 1. ALPHA开发板LED灯硬件原理分析：

![image-20230809181435868](https://github.com/Scholar618/I.MX6ULL-ALPHA/tree/main/pictures/image-20230809181435868.png)

![image-20230809181507424](https://github.com/Scholar618/I.MX6ULL-ALPHA/tree/main/pictures/image-20230809181507424.png)

由原理图可知，LED0接到了GPIO1_3，于是我们查看I.MX6U参考手册中的GPIO3

![image-20230809182317954](https://github.com/Scholar618/I.MX6ULL-ALPHA/tree/main/pictures/image-20230809182317954.png)

首先，我们先来了解STM32 IO 初始化流程：

1. 使能**GPIO时钟**
2. 设置**IO复用**，并将其复用为GPIO
3. 配置GPIO的电气属性
4. 使用GPIO、输出高/低电平

I.MX6ULL IO 初始化：

1. **使能时钟**：CCGR0-CCGR6这7个寄存器控制着6ULL所有外设时钟的使能，为了简单，设置CCGR0-CCGR6这7个寄存器全部为0XFFFFFFFF，相当于使能所有外设时钟。
2. **IO复用**：将寄存器IOMUXC_SW_**MUX**_CTL_PAD_GPIO1_IO03的bit3-0设置为0101=5， 这样GPIO1_IO03就复用位GPIO了
3. **电气属性**：寄存器IOMUXC_SW_**PAD**_CTL_PAD_GPIO1_IO03设置GPIO1_IO03的电气属性，包括：压摆率、速度、驱动能力、开路、上下拉等
4. **配置GPIO功能**：设置输入输出，设置GPIO1_DR 寄存器bit3为1，设置为输出模式；设置GPIO1_DR寄存器的bit3，为1表示输出高电平，为0表示输出低电平。

### 二、I.MX6U PIN/PAD 详解

即上述I.MX6ULL IO 初始化中的配置电器属性，有关于压摆率、速度、驱动能力、开路等属性。

### 三、I.MX6U GPIO详解

即上述I.MX6ULL IO 初始化中的配置GPIO功能，设置输入输出

### 四、编写驱动

根据上述四点逐步编写程序。

### 五、 编译程序

1. 将.c , .s文件编译为.o文件
2. 使用arm-linux-gnueabihf-gcc 将所有的.o文件链接为elf格式的可执行文件
3. 将elf文件转为bin文件
4. 将elf文件转为汇编，反汇编

链接：就是将所有.o文件链接到一起，并且链接到指定的地方。本实验链接时要指定链接起始地址，链接起始地址就是代码运行的起始地址

​	对于6ULL来说，链接起始地址应该指向RAM地址，RAM分为内部RAM和外部RAM，也就是DDR，内部地址范围（0x90000000~0x91FFFFFF），也可以放到外部DDR中，对于I.MX6U-ALPHA开发板，512MB字节DDR版本的核心板，DDR范围就是0x80000000~0x9FFFFFFF，对于256MB的DDR来说，就是0x80000000~0x8FFFFFFF

​	假设，逻辑代码的链接起始地址为0x87800000，要使用DDR，必须要初始化DDR，但是代码里没有初始化DDR代码块，那么DDR怎么使用？对于I.MX来说，bin文件不能直接运行，需要添加一个头部，这个头部信息包含了DDR的初始化参数，I.MX系列SOC内部boot room会从SD卡、EMMC等外置存储中读取头部信息，然后初始化DDR，并且将bin文件拷贝到指定的地方。

​	bin的运行地址一定要和链接起始地址一致，位置无关代码除外。

### 六、 烧写bin文件

STM32烧写到内部FLASH

6ULL支持SD卡、EMMC、NAND、nor、SPI flash等等启动，裸机例程烧写到SD卡里面

在Ubuntu下向SD卡烧写裸机bin文件，烧写不是将bin文件拷贝到SD卡中，而是将bin文件烧写到SD卡绝对地址上，而且对于I.MX来说，不能直接烧写bin文件，必须先在bin文件前面添加头部



