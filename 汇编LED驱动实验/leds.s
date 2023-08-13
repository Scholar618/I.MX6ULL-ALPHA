.global _start @全局标号

_start:

    /*1.使能所有外设时钟*/
    ldr r0, =0x020c4068 @ CCGR0地址
    ldr r1, =0xffffffff @ 向CCGR0写入的数据
    str r1, [r0]        @ 将0xffffffff写入到CCGR0中

    ldr r0, =0x020c406c @ CCGR1地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR1中

    ldr r0, =0x020c4070 @ CCGR2地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR2中

    ldr r0, =0x020c4074 @ CCGR3地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR3中

    ldr r0, =0x020c4078 @ CCGR4地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR4中

    ldr r0, =0x020c407c @ CCGR5地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR5中
    
    ldr r0, =0x020c4080 @ CCGR6地址
    str r1, [r0]        @ 将0xffffffff写入到CCGR6中

    /*2.IO复用
     * 配置 GPIO1_IO03 PIN 的复用为GPIO，也就是设置
     * IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03=5
     * IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO00寄存器地址为0x020e0068
     */
    ldr r0, =0x020e0068 @ IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03地址
    ldr r1, =0x5        @ 向CCGR0写入的数据
    str r1, [r0]        @ 将5写入到IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03中

    /*3.电气属性
     * 配置GPIO1_IO03的电气属性，也就是寄存器
     * IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO03
     * IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO03寄存器地址为0x020e02f4
     * 
     * bit0:    0   低速率             SRE
     * bit5:3:  110 R0/6驱动能力        DSE
     * bit7:6:  10  100MHZ速度         SPEED
     * bit11:   0   关闭开路输出         ODE
     * bit12:   1   使能pull/kepper     PKE
     * bit13:   0   kepper             PUE
     * bit15:14 00  100K下拉            PUS
     * bit16:   0   关闭HYS             HYS
     * 转化为十进制: 0x10b0
     */
    ldr r0, =0x020e02f4
    ldr r1, =0x10b0
    str r1, [r0]

    /*配置GPIO功能
     * 设置GPIO1_GDIR寄存器，设置GPIO1_GPIO03为输出
     * GPIO1_GDIR寄存器地址为0x0209c004
     * 设置GPIO1_GDIR寄存器bit3为1，也就是GPIO1_GPIO03为输出
     */
    ldr r0, =0x0209c004
    ldr r1, =0x8
    str r1, [r0]

     /*打开LED，也就是设置GPIO1_ID03为0
      * GPIO1_DR寄存器地址为0x0209c000
      */
    ldr r0, =0x0209c000
    ldr r1, =0
    str r1, [r0]

loop:
    b loop


