#include "main.h"
#include "bsp_clk.h"
#include "bsp_led.h"
#include "bsp_delay.h"
#include "bsp_beep.h"

int main(void) 
{
    clk_enable(); /*使能外设时钟*/
    /*1.初始化LED*/
    led_init();
    beep_init(); // 初始化蜂鸣器
    /*2.设置LED闪烁*/
    while(1) {
        led_on();
        beep_switch(ON);
        delay(1000);

        led_off();
        beep_switch(OFF);
        delay(1000);
    }
    return 0;
}