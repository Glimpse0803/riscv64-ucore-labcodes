
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp

    tail kern_init
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	01660613          	addi	a2,a2,22 # 80204028 <end>
int kern_init(void) {
    8020001a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
int kern_init(void) {
    80200020:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
    80200022:	5b0000ef          	jal	ra,802005d2 <memset>

    cons_init();  // init the console
    80200026:	150000ef          	jal	ra,80200176 <cons_init>

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	9f658593          	addi	a1,a1,-1546 # 80200a20 <etext>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	a0e50513          	addi	a0,a0,-1522 # 80200a40 <etext+0x20>
    8020003a:	036000ef          	jal	ra,80200070 <cprintf>

    print_kerninfo();
    8020003e:	068000ef          	jal	ra,802000a6 <print_kerninfo>

    // grade_backtrace();

    idt_init();  // init interrupt descriptor table
    80200042:	144000ef          	jal	ra,80200186 <idt_init>

    // rdtime in mbare mode crashes
    clock_init();  // init clock interrupt
    80200046:	0ee000ef          	jal	ra,80200134 <clock_init>

    intr_enable();  // enable irq interrupt
    8020004a:	136000ef          	jal	ra,80200180 <intr_enable>
    8020004e:	ffff                	0xffff
    80200050:	ffff                	0xffff

    // 使用内联汇编代码的方式进行测试
    asm volatile(".word 0xFFFFFFFF"); // 一个无效的指令
    asm volatile("ebreak"); // 插入断点指令
    80200052:	9002                	ebreak
    
    while (1)
    80200054:	a001                	j	80200054 <kern_init+0x4a>

0000000080200056 <cputch>:

/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void cputch(int c, int *cnt) {
    80200056:	1141                	addi	sp,sp,-16
    80200058:	e022                	sd	s0,0(sp)
    8020005a:	e406                	sd	ra,8(sp)
    8020005c:	842e                	mv	s0,a1
    cons_putc(c);
    8020005e:	11a000ef          	jal	ra,80200178 <cons_putc>
    (*cnt)++;
    80200062:	401c                	lw	a5,0(s0)
}
    80200064:	60a2                	ld	ra,8(sp)
    (*cnt)++;
    80200066:	2785                	addiw	a5,a5,1
    80200068:	c01c                	sw	a5,0(s0)
}
    8020006a:	6402                	ld	s0,0(sp)
    8020006c:	0141                	addi	sp,sp,16
    8020006e:	8082                	ret

0000000080200070 <cprintf>:
 * cprintf - formats a string and writes it to stdout
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...) {
    80200070:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    80200072:	02810313          	addi	t1,sp,40 # 80204028 <end>
int cprintf(const char *fmt, ...) {
    80200076:	8e2a                	mv	t3,a0
    80200078:	f42e                	sd	a1,40(sp)
    8020007a:	f832                	sd	a2,48(sp)
    8020007c:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    8020007e:	00000517          	auipc	a0,0x0
    80200082:	fd850513          	addi	a0,a0,-40 # 80200056 <cputch>
    80200086:	004c                	addi	a1,sp,4
    80200088:	869a                	mv	a3,t1
    8020008a:	8672                	mv	a2,t3
int cprintf(const char *fmt, ...) {
    8020008c:	ec06                	sd	ra,24(sp)
    8020008e:	e0ba                	sd	a4,64(sp)
    80200090:	e4be                	sd	a5,72(sp)
    80200092:	e8c2                	sd	a6,80(sp)
    80200094:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
    80200096:	e41a                	sd	t1,8(sp)
    int cnt = 0;
    80200098:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    8020009a:	5b6000ef          	jal	ra,80200650 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
    8020009e:	60e2                	ld	ra,24(sp)
    802000a0:	4512                	lw	a0,4(sp)
    802000a2:	6125                	addi	sp,sp,96
    802000a4:	8082                	ret

00000000802000a6 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
    802000a6:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
    802000a8:	00001517          	auipc	a0,0x1
    802000ac:	9a050513          	addi	a0,a0,-1632 # 80200a48 <etext+0x28>
void print_kerninfo(void) {
    802000b0:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
    802000b2:	fbfff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  entry  0x%016x (virtual)\n", kern_init);
    802000b6:	00000597          	auipc	a1,0x0
    802000ba:	f5458593          	addi	a1,a1,-172 # 8020000a <kern_init>
    802000be:	00001517          	auipc	a0,0x1
    802000c2:	9aa50513          	addi	a0,a0,-1622 # 80200a68 <etext+0x48>
    802000c6:	fabff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  etext  0x%016x (virtual)\n", etext);
    802000ca:	00001597          	auipc	a1,0x1
    802000ce:	95658593          	addi	a1,a1,-1706 # 80200a20 <etext>
    802000d2:	00001517          	auipc	a0,0x1
    802000d6:	9b650513          	addi	a0,a0,-1610 # 80200a88 <etext+0x68>
    802000da:	f97ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  edata  0x%016x (virtual)\n", edata);
    802000de:	00004597          	auipc	a1,0x4
    802000e2:	f3258593          	addi	a1,a1,-206 # 80204010 <ticks>
    802000e6:	00001517          	auipc	a0,0x1
    802000ea:	9c250513          	addi	a0,a0,-1598 # 80200aa8 <etext+0x88>
    802000ee:	f83ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  end    0x%016x (virtual)\n", end);
    802000f2:	00004597          	auipc	a1,0x4
    802000f6:	f3658593          	addi	a1,a1,-202 # 80204028 <end>
    802000fa:	00001517          	auipc	a0,0x1
    802000fe:	9ce50513          	addi	a0,a0,-1586 # 80200ac8 <etext+0xa8>
    80200102:	f6fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
    80200106:	00004597          	auipc	a1,0x4
    8020010a:	32158593          	addi	a1,a1,801 # 80204427 <end+0x3ff>
    8020010e:	00000797          	auipc	a5,0x0
    80200112:	efc78793          	addi	a5,a5,-260 # 8020000a <kern_init>
    80200116:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
    8020011a:	43f7d593          	srai	a1,a5,0x3f
}
    8020011e:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200120:	3ff5f593          	andi	a1,a1,1023
    80200124:	95be                	add	a1,a1,a5
    80200126:	85a9                	srai	a1,a1,0xa
    80200128:	00001517          	auipc	a0,0x1
    8020012c:	9c050513          	addi	a0,a0,-1600 # 80200ae8 <etext+0xc8>
}
    80200130:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200132:	bf3d                	j	80200070 <cprintf>

0000000080200134 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    80200134:	1141                	addi	sp,sp,-16
    80200136:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
    80200138:	02000793          	li	a5,32
    8020013c:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    80200140:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    80200144:	67e1                	lui	a5,0x18
    80200146:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020014a:	953e                	add	a0,a0,a5
    8020014c:	0a1000ef          	jal	ra,802009ec <sbi_set_timer>
}
    80200150:	60a2                	ld	ra,8(sp)
    ticks = 0;
    80200152:	00004797          	auipc	a5,0x4
    80200156:	ea07bf23          	sd	zero,-322(a5) # 80204010 <ticks>
    cprintf("++ setup timer interrupts\n");
    8020015a:	00001517          	auipc	a0,0x1
    8020015e:	9be50513          	addi	a0,a0,-1602 # 80200b18 <etext+0xf8>
}
    80200162:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
    80200164:	b731                	j	80200070 <cprintf>

0000000080200166 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    80200166:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    8020016a:	67e1                	lui	a5,0x18
    8020016c:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200170:	953e                	add	a0,a0,a5
    80200172:	07b0006f          	j	802009ec <sbi_set_timer>

0000000080200176 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
    80200176:	8082                	ret

0000000080200178 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
    80200178:	0ff57513          	zext.b	a0,a0
    8020017c:	0570006f          	j	802009d2 <sbi_console_putchar>

0000000080200180 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
    80200180:	100167f3          	csrrsi	a5,sstatus,2
    80200184:	8082                	ret

0000000080200186 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200186:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    // 设置异常向量地址
    write_csr(stvec, &__alltraps);
    8020018a:	00000797          	auipc	a5,0x0
    8020018e:	37678793          	addi	a5,a5,886 # 80200500 <__alltraps>
    80200192:	10579073          	csrw	stvec,a5
}
    80200196:	8082                	ret

0000000080200198 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200198:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    8020019a:	1141                	addi	sp,sp,-16
    8020019c:	e022                	sd	s0,0(sp)
    8020019e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a0:	00001517          	auipc	a0,0x1
    802001a4:	99850513          	addi	a0,a0,-1640 # 80200b38 <etext+0x118>
void print_regs(struct pushregs *gpr) {
    802001a8:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001aa:	ec7ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001ae:	640c                	ld	a1,8(s0)
    802001b0:	00001517          	auipc	a0,0x1
    802001b4:	9a050513          	addi	a0,a0,-1632 # 80200b50 <etext+0x130>
    802001b8:	eb9ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001bc:	680c                	ld	a1,16(s0)
    802001be:	00001517          	auipc	a0,0x1
    802001c2:	9aa50513          	addi	a0,a0,-1622 # 80200b68 <etext+0x148>
    802001c6:	eabff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001ca:	6c0c                	ld	a1,24(s0)
    802001cc:	00001517          	auipc	a0,0x1
    802001d0:	9b450513          	addi	a0,a0,-1612 # 80200b80 <etext+0x160>
    802001d4:	e9dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d8:	700c                	ld	a1,32(s0)
    802001da:	00001517          	auipc	a0,0x1
    802001de:	9be50513          	addi	a0,a0,-1602 # 80200b98 <etext+0x178>
    802001e2:	e8fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e6:	740c                	ld	a1,40(s0)
    802001e8:	00001517          	auipc	a0,0x1
    802001ec:	9c850513          	addi	a0,a0,-1592 # 80200bb0 <etext+0x190>
    802001f0:	e81ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001f4:	780c                	ld	a1,48(s0)
    802001f6:	00001517          	auipc	a0,0x1
    802001fa:	9d250513          	addi	a0,a0,-1582 # 80200bc8 <etext+0x1a8>
    802001fe:	e73ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    80200202:	7c0c                	ld	a1,56(s0)
    80200204:	00001517          	auipc	a0,0x1
    80200208:	9dc50513          	addi	a0,a0,-1572 # 80200be0 <etext+0x1c0>
    8020020c:	e65ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    80200210:	602c                	ld	a1,64(s0)
    80200212:	00001517          	auipc	a0,0x1
    80200216:	9e650513          	addi	a0,a0,-1562 # 80200bf8 <etext+0x1d8>
    8020021a:	e57ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    8020021e:	642c                	ld	a1,72(s0)
    80200220:	00001517          	auipc	a0,0x1
    80200224:	9f050513          	addi	a0,a0,-1552 # 80200c10 <etext+0x1f0>
    80200228:	e49ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    8020022c:	682c                	ld	a1,80(s0)
    8020022e:	00001517          	auipc	a0,0x1
    80200232:	9fa50513          	addi	a0,a0,-1542 # 80200c28 <etext+0x208>
    80200236:	e3bff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    8020023a:	6c2c                	ld	a1,88(s0)
    8020023c:	00001517          	auipc	a0,0x1
    80200240:	a0450513          	addi	a0,a0,-1532 # 80200c40 <etext+0x220>
    80200244:	e2dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200248:	702c                	ld	a1,96(s0)
    8020024a:	00001517          	auipc	a0,0x1
    8020024e:	a0e50513          	addi	a0,a0,-1522 # 80200c58 <etext+0x238>
    80200252:	e1fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200256:	742c                	ld	a1,104(s0)
    80200258:	00001517          	auipc	a0,0x1
    8020025c:	a1850513          	addi	a0,a0,-1512 # 80200c70 <etext+0x250>
    80200260:	e11ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    80200264:	782c                	ld	a1,112(s0)
    80200266:	00001517          	auipc	a0,0x1
    8020026a:	a2250513          	addi	a0,a0,-1502 # 80200c88 <etext+0x268>
    8020026e:	e03ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    80200272:	7c2c                	ld	a1,120(s0)
    80200274:	00001517          	auipc	a0,0x1
    80200278:	a2c50513          	addi	a0,a0,-1492 # 80200ca0 <etext+0x280>
    8020027c:	df5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    80200280:	604c                	ld	a1,128(s0)
    80200282:	00001517          	auipc	a0,0x1
    80200286:	a3650513          	addi	a0,a0,-1482 # 80200cb8 <etext+0x298>
    8020028a:	de7ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    8020028e:	644c                	ld	a1,136(s0)
    80200290:	00001517          	auipc	a0,0x1
    80200294:	a4050513          	addi	a0,a0,-1472 # 80200cd0 <etext+0x2b0>
    80200298:	dd9ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    8020029c:	684c                	ld	a1,144(s0)
    8020029e:	00001517          	auipc	a0,0x1
    802002a2:	a4a50513          	addi	a0,a0,-1462 # 80200ce8 <etext+0x2c8>
    802002a6:	dcbff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002aa:	6c4c                	ld	a1,152(s0)
    802002ac:	00001517          	auipc	a0,0x1
    802002b0:	a5450513          	addi	a0,a0,-1452 # 80200d00 <etext+0x2e0>
    802002b4:	dbdff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b8:	704c                	ld	a1,160(s0)
    802002ba:	00001517          	auipc	a0,0x1
    802002be:	a5e50513          	addi	a0,a0,-1442 # 80200d18 <etext+0x2f8>
    802002c2:	dafff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c6:	744c                	ld	a1,168(s0)
    802002c8:	00001517          	auipc	a0,0x1
    802002cc:	a6850513          	addi	a0,a0,-1432 # 80200d30 <etext+0x310>
    802002d0:	da1ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002d4:	784c                	ld	a1,176(s0)
    802002d6:	00001517          	auipc	a0,0x1
    802002da:	a7250513          	addi	a0,a0,-1422 # 80200d48 <etext+0x328>
    802002de:	d93ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002e2:	7c4c                	ld	a1,184(s0)
    802002e4:	00001517          	auipc	a0,0x1
    802002e8:	a7c50513          	addi	a0,a0,-1412 # 80200d60 <etext+0x340>
    802002ec:	d85ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002f0:	606c                	ld	a1,192(s0)
    802002f2:	00001517          	auipc	a0,0x1
    802002f6:	a8650513          	addi	a0,a0,-1402 # 80200d78 <etext+0x358>
    802002fa:	d77ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002fe:	646c                	ld	a1,200(s0)
    80200300:	00001517          	auipc	a0,0x1
    80200304:	a9050513          	addi	a0,a0,-1392 # 80200d90 <etext+0x370>
    80200308:	d69ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    8020030c:	686c                	ld	a1,208(s0)
    8020030e:	00001517          	auipc	a0,0x1
    80200312:	a9a50513          	addi	a0,a0,-1382 # 80200da8 <etext+0x388>
    80200316:	d5bff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    8020031a:	6c6c                	ld	a1,216(s0)
    8020031c:	00001517          	auipc	a0,0x1
    80200320:	aa450513          	addi	a0,a0,-1372 # 80200dc0 <etext+0x3a0>
    80200324:	d4dff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200328:	706c                	ld	a1,224(s0)
    8020032a:	00001517          	auipc	a0,0x1
    8020032e:	aae50513          	addi	a0,a0,-1362 # 80200dd8 <etext+0x3b8>
    80200332:	d3fff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200336:	746c                	ld	a1,232(s0)
    80200338:	00001517          	auipc	a0,0x1
    8020033c:	ab850513          	addi	a0,a0,-1352 # 80200df0 <etext+0x3d0>
    80200340:	d31ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    80200344:	786c                	ld	a1,240(s0)
    80200346:	00001517          	auipc	a0,0x1
    8020034a:	ac250513          	addi	a0,a0,-1342 # 80200e08 <etext+0x3e8>
    8020034e:	d23ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	7c6c                	ld	a1,248(s0)
}
    80200354:	6402                	ld	s0,0(sp)
    80200356:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200358:	00001517          	auipc	a0,0x1
    8020035c:	ac850513          	addi	a0,a0,-1336 # 80200e20 <etext+0x400>
}
    80200360:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200362:	b339                	j	80200070 <cprintf>

0000000080200364 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    80200364:	1141                	addi	sp,sp,-16
    80200366:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200368:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    8020036a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    8020036c:	00001517          	auipc	a0,0x1
    80200370:	acc50513          	addi	a0,a0,-1332 # 80200e38 <etext+0x418>
void print_trapframe(struct trapframe *tf) {
    80200374:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200376:	cfbff0ef          	jal	ra,80200070 <cprintf>
    print_regs(&tf->gpr);
    8020037a:	8522                	mv	a0,s0
    8020037c:	e1dff0ef          	jal	ra,80200198 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    80200380:	10043583          	ld	a1,256(s0)
    80200384:	00001517          	auipc	a0,0x1
    80200388:	acc50513          	addi	a0,a0,-1332 # 80200e50 <etext+0x430>
    8020038c:	ce5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    80200390:	10843583          	ld	a1,264(s0)
    80200394:	00001517          	auipc	a0,0x1
    80200398:	ad450513          	addi	a0,a0,-1324 # 80200e68 <etext+0x448>
    8020039c:	cd5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    802003a0:	11043583          	ld	a1,272(s0)
    802003a4:	00001517          	auipc	a0,0x1
    802003a8:	adc50513          	addi	a0,a0,-1316 # 80200e80 <etext+0x460>
    802003ac:	cc5ff0ef          	jal	ra,80200070 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b0:	11843583          	ld	a1,280(s0)
}
    802003b4:	6402                	ld	s0,0(sp)
    802003b6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b8:	00001517          	auipc	a0,0x1
    802003bc:	ae050513          	addi	a0,a0,-1312 # 80200e98 <etext+0x478>
}
    802003c0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003c2:	b17d                	j	80200070 <cprintf>

00000000802003c4 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    802003c4:	11853783          	ld	a5,280(a0)
    802003c8:	472d                	li	a4,11
    802003ca:	0786                	slli	a5,a5,0x1
    802003cc:	8385                	srli	a5,a5,0x1
    802003ce:	06f76a63          	bltu	a4,a5,80200442 <interrupt_handler+0x7e>
    802003d2:	00001717          	auipc	a4,0x1
    802003d6:	b8e70713          	addi	a4,a4,-1138 # 80200f60 <etext+0x540>
    802003da:	078a                	slli	a5,a5,0x2
    802003dc:	97ba                	add	a5,a5,a4
    802003de:	439c                	lw	a5,0(a5)
    802003e0:	97ba                	add	a5,a5,a4
    802003e2:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003e4:	00001517          	auipc	a0,0x1
    802003e8:	b2c50513          	addi	a0,a0,-1236 # 80200f10 <etext+0x4f0>
    802003ec:	b151                	j	80200070 <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003ee:	00001517          	auipc	a0,0x1
    802003f2:	b0250513          	addi	a0,a0,-1278 # 80200ef0 <etext+0x4d0>
    802003f6:	b9ad                	j	80200070 <cprintf>
            cprintf("User software interrupt\n");
    802003f8:	00001517          	auipc	a0,0x1
    802003fc:	ab850513          	addi	a0,a0,-1352 # 80200eb0 <etext+0x490>
    80200400:	b985                	j	80200070 <cprintf>
            cprintf("Supervisor software interrupt\n");
    80200402:	00001517          	auipc	a0,0x1
    80200406:	ace50513          	addi	a0,a0,-1330 # 80200ed0 <etext+0x4b0>
    8020040a:	b19d                	j	80200070 <cprintf>
void interrupt_handler(struct trapframe *tf) {
    8020040c:	1141                	addi	sp,sp,-16
    8020040e:	e022                	sd	s0,0(sp)
    80200410:	e406                	sd	ra,8(sp)
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();
            num++;
    80200412:	00004417          	auipc	s0,0x4
    80200416:	c0640413          	addi	s0,s0,-1018 # 80204018 <num>
            clock_set_next_event();
    8020041a:	d4dff0ef          	jal	ra,80200166 <clock_set_next_event>
            num++;
    8020041e:	601c                	ld	a5,0(s0)
            if(num%TICK_NUM == 0){
    80200420:	06400713          	li	a4,100
            num++;
    80200424:	0785                	addi	a5,a5,1
    80200426:	e01c                	sd	a5,0(s0)
            if(num%TICK_NUM == 0){
    80200428:	601c                	ld	a5,0(s0)
    8020042a:	02e7f7b3          	remu	a5,a5,a4
    8020042e:	cb99                	beqz	a5,80200444 <interrupt_handler+0x80>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    80200430:	60a2                	ld	ra,8(sp)
    80200432:	6402                	ld	s0,0(sp)
    80200434:	0141                	addi	sp,sp,16
    80200436:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    80200438:	00001517          	auipc	a0,0x1
    8020043c:	b0850513          	addi	a0,a0,-1272 # 80200f40 <etext+0x520>
    80200440:	b905                	j	80200070 <cprintf>
            print_trapframe(tf);
    80200442:	b70d                	j	80200364 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
    80200444:	06400593          	li	a1,100
    80200448:	00001517          	auipc	a0,0x1
    8020044c:	ae850513          	addi	a0,a0,-1304 # 80200f30 <etext+0x510>
    80200450:	c21ff0ef          	jal	ra,80200070 <cprintf>
                if(num/TICK_NUM == 10){
    80200454:	601c                	ld	a5,0(s0)
    80200456:	06300713          	li	a4,99
    8020045a:	c1878793          	addi	a5,a5,-1000
    8020045e:	fcf769e3          	bltu	a4,a5,80200430 <interrupt_handler+0x6c>
}
    80200462:	6402                	ld	s0,0(sp)
    80200464:	60a2                	ld	ra,8(sp)
    80200466:	0141                	addi	sp,sp,16
                    sbi_shutdown();
    80200468:	ab79                	j	80200a06 <sbi_shutdown>

000000008020046a <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
    8020046a:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
    8020046e:	1141                	addi	sp,sp,-16
    80200470:	e022                	sd	s0,0(sp)
    80200472:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
    80200474:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
    80200476:	842a                	mv	s0,a0
    switch (tf->cause) {
    80200478:	04e78663          	beq	a5,a4,802004c4 <exception_handler+0x5a>
    8020047c:	02f76c63          	bltu	a4,a5,802004b4 <exception_handler+0x4a>
    80200480:	4709                	li	a4,2
    80200482:	02e79563          	bne	a5,a4,802004ac <exception_handler+0x42>
             /* LAB1 CHALLENGE3   YOUR CODE : 2213483 */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Exception type:Illegal instruction\n");
    80200486:	00001517          	auipc	a0,0x1
    8020048a:	b0a50513          	addi	a0,a0,-1270 # 80200f90 <etext+0x570>
    8020048e:	be3ff0ef          	jal	ra,80200070 <cprintf>
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
    80200492:	10843583          	ld	a1,264(s0)
    80200496:	00001517          	auipc	a0,0x1
    8020049a:	b2250513          	addi	a0,a0,-1246 # 80200fb8 <etext+0x598>
    8020049e:	bd3ff0ef          	jal	ra,80200070 <cprintf>
            tf->epc = tf->epc + 4;
    802004a2:	10843783          	ld	a5,264(s0)
    802004a6:	0791                	addi	a5,a5,4
    802004a8:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    802004ac:	60a2                	ld	ra,8(sp)
    802004ae:	6402                	ld	s0,0(sp)
    802004b0:	0141                	addi	sp,sp,16
    802004b2:	8082                	ret
    switch (tf->cause) {
    802004b4:	17f1                	addi	a5,a5,-4
    802004b6:	471d                	li	a4,7
    802004b8:	fef77ae3          	bgeu	a4,a5,802004ac <exception_handler+0x42>
}
    802004bc:	6402                	ld	s0,0(sp)
    802004be:	60a2                	ld	ra,8(sp)
    802004c0:	0141                	addi	sp,sp,16
            print_trapframe(tf);
    802004c2:	b54d                	j	80200364 <print_trapframe>
            cprintf("Exception type: breakpoint\n");
    802004c4:	00001517          	auipc	a0,0x1
    802004c8:	b1c50513          	addi	a0,a0,-1252 # 80200fe0 <etext+0x5c0>
    802004cc:	ba5ff0ef          	jal	ra,80200070 <cprintf>
            cprintf("breakpoint caught at 0x%08x\n", tf->epc);
    802004d0:	10843583          	ld	a1,264(s0)
    802004d4:	00001517          	auipc	a0,0x1
    802004d8:	b2c50513          	addi	a0,a0,-1236 # 80201000 <etext+0x5e0>
    802004dc:	b95ff0ef          	jal	ra,80200070 <cprintf>
            tf->epc = tf->epc + 4;
    802004e0:	10843783          	ld	a5,264(s0)
}
    802004e4:	60a2                	ld	ra,8(sp)
            tf->epc = tf->epc + 4;
    802004e6:	0791                	addi	a5,a5,4
    802004e8:	10f43423          	sd	a5,264(s0)
}
    802004ec:	6402                	ld	s0,0(sp)
    802004ee:	0141                	addi	sp,sp,16
    802004f0:	8082                	ret

00000000802004f2 <trap>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    802004f2:	11853783          	ld	a5,280(a0)
    802004f6:	0007c363          	bltz	a5,802004fc <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    802004fa:	bf85                	j	8020046a <exception_handler>
        interrupt_handler(tf);
    802004fc:	b5e1                	j	802003c4 <interrupt_handler>
	...

0000000080200500 <__alltraps>:
    .endm

    .globl __alltraps
.align(2)
__alltraps:
    SAVE_ALL
    80200500:	14011073          	csrw	sscratch,sp
    80200504:	712d                	addi	sp,sp,-288
    80200506:	e002                	sd	zero,0(sp)
    80200508:	e406                	sd	ra,8(sp)
    8020050a:	ec0e                	sd	gp,24(sp)
    8020050c:	f012                	sd	tp,32(sp)
    8020050e:	f416                	sd	t0,40(sp)
    80200510:	f81a                	sd	t1,48(sp)
    80200512:	fc1e                	sd	t2,56(sp)
    80200514:	e0a2                	sd	s0,64(sp)
    80200516:	e4a6                	sd	s1,72(sp)
    80200518:	e8aa                	sd	a0,80(sp)
    8020051a:	ecae                	sd	a1,88(sp)
    8020051c:	f0b2                	sd	a2,96(sp)
    8020051e:	f4b6                	sd	a3,104(sp)
    80200520:	f8ba                	sd	a4,112(sp)
    80200522:	fcbe                	sd	a5,120(sp)
    80200524:	e142                	sd	a6,128(sp)
    80200526:	e546                	sd	a7,136(sp)
    80200528:	e94a                	sd	s2,144(sp)
    8020052a:	ed4e                	sd	s3,152(sp)
    8020052c:	f152                	sd	s4,160(sp)
    8020052e:	f556                	sd	s5,168(sp)
    80200530:	f95a                	sd	s6,176(sp)
    80200532:	fd5e                	sd	s7,184(sp)
    80200534:	e1e2                	sd	s8,192(sp)
    80200536:	e5e6                	sd	s9,200(sp)
    80200538:	e9ea                	sd	s10,208(sp)
    8020053a:	edee                	sd	s11,216(sp)
    8020053c:	f1f2                	sd	t3,224(sp)
    8020053e:	f5f6                	sd	t4,232(sp)
    80200540:	f9fa                	sd	t5,240(sp)
    80200542:	fdfe                	sd	t6,248(sp)
    80200544:	14001473          	csrrw	s0,sscratch,zero
    80200548:	100024f3          	csrr	s1,sstatus
    8020054c:	14102973          	csrr	s2,sepc
    80200550:	143029f3          	csrr	s3,stval
    80200554:	14202a73          	csrr	s4,scause
    80200558:	e822                	sd	s0,16(sp)
    8020055a:	e226                	sd	s1,256(sp)
    8020055c:	e64a                	sd	s2,264(sp)
    8020055e:	ea4e                	sd	s3,272(sp)
    80200560:	ee52                	sd	s4,280(sp)

    move  a0, sp
    80200562:	850a                	mv	a0,sp
    jal trap
    80200564:	f8fff0ef          	jal	ra,802004f2 <trap>

0000000080200568 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
    80200568:	6492                	ld	s1,256(sp)
    8020056a:	6932                	ld	s2,264(sp)
    8020056c:	10049073          	csrw	sstatus,s1
    80200570:	14191073          	csrw	sepc,s2
    80200574:	60a2                	ld	ra,8(sp)
    80200576:	61e2                	ld	gp,24(sp)
    80200578:	7202                	ld	tp,32(sp)
    8020057a:	72a2                	ld	t0,40(sp)
    8020057c:	7342                	ld	t1,48(sp)
    8020057e:	73e2                	ld	t2,56(sp)
    80200580:	6406                	ld	s0,64(sp)
    80200582:	64a6                	ld	s1,72(sp)
    80200584:	6546                	ld	a0,80(sp)
    80200586:	65e6                	ld	a1,88(sp)
    80200588:	7606                	ld	a2,96(sp)
    8020058a:	76a6                	ld	a3,104(sp)
    8020058c:	7746                	ld	a4,112(sp)
    8020058e:	77e6                	ld	a5,120(sp)
    80200590:	680a                	ld	a6,128(sp)
    80200592:	68aa                	ld	a7,136(sp)
    80200594:	694a                	ld	s2,144(sp)
    80200596:	69ea                	ld	s3,152(sp)
    80200598:	7a0a                	ld	s4,160(sp)
    8020059a:	7aaa                	ld	s5,168(sp)
    8020059c:	7b4a                	ld	s6,176(sp)
    8020059e:	7bea                	ld	s7,184(sp)
    802005a0:	6c0e                	ld	s8,192(sp)
    802005a2:	6cae                	ld	s9,200(sp)
    802005a4:	6d4e                	ld	s10,208(sp)
    802005a6:	6dee                	ld	s11,216(sp)
    802005a8:	7e0e                	ld	t3,224(sp)
    802005aa:	7eae                	ld	t4,232(sp)
    802005ac:	7f4e                	ld	t5,240(sp)
    802005ae:	7fee                	ld	t6,248(sp)
    802005b0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
    802005b2:	10200073          	sret

00000000802005b6 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    802005b6:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
    802005b8:	e589                	bnez	a1,802005c2 <strnlen+0xc>
    802005ba:	a811                	j	802005ce <strnlen+0x18>
        cnt ++;
    802005bc:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
    802005be:	00f58863          	beq	a1,a5,802005ce <strnlen+0x18>
    802005c2:	00f50733          	add	a4,a0,a5
    802005c6:	00074703          	lbu	a4,0(a4)
    802005ca:	fb6d                	bnez	a4,802005bc <strnlen+0x6>
    802005cc:	85be                	mv	a1,a5
    }
    return cnt;
}
    802005ce:	852e                	mv	a0,a1
    802005d0:	8082                	ret

00000000802005d2 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
    802005d2:	ca01                	beqz	a2,802005e2 <memset+0x10>
    802005d4:	962a                	add	a2,a2,a0
    char *p = s;
    802005d6:	87aa                	mv	a5,a0
        *p ++ = c;
    802005d8:	0785                	addi	a5,a5,1
    802005da:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
    802005de:	fec79de3          	bne	a5,a2,802005d8 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
    802005e2:	8082                	ret

00000000802005e4 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
    802005e4:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    802005e8:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
    802005ea:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    802005ee:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
    802005f0:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
    802005f4:	f022                	sd	s0,32(sp)
    802005f6:	ec26                	sd	s1,24(sp)
    802005f8:	e84a                	sd	s2,16(sp)
    802005fa:	f406                	sd	ra,40(sp)
    802005fc:	e44e                	sd	s3,8(sp)
    802005fe:	84aa                	mv	s1,a0
    80200600:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
    80200602:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
    80200606:	2a01                	sext.w	s4,s4
    if (num >= base) {
    80200608:	03067e63          	bgeu	a2,a6,80200644 <printnum+0x60>
    8020060c:	89be                	mv	s3,a5
        while (-- width > 0)
    8020060e:	00805763          	blez	s0,8020061c <printnum+0x38>
    80200612:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
    80200614:	85ca                	mv	a1,s2
    80200616:	854e                	mv	a0,s3
    80200618:	9482                	jalr	s1
        while (-- width > 0)
    8020061a:	fc65                	bnez	s0,80200612 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
    8020061c:	1a02                	slli	s4,s4,0x20
    8020061e:	00001797          	auipc	a5,0x1
    80200622:	a0278793          	addi	a5,a5,-1534 # 80201020 <etext+0x600>
    80200626:	020a5a13          	srli	s4,s4,0x20
    8020062a:	9a3e                	add	s4,s4,a5
}
    8020062c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
    8020062e:	000a4503          	lbu	a0,0(s4)
}
    80200632:	70a2                	ld	ra,40(sp)
    80200634:	69a2                	ld	s3,8(sp)
    80200636:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
    80200638:	85ca                	mv	a1,s2
    8020063a:	87a6                	mv	a5,s1
}
    8020063c:	6942                	ld	s2,16(sp)
    8020063e:	64e2                	ld	s1,24(sp)
    80200640:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
    80200642:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
    80200644:	03065633          	divu	a2,a2,a6
    80200648:	8722                	mv	a4,s0
    8020064a:	f9bff0ef          	jal	ra,802005e4 <printnum>
    8020064e:	b7f9                	j	8020061c <printnum+0x38>

0000000080200650 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
    80200650:	7119                	addi	sp,sp,-128
    80200652:	f4a6                	sd	s1,104(sp)
    80200654:	f0ca                	sd	s2,96(sp)
    80200656:	ecce                	sd	s3,88(sp)
    80200658:	e8d2                	sd	s4,80(sp)
    8020065a:	e4d6                	sd	s5,72(sp)
    8020065c:	e0da                	sd	s6,64(sp)
    8020065e:	fc5e                	sd	s7,56(sp)
    80200660:	f06a                	sd	s10,32(sp)
    80200662:	fc86                	sd	ra,120(sp)
    80200664:	f8a2                	sd	s0,112(sp)
    80200666:	f862                	sd	s8,48(sp)
    80200668:	f466                	sd	s9,40(sp)
    8020066a:	ec6e                	sd	s11,24(sp)
    8020066c:	892a                	mv	s2,a0
    8020066e:	84ae                	mv	s1,a1
    80200670:	8d32                	mv	s10,a2
    80200672:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    80200674:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
    80200678:	5b7d                	li	s6,-1
    8020067a:	00001a97          	auipc	s5,0x1
    8020067e:	9daa8a93          	addi	s5,s5,-1574 # 80201054 <etext+0x634>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    80200682:	00001b97          	auipc	s7,0x1
    80200686:	baeb8b93          	addi	s7,s7,-1106 # 80201230 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    8020068a:	000d4503          	lbu	a0,0(s10)
    8020068e:	001d0413          	addi	s0,s10,1
    80200692:	01350a63          	beq	a0,s3,802006a6 <vprintfmt+0x56>
            if (ch == '\0') {
    80200696:	c121                	beqz	a0,802006d6 <vprintfmt+0x86>
            putch(ch, putdat);
    80200698:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    8020069a:	0405                	addi	s0,s0,1
            putch(ch, putdat);
    8020069c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    8020069e:	fff44503          	lbu	a0,-1(s0)
    802006a2:	ff351ae3          	bne	a0,s3,80200696 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
    802006a6:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
    802006aa:	02000793          	li	a5,32
        lflag = altflag = 0;
    802006ae:	4c81                	li	s9,0
    802006b0:	4881                	li	a7,0
        width = precision = -1;
    802006b2:	5c7d                	li	s8,-1
    802006b4:	5dfd                	li	s11,-1
    802006b6:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
    802006ba:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
    802006bc:	fdd6059b          	addiw	a1,a2,-35
    802006c0:	0ff5f593          	zext.b	a1,a1
    802006c4:	00140d13          	addi	s10,s0,1
    802006c8:	04b56263          	bltu	a0,a1,8020070c <vprintfmt+0xbc>
    802006cc:	058a                	slli	a1,a1,0x2
    802006ce:	95d6                	add	a1,a1,s5
    802006d0:	4194                	lw	a3,0(a1)
    802006d2:	96d6                	add	a3,a3,s5
    802006d4:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
    802006d6:	70e6                	ld	ra,120(sp)
    802006d8:	7446                	ld	s0,112(sp)
    802006da:	74a6                	ld	s1,104(sp)
    802006dc:	7906                	ld	s2,96(sp)
    802006de:	69e6                	ld	s3,88(sp)
    802006e0:	6a46                	ld	s4,80(sp)
    802006e2:	6aa6                	ld	s5,72(sp)
    802006e4:	6b06                	ld	s6,64(sp)
    802006e6:	7be2                	ld	s7,56(sp)
    802006e8:	7c42                	ld	s8,48(sp)
    802006ea:	7ca2                	ld	s9,40(sp)
    802006ec:	7d02                	ld	s10,32(sp)
    802006ee:	6de2                	ld	s11,24(sp)
    802006f0:	6109                	addi	sp,sp,128
    802006f2:	8082                	ret
            padc = '0';
    802006f4:	87b2                	mv	a5,a2
            goto reswitch;
    802006f6:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    802006fa:	846a                	mv	s0,s10
    802006fc:	00140d13          	addi	s10,s0,1
    80200700:	fdd6059b          	addiw	a1,a2,-35
    80200704:	0ff5f593          	zext.b	a1,a1
    80200708:	fcb572e3          	bgeu	a0,a1,802006cc <vprintfmt+0x7c>
            putch('%', putdat);
    8020070c:	85a6                	mv	a1,s1
    8020070e:	02500513          	li	a0,37
    80200712:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
    80200714:	fff44783          	lbu	a5,-1(s0)
    80200718:	8d22                	mv	s10,s0
    8020071a:	f73788e3          	beq	a5,s3,8020068a <vprintfmt+0x3a>
    8020071e:	ffed4783          	lbu	a5,-2(s10)
    80200722:	1d7d                	addi	s10,s10,-1
    80200724:	ff379de3          	bne	a5,s3,8020071e <vprintfmt+0xce>
    80200728:	b78d                	j	8020068a <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
    8020072a:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
    8020072e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    80200732:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
    80200734:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
    80200738:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    8020073c:	02d86463          	bltu	a6,a3,80200764 <vprintfmt+0x114>
                ch = *fmt;
    80200740:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
    80200744:	002c169b          	slliw	a3,s8,0x2
    80200748:	0186873b          	addw	a4,a3,s8
    8020074c:	0017171b          	slliw	a4,a4,0x1
    80200750:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
    80200752:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
    80200756:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
    80200758:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
    8020075c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    80200760:	fed870e3          	bgeu	a6,a3,80200740 <vprintfmt+0xf0>
            if (width < 0)
    80200764:	f40ddce3          	bgez	s11,802006bc <vprintfmt+0x6c>
                width = precision, precision = -1;
    80200768:	8de2                	mv	s11,s8
    8020076a:	5c7d                	li	s8,-1
    8020076c:	bf81                	j	802006bc <vprintfmt+0x6c>
            if (width < 0)
    8020076e:	fffdc693          	not	a3,s11
    80200772:	96fd                	srai	a3,a3,0x3f
    80200774:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
    80200778:	00144603          	lbu	a2,1(s0)
    8020077c:	2d81                	sext.w	s11,s11
    8020077e:	846a                	mv	s0,s10
            goto reswitch;
    80200780:	bf35                	j	802006bc <vprintfmt+0x6c>
            precision = va_arg(ap, int);
    80200782:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
    80200786:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
    8020078a:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
    8020078c:	846a                	mv	s0,s10
            goto process_precision;
    8020078e:	bfd9                	j	80200764 <vprintfmt+0x114>
    if (lflag >= 2) {
    80200790:	4705                	li	a4,1
            precision = va_arg(ap, int);
    80200792:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    80200796:	01174463          	blt	a4,a7,8020079e <vprintfmt+0x14e>
    else if (lflag) {
    8020079a:	1a088e63          	beqz	a7,80200956 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
    8020079e:	000a3603          	ld	a2,0(s4)
    802007a2:	46c1                	li	a3,16
    802007a4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
    802007a6:	2781                	sext.w	a5,a5
    802007a8:	876e                	mv	a4,s11
    802007aa:	85a6                	mv	a1,s1
    802007ac:	854a                	mv	a0,s2
    802007ae:	e37ff0ef          	jal	ra,802005e4 <printnum>
            break;
    802007b2:	bde1                	j	8020068a <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
    802007b4:	000a2503          	lw	a0,0(s4)
    802007b8:	85a6                	mv	a1,s1
    802007ba:	0a21                	addi	s4,s4,8
    802007bc:	9902                	jalr	s2
            break;
    802007be:	b5f1                	j	8020068a <vprintfmt+0x3a>
    if (lflag >= 2) {
    802007c0:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802007c2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    802007c6:	01174463          	blt	a4,a7,802007ce <vprintfmt+0x17e>
    else if (lflag) {
    802007ca:	18088163          	beqz	a7,8020094c <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
    802007ce:	000a3603          	ld	a2,0(s4)
    802007d2:	46a9                	li	a3,10
    802007d4:	8a2e                	mv	s4,a1
    802007d6:	bfc1                	j	802007a6 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
    802007d8:	00144603          	lbu	a2,1(s0)
            altflag = 1;
    802007dc:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
    802007de:	846a                	mv	s0,s10
            goto reswitch;
    802007e0:	bdf1                	j	802006bc <vprintfmt+0x6c>
            putch(ch, putdat);
    802007e2:	85a6                	mv	a1,s1
    802007e4:	02500513          	li	a0,37
    802007e8:	9902                	jalr	s2
            break;
    802007ea:	b545                	j	8020068a <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
    802007ec:	00144603          	lbu	a2,1(s0)
            lflag ++;
    802007f0:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
    802007f2:	846a                	mv	s0,s10
            goto reswitch;
    802007f4:	b5e1                	j	802006bc <vprintfmt+0x6c>
    if (lflag >= 2) {
    802007f6:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802007f8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    802007fc:	01174463          	blt	a4,a7,80200804 <vprintfmt+0x1b4>
    else if (lflag) {
    80200800:	14088163          	beqz	a7,80200942 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
    80200804:	000a3603          	ld	a2,0(s4)
    80200808:	46a1                	li	a3,8
    8020080a:	8a2e                	mv	s4,a1
    8020080c:	bf69                	j	802007a6 <vprintfmt+0x156>
            putch('0', putdat);
    8020080e:	03000513          	li	a0,48
    80200812:	85a6                	mv	a1,s1
    80200814:	e03e                	sd	a5,0(sp)
    80200816:	9902                	jalr	s2
            putch('x', putdat);
    80200818:	85a6                	mv	a1,s1
    8020081a:	07800513          	li	a0,120
    8020081e:	9902                	jalr	s2
            num = (unsigned long long)va_arg(ap, void *);
    80200820:	0a21                	addi	s4,s4,8
            goto number;
    80200822:	6782                	ld	a5,0(sp)
    80200824:	46c1                	li	a3,16
            num = (unsigned long long)va_arg(ap, void *);
    80200826:	ff8a3603          	ld	a2,-8(s4)
            goto number;
    8020082a:	bfb5                	j	802007a6 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
    8020082c:	000a3403          	ld	s0,0(s4)
    80200830:	008a0713          	addi	a4,s4,8
    80200834:	e03a                	sd	a4,0(sp)
    80200836:	14040263          	beqz	s0,8020097a <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
    8020083a:	0fb05763          	blez	s11,80200928 <vprintfmt+0x2d8>
    8020083e:	02d00693          	li	a3,45
    80200842:	0cd79163          	bne	a5,a3,80200904 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200846:	00044783          	lbu	a5,0(s0)
    8020084a:	0007851b          	sext.w	a0,a5
    8020084e:	cf85                	beqz	a5,80200886 <vprintfmt+0x236>
    80200850:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
    80200854:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200858:	000c4563          	bltz	s8,80200862 <vprintfmt+0x212>
    8020085c:	3c7d                	addiw	s8,s8,-1
    8020085e:	036c0263          	beq	s8,s6,80200882 <vprintfmt+0x232>
                    putch('?', putdat);
    80200862:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
    80200864:	0e0c8e63          	beqz	s9,80200960 <vprintfmt+0x310>
    80200868:	3781                	addiw	a5,a5,-32
    8020086a:	0ef47b63          	bgeu	s0,a5,80200960 <vprintfmt+0x310>
                    putch('?', putdat);
    8020086e:	03f00513          	li	a0,63
    80200872:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200874:	000a4783          	lbu	a5,0(s4)
    80200878:	3dfd                	addiw	s11,s11,-1
    8020087a:	0a05                	addi	s4,s4,1
    8020087c:	0007851b          	sext.w	a0,a5
    80200880:	ffe1                	bnez	a5,80200858 <vprintfmt+0x208>
            for (; width > 0; width --) {
    80200882:	01b05963          	blez	s11,80200894 <vprintfmt+0x244>
    80200886:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
    80200888:	85a6                	mv	a1,s1
    8020088a:	02000513          	li	a0,32
    8020088e:	9902                	jalr	s2
            for (; width > 0; width --) {
    80200890:	fe0d9be3          	bnez	s11,80200886 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
    80200894:	6a02                	ld	s4,0(sp)
    80200896:	bbd5                	j	8020068a <vprintfmt+0x3a>
    if (lflag >= 2) {
    80200898:	4705                	li	a4,1
            precision = va_arg(ap, int);
    8020089a:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
    8020089e:	01174463          	blt	a4,a7,802008a6 <vprintfmt+0x256>
    else if (lflag) {
    802008a2:	08088d63          	beqz	a7,8020093c <vprintfmt+0x2ec>
        return va_arg(*ap, long);
    802008a6:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
    802008aa:	0a044d63          	bltz	s0,80200964 <vprintfmt+0x314>
            num = getint(&ap, lflag);
    802008ae:	8622                	mv	a2,s0
    802008b0:	8a66                	mv	s4,s9
    802008b2:	46a9                	li	a3,10
    802008b4:	bdcd                	j	802007a6 <vprintfmt+0x156>
            err = va_arg(ap, int);
    802008b6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802008ba:	4719                	li	a4,6
            err = va_arg(ap, int);
    802008bc:	0a21                	addi	s4,s4,8
            if (err < 0) {
    802008be:	41f7d69b          	sraiw	a3,a5,0x1f
    802008c2:	8fb5                	xor	a5,a5,a3
    802008c4:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802008c8:	02d74163          	blt	a4,a3,802008ea <vprintfmt+0x29a>
    802008cc:	00369793          	slli	a5,a3,0x3
    802008d0:	97de                	add	a5,a5,s7
    802008d2:	639c                	ld	a5,0(a5)
    802008d4:	cb99                	beqz	a5,802008ea <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
    802008d6:	86be                	mv	a3,a5
    802008d8:	00000617          	auipc	a2,0x0
    802008dc:	77860613          	addi	a2,a2,1912 # 80201050 <etext+0x630>
    802008e0:	85a6                	mv	a1,s1
    802008e2:	854a                	mv	a0,s2
    802008e4:	0ce000ef          	jal	ra,802009b2 <printfmt>
    802008e8:	b34d                	j	8020068a <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
    802008ea:	00000617          	auipc	a2,0x0
    802008ee:	75660613          	addi	a2,a2,1878 # 80201040 <etext+0x620>
    802008f2:	85a6                	mv	a1,s1
    802008f4:	854a                	mv	a0,s2
    802008f6:	0bc000ef          	jal	ra,802009b2 <printfmt>
    802008fa:	bb41                	j	8020068a <vprintfmt+0x3a>
                p = "(null)";
    802008fc:	00000417          	auipc	s0,0x0
    80200900:	73c40413          	addi	s0,s0,1852 # 80201038 <etext+0x618>
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200904:	85e2                	mv	a1,s8
    80200906:	8522                	mv	a0,s0
    80200908:	e43e                	sd	a5,8(sp)
    8020090a:	cadff0ef          	jal	ra,802005b6 <strnlen>
    8020090e:	40ad8dbb          	subw	s11,s11,a0
    80200912:	01b05b63          	blez	s11,80200928 <vprintfmt+0x2d8>
                    putch(padc, putdat);
    80200916:	67a2                	ld	a5,8(sp)
    80200918:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
    8020091c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
    8020091e:	85a6                	mv	a1,s1
    80200920:	8552                	mv	a0,s4
    80200922:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200924:	fe0d9ce3          	bnez	s11,8020091c <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200928:	00044783          	lbu	a5,0(s0)
    8020092c:	00140a13          	addi	s4,s0,1
    80200930:	0007851b          	sext.w	a0,a5
    80200934:	d3a5                	beqz	a5,80200894 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
    80200936:	05e00413          	li	s0,94
    8020093a:	bf39                	j	80200858 <vprintfmt+0x208>
        return va_arg(*ap, int);
    8020093c:	000a2403          	lw	s0,0(s4)
    80200940:	b7ad                	j	802008aa <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
    80200942:	000a6603          	lwu	a2,0(s4)
    80200946:	46a1                	li	a3,8
    80200948:	8a2e                	mv	s4,a1
    8020094a:	bdb1                	j	802007a6 <vprintfmt+0x156>
    8020094c:	000a6603          	lwu	a2,0(s4)
    80200950:	46a9                	li	a3,10
    80200952:	8a2e                	mv	s4,a1
    80200954:	bd89                	j	802007a6 <vprintfmt+0x156>
    80200956:	000a6603          	lwu	a2,0(s4)
    8020095a:	46c1                	li	a3,16
    8020095c:	8a2e                	mv	s4,a1
    8020095e:	b5a1                	j	802007a6 <vprintfmt+0x156>
                    putch(ch, putdat);
    80200960:	9902                	jalr	s2
    80200962:	bf09                	j	80200874 <vprintfmt+0x224>
                putch('-', putdat);
    80200964:	85a6                	mv	a1,s1
    80200966:	02d00513          	li	a0,45
    8020096a:	e03e                	sd	a5,0(sp)
    8020096c:	9902                	jalr	s2
                num = -(long long)num;
    8020096e:	6782                	ld	a5,0(sp)
    80200970:	8a66                	mv	s4,s9
    80200972:	40800633          	neg	a2,s0
    80200976:	46a9                	li	a3,10
    80200978:	b53d                	j	802007a6 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
    8020097a:	03b05163          	blez	s11,8020099c <vprintfmt+0x34c>
    8020097e:	02d00693          	li	a3,45
    80200982:	f6d79de3          	bne	a5,a3,802008fc <vprintfmt+0x2ac>
                p = "(null)";
    80200986:	00000417          	auipc	s0,0x0
    8020098a:	6b240413          	addi	s0,s0,1714 # 80201038 <etext+0x618>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020098e:	02800793          	li	a5,40
    80200992:	02800513          	li	a0,40
    80200996:	00140a13          	addi	s4,s0,1
    8020099a:	bd6d                	j	80200854 <vprintfmt+0x204>
    8020099c:	00000a17          	auipc	s4,0x0
    802009a0:	69da0a13          	addi	s4,s4,1693 # 80201039 <etext+0x619>
    802009a4:	02800513          	li	a0,40
    802009a8:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
    802009ac:	05e00413          	li	s0,94
    802009b0:	b565                	j	80200858 <vprintfmt+0x208>

00000000802009b2 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802009b2:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
    802009b4:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802009b8:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
    802009ba:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802009bc:	ec06                	sd	ra,24(sp)
    802009be:	f83a                	sd	a4,48(sp)
    802009c0:	fc3e                	sd	a5,56(sp)
    802009c2:	e0c2                	sd	a6,64(sp)
    802009c4:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
    802009c6:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
    802009c8:	c89ff0ef          	jal	ra,80200650 <vprintfmt>
}
    802009cc:	60e2                	ld	ra,24(sp)
    802009ce:	6161                	addi	sp,sp,80
    802009d0:	8082                	ret

00000000802009d2 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
    802009d2:	4781                	li	a5,0
    802009d4:	00003717          	auipc	a4,0x3
    802009d8:	62c73703          	ld	a4,1580(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    802009dc:	88ba                	mv	a7,a4
    802009de:	852a                	mv	a0,a0
    802009e0:	85be                	mv	a1,a5
    802009e2:	863e                	mv	a2,a5
    802009e4:	00000073          	ecall
    802009e8:	87aa                	mv	a5,a0
int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
    802009ea:	8082                	ret

00000000802009ec <sbi_set_timer>:
    __asm__ volatile (
    802009ec:	4781                	li	a5,0
    802009ee:	00003717          	auipc	a4,0x3
    802009f2:	63273703          	ld	a4,1586(a4) # 80204020 <SBI_SET_TIMER>
    802009f6:	88ba                	mv	a7,a4
    802009f8:	852a                	mv	a0,a0
    802009fa:	85be                	mv	a1,a5
    802009fc:	863e                	mv	a2,a5
    802009fe:	00000073          	ecall
    80200a02:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
    80200a04:	8082                	ret

0000000080200a06 <sbi_shutdown>:
    __asm__ volatile (
    80200a06:	4781                	li	a5,0
    80200a08:	00003717          	auipc	a4,0x3
    80200a0c:	60073703          	ld	a4,1536(a4) # 80204008 <SBI_SHUTDOWN>
    80200a10:	88ba                	mv	a7,a4
    80200a12:	853e                	mv	a0,a5
    80200a14:	85be                	mv	a1,a5
    80200a16:	863e                	mv	a2,a5
    80200a18:	00000073          	ecall
    80200a1c:	87aa                	mv	a5,a0


void sbi_shutdown(void)
{
    sbi_call(SBI_SHUTDOWN,0,0,0);
    80200a1e:	8082                	ret
