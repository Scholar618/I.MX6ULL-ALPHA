### 一、硬件原理图分析

1、32.768khz的晶振，共给RTC使用

2、在6U的T16和T17这两个IO上接了一个24MHz的晶振

### 二、I.MX6U系统时钟分析

1、7路PLL

为了方便生成时钟，6ULL从24MHz晶振生成出7路PLL，这7路PLL中又生出来PFD
PLL1：ARM PLL供给内核使用
PLL2：system PLL 528MHz，此路PLL分出了4路PFD，PLL2_PFD0~PFD3
PLL3：USB1 PLL，480MHz 480_PLL，此路PLL分出了4路PFD，分别为PLL3_PFD0~PFD3。
PLL4：Audio PLL，主供音频使用。
PLL5：Video PLL，主供视频外设，如RGB LCD接口，和图像处理有关的外设。
PLL6：ENET PLL，主供网络外设
PLL7：USB2_PLL，480MHz，无PFD

2、各路PLL分出的PFD

3、时钟树

4、外设是如何选择合适的时钟

比如ESAI时钟源选择：
PLL4，PLL3_PFD2，PLL5，PLL3。

5、要初始化的PLL和PFD

PLL1.
PLL2. 以及PLL2_PFD0~PFD3
PLL3. 以及PLL3_PFD0~PFD3

一般按照时钟树里的值进行设置

### 三、I.MX6U系统配置

#### 1、系统主频的配置

①、要设置ARM内核主频为528MHz，设置CACRR寄存器的ARM_PODF位为2分频，然后设置PLL1=1056MHz即可，CACRR的bit3~0为ARM_PODF位，可设置0~7，分别对应1~8分频，应该设置CACRR寄存器的ARM_PODF=1

②、设置PLL1=1056MHz，PLL1=pll1_sw_clk。pll1_sw_clk有两路可以选择，分别为pll1_man_clk和step_clk。通过CCSR寄存器的pll1_sw_clk_sel位(bit2)来选择。为0的时候选择pll1_main_clk，为1的时候选择step_clk

③、在修改PLL1时，也就是设置系统时钟时需要给6ULL一个<u>临时的时钟</u>，也就是step_clk。在修改PLL1的时候需要将pll1_sw_clk切换到step_clk上。

④、设置step_clk，step_clk也有两路来源，由CCSR寄存器的step_sel位(bit8)来设置，为0的时候设置step_clk为osc=24MHz。为1的时候不重要。

⑤、时钟切换成功后，就可以修改PLL1的值

⑥、通过CCM_ANALOG_PLL_ARM寄存器的DIV_SELECT位(bit0~6)来设置PLL1的频率，公式为
		Output = fref + DIV_SEL/2    1056 = 24 + DIV_SEL/2=>DIV_SEL = 88
		设置CCM_ANALOG_PLL_ARM寄存器的DIV_SELECT位=88即可，PLL1 = 1056MHz
		还要设置CCM_ANALOG_PLL_ARM寄存器的ENABLE位(bit13)为1，也就是使能输出

⑦、在切换回PLL1之前，设置CACRR寄存器的ARM_PODF=1.





#### 2、各个PLL时钟的配置

PLL2和PLL3中，PLL2固定为528MHz，PLL3固定为480MHz

①、初始化PLL2_PFD0~PFD3。寄存器CCM_ANALOG_PFD_528用于设置4路PFD的时钟，比如PFD=528*18/PFD0_FRAC位即可，比如PLL2_PFD0=352M=528×18/PFD0_FRAC,因此FPD0_FRAC = 27。

②、初始化PLL3_PFD0~PFD3

#### 3、其他外设的时钟源配置

AHB_CLK_ROOT、PERCLK_CLK_ROOT以及IPG_CLK_ROOT。

因为PERCLK_CLK_ROOT以及IPG_CLK_ROOT要用到AHB_CLK_ROOT，所以我们要初始化AHB_CLK_ROOT。

①、AHB_CLK_ROOT初始化

​	AHB_CLK_ROOT=132MHz
​	设置CBCMR寄存器的PRE_PERIPH_SEL位，设置CBCDR寄存器的PERIPH_CLK_SEL位为0，设置CBCDR寄存器的AHB_PODF位为2（3分频），使得396/3=132MHz。

​	PERCLK_CLK_ROOT=66MHz

​	IPG_CLK_ROOT=66MHz

②、IPG_CLK_ROOT初始化

​	设置CBCDR寄存器IPG_PODF=1,也就是二分频

③、PERCLK_CLK_ROOT初始化

​	设置CBCMR1寄存器的PERCLK_CLK_SEL位为0

## 
