CROSS_COMPILE ?= arm-linux-gnueabihf-
TARGET		  ?= beep

CC 			:= $(CROSS_COMPILE)gcc
LD			:= $(CROSS_COMPILE)ld
OBJCOPY		:= $(CROSS_COMPILE)objcopy
OBJDUMP		:= $(CROSS_COMPILE)objdump

INCUDIRS	:= imx6u   \
			   bsp/clk \
			   bsp/led \
			   bsp/delay \
			   bsp/beep
			
SRCDIRS		:= project \
			   bsp/clk \
			   bsp/led \
			   bsp/delay \
			   bsp/beep

INCLUDE		:= $(patsubst %, -I %, ${INCUDIRS})

SFILES		:= $(foreach dir, ${SRCDIRS}, ${wildcard $(dir)/*.S})
CFILES		:= $(foreach dir, ${SRCDIRS}, ${wildcard $(dir)/*.c})

SFILENOIR	:= $(notdir ${SFILES})
CFILENOIR	:= $(notdir ${CFILES})

SOBJS		:= $(patsubst %, obj/%, ${SFILENOIR:.S=.o})
COBJS		:= $(patsubst %, obj/%, ${CFILENOIR:.c=.o})

OBJS		:= $(SOBJS)$(COBJS)

VPATH		:= $(SRCDIRS)

.PHONY:clean

$(TARGET).bin : $(OBJS)
	$(LD) -Timx6u.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis

$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2 $(INCLUDE) -o $@ $<

$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2 $(INCLUDE) -o $@ $<

clean:
	rm -rf $(TARGET).elf $(TARGET).bin $(TARGET).dis $(OBJS)

print:
	@echo INCLUDE = $(INCLUDE)
	@echo SFILES = $(SFILES)
	@echo CFILES = $(CFILES)
	@echo SFILENOIR = $(SFILENOIR)
	@echo CFILENOIR = $(CFILENOIR)
	@echo SOBJS = $(SOBJS)
	@echo COBJS = $(COBJS)
	@echo OBJS = $(OBJS)
