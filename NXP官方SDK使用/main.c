#include "fsl_common.h"
#include "fsl_iomuxc.h"
#include "MCIMX6Y2.h"

/*初始化使能外设时钟*/
void clk_enable(void) {
    CCM->CCGR0 = 0xFFFFFFFF;
    CCM->CCGR1 = 0xFFFFFFFF;    
    CCM->CCGR2 = 0xFFFFFFFF;
    CCM->CCGR3 = 0xFFFFFFFF; 
    CCM->CCGR4 = 0xFFFFFFFF;
    CCM->CCGR5 = 0xFFFFFFFF;    
    CCM->CCGR6 = 0xFFFFFFFF;
}

/*初始化LED*/
void led_init(void) {
    IOMUXC_SetPinMux(IOMUXC_GPIO1_IO03_GPIO1_IO03, 0);
    IOMUXC_SetPinConfig(IOMUXC_GPIO1_IO03_GPIO1_IO03, 0x10B0);

    /*GPIO初始化*/
    GPIO1->GDIR = 0x8; /*设置为输出*/
    GPIO1->DR = 0x0; /*打开LED灯*/
}

int main(void) 
{
    clk_enable(); /*使能外设时钟*/
    /*1.初始化LED*/
    led_init();
    /*2.设置LED闪烁*/
    while(1);
    return 0;
}
