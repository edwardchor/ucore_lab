
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 92 59 00 00       	call   1059e8 <memset>

    cons_init();                // init the console
  100056:	e8 b7 14 00 00       	call   101512 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 5b 10 00 	movl   $0x105b80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 5b 10 00 	movl   $0x105b9c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 14 40 00 00       	call   104098 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 f2 15 00 00       	call   10167b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 6a 17 00 00       	call   1017f8 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 35 0c 00 00       	call   100cc8 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 51 15 00 00       	call   1015e9 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 3e 0b 00 00       	call   100bfa <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 5b 10 00 	movl   $0x105ba1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 5b 10 00 	movl   $0x105baf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 5b 10 00 	movl   $0x105bbd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 5b 10 00 	movl   $0x105bcb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 5b 10 00 	movl   $0x105bd9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 5b 10 00 	movl   $0x105be8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 5c 10 00 	movl   $0x105c08,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 5c 10 00 	movl   $0x105c27,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 44 12 00 00       	call   10153e <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 ca 4e 00 00       	call   105201 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 cb 11 00 00       	call   10153e <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 ab 11 00 00       	call   10157a <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 5c 10 00    	movl   $0x105c2c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 5c 10 00 	movl   $0x105c2c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 50 6e 10 00 	movl   $0x106e50,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 74 16 11 00 	movl   $0x111674,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 75 16 11 00 	movl   $0x111675,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 93 40 11 00 	movl   $0x114093,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 70 51 00 00       	call   10585c <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 5c 10 00 	movl   $0x105c36,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 5c 10 00 	movl   $0x105c4f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 71 5b 10 	movl   $0x105b71,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 5c 10 00 	movl   $0x105c67,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 5c 10 00 	movl   $0x105c7f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 5c 10 00 	movl   $0x105c97,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 5c 10 00 	movl   $0x105cb0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 5c 10 00 	movl   $0x105cda,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 5c 10 00 	movl   $0x105cf6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  1009bd:	5d                   	pop    %ebp
  1009be:	c3                   	ret    

001009bf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  1009bf:	55                   	push   %ebp
  1009c0:	89 e5                	mov    %esp,%ebp
  1009c2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  1009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009cc:	eb 0c                	jmp    1009da <parse+0x1b>
            *buf ++ = '\0';
  1009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d1:	8d 50 01             	lea    0x1(%eax),%edx
  1009d4:	89 55 08             	mov    %edx,0x8(%ebp)
  1009d7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009da:	8b 45 08             	mov    0x8(%ebp),%eax
  1009dd:	0f b6 00             	movzbl (%eax),%eax
  1009e0:	84 c0                	test   %al,%al
  1009e2:	74 1d                	je     100a01 <parse+0x42>
  1009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e7:	0f b6 00             	movzbl (%eax),%eax
  1009ea:	0f be c0             	movsbl %al,%eax
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	c7 04 24 88 5d 10 00 	movl   $0x105d88,(%esp)
  1009f8:	e8 2c 4e 00 00       	call   105829 <strchr>
  1009fd:	85 c0                	test   %eax,%eax
  1009ff:	75 cd                	jne    1009ce <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	0f b6 00             	movzbl (%eax),%eax
  100a07:	84 c0                	test   %al,%al
  100a09:	75 02                	jne    100a0d <parse+0x4e>
            break;
  100a0b:	eb 67                	jmp    100a74 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a0d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a11:	75 14                	jne    100a27 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a1a:	00 
  100a1b:	c7 04 24 8d 5d 10 00 	movl   $0x105d8d,(%esp)
  100a22:	e8 15 f9 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2a:	8d 50 01             	lea    0x1(%eax),%edx
  100a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a3a:	01 c2                	add    %eax,%edx
  100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a41:	eb 04                	jmp    100a47 <parse+0x88>
            buf ++;
  100a43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a47:	8b 45 08             	mov    0x8(%ebp),%eax
  100a4a:	0f b6 00             	movzbl (%eax),%eax
  100a4d:	84 c0                	test   %al,%al
  100a4f:	74 1d                	je     100a6e <parse+0xaf>
  100a51:	8b 45 08             	mov    0x8(%ebp),%eax
  100a54:	0f b6 00             	movzbl (%eax),%eax
  100a57:	0f be c0             	movsbl %al,%eax
  100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5e:	c7 04 24 88 5d 10 00 	movl   $0x105d88,(%esp)
  100a65:	e8 bf 4d 00 00       	call   105829 <strchr>
  100a6a:	85 c0                	test   %eax,%eax
  100a6c:	74 d5                	je     100a43 <parse+0x84>
            buf ++;
        }
    }
  100a6e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6f:	e9 66 ff ff ff       	jmp    1009da <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a7f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a86:	8b 45 08             	mov    0x8(%ebp),%eax
  100a89:	89 04 24             	mov    %eax,(%esp)
  100a8c:	e8 2e ff ff ff       	call   1009bf <parse>
  100a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a98:	75 0a                	jne    100aa4 <runcmd+0x2b>
        return 0;
  100a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  100a9f:	e9 85 00 00 00       	jmp    100b29 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100aab:	eb 5c                	jmp    100b09 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100aad:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ab3:	89 d0                	mov    %edx,%eax
  100ab5:	01 c0                	add    %eax,%eax
  100ab7:	01 d0                	add    %edx,%eax
  100ab9:	c1 e0 02             	shl    $0x2,%eax
  100abc:	05 20 70 11 00       	add    $0x117020,%eax
  100ac1:	8b 00                	mov    (%eax),%eax
  100ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ac7:	89 04 24             	mov    %eax,(%esp)
  100aca:	e8 bb 4c 00 00       	call   10578a <strcmp>
  100acf:	85 c0                	test   %eax,%eax
  100ad1:	75 32                	jne    100b05 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ad6:	89 d0                	mov    %edx,%eax
  100ad8:	01 c0                	add    %eax,%eax
  100ada:	01 d0                	add    %edx,%eax
  100adc:	c1 e0 02             	shl    $0x2,%eax
  100adf:	05 20 70 11 00       	add    $0x117020,%eax
  100ae4:	8b 40 08             	mov    0x8(%eax),%eax
  100ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100aea:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  100af0:	89 54 24 08          	mov    %edx,0x8(%esp)
  100af4:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100af7:	83 c2 04             	add    $0x4,%edx
  100afa:	89 54 24 04          	mov    %edx,0x4(%esp)
  100afe:	89 0c 24             	mov    %ecx,(%esp)
  100b01:	ff d0                	call   *%eax
  100b03:	eb 24                	jmp    100b29 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0c:	83 f8 02             	cmp    $0x2,%eax
  100b0f:	76 9c                	jbe    100aad <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 ab 5d 10 00 	movl   $0x105dab,(%esp)
  100b1f:	e8 18 f8 ff ff       	call   10033c <cprintf>
    return 0;
  100b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b29:	c9                   	leave  
  100b2a:	c3                   	ret    

00100b2b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b2b:	55                   	push   %ebp
  100b2c:	89 e5                	mov    %esp,%ebp
  100b2e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b31:	c7 04 24 c4 5d 10 00 	movl   $0x105dc4,(%esp)
  100b38:	e8 ff f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b3d:	c7 04 24 ec 5d 10 00 	movl   $0x105dec,(%esp)
  100b44:	e8 f3 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b4d:	74 0b                	je     100b5a <kmonitor+0x2f>
        print_trapframe(tf);
  100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b52:	89 04 24             	mov    %eax,(%esp)
  100b55:	e8 ea 0c 00 00       	call   101844 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b5a:	c7 04 24 11 5e 10 00 	movl   $0x105e11,(%esp)
  100b61:	e8 cd f6 ff ff       	call   100233 <readline>
  100b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b6d:	74 18                	je     100b87 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b79:	89 04 24             	mov    %eax,(%esp)
  100b7c:	e8 f8 fe ff ff       	call   100a79 <runcmd>
  100b81:	85 c0                	test   %eax,%eax
  100b83:	79 02                	jns    100b87 <kmonitor+0x5c>
                break;
  100b85:	eb 02                	jmp    100b89 <kmonitor+0x5e>
            }
        }
    }
  100b87:	eb d1                	jmp    100b5a <kmonitor+0x2f>
}
  100b89:	c9                   	leave  
  100b8a:	c3                   	ret    

00100b8b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b8b:	55                   	push   %ebp
  100b8c:	89 e5                	mov    %esp,%ebp
  100b8e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b98:	eb 3f                	jmp    100bd9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9d:	89 d0                	mov    %edx,%eax
  100b9f:	01 c0                	add    %eax,%eax
  100ba1:	01 d0                	add    %edx,%eax
  100ba3:	c1 e0 02             	shl    $0x2,%eax
  100ba6:	05 20 70 11 00       	add    $0x117020,%eax
  100bab:	8b 48 04             	mov    0x4(%eax),%ecx
  100bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bb1:	89 d0                	mov    %edx,%eax
  100bb3:	01 c0                	add    %eax,%eax
  100bb5:	01 d0                	add    %edx,%eax
  100bb7:	c1 e0 02             	shl    $0x2,%eax
  100bba:	05 20 70 11 00       	add    $0x117020,%eax
  100bbf:	8b 00                	mov    (%eax),%eax
  100bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc9:	c7 04 24 15 5e 10 00 	movl   $0x105e15,(%esp)
  100bd0:	e8 67 f7 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdc:	83 f8 02             	cmp    $0x2,%eax
  100bdf:	76 b9                	jbe    100b9a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be6:	c9                   	leave  
  100be7:	c3                   	ret    

00100be8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100be8:	55                   	push   %ebp
  100be9:	89 e5                	mov    %esp,%ebp
  100beb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100bee:	e8 7d fc ff ff       	call   100870 <print_kerninfo>
    return 0;
  100bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf8:	c9                   	leave  
  100bf9:	c3                   	ret    

00100bfa <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100bfa:	55                   	push   %ebp
  100bfb:	89 e5                	mov    %esp,%ebp
  100bfd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c00:	e8 b5 fd ff ff       	call   1009ba <print_stackframe>
    return 0;
  100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c0a:	c9                   	leave  
  100c0b:	c3                   	ret    

00100c0c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c0c:	55                   	push   %ebp
  100c0d:	89 e5                	mov    %esp,%ebp
  100c0f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c12:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100c17:	85 c0                	test   %eax,%eax
  100c19:	74 02                	je     100c1d <__panic+0x11>
        goto panic_dead;
  100c1b:	eb 48                	jmp    100c65 <__panic+0x59>
    }
    is_panic = 1;
  100c1d:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100c24:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c27:	8d 45 14             	lea    0x14(%ebp),%eax
  100c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c30:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c34:	8b 45 08             	mov    0x8(%ebp),%eax
  100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3b:	c7 04 24 1e 5e 10 00 	movl   $0x105e1e,(%esp)
  100c42:	e8 f5 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  100c51:	89 04 24             	mov    %eax,(%esp)
  100c54:	e8 b0 f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100c59:	c7 04 24 3a 5e 10 00 	movl   $0x105e3a,(%esp)
  100c60:	e8 d7 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100c65:	e8 85 09 00 00       	call   1015ef <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c71:	e8 b5 fe ff ff       	call   100b2b <kmonitor>
    }
  100c76:	eb f2                	jmp    100c6a <__panic+0x5e>

00100c78 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100c7e:	8d 45 14             	lea    0x14(%ebp),%eax
  100c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c87:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c92:	c7 04 24 3c 5e 10 00 	movl   $0x105e3c,(%esp)
  100c99:	e8 9e f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  100ca8:	89 04 24             	mov    %eax,(%esp)
  100cab:	e8 59 f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100cb0:	c7 04 24 3a 5e 10 00 	movl   $0x105e3a,(%esp)
  100cb7:	e8 80 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100cbc:	c9                   	leave  
  100cbd:	c3                   	ret    

00100cbe <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100cbe:	55                   	push   %ebp
  100cbf:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100cc1:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100cc6:	5d                   	pop    %ebp
  100cc7:	c3                   	ret    

00100cc8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cc8:	55                   	push   %ebp
  100cc9:	89 e5                	mov    %esp,%ebp
  100ccb:	83 ec 28             	sub    $0x28,%esp
  100cce:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100cd4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100cd8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100cdc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ce0:	ee                   	out    %al,(%dx)
  100ce1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ce7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100ceb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100cef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cf3:	ee                   	out    %al,(%dx)
  100cf4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100cfa:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100cfe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d02:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d06:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d07:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d0e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d11:	c7 04 24 5a 5e 10 00 	movl   $0x105e5a,(%esp)
  100d18:	e8 1f f6 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d24:	e8 24 09 00 00       	call   10164d <pic_enable>
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d31:	9c                   	pushf  
  100d32:	58                   	pop    %eax
  100d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d39:	25 00 02 00 00       	and    $0x200,%eax
  100d3e:	85 c0                	test   %eax,%eax
  100d40:	74 0c                	je     100d4e <__intr_save+0x23>
        intr_disable();
  100d42:	e8 a8 08 00 00       	call   1015ef <intr_disable>
        return 1;
  100d47:	b8 01 00 00 00       	mov    $0x1,%eax
  100d4c:	eb 05                	jmp    100d53 <__intr_save+0x28>
    }
    return 0;
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d5f:	74 05                	je     100d66 <__intr_restore+0x11>
        intr_enable();
  100d61:	e8 83 08 00 00       	call   1015e9 <intr_enable>
    }
}
  100d66:	c9                   	leave  
  100d67:	c3                   	ret    

00100d68 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
  100d6b:	83 ec 10             	sub    $0x10,%esp
  100d6e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100d74:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d78:	89 c2                	mov    %eax,%edx
  100d7a:	ec                   	in     (%dx),%al
  100d7b:	88 45 fd             	mov    %al,-0x3(%ebp)
  100d7e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d84:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d88:	89 c2                	mov    %eax,%edx
  100d8a:	ec                   	in     (%dx),%al
  100d8b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d8e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d94:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d98:	89 c2                	mov    %eax,%edx
  100d9a:	ec                   	in     (%dx),%al
  100d9b:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d9e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100da4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100da8:	89 c2                	mov    %eax,%edx
  100daa:	ec                   	in     (%dx),%al
  100dab:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dae:	c9                   	leave  
  100daf:	c3                   	ret    

00100db0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100db0:	55                   	push   %ebp
  100db1:	89 e5                	mov    %esp,%ebp
  100db3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100db6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dc0:	0f b7 00             	movzwl (%eax),%eax
  100dc3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dca:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd2:	0f b7 00             	movzwl (%eax),%eax
  100dd5:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100dd9:	74 12                	je     100ded <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ddb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100de2:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100de9:	b4 03 
  100deb:	eb 13                	jmp    100e00 <cga_init+0x50>
    } else {
        *cp = was;
  100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100df4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100df7:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100dfe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e00:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e07:	0f b7 c0             	movzwl %ax,%eax
  100e0a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e0e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e12:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e1a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e1b:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e22:	83 c0 01             	add    $0x1,%eax
  100e25:	0f b7 c0             	movzwl %ax,%eax
  100e28:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e30:	89 c2                	mov    %eax,%edx
  100e32:	ec                   	in     (%dx),%al
  100e33:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e3a:	0f b6 c0             	movzbl %al,%eax
  100e3d:	c1 e0 08             	shl    $0x8,%eax
  100e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e43:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e4a:	0f b7 c0             	movzwl %ax,%eax
  100e4d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e51:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e55:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e59:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e5d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e5e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e65:	83 c0 01             	add    $0x1,%eax
  100e68:	0f b7 c0             	movzwl %ax,%eax
  100e6b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e6f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100e73:	89 c2                	mov    %eax,%edx
  100e75:	ec                   	in     (%dx),%al
  100e76:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e79:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e7d:	0f b6 c0             	movzbl %al,%eax
  100e80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e8e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100e94:	c9                   	leave  
  100e95:	c3                   	ret    

00100e96 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e96:	55                   	push   %ebp
  100e97:	89 e5                	mov    %esp,%ebp
  100e99:	83 ec 48             	sub    $0x48,%esp
  100e9c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ea2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ea6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100eaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eae:	ee                   	out    %al,(%dx)
  100eaf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100eb5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100eb9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ebd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
  100ec2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100ec8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
  100ed5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100edb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100edf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ee7:	ee                   	out    %al,(%dx)
  100ee8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100eee:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100ef2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100efa:	ee                   	out    %al,(%dx)
  100efb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f01:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f05:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f09:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f0d:	ee                   	out    %al,(%dx)
  100f0e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f14:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f18:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f1c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
  100f21:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f27:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f2b:	89 c2                	mov    %eax,%edx
  100f2d:	ec                   	in     (%dx),%al
  100f2e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f31:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f35:	3c ff                	cmp    $0xff,%al
  100f37:	0f 95 c0             	setne  %al
  100f3a:	0f b6 c0             	movzbl %al,%eax
  100f3d:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100f42:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f48:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f4c:	89 c2                	mov    %eax,%edx
  100f4e:	ec                   	in     (%dx),%al
  100f4f:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f52:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f58:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f5c:	89 c2                	mov    %eax,%edx
  100f5e:	ec                   	in     (%dx),%al
  100f5f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f62:	a1 88 7e 11 00       	mov    0x117e88,%eax
  100f67:	85 c0                	test   %eax,%eax
  100f69:	74 0c                	je     100f77 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100f6b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f72:	e8 d6 06 00 00       	call   10164d <pic_enable>
    }
}
  100f77:	c9                   	leave  
  100f78:	c3                   	ret    

00100f79 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f79:	55                   	push   %ebp
  100f7a:	89 e5                	mov    %esp,%ebp
  100f7c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f86:	eb 09                	jmp    100f91 <lpt_putc_sub+0x18>
        delay();
  100f88:	e8 db fd ff ff       	call   100d68 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f91:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f97:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f9b:	89 c2                	mov    %eax,%edx
  100f9d:	ec                   	in     (%dx),%al
  100f9e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fa1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fa5:	84 c0                	test   %al,%al
  100fa7:	78 09                	js     100fb2 <lpt_putc_sub+0x39>
  100fa9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fb0:	7e d6                	jle    100f88 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb5:	0f b6 c0             	movzbl %al,%eax
  100fb8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100fbe:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
  100fdd:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100fe3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  100fe7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100feb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100ff0:	c9                   	leave  
  100ff1:	c3                   	ret    

00100ff2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100ff2:	55                   	push   %ebp
  100ff3:	89 e5                	mov    %esp,%ebp
  100ff5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100ff8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100ffc:	74 0d                	je     10100b <lpt_putc+0x19>
        lpt_putc_sub(c);
  100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  101001:	89 04 24             	mov    %eax,(%esp)
  101004:	e8 70 ff ff ff       	call   100f79 <lpt_putc_sub>
  101009:	eb 24                	jmp    10102f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10100b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101012:	e8 62 ff ff ff       	call   100f79 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101017:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10101e:	e8 56 ff ff ff       	call   100f79 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101023:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10102a:	e8 4a ff ff ff       	call   100f79 <lpt_putc_sub>
    }
}
  10102f:	c9                   	leave  
  101030:	c3                   	ret    

00101031 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101031:	55                   	push   %ebp
  101032:	89 e5                	mov    %esp,%ebp
  101034:	53                   	push   %ebx
  101035:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101038:	8b 45 08             	mov    0x8(%ebp),%eax
  10103b:	b0 00                	mov    $0x0,%al
  10103d:	85 c0                	test   %eax,%eax
  10103f:	75 07                	jne    101048 <cga_putc+0x17>
        c |= 0x0700;
  101041:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101048:	8b 45 08             	mov    0x8(%ebp),%eax
  10104b:	0f b6 c0             	movzbl %al,%eax
  10104e:	83 f8 0a             	cmp    $0xa,%eax
  101051:	74 4c                	je     10109f <cga_putc+0x6e>
  101053:	83 f8 0d             	cmp    $0xd,%eax
  101056:	74 57                	je     1010af <cga_putc+0x7e>
  101058:	83 f8 08             	cmp    $0x8,%eax
  10105b:	0f 85 88 00 00 00    	jne    1010e9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101061:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101068:	66 85 c0             	test   %ax,%ax
  10106b:	74 30                	je     10109d <cga_putc+0x6c>
            crt_pos --;
  10106d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101074:	83 e8 01             	sub    $0x1,%eax
  101077:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10107d:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101082:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101089:	0f b7 d2             	movzwl %dx,%edx
  10108c:	01 d2                	add    %edx,%edx
  10108e:	01 c2                	add    %eax,%edx
  101090:	8b 45 08             	mov    0x8(%ebp),%eax
  101093:	b0 00                	mov    $0x0,%al
  101095:	83 c8 20             	or     $0x20,%eax
  101098:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10109b:	eb 72                	jmp    10110f <cga_putc+0xde>
  10109d:	eb 70                	jmp    10110f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10109f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010a6:	83 c0 50             	add    $0x50,%eax
  1010a9:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010af:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  1010b6:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  1010bd:	0f b7 c1             	movzwl %cx,%eax
  1010c0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010c6:	c1 e8 10             	shr    $0x10,%eax
  1010c9:	89 c2                	mov    %eax,%edx
  1010cb:	66 c1 ea 06          	shr    $0x6,%dx
  1010cf:	89 d0                	mov    %edx,%eax
  1010d1:	c1 e0 02             	shl    $0x2,%eax
  1010d4:	01 d0                	add    %edx,%eax
  1010d6:	c1 e0 04             	shl    $0x4,%eax
  1010d9:	29 c1                	sub    %eax,%ecx
  1010db:	89 ca                	mov    %ecx,%edx
  1010dd:	89 d8                	mov    %ebx,%eax
  1010df:	29 d0                	sub    %edx,%eax
  1010e1:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1010e7:	eb 26                	jmp    10110f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010e9:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1010ef:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010f6:	8d 50 01             	lea    0x1(%eax),%edx
  1010f9:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  101100:	0f b7 c0             	movzwl %ax,%eax
  101103:	01 c0                	add    %eax,%eax
  101105:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101108:	8b 45 08             	mov    0x8(%ebp),%eax
  10110b:	66 89 02             	mov    %ax,(%edx)
        break;
  10110e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10110f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101116:	66 3d cf 07          	cmp    $0x7cf,%ax
  10111a:	76 5b                	jbe    101177 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10111c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101121:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101127:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10112c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101133:	00 
  101134:	89 54 24 04          	mov    %edx,0x4(%esp)
  101138:	89 04 24             	mov    %eax,(%esp)
  10113b:	e8 e7 48 00 00       	call   105a27 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101140:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101147:	eb 15                	jmp    10115e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101149:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101151:	01 d2                	add    %edx,%edx
  101153:	01 d0                	add    %edx,%eax
  101155:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10115a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10115e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101165:	7e e2                	jle    101149 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101167:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10116e:	83 e8 50             	sub    $0x50,%eax
  101171:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101177:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10117e:	0f b7 c0             	movzwl %ax,%eax
  101181:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101185:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101189:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10118d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101191:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101192:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101199:	66 c1 e8 08          	shr    $0x8,%ax
  10119d:	0f b6 c0             	movzbl %al,%eax
  1011a0:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011a7:	83 c2 01             	add    $0x1,%edx
  1011aa:	0f b7 d2             	movzwl %dx,%edx
  1011ad:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011b1:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011b4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011b8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011bc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011bd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011cb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1011cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011d7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011d8:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011df:	0f b6 c0             	movzbl %al,%eax
  1011e2:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011e9:	83 c2 01             	add    $0x1,%edx
  1011ec:	0f b7 d2             	movzwl %dx,%edx
  1011ef:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1011f3:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1011f6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011fa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011fe:	ee                   	out    %al,(%dx)
}
  1011ff:	83 c4 34             	add    $0x34,%esp
  101202:	5b                   	pop    %ebx
  101203:	5d                   	pop    %ebp
  101204:	c3                   	ret    

00101205 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101205:	55                   	push   %ebp
  101206:	89 e5                	mov    %esp,%ebp
  101208:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101212:	eb 09                	jmp    10121d <serial_putc_sub+0x18>
        delay();
  101214:	e8 4f fb ff ff       	call   100d68 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101219:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10121d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101223:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101227:	89 c2                	mov    %eax,%edx
  101229:	ec                   	in     (%dx),%al
  10122a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10122d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101231:	0f b6 c0             	movzbl %al,%eax
  101234:	83 e0 20             	and    $0x20,%eax
  101237:	85 c0                	test   %eax,%eax
  101239:	75 09                	jne    101244 <serial_putc_sub+0x3f>
  10123b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101242:	7e d0                	jle    101214 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101244:	8b 45 08             	mov    0x8(%ebp),%eax
  101247:	0f b6 c0             	movzbl %al,%eax
  10124a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101250:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101253:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101257:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
}
  10125c:	c9                   	leave  
  10125d:	c3                   	ret    

0010125e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10125e:	55                   	push   %ebp
  10125f:	89 e5                	mov    %esp,%ebp
  101261:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101264:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101268:	74 0d                	je     101277 <serial_putc+0x19>
        serial_putc_sub(c);
  10126a:	8b 45 08             	mov    0x8(%ebp),%eax
  10126d:	89 04 24             	mov    %eax,(%esp)
  101270:	e8 90 ff ff ff       	call   101205 <serial_putc_sub>
  101275:	eb 24                	jmp    10129b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101277:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10127e:	e8 82 ff ff ff       	call   101205 <serial_putc_sub>
        serial_putc_sub(' ');
  101283:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10128a:	e8 76 ff ff ff       	call   101205 <serial_putc_sub>
        serial_putc_sub('\b');
  10128f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101296:	e8 6a ff ff ff       	call   101205 <serial_putc_sub>
    }
}
  10129b:	c9                   	leave  
  10129c:	c3                   	ret    

0010129d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10129d:	55                   	push   %ebp
  10129e:	89 e5                	mov    %esp,%ebp
  1012a0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012a3:	eb 33                	jmp    1012d8 <cons_intr+0x3b>
        if (c != 0) {
  1012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012a9:	74 2d                	je     1012d8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012ab:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012b0:	8d 50 01             	lea    0x1(%eax),%edx
  1012b3:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  1012b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012bc:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012c2:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012c7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012cc:	75 0a                	jne    1012d8 <cons_intr+0x3b>
                cons.wpos = 0;
  1012ce:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1012d5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012db:	ff d0                	call   *%eax
  1012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012e4:	75 bf                	jne    1012a5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012e6:	c9                   	leave  
  1012e7:	c3                   	ret    

001012e8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012e8:	55                   	push   %ebp
  1012e9:	89 e5                	mov    %esp,%ebp
  1012eb:	83 ec 10             	sub    $0x10,%esp
  1012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f8:	89 c2                	mov    %eax,%edx
  1012fa:	ec                   	in     (%dx),%al
  1012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101302:	0f b6 c0             	movzbl %al,%eax
  101305:	83 e0 01             	and    $0x1,%eax
  101308:	85 c0                	test   %eax,%eax
  10130a:	75 07                	jne    101313 <serial_proc_data+0x2b>
        return -1;
  10130c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101311:	eb 2a                	jmp    10133d <serial_proc_data+0x55>
  101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101319:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10131d:	89 c2                	mov    %eax,%edx
  10131f:	ec                   	in     (%dx),%al
  101320:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101327:	0f b6 c0             	movzbl %al,%eax
  10132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10132d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101331:	75 07                	jne    10133a <serial_proc_data+0x52>
        c = '\b';
  101333:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10133a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10133d:	c9                   	leave  
  10133e:	c3                   	ret    

0010133f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10133f:	55                   	push   %ebp
  101340:	89 e5                	mov    %esp,%ebp
  101342:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101345:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10134a:	85 c0                	test   %eax,%eax
  10134c:	74 0c                	je     10135a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10134e:	c7 04 24 e8 12 10 00 	movl   $0x1012e8,(%esp)
  101355:	e8 43 ff ff ff       	call   10129d <cons_intr>
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 38             	sub    $0x38,%esp
  101362:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101368:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10136c:	89 c2                	mov    %eax,%edx
  10136e:	ec                   	in     (%dx),%al
  10136f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101372:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101376:	0f b6 c0             	movzbl %al,%eax
  101379:	83 e0 01             	and    $0x1,%eax
  10137c:	85 c0                	test   %eax,%eax
  10137e:	75 0a                	jne    10138a <kbd_proc_data+0x2e>
        return -1;
  101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101385:	e9 59 01 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
  10138a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101390:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101394:	89 c2                	mov    %eax,%edx
  101396:	ec                   	in     (%dx),%al
  101397:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10139a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10139e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013a1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013a5:	75 17                	jne    1013be <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013a7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013ac:	83 c8 40             	or     $0x40,%eax
  1013af:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  1013b9:	e9 25 01 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013c2:	84 c0                	test   %al,%al
  1013c4:	79 47                	jns    10140d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013c6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013cb:	83 e0 40             	and    $0x40,%eax
  1013ce:	85 c0                	test   %eax,%eax
  1013d0:	75 09                	jne    1013db <kbd_proc_data+0x7f>
  1013d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013d6:	83 e0 7f             	and    $0x7f,%eax
  1013d9:	eb 04                	jmp    1013df <kbd_proc_data+0x83>
  1013db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013df:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e6:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1013ed:	83 c8 40             	or     $0x40,%eax
  1013f0:	0f b6 c0             	movzbl %al,%eax
  1013f3:	f7 d0                	not    %eax
  1013f5:	89 c2                	mov    %eax,%edx
  1013f7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013fc:	21 d0                	and    %edx,%eax
  1013fe:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101403:	b8 00 00 00 00       	mov    $0x0,%eax
  101408:	e9 d6 00 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10140d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101412:	83 e0 40             	and    $0x40,%eax
  101415:	85 c0                	test   %eax,%eax
  101417:	74 11                	je     10142a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101419:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10141d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101422:	83 e0 bf             	and    $0xffffffbf,%eax
  101425:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  10142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142e:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101435:	0f b6 d0             	movzbl %al,%edx
  101438:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10143d:	09 d0                	or     %edx,%eax
  10143f:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101448:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10144f:	0f b6 d0             	movzbl %al,%edx
  101452:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101457:	31 d0                	xor    %edx,%eax
  101459:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10145e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101463:	83 e0 03             	and    $0x3,%eax
  101466:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10146d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101471:	01 d0                	add    %edx,%eax
  101473:	0f b6 00             	movzbl (%eax),%eax
  101476:	0f b6 c0             	movzbl %al,%eax
  101479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10147c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101481:	83 e0 08             	and    $0x8,%eax
  101484:	85 c0                	test   %eax,%eax
  101486:	74 22                	je     1014aa <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101488:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10148c:	7e 0c                	jle    10149a <kbd_proc_data+0x13e>
  10148e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101492:	7f 06                	jg     10149a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101494:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101498:	eb 10                	jmp    1014aa <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10149a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10149e:	7e 0a                	jle    1014aa <kbd_proc_data+0x14e>
  1014a0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014a4:	7f 04                	jg     1014aa <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014a6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014aa:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014af:	f7 d0                	not    %eax
  1014b1:	83 e0 06             	and    $0x6,%eax
  1014b4:	85 c0                	test   %eax,%eax
  1014b6:	75 28                	jne    1014e0 <kbd_proc_data+0x184>
  1014b8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014bf:	75 1f                	jne    1014e0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014c1:	c7 04 24 75 5e 10 00 	movl   $0x105e75,(%esp)
  1014c8:	e8 6f ee ff ff       	call   10033c <cprintf>
  1014cd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014d3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014d7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1014db:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1014df:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014e3:	c9                   	leave  
  1014e4:	c3                   	ret    

001014e5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014e5:	55                   	push   %ebp
  1014e6:	89 e5                	mov    %esp,%ebp
  1014e8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014eb:	c7 04 24 5c 13 10 00 	movl   $0x10135c,(%esp)
  1014f2:	e8 a6 fd ff ff       	call   10129d <cons_intr>
}
  1014f7:	c9                   	leave  
  1014f8:	c3                   	ret    

001014f9 <kbd_init>:

static void
kbd_init(void) {
  1014f9:	55                   	push   %ebp
  1014fa:	89 e5                	mov    %esp,%ebp
  1014fc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1014ff:	e8 e1 ff ff ff       	call   1014e5 <kbd_intr>
    pic_enable(IRQ_KBD);
  101504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10150b:	e8 3d 01 00 00       	call   10164d <pic_enable>
}
  101510:	c9                   	leave  
  101511:	c3                   	ret    

00101512 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101512:	55                   	push   %ebp
  101513:	89 e5                	mov    %esp,%ebp
  101515:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101518:	e8 93 f8 ff ff       	call   100db0 <cga_init>
    serial_init();
  10151d:	e8 74 f9 ff ff       	call   100e96 <serial_init>
    kbd_init();
  101522:	e8 d2 ff ff ff       	call   1014f9 <kbd_init>
    if (!serial_exists) {
  101527:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10152c:	85 c0                	test   %eax,%eax
  10152e:	75 0c                	jne    10153c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101530:	c7 04 24 81 5e 10 00 	movl   $0x105e81,(%esp)
  101537:	e8 00 ee ff ff       	call   10033c <cprintf>
    }
}
  10153c:	c9                   	leave  
  10153d:	c3                   	ret    

0010153e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10153e:	55                   	push   %ebp
  10153f:	89 e5                	mov    %esp,%ebp
  101541:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101544:	e8 e2 f7 ff ff       	call   100d2b <__intr_save>
  101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10154c:	8b 45 08             	mov    0x8(%ebp),%eax
  10154f:	89 04 24             	mov    %eax,(%esp)
  101552:	e8 9b fa ff ff       	call   100ff2 <lpt_putc>
        cga_putc(c);
  101557:	8b 45 08             	mov    0x8(%ebp),%eax
  10155a:	89 04 24             	mov    %eax,(%esp)
  10155d:	e8 cf fa ff ff       	call   101031 <cga_putc>
        serial_putc(c);
  101562:	8b 45 08             	mov    0x8(%ebp),%eax
  101565:	89 04 24             	mov    %eax,(%esp)
  101568:	e8 f1 fc ff ff       	call   10125e <serial_putc>
    }
    local_intr_restore(intr_flag);
  10156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101570:	89 04 24             	mov    %eax,(%esp)
  101573:	e8 dd f7 ff ff       	call   100d55 <__intr_restore>
}
  101578:	c9                   	leave  
  101579:	c3                   	ret    

0010157a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10157a:	55                   	push   %ebp
  10157b:	89 e5                	mov    %esp,%ebp
  10157d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101587:	e8 9f f7 ff ff       	call   100d2b <__intr_save>
  10158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10158f:	e8 ab fd ff ff       	call   10133f <serial_intr>
        kbd_intr();
  101594:	e8 4c ff ff ff       	call   1014e5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101599:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10159f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1015a4:	39 c2                	cmp    %eax,%edx
  1015a6:	74 31                	je     1015d9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1015a8:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015ad:	8d 50 01             	lea    0x1(%eax),%edx
  1015b0:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  1015b6:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  1015bd:	0f b6 c0             	movzbl %al,%eax
  1015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1015c3:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015c8:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015cd:	75 0a                	jne    1015d9 <cons_getc+0x5f>
                cons.rpos = 0;
  1015cf:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1015d6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015dc:	89 04 24             	mov    %eax,(%esp)
  1015df:	e8 71 f7 ff ff       	call   100d55 <__intr_restore>
    return c;
  1015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015e7:	c9                   	leave  
  1015e8:	c3                   	ret    

001015e9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015e9:	55                   	push   %ebp
  1015ea:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015ec:	fb                   	sti    
    sti();
}
  1015ed:	5d                   	pop    %ebp
  1015ee:	c3                   	ret    

001015ef <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015ef:	55                   	push   %ebp
  1015f0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1015f2:	fa                   	cli    
    cli();
}
  1015f3:	5d                   	pop    %ebp
  1015f4:	c3                   	ret    

001015f5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015f5:	55                   	push   %ebp
  1015f6:	89 e5                	mov    %esp,%ebp
  1015f8:	83 ec 14             	sub    $0x14,%esp
  1015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1015fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101602:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101606:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  10160c:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	74 36                	je     10164b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101615:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101619:	0f b6 c0             	movzbl %al,%eax
  10161c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101622:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101625:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101629:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10162d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10162e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101632:	66 c1 e8 08          	shr    $0x8,%ax
  101636:	0f b6 c0             	movzbl %al,%eax
  101639:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10163f:	88 45 f9             	mov    %al,-0x7(%ebp)
  101642:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101646:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10164a:	ee                   	out    %al,(%dx)
    }
}
  10164b:	c9                   	leave  
  10164c:	c3                   	ret    

0010164d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101653:	8b 45 08             	mov    0x8(%ebp),%eax
  101656:	ba 01 00 00 00       	mov    $0x1,%edx
  10165b:	89 c1                	mov    %eax,%ecx
  10165d:	d3 e2                	shl    %cl,%edx
  10165f:	89 d0                	mov    %edx,%eax
  101661:	f7 d0                	not    %eax
  101663:	89 c2                	mov    %eax,%edx
  101665:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10166c:	21 d0                	and    %edx,%eax
  10166e:	0f b7 c0             	movzwl %ax,%eax
  101671:	89 04 24             	mov    %eax,(%esp)
  101674:	e8 7c ff ff ff       	call   1015f5 <pic_setmask>
}
  101679:	c9                   	leave  
  10167a:	c3                   	ret    

0010167b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10167b:	55                   	push   %ebp
  10167c:	89 e5                	mov    %esp,%ebp
  10167e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101681:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101688:	00 00 00 
  10168b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101691:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101695:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101699:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10169d:	ee                   	out    %al,(%dx)
  10169e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016a4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016a8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ac:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016b0:	ee                   	out    %al,(%dx)
  1016b1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016b7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016c3:	ee                   	out    %al,(%dx)
  1016c4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016ca:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016d6:	ee                   	out    %al,(%dx)
  1016d7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016dd:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016e1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016e5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
  1016ea:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1016f0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1016f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1016f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101703:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101707:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10170b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101716:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10171a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10171e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101729:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10172d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101731:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10173c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101740:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101744:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10174f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101753:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101757:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101762:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101766:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10176a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101775:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101788:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10178c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101790:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101795:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10179c:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017a0:	74 12                	je     1017b4 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017a2:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1017a9:	0f b7 c0             	movzwl %ax,%eax
  1017ac:	89 04 24             	mov    %eax,(%esp)
  1017af:	e8 41 fe ff ff       	call   1015f5 <pic_setmask>
    }
}
  1017b4:	c9                   	leave  
  1017b5:	c3                   	ret    

001017b6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017b6:	55                   	push   %ebp
  1017b7:	89 e5                	mov    %esp,%ebp
  1017b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017bc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017c3:	00 
  1017c4:	c7 04 24 a0 5e 10 00 	movl   $0x105ea0,(%esp)
  1017cb:	e8 6c eb ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1017d0:	c7 04 24 aa 5e 10 00 	movl   $0x105eaa,(%esp)
  1017d7:	e8 60 eb ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  1017dc:	c7 44 24 08 b8 5e 10 	movl   $0x105eb8,0x8(%esp)
  1017e3:	00 
  1017e4:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1017eb:	00 
  1017ec:	c7 04 24 ce 5e 10 00 	movl   $0x105ece,(%esp)
  1017f3:	e8 14 f4 ff ff       	call   100c0c <__panic>

001017f8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f8:	55                   	push   %ebp
  1017f9:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1017fb:	5d                   	pop    %ebp
  1017fc:	c3                   	ret    

001017fd <trapname>:

static const char *
trapname(int trapno) {
  1017fd:	55                   	push   %ebp
  1017fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101800:	8b 45 08             	mov    0x8(%ebp),%eax
  101803:	83 f8 13             	cmp    $0x13,%eax
  101806:	77 0c                	ja     101814 <trapname+0x17>
        return excnames[trapno];
  101808:	8b 45 08             	mov    0x8(%ebp),%eax
  10180b:	8b 04 85 20 62 10 00 	mov    0x106220(,%eax,4),%eax
  101812:	eb 18                	jmp    10182c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101814:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101818:	7e 0d                	jle    101827 <trapname+0x2a>
  10181a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10181e:	7f 07                	jg     101827 <trapname+0x2a>
        return "Hardware Interrupt";
  101820:	b8 df 5e 10 00       	mov    $0x105edf,%eax
  101825:	eb 05                	jmp    10182c <trapname+0x2f>
    }
    return "(unknown trap)";
  101827:	b8 f2 5e 10 00       	mov    $0x105ef2,%eax
}
  10182c:	5d                   	pop    %ebp
  10182d:	c3                   	ret    

0010182e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10182e:	55                   	push   %ebp
  10182f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101831:	8b 45 08             	mov    0x8(%ebp),%eax
  101834:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101838:	66 83 f8 08          	cmp    $0x8,%ax
  10183c:	0f 94 c0             	sete   %al
  10183f:	0f b6 c0             	movzbl %al,%eax
}
  101842:	5d                   	pop    %ebp
  101843:	c3                   	ret    

00101844 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101844:	55                   	push   %ebp
  101845:	89 e5                	mov    %esp,%ebp
  101847:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  10184a:	8b 45 08             	mov    0x8(%ebp),%eax
  10184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101851:	c7 04 24 33 5f 10 00 	movl   $0x105f33,(%esp)
  101858:	e8 df ea ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  10185d:	8b 45 08             	mov    0x8(%ebp),%eax
  101860:	89 04 24             	mov    %eax,(%esp)
  101863:	e8 a1 01 00 00       	call   101a09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101868:	8b 45 08             	mov    0x8(%ebp),%eax
  10186b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10186f:	0f b7 c0             	movzwl %ax,%eax
  101872:	89 44 24 04          	mov    %eax,0x4(%esp)
  101876:	c7 04 24 44 5f 10 00 	movl   $0x105f44,(%esp)
  10187d:	e8 ba ea ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101882:	8b 45 08             	mov    0x8(%ebp),%eax
  101885:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101889:	0f b7 c0             	movzwl %ax,%eax
  10188c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101890:	c7 04 24 57 5f 10 00 	movl   $0x105f57,(%esp)
  101897:	e8 a0 ea ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10189c:	8b 45 08             	mov    0x8(%ebp),%eax
  10189f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018a3:	0f b7 c0             	movzwl %ax,%eax
  1018a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018aa:	c7 04 24 6a 5f 10 00 	movl   $0x105f6a,(%esp)
  1018b1:	e8 86 ea ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018bd:	0f b7 c0             	movzwl %ax,%eax
  1018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018c4:	c7 04 24 7d 5f 10 00 	movl   $0x105f7d,(%esp)
  1018cb:	e8 6c ea ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d3:	8b 40 30             	mov    0x30(%eax),%eax
  1018d6:	89 04 24             	mov    %eax,(%esp)
  1018d9:	e8 1f ff ff ff       	call   1017fd <trapname>
  1018de:	8b 55 08             	mov    0x8(%ebp),%edx
  1018e1:	8b 52 30             	mov    0x30(%edx),%edx
  1018e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1018e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018ec:	c7 04 24 90 5f 10 00 	movl   $0x105f90,(%esp)
  1018f3:	e8 44 ea ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018fb:	8b 40 34             	mov    0x34(%eax),%eax
  1018fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101902:	c7 04 24 a2 5f 10 00 	movl   $0x105fa2,(%esp)
  101909:	e8 2e ea ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  10190e:	8b 45 08             	mov    0x8(%ebp),%eax
  101911:	8b 40 38             	mov    0x38(%eax),%eax
  101914:	89 44 24 04          	mov    %eax,0x4(%esp)
  101918:	c7 04 24 b1 5f 10 00 	movl   $0x105fb1,(%esp)
  10191f:	e8 18 ea ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101924:	8b 45 08             	mov    0x8(%ebp),%eax
  101927:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10192b:	0f b7 c0             	movzwl %ax,%eax
  10192e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101932:	c7 04 24 c0 5f 10 00 	movl   $0x105fc0,(%esp)
  101939:	e8 fe e9 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  10193e:	8b 45 08             	mov    0x8(%ebp),%eax
  101941:	8b 40 40             	mov    0x40(%eax),%eax
  101944:	89 44 24 04          	mov    %eax,0x4(%esp)
  101948:	c7 04 24 d3 5f 10 00 	movl   $0x105fd3,(%esp)
  10194f:	e8 e8 e9 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10195b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101962:	eb 3e                	jmp    1019a2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101964:	8b 45 08             	mov    0x8(%ebp),%eax
  101967:	8b 50 40             	mov    0x40(%eax),%edx
  10196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10196d:	21 d0                	and    %edx,%eax
  10196f:	85 c0                	test   %eax,%eax
  101971:	74 28                	je     10199b <print_trapframe+0x157>
  101973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101976:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  10197d:	85 c0                	test   %eax,%eax
  10197f:	74 1a                	je     10199b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101984:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  10198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10198f:	c7 04 24 e2 5f 10 00 	movl   $0x105fe2,(%esp)
  101996:	e8 a1 e9 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10199b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10199f:	d1 65 f0             	shll   -0x10(%ebp)
  1019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019a5:	83 f8 17             	cmp    $0x17,%eax
  1019a8:	76 ba                	jbe    101964 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ad:	8b 40 40             	mov    0x40(%eax),%eax
  1019b0:	25 00 30 00 00       	and    $0x3000,%eax
  1019b5:	c1 e8 0c             	shr    $0xc,%eax
  1019b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019bc:	c7 04 24 e6 5f 10 00 	movl   $0x105fe6,(%esp)
  1019c3:	e8 74 e9 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  1019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cb:	89 04 24             	mov    %eax,(%esp)
  1019ce:	e8 5b fe ff ff       	call   10182e <trap_in_kernel>
  1019d3:	85 c0                	test   %eax,%eax
  1019d5:	75 30                	jne    101a07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019da:	8b 40 44             	mov    0x44(%eax),%eax
  1019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e1:	c7 04 24 ef 5f 10 00 	movl   $0x105fef,(%esp)
  1019e8:	e8 4f e9 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  1019f4:	0f b7 c0             	movzwl %ax,%eax
  1019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fb:	c7 04 24 fe 5f 10 00 	movl   $0x105ffe,(%esp)
  101a02:	e8 35 e9 ff ff       	call   10033c <cprintf>
    }
}
  101a07:	c9                   	leave  
  101a08:	c3                   	ret    

00101a09 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a09:	55                   	push   %ebp
  101a0a:	89 e5                	mov    %esp,%ebp
  101a0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	8b 00                	mov    (%eax),%eax
  101a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a18:	c7 04 24 11 60 10 00 	movl   $0x106011,(%esp)
  101a1f:	e8 18 e9 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	8b 40 04             	mov    0x4(%eax),%eax
  101a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2e:	c7 04 24 20 60 10 00 	movl   $0x106020,(%esp)
  101a35:	e8 02 e9 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3d:	8b 40 08             	mov    0x8(%eax),%eax
  101a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a44:	c7 04 24 2f 60 10 00 	movl   $0x10602f,(%esp)
  101a4b:	e8 ec e8 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a50:	8b 45 08             	mov    0x8(%ebp),%eax
  101a53:	8b 40 0c             	mov    0xc(%eax),%eax
  101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5a:	c7 04 24 3e 60 10 00 	movl   $0x10603e,(%esp)
  101a61:	e8 d6 e8 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a66:	8b 45 08             	mov    0x8(%ebp),%eax
  101a69:	8b 40 10             	mov    0x10(%eax),%eax
  101a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a70:	c7 04 24 4d 60 10 00 	movl   $0x10604d,(%esp)
  101a77:	e8 c0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7f:	8b 40 14             	mov    0x14(%eax),%eax
  101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a86:	c7 04 24 5c 60 10 00 	movl   $0x10605c,(%esp)
  101a8d:	e8 aa e8 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	8b 40 18             	mov    0x18(%eax),%eax
  101a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9c:	c7 04 24 6b 60 10 00 	movl   $0x10606b,(%esp)
  101aa3:	e8 94 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aab:	8b 40 1c             	mov    0x1c(%eax),%eax
  101aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab2:	c7 04 24 7a 60 10 00 	movl   $0x10607a,(%esp)
  101ab9:	e8 7e e8 ff ff       	call   10033c <cprintf>
}
  101abe:	c9                   	leave  
  101abf:	c3                   	ret    

00101ac0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ac0:	55                   	push   %ebp
  101ac1:	89 e5                	mov    %esp,%ebp
  101ac3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac9:	8b 40 30             	mov    0x30(%eax),%eax
  101acc:	83 f8 2f             	cmp    $0x2f,%eax
  101acf:	77 1e                	ja     101aef <trap_dispatch+0x2f>
  101ad1:	83 f8 2e             	cmp    $0x2e,%eax
  101ad4:	0f 83 bf 00 00 00    	jae    101b99 <trap_dispatch+0xd9>
  101ada:	83 f8 21             	cmp    $0x21,%eax
  101add:	74 40                	je     101b1f <trap_dispatch+0x5f>
  101adf:	83 f8 24             	cmp    $0x24,%eax
  101ae2:	74 15                	je     101af9 <trap_dispatch+0x39>
  101ae4:	83 f8 20             	cmp    $0x20,%eax
  101ae7:	0f 84 af 00 00 00    	je     101b9c <trap_dispatch+0xdc>
  101aed:	eb 72                	jmp    101b61 <trap_dispatch+0xa1>
  101aef:	83 e8 78             	sub    $0x78,%eax
  101af2:	83 f8 01             	cmp    $0x1,%eax
  101af5:	77 6a                	ja     101b61 <trap_dispatch+0xa1>
  101af7:	eb 4c                	jmp    101b45 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101af9:	e8 7c fa ff ff       	call   10157a <cons_getc>
  101afe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b09:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b11:	c7 04 24 89 60 10 00 	movl   $0x106089,(%esp)
  101b18:	e8 1f e8 ff ff       	call   10033c <cprintf>
        break;
  101b1d:	eb 7e                	jmp    101b9d <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b1f:	e8 56 fa ff ff       	call   10157a <cons_getc>
  101b24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b37:	c7 04 24 9b 60 10 00 	movl   $0x10609b,(%esp)
  101b3e:	e8 f9 e7 ff ff       	call   10033c <cprintf>
        break;
  101b43:	eb 58                	jmp    101b9d <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b45:	c7 44 24 08 aa 60 10 	movl   $0x1060aa,0x8(%esp)
  101b4c:	00 
  101b4d:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b54:	00 
  101b55:	c7 04 24 ce 5e 10 00 	movl   $0x105ece,(%esp)
  101b5c:	e8 ab f0 ff ff       	call   100c0c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b61:	8b 45 08             	mov    0x8(%ebp),%eax
  101b64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b68:	0f b7 c0             	movzwl %ax,%eax
  101b6b:	83 e0 03             	and    $0x3,%eax
  101b6e:	85 c0                	test   %eax,%eax
  101b70:	75 2b                	jne    101b9d <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	89 04 24             	mov    %eax,(%esp)
  101b78:	e8 c7 fc ff ff       	call   101844 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b7d:	c7 44 24 08 ba 60 10 	movl   $0x1060ba,0x8(%esp)
  101b84:	00 
  101b85:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101b8c:	00 
  101b8d:	c7 04 24 ce 5e 10 00 	movl   $0x105ece,(%esp)
  101b94:	e8 73 f0 ff ff       	call   100c0c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101b99:	90                   	nop
  101b9a:	eb 01                	jmp    101b9d <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101b9c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101b9d:	c9                   	leave  
  101b9e:	c3                   	ret    

00101b9f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101b9f:	55                   	push   %ebp
  101ba0:	89 e5                	mov    %esp,%ebp
  101ba2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	89 04 24             	mov    %eax,(%esp)
  101bab:	e8 10 ff ff ff       	call   101ac0 <trap_dispatch>
}
  101bb0:	c9                   	leave  
  101bb1:	c3                   	ret    

00101bb2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101bb2:	1e                   	push   %ds
    pushl %es
  101bb3:	06                   	push   %es
    pushl %fs
  101bb4:	0f a0                	push   %fs
    pushl %gs
  101bb6:	0f a8                	push   %gs
    pushal
  101bb8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101bb9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101bbe:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101bc0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101bc2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101bc3:	e8 d7 ff ff ff       	call   101b9f <trap>

    # pop the pushed stack pointer
    popl %esp
  101bc8:	5c                   	pop    %esp

00101bc9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101bc9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101bca:	0f a9                	pop    %gs
    popl %fs
  101bcc:	0f a1                	pop    %fs
    popl %es
  101bce:	07                   	pop    %es
    popl %ds
  101bcf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101bd0:	83 c4 08             	add    $0x8,%esp
    iret
  101bd3:	cf                   	iret   

00101bd4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bd4:	6a 00                	push   $0x0
  pushl $0
  101bd6:	6a 00                	push   $0x0
  jmp __alltraps
  101bd8:	e9 d5 ff ff ff       	jmp    101bb2 <__alltraps>

00101bdd <vector1>:
.globl vector1
vector1:
  pushl $0
  101bdd:	6a 00                	push   $0x0
  pushl $1
  101bdf:	6a 01                	push   $0x1
  jmp __alltraps
  101be1:	e9 cc ff ff ff       	jmp    101bb2 <__alltraps>

00101be6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101be6:	6a 00                	push   $0x0
  pushl $2
  101be8:	6a 02                	push   $0x2
  jmp __alltraps
  101bea:	e9 c3 ff ff ff       	jmp    101bb2 <__alltraps>

00101bef <vector3>:
.globl vector3
vector3:
  pushl $0
  101bef:	6a 00                	push   $0x0
  pushl $3
  101bf1:	6a 03                	push   $0x3
  jmp __alltraps
  101bf3:	e9 ba ff ff ff       	jmp    101bb2 <__alltraps>

00101bf8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101bf8:	6a 00                	push   $0x0
  pushl $4
  101bfa:	6a 04                	push   $0x4
  jmp __alltraps
  101bfc:	e9 b1 ff ff ff       	jmp    101bb2 <__alltraps>

00101c01 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c01:	6a 00                	push   $0x0
  pushl $5
  101c03:	6a 05                	push   $0x5
  jmp __alltraps
  101c05:	e9 a8 ff ff ff       	jmp    101bb2 <__alltraps>

00101c0a <vector6>:
.globl vector6
vector6:
  pushl $0
  101c0a:	6a 00                	push   $0x0
  pushl $6
  101c0c:	6a 06                	push   $0x6
  jmp __alltraps
  101c0e:	e9 9f ff ff ff       	jmp    101bb2 <__alltraps>

00101c13 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c13:	6a 00                	push   $0x0
  pushl $7
  101c15:	6a 07                	push   $0x7
  jmp __alltraps
  101c17:	e9 96 ff ff ff       	jmp    101bb2 <__alltraps>

00101c1c <vector8>:
.globl vector8
vector8:
  pushl $8
  101c1c:	6a 08                	push   $0x8
  jmp __alltraps
  101c1e:	e9 8f ff ff ff       	jmp    101bb2 <__alltraps>

00101c23 <vector9>:
.globl vector9
vector9:
  pushl $9
  101c23:	6a 09                	push   $0x9
  jmp __alltraps
  101c25:	e9 88 ff ff ff       	jmp    101bb2 <__alltraps>

00101c2a <vector10>:
.globl vector10
vector10:
  pushl $10
  101c2a:	6a 0a                	push   $0xa
  jmp __alltraps
  101c2c:	e9 81 ff ff ff       	jmp    101bb2 <__alltraps>

00101c31 <vector11>:
.globl vector11
vector11:
  pushl $11
  101c31:	6a 0b                	push   $0xb
  jmp __alltraps
  101c33:	e9 7a ff ff ff       	jmp    101bb2 <__alltraps>

00101c38 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c38:	6a 0c                	push   $0xc
  jmp __alltraps
  101c3a:	e9 73 ff ff ff       	jmp    101bb2 <__alltraps>

00101c3f <vector13>:
.globl vector13
vector13:
  pushl $13
  101c3f:	6a 0d                	push   $0xd
  jmp __alltraps
  101c41:	e9 6c ff ff ff       	jmp    101bb2 <__alltraps>

00101c46 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c46:	6a 0e                	push   $0xe
  jmp __alltraps
  101c48:	e9 65 ff ff ff       	jmp    101bb2 <__alltraps>

00101c4d <vector15>:
.globl vector15
vector15:
  pushl $0
  101c4d:	6a 00                	push   $0x0
  pushl $15
  101c4f:	6a 0f                	push   $0xf
  jmp __alltraps
  101c51:	e9 5c ff ff ff       	jmp    101bb2 <__alltraps>

00101c56 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c56:	6a 00                	push   $0x0
  pushl $16
  101c58:	6a 10                	push   $0x10
  jmp __alltraps
  101c5a:	e9 53 ff ff ff       	jmp    101bb2 <__alltraps>

00101c5f <vector17>:
.globl vector17
vector17:
  pushl $17
  101c5f:	6a 11                	push   $0x11
  jmp __alltraps
  101c61:	e9 4c ff ff ff       	jmp    101bb2 <__alltraps>

00101c66 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c66:	6a 00                	push   $0x0
  pushl $18
  101c68:	6a 12                	push   $0x12
  jmp __alltraps
  101c6a:	e9 43 ff ff ff       	jmp    101bb2 <__alltraps>

00101c6f <vector19>:
.globl vector19
vector19:
  pushl $0
  101c6f:	6a 00                	push   $0x0
  pushl $19
  101c71:	6a 13                	push   $0x13
  jmp __alltraps
  101c73:	e9 3a ff ff ff       	jmp    101bb2 <__alltraps>

00101c78 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c78:	6a 00                	push   $0x0
  pushl $20
  101c7a:	6a 14                	push   $0x14
  jmp __alltraps
  101c7c:	e9 31 ff ff ff       	jmp    101bb2 <__alltraps>

00101c81 <vector21>:
.globl vector21
vector21:
  pushl $0
  101c81:	6a 00                	push   $0x0
  pushl $21
  101c83:	6a 15                	push   $0x15
  jmp __alltraps
  101c85:	e9 28 ff ff ff       	jmp    101bb2 <__alltraps>

00101c8a <vector22>:
.globl vector22
vector22:
  pushl $0
  101c8a:	6a 00                	push   $0x0
  pushl $22
  101c8c:	6a 16                	push   $0x16
  jmp __alltraps
  101c8e:	e9 1f ff ff ff       	jmp    101bb2 <__alltraps>

00101c93 <vector23>:
.globl vector23
vector23:
  pushl $0
  101c93:	6a 00                	push   $0x0
  pushl $23
  101c95:	6a 17                	push   $0x17
  jmp __alltraps
  101c97:	e9 16 ff ff ff       	jmp    101bb2 <__alltraps>

00101c9c <vector24>:
.globl vector24
vector24:
  pushl $0
  101c9c:	6a 00                	push   $0x0
  pushl $24
  101c9e:	6a 18                	push   $0x18
  jmp __alltraps
  101ca0:	e9 0d ff ff ff       	jmp    101bb2 <__alltraps>

00101ca5 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ca5:	6a 00                	push   $0x0
  pushl $25
  101ca7:	6a 19                	push   $0x19
  jmp __alltraps
  101ca9:	e9 04 ff ff ff       	jmp    101bb2 <__alltraps>

00101cae <vector26>:
.globl vector26
vector26:
  pushl $0
  101cae:	6a 00                	push   $0x0
  pushl $26
  101cb0:	6a 1a                	push   $0x1a
  jmp __alltraps
  101cb2:	e9 fb fe ff ff       	jmp    101bb2 <__alltraps>

00101cb7 <vector27>:
.globl vector27
vector27:
  pushl $0
  101cb7:	6a 00                	push   $0x0
  pushl $27
  101cb9:	6a 1b                	push   $0x1b
  jmp __alltraps
  101cbb:	e9 f2 fe ff ff       	jmp    101bb2 <__alltraps>

00101cc0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101cc0:	6a 00                	push   $0x0
  pushl $28
  101cc2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cc4:	e9 e9 fe ff ff       	jmp    101bb2 <__alltraps>

00101cc9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cc9:	6a 00                	push   $0x0
  pushl $29
  101ccb:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ccd:	e9 e0 fe ff ff       	jmp    101bb2 <__alltraps>

00101cd2 <vector30>:
.globl vector30
vector30:
  pushl $0
  101cd2:	6a 00                	push   $0x0
  pushl $30
  101cd4:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cd6:	e9 d7 fe ff ff       	jmp    101bb2 <__alltraps>

00101cdb <vector31>:
.globl vector31
vector31:
  pushl $0
  101cdb:	6a 00                	push   $0x0
  pushl $31
  101cdd:	6a 1f                	push   $0x1f
  jmp __alltraps
  101cdf:	e9 ce fe ff ff       	jmp    101bb2 <__alltraps>

00101ce4 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ce4:	6a 00                	push   $0x0
  pushl $32
  101ce6:	6a 20                	push   $0x20
  jmp __alltraps
  101ce8:	e9 c5 fe ff ff       	jmp    101bb2 <__alltraps>

00101ced <vector33>:
.globl vector33
vector33:
  pushl $0
  101ced:	6a 00                	push   $0x0
  pushl $33
  101cef:	6a 21                	push   $0x21
  jmp __alltraps
  101cf1:	e9 bc fe ff ff       	jmp    101bb2 <__alltraps>

00101cf6 <vector34>:
.globl vector34
vector34:
  pushl $0
  101cf6:	6a 00                	push   $0x0
  pushl $34
  101cf8:	6a 22                	push   $0x22
  jmp __alltraps
  101cfa:	e9 b3 fe ff ff       	jmp    101bb2 <__alltraps>

00101cff <vector35>:
.globl vector35
vector35:
  pushl $0
  101cff:	6a 00                	push   $0x0
  pushl $35
  101d01:	6a 23                	push   $0x23
  jmp __alltraps
  101d03:	e9 aa fe ff ff       	jmp    101bb2 <__alltraps>

00101d08 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d08:	6a 00                	push   $0x0
  pushl $36
  101d0a:	6a 24                	push   $0x24
  jmp __alltraps
  101d0c:	e9 a1 fe ff ff       	jmp    101bb2 <__alltraps>

00101d11 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d11:	6a 00                	push   $0x0
  pushl $37
  101d13:	6a 25                	push   $0x25
  jmp __alltraps
  101d15:	e9 98 fe ff ff       	jmp    101bb2 <__alltraps>

00101d1a <vector38>:
.globl vector38
vector38:
  pushl $0
  101d1a:	6a 00                	push   $0x0
  pushl $38
  101d1c:	6a 26                	push   $0x26
  jmp __alltraps
  101d1e:	e9 8f fe ff ff       	jmp    101bb2 <__alltraps>

00101d23 <vector39>:
.globl vector39
vector39:
  pushl $0
  101d23:	6a 00                	push   $0x0
  pushl $39
  101d25:	6a 27                	push   $0x27
  jmp __alltraps
  101d27:	e9 86 fe ff ff       	jmp    101bb2 <__alltraps>

00101d2c <vector40>:
.globl vector40
vector40:
  pushl $0
  101d2c:	6a 00                	push   $0x0
  pushl $40
  101d2e:	6a 28                	push   $0x28
  jmp __alltraps
  101d30:	e9 7d fe ff ff       	jmp    101bb2 <__alltraps>

00101d35 <vector41>:
.globl vector41
vector41:
  pushl $0
  101d35:	6a 00                	push   $0x0
  pushl $41
  101d37:	6a 29                	push   $0x29
  jmp __alltraps
  101d39:	e9 74 fe ff ff       	jmp    101bb2 <__alltraps>

00101d3e <vector42>:
.globl vector42
vector42:
  pushl $0
  101d3e:	6a 00                	push   $0x0
  pushl $42
  101d40:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d42:	e9 6b fe ff ff       	jmp    101bb2 <__alltraps>

00101d47 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d47:	6a 00                	push   $0x0
  pushl $43
  101d49:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d4b:	e9 62 fe ff ff       	jmp    101bb2 <__alltraps>

00101d50 <vector44>:
.globl vector44
vector44:
  pushl $0
  101d50:	6a 00                	push   $0x0
  pushl $44
  101d52:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d54:	e9 59 fe ff ff       	jmp    101bb2 <__alltraps>

00101d59 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d59:	6a 00                	push   $0x0
  pushl $45
  101d5b:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d5d:	e9 50 fe ff ff       	jmp    101bb2 <__alltraps>

00101d62 <vector46>:
.globl vector46
vector46:
  pushl $0
  101d62:	6a 00                	push   $0x0
  pushl $46
  101d64:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d66:	e9 47 fe ff ff       	jmp    101bb2 <__alltraps>

00101d6b <vector47>:
.globl vector47
vector47:
  pushl $0
  101d6b:	6a 00                	push   $0x0
  pushl $47
  101d6d:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d6f:	e9 3e fe ff ff       	jmp    101bb2 <__alltraps>

00101d74 <vector48>:
.globl vector48
vector48:
  pushl $0
  101d74:	6a 00                	push   $0x0
  pushl $48
  101d76:	6a 30                	push   $0x30
  jmp __alltraps
  101d78:	e9 35 fe ff ff       	jmp    101bb2 <__alltraps>

00101d7d <vector49>:
.globl vector49
vector49:
  pushl $0
  101d7d:	6a 00                	push   $0x0
  pushl $49
  101d7f:	6a 31                	push   $0x31
  jmp __alltraps
  101d81:	e9 2c fe ff ff       	jmp    101bb2 <__alltraps>

00101d86 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d86:	6a 00                	push   $0x0
  pushl $50
  101d88:	6a 32                	push   $0x32
  jmp __alltraps
  101d8a:	e9 23 fe ff ff       	jmp    101bb2 <__alltraps>

00101d8f <vector51>:
.globl vector51
vector51:
  pushl $0
  101d8f:	6a 00                	push   $0x0
  pushl $51
  101d91:	6a 33                	push   $0x33
  jmp __alltraps
  101d93:	e9 1a fe ff ff       	jmp    101bb2 <__alltraps>

00101d98 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d98:	6a 00                	push   $0x0
  pushl $52
  101d9a:	6a 34                	push   $0x34
  jmp __alltraps
  101d9c:	e9 11 fe ff ff       	jmp    101bb2 <__alltraps>

00101da1 <vector53>:
.globl vector53
vector53:
  pushl $0
  101da1:	6a 00                	push   $0x0
  pushl $53
  101da3:	6a 35                	push   $0x35
  jmp __alltraps
  101da5:	e9 08 fe ff ff       	jmp    101bb2 <__alltraps>

00101daa <vector54>:
.globl vector54
vector54:
  pushl $0
  101daa:	6a 00                	push   $0x0
  pushl $54
  101dac:	6a 36                	push   $0x36
  jmp __alltraps
  101dae:	e9 ff fd ff ff       	jmp    101bb2 <__alltraps>

00101db3 <vector55>:
.globl vector55
vector55:
  pushl $0
  101db3:	6a 00                	push   $0x0
  pushl $55
  101db5:	6a 37                	push   $0x37
  jmp __alltraps
  101db7:	e9 f6 fd ff ff       	jmp    101bb2 <__alltraps>

00101dbc <vector56>:
.globl vector56
vector56:
  pushl $0
  101dbc:	6a 00                	push   $0x0
  pushl $56
  101dbe:	6a 38                	push   $0x38
  jmp __alltraps
  101dc0:	e9 ed fd ff ff       	jmp    101bb2 <__alltraps>

00101dc5 <vector57>:
.globl vector57
vector57:
  pushl $0
  101dc5:	6a 00                	push   $0x0
  pushl $57
  101dc7:	6a 39                	push   $0x39
  jmp __alltraps
  101dc9:	e9 e4 fd ff ff       	jmp    101bb2 <__alltraps>

00101dce <vector58>:
.globl vector58
vector58:
  pushl $0
  101dce:	6a 00                	push   $0x0
  pushl $58
  101dd0:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dd2:	e9 db fd ff ff       	jmp    101bb2 <__alltraps>

00101dd7 <vector59>:
.globl vector59
vector59:
  pushl $0
  101dd7:	6a 00                	push   $0x0
  pushl $59
  101dd9:	6a 3b                	push   $0x3b
  jmp __alltraps
  101ddb:	e9 d2 fd ff ff       	jmp    101bb2 <__alltraps>

00101de0 <vector60>:
.globl vector60
vector60:
  pushl $0
  101de0:	6a 00                	push   $0x0
  pushl $60
  101de2:	6a 3c                	push   $0x3c
  jmp __alltraps
  101de4:	e9 c9 fd ff ff       	jmp    101bb2 <__alltraps>

00101de9 <vector61>:
.globl vector61
vector61:
  pushl $0
  101de9:	6a 00                	push   $0x0
  pushl $61
  101deb:	6a 3d                	push   $0x3d
  jmp __alltraps
  101ded:	e9 c0 fd ff ff       	jmp    101bb2 <__alltraps>

00101df2 <vector62>:
.globl vector62
vector62:
  pushl $0
  101df2:	6a 00                	push   $0x0
  pushl $62
  101df4:	6a 3e                	push   $0x3e
  jmp __alltraps
  101df6:	e9 b7 fd ff ff       	jmp    101bb2 <__alltraps>

00101dfb <vector63>:
.globl vector63
vector63:
  pushl $0
  101dfb:	6a 00                	push   $0x0
  pushl $63
  101dfd:	6a 3f                	push   $0x3f
  jmp __alltraps
  101dff:	e9 ae fd ff ff       	jmp    101bb2 <__alltraps>

00101e04 <vector64>:
.globl vector64
vector64:
  pushl $0
  101e04:	6a 00                	push   $0x0
  pushl $64
  101e06:	6a 40                	push   $0x40
  jmp __alltraps
  101e08:	e9 a5 fd ff ff       	jmp    101bb2 <__alltraps>

00101e0d <vector65>:
.globl vector65
vector65:
  pushl $0
  101e0d:	6a 00                	push   $0x0
  pushl $65
  101e0f:	6a 41                	push   $0x41
  jmp __alltraps
  101e11:	e9 9c fd ff ff       	jmp    101bb2 <__alltraps>

00101e16 <vector66>:
.globl vector66
vector66:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $66
  101e18:	6a 42                	push   $0x42
  jmp __alltraps
  101e1a:	e9 93 fd ff ff       	jmp    101bb2 <__alltraps>

00101e1f <vector67>:
.globl vector67
vector67:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $67
  101e21:	6a 43                	push   $0x43
  jmp __alltraps
  101e23:	e9 8a fd ff ff       	jmp    101bb2 <__alltraps>

00101e28 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e28:	6a 00                	push   $0x0
  pushl $68
  101e2a:	6a 44                	push   $0x44
  jmp __alltraps
  101e2c:	e9 81 fd ff ff       	jmp    101bb2 <__alltraps>

00101e31 <vector69>:
.globl vector69
vector69:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $69
  101e33:	6a 45                	push   $0x45
  jmp __alltraps
  101e35:	e9 78 fd ff ff       	jmp    101bb2 <__alltraps>

00101e3a <vector70>:
.globl vector70
vector70:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $70
  101e3c:	6a 46                	push   $0x46
  jmp __alltraps
  101e3e:	e9 6f fd ff ff       	jmp    101bb2 <__alltraps>

00101e43 <vector71>:
.globl vector71
vector71:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $71
  101e45:	6a 47                	push   $0x47
  jmp __alltraps
  101e47:	e9 66 fd ff ff       	jmp    101bb2 <__alltraps>

00101e4c <vector72>:
.globl vector72
vector72:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $72
  101e4e:	6a 48                	push   $0x48
  jmp __alltraps
  101e50:	e9 5d fd ff ff       	jmp    101bb2 <__alltraps>

00101e55 <vector73>:
.globl vector73
vector73:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $73
  101e57:	6a 49                	push   $0x49
  jmp __alltraps
  101e59:	e9 54 fd ff ff       	jmp    101bb2 <__alltraps>

00101e5e <vector74>:
.globl vector74
vector74:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $74
  101e60:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e62:	e9 4b fd ff ff       	jmp    101bb2 <__alltraps>

00101e67 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $75
  101e69:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e6b:	e9 42 fd ff ff       	jmp    101bb2 <__alltraps>

00101e70 <vector76>:
.globl vector76
vector76:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $76
  101e72:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e74:	e9 39 fd ff ff       	jmp    101bb2 <__alltraps>

00101e79 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $77
  101e7b:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e7d:	e9 30 fd ff ff       	jmp    101bb2 <__alltraps>

00101e82 <vector78>:
.globl vector78
vector78:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $78
  101e84:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e86:	e9 27 fd ff ff       	jmp    101bb2 <__alltraps>

00101e8b <vector79>:
.globl vector79
vector79:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $79
  101e8d:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e8f:	e9 1e fd ff ff       	jmp    101bb2 <__alltraps>

00101e94 <vector80>:
.globl vector80
vector80:
  pushl $0
  101e94:	6a 00                	push   $0x0
  pushl $80
  101e96:	6a 50                	push   $0x50
  jmp __alltraps
  101e98:	e9 15 fd ff ff       	jmp    101bb2 <__alltraps>

00101e9d <vector81>:
.globl vector81
vector81:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $81
  101e9f:	6a 51                	push   $0x51
  jmp __alltraps
  101ea1:	e9 0c fd ff ff       	jmp    101bb2 <__alltraps>

00101ea6 <vector82>:
.globl vector82
vector82:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $82
  101ea8:	6a 52                	push   $0x52
  jmp __alltraps
  101eaa:	e9 03 fd ff ff       	jmp    101bb2 <__alltraps>

00101eaf <vector83>:
.globl vector83
vector83:
  pushl $0
  101eaf:	6a 00                	push   $0x0
  pushl $83
  101eb1:	6a 53                	push   $0x53
  jmp __alltraps
  101eb3:	e9 fa fc ff ff       	jmp    101bb2 <__alltraps>

00101eb8 <vector84>:
.globl vector84
vector84:
  pushl $0
  101eb8:	6a 00                	push   $0x0
  pushl $84
  101eba:	6a 54                	push   $0x54
  jmp __alltraps
  101ebc:	e9 f1 fc ff ff       	jmp    101bb2 <__alltraps>

00101ec1 <vector85>:
.globl vector85
vector85:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $85
  101ec3:	6a 55                	push   $0x55
  jmp __alltraps
  101ec5:	e9 e8 fc ff ff       	jmp    101bb2 <__alltraps>

00101eca <vector86>:
.globl vector86
vector86:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $86
  101ecc:	6a 56                	push   $0x56
  jmp __alltraps
  101ece:	e9 df fc ff ff       	jmp    101bb2 <__alltraps>

00101ed3 <vector87>:
.globl vector87
vector87:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $87
  101ed5:	6a 57                	push   $0x57
  jmp __alltraps
  101ed7:	e9 d6 fc ff ff       	jmp    101bb2 <__alltraps>

00101edc <vector88>:
.globl vector88
vector88:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $88
  101ede:	6a 58                	push   $0x58
  jmp __alltraps
  101ee0:	e9 cd fc ff ff       	jmp    101bb2 <__alltraps>

00101ee5 <vector89>:
.globl vector89
vector89:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $89
  101ee7:	6a 59                	push   $0x59
  jmp __alltraps
  101ee9:	e9 c4 fc ff ff       	jmp    101bb2 <__alltraps>

00101eee <vector90>:
.globl vector90
vector90:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $90
  101ef0:	6a 5a                	push   $0x5a
  jmp __alltraps
  101ef2:	e9 bb fc ff ff       	jmp    101bb2 <__alltraps>

00101ef7 <vector91>:
.globl vector91
vector91:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $91
  101ef9:	6a 5b                	push   $0x5b
  jmp __alltraps
  101efb:	e9 b2 fc ff ff       	jmp    101bb2 <__alltraps>

00101f00 <vector92>:
.globl vector92
vector92:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $92
  101f02:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f04:	e9 a9 fc ff ff       	jmp    101bb2 <__alltraps>

00101f09 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $93
  101f0b:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f0d:	e9 a0 fc ff ff       	jmp    101bb2 <__alltraps>

00101f12 <vector94>:
.globl vector94
vector94:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $94
  101f14:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f16:	e9 97 fc ff ff       	jmp    101bb2 <__alltraps>

00101f1b <vector95>:
.globl vector95
vector95:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $95
  101f1d:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f1f:	e9 8e fc ff ff       	jmp    101bb2 <__alltraps>

00101f24 <vector96>:
.globl vector96
vector96:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $96
  101f26:	6a 60                	push   $0x60
  jmp __alltraps
  101f28:	e9 85 fc ff ff       	jmp    101bb2 <__alltraps>

00101f2d <vector97>:
.globl vector97
vector97:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $97
  101f2f:	6a 61                	push   $0x61
  jmp __alltraps
  101f31:	e9 7c fc ff ff       	jmp    101bb2 <__alltraps>

00101f36 <vector98>:
.globl vector98
vector98:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $98
  101f38:	6a 62                	push   $0x62
  jmp __alltraps
  101f3a:	e9 73 fc ff ff       	jmp    101bb2 <__alltraps>

00101f3f <vector99>:
.globl vector99
vector99:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $99
  101f41:	6a 63                	push   $0x63
  jmp __alltraps
  101f43:	e9 6a fc ff ff       	jmp    101bb2 <__alltraps>

00101f48 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $100
  101f4a:	6a 64                	push   $0x64
  jmp __alltraps
  101f4c:	e9 61 fc ff ff       	jmp    101bb2 <__alltraps>

00101f51 <vector101>:
.globl vector101
vector101:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $101
  101f53:	6a 65                	push   $0x65
  jmp __alltraps
  101f55:	e9 58 fc ff ff       	jmp    101bb2 <__alltraps>

00101f5a <vector102>:
.globl vector102
vector102:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $102
  101f5c:	6a 66                	push   $0x66
  jmp __alltraps
  101f5e:	e9 4f fc ff ff       	jmp    101bb2 <__alltraps>

00101f63 <vector103>:
.globl vector103
vector103:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $103
  101f65:	6a 67                	push   $0x67
  jmp __alltraps
  101f67:	e9 46 fc ff ff       	jmp    101bb2 <__alltraps>

00101f6c <vector104>:
.globl vector104
vector104:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $104
  101f6e:	6a 68                	push   $0x68
  jmp __alltraps
  101f70:	e9 3d fc ff ff       	jmp    101bb2 <__alltraps>

00101f75 <vector105>:
.globl vector105
vector105:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $105
  101f77:	6a 69                	push   $0x69
  jmp __alltraps
  101f79:	e9 34 fc ff ff       	jmp    101bb2 <__alltraps>

00101f7e <vector106>:
.globl vector106
vector106:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $106
  101f80:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f82:	e9 2b fc ff ff       	jmp    101bb2 <__alltraps>

00101f87 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $107
  101f89:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f8b:	e9 22 fc ff ff       	jmp    101bb2 <__alltraps>

00101f90 <vector108>:
.globl vector108
vector108:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $108
  101f92:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f94:	e9 19 fc ff ff       	jmp    101bb2 <__alltraps>

00101f99 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $109
  101f9b:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f9d:	e9 10 fc ff ff       	jmp    101bb2 <__alltraps>

00101fa2 <vector110>:
.globl vector110
vector110:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $110
  101fa4:	6a 6e                	push   $0x6e
  jmp __alltraps
  101fa6:	e9 07 fc ff ff       	jmp    101bb2 <__alltraps>

00101fab <vector111>:
.globl vector111
vector111:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $111
  101fad:	6a 6f                	push   $0x6f
  jmp __alltraps
  101faf:	e9 fe fb ff ff       	jmp    101bb2 <__alltraps>

00101fb4 <vector112>:
.globl vector112
vector112:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $112
  101fb6:	6a 70                	push   $0x70
  jmp __alltraps
  101fb8:	e9 f5 fb ff ff       	jmp    101bb2 <__alltraps>

00101fbd <vector113>:
.globl vector113
vector113:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $113
  101fbf:	6a 71                	push   $0x71
  jmp __alltraps
  101fc1:	e9 ec fb ff ff       	jmp    101bb2 <__alltraps>

00101fc6 <vector114>:
.globl vector114
vector114:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $114
  101fc8:	6a 72                	push   $0x72
  jmp __alltraps
  101fca:	e9 e3 fb ff ff       	jmp    101bb2 <__alltraps>

00101fcf <vector115>:
.globl vector115
vector115:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $115
  101fd1:	6a 73                	push   $0x73
  jmp __alltraps
  101fd3:	e9 da fb ff ff       	jmp    101bb2 <__alltraps>

00101fd8 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $116
  101fda:	6a 74                	push   $0x74
  jmp __alltraps
  101fdc:	e9 d1 fb ff ff       	jmp    101bb2 <__alltraps>

00101fe1 <vector117>:
.globl vector117
vector117:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $117
  101fe3:	6a 75                	push   $0x75
  jmp __alltraps
  101fe5:	e9 c8 fb ff ff       	jmp    101bb2 <__alltraps>

00101fea <vector118>:
.globl vector118
vector118:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $118
  101fec:	6a 76                	push   $0x76
  jmp __alltraps
  101fee:	e9 bf fb ff ff       	jmp    101bb2 <__alltraps>

00101ff3 <vector119>:
.globl vector119
vector119:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $119
  101ff5:	6a 77                	push   $0x77
  jmp __alltraps
  101ff7:	e9 b6 fb ff ff       	jmp    101bb2 <__alltraps>

00101ffc <vector120>:
.globl vector120
vector120:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $120
  101ffe:	6a 78                	push   $0x78
  jmp __alltraps
  102000:	e9 ad fb ff ff       	jmp    101bb2 <__alltraps>

00102005 <vector121>:
.globl vector121
vector121:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $121
  102007:	6a 79                	push   $0x79
  jmp __alltraps
  102009:	e9 a4 fb ff ff       	jmp    101bb2 <__alltraps>

0010200e <vector122>:
.globl vector122
vector122:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $122
  102010:	6a 7a                	push   $0x7a
  jmp __alltraps
  102012:	e9 9b fb ff ff       	jmp    101bb2 <__alltraps>

00102017 <vector123>:
.globl vector123
vector123:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $123
  102019:	6a 7b                	push   $0x7b
  jmp __alltraps
  10201b:	e9 92 fb ff ff       	jmp    101bb2 <__alltraps>

00102020 <vector124>:
.globl vector124
vector124:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $124
  102022:	6a 7c                	push   $0x7c
  jmp __alltraps
  102024:	e9 89 fb ff ff       	jmp    101bb2 <__alltraps>

00102029 <vector125>:
.globl vector125
vector125:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $125
  10202b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10202d:	e9 80 fb ff ff       	jmp    101bb2 <__alltraps>

00102032 <vector126>:
.globl vector126
vector126:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $126
  102034:	6a 7e                	push   $0x7e
  jmp __alltraps
  102036:	e9 77 fb ff ff       	jmp    101bb2 <__alltraps>

0010203b <vector127>:
.globl vector127
vector127:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $127
  10203d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10203f:	e9 6e fb ff ff       	jmp    101bb2 <__alltraps>

00102044 <vector128>:
.globl vector128
vector128:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $128
  102046:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10204b:	e9 62 fb ff ff       	jmp    101bb2 <__alltraps>

00102050 <vector129>:
.globl vector129
vector129:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $129
  102052:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102057:	e9 56 fb ff ff       	jmp    101bb2 <__alltraps>

0010205c <vector130>:
.globl vector130
vector130:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $130
  10205e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102063:	e9 4a fb ff ff       	jmp    101bb2 <__alltraps>

00102068 <vector131>:
.globl vector131
vector131:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $131
  10206a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10206f:	e9 3e fb ff ff       	jmp    101bb2 <__alltraps>

00102074 <vector132>:
.globl vector132
vector132:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $132
  102076:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10207b:	e9 32 fb ff ff       	jmp    101bb2 <__alltraps>

00102080 <vector133>:
.globl vector133
vector133:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $133
  102082:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102087:	e9 26 fb ff ff       	jmp    101bb2 <__alltraps>

0010208c <vector134>:
.globl vector134
vector134:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $134
  10208e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102093:	e9 1a fb ff ff       	jmp    101bb2 <__alltraps>

00102098 <vector135>:
.globl vector135
vector135:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $135
  10209a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10209f:	e9 0e fb ff ff       	jmp    101bb2 <__alltraps>

001020a4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $136
  1020a6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1020ab:	e9 02 fb ff ff       	jmp    101bb2 <__alltraps>

001020b0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $137
  1020b2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020b7:	e9 f6 fa ff ff       	jmp    101bb2 <__alltraps>

001020bc <vector138>:
.globl vector138
vector138:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $138
  1020be:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020c3:	e9 ea fa ff ff       	jmp    101bb2 <__alltraps>

001020c8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $139
  1020ca:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020cf:	e9 de fa ff ff       	jmp    101bb2 <__alltraps>

001020d4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $140
  1020d6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020db:	e9 d2 fa ff ff       	jmp    101bb2 <__alltraps>

001020e0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $141
  1020e2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020e7:	e9 c6 fa ff ff       	jmp    101bb2 <__alltraps>

001020ec <vector142>:
.globl vector142
vector142:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $142
  1020ee:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020f3:	e9 ba fa ff ff       	jmp    101bb2 <__alltraps>

001020f8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $143
  1020fa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020ff:	e9 ae fa ff ff       	jmp    101bb2 <__alltraps>

00102104 <vector144>:
.globl vector144
vector144:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $144
  102106:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10210b:	e9 a2 fa ff ff       	jmp    101bb2 <__alltraps>

00102110 <vector145>:
.globl vector145
vector145:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $145
  102112:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102117:	e9 96 fa ff ff       	jmp    101bb2 <__alltraps>

0010211c <vector146>:
.globl vector146
vector146:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $146
  10211e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102123:	e9 8a fa ff ff       	jmp    101bb2 <__alltraps>

00102128 <vector147>:
.globl vector147
vector147:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $147
  10212a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10212f:	e9 7e fa ff ff       	jmp    101bb2 <__alltraps>

00102134 <vector148>:
.globl vector148
vector148:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $148
  102136:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10213b:	e9 72 fa ff ff       	jmp    101bb2 <__alltraps>

00102140 <vector149>:
.globl vector149
vector149:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $149
  102142:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102147:	e9 66 fa ff ff       	jmp    101bb2 <__alltraps>

0010214c <vector150>:
.globl vector150
vector150:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $150
  10214e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102153:	e9 5a fa ff ff       	jmp    101bb2 <__alltraps>

00102158 <vector151>:
.globl vector151
vector151:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $151
  10215a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10215f:	e9 4e fa ff ff       	jmp    101bb2 <__alltraps>

00102164 <vector152>:
.globl vector152
vector152:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $152
  102166:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10216b:	e9 42 fa ff ff       	jmp    101bb2 <__alltraps>

00102170 <vector153>:
.globl vector153
vector153:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $153
  102172:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102177:	e9 36 fa ff ff       	jmp    101bb2 <__alltraps>

0010217c <vector154>:
.globl vector154
vector154:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $154
  10217e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102183:	e9 2a fa ff ff       	jmp    101bb2 <__alltraps>

00102188 <vector155>:
.globl vector155
vector155:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $155
  10218a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10218f:	e9 1e fa ff ff       	jmp    101bb2 <__alltraps>

00102194 <vector156>:
.globl vector156
vector156:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $156
  102196:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10219b:	e9 12 fa ff ff       	jmp    101bb2 <__alltraps>

001021a0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $157
  1021a2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1021a7:	e9 06 fa ff ff       	jmp    101bb2 <__alltraps>

001021ac <vector158>:
.globl vector158
vector158:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $158
  1021ae:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021b3:	e9 fa f9 ff ff       	jmp    101bb2 <__alltraps>

001021b8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $159
  1021ba:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021bf:	e9 ee f9 ff ff       	jmp    101bb2 <__alltraps>

001021c4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $160
  1021c6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021cb:	e9 e2 f9 ff ff       	jmp    101bb2 <__alltraps>

001021d0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $161
  1021d2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021d7:	e9 d6 f9 ff ff       	jmp    101bb2 <__alltraps>

001021dc <vector162>:
.globl vector162
vector162:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $162
  1021de:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021e3:	e9 ca f9 ff ff       	jmp    101bb2 <__alltraps>

001021e8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $163
  1021ea:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021ef:	e9 be f9 ff ff       	jmp    101bb2 <__alltraps>

001021f4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $164
  1021f6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021fb:	e9 b2 f9 ff ff       	jmp    101bb2 <__alltraps>

00102200 <vector165>:
.globl vector165
vector165:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $165
  102202:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102207:	e9 a6 f9 ff ff       	jmp    101bb2 <__alltraps>

0010220c <vector166>:
.globl vector166
vector166:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $166
  10220e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102213:	e9 9a f9 ff ff       	jmp    101bb2 <__alltraps>

00102218 <vector167>:
.globl vector167
vector167:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $167
  10221a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10221f:	e9 8e f9 ff ff       	jmp    101bb2 <__alltraps>

00102224 <vector168>:
.globl vector168
vector168:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $168
  102226:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10222b:	e9 82 f9 ff ff       	jmp    101bb2 <__alltraps>

00102230 <vector169>:
.globl vector169
vector169:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $169
  102232:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102237:	e9 76 f9 ff ff       	jmp    101bb2 <__alltraps>

0010223c <vector170>:
.globl vector170
vector170:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $170
  10223e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102243:	e9 6a f9 ff ff       	jmp    101bb2 <__alltraps>

00102248 <vector171>:
.globl vector171
vector171:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $171
  10224a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10224f:	e9 5e f9 ff ff       	jmp    101bb2 <__alltraps>

00102254 <vector172>:
.globl vector172
vector172:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $172
  102256:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10225b:	e9 52 f9 ff ff       	jmp    101bb2 <__alltraps>

00102260 <vector173>:
.globl vector173
vector173:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $173
  102262:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102267:	e9 46 f9 ff ff       	jmp    101bb2 <__alltraps>

0010226c <vector174>:
.globl vector174
vector174:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $174
  10226e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102273:	e9 3a f9 ff ff       	jmp    101bb2 <__alltraps>

00102278 <vector175>:
.globl vector175
vector175:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $175
  10227a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10227f:	e9 2e f9 ff ff       	jmp    101bb2 <__alltraps>

00102284 <vector176>:
.globl vector176
vector176:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $176
  102286:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10228b:	e9 22 f9 ff ff       	jmp    101bb2 <__alltraps>

00102290 <vector177>:
.globl vector177
vector177:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $177
  102292:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102297:	e9 16 f9 ff ff       	jmp    101bb2 <__alltraps>

0010229c <vector178>:
.globl vector178
vector178:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $178
  10229e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1022a3:	e9 0a f9 ff ff       	jmp    101bb2 <__alltraps>

001022a8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $179
  1022aa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1022af:	e9 fe f8 ff ff       	jmp    101bb2 <__alltraps>

001022b4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $180
  1022b6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022bb:	e9 f2 f8 ff ff       	jmp    101bb2 <__alltraps>

001022c0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $181
  1022c2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022c7:	e9 e6 f8 ff ff       	jmp    101bb2 <__alltraps>

001022cc <vector182>:
.globl vector182
vector182:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $182
  1022ce:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022d3:	e9 da f8 ff ff       	jmp    101bb2 <__alltraps>

001022d8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $183
  1022da:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022df:	e9 ce f8 ff ff       	jmp    101bb2 <__alltraps>

001022e4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $184
  1022e6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022eb:	e9 c2 f8 ff ff       	jmp    101bb2 <__alltraps>

001022f0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $185
  1022f2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022f7:	e9 b6 f8 ff ff       	jmp    101bb2 <__alltraps>

001022fc <vector186>:
.globl vector186
vector186:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $186
  1022fe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102303:	e9 aa f8 ff ff       	jmp    101bb2 <__alltraps>

00102308 <vector187>:
.globl vector187
vector187:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $187
  10230a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10230f:	e9 9e f8 ff ff       	jmp    101bb2 <__alltraps>

00102314 <vector188>:
.globl vector188
vector188:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $188
  102316:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10231b:	e9 92 f8 ff ff       	jmp    101bb2 <__alltraps>

00102320 <vector189>:
.globl vector189
vector189:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $189
  102322:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102327:	e9 86 f8 ff ff       	jmp    101bb2 <__alltraps>

0010232c <vector190>:
.globl vector190
vector190:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $190
  10232e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102333:	e9 7a f8 ff ff       	jmp    101bb2 <__alltraps>

00102338 <vector191>:
.globl vector191
vector191:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $191
  10233a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10233f:	e9 6e f8 ff ff       	jmp    101bb2 <__alltraps>

00102344 <vector192>:
.globl vector192
vector192:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $192
  102346:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10234b:	e9 62 f8 ff ff       	jmp    101bb2 <__alltraps>

00102350 <vector193>:
.globl vector193
vector193:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $193
  102352:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102357:	e9 56 f8 ff ff       	jmp    101bb2 <__alltraps>

0010235c <vector194>:
.globl vector194
vector194:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $194
  10235e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102363:	e9 4a f8 ff ff       	jmp    101bb2 <__alltraps>

00102368 <vector195>:
.globl vector195
vector195:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $195
  10236a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10236f:	e9 3e f8 ff ff       	jmp    101bb2 <__alltraps>

00102374 <vector196>:
.globl vector196
vector196:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $196
  102376:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10237b:	e9 32 f8 ff ff       	jmp    101bb2 <__alltraps>

00102380 <vector197>:
.globl vector197
vector197:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $197
  102382:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102387:	e9 26 f8 ff ff       	jmp    101bb2 <__alltraps>

0010238c <vector198>:
.globl vector198
vector198:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $198
  10238e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102393:	e9 1a f8 ff ff       	jmp    101bb2 <__alltraps>

00102398 <vector199>:
.globl vector199
vector199:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $199
  10239a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10239f:	e9 0e f8 ff ff       	jmp    101bb2 <__alltraps>

001023a4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $200
  1023a6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1023ab:	e9 02 f8 ff ff       	jmp    101bb2 <__alltraps>

001023b0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $201
  1023b2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023b7:	e9 f6 f7 ff ff       	jmp    101bb2 <__alltraps>

001023bc <vector202>:
.globl vector202
vector202:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $202
  1023be:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023c3:	e9 ea f7 ff ff       	jmp    101bb2 <__alltraps>

001023c8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $203
  1023ca:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023cf:	e9 de f7 ff ff       	jmp    101bb2 <__alltraps>

001023d4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $204
  1023d6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023db:	e9 d2 f7 ff ff       	jmp    101bb2 <__alltraps>

001023e0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $205
  1023e2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023e7:	e9 c6 f7 ff ff       	jmp    101bb2 <__alltraps>

001023ec <vector206>:
.globl vector206
vector206:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $206
  1023ee:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023f3:	e9 ba f7 ff ff       	jmp    101bb2 <__alltraps>

001023f8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $207
  1023fa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023ff:	e9 ae f7 ff ff       	jmp    101bb2 <__alltraps>

00102404 <vector208>:
.globl vector208
vector208:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $208
  102406:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10240b:	e9 a2 f7 ff ff       	jmp    101bb2 <__alltraps>

00102410 <vector209>:
.globl vector209
vector209:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $209
  102412:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102417:	e9 96 f7 ff ff       	jmp    101bb2 <__alltraps>

0010241c <vector210>:
.globl vector210
vector210:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $210
  10241e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102423:	e9 8a f7 ff ff       	jmp    101bb2 <__alltraps>

00102428 <vector211>:
.globl vector211
vector211:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $211
  10242a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10242f:	e9 7e f7 ff ff       	jmp    101bb2 <__alltraps>

00102434 <vector212>:
.globl vector212
vector212:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $212
  102436:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10243b:	e9 72 f7 ff ff       	jmp    101bb2 <__alltraps>

00102440 <vector213>:
.globl vector213
vector213:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $213
  102442:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102447:	e9 66 f7 ff ff       	jmp    101bb2 <__alltraps>

0010244c <vector214>:
.globl vector214
vector214:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $214
  10244e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102453:	e9 5a f7 ff ff       	jmp    101bb2 <__alltraps>

00102458 <vector215>:
.globl vector215
vector215:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $215
  10245a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10245f:	e9 4e f7 ff ff       	jmp    101bb2 <__alltraps>

00102464 <vector216>:
.globl vector216
vector216:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $216
  102466:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10246b:	e9 42 f7 ff ff       	jmp    101bb2 <__alltraps>

00102470 <vector217>:
.globl vector217
vector217:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $217
  102472:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102477:	e9 36 f7 ff ff       	jmp    101bb2 <__alltraps>

0010247c <vector218>:
.globl vector218
vector218:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $218
  10247e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102483:	e9 2a f7 ff ff       	jmp    101bb2 <__alltraps>

00102488 <vector219>:
.globl vector219
vector219:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $219
  10248a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10248f:	e9 1e f7 ff ff       	jmp    101bb2 <__alltraps>

00102494 <vector220>:
.globl vector220
vector220:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $220
  102496:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10249b:	e9 12 f7 ff ff       	jmp    101bb2 <__alltraps>

001024a0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $221
  1024a2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1024a7:	e9 06 f7 ff ff       	jmp    101bb2 <__alltraps>

001024ac <vector222>:
.globl vector222
vector222:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $222
  1024ae:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024b3:	e9 fa f6 ff ff       	jmp    101bb2 <__alltraps>

001024b8 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $223
  1024ba:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024bf:	e9 ee f6 ff ff       	jmp    101bb2 <__alltraps>

001024c4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $224
  1024c6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024cb:	e9 e2 f6 ff ff       	jmp    101bb2 <__alltraps>

001024d0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $225
  1024d2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024d7:	e9 d6 f6 ff ff       	jmp    101bb2 <__alltraps>

001024dc <vector226>:
.globl vector226
vector226:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $226
  1024de:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024e3:	e9 ca f6 ff ff       	jmp    101bb2 <__alltraps>

001024e8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $227
  1024ea:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024ef:	e9 be f6 ff ff       	jmp    101bb2 <__alltraps>

001024f4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $228
  1024f6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024fb:	e9 b2 f6 ff ff       	jmp    101bb2 <__alltraps>

00102500 <vector229>:
.globl vector229
vector229:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $229
  102502:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102507:	e9 a6 f6 ff ff       	jmp    101bb2 <__alltraps>

0010250c <vector230>:
.globl vector230
vector230:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $230
  10250e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102513:	e9 9a f6 ff ff       	jmp    101bb2 <__alltraps>

00102518 <vector231>:
.globl vector231
vector231:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $231
  10251a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10251f:	e9 8e f6 ff ff       	jmp    101bb2 <__alltraps>

00102524 <vector232>:
.globl vector232
vector232:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $232
  102526:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10252b:	e9 82 f6 ff ff       	jmp    101bb2 <__alltraps>

00102530 <vector233>:
.globl vector233
vector233:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $233
  102532:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102537:	e9 76 f6 ff ff       	jmp    101bb2 <__alltraps>

0010253c <vector234>:
.globl vector234
vector234:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $234
  10253e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102543:	e9 6a f6 ff ff       	jmp    101bb2 <__alltraps>

00102548 <vector235>:
.globl vector235
vector235:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $235
  10254a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10254f:	e9 5e f6 ff ff       	jmp    101bb2 <__alltraps>

00102554 <vector236>:
.globl vector236
vector236:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $236
  102556:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10255b:	e9 52 f6 ff ff       	jmp    101bb2 <__alltraps>

00102560 <vector237>:
.globl vector237
vector237:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $237
  102562:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102567:	e9 46 f6 ff ff       	jmp    101bb2 <__alltraps>

0010256c <vector238>:
.globl vector238
vector238:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $238
  10256e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102573:	e9 3a f6 ff ff       	jmp    101bb2 <__alltraps>

00102578 <vector239>:
.globl vector239
vector239:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $239
  10257a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10257f:	e9 2e f6 ff ff       	jmp    101bb2 <__alltraps>

00102584 <vector240>:
.globl vector240
vector240:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $240
  102586:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10258b:	e9 22 f6 ff ff       	jmp    101bb2 <__alltraps>

00102590 <vector241>:
.globl vector241
vector241:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $241
  102592:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102597:	e9 16 f6 ff ff       	jmp    101bb2 <__alltraps>

0010259c <vector242>:
.globl vector242
vector242:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $242
  10259e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1025a3:	e9 0a f6 ff ff       	jmp    101bb2 <__alltraps>

001025a8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $243
  1025aa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1025af:	e9 fe f5 ff ff       	jmp    101bb2 <__alltraps>

001025b4 <vector244>:
.globl vector244
vector244:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $244
  1025b6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025bb:	e9 f2 f5 ff ff       	jmp    101bb2 <__alltraps>

001025c0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $245
  1025c2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025c7:	e9 e6 f5 ff ff       	jmp    101bb2 <__alltraps>

001025cc <vector246>:
.globl vector246
vector246:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $246
  1025ce:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025d3:	e9 da f5 ff ff       	jmp    101bb2 <__alltraps>

001025d8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $247
  1025da:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025df:	e9 ce f5 ff ff       	jmp    101bb2 <__alltraps>

001025e4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $248
  1025e6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025eb:	e9 c2 f5 ff ff       	jmp    101bb2 <__alltraps>

001025f0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $249
  1025f2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025f7:	e9 b6 f5 ff ff       	jmp    101bb2 <__alltraps>

001025fc <vector250>:
.globl vector250
vector250:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $250
  1025fe:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102603:	e9 aa f5 ff ff       	jmp    101bb2 <__alltraps>

00102608 <vector251>:
.globl vector251
vector251:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $251
  10260a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10260f:	e9 9e f5 ff ff       	jmp    101bb2 <__alltraps>

00102614 <vector252>:
.globl vector252
vector252:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $252
  102616:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10261b:	e9 92 f5 ff ff       	jmp    101bb2 <__alltraps>

00102620 <vector253>:
.globl vector253
vector253:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $253
  102622:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102627:	e9 86 f5 ff ff       	jmp    101bb2 <__alltraps>

0010262c <vector254>:
.globl vector254
vector254:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $254
  10262e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102633:	e9 7a f5 ff ff       	jmp    101bb2 <__alltraps>

00102638 <vector255>:
.globl vector255
vector255:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $255
  10263a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10263f:	e9 6e f5 ff ff       	jmp    101bb2 <__alltraps>

00102644 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102644:	55                   	push   %ebp
  102645:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102647:	8b 55 08             	mov    0x8(%ebp),%edx
  10264a:	a1 64 89 11 00       	mov    0x118964,%eax
  10264f:	29 c2                	sub    %eax,%edx
  102651:	89 d0                	mov    %edx,%eax
  102653:	c1 f8 02             	sar    $0x2,%eax
  102656:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10265c:	5d                   	pop    %ebp
  10265d:	c3                   	ret    

0010265e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10265e:	55                   	push   %ebp
  10265f:	89 e5                	mov    %esp,%ebp
  102661:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102664:	8b 45 08             	mov    0x8(%ebp),%eax
  102667:	89 04 24             	mov    %eax,(%esp)
  10266a:	e8 d5 ff ff ff       	call   102644 <page2ppn>
  10266f:	c1 e0 0c             	shl    $0xc,%eax
}
  102672:	c9                   	leave  
  102673:	c3                   	ret    

00102674 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102674:	55                   	push   %ebp
  102675:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102677:	8b 45 08             	mov    0x8(%ebp),%eax
  10267a:	8b 00                	mov    (%eax),%eax
}
  10267c:	5d                   	pop    %ebp
  10267d:	c3                   	ret    

0010267e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10267e:	55                   	push   %ebp
  10267f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102681:	8b 45 08             	mov    0x8(%ebp),%eax
  102684:	8b 55 0c             	mov    0xc(%ebp),%edx
  102687:	89 10                	mov    %edx,(%eax)
}
  102689:	5d                   	pop    %ebp
  10268a:	c3                   	ret    

0010268b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10268b:	55                   	push   %ebp
  10268c:	89 e5                	mov    %esp,%ebp
  10268e:	83 ec 10             	sub    $0x10,%esp
  102691:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10269b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10269e:	89 50 04             	mov    %edx,0x4(%eax)
  1026a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1026a4:	8b 50 04             	mov    0x4(%eax),%edx
  1026a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1026aa:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1026ac:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1026b3:	00 00 00 
}
  1026b6:	c9                   	leave  
  1026b7:	c3                   	ret    

001026b8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1026b8:	55                   	push   %ebp
  1026b9:	89 e5                	mov    %esp,%ebp
  1026bb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1026be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1026c2:	75 24                	jne    1026e8 <default_init_memmap+0x30>
  1026c4:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  1026cb:	00 
  1026cc:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1026d3:	00 
  1026d4:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1026db:	00 
  1026dc:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1026e3:	e8 24 e5 ff ff       	call   100c0c <__panic>
    struct Page *p = base;
  1026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1026ee:	e9 dc 00 00 00       	jmp    1027cf <default_init_memmap+0x117>
        assert(PageReserved(p));
  1026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026f6:	83 c0 04             	add    $0x4,%eax
  1026f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102700:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102709:	0f a3 10             	bt     %edx,(%eax)
  10270c:	19 c0                	sbb    %eax,%eax
  10270e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102711:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102715:	0f 95 c0             	setne  %al
  102718:	0f b6 c0             	movzbl %al,%eax
  10271b:	85 c0                	test   %eax,%eax
  10271d:	75 24                	jne    102743 <default_init_memmap+0x8b>
  10271f:	c7 44 24 0c a1 62 10 	movl   $0x1062a1,0xc(%esp)
  102726:	00 
  102727:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10272e:	00 
  10272f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102736:	00 
  102737:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10273e:	e8 c9 e4 ff ff       	call   100c0c <__panic>
        p->flags = 0;
  102743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  10274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102750:	83 c0 04             	add    $0x4,%eax
  102753:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10275a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10275d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102763:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102769:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  102770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102777:	00 
  102778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10277b:	89 04 24             	mov    %eax,(%esp)
  10277e:	e8 fb fe ff ff       	call   10267e <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102786:	83 c0 0c             	add    $0xc,%eax
  102789:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102790:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102793:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102796:	8b 00                	mov    (%eax),%eax
  102798:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10279b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10279e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1027a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1027a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1027a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1027aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1027ad:	89 10                	mov    %edx,(%eax)
  1027af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1027b2:	8b 10                	mov    (%eax),%edx
  1027b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1027b7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1027ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1027bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1027c0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1027c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1027c6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1027c9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1027cb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1027cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1027d2:	89 d0                	mov    %edx,%eax
  1027d4:	c1 e0 02             	shl    $0x2,%eax
  1027d7:	01 d0                	add    %edx,%eax
  1027d9:	c1 e0 02             	shl    $0x2,%eax
  1027dc:	89 c2                	mov    %eax,%edx
  1027de:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e1:	01 d0                	add    %edx,%eax
  1027e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1027e6:	0f 85 07 ff ff ff    	jne    1026f3 <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
  1027ec:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1027f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027f5:	01 d0                	add    %edx,%eax
  1027f7:	a3 58 89 11 00       	mov    %eax,0x118958
    //first block
    base->property = n;
  1027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1027ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  102802:	89 50 08             	mov    %edx,0x8(%eax)
}
  102805:	c9                   	leave  
  102806:	c3                   	ret    

00102807 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102807:	55                   	push   %ebp
  102808:	89 e5                	mov    %esp,%ebp
  10280a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10280d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102811:	75 24                	jne    102837 <default_alloc_pages+0x30>
  102813:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  10281a:	00 
  10281b:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102822:	00 
  102823:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  10282a:	00 
  10282b:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102832:	e8 d5 e3 ff ff       	call   100c0c <__panic>
    if (n > nr_free) {
  102837:	a1 58 89 11 00       	mov    0x118958,%eax
  10283c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10283f:	73 0a                	jae    10284b <default_alloc_pages+0x44>
        return NULL;
  102841:	b8 00 00 00 00       	mov    $0x0,%eax
  102846:	e9 37 01 00 00       	jmp    102982 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
  10284b:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
  102852:	e9 0a 01 00 00       	jmp    102961 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
  102857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10285a:	83 e8 0c             	sub    $0xc,%eax
  10285d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
  102860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102863:	8b 40 08             	mov    0x8(%eax),%eax
  102866:	3b 45 08             	cmp    0x8(%ebp),%eax
  102869:	0f 82 f2 00 00 00    	jb     102961 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
  10286f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102876:	eb 7c                	jmp    1028f4 <default_alloc_pages+0xed>
  102878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10287b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10287e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102881:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
  102884:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
  102887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10288a:	83 e8 0c             	sub    $0xc,%eax
  10288d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
  102890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102893:	83 c0 04             	add    $0x4,%eax
  102896:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10289d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1028a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1028a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1028a6:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
  1028a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1028ac:	83 c0 04             	add    $0x4,%eax
  1028af:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1028b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1028b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1028bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1028bf:	0f b3 10             	btr    %edx,(%eax)
  1028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1028c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1028cb:	8b 40 04             	mov    0x4(%eax),%eax
  1028ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1028d1:	8b 12                	mov    (%edx),%edx
  1028d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1028d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1028dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1028df:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1028e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1028e5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1028e8:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
  1028ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1028ed:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
  1028f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  1028fa:	0f 82 78 ff ff ff    	jb     102878 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
  102900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102903:	8b 40 08             	mov    0x8(%eax),%eax
  102906:	3b 45 08             	cmp    0x8(%ebp),%eax
  102909:	76 12                	jbe    10291d <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
  10290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10290e:	8d 50 f4             	lea    -0xc(%eax),%edx
  102911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102914:	8b 40 08             	mov    0x8(%eax),%eax
  102917:	2b 45 08             	sub    0x8(%ebp),%eax
  10291a:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
  10291d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102920:	83 c0 04             	add    $0x4,%eax
  102923:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10292a:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10292d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102930:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102933:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
  102936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102939:	83 c0 04             	add    $0x4,%eax
  10293c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102943:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102946:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102949:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10294c:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
  10294f:	a1 58 89 11 00       	mov    0x118958,%eax
  102954:	2b 45 08             	sub    0x8(%ebp),%eax
  102957:	a3 58 89 11 00       	mov    %eax,0x118958
        return p;
  10295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10295f:	eb 21                	jmp    102982 <default_alloc_pages+0x17b>
  102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102964:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102967:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10296a:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
  10296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102970:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102977:	0f 85 da fe ff ff    	jne    102857 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
  10297d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102982:	c9                   	leave  
  102983:	c3                   	ret    

00102984 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102984:	55                   	push   %ebp
  102985:	89 e5                	mov    %esp,%ebp
  102987:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10298a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10298e:	75 24                	jne    1029b4 <default_free_pages+0x30>
  102990:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  102997:	00 
  102998:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10299f:	00 
  1029a0:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  1029a7:	00 
  1029a8:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1029af:	e8 58 e2 ff ff       	call   100c0c <__panic>
    assert(PageReserved(base));
  1029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b7:	83 c0 04             	add    $0x4,%eax
  1029ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1029c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029ca:	0f a3 10             	bt     %edx,(%eax)
  1029cd:	19 c0                	sbb    %eax,%eax
  1029cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1029d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1029d6:	0f 95 c0             	setne  %al
  1029d9:	0f b6 c0             	movzbl %al,%eax
  1029dc:	85 c0                	test   %eax,%eax
  1029de:	75 24                	jne    102a04 <default_free_pages+0x80>
  1029e0:	c7 44 24 0c b1 62 10 	movl   $0x1062b1,0xc(%esp)
  1029e7:	00 
  1029e8:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1029ef:	00 
  1029f0:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  1029f7:	00 
  1029f8:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1029ff:	e8 08 e2 ff ff       	call   100c0c <__panic>

    list_entry_t *le = &free_list;
  102a04:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
  102a0b:	eb 13                	jmp    102a20 <default_free_pages+0x9c>
      p = le2page(le, page_link);
  102a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a10:	83 e8 0c             	sub    $0xc,%eax
  102a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
  102a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a19:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a1c:	76 02                	jbe    102a20 <default_free_pages+0x9c>
        break;
  102a1e:	eb 18                	jmp    102a38 <default_free_pages+0xb4>
  102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a29:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
  102a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a2f:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102a36:	75 d5                	jne    102a0d <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102a38:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a3e:	eb 4b                	jmp    102a8b <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
  102a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a43:	8d 50 0c             	lea    0xc(%eax),%edx
  102a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a49:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102a4c:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a52:	8b 00                	mov    (%eax),%eax
  102a54:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a57:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a60:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a69:	89 10                	mov    %edx,(%eax)
  102a6b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a6e:	8b 10                	mov    (%eax),%edx
  102a70:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a79:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a82:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a85:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102a87:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a8e:	89 d0                	mov    %edx,%eax
  102a90:	c1 e0 02             	shl    $0x2,%eax
  102a93:	01 d0                	add    %edx,%eax
  102a95:	c1 e0 02             	shl    $0x2,%eax
  102a98:	89 c2                	mov    %eax,%edx
  102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9d:	01 d0                	add    %edx,%eax
  102a9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102aa2:	77 9c                	ja     102a40 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102aae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102ab5:	00 
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	89 04 24             	mov    %eax,(%esp)
  102abc:	e8 bd fb ff ff       	call   10267e <set_page_ref>
    ClearPageProperty(base);
  102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac4:	83 c0 04             	add    $0x4,%eax
  102ac7:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102ace:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ad1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ad4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ad7:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102ada:	8b 45 08             	mov    0x8(%ebp),%eax
  102add:	83 c0 04             	add    $0x4,%eax
  102ae0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102ae7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102aed:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102af0:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102af3:	8b 45 08             	mov    0x8(%ebp),%eax
  102af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102af9:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le,page_link) ;
  102afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aff:	83 e8 0c             	sub    $0xc,%eax
  102b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
  102b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b08:	89 d0                	mov    %edx,%eax
  102b0a:	c1 e0 02             	shl    $0x2,%eax
  102b0d:	01 d0                	add    %edx,%eax
  102b0f:	c1 e0 02             	shl    $0x2,%eax
  102b12:	89 c2                	mov    %eax,%edx
  102b14:	8b 45 08             	mov    0x8(%ebp),%eax
  102b17:	01 d0                	add    %edx,%eax
  102b19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102b1c:	75 1e                	jne    102b3c <default_free_pages+0x1b8>
      base->property += p->property;
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	8b 50 08             	mov    0x8(%eax),%edx
  102b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b27:	8b 40 08             	mov    0x8(%eax),%eax
  102b2a:	01 c2                	add    %eax,%edx
  102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2f:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
  102b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	83 c0 0c             	add    $0xc,%eax
  102b42:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102b45:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b48:	8b 00                	mov    (%eax),%eax
  102b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  102b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b50:	83 e8 0c             	sub    $0xc,%eax
  102b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
  102b56:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102b5d:	74 57                	je     102bb6 <default_free_pages+0x232>
  102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b62:	83 e8 14             	sub    $0x14,%eax
  102b65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102b68:	75 4c                	jne    102bb6 <default_free_pages+0x232>
      while(le!=&free_list){
  102b6a:	eb 41                	jmp    102bad <default_free_pages+0x229>
        if(p->property){
  102b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b6f:	8b 40 08             	mov    0x8(%eax),%eax
  102b72:	85 c0                	test   %eax,%eax
  102b74:	74 20                	je     102b96 <default_free_pages+0x212>
          p->property += base->property;
  102b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b79:	8b 50 08             	mov    0x8(%eax),%edx
  102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7f:	8b 40 08             	mov    0x8(%eax),%eax
  102b82:	01 c2                	add    %eax,%edx
  102b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b87:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
  102b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
  102b94:	eb 20                	jmp    102bb6 <default_free_pages+0x232>
  102b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b99:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102b9c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b9f:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
  102ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
  102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba7:	83 e8 0c             	sub    $0xc,%eax
  102baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
  102bad:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102bb4:	75 b6                	jne    102b6c <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
  102bb6:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bbf:	01 d0                	add    %edx,%eax
  102bc1:	a3 58 89 11 00       	mov    %eax,0x118958
    return ;
  102bc6:	90                   	nop
}
  102bc7:	c9                   	leave  
  102bc8:	c3                   	ret    

00102bc9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102bc9:	55                   	push   %ebp
  102bca:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102bcc:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102bd1:	5d                   	pop    %ebp
  102bd2:	c3                   	ret    

00102bd3 <basic_check>:

static void
basic_check(void) {
  102bd3:	55                   	push   %ebp
  102bd4:	89 e5                	mov    %esp,%ebp
  102bd6:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102bd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102bec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102bf3:	e8 90 0e 00 00       	call   103a88 <alloc_pages>
  102bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102bff:	75 24                	jne    102c25 <basic_check+0x52>
  102c01:	c7 44 24 0c c4 62 10 	movl   $0x1062c4,0xc(%esp)
  102c08:	00 
  102c09:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102c10:	00 
  102c11:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  102c18:	00 
  102c19:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102c20:	e8 e7 df ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102c25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c2c:	e8 57 0e 00 00       	call   103a88 <alloc_pages>
  102c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102c38:	75 24                	jne    102c5e <basic_check+0x8b>
  102c3a:	c7 44 24 0c e0 62 10 	movl   $0x1062e0,0xc(%esp)
  102c41:	00 
  102c42:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102c49:	00 
  102c4a:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102c51:	00 
  102c52:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102c59:	e8 ae df ff ff       	call   100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102c5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c65:	e8 1e 0e 00 00       	call   103a88 <alloc_pages>
  102c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c71:	75 24                	jne    102c97 <basic_check+0xc4>
  102c73:	c7 44 24 0c fc 62 10 	movl   $0x1062fc,0xc(%esp)
  102c7a:	00 
  102c7b:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102c82:	00 
  102c83:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102c8a:	00 
  102c8b:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102c92:	e8 75 df ff ff       	call   100c0c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102c9d:	74 10                	je     102caf <basic_check+0xdc>
  102c9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ca2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ca5:	74 08                	je     102caf <basic_check+0xdc>
  102ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102caa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cad:	75 24                	jne    102cd3 <basic_check+0x100>
  102caf:	c7 44 24 0c 18 63 10 	movl   $0x106318,0xc(%esp)
  102cb6:	00 
  102cb7:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102cbe:	00 
  102cbf:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102cc6:	00 
  102cc7:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102cce:	e8 39 df ff ff       	call   100c0c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cd6:	89 04 24             	mov    %eax,(%esp)
  102cd9:	e8 96 f9 ff ff       	call   102674 <page_ref>
  102cde:	85 c0                	test   %eax,%eax
  102ce0:	75 1e                	jne    102d00 <basic_check+0x12d>
  102ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce5:	89 04 24             	mov    %eax,(%esp)
  102ce8:	e8 87 f9 ff ff       	call   102674 <page_ref>
  102ced:	85 c0                	test   %eax,%eax
  102cef:	75 0f                	jne    102d00 <basic_check+0x12d>
  102cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf4:	89 04 24             	mov    %eax,(%esp)
  102cf7:	e8 78 f9 ff ff       	call   102674 <page_ref>
  102cfc:	85 c0                	test   %eax,%eax
  102cfe:	74 24                	je     102d24 <basic_check+0x151>
  102d00:	c7 44 24 0c 3c 63 10 	movl   $0x10633c,0xc(%esp)
  102d07:	00 
  102d08:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102d0f:	00 
  102d10:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102d17:	00 
  102d18:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d1f:	e8 e8 de ff ff       	call   100c0c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d27:	89 04 24             	mov    %eax,(%esp)
  102d2a:	e8 2f f9 ff ff       	call   10265e <page2pa>
  102d2f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102d35:	c1 e2 0c             	shl    $0xc,%edx
  102d38:	39 d0                	cmp    %edx,%eax
  102d3a:	72 24                	jb     102d60 <basic_check+0x18d>
  102d3c:	c7 44 24 0c 78 63 10 	movl   $0x106378,0xc(%esp)
  102d43:	00 
  102d44:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102d4b:	00 
  102d4c:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102d53:	00 
  102d54:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d5b:	e8 ac de ff ff       	call   100c0c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d63:	89 04 24             	mov    %eax,(%esp)
  102d66:	e8 f3 f8 ff ff       	call   10265e <page2pa>
  102d6b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102d71:	c1 e2 0c             	shl    $0xc,%edx
  102d74:	39 d0                	cmp    %edx,%eax
  102d76:	72 24                	jb     102d9c <basic_check+0x1c9>
  102d78:	c7 44 24 0c 95 63 10 	movl   $0x106395,0xc(%esp)
  102d7f:	00 
  102d80:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102d87:	00 
  102d88:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  102d8f:	00 
  102d90:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d97:	e8 70 de ff ff       	call   100c0c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9f:	89 04 24             	mov    %eax,(%esp)
  102da2:	e8 b7 f8 ff ff       	call   10265e <page2pa>
  102da7:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102dad:	c1 e2 0c             	shl    $0xc,%edx
  102db0:	39 d0                	cmp    %edx,%eax
  102db2:	72 24                	jb     102dd8 <basic_check+0x205>
  102db4:	c7 44 24 0c b2 63 10 	movl   $0x1063b2,0xc(%esp)
  102dbb:	00 
  102dbc:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102dc3:	00 
  102dc4:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102dcb:	00 
  102dcc:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102dd3:	e8 34 de ff ff       	call   100c0c <__panic>

    list_entry_t free_list_store = free_list;
  102dd8:	a1 50 89 11 00       	mov    0x118950,%eax
  102ddd:	8b 15 54 89 11 00    	mov    0x118954,%edx
  102de3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102de6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102de9:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102df6:	89 50 04             	mov    %edx,0x4(%eax)
  102df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dfc:	8b 50 04             	mov    0x4(%eax),%edx
  102dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e02:	89 10                	mov    %edx,(%eax)
  102e04:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e0e:	8b 40 04             	mov    0x4(%eax),%eax
  102e11:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102e14:	0f 94 c0             	sete   %al
  102e17:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102e1a:	85 c0                	test   %eax,%eax
  102e1c:	75 24                	jne    102e42 <basic_check+0x26f>
  102e1e:	c7 44 24 0c cf 63 10 	movl   $0x1063cf,0xc(%esp)
  102e25:	00 
  102e26:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102e2d:	00 
  102e2e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  102e35:	00 
  102e36:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102e3d:	e8 ca dd ff ff       	call   100c0c <__panic>

    unsigned int nr_free_store = nr_free;
  102e42:	a1 58 89 11 00       	mov    0x118958,%eax
  102e47:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102e4a:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102e51:	00 00 00 

    assert(alloc_page() == NULL);
  102e54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e5b:	e8 28 0c 00 00       	call   103a88 <alloc_pages>
  102e60:	85 c0                	test   %eax,%eax
  102e62:	74 24                	je     102e88 <basic_check+0x2b5>
  102e64:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  102e6b:	00 
  102e6c:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102e73:	00 
  102e74:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  102e7b:	00 
  102e7c:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102e83:	e8 84 dd ff ff       	call   100c0c <__panic>

    free_page(p0);
  102e88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102e8f:	00 
  102e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e93:	89 04 24             	mov    %eax,(%esp)
  102e96:	e8 25 0c 00 00       	call   103ac0 <free_pages>
    free_page(p1);
  102e9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102ea2:	00 
  102ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea6:	89 04 24             	mov    %eax,(%esp)
  102ea9:	e8 12 0c 00 00       	call   103ac0 <free_pages>
    free_page(p2);
  102eae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102eb5:	00 
  102eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb9:	89 04 24             	mov    %eax,(%esp)
  102ebc:	e8 ff 0b 00 00       	call   103ac0 <free_pages>
    assert(nr_free == 3);
  102ec1:	a1 58 89 11 00       	mov    0x118958,%eax
  102ec6:	83 f8 03             	cmp    $0x3,%eax
  102ec9:	74 24                	je     102eef <basic_check+0x31c>
  102ecb:	c7 44 24 0c fb 63 10 	movl   $0x1063fb,0xc(%esp)
  102ed2:	00 
  102ed3:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102eda:	00 
  102edb:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  102ee2:	00 
  102ee3:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102eea:	e8 1d dd ff ff       	call   100c0c <__panic>

    assert((p0 = alloc_page()) != NULL);
  102eef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ef6:	e8 8d 0b 00 00       	call   103a88 <alloc_pages>
  102efb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102efe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f02:	75 24                	jne    102f28 <basic_check+0x355>
  102f04:	c7 44 24 0c c4 62 10 	movl   $0x1062c4,0xc(%esp)
  102f0b:	00 
  102f0c:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f13:	00 
  102f14:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  102f1b:	00 
  102f1c:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f23:	e8 e4 dc ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f2f:	e8 54 0b 00 00       	call   103a88 <alloc_pages>
  102f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f3b:	75 24                	jne    102f61 <basic_check+0x38e>
  102f3d:	c7 44 24 0c e0 62 10 	movl   $0x1062e0,0xc(%esp)
  102f44:	00 
  102f45:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f4c:	00 
  102f4d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  102f54:	00 
  102f55:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f5c:	e8 ab dc ff ff       	call   100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f68:	e8 1b 0b 00 00       	call   103a88 <alloc_pages>
  102f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f74:	75 24                	jne    102f9a <basic_check+0x3c7>
  102f76:	c7 44 24 0c fc 62 10 	movl   $0x1062fc,0xc(%esp)
  102f7d:	00 
  102f7e:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f85:	00 
  102f86:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  102f8d:	00 
  102f8e:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f95:	e8 72 dc ff ff       	call   100c0c <__panic>

    assert(alloc_page() == NULL);
  102f9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fa1:	e8 e2 0a 00 00       	call   103a88 <alloc_pages>
  102fa6:	85 c0                	test   %eax,%eax
  102fa8:	74 24                	je     102fce <basic_check+0x3fb>
  102faa:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  102fb1:	00 
  102fb2:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102fb9:	00 
  102fba:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  102fc1:	00 
  102fc2:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102fc9:	e8 3e dc ff ff       	call   100c0c <__panic>

    free_page(p0);
  102fce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102fd5:	00 
  102fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fd9:	89 04 24             	mov    %eax,(%esp)
  102fdc:	e8 df 0a 00 00       	call   103ac0 <free_pages>
  102fe1:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  102fe8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102feb:	8b 40 04             	mov    0x4(%eax),%eax
  102fee:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  102ff1:	0f 94 c0             	sete   %al
  102ff4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  102ff7:	85 c0                	test   %eax,%eax
  102ff9:	74 24                	je     10301f <basic_check+0x44c>
  102ffb:	c7 44 24 0c 08 64 10 	movl   $0x106408,0xc(%esp)
  103002:	00 
  103003:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10300a:	00 
  10300b:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  103012:	00 
  103013:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10301a:	e8 ed db ff ff       	call   100c0c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10301f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103026:	e8 5d 0a 00 00       	call   103a88 <alloc_pages>
  10302b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10302e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103031:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103034:	74 24                	je     10305a <basic_check+0x487>
  103036:	c7 44 24 0c 20 64 10 	movl   $0x106420,0xc(%esp)
  10303d:	00 
  10303e:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103045:	00 
  103046:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10304d:	00 
  10304e:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103055:	e8 b2 db ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  10305a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103061:	e8 22 0a 00 00       	call   103a88 <alloc_pages>
  103066:	85 c0                	test   %eax,%eax
  103068:	74 24                	je     10308e <basic_check+0x4bb>
  10306a:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  103071:	00 
  103072:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103079:	00 
  10307a:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103081:	00 
  103082:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103089:	e8 7e db ff ff       	call   100c0c <__panic>

    assert(nr_free == 0);
  10308e:	a1 58 89 11 00       	mov    0x118958,%eax
  103093:	85 c0                	test   %eax,%eax
  103095:	74 24                	je     1030bb <basic_check+0x4e8>
  103097:	c7 44 24 0c 39 64 10 	movl   $0x106439,0xc(%esp)
  10309e:	00 
  10309f:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1030a6:	00 
  1030a7:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  1030ae:	00 
  1030af:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1030b6:	e8 51 db ff ff       	call   100c0c <__panic>
    free_list = free_list_store;
  1030bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030c1:	a3 50 89 11 00       	mov    %eax,0x118950
  1030c6:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  1030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030cf:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  1030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030db:	00 
  1030dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030df:	89 04 24             	mov    %eax,(%esp)
  1030e2:	e8 d9 09 00 00       	call   103ac0 <free_pages>
    free_page(p1);
  1030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030ee:	00 
  1030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f2:	89 04 24             	mov    %eax,(%esp)
  1030f5:	e8 c6 09 00 00       	call   103ac0 <free_pages>
    free_page(p2);
  1030fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103101:	00 
  103102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103105:	89 04 24             	mov    %eax,(%esp)
  103108:	e8 b3 09 00 00       	call   103ac0 <free_pages>
}
  10310d:	c9                   	leave  
  10310e:	c3                   	ret    

0010310f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10310f:	55                   	push   %ebp
  103110:	89 e5                	mov    %esp,%ebp
  103112:	53                   	push   %ebx
  103113:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103120:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103127:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10312e:	eb 6b                	jmp    10319b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103133:	83 e8 0c             	sub    $0xc,%eax
  103136:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10313c:	83 c0 04             	add    $0x4,%eax
  10313f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103146:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103149:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10314c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10314f:	0f a3 10             	bt     %edx,(%eax)
  103152:	19 c0                	sbb    %eax,%eax
  103154:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103157:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10315b:	0f 95 c0             	setne  %al
  10315e:	0f b6 c0             	movzbl %al,%eax
  103161:	85 c0                	test   %eax,%eax
  103163:	75 24                	jne    103189 <default_check+0x7a>
  103165:	c7 44 24 0c 46 64 10 	movl   $0x106446,0xc(%esp)
  10316c:	00 
  10316d:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103174:	00 
  103175:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10317c:	00 
  10317d:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103184:	e8 83 da ff ff       	call   100c0c <__panic>
        count ++, total += p->property;
  103189:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103190:	8b 50 08             	mov    0x8(%eax),%edx
  103193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103196:	01 d0                	add    %edx,%eax
  103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10319e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1031a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1031a4:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1031a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031aa:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1031b1:	0f 85 79 ff ff ff    	jne    103130 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1031b7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1031ba:	e8 33 09 00 00       	call   103af2 <nr_free_pages>
  1031bf:	39 c3                	cmp    %eax,%ebx
  1031c1:	74 24                	je     1031e7 <default_check+0xd8>
  1031c3:	c7 44 24 0c 56 64 10 	movl   $0x106456,0xc(%esp)
  1031ca:	00 
  1031cb:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1031d2:	00 
  1031d3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  1031da:	00 
  1031db:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1031e2:	e8 25 da ff ff       	call   100c0c <__panic>

    basic_check();
  1031e7:	e8 e7 f9 ff ff       	call   102bd3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1031ec:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1031f3:	e8 90 08 00 00       	call   103a88 <alloc_pages>
  1031f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1031fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031ff:	75 24                	jne    103225 <default_check+0x116>
  103201:	c7 44 24 0c 6f 64 10 	movl   $0x10646f,0xc(%esp)
  103208:	00 
  103209:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103210:	00 
  103211:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103218:	00 
  103219:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103220:	e8 e7 d9 ff ff       	call   100c0c <__panic>
    assert(!PageProperty(p0));
  103225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103228:	83 c0 04             	add    $0x4,%eax
  10322b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103232:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103235:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103238:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10323b:	0f a3 10             	bt     %edx,(%eax)
  10323e:	19 c0                	sbb    %eax,%eax
  103240:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103243:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103247:	0f 95 c0             	setne  %al
  10324a:	0f b6 c0             	movzbl %al,%eax
  10324d:	85 c0                	test   %eax,%eax
  10324f:	74 24                	je     103275 <default_check+0x166>
  103251:	c7 44 24 0c 7a 64 10 	movl   $0x10647a,0xc(%esp)
  103258:	00 
  103259:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103260:	00 
  103261:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103268:	00 
  103269:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103270:	e8 97 d9 ff ff       	call   100c0c <__panic>

    list_entry_t free_list_store = free_list;
  103275:	a1 50 89 11 00       	mov    0x118950,%eax
  10327a:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103280:	89 45 80             	mov    %eax,-0x80(%ebp)
  103283:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103286:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10328d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103290:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103293:	89 50 04             	mov    %edx,0x4(%eax)
  103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103299:	8b 50 04             	mov    0x4(%eax),%edx
  10329c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10329f:	89 10                	mov    %edx,(%eax)
  1032a1:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1032a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1032ab:	8b 40 04             	mov    0x4(%eax),%eax
  1032ae:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1032b1:	0f 94 c0             	sete   %al
  1032b4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032b7:	85 c0                	test   %eax,%eax
  1032b9:	75 24                	jne    1032df <default_check+0x1d0>
  1032bb:	c7 44 24 0c cf 63 10 	movl   $0x1063cf,0xc(%esp)
  1032c2:	00 
  1032c3:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1032ca:	00 
  1032cb:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  1032d2:	00 
  1032d3:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1032da:	e8 2d d9 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  1032df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032e6:	e8 9d 07 00 00       	call   103a88 <alloc_pages>
  1032eb:	85 c0                	test   %eax,%eax
  1032ed:	74 24                	je     103313 <default_check+0x204>
  1032ef:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  1032f6:	00 
  1032f7:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1032fe:	00 
  1032ff:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103306:	00 
  103307:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10330e:	e8 f9 d8 ff ff       	call   100c0c <__panic>

    unsigned int nr_free_store = nr_free;
  103313:	a1 58 89 11 00       	mov    0x118958,%eax
  103318:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10331b:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103322:	00 00 00 

    free_pages(p0 + 2, 3);
  103325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103328:	83 c0 28             	add    $0x28,%eax
  10332b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103332:	00 
  103333:	89 04 24             	mov    %eax,(%esp)
  103336:	e8 85 07 00 00       	call   103ac0 <free_pages>
    assert(alloc_pages(4) == NULL);
  10333b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103342:	e8 41 07 00 00       	call   103a88 <alloc_pages>
  103347:	85 c0                	test   %eax,%eax
  103349:	74 24                	je     10336f <default_check+0x260>
  10334b:	c7 44 24 0c 8c 64 10 	movl   $0x10648c,0xc(%esp)
  103352:	00 
  103353:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10335a:	00 
  10335b:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  103362:	00 
  103363:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10336a:	e8 9d d8 ff ff       	call   100c0c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103372:	83 c0 28             	add    $0x28,%eax
  103375:	83 c0 04             	add    $0x4,%eax
  103378:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10337f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103382:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103385:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103388:	0f a3 10             	bt     %edx,(%eax)
  10338b:	19 c0                	sbb    %eax,%eax
  10338d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103390:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103394:	0f 95 c0             	setne  %al
  103397:	0f b6 c0             	movzbl %al,%eax
  10339a:	85 c0                	test   %eax,%eax
  10339c:	74 0e                	je     1033ac <default_check+0x29d>
  10339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033a1:	83 c0 28             	add    $0x28,%eax
  1033a4:	8b 40 08             	mov    0x8(%eax),%eax
  1033a7:	83 f8 03             	cmp    $0x3,%eax
  1033aa:	74 24                	je     1033d0 <default_check+0x2c1>
  1033ac:	c7 44 24 0c a4 64 10 	movl   $0x1064a4,0xc(%esp)
  1033b3:	00 
  1033b4:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1033bb:	00 
  1033bc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1033c3:	00 
  1033c4:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1033cb:	e8 3c d8 ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1033d0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1033d7:	e8 ac 06 00 00       	call   103a88 <alloc_pages>
  1033dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1033df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1033e3:	75 24                	jne    103409 <default_check+0x2fa>
  1033e5:	c7 44 24 0c d0 64 10 	movl   $0x1064d0,0xc(%esp)
  1033ec:	00 
  1033ed:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1033f4:	00 
  1033f5:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1033fc:	00 
  1033fd:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103404:	e8 03 d8 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  103409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103410:	e8 73 06 00 00       	call   103a88 <alloc_pages>
  103415:	85 c0                	test   %eax,%eax
  103417:	74 24                	je     10343d <default_check+0x32e>
  103419:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  103420:	00 
  103421:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103428:	00 
  103429:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103430:	00 
  103431:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103438:	e8 cf d7 ff ff       	call   100c0c <__panic>
    assert(p0 + 2 == p1);
  10343d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103440:	83 c0 28             	add    $0x28,%eax
  103443:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103446:	74 24                	je     10346c <default_check+0x35d>
  103448:	c7 44 24 0c ee 64 10 	movl   $0x1064ee,0xc(%esp)
  10344f:	00 
  103450:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103457:	00 
  103458:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  10345f:	00 
  103460:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103467:	e8 a0 d7 ff ff       	call   100c0c <__panic>

    p2 = p0 + 1;
  10346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10346f:	83 c0 14             	add    $0x14,%eax
  103472:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103475:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10347c:	00 
  10347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103480:	89 04 24             	mov    %eax,(%esp)
  103483:	e8 38 06 00 00       	call   103ac0 <free_pages>
    free_pages(p1, 3);
  103488:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10348f:	00 
  103490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103493:	89 04 24             	mov    %eax,(%esp)
  103496:	e8 25 06 00 00       	call   103ac0 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10349b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10349e:	83 c0 04             	add    $0x4,%eax
  1034a1:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1034a8:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1034ae:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1034b1:	0f a3 10             	bt     %edx,(%eax)
  1034b4:	19 c0                	sbb    %eax,%eax
  1034b6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1034b9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1034bd:	0f 95 c0             	setne  %al
  1034c0:	0f b6 c0             	movzbl %al,%eax
  1034c3:	85 c0                	test   %eax,%eax
  1034c5:	74 0b                	je     1034d2 <default_check+0x3c3>
  1034c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034ca:	8b 40 08             	mov    0x8(%eax),%eax
  1034cd:	83 f8 01             	cmp    $0x1,%eax
  1034d0:	74 24                	je     1034f6 <default_check+0x3e7>
  1034d2:	c7 44 24 0c fc 64 10 	movl   $0x1064fc,0xc(%esp)
  1034d9:	00 
  1034da:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1034e1:	00 
  1034e2:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1034e9:	00 
  1034ea:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1034f1:	e8 16 d7 ff ff       	call   100c0c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1034f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034f9:	83 c0 04             	add    $0x4,%eax
  1034fc:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103503:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103506:	8b 45 90             	mov    -0x70(%ebp),%eax
  103509:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10350c:	0f a3 10             	bt     %edx,(%eax)
  10350f:	19 c0                	sbb    %eax,%eax
  103511:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103514:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103518:	0f 95 c0             	setne  %al
  10351b:	0f b6 c0             	movzbl %al,%eax
  10351e:	85 c0                	test   %eax,%eax
  103520:	74 0b                	je     10352d <default_check+0x41e>
  103522:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103525:	8b 40 08             	mov    0x8(%eax),%eax
  103528:	83 f8 03             	cmp    $0x3,%eax
  10352b:	74 24                	je     103551 <default_check+0x442>
  10352d:	c7 44 24 0c 24 65 10 	movl   $0x106524,0xc(%esp)
  103534:	00 
  103535:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10353c:	00 
  10353d:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103544:	00 
  103545:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10354c:	e8 bb d6 ff ff       	call   100c0c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103558:	e8 2b 05 00 00       	call   103a88 <alloc_pages>
  10355d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103560:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103563:	83 e8 14             	sub    $0x14,%eax
  103566:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103569:	74 24                	je     10358f <default_check+0x480>
  10356b:	c7 44 24 0c 4a 65 10 	movl   $0x10654a,0xc(%esp)
  103572:	00 
  103573:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10357a:	00 
  10357b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103582:	00 
  103583:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10358a:	e8 7d d6 ff ff       	call   100c0c <__panic>
    free_page(p0);
  10358f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103596:	00 
  103597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10359a:	89 04 24             	mov    %eax,(%esp)
  10359d:	e8 1e 05 00 00       	call   103ac0 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1035a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1035a9:	e8 da 04 00 00       	call   103a88 <alloc_pages>
  1035ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1035b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035b4:	83 c0 14             	add    $0x14,%eax
  1035b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1035ba:	74 24                	je     1035e0 <default_check+0x4d1>
  1035bc:	c7 44 24 0c 68 65 10 	movl   $0x106568,0xc(%esp)
  1035c3:	00 
  1035c4:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1035cb:	00 
  1035cc:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1035d3:	00 
  1035d4:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1035db:	e8 2c d6 ff ff       	call   100c0c <__panic>

    free_pages(p0, 2);
  1035e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1035e7:	00 
  1035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035eb:	89 04 24             	mov    %eax,(%esp)
  1035ee:	e8 cd 04 00 00       	call   103ac0 <free_pages>
    free_page(p2);
  1035f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035fa:	00 
  1035fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035fe:	89 04 24             	mov    %eax,(%esp)
  103601:	e8 ba 04 00 00       	call   103ac0 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103606:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10360d:	e8 76 04 00 00       	call   103a88 <alloc_pages>
  103612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103619:	75 24                	jne    10363f <default_check+0x530>
  10361b:	c7 44 24 0c 88 65 10 	movl   $0x106588,0xc(%esp)
  103622:	00 
  103623:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10362a:	00 
  10362b:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103632:	00 
  103633:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10363a:	e8 cd d5 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  10363f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103646:	e8 3d 04 00 00       	call   103a88 <alloc_pages>
  10364b:	85 c0                	test   %eax,%eax
  10364d:	74 24                	je     103673 <default_check+0x564>
  10364f:	c7 44 24 0c e6 63 10 	movl   $0x1063e6,0xc(%esp)
  103656:	00 
  103657:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10365e:	00 
  10365f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103666:	00 
  103667:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10366e:	e8 99 d5 ff ff       	call   100c0c <__panic>

    assert(nr_free == 0);
  103673:	a1 58 89 11 00       	mov    0x118958,%eax
  103678:	85 c0                	test   %eax,%eax
  10367a:	74 24                	je     1036a0 <default_check+0x591>
  10367c:	c7 44 24 0c 39 64 10 	movl   $0x106439,0xc(%esp)
  103683:	00 
  103684:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10368b:	00 
  10368c:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103693:	00 
  103694:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10369b:	e8 6c d5 ff ff       	call   100c0c <__panic>
    nr_free = nr_free_store;
  1036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036a3:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1036a8:	8b 45 80             	mov    -0x80(%ebp),%eax
  1036ab:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1036ae:	a3 50 89 11 00       	mov    %eax,0x118950
  1036b3:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1036b9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1036c0:	00 
  1036c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c4:	89 04 24             	mov    %eax,(%esp)
  1036c7:	e8 f4 03 00 00       	call   103ac0 <free_pages>

    le = &free_list;
  1036cc:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1036d3:	eb 1d                	jmp    1036f2 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1036d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036d8:	83 e8 0c             	sub    $0xc,%eax
  1036db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1036de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1036e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1036e8:	8b 40 08             	mov    0x8(%eax),%eax
  1036eb:	29 c2                	sub    %eax,%edx
  1036ed:	89 d0                	mov    %edx,%eax
  1036ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036f5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1036f8:	8b 45 88             	mov    -0x78(%ebp),%eax
  1036fb:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1036fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103701:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103708:	75 cb                	jne    1036d5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10370a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10370e:	74 24                	je     103734 <default_check+0x625>
  103710:	c7 44 24 0c a6 65 10 	movl   $0x1065a6,0xc(%esp)
  103717:	00 
  103718:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10371f:	00 
  103720:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  103727:	00 
  103728:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10372f:	e8 d8 d4 ff ff       	call   100c0c <__panic>
    assert(total == 0);
  103734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103738:	74 24                	je     10375e <default_check+0x64f>
  10373a:	c7 44 24 0c b1 65 10 	movl   $0x1065b1,0xc(%esp)
  103741:	00 
  103742:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103749:	00 
  10374a:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  103751:	00 
  103752:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103759:	e8 ae d4 ff ff       	call   100c0c <__panic>
}
  10375e:	81 c4 94 00 00 00    	add    $0x94,%esp
  103764:	5b                   	pop    %ebx
  103765:	5d                   	pop    %ebp
  103766:	c3                   	ret    

00103767 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103767:	55                   	push   %ebp
  103768:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10376a:	8b 55 08             	mov    0x8(%ebp),%edx
  10376d:	a1 64 89 11 00       	mov    0x118964,%eax
  103772:	29 c2                	sub    %eax,%edx
  103774:	89 d0                	mov    %edx,%eax
  103776:	c1 f8 02             	sar    $0x2,%eax
  103779:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10377f:	5d                   	pop    %ebp
  103780:	c3                   	ret    

00103781 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103781:	55                   	push   %ebp
  103782:	89 e5                	mov    %esp,%ebp
  103784:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103787:	8b 45 08             	mov    0x8(%ebp),%eax
  10378a:	89 04 24             	mov    %eax,(%esp)
  10378d:	e8 d5 ff ff ff       	call   103767 <page2ppn>
  103792:	c1 e0 0c             	shl    $0xc,%eax
}
  103795:	c9                   	leave  
  103796:	c3                   	ret    

00103797 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103797:	55                   	push   %ebp
  103798:	89 e5                	mov    %esp,%ebp
  10379a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  10379d:	8b 45 08             	mov    0x8(%ebp),%eax
  1037a0:	c1 e8 0c             	shr    $0xc,%eax
  1037a3:	89 c2                	mov    %eax,%edx
  1037a5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1037aa:	39 c2                	cmp    %eax,%edx
  1037ac:	72 1c                	jb     1037ca <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1037ae:	c7 44 24 08 ec 65 10 	movl   $0x1065ec,0x8(%esp)
  1037b5:	00 
  1037b6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1037bd:	00 
  1037be:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1037c5:	e8 42 d4 ff ff       	call   100c0c <__panic>
    }
    return &pages[PPN(pa)];
  1037ca:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  1037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d3:	c1 e8 0c             	shr    $0xc,%eax
  1037d6:	89 c2                	mov    %eax,%edx
  1037d8:	89 d0                	mov    %edx,%eax
  1037da:	c1 e0 02             	shl    $0x2,%eax
  1037dd:	01 d0                	add    %edx,%eax
  1037df:	c1 e0 02             	shl    $0x2,%eax
  1037e2:	01 c8                	add    %ecx,%eax
}
  1037e4:	c9                   	leave  
  1037e5:	c3                   	ret    

001037e6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1037e6:	55                   	push   %ebp
  1037e7:	89 e5                	mov    %esp,%ebp
  1037e9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1037ef:	89 04 24             	mov    %eax,(%esp)
  1037f2:	e8 8a ff ff ff       	call   103781 <page2pa>
  1037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037fd:	c1 e8 0c             	shr    $0xc,%eax
  103800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103803:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103808:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10380b:	72 23                	jb     103830 <page2kva+0x4a>
  10380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103810:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103814:	c7 44 24 08 1c 66 10 	movl   $0x10661c,0x8(%esp)
  10381b:	00 
  10381c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103823:	00 
  103824:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10382b:	e8 dc d3 ff ff       	call   100c0c <__panic>
  103830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103833:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103838:	c9                   	leave  
  103839:	c3                   	ret    

0010383a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  10383a:	55                   	push   %ebp
  10383b:	89 e5                	mov    %esp,%ebp
  10383d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103840:	8b 45 08             	mov    0x8(%ebp),%eax
  103843:	83 e0 01             	and    $0x1,%eax
  103846:	85 c0                	test   %eax,%eax
  103848:	75 1c                	jne    103866 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  10384a:	c7 44 24 08 40 66 10 	movl   $0x106640,0x8(%esp)
  103851:	00 
  103852:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103859:	00 
  10385a:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103861:	e8 a6 d3 ff ff       	call   100c0c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103866:	8b 45 08             	mov    0x8(%ebp),%eax
  103869:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10386e:	89 04 24             	mov    %eax,(%esp)
  103871:	e8 21 ff ff ff       	call   103797 <pa2page>
}
  103876:	c9                   	leave  
  103877:	c3                   	ret    

00103878 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103878:	55                   	push   %ebp
  103879:	89 e5                	mov    %esp,%ebp
  10387b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  10387e:	8b 45 08             	mov    0x8(%ebp),%eax
  103881:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103886:	89 04 24             	mov    %eax,(%esp)
  103889:	e8 09 ff ff ff       	call   103797 <pa2page>
}
  10388e:	c9                   	leave  
  10388f:	c3                   	ret    

00103890 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103890:	55                   	push   %ebp
  103891:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103893:	8b 45 08             	mov    0x8(%ebp),%eax
  103896:	8b 00                	mov    (%eax),%eax
}
  103898:	5d                   	pop    %ebp
  103899:	c3                   	ret    

0010389a <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  10389a:	55                   	push   %ebp
  10389b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  10389d:	8b 45 08             	mov    0x8(%ebp),%eax
  1038a0:	8b 00                	mov    (%eax),%eax
  1038a2:	8d 50 01             	lea    0x1(%eax),%edx
  1038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1038a8:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ad:	8b 00                	mov    (%eax),%eax
}
  1038af:	5d                   	pop    %ebp
  1038b0:	c3                   	ret    

001038b1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1038b1:	55                   	push   %ebp
  1038b2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1038b7:	8b 00                	mov    (%eax),%eax
  1038b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1038bf:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1038c4:	8b 00                	mov    (%eax),%eax
}
  1038c6:	5d                   	pop    %ebp
  1038c7:	c3                   	ret    

001038c8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  1038c8:	55                   	push   %ebp
  1038c9:	89 e5                	mov    %esp,%ebp
  1038cb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1038ce:	9c                   	pushf  
  1038cf:	58                   	pop    %eax
  1038d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1038d6:	25 00 02 00 00       	and    $0x200,%eax
  1038db:	85 c0                	test   %eax,%eax
  1038dd:	74 0c                	je     1038eb <__intr_save+0x23>
        intr_disable();
  1038df:	e8 0b dd ff ff       	call   1015ef <intr_disable>
        return 1;
  1038e4:	b8 01 00 00 00       	mov    $0x1,%eax
  1038e9:	eb 05                	jmp    1038f0 <__intr_save+0x28>
    }
    return 0;
  1038eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038f0:	c9                   	leave  
  1038f1:	c3                   	ret    

001038f2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  1038f2:	55                   	push   %ebp
  1038f3:	89 e5                	mov    %esp,%ebp
  1038f5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  1038f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1038fc:	74 05                	je     103903 <__intr_restore+0x11>
        intr_enable();
  1038fe:	e8 e6 dc ff ff       	call   1015e9 <intr_enable>
    }
}
  103903:	c9                   	leave  
  103904:	c3                   	ret    

00103905 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103905:	55                   	push   %ebp
  103906:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103908:	8b 45 08             	mov    0x8(%ebp),%eax
  10390b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10390e:	b8 23 00 00 00       	mov    $0x23,%eax
  103913:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103915:	b8 23 00 00 00       	mov    $0x23,%eax
  10391a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10391c:	b8 10 00 00 00       	mov    $0x10,%eax
  103921:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103923:	b8 10 00 00 00       	mov    $0x10,%eax
  103928:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10392a:	b8 10 00 00 00       	mov    $0x10,%eax
  10392f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103931:	ea 38 39 10 00 08 00 	ljmp   $0x8,$0x103938
}
  103938:	5d                   	pop    %ebp
  103939:	c3                   	ret    

0010393a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  10393a:	55                   	push   %ebp
  10393b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  10393d:	8b 45 08             	mov    0x8(%ebp),%eax
  103940:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103945:	5d                   	pop    %ebp
  103946:	c3                   	ret    

00103947 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103947:	55                   	push   %ebp
  103948:	89 e5                	mov    %esp,%ebp
  10394a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  10394d:	b8 00 70 11 00       	mov    $0x117000,%eax
  103952:	89 04 24             	mov    %eax,(%esp)
  103955:	e8 e0 ff ff ff       	call   10393a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  10395a:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103961:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103963:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  10396a:	68 00 
  10396c:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103971:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103977:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  10397c:	c1 e8 10             	shr    $0x10,%eax
  10397f:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103984:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  10398b:	83 e0 f0             	and    $0xfffffff0,%eax
  10398e:	83 c8 09             	or     $0x9,%eax
  103991:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103996:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  10399d:	83 e0 ef             	and    $0xffffffef,%eax
  1039a0:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  1039a5:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  1039ac:	83 e0 9f             	and    $0xffffff9f,%eax
  1039af:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  1039b4:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  1039bb:	83 c8 80             	or     $0xffffff80,%eax
  1039be:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  1039c3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1039ca:	83 e0 f0             	and    $0xfffffff0,%eax
  1039cd:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1039d2:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1039d9:	83 e0 ef             	and    $0xffffffef,%eax
  1039dc:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1039e1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1039e8:	83 e0 df             	and    $0xffffffdf,%eax
  1039eb:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1039f0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1039f7:	83 c8 40             	or     $0x40,%eax
  1039fa:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1039ff:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103a06:	83 e0 7f             	and    $0x7f,%eax
  103a09:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103a0e:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103a13:	c1 e8 18             	shr    $0x18,%eax
  103a16:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103a1b:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103a22:	e8 de fe ff ff       	call   103905 <lgdt>
  103a27:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103a2d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103a31:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103a34:	c9                   	leave  
  103a35:	c3                   	ret    

00103a36 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103a36:	55                   	push   %ebp
  103a37:	89 e5                	mov    %esp,%ebp
  103a39:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103a3c:	c7 05 5c 89 11 00 d0 	movl   $0x1065d0,0x11895c
  103a43:	65 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103a46:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103a4b:	8b 00                	mov    (%eax),%eax
  103a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a51:	c7 04 24 6c 66 10 00 	movl   $0x10666c,(%esp)
  103a58:	e8 df c8 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103a5d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103a62:	8b 40 04             	mov    0x4(%eax),%eax
  103a65:	ff d0                	call   *%eax
}
  103a67:	c9                   	leave  
  103a68:	c3                   	ret    

00103a69 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103a69:	55                   	push   %ebp
  103a6a:	89 e5                	mov    %esp,%ebp
  103a6c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103a6f:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103a74:	8b 40 08             	mov    0x8(%eax),%eax
  103a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a7a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  103a81:	89 14 24             	mov    %edx,(%esp)
  103a84:	ff d0                	call   *%eax
}
  103a86:	c9                   	leave  
  103a87:	c3                   	ret    

00103a88 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103a88:	55                   	push   %ebp
  103a89:	89 e5                	mov    %esp,%ebp
  103a8b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103a95:	e8 2e fe ff ff       	call   1038c8 <__intr_save>
  103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103a9d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  103aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  103aa8:	89 14 24             	mov    %edx,(%esp)
  103aab:	ff d0                	call   *%eax
  103aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ab3:	89 04 24             	mov    %eax,(%esp)
  103ab6:	e8 37 fe ff ff       	call   1038f2 <__intr_restore>
    return page;
  103abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103abe:	c9                   	leave  
  103abf:	c3                   	ret    

00103ac0 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103ac0:	55                   	push   %ebp
  103ac1:	89 e5                	mov    %esp,%ebp
  103ac3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103ac6:	e8 fd fd ff ff       	call   1038c8 <__intr_save>
  103acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103ace:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ad3:	8b 40 10             	mov    0x10(%eax),%eax
  103ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103add:	8b 55 08             	mov    0x8(%ebp),%edx
  103ae0:	89 14 24             	mov    %edx,(%esp)
  103ae3:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ae8:	89 04 24             	mov    %eax,(%esp)
  103aeb:	e8 02 fe ff ff       	call   1038f2 <__intr_restore>
}
  103af0:	c9                   	leave  
  103af1:	c3                   	ret    

00103af2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103af2:	55                   	push   %ebp
  103af3:	89 e5                	mov    %esp,%ebp
  103af5:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103af8:	e8 cb fd ff ff       	call   1038c8 <__intr_save>
  103afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103b00:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103b05:	8b 40 14             	mov    0x14(%eax),%eax
  103b08:	ff d0                	call   *%eax
  103b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b10:	89 04 24             	mov    %eax,(%esp)
  103b13:	e8 da fd ff ff       	call   1038f2 <__intr_restore>
    return ret;
  103b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103b1b:	c9                   	leave  
  103b1c:	c3                   	ret    

00103b1d <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103b1d:	55                   	push   %ebp
  103b1e:	89 e5                	mov    %esp,%ebp
  103b20:	57                   	push   %edi
  103b21:	56                   	push   %esi
  103b22:	53                   	push   %ebx
  103b23:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103b29:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103b30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103b37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103b3e:	c7 04 24 83 66 10 00 	movl   $0x106683,(%esp)
  103b45:	e8 f2 c7 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103b4a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103b51:	e9 15 01 00 00       	jmp    103c6b <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103b56:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103b59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103b5c:	89 d0                	mov    %edx,%eax
  103b5e:	c1 e0 02             	shl    $0x2,%eax
  103b61:	01 d0                	add    %edx,%eax
  103b63:	c1 e0 02             	shl    $0x2,%eax
  103b66:	01 c8                	add    %ecx,%eax
  103b68:	8b 50 08             	mov    0x8(%eax),%edx
  103b6b:	8b 40 04             	mov    0x4(%eax),%eax
  103b6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103b71:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103b74:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103b77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103b7a:	89 d0                	mov    %edx,%eax
  103b7c:	c1 e0 02             	shl    $0x2,%eax
  103b7f:	01 d0                	add    %edx,%eax
  103b81:	c1 e0 02             	shl    $0x2,%eax
  103b84:	01 c8                	add    %ecx,%eax
  103b86:	8b 48 0c             	mov    0xc(%eax),%ecx
  103b89:	8b 58 10             	mov    0x10(%eax),%ebx
  103b8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103b8f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103b92:	01 c8                	add    %ecx,%eax
  103b94:	11 da                	adc    %ebx,%edx
  103b96:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103b99:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103b9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ba2:	89 d0                	mov    %edx,%eax
  103ba4:	c1 e0 02             	shl    $0x2,%eax
  103ba7:	01 d0                	add    %edx,%eax
  103ba9:	c1 e0 02             	shl    $0x2,%eax
  103bac:	01 c8                	add    %ecx,%eax
  103bae:	83 c0 14             	add    $0x14,%eax
  103bb1:	8b 00                	mov    (%eax),%eax
  103bb3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103bb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103bbc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103bbf:	83 c0 ff             	add    $0xffffffff,%eax
  103bc2:	83 d2 ff             	adc    $0xffffffff,%edx
  103bc5:	89 c6                	mov    %eax,%esi
  103bc7:	89 d7                	mov    %edx,%edi
  103bc9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103bcf:	89 d0                	mov    %edx,%eax
  103bd1:	c1 e0 02             	shl    $0x2,%eax
  103bd4:	01 d0                	add    %edx,%eax
  103bd6:	c1 e0 02             	shl    $0x2,%eax
  103bd9:	01 c8                	add    %ecx,%eax
  103bdb:	8b 48 0c             	mov    0xc(%eax),%ecx
  103bde:	8b 58 10             	mov    0x10(%eax),%ebx
  103be1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103be7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103beb:	89 74 24 14          	mov    %esi,0x14(%esp)
  103bef:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103bf3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103bf6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103bf9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103bfd:	89 54 24 10          	mov    %edx,0x10(%esp)
  103c01:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103c05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103c09:	c7 04 24 90 66 10 00 	movl   $0x106690,(%esp)
  103c10:	e8 27 c7 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103c15:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103c18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103c1b:	89 d0                	mov    %edx,%eax
  103c1d:	c1 e0 02             	shl    $0x2,%eax
  103c20:	01 d0                	add    %edx,%eax
  103c22:	c1 e0 02             	shl    $0x2,%eax
  103c25:	01 c8                	add    %ecx,%eax
  103c27:	83 c0 14             	add    $0x14,%eax
  103c2a:	8b 00                	mov    (%eax),%eax
  103c2c:	83 f8 01             	cmp    $0x1,%eax
  103c2f:	75 36                	jne    103c67 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103c37:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103c3a:	77 2b                	ja     103c67 <page_init+0x14a>
  103c3c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103c3f:	72 05                	jb     103c46 <page_init+0x129>
  103c41:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103c44:	73 21                	jae    103c67 <page_init+0x14a>
  103c46:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103c4a:	77 1b                	ja     103c67 <page_init+0x14a>
  103c4c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103c50:	72 09                	jb     103c5b <page_init+0x13e>
  103c52:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103c59:	77 0c                	ja     103c67 <page_init+0x14a>
                maxpa = end;
  103c5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103c5e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c64:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103c67:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103c6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103c6e:	8b 00                	mov    (%eax),%eax
  103c70:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103c73:	0f 8f dd fe ff ff    	jg     103b56 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103c7d:	72 1d                	jb     103c9c <page_init+0x17f>
  103c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103c83:	77 09                	ja     103c8e <page_init+0x171>
  103c85:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103c8c:	76 0e                	jbe    103c9c <page_init+0x17f>
        maxpa = KMEMSIZE;
  103c8e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103c95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ca2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ca6:	c1 ea 0c             	shr    $0xc,%edx
  103ca9:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103cae:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103cb5:	b8 68 89 11 00       	mov    $0x118968,%eax
  103cba:	8d 50 ff             	lea    -0x1(%eax),%edx
  103cbd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103cc0:	01 d0                	add    %edx,%eax
  103cc2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103cc5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  103ccd:	f7 75 ac             	divl   -0x54(%ebp)
  103cd0:	89 d0                	mov    %edx,%eax
  103cd2:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103cd5:	29 c2                	sub    %eax,%edx
  103cd7:	89 d0                	mov    %edx,%eax
  103cd9:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103cde:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ce5:	eb 2f                	jmp    103d16 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103ce7:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103ced:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cf0:	89 d0                	mov    %edx,%eax
  103cf2:	c1 e0 02             	shl    $0x2,%eax
  103cf5:	01 d0                	add    %edx,%eax
  103cf7:	c1 e0 02             	shl    $0x2,%eax
  103cfa:	01 c8                	add    %ecx,%eax
  103cfc:	83 c0 04             	add    $0x4,%eax
  103cff:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103d06:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103d09:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103d0c:	8b 55 90             	mov    -0x70(%ebp),%edx
  103d0f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103d12:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103d16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d19:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103d1e:	39 c2                	cmp    %eax,%edx
  103d20:	72 c5                	jb     103ce7 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103d22:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103d28:	89 d0                	mov    %edx,%eax
  103d2a:	c1 e0 02             	shl    $0x2,%eax
  103d2d:	01 d0                	add    %edx,%eax
  103d2f:	c1 e0 02             	shl    $0x2,%eax
  103d32:	89 c2                	mov    %eax,%edx
  103d34:	a1 64 89 11 00       	mov    0x118964,%eax
  103d39:	01 d0                	add    %edx,%eax
  103d3b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103d3e:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103d45:	77 23                	ja     103d6a <page_init+0x24d>
  103d47:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103d4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d4e:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  103d55:	00 
  103d56:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103d5d:	00 
  103d5e:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  103d65:	e8 a2 ce ff ff       	call   100c0c <__panic>
  103d6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103d6d:	05 00 00 00 40       	add    $0x40000000,%eax
  103d72:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103d75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d7c:	e9 74 01 00 00       	jmp    103ef5 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d87:	89 d0                	mov    %edx,%eax
  103d89:	c1 e0 02             	shl    $0x2,%eax
  103d8c:	01 d0                	add    %edx,%eax
  103d8e:	c1 e0 02             	shl    $0x2,%eax
  103d91:	01 c8                	add    %ecx,%eax
  103d93:	8b 50 08             	mov    0x8(%eax),%edx
  103d96:	8b 40 04             	mov    0x4(%eax),%eax
  103d99:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103d9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103d9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103da2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103da5:	89 d0                	mov    %edx,%eax
  103da7:	c1 e0 02             	shl    $0x2,%eax
  103daa:	01 d0                	add    %edx,%eax
  103dac:	c1 e0 02             	shl    $0x2,%eax
  103daf:	01 c8                	add    %ecx,%eax
  103db1:	8b 48 0c             	mov    0xc(%eax),%ecx
  103db4:	8b 58 10             	mov    0x10(%eax),%ebx
  103db7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103dba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103dbd:	01 c8                	add    %ecx,%eax
  103dbf:	11 da                	adc    %ebx,%edx
  103dc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103dc4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103dc7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dcd:	89 d0                	mov    %edx,%eax
  103dcf:	c1 e0 02             	shl    $0x2,%eax
  103dd2:	01 d0                	add    %edx,%eax
  103dd4:	c1 e0 02             	shl    $0x2,%eax
  103dd7:	01 c8                	add    %ecx,%eax
  103dd9:	83 c0 14             	add    $0x14,%eax
  103ddc:	8b 00                	mov    (%eax),%eax
  103dde:	83 f8 01             	cmp    $0x1,%eax
  103de1:	0f 85 0a 01 00 00    	jne    103ef1 <page_init+0x3d4>
            if (begin < freemem) {
  103de7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103dea:	ba 00 00 00 00       	mov    $0x0,%edx
  103def:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103df2:	72 17                	jb     103e0b <page_init+0x2ee>
  103df4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103df7:	77 05                	ja     103dfe <page_init+0x2e1>
  103df9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103dfc:	76 0d                	jbe    103e0b <page_init+0x2ee>
                begin = freemem;
  103dfe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103e01:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e04:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103e0b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103e0f:	72 1d                	jb     103e2e <page_init+0x311>
  103e11:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103e15:	77 09                	ja     103e20 <page_init+0x303>
  103e17:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103e1e:	76 0e                	jbe    103e2e <page_init+0x311>
                end = KMEMSIZE;
  103e20:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103e27:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103e2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103e31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103e34:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103e37:	0f 87 b4 00 00 00    	ja     103ef1 <page_init+0x3d4>
  103e3d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103e40:	72 09                	jb     103e4b <page_init+0x32e>
  103e42:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103e45:	0f 83 a6 00 00 00    	jae    103ef1 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103e4b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103e52:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103e55:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103e58:	01 d0                	add    %edx,%eax
  103e5a:	83 e8 01             	sub    $0x1,%eax
  103e5d:	89 45 98             	mov    %eax,-0x68(%ebp)
  103e60:	8b 45 98             	mov    -0x68(%ebp),%eax
  103e63:	ba 00 00 00 00       	mov    $0x0,%edx
  103e68:	f7 75 9c             	divl   -0x64(%ebp)
  103e6b:	89 d0                	mov    %edx,%eax
  103e6d:	8b 55 98             	mov    -0x68(%ebp),%edx
  103e70:	29 c2                	sub    %eax,%edx
  103e72:	89 d0                	mov    %edx,%eax
  103e74:	ba 00 00 00 00       	mov    $0x0,%edx
  103e79:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103e7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103e82:	89 45 94             	mov    %eax,-0x6c(%ebp)
  103e85:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103e88:	ba 00 00 00 00       	mov    $0x0,%edx
  103e8d:	89 c7                	mov    %eax,%edi
  103e8f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  103e95:	89 7d 80             	mov    %edi,-0x80(%ebp)
  103e98:	89 d0                	mov    %edx,%eax
  103e9a:	83 e0 00             	and    $0x0,%eax
  103e9d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103ea0:	8b 45 80             	mov    -0x80(%ebp),%eax
  103ea3:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ea9:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  103eac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103eaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103eb2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103eb5:	77 3a                	ja     103ef1 <page_init+0x3d4>
  103eb7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103eba:	72 05                	jb     103ec1 <page_init+0x3a4>
  103ebc:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103ebf:	73 30                	jae    103ef1 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103ec1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  103ec4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  103ec7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103eca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103ecd:	29 c8                	sub    %ecx,%eax
  103ecf:	19 da                	sbb    %ebx,%edx
  103ed1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ed5:	c1 ea 0c             	shr    $0xc,%edx
  103ed8:	89 c3                	mov    %eax,%ebx
  103eda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103edd:	89 04 24             	mov    %eax,(%esp)
  103ee0:	e8 b2 f8 ff ff       	call   103797 <pa2page>
  103ee5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103ee9:	89 04 24             	mov    %eax,(%esp)
  103eec:	e8 78 fb ff ff       	call   103a69 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  103ef1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ef5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ef8:	8b 00                	mov    (%eax),%eax
  103efa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103efd:	0f 8f 7e fe ff ff    	jg     103d81 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  103f03:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103f09:	5b                   	pop    %ebx
  103f0a:	5e                   	pop    %esi
  103f0b:	5f                   	pop    %edi
  103f0c:	5d                   	pop    %ebp
  103f0d:	c3                   	ret    

00103f0e <enable_paging>:

static void
enable_paging(void) {
  103f0e:	55                   	push   %ebp
  103f0f:	89 e5                	mov    %esp,%ebp
  103f11:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103f14:	a1 60 89 11 00       	mov    0x118960,%eax
  103f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103f1f:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103f22:	0f 20 c0             	mov    %cr0,%eax
  103f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103f28:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103f2e:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103f35:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  103f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f42:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103f45:	c9                   	leave  
  103f46:	c3                   	ret    

00103f47 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103f47:	55                   	push   %ebp
  103f48:	89 e5                	mov    %esp,%ebp
  103f4a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  103f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f53:	31 d0                	xor    %edx,%eax
  103f55:	25 ff 0f 00 00       	and    $0xfff,%eax
  103f5a:	85 c0                	test   %eax,%eax
  103f5c:	74 24                	je     103f82 <boot_map_segment+0x3b>
  103f5e:	c7 44 24 0c f2 66 10 	movl   $0x1066f2,0xc(%esp)
  103f65:	00 
  103f66:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  103f6d:	00 
  103f6e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103f75:	00 
  103f76:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  103f7d:	e8 8a cc ff ff       	call   100c0c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103f82:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  103f8c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103f91:	89 c2                	mov    %eax,%edx
  103f93:	8b 45 10             	mov    0x10(%ebp),%eax
  103f96:	01 c2                	add    %eax,%edx
  103f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f9b:	01 d0                	add    %edx,%eax
  103f9d:	83 e8 01             	sub    $0x1,%eax
  103fa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fa6:	ba 00 00 00 00       	mov    $0x0,%edx
  103fab:	f7 75 f0             	divl   -0x10(%ebp)
  103fae:	89 d0                	mov    %edx,%eax
  103fb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fb3:	29 c2                	sub    %eax,%edx
  103fb5:	89 d0                	mov    %edx,%eax
  103fb7:	c1 e8 0c             	shr    $0xc,%eax
  103fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103fc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103fc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103fcb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103fce:	8b 45 14             	mov    0x14(%ebp),%eax
  103fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103fdc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103fdf:	eb 6b                	jmp    10404c <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103fe1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103fe8:	00 
  103fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  103fec:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ff3:	89 04 24             	mov    %eax,(%esp)
  103ff6:	e8 cc 01 00 00       	call   1041c7 <get_pte>
  103ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103ffe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104002:	75 24                	jne    104028 <boot_map_segment+0xe1>
  104004:	c7 44 24 0c 1e 67 10 	movl   $0x10671e,0xc(%esp)
  10400b:	00 
  10400c:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104013:	00 
  104014:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10401b:	00 
  10401c:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104023:	e8 e4 cb ff ff       	call   100c0c <__panic>
        *ptep = pa | PTE_P | perm;
  104028:	8b 45 18             	mov    0x18(%ebp),%eax
  10402b:	8b 55 14             	mov    0x14(%ebp),%edx
  10402e:	09 d0                	or     %edx,%eax
  104030:	83 c8 01             	or     $0x1,%eax
  104033:	89 c2                	mov    %eax,%edx
  104035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104038:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10403a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10403e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104045:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10404c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104050:	75 8f                	jne    103fe1 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104052:	c9                   	leave  
  104053:	c3                   	ret    

00104054 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104054:	55                   	push   %ebp
  104055:	89 e5                	mov    %esp,%ebp
  104057:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10405a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104061:	e8 22 fa ff ff       	call   103a88 <alloc_pages>
  104066:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10406d:	75 1c                	jne    10408b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10406f:	c7 44 24 08 2b 67 10 	movl   $0x10672b,0x8(%esp)
  104076:	00 
  104077:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10407e:	00 
  10407f:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104086:	e8 81 cb ff ff       	call   100c0c <__panic>
    }
    return page2kva(p);
  10408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10408e:	89 04 24             	mov    %eax,(%esp)
  104091:	e8 50 f7 ff ff       	call   1037e6 <page2kva>
}
  104096:	c9                   	leave  
  104097:	c3                   	ret    

00104098 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104098:	55                   	push   %ebp
  104099:	89 e5                	mov    %esp,%ebp
  10409b:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10409e:	e8 93 f9 ff ff       	call   103a36 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1040a3:	e8 75 fa ff ff       	call   103b1d <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1040a8:	e8 d7 02 00 00       	call   104384 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1040ad:	e8 a2 ff ff ff       	call   104054 <boot_alloc_page>
  1040b2:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1040b7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1040bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1040c3:	00 
  1040c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1040cb:	00 
  1040cc:	89 04 24             	mov    %eax,(%esp)
  1040cf:	e8 14 19 00 00       	call   1059e8 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1040d4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1040d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1040dc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1040e3:	77 23                	ja     104108 <pmm_init+0x70>
  1040e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040ec:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  1040f3:	00 
  1040f4:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1040fb:	00 
  1040fc:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104103:	e8 04 cb ff ff       	call   100c0c <__panic>
  104108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410b:	05 00 00 00 40       	add    $0x40000000,%eax
  104110:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  104115:	e8 88 02 00 00       	call   1043a2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10411a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10411f:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104125:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10412a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10412d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104134:	77 23                	ja     104159 <pmm_init+0xc1>
  104136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104139:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10413d:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  104144:	00 
  104145:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10414c:	00 
  10414d:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104154:	e8 b3 ca ff ff       	call   100c0c <__panic>
  104159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10415c:	05 00 00 00 40       	add    $0x40000000,%eax
  104161:	83 c8 03             	or     $0x3,%eax
  104164:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104166:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10416b:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104172:	00 
  104173:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10417a:	00 
  10417b:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104182:	38 
  104183:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10418a:	c0 
  10418b:	89 04 24             	mov    %eax,(%esp)
  10418e:	e8 b4 fd ff ff       	call   103f47 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104193:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104198:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10419e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1041a4:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1041a6:	e8 63 fd ff ff       	call   103f0e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1041ab:	e8 97 f7 ff ff       	call   103947 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1041b0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1041b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1041bb:	e8 7d 08 00 00       	call   104a3d <check_boot_pgdir>

    print_pgdir();
  1041c0:	e8 05 0d 00 00       	call   104eca <print_pgdir>

}
  1041c5:	c9                   	leave  
  1041c6:	c3                   	ret    

001041c7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1041c7:	55                   	push   %ebp
  1041c8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1041ca:	5d                   	pop    %ebp
  1041cb:	c3                   	ret    

001041cc <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1041cc:	55                   	push   %ebp
  1041cd:	89 e5                	mov    %esp,%ebp
  1041cf:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1041d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1041d9:	00 
  1041da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1041e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1041e4:	89 04 24             	mov    %eax,(%esp)
  1041e7:	e8 db ff ff ff       	call   1041c7 <get_pte>
  1041ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1041ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1041f3:	74 08                	je     1041fd <get_page+0x31>
        *ptep_store = ptep;
  1041f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1041f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1041fb:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1041fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104201:	74 1b                	je     10421e <get_page+0x52>
  104203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104206:	8b 00                	mov    (%eax),%eax
  104208:	83 e0 01             	and    $0x1,%eax
  10420b:	85 c0                	test   %eax,%eax
  10420d:	74 0f                	je     10421e <get_page+0x52>
        return pte2page(*ptep);
  10420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104212:	8b 00                	mov    (%eax),%eax
  104214:	89 04 24             	mov    %eax,(%esp)
  104217:	e8 1e f6 ff ff       	call   10383a <pte2page>
  10421c:	eb 05                	jmp    104223 <get_page+0x57>
    }
    return NULL;
  10421e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104223:	c9                   	leave  
  104224:	c3                   	ret    

00104225 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104225:	55                   	push   %ebp
  104226:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104228:	5d                   	pop    %ebp
  104229:	c3                   	ret    

0010422a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10422a:	55                   	push   %ebp
  10422b:	89 e5                	mov    %esp,%ebp
  10422d:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104230:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104237:	00 
  104238:	8b 45 0c             	mov    0xc(%ebp),%eax
  10423b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10423f:	8b 45 08             	mov    0x8(%ebp),%eax
  104242:	89 04 24             	mov    %eax,(%esp)
  104245:	e8 7d ff ff ff       	call   1041c7 <get_pte>
  10424a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10424d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104251:	74 19                	je     10426c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104253:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104256:	89 44 24 08          	mov    %eax,0x8(%esp)
  10425a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10425d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104261:	8b 45 08             	mov    0x8(%ebp),%eax
  104264:	89 04 24             	mov    %eax,(%esp)
  104267:	e8 b9 ff ff ff       	call   104225 <page_remove_pte>
    }
}
  10426c:	c9                   	leave  
  10426d:	c3                   	ret    

0010426e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10426e:	55                   	push   %ebp
  10426f:	89 e5                	mov    %esp,%ebp
  104271:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104274:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10427b:	00 
  10427c:	8b 45 10             	mov    0x10(%ebp),%eax
  10427f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104283:	8b 45 08             	mov    0x8(%ebp),%eax
  104286:	89 04 24             	mov    %eax,(%esp)
  104289:	e8 39 ff ff ff       	call   1041c7 <get_pte>
  10428e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104295:	75 0a                	jne    1042a1 <page_insert+0x33>
        return -E_NO_MEM;
  104297:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10429c:	e9 84 00 00 00       	jmp    104325 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1042a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042a4:	89 04 24             	mov    %eax,(%esp)
  1042a7:	e8 ee f5 ff ff       	call   10389a <page_ref_inc>
    if (*ptep & PTE_P) {
  1042ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042af:	8b 00                	mov    (%eax),%eax
  1042b1:	83 e0 01             	and    $0x1,%eax
  1042b4:	85 c0                	test   %eax,%eax
  1042b6:	74 3e                	je     1042f6 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042bb:	8b 00                	mov    (%eax),%eax
  1042bd:	89 04 24             	mov    %eax,(%esp)
  1042c0:	e8 75 f5 ff ff       	call   10383a <pte2page>
  1042c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1042c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1042ce:	75 0d                	jne    1042dd <page_insert+0x6f>
            page_ref_dec(page);
  1042d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042d3:	89 04 24             	mov    %eax,(%esp)
  1042d6:	e8 d6 f5 ff ff       	call   1038b1 <page_ref_dec>
  1042db:	eb 19                	jmp    1042f6 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1042dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1042e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1042e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ee:	89 04 24             	mov    %eax,(%esp)
  1042f1:	e8 2f ff ff ff       	call   104225 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1042f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042f9:	89 04 24             	mov    %eax,(%esp)
  1042fc:	e8 80 f4 ff ff       	call   103781 <page2pa>
  104301:	0b 45 14             	or     0x14(%ebp),%eax
  104304:	83 c8 01             	or     $0x1,%eax
  104307:	89 c2                	mov    %eax,%edx
  104309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10430c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10430e:	8b 45 10             	mov    0x10(%ebp),%eax
  104311:	89 44 24 04          	mov    %eax,0x4(%esp)
  104315:	8b 45 08             	mov    0x8(%ebp),%eax
  104318:	89 04 24             	mov    %eax,(%esp)
  10431b:	e8 07 00 00 00       	call   104327 <tlb_invalidate>
    return 0;
  104320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104325:	c9                   	leave  
  104326:	c3                   	ret    

00104327 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104327:	55                   	push   %ebp
  104328:	89 e5                	mov    %esp,%ebp
  10432a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10432d:	0f 20 d8             	mov    %cr3,%eax
  104330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104333:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104336:	89 c2                	mov    %eax,%edx
  104338:	8b 45 08             	mov    0x8(%ebp),%eax
  10433b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10433e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104345:	77 23                	ja     10436a <tlb_invalidate+0x43>
  104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10434e:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  104355:	00 
  104356:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  10435d:	00 
  10435e:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104365:	e8 a2 c8 ff ff       	call   100c0c <__panic>
  10436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10436d:	05 00 00 00 40       	add    $0x40000000,%eax
  104372:	39 c2                	cmp    %eax,%edx
  104374:	75 0c                	jne    104382 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104376:	8b 45 0c             	mov    0xc(%ebp),%eax
  104379:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10437c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10437f:	0f 01 38             	invlpg (%eax)
    }
}
  104382:	c9                   	leave  
  104383:	c3                   	ret    

00104384 <check_alloc_page>:

static void
check_alloc_page(void) {
  104384:	55                   	push   %ebp
  104385:	89 e5                	mov    %esp,%ebp
  104387:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10438a:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10438f:	8b 40 18             	mov    0x18(%eax),%eax
  104392:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104394:	c7 04 24 44 67 10 00 	movl   $0x106744,(%esp)
  10439b:	e8 9c bf ff ff       	call   10033c <cprintf>
}
  1043a0:	c9                   	leave  
  1043a1:	c3                   	ret    

001043a2 <check_pgdir>:

static void
check_pgdir(void) {
  1043a2:	55                   	push   %ebp
  1043a3:	89 e5                	mov    %esp,%ebp
  1043a5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1043a8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1043ad:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1043b2:	76 24                	jbe    1043d8 <check_pgdir+0x36>
  1043b4:	c7 44 24 0c 63 67 10 	movl   $0x106763,0xc(%esp)
  1043bb:	00 
  1043bc:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1043c3:	00 
  1043c4:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1043cb:	00 
  1043cc:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1043d3:	e8 34 c8 ff ff       	call   100c0c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1043d8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043dd:	85 c0                	test   %eax,%eax
  1043df:	74 0e                	je     1043ef <check_pgdir+0x4d>
  1043e1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043e6:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043eb:	85 c0                	test   %eax,%eax
  1043ed:	74 24                	je     104413 <check_pgdir+0x71>
  1043ef:	c7 44 24 0c 80 67 10 	movl   $0x106780,0xc(%esp)
  1043f6:	00 
  1043f7:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1043fe:	00 
  1043ff:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104406:	00 
  104407:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  10440e:	e8 f9 c7 ff ff       	call   100c0c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104413:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104418:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10441f:	00 
  104420:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104427:	00 
  104428:	89 04 24             	mov    %eax,(%esp)
  10442b:	e8 9c fd ff ff       	call   1041cc <get_page>
  104430:	85 c0                	test   %eax,%eax
  104432:	74 24                	je     104458 <check_pgdir+0xb6>
  104434:	c7 44 24 0c b8 67 10 	movl   $0x1067b8,0xc(%esp)
  10443b:	00 
  10443c:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104443:	00 
  104444:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  10444b:	00 
  10444c:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104453:	e8 b4 c7 ff ff       	call   100c0c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104458:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10445f:	e8 24 f6 ff ff       	call   103a88 <alloc_pages>
  104464:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104467:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10446c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104473:	00 
  104474:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10447b:	00 
  10447c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10447f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104483:	89 04 24             	mov    %eax,(%esp)
  104486:	e8 e3 fd ff ff       	call   10426e <page_insert>
  10448b:	85 c0                	test   %eax,%eax
  10448d:	74 24                	je     1044b3 <check_pgdir+0x111>
  10448f:	c7 44 24 0c e0 67 10 	movl   $0x1067e0,0xc(%esp)
  104496:	00 
  104497:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  10449e:	00 
  10449f:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1044a6:	00 
  1044a7:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1044ae:	e8 59 c7 ff ff       	call   100c0c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1044b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044bf:	00 
  1044c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044c7:	00 
  1044c8:	89 04 24             	mov    %eax,(%esp)
  1044cb:	e8 f7 fc ff ff       	call   1041c7 <get_pte>
  1044d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1044d7:	75 24                	jne    1044fd <check_pgdir+0x15b>
  1044d9:	c7 44 24 0c 0c 68 10 	movl   $0x10680c,0xc(%esp)
  1044e0:	00 
  1044e1:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1044e8:	00 
  1044e9:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  1044f0:	00 
  1044f1:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1044f8:	e8 0f c7 ff ff       	call   100c0c <__panic>
    assert(pte2page(*ptep) == p1);
  1044fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104500:	8b 00                	mov    (%eax),%eax
  104502:	89 04 24             	mov    %eax,(%esp)
  104505:	e8 30 f3 ff ff       	call   10383a <pte2page>
  10450a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10450d:	74 24                	je     104533 <check_pgdir+0x191>
  10450f:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  104516:	00 
  104517:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  10451e:	00 
  10451f:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  104526:	00 
  104527:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  10452e:	e8 d9 c6 ff ff       	call   100c0c <__panic>
    assert(page_ref(p1) == 1);
  104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104536:	89 04 24             	mov    %eax,(%esp)
  104539:	e8 52 f3 ff ff       	call   103890 <page_ref>
  10453e:	83 f8 01             	cmp    $0x1,%eax
  104541:	74 24                	je     104567 <check_pgdir+0x1c5>
  104543:	c7 44 24 0c 4f 68 10 	movl   $0x10684f,0xc(%esp)
  10454a:	00 
  10454b:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104552:	00 
  104553:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  10455a:	00 
  10455b:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104562:	e8 a5 c6 ff ff       	call   100c0c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104567:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10456c:	8b 00                	mov    (%eax),%eax
  10456e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104573:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104579:	c1 e8 0c             	shr    $0xc,%eax
  10457c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10457f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104584:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104587:	72 23                	jb     1045ac <check_pgdir+0x20a>
  104589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10458c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104590:	c7 44 24 08 1c 66 10 	movl   $0x10661c,0x8(%esp)
  104597:	00 
  104598:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  10459f:	00 
  1045a0:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1045a7:	e8 60 c6 ff ff       	call   100c0c <__panic>
  1045ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045af:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045b4:	83 c0 04             	add    $0x4,%eax
  1045b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1045ba:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045c6:	00 
  1045c7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1045ce:	00 
  1045cf:	89 04 24             	mov    %eax,(%esp)
  1045d2:	e8 f0 fb ff ff       	call   1041c7 <get_pte>
  1045d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1045da:	74 24                	je     104600 <check_pgdir+0x25e>
  1045dc:	c7 44 24 0c 64 68 10 	movl   $0x106864,0xc(%esp)
  1045e3:	00 
  1045e4:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1045eb:	00 
  1045ec:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  1045f3:	00 
  1045f4:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1045fb:	e8 0c c6 ff ff       	call   100c0c <__panic>

    p2 = alloc_page();
  104600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104607:	e8 7c f4 ff ff       	call   103a88 <alloc_pages>
  10460c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10460f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104614:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10461b:	00 
  10461c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104623:	00 
  104624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104627:	89 54 24 04          	mov    %edx,0x4(%esp)
  10462b:	89 04 24             	mov    %eax,(%esp)
  10462e:	e8 3b fc ff ff       	call   10426e <page_insert>
  104633:	85 c0                	test   %eax,%eax
  104635:	74 24                	je     10465b <check_pgdir+0x2b9>
  104637:	c7 44 24 0c 8c 68 10 	movl   $0x10688c,0xc(%esp)
  10463e:	00 
  10463f:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104646:	00 
  104647:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  10464e:	00 
  10464f:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104656:	e8 b1 c5 ff ff       	call   100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10465b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104660:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104667:	00 
  104668:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10466f:	00 
  104670:	89 04 24             	mov    %eax,(%esp)
  104673:	e8 4f fb ff ff       	call   1041c7 <get_pte>
  104678:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10467b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10467f:	75 24                	jne    1046a5 <check_pgdir+0x303>
  104681:	c7 44 24 0c c4 68 10 	movl   $0x1068c4,0xc(%esp)
  104688:	00 
  104689:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104690:	00 
  104691:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104698:	00 
  104699:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1046a0:	e8 67 c5 ff ff       	call   100c0c <__panic>
    assert(*ptep & PTE_U);
  1046a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046a8:	8b 00                	mov    (%eax),%eax
  1046aa:	83 e0 04             	and    $0x4,%eax
  1046ad:	85 c0                	test   %eax,%eax
  1046af:	75 24                	jne    1046d5 <check_pgdir+0x333>
  1046b1:	c7 44 24 0c f4 68 10 	movl   $0x1068f4,0xc(%esp)
  1046b8:	00 
  1046b9:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1046c0:	00 
  1046c1:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1046c8:	00 
  1046c9:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1046d0:	e8 37 c5 ff ff       	call   100c0c <__panic>
    assert(*ptep & PTE_W);
  1046d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046d8:	8b 00                	mov    (%eax),%eax
  1046da:	83 e0 02             	and    $0x2,%eax
  1046dd:	85 c0                	test   %eax,%eax
  1046df:	75 24                	jne    104705 <check_pgdir+0x363>
  1046e1:	c7 44 24 0c 02 69 10 	movl   $0x106902,0xc(%esp)
  1046e8:	00 
  1046e9:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1046f0:	00 
  1046f1:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  1046f8:	00 
  1046f9:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104700:	e8 07 c5 ff ff       	call   100c0c <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104705:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10470a:	8b 00                	mov    (%eax),%eax
  10470c:	83 e0 04             	and    $0x4,%eax
  10470f:	85 c0                	test   %eax,%eax
  104711:	75 24                	jne    104737 <check_pgdir+0x395>
  104713:	c7 44 24 0c 10 69 10 	movl   $0x106910,0xc(%esp)
  10471a:	00 
  10471b:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104722:	00 
  104723:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  10472a:	00 
  10472b:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104732:	e8 d5 c4 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 1);
  104737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10473a:	89 04 24             	mov    %eax,(%esp)
  10473d:	e8 4e f1 ff ff       	call   103890 <page_ref>
  104742:	83 f8 01             	cmp    $0x1,%eax
  104745:	74 24                	je     10476b <check_pgdir+0x3c9>
  104747:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  10474e:	00 
  10474f:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104756:	00 
  104757:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  10475e:	00 
  10475f:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104766:	e8 a1 c4 ff ff       	call   100c0c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10476b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104770:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104777:	00 
  104778:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10477f:	00 
  104780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104783:	89 54 24 04          	mov    %edx,0x4(%esp)
  104787:	89 04 24             	mov    %eax,(%esp)
  10478a:	e8 df fa ff ff       	call   10426e <page_insert>
  10478f:	85 c0                	test   %eax,%eax
  104791:	74 24                	je     1047b7 <check_pgdir+0x415>
  104793:	c7 44 24 0c 38 69 10 	movl   $0x106938,0xc(%esp)
  10479a:	00 
  10479b:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1047a2:	00 
  1047a3:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1047aa:	00 
  1047ab:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1047b2:	e8 55 c4 ff ff       	call   100c0c <__panic>
    assert(page_ref(p1) == 2);
  1047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047ba:	89 04 24             	mov    %eax,(%esp)
  1047bd:	e8 ce f0 ff ff       	call   103890 <page_ref>
  1047c2:	83 f8 02             	cmp    $0x2,%eax
  1047c5:	74 24                	je     1047eb <check_pgdir+0x449>
  1047c7:	c7 44 24 0c 64 69 10 	movl   $0x106964,0xc(%esp)
  1047ce:	00 
  1047cf:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1047d6:	00 
  1047d7:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1047de:	00 
  1047df:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1047e6:	e8 21 c4 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  1047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047ee:	89 04 24             	mov    %eax,(%esp)
  1047f1:	e8 9a f0 ff ff       	call   103890 <page_ref>
  1047f6:	85 c0                	test   %eax,%eax
  1047f8:	74 24                	je     10481e <check_pgdir+0x47c>
  1047fa:	c7 44 24 0c 76 69 10 	movl   $0x106976,0xc(%esp)
  104801:	00 
  104802:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104809:	00 
  10480a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104811:	00 
  104812:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104819:	e8 ee c3 ff ff       	call   100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10481e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104823:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10482a:	00 
  10482b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104832:	00 
  104833:	89 04 24             	mov    %eax,(%esp)
  104836:	e8 8c f9 ff ff       	call   1041c7 <get_pte>
  10483b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10483e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104842:	75 24                	jne    104868 <check_pgdir+0x4c6>
  104844:	c7 44 24 0c c4 68 10 	movl   $0x1068c4,0xc(%esp)
  10484b:	00 
  10484c:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104853:	00 
  104854:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10485b:	00 
  10485c:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104863:	e8 a4 c3 ff ff       	call   100c0c <__panic>
    assert(pte2page(*ptep) == p1);
  104868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10486b:	8b 00                	mov    (%eax),%eax
  10486d:	89 04 24             	mov    %eax,(%esp)
  104870:	e8 c5 ef ff ff       	call   10383a <pte2page>
  104875:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104878:	74 24                	je     10489e <check_pgdir+0x4fc>
  10487a:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  104881:	00 
  104882:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104889:	00 
  10488a:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104891:	00 
  104892:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104899:	e8 6e c3 ff ff       	call   100c0c <__panic>
    assert((*ptep & PTE_U) == 0);
  10489e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048a1:	8b 00                	mov    (%eax),%eax
  1048a3:	83 e0 04             	and    $0x4,%eax
  1048a6:	85 c0                	test   %eax,%eax
  1048a8:	74 24                	je     1048ce <check_pgdir+0x52c>
  1048aa:	c7 44 24 0c 88 69 10 	movl   $0x106988,0xc(%esp)
  1048b1:	00 
  1048b2:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1048b9:	00 
  1048ba:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1048c1:	00 
  1048c2:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1048c9:	e8 3e c3 ff ff       	call   100c0c <__panic>

    page_remove(boot_pgdir, 0x0);
  1048ce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048da:	00 
  1048db:	89 04 24             	mov    %eax,(%esp)
  1048de:	e8 47 f9 ff ff       	call   10422a <page_remove>
    assert(page_ref(p1) == 1);
  1048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e6:	89 04 24             	mov    %eax,(%esp)
  1048e9:	e8 a2 ef ff ff       	call   103890 <page_ref>
  1048ee:	83 f8 01             	cmp    $0x1,%eax
  1048f1:	74 24                	je     104917 <check_pgdir+0x575>
  1048f3:	c7 44 24 0c 4f 68 10 	movl   $0x10684f,0xc(%esp)
  1048fa:	00 
  1048fb:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104902:	00 
  104903:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  10490a:	00 
  10490b:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104912:	e8 f5 c2 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  104917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10491a:	89 04 24             	mov    %eax,(%esp)
  10491d:	e8 6e ef ff ff       	call   103890 <page_ref>
  104922:	85 c0                	test   %eax,%eax
  104924:	74 24                	je     10494a <check_pgdir+0x5a8>
  104926:	c7 44 24 0c 76 69 10 	movl   $0x106976,0xc(%esp)
  10492d:	00 
  10492e:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104935:	00 
  104936:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  10493d:	00 
  10493e:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104945:	e8 c2 c2 ff ff       	call   100c0c <__panic>

    page_remove(boot_pgdir, PGSIZE);
  10494a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10494f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104956:	00 
  104957:	89 04 24             	mov    %eax,(%esp)
  10495a:	e8 cb f8 ff ff       	call   10422a <page_remove>
    assert(page_ref(p1) == 0);
  10495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104962:	89 04 24             	mov    %eax,(%esp)
  104965:	e8 26 ef ff ff       	call   103890 <page_ref>
  10496a:	85 c0                	test   %eax,%eax
  10496c:	74 24                	je     104992 <check_pgdir+0x5f0>
  10496e:	c7 44 24 0c 9d 69 10 	movl   $0x10699d,0xc(%esp)
  104975:	00 
  104976:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  10497d:	00 
  10497e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104985:	00 
  104986:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  10498d:	e8 7a c2 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  104992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104995:	89 04 24             	mov    %eax,(%esp)
  104998:	e8 f3 ee ff ff       	call   103890 <page_ref>
  10499d:	85 c0                	test   %eax,%eax
  10499f:	74 24                	je     1049c5 <check_pgdir+0x623>
  1049a1:	c7 44 24 0c 76 69 10 	movl   $0x106976,0xc(%esp)
  1049a8:	00 
  1049a9:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1049b0:	00 
  1049b1:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  1049b8:	00 
  1049b9:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  1049c0:	e8 47 c2 ff ff       	call   100c0c <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  1049c5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049ca:	8b 00                	mov    (%eax),%eax
  1049cc:	89 04 24             	mov    %eax,(%esp)
  1049cf:	e8 a4 ee ff ff       	call   103878 <pde2page>
  1049d4:	89 04 24             	mov    %eax,(%esp)
  1049d7:	e8 b4 ee ff ff       	call   103890 <page_ref>
  1049dc:	83 f8 01             	cmp    $0x1,%eax
  1049df:	74 24                	je     104a05 <check_pgdir+0x663>
  1049e1:	c7 44 24 0c b0 69 10 	movl   $0x1069b0,0xc(%esp)
  1049e8:	00 
  1049e9:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  1049f0:	00 
  1049f1:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1049f8:	00 
  1049f9:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104a00:	e8 07 c2 ff ff       	call   100c0c <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104a05:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a0a:	8b 00                	mov    (%eax),%eax
  104a0c:	89 04 24             	mov    %eax,(%esp)
  104a0f:	e8 64 ee ff ff       	call   103878 <pde2page>
  104a14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a1b:	00 
  104a1c:	89 04 24             	mov    %eax,(%esp)
  104a1f:	e8 9c f0 ff ff       	call   103ac0 <free_pages>
    boot_pgdir[0] = 0;
  104a24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104a2f:	c7 04 24 d7 69 10 00 	movl   $0x1069d7,(%esp)
  104a36:	e8 01 b9 ff ff       	call   10033c <cprintf>
}
  104a3b:	c9                   	leave  
  104a3c:	c3                   	ret    

00104a3d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104a3d:	55                   	push   %ebp
  104a3e:	89 e5                	mov    %esp,%ebp
  104a40:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a4a:	e9 ca 00 00 00       	jmp    104b19 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a58:	c1 e8 0c             	shr    $0xc,%eax
  104a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a5e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104a63:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104a66:	72 23                	jb     104a8b <check_boot_pgdir+0x4e>
  104a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a6f:	c7 44 24 08 1c 66 10 	movl   $0x10661c,0x8(%esp)
  104a76:	00 
  104a77:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104a7e:	00 
  104a7f:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104a86:	e8 81 c1 ff ff       	call   100c0c <__panic>
  104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a8e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a93:	89 c2                	mov    %eax,%edx
  104a95:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aa1:	00 
  104aa2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104aa6:	89 04 24             	mov    %eax,(%esp)
  104aa9:	e8 19 f7 ff ff       	call   1041c7 <get_pte>
  104aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ab1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ab5:	75 24                	jne    104adb <check_boot_pgdir+0x9e>
  104ab7:	c7 44 24 0c f4 69 10 	movl   $0x1069f4,0xc(%esp)
  104abe:	00 
  104abf:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104ac6:	00 
  104ac7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104ace:	00 
  104acf:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104ad6:	e8 31 c1 ff ff       	call   100c0c <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ade:	8b 00                	mov    (%eax),%eax
  104ae0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ae5:	89 c2                	mov    %eax,%edx
  104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104aea:	39 c2                	cmp    %eax,%edx
  104aec:	74 24                	je     104b12 <check_boot_pgdir+0xd5>
  104aee:	c7 44 24 0c 31 6a 10 	movl   $0x106a31,0xc(%esp)
  104af5:	00 
  104af6:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104afd:	00 
  104afe:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104b05:	00 
  104b06:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104b0d:	e8 fa c0 ff ff       	call   100c0c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104b12:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b1c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104b21:	39 c2                	cmp    %eax,%edx
  104b23:	0f 82 26 ff ff ff    	jb     104a4f <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104b29:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b2e:	05 ac 0f 00 00       	add    $0xfac,%eax
  104b33:	8b 00                	mov    (%eax),%eax
  104b35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b3a:	89 c2                	mov    %eax,%edx
  104b3c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b44:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104b4b:	77 23                	ja     104b70 <check_boot_pgdir+0x133>
  104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b54:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  104b5b:	00 
  104b5c:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104b63:	00 
  104b64:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104b6b:	e8 9c c0 ff ff       	call   100c0c <__panic>
  104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b73:	05 00 00 00 40       	add    $0x40000000,%eax
  104b78:	39 c2                	cmp    %eax,%edx
  104b7a:	74 24                	je     104ba0 <check_boot_pgdir+0x163>
  104b7c:	c7 44 24 0c 48 6a 10 	movl   $0x106a48,0xc(%esp)
  104b83:	00 
  104b84:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104b8b:	00 
  104b8c:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104b93:	00 
  104b94:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104b9b:	e8 6c c0 ff ff       	call   100c0c <__panic>

    assert(boot_pgdir[0] == 0);
  104ba0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ba5:	8b 00                	mov    (%eax),%eax
  104ba7:	85 c0                	test   %eax,%eax
  104ba9:	74 24                	je     104bcf <check_boot_pgdir+0x192>
  104bab:	c7 44 24 0c 7c 6a 10 	movl   $0x106a7c,0xc(%esp)
  104bb2:	00 
  104bb3:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104bba:	00 
  104bbb:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104bc2:	00 
  104bc3:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104bca:	e8 3d c0 ff ff       	call   100c0c <__panic>

    struct Page *p;
    p = alloc_page();
  104bcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bd6:	e8 ad ee ff ff       	call   103a88 <alloc_pages>
  104bdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104bde:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104be3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104bea:	00 
  104beb:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104bf2:	00 
  104bf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bfa:	89 04 24             	mov    %eax,(%esp)
  104bfd:	e8 6c f6 ff ff       	call   10426e <page_insert>
  104c02:	85 c0                	test   %eax,%eax
  104c04:	74 24                	je     104c2a <check_boot_pgdir+0x1ed>
  104c06:	c7 44 24 0c 90 6a 10 	movl   $0x106a90,0xc(%esp)
  104c0d:	00 
  104c0e:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104c15:	00 
  104c16:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104c1d:	00 
  104c1e:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104c25:	e8 e2 bf ff ff       	call   100c0c <__panic>
    assert(page_ref(p) == 1);
  104c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c2d:	89 04 24             	mov    %eax,(%esp)
  104c30:	e8 5b ec ff ff       	call   103890 <page_ref>
  104c35:	83 f8 01             	cmp    $0x1,%eax
  104c38:	74 24                	je     104c5e <check_boot_pgdir+0x221>
  104c3a:	c7 44 24 0c be 6a 10 	movl   $0x106abe,0xc(%esp)
  104c41:	00 
  104c42:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104c49:	00 
  104c4a:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104c51:	00 
  104c52:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104c59:	e8 ae bf ff ff       	call   100c0c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104c5e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c63:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104c6a:	00 
  104c6b:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104c72:	00 
  104c73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104c76:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c7a:	89 04 24             	mov    %eax,(%esp)
  104c7d:	e8 ec f5 ff ff       	call   10426e <page_insert>
  104c82:	85 c0                	test   %eax,%eax
  104c84:	74 24                	je     104caa <check_boot_pgdir+0x26d>
  104c86:	c7 44 24 0c d0 6a 10 	movl   $0x106ad0,0xc(%esp)
  104c8d:	00 
  104c8e:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104c95:	00 
  104c96:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104c9d:	00 
  104c9e:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104ca5:	e8 62 bf ff ff       	call   100c0c <__panic>
    assert(page_ref(p) == 2);
  104caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cad:	89 04 24             	mov    %eax,(%esp)
  104cb0:	e8 db eb ff ff       	call   103890 <page_ref>
  104cb5:	83 f8 02             	cmp    $0x2,%eax
  104cb8:	74 24                	je     104cde <check_boot_pgdir+0x2a1>
  104cba:	c7 44 24 0c 07 6b 10 	movl   $0x106b07,0xc(%esp)
  104cc1:	00 
  104cc2:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104cc9:	00 
  104cca:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104cd1:	00 
  104cd2:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104cd9:	e8 2e bf ff ff       	call   100c0c <__panic>

    const char *str = "ucore: Hello world!!";
  104cde:	c7 45 dc 18 6b 10 00 	movl   $0x106b18,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104cf3:	e8 19 0a 00 00       	call   105711 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104cf8:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104cff:	00 
  104d00:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104d07:	e8 7e 0a 00 00       	call   10578a <strcmp>
  104d0c:	85 c0                	test   %eax,%eax
  104d0e:	74 24                	je     104d34 <check_boot_pgdir+0x2f7>
  104d10:	c7 44 24 0c 30 6b 10 	movl   $0x106b30,0xc(%esp)
  104d17:	00 
  104d18:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104d1f:	00 
  104d20:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104d27:	00 
  104d28:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104d2f:	e8 d8 be ff ff       	call   100c0c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d37:	89 04 24             	mov    %eax,(%esp)
  104d3a:	e8 a7 ea ff ff       	call   1037e6 <page2kva>
  104d3f:	05 00 01 00 00       	add    $0x100,%eax
  104d44:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104d47:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104d4e:	e8 66 09 00 00       	call   1056b9 <strlen>
  104d53:	85 c0                	test   %eax,%eax
  104d55:	74 24                	je     104d7b <check_boot_pgdir+0x33e>
  104d57:	c7 44 24 0c 68 6b 10 	movl   $0x106b68,0xc(%esp)
  104d5e:	00 
  104d5f:	c7 44 24 08 09 67 10 	movl   $0x106709,0x8(%esp)
  104d66:	00 
  104d67:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104d6e:	00 
  104d6f:	c7 04 24 e4 66 10 00 	movl   $0x1066e4,(%esp)
  104d76:	e8 91 be ff ff       	call   100c0c <__panic>

    free_page(p);
  104d7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d82:	00 
  104d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d86:	89 04 24             	mov    %eax,(%esp)
  104d89:	e8 32 ed ff ff       	call   103ac0 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104d8e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d93:	8b 00                	mov    (%eax),%eax
  104d95:	89 04 24             	mov    %eax,(%esp)
  104d98:	e8 db ea ff ff       	call   103878 <pde2page>
  104d9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104da4:	00 
  104da5:	89 04 24             	mov    %eax,(%esp)
  104da8:	e8 13 ed ff ff       	call   103ac0 <free_pages>
    boot_pgdir[0] = 0;
  104dad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104db8:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104dbf:	e8 78 b5 ff ff       	call   10033c <cprintf>
}
  104dc4:	c9                   	leave  
  104dc5:	c3                   	ret    

00104dc6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104dc6:	55                   	push   %ebp
  104dc7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  104dcc:	83 e0 04             	and    $0x4,%eax
  104dcf:	85 c0                	test   %eax,%eax
  104dd1:	74 07                	je     104dda <perm2str+0x14>
  104dd3:	b8 75 00 00 00       	mov    $0x75,%eax
  104dd8:	eb 05                	jmp    104ddf <perm2str+0x19>
  104dda:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104ddf:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  104de4:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104deb:	8b 45 08             	mov    0x8(%ebp),%eax
  104dee:	83 e0 02             	and    $0x2,%eax
  104df1:	85 c0                	test   %eax,%eax
  104df3:	74 07                	je     104dfc <perm2str+0x36>
  104df5:	b8 77 00 00 00       	mov    $0x77,%eax
  104dfa:	eb 05                	jmp    104e01 <perm2str+0x3b>
  104dfc:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104e01:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  104e06:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  104e0d:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  104e12:	5d                   	pop    %ebp
  104e13:	c3                   	ret    

00104e14 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104e14:	55                   	push   %ebp
  104e15:	89 e5                	mov    %esp,%ebp
  104e17:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  104e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e20:	72 0a                	jb     104e2c <get_pgtable_items+0x18>
        return 0;
  104e22:	b8 00 00 00 00       	mov    $0x0,%eax
  104e27:	e9 9c 00 00 00       	jmp    104ec8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  104e2c:	eb 04                	jmp    104e32 <get_pgtable_items+0x1e>
        start ++;
  104e2e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  104e32:	8b 45 10             	mov    0x10(%ebp),%eax
  104e35:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e38:	73 18                	jae    104e52 <get_pgtable_items+0x3e>
  104e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  104e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104e44:	8b 45 14             	mov    0x14(%ebp),%eax
  104e47:	01 d0                	add    %edx,%eax
  104e49:	8b 00                	mov    (%eax),%eax
  104e4b:	83 e0 01             	and    $0x1,%eax
  104e4e:	85 c0                	test   %eax,%eax
  104e50:	74 dc                	je     104e2e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  104e52:	8b 45 10             	mov    0x10(%ebp),%eax
  104e55:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e58:	73 69                	jae    104ec3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104e5a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104e5e:	74 08                	je     104e68 <get_pgtable_items+0x54>
            *left_store = start;
  104e60:	8b 45 18             	mov    0x18(%ebp),%eax
  104e63:	8b 55 10             	mov    0x10(%ebp),%edx
  104e66:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104e68:	8b 45 10             	mov    0x10(%ebp),%eax
  104e6b:	8d 50 01             	lea    0x1(%eax),%edx
  104e6e:	89 55 10             	mov    %edx,0x10(%ebp)
  104e71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104e78:	8b 45 14             	mov    0x14(%ebp),%eax
  104e7b:	01 d0                	add    %edx,%eax
  104e7d:	8b 00                	mov    (%eax),%eax
  104e7f:	83 e0 07             	and    $0x7,%eax
  104e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104e85:	eb 04                	jmp    104e8b <get_pgtable_items+0x77>
            start ++;
  104e87:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  104e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  104e8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e91:	73 1d                	jae    104eb0 <get_pgtable_items+0x9c>
  104e93:	8b 45 10             	mov    0x10(%ebp),%eax
  104e96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  104ea0:	01 d0                	add    %edx,%eax
  104ea2:	8b 00                	mov    (%eax),%eax
  104ea4:	83 e0 07             	and    $0x7,%eax
  104ea7:	89 c2                	mov    %eax,%edx
  104ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104eac:	39 c2                	cmp    %eax,%edx
  104eae:	74 d7                	je     104e87 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  104eb0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104eb4:	74 08                	je     104ebe <get_pgtable_items+0xaa>
            *right_store = start;
  104eb6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104eb9:	8b 55 10             	mov    0x10(%ebp),%edx
  104ebc:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104ec1:	eb 05                	jmp    104ec8 <get_pgtable_items+0xb4>
    }
    return 0;
  104ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104ec8:	c9                   	leave  
  104ec9:	c3                   	ret    

00104eca <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104eca:	55                   	push   %ebp
  104ecb:	89 e5                	mov    %esp,%ebp
  104ecd:	57                   	push   %edi
  104ece:	56                   	push   %esi
  104ecf:	53                   	push   %ebx
  104ed0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104ed3:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104eda:	e8 5d b4 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  104edf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104ee6:	e9 fa 00 00 00       	jmp    104fe5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104eeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eee:	89 04 24             	mov    %eax,(%esp)
  104ef1:	e8 d0 fe ff ff       	call   104dc6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104ef6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104ef9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104efc:	29 d1                	sub    %edx,%ecx
  104efe:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104f00:	89 d6                	mov    %edx,%esi
  104f02:	c1 e6 16             	shl    $0x16,%esi
  104f05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104f08:	89 d3                	mov    %edx,%ebx
  104f0a:	c1 e3 16             	shl    $0x16,%ebx
  104f0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f10:	89 d1                	mov    %edx,%ecx
  104f12:	c1 e1 16             	shl    $0x16,%ecx
  104f15:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104f18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f1b:	29 d7                	sub    %edx,%edi
  104f1d:	89 fa                	mov    %edi,%edx
  104f1f:	89 44 24 14          	mov    %eax,0x14(%esp)
  104f23:	89 74 24 10          	mov    %esi,0x10(%esp)
  104f27:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104f2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104f2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f33:	c7 04 24 dd 6b 10 00 	movl   $0x106bdd,(%esp)
  104f3a:	e8 fd b3 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f42:	c1 e0 0a             	shl    $0xa,%eax
  104f45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104f48:	eb 54                	jmp    104f9e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f4d:	89 04 24             	mov    %eax,(%esp)
  104f50:	e8 71 fe ff ff       	call   104dc6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104f55:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104f58:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104f5b:	29 d1                	sub    %edx,%ecx
  104f5d:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104f5f:	89 d6                	mov    %edx,%esi
  104f61:	c1 e6 0c             	shl    $0xc,%esi
  104f64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f67:	89 d3                	mov    %edx,%ebx
  104f69:	c1 e3 0c             	shl    $0xc,%ebx
  104f6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104f6f:	c1 e2 0c             	shl    $0xc,%edx
  104f72:	89 d1                	mov    %edx,%ecx
  104f74:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104f77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104f7a:	29 d7                	sub    %edx,%edi
  104f7c:	89 fa                	mov    %edi,%edx
  104f7e:	89 44 24 14          	mov    %eax,0x14(%esp)
  104f82:	89 74 24 10          	mov    %esi,0x10(%esp)
  104f86:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104f8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104f8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f92:	c7 04 24 fc 6b 10 00 	movl   $0x106bfc,(%esp)
  104f99:	e8 9e b3 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104f9e:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  104fa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fa6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104fa9:	89 ce                	mov    %ecx,%esi
  104fab:	c1 e6 0a             	shl    $0xa,%esi
  104fae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  104fb1:	89 cb                	mov    %ecx,%ebx
  104fb3:	c1 e3 0a             	shl    $0xa,%ebx
  104fb6:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  104fb9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  104fbd:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  104fc0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  104fc4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  104fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104fcc:	89 74 24 04          	mov    %esi,0x4(%esp)
  104fd0:	89 1c 24             	mov    %ebx,(%esp)
  104fd3:	e8 3c fe ff ff       	call   104e14 <get_pgtable_items>
  104fd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104fdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104fdf:	0f 85 65 ff ff ff    	jne    104f4a <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104fe5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  104fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104fed:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  104ff0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  104ff4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  104ff7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  104ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  104fff:	89 44 24 08          	mov    %eax,0x8(%esp)
  105003:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10500a:	00 
  10500b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105012:	e8 fd fd ff ff       	call   104e14 <get_pgtable_items>
  105017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10501a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10501e:	0f 85 c7 fe ff ff    	jne    104eeb <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105024:	c7 04 24 20 6c 10 00 	movl   $0x106c20,(%esp)
  10502b:	e8 0c b3 ff ff       	call   10033c <cprintf>
}
  105030:	83 c4 4c             	add    $0x4c,%esp
  105033:	5b                   	pop    %ebx
  105034:	5e                   	pop    %esi
  105035:	5f                   	pop    %edi
  105036:	5d                   	pop    %ebp
  105037:	c3                   	ret    

00105038 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105038:	55                   	push   %ebp
  105039:	89 e5                	mov    %esp,%ebp
  10503b:	83 ec 58             	sub    $0x58,%esp
  10503e:	8b 45 10             	mov    0x10(%ebp),%eax
  105041:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105044:	8b 45 14             	mov    0x14(%ebp),%eax
  105047:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10504a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10504d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105050:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105053:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105056:	8b 45 18             	mov    0x18(%ebp),%eax
  105059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10505c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10505f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105062:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105065:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10506b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10506e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105072:	74 1c                	je     105090 <printnum+0x58>
  105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105077:	ba 00 00 00 00       	mov    $0x0,%edx
  10507c:	f7 75 e4             	divl   -0x1c(%ebp)
  10507f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105085:	ba 00 00 00 00       	mov    $0x0,%edx
  10508a:	f7 75 e4             	divl   -0x1c(%ebp)
  10508d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105096:	f7 75 e4             	divl   -0x1c(%ebp)
  105099:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10509c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10509f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1050a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1050ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1050b1:	8b 45 18             	mov    0x18(%ebp),%eax
  1050b4:	ba 00 00 00 00       	mov    $0x0,%edx
  1050b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1050bc:	77 56                	ja     105114 <printnum+0xdc>
  1050be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1050c1:	72 05                	jb     1050c8 <printnum+0x90>
  1050c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1050c6:	77 4c                	ja     105114 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1050c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1050cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1050ce:	8b 45 20             	mov    0x20(%ebp),%eax
  1050d1:	89 44 24 18          	mov    %eax,0x18(%esp)
  1050d5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1050d9:	8b 45 18             	mov    0x18(%ebp),%eax
  1050dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1050e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1050ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1050f8:	89 04 24             	mov    %eax,(%esp)
  1050fb:	e8 38 ff ff ff       	call   105038 <printnum>
  105100:	eb 1c                	jmp    10511e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105102:	8b 45 0c             	mov    0xc(%ebp),%eax
  105105:	89 44 24 04          	mov    %eax,0x4(%esp)
  105109:	8b 45 20             	mov    0x20(%ebp),%eax
  10510c:	89 04 24             	mov    %eax,(%esp)
  10510f:	8b 45 08             	mov    0x8(%ebp),%eax
  105112:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105114:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105118:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10511c:	7f e4                	jg     105102 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10511e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105121:	05 d4 6c 10 00       	add    $0x106cd4,%eax
  105126:	0f b6 00             	movzbl (%eax),%eax
  105129:	0f be c0             	movsbl %al,%eax
  10512c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10512f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105133:	89 04 24             	mov    %eax,(%esp)
  105136:	8b 45 08             	mov    0x8(%ebp),%eax
  105139:	ff d0                	call   *%eax
}
  10513b:	c9                   	leave  
  10513c:	c3                   	ret    

0010513d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10513d:	55                   	push   %ebp
  10513e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105140:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105144:	7e 14                	jle    10515a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105146:	8b 45 08             	mov    0x8(%ebp),%eax
  105149:	8b 00                	mov    (%eax),%eax
  10514b:	8d 48 08             	lea    0x8(%eax),%ecx
  10514e:	8b 55 08             	mov    0x8(%ebp),%edx
  105151:	89 0a                	mov    %ecx,(%edx)
  105153:	8b 50 04             	mov    0x4(%eax),%edx
  105156:	8b 00                	mov    (%eax),%eax
  105158:	eb 30                	jmp    10518a <getuint+0x4d>
    }
    else if (lflag) {
  10515a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10515e:	74 16                	je     105176 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105160:	8b 45 08             	mov    0x8(%ebp),%eax
  105163:	8b 00                	mov    (%eax),%eax
  105165:	8d 48 04             	lea    0x4(%eax),%ecx
  105168:	8b 55 08             	mov    0x8(%ebp),%edx
  10516b:	89 0a                	mov    %ecx,(%edx)
  10516d:	8b 00                	mov    (%eax),%eax
  10516f:	ba 00 00 00 00       	mov    $0x0,%edx
  105174:	eb 14                	jmp    10518a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105176:	8b 45 08             	mov    0x8(%ebp),%eax
  105179:	8b 00                	mov    (%eax),%eax
  10517b:	8d 48 04             	lea    0x4(%eax),%ecx
  10517e:	8b 55 08             	mov    0x8(%ebp),%edx
  105181:	89 0a                	mov    %ecx,(%edx)
  105183:	8b 00                	mov    (%eax),%eax
  105185:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10518a:	5d                   	pop    %ebp
  10518b:	c3                   	ret    

0010518c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10518c:	55                   	push   %ebp
  10518d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10518f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105193:	7e 14                	jle    1051a9 <getint+0x1d>
        return va_arg(*ap, long long);
  105195:	8b 45 08             	mov    0x8(%ebp),%eax
  105198:	8b 00                	mov    (%eax),%eax
  10519a:	8d 48 08             	lea    0x8(%eax),%ecx
  10519d:	8b 55 08             	mov    0x8(%ebp),%edx
  1051a0:	89 0a                	mov    %ecx,(%edx)
  1051a2:	8b 50 04             	mov    0x4(%eax),%edx
  1051a5:	8b 00                	mov    (%eax),%eax
  1051a7:	eb 28                	jmp    1051d1 <getint+0x45>
    }
    else if (lflag) {
  1051a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1051ad:	74 12                	je     1051c1 <getint+0x35>
        return va_arg(*ap, long);
  1051af:	8b 45 08             	mov    0x8(%ebp),%eax
  1051b2:	8b 00                	mov    (%eax),%eax
  1051b4:	8d 48 04             	lea    0x4(%eax),%ecx
  1051b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1051ba:	89 0a                	mov    %ecx,(%edx)
  1051bc:	8b 00                	mov    (%eax),%eax
  1051be:	99                   	cltd   
  1051bf:	eb 10                	jmp    1051d1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1051c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1051c4:	8b 00                	mov    (%eax),%eax
  1051c6:	8d 48 04             	lea    0x4(%eax),%ecx
  1051c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1051cc:	89 0a                	mov    %ecx,(%edx)
  1051ce:	8b 00                	mov    (%eax),%eax
  1051d0:	99                   	cltd   
    }
}
  1051d1:	5d                   	pop    %ebp
  1051d2:	c3                   	ret    

001051d3 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1051d3:	55                   	push   %ebp
  1051d4:	89 e5                	mov    %esp,%ebp
  1051d6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1051d9:	8d 45 14             	lea    0x14(%ebp),%eax
  1051dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1051e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1051e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f7:	89 04 24             	mov    %eax,(%esp)
  1051fa:	e8 02 00 00 00       	call   105201 <vprintfmt>
    va_end(ap);
}
  1051ff:	c9                   	leave  
  105200:	c3                   	ret    

00105201 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105201:	55                   	push   %ebp
  105202:	89 e5                	mov    %esp,%ebp
  105204:	56                   	push   %esi
  105205:	53                   	push   %ebx
  105206:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105209:	eb 18                	jmp    105223 <vprintfmt+0x22>
            if (ch == '\0') {
  10520b:	85 db                	test   %ebx,%ebx
  10520d:	75 05                	jne    105214 <vprintfmt+0x13>
                return;
  10520f:	e9 d1 03 00 00       	jmp    1055e5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105214:	8b 45 0c             	mov    0xc(%ebp),%eax
  105217:	89 44 24 04          	mov    %eax,0x4(%esp)
  10521b:	89 1c 24             	mov    %ebx,(%esp)
  10521e:	8b 45 08             	mov    0x8(%ebp),%eax
  105221:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105223:	8b 45 10             	mov    0x10(%ebp),%eax
  105226:	8d 50 01             	lea    0x1(%eax),%edx
  105229:	89 55 10             	mov    %edx,0x10(%ebp)
  10522c:	0f b6 00             	movzbl (%eax),%eax
  10522f:	0f b6 d8             	movzbl %al,%ebx
  105232:	83 fb 25             	cmp    $0x25,%ebx
  105235:	75 d4                	jne    10520b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105237:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10523b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105245:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105248:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10524f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105252:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105255:	8b 45 10             	mov    0x10(%ebp),%eax
  105258:	8d 50 01             	lea    0x1(%eax),%edx
  10525b:	89 55 10             	mov    %edx,0x10(%ebp)
  10525e:	0f b6 00             	movzbl (%eax),%eax
  105261:	0f b6 d8             	movzbl %al,%ebx
  105264:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105267:	83 f8 55             	cmp    $0x55,%eax
  10526a:	0f 87 44 03 00 00    	ja     1055b4 <vprintfmt+0x3b3>
  105270:	8b 04 85 f8 6c 10 00 	mov    0x106cf8(,%eax,4),%eax
  105277:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105279:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10527d:	eb d6                	jmp    105255 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10527f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105283:	eb d0                	jmp    105255 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105285:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10528c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10528f:	89 d0                	mov    %edx,%eax
  105291:	c1 e0 02             	shl    $0x2,%eax
  105294:	01 d0                	add    %edx,%eax
  105296:	01 c0                	add    %eax,%eax
  105298:	01 d8                	add    %ebx,%eax
  10529a:	83 e8 30             	sub    $0x30,%eax
  10529d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1052a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1052a3:	0f b6 00             	movzbl (%eax),%eax
  1052a6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1052a9:	83 fb 2f             	cmp    $0x2f,%ebx
  1052ac:	7e 0b                	jle    1052b9 <vprintfmt+0xb8>
  1052ae:	83 fb 39             	cmp    $0x39,%ebx
  1052b1:	7f 06                	jg     1052b9 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1052b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1052b7:	eb d3                	jmp    10528c <vprintfmt+0x8b>
            goto process_precision;
  1052b9:	eb 33                	jmp    1052ee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1052bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1052be:	8d 50 04             	lea    0x4(%eax),%edx
  1052c1:	89 55 14             	mov    %edx,0x14(%ebp)
  1052c4:	8b 00                	mov    (%eax),%eax
  1052c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1052c9:	eb 23                	jmp    1052ee <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1052cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1052cf:	79 0c                	jns    1052dd <vprintfmt+0xdc>
                width = 0;
  1052d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1052d8:	e9 78 ff ff ff       	jmp    105255 <vprintfmt+0x54>
  1052dd:	e9 73 ff ff ff       	jmp    105255 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1052e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1052e9:	e9 67 ff ff ff       	jmp    105255 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1052ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1052f2:	79 12                	jns    105306 <vprintfmt+0x105>
                width = precision, precision = -1;
  1052f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105301:	e9 4f ff ff ff       	jmp    105255 <vprintfmt+0x54>
  105306:	e9 4a ff ff ff       	jmp    105255 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10530b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10530f:	e9 41 ff ff ff       	jmp    105255 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105314:	8b 45 14             	mov    0x14(%ebp),%eax
  105317:	8d 50 04             	lea    0x4(%eax),%edx
  10531a:	89 55 14             	mov    %edx,0x14(%ebp)
  10531d:	8b 00                	mov    (%eax),%eax
  10531f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105322:	89 54 24 04          	mov    %edx,0x4(%esp)
  105326:	89 04 24             	mov    %eax,(%esp)
  105329:	8b 45 08             	mov    0x8(%ebp),%eax
  10532c:	ff d0                	call   *%eax
            break;
  10532e:	e9 ac 02 00 00       	jmp    1055df <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105333:	8b 45 14             	mov    0x14(%ebp),%eax
  105336:	8d 50 04             	lea    0x4(%eax),%edx
  105339:	89 55 14             	mov    %edx,0x14(%ebp)
  10533c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10533e:	85 db                	test   %ebx,%ebx
  105340:	79 02                	jns    105344 <vprintfmt+0x143>
                err = -err;
  105342:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105344:	83 fb 06             	cmp    $0x6,%ebx
  105347:	7f 0b                	jg     105354 <vprintfmt+0x153>
  105349:	8b 34 9d b8 6c 10 00 	mov    0x106cb8(,%ebx,4),%esi
  105350:	85 f6                	test   %esi,%esi
  105352:	75 23                	jne    105377 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105358:	c7 44 24 08 e5 6c 10 	movl   $0x106ce5,0x8(%esp)
  10535f:	00 
  105360:	8b 45 0c             	mov    0xc(%ebp),%eax
  105363:	89 44 24 04          	mov    %eax,0x4(%esp)
  105367:	8b 45 08             	mov    0x8(%ebp),%eax
  10536a:	89 04 24             	mov    %eax,(%esp)
  10536d:	e8 61 fe ff ff       	call   1051d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105372:	e9 68 02 00 00       	jmp    1055df <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105377:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10537b:	c7 44 24 08 ee 6c 10 	movl   $0x106cee,0x8(%esp)
  105382:	00 
  105383:	8b 45 0c             	mov    0xc(%ebp),%eax
  105386:	89 44 24 04          	mov    %eax,0x4(%esp)
  10538a:	8b 45 08             	mov    0x8(%ebp),%eax
  10538d:	89 04 24             	mov    %eax,(%esp)
  105390:	e8 3e fe ff ff       	call   1051d3 <printfmt>
            }
            break;
  105395:	e9 45 02 00 00       	jmp    1055df <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10539a:	8b 45 14             	mov    0x14(%ebp),%eax
  10539d:	8d 50 04             	lea    0x4(%eax),%edx
  1053a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1053a3:	8b 30                	mov    (%eax),%esi
  1053a5:	85 f6                	test   %esi,%esi
  1053a7:	75 05                	jne    1053ae <vprintfmt+0x1ad>
                p = "(null)";
  1053a9:	be f1 6c 10 00       	mov    $0x106cf1,%esi
            }
            if (width > 0 && padc != '-') {
  1053ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1053b2:	7e 3e                	jle    1053f2 <vprintfmt+0x1f1>
  1053b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1053b8:	74 38                	je     1053f2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1053ba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1053bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053c4:	89 34 24             	mov    %esi,(%esp)
  1053c7:	e8 15 03 00 00       	call   1056e1 <strnlen>
  1053cc:	29 c3                	sub    %eax,%ebx
  1053ce:	89 d8                	mov    %ebx,%eax
  1053d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053d3:	eb 17                	jmp    1053ec <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1053d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1053d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053e0:	89 04 24             	mov    %eax,(%esp)
  1053e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1053e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1053ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1053f0:	7f e3                	jg     1053d5 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1053f2:	eb 38                	jmp    10542c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1053f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1053f8:	74 1f                	je     105419 <vprintfmt+0x218>
  1053fa:	83 fb 1f             	cmp    $0x1f,%ebx
  1053fd:	7e 05                	jle    105404 <vprintfmt+0x203>
  1053ff:	83 fb 7e             	cmp    $0x7e,%ebx
  105402:	7e 15                	jle    105419 <vprintfmt+0x218>
                    putch('?', putdat);
  105404:	8b 45 0c             	mov    0xc(%ebp),%eax
  105407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10540b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105412:	8b 45 08             	mov    0x8(%ebp),%eax
  105415:	ff d0                	call   *%eax
  105417:	eb 0f                	jmp    105428 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105419:	8b 45 0c             	mov    0xc(%ebp),%eax
  10541c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105420:	89 1c 24             	mov    %ebx,(%esp)
  105423:	8b 45 08             	mov    0x8(%ebp),%eax
  105426:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105428:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10542c:	89 f0                	mov    %esi,%eax
  10542e:	8d 70 01             	lea    0x1(%eax),%esi
  105431:	0f b6 00             	movzbl (%eax),%eax
  105434:	0f be d8             	movsbl %al,%ebx
  105437:	85 db                	test   %ebx,%ebx
  105439:	74 10                	je     10544b <vprintfmt+0x24a>
  10543b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10543f:	78 b3                	js     1053f4 <vprintfmt+0x1f3>
  105441:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105445:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105449:	79 a9                	jns    1053f4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10544b:	eb 17                	jmp    105464 <vprintfmt+0x263>
                putch(' ', putdat);
  10544d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105450:	89 44 24 04          	mov    %eax,0x4(%esp)
  105454:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10545b:	8b 45 08             	mov    0x8(%ebp),%eax
  10545e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105460:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105464:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105468:	7f e3                	jg     10544d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10546a:	e9 70 01 00 00       	jmp    1055df <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10546f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105472:	89 44 24 04          	mov    %eax,0x4(%esp)
  105476:	8d 45 14             	lea    0x14(%ebp),%eax
  105479:	89 04 24             	mov    %eax,(%esp)
  10547c:	e8 0b fd ff ff       	call   10518c <getint>
  105481:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105484:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10548a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10548d:	85 d2                	test   %edx,%edx
  10548f:	79 26                	jns    1054b7 <vprintfmt+0x2b6>
                putch('-', putdat);
  105491:	8b 45 0c             	mov    0xc(%ebp),%eax
  105494:	89 44 24 04          	mov    %eax,0x4(%esp)
  105498:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10549f:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a2:	ff d0                	call   *%eax
                num = -(long long)num;
  1054a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054aa:	f7 d8                	neg    %eax
  1054ac:	83 d2 00             	adc    $0x0,%edx
  1054af:	f7 da                	neg    %edx
  1054b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1054b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1054be:	e9 a8 00 00 00       	jmp    10556b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1054cd:	89 04 24             	mov    %eax,(%esp)
  1054d0:	e8 68 fc ff ff       	call   10513d <getuint>
  1054d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1054db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1054e2:	e9 84 00 00 00       	jmp    10556b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1054e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1054f1:	89 04 24             	mov    %eax,(%esp)
  1054f4:	e8 44 fc ff ff       	call   10513d <getuint>
  1054f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1054ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105506:	eb 63                	jmp    10556b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105508:	8b 45 0c             	mov    0xc(%ebp),%eax
  10550b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10550f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105516:	8b 45 08             	mov    0x8(%ebp),%eax
  105519:	ff d0                	call   *%eax
            putch('x', putdat);
  10551b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10551e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105522:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105529:	8b 45 08             	mov    0x8(%ebp),%eax
  10552c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10552e:	8b 45 14             	mov    0x14(%ebp),%eax
  105531:	8d 50 04             	lea    0x4(%eax),%edx
  105534:	89 55 14             	mov    %edx,0x14(%ebp)
  105537:	8b 00                	mov    (%eax),%eax
  105539:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10553c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105543:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10554a:	eb 1f                	jmp    10556b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10554c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10554f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105553:	8d 45 14             	lea    0x14(%ebp),%eax
  105556:	89 04 24             	mov    %eax,(%esp)
  105559:	e8 df fb ff ff       	call   10513d <getuint>
  10555e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105561:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105564:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10556b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10556f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105572:	89 54 24 18          	mov    %edx,0x18(%esp)
  105576:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105579:	89 54 24 14          	mov    %edx,0x14(%esp)
  10557d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105587:	89 44 24 08          	mov    %eax,0x8(%esp)
  10558b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10558f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105592:	89 44 24 04          	mov    %eax,0x4(%esp)
  105596:	8b 45 08             	mov    0x8(%ebp),%eax
  105599:	89 04 24             	mov    %eax,(%esp)
  10559c:	e8 97 fa ff ff       	call   105038 <printnum>
            break;
  1055a1:	eb 3c                	jmp    1055df <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1055a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055aa:	89 1c 24             	mov    %ebx,(%esp)
  1055ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b0:	ff d0                	call   *%eax
            break;
  1055b2:	eb 2b                	jmp    1055df <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1055b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1055c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1055c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1055cb:	eb 04                	jmp    1055d1 <vprintfmt+0x3d0>
  1055cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1055d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1055d4:	83 e8 01             	sub    $0x1,%eax
  1055d7:	0f b6 00             	movzbl (%eax),%eax
  1055da:	3c 25                	cmp    $0x25,%al
  1055dc:	75 ef                	jne    1055cd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1055de:	90                   	nop
        }
    }
  1055df:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055e0:	e9 3e fc ff ff       	jmp    105223 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1055e5:	83 c4 40             	add    $0x40,%esp
  1055e8:	5b                   	pop    %ebx
  1055e9:	5e                   	pop    %esi
  1055ea:	5d                   	pop    %ebp
  1055eb:	c3                   	ret    

001055ec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1055ec:	55                   	push   %ebp
  1055ed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1055ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f2:	8b 40 08             	mov    0x8(%eax),%eax
  1055f5:	8d 50 01             	lea    0x1(%eax),%edx
  1055f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055fb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105601:	8b 10                	mov    (%eax),%edx
  105603:	8b 45 0c             	mov    0xc(%ebp),%eax
  105606:	8b 40 04             	mov    0x4(%eax),%eax
  105609:	39 c2                	cmp    %eax,%edx
  10560b:	73 12                	jae    10561f <sprintputch+0x33>
        *b->buf ++ = ch;
  10560d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105610:	8b 00                	mov    (%eax),%eax
  105612:	8d 48 01             	lea    0x1(%eax),%ecx
  105615:	8b 55 0c             	mov    0xc(%ebp),%edx
  105618:	89 0a                	mov    %ecx,(%edx)
  10561a:	8b 55 08             	mov    0x8(%ebp),%edx
  10561d:	88 10                	mov    %dl,(%eax)
    }
}
  10561f:	5d                   	pop    %ebp
  105620:	c3                   	ret    

00105621 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105621:	55                   	push   %ebp
  105622:	89 e5                	mov    %esp,%ebp
  105624:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105627:	8d 45 14             	lea    0x14(%ebp),%eax
  10562a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10562d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105630:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105634:	8b 45 10             	mov    0x10(%ebp),%eax
  105637:	89 44 24 08          	mov    %eax,0x8(%esp)
  10563b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105642:	8b 45 08             	mov    0x8(%ebp),%eax
  105645:	89 04 24             	mov    %eax,(%esp)
  105648:	e8 08 00 00 00       	call   105655 <vsnprintf>
  10564d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105653:	c9                   	leave  
  105654:	c3                   	ret    

00105655 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105655:	55                   	push   %ebp
  105656:	89 e5                	mov    %esp,%ebp
  105658:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10565b:	8b 45 08             	mov    0x8(%ebp),%eax
  10565e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105661:	8b 45 0c             	mov    0xc(%ebp),%eax
  105664:	8d 50 ff             	lea    -0x1(%eax),%edx
  105667:	8b 45 08             	mov    0x8(%ebp),%eax
  10566a:	01 d0                	add    %edx,%eax
  10566c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10566f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10567a:	74 0a                	je     105686 <vsnprintf+0x31>
  10567c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10567f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105682:	39 c2                	cmp    %eax,%edx
  105684:	76 07                	jbe    10568d <vsnprintf+0x38>
        return -E_INVAL;
  105686:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10568b:	eb 2a                	jmp    1056b7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10568d:	8b 45 14             	mov    0x14(%ebp),%eax
  105690:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105694:	8b 45 10             	mov    0x10(%ebp),%eax
  105697:	89 44 24 08          	mov    %eax,0x8(%esp)
  10569b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10569e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056a2:	c7 04 24 ec 55 10 00 	movl   $0x1055ec,(%esp)
  1056a9:	e8 53 fb ff ff       	call   105201 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1056ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1056b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1056b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1056b7:	c9                   	leave  
  1056b8:	c3                   	ret    

001056b9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1056b9:	55                   	push   %ebp
  1056ba:	89 e5                	mov    %esp,%ebp
  1056bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1056bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1056c6:	eb 04                	jmp    1056cc <strlen+0x13>
        cnt ++;
  1056c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1056cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1056cf:	8d 50 01             	lea    0x1(%eax),%edx
  1056d2:	89 55 08             	mov    %edx,0x8(%ebp)
  1056d5:	0f b6 00             	movzbl (%eax),%eax
  1056d8:	84 c0                	test   %al,%al
  1056da:	75 ec                	jne    1056c8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1056dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1056df:	c9                   	leave  
  1056e0:	c3                   	ret    

001056e1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1056e1:	55                   	push   %ebp
  1056e2:	89 e5                	mov    %esp,%ebp
  1056e4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1056e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1056ee:	eb 04                	jmp    1056f4 <strnlen+0x13>
        cnt ++;
  1056f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1056f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1056fa:	73 10                	jae    10570c <strnlen+0x2b>
  1056fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ff:	8d 50 01             	lea    0x1(%eax),%edx
  105702:	89 55 08             	mov    %edx,0x8(%ebp)
  105705:	0f b6 00             	movzbl (%eax),%eax
  105708:	84 c0                	test   %al,%al
  10570a:	75 e4                	jne    1056f0 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10570c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10570f:	c9                   	leave  
  105710:	c3                   	ret    

00105711 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105711:	55                   	push   %ebp
  105712:	89 e5                	mov    %esp,%ebp
  105714:	57                   	push   %edi
  105715:	56                   	push   %esi
  105716:	83 ec 20             	sub    $0x20,%esp
  105719:	8b 45 08             	mov    0x8(%ebp),%eax
  10571c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10571f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105722:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105725:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10572b:	89 d1                	mov    %edx,%ecx
  10572d:	89 c2                	mov    %eax,%edx
  10572f:	89 ce                	mov    %ecx,%esi
  105731:	89 d7                	mov    %edx,%edi
  105733:	ac                   	lods   %ds:(%esi),%al
  105734:	aa                   	stos   %al,%es:(%edi)
  105735:	84 c0                	test   %al,%al
  105737:	75 fa                	jne    105733 <strcpy+0x22>
  105739:	89 fa                	mov    %edi,%edx
  10573b:	89 f1                	mov    %esi,%ecx
  10573d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105740:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105749:	83 c4 20             	add    $0x20,%esp
  10574c:	5e                   	pop    %esi
  10574d:	5f                   	pop    %edi
  10574e:	5d                   	pop    %ebp
  10574f:	c3                   	ret    

00105750 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105750:	55                   	push   %ebp
  105751:	89 e5                	mov    %esp,%ebp
  105753:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105756:	8b 45 08             	mov    0x8(%ebp),%eax
  105759:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10575c:	eb 21                	jmp    10577f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10575e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105761:	0f b6 10             	movzbl (%eax),%edx
  105764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105767:	88 10                	mov    %dl,(%eax)
  105769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10576c:	0f b6 00             	movzbl (%eax),%eax
  10576f:	84 c0                	test   %al,%al
  105771:	74 04                	je     105777 <strncpy+0x27>
            src ++;
  105773:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105777:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10577b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10577f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105783:	75 d9                	jne    10575e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105785:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105788:	c9                   	leave  
  105789:	c3                   	ret    

0010578a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10578a:	55                   	push   %ebp
  10578b:	89 e5                	mov    %esp,%ebp
  10578d:	57                   	push   %edi
  10578e:	56                   	push   %esi
  10578f:	83 ec 20             	sub    $0x20,%esp
  105792:	8b 45 08             	mov    0x8(%ebp),%eax
  105795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105798:	8b 45 0c             	mov    0xc(%ebp),%eax
  10579b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10579e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a4:	89 d1                	mov    %edx,%ecx
  1057a6:	89 c2                	mov    %eax,%edx
  1057a8:	89 ce                	mov    %ecx,%esi
  1057aa:	89 d7                	mov    %edx,%edi
  1057ac:	ac                   	lods   %ds:(%esi),%al
  1057ad:	ae                   	scas   %es:(%edi),%al
  1057ae:	75 08                	jne    1057b8 <strcmp+0x2e>
  1057b0:	84 c0                	test   %al,%al
  1057b2:	75 f8                	jne    1057ac <strcmp+0x22>
  1057b4:	31 c0                	xor    %eax,%eax
  1057b6:	eb 04                	jmp    1057bc <strcmp+0x32>
  1057b8:	19 c0                	sbb    %eax,%eax
  1057ba:	0c 01                	or     $0x1,%al
  1057bc:	89 fa                	mov    %edi,%edx
  1057be:	89 f1                	mov    %esi,%ecx
  1057c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057c3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1057c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1057c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1057cc:	83 c4 20             	add    $0x20,%esp
  1057cf:	5e                   	pop    %esi
  1057d0:	5f                   	pop    %edi
  1057d1:	5d                   	pop    %ebp
  1057d2:	c3                   	ret    

001057d3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1057d3:	55                   	push   %ebp
  1057d4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1057d6:	eb 0c                	jmp    1057e4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1057d8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1057e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1057e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057e8:	74 1a                	je     105804 <strncmp+0x31>
  1057ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ed:	0f b6 00             	movzbl (%eax),%eax
  1057f0:	84 c0                	test   %al,%al
  1057f2:	74 10                	je     105804 <strncmp+0x31>
  1057f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f7:	0f b6 10             	movzbl (%eax),%edx
  1057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fd:	0f b6 00             	movzbl (%eax),%eax
  105800:	38 c2                	cmp    %al,%dl
  105802:	74 d4                	je     1057d8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105804:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105808:	74 18                	je     105822 <strncmp+0x4f>
  10580a:	8b 45 08             	mov    0x8(%ebp),%eax
  10580d:	0f b6 00             	movzbl (%eax),%eax
  105810:	0f b6 d0             	movzbl %al,%edx
  105813:	8b 45 0c             	mov    0xc(%ebp),%eax
  105816:	0f b6 00             	movzbl (%eax),%eax
  105819:	0f b6 c0             	movzbl %al,%eax
  10581c:	29 c2                	sub    %eax,%edx
  10581e:	89 d0                	mov    %edx,%eax
  105820:	eb 05                	jmp    105827 <strncmp+0x54>
  105822:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105827:	5d                   	pop    %ebp
  105828:	c3                   	ret    

00105829 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105829:	55                   	push   %ebp
  10582a:	89 e5                	mov    %esp,%ebp
  10582c:	83 ec 04             	sub    $0x4,%esp
  10582f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105832:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105835:	eb 14                	jmp    10584b <strchr+0x22>
        if (*s == c) {
  105837:	8b 45 08             	mov    0x8(%ebp),%eax
  10583a:	0f b6 00             	movzbl (%eax),%eax
  10583d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105840:	75 05                	jne    105847 <strchr+0x1e>
            return (char *)s;
  105842:	8b 45 08             	mov    0x8(%ebp),%eax
  105845:	eb 13                	jmp    10585a <strchr+0x31>
        }
        s ++;
  105847:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10584b:	8b 45 08             	mov    0x8(%ebp),%eax
  10584e:	0f b6 00             	movzbl (%eax),%eax
  105851:	84 c0                	test   %al,%al
  105853:	75 e2                	jne    105837 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10585a:	c9                   	leave  
  10585b:	c3                   	ret    

0010585c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10585c:	55                   	push   %ebp
  10585d:	89 e5                	mov    %esp,%ebp
  10585f:	83 ec 04             	sub    $0x4,%esp
  105862:	8b 45 0c             	mov    0xc(%ebp),%eax
  105865:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105868:	eb 11                	jmp    10587b <strfind+0x1f>
        if (*s == c) {
  10586a:	8b 45 08             	mov    0x8(%ebp),%eax
  10586d:	0f b6 00             	movzbl (%eax),%eax
  105870:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105873:	75 02                	jne    105877 <strfind+0x1b>
            break;
  105875:	eb 0e                	jmp    105885 <strfind+0x29>
        }
        s ++;
  105877:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10587b:	8b 45 08             	mov    0x8(%ebp),%eax
  10587e:	0f b6 00             	movzbl (%eax),%eax
  105881:	84 c0                	test   %al,%al
  105883:	75 e5                	jne    10586a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105885:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105888:	c9                   	leave  
  105889:	c3                   	ret    

0010588a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10588a:	55                   	push   %ebp
  10588b:	89 e5                	mov    %esp,%ebp
  10588d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105890:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105897:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10589e:	eb 04                	jmp    1058a4 <strtol+0x1a>
        s ++;
  1058a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1058a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a7:	0f b6 00             	movzbl (%eax),%eax
  1058aa:	3c 20                	cmp    $0x20,%al
  1058ac:	74 f2                	je     1058a0 <strtol+0x16>
  1058ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b1:	0f b6 00             	movzbl (%eax),%eax
  1058b4:	3c 09                	cmp    $0x9,%al
  1058b6:	74 e8                	je     1058a0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1058b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058bb:	0f b6 00             	movzbl (%eax),%eax
  1058be:	3c 2b                	cmp    $0x2b,%al
  1058c0:	75 06                	jne    1058c8 <strtol+0x3e>
        s ++;
  1058c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058c6:	eb 15                	jmp    1058dd <strtol+0x53>
    }
    else if (*s == '-') {
  1058c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058cb:	0f b6 00             	movzbl (%eax),%eax
  1058ce:	3c 2d                	cmp    $0x2d,%al
  1058d0:	75 0b                	jne    1058dd <strtol+0x53>
        s ++, neg = 1;
  1058d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1058dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058e1:	74 06                	je     1058e9 <strtol+0x5f>
  1058e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1058e7:	75 24                	jne    10590d <strtol+0x83>
  1058e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ec:	0f b6 00             	movzbl (%eax),%eax
  1058ef:	3c 30                	cmp    $0x30,%al
  1058f1:	75 1a                	jne    10590d <strtol+0x83>
  1058f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f6:	83 c0 01             	add    $0x1,%eax
  1058f9:	0f b6 00             	movzbl (%eax),%eax
  1058fc:	3c 78                	cmp    $0x78,%al
  1058fe:	75 0d                	jne    10590d <strtol+0x83>
        s += 2, base = 16;
  105900:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105904:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10590b:	eb 2a                	jmp    105937 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10590d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105911:	75 17                	jne    10592a <strtol+0xa0>
  105913:	8b 45 08             	mov    0x8(%ebp),%eax
  105916:	0f b6 00             	movzbl (%eax),%eax
  105919:	3c 30                	cmp    $0x30,%al
  10591b:	75 0d                	jne    10592a <strtol+0xa0>
        s ++, base = 8;
  10591d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105921:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105928:	eb 0d                	jmp    105937 <strtol+0xad>
    }
    else if (base == 0) {
  10592a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10592e:	75 07                	jne    105937 <strtol+0xad>
        base = 10;
  105930:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105937:	8b 45 08             	mov    0x8(%ebp),%eax
  10593a:	0f b6 00             	movzbl (%eax),%eax
  10593d:	3c 2f                	cmp    $0x2f,%al
  10593f:	7e 1b                	jle    10595c <strtol+0xd2>
  105941:	8b 45 08             	mov    0x8(%ebp),%eax
  105944:	0f b6 00             	movzbl (%eax),%eax
  105947:	3c 39                	cmp    $0x39,%al
  105949:	7f 11                	jg     10595c <strtol+0xd2>
            dig = *s - '0';
  10594b:	8b 45 08             	mov    0x8(%ebp),%eax
  10594e:	0f b6 00             	movzbl (%eax),%eax
  105951:	0f be c0             	movsbl %al,%eax
  105954:	83 e8 30             	sub    $0x30,%eax
  105957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10595a:	eb 48                	jmp    1059a4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10595c:	8b 45 08             	mov    0x8(%ebp),%eax
  10595f:	0f b6 00             	movzbl (%eax),%eax
  105962:	3c 60                	cmp    $0x60,%al
  105964:	7e 1b                	jle    105981 <strtol+0xf7>
  105966:	8b 45 08             	mov    0x8(%ebp),%eax
  105969:	0f b6 00             	movzbl (%eax),%eax
  10596c:	3c 7a                	cmp    $0x7a,%al
  10596e:	7f 11                	jg     105981 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105970:	8b 45 08             	mov    0x8(%ebp),%eax
  105973:	0f b6 00             	movzbl (%eax),%eax
  105976:	0f be c0             	movsbl %al,%eax
  105979:	83 e8 57             	sub    $0x57,%eax
  10597c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10597f:	eb 23                	jmp    1059a4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105981:	8b 45 08             	mov    0x8(%ebp),%eax
  105984:	0f b6 00             	movzbl (%eax),%eax
  105987:	3c 40                	cmp    $0x40,%al
  105989:	7e 3d                	jle    1059c8 <strtol+0x13e>
  10598b:	8b 45 08             	mov    0x8(%ebp),%eax
  10598e:	0f b6 00             	movzbl (%eax),%eax
  105991:	3c 5a                	cmp    $0x5a,%al
  105993:	7f 33                	jg     1059c8 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105995:	8b 45 08             	mov    0x8(%ebp),%eax
  105998:	0f b6 00             	movzbl (%eax),%eax
  10599b:	0f be c0             	movsbl %al,%eax
  10599e:	83 e8 37             	sub    $0x37,%eax
  1059a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1059a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  1059aa:	7c 02                	jl     1059ae <strtol+0x124>
            break;
  1059ac:	eb 1a                	jmp    1059c8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1059ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  1059b9:	89 c2                	mov    %eax,%edx
  1059bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059be:	01 d0                	add    %edx,%eax
  1059c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1059c3:	e9 6f ff ff ff       	jmp    105937 <strtol+0xad>

    if (endptr) {
  1059c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059cc:	74 08                	je     1059d6 <strtol+0x14c>
        *endptr = (char *) s;
  1059ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1059d4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1059d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1059da:	74 07                	je     1059e3 <strtol+0x159>
  1059dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059df:	f7 d8                	neg    %eax
  1059e1:	eb 03                	jmp    1059e6 <strtol+0x15c>
  1059e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1059e6:	c9                   	leave  
  1059e7:	c3                   	ret    

001059e8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1059e8:	55                   	push   %ebp
  1059e9:	89 e5                	mov    %esp,%ebp
  1059eb:	57                   	push   %edi
  1059ec:	83 ec 24             	sub    $0x24,%esp
  1059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1059f5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1059f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1059fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1059ff:	88 45 f7             	mov    %al,-0x9(%ebp)
  105a02:	8b 45 10             	mov    0x10(%ebp),%eax
  105a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105a08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105a0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105a0f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105a12:	89 d7                	mov    %edx,%edi
  105a14:	f3 aa                	rep stos %al,%es:(%edi)
  105a16:	89 fa                	mov    %edi,%edx
  105a18:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a1b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105a21:	83 c4 24             	add    $0x24,%esp
  105a24:	5f                   	pop    %edi
  105a25:	5d                   	pop    %ebp
  105a26:	c3                   	ret    

00105a27 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105a27:	55                   	push   %ebp
  105a28:	89 e5                	mov    %esp,%ebp
  105a2a:	57                   	push   %edi
  105a2b:	56                   	push   %esi
  105a2c:	53                   	push   %ebx
  105a2d:	83 ec 30             	sub    $0x30,%esp
  105a30:	8b 45 08             	mov    0x8(%ebp),%eax
  105a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  105a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105a48:	73 42                	jae    105a8c <memmove+0x65>
  105a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a5f:	c1 e8 02             	shr    $0x2,%eax
  105a62:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a6a:	89 d7                	mov    %edx,%edi
  105a6c:	89 c6                	mov    %eax,%esi
  105a6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105a73:	83 e1 03             	and    $0x3,%ecx
  105a76:	74 02                	je     105a7a <memmove+0x53>
  105a78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a7a:	89 f0                	mov    %esi,%eax
  105a7c:	89 fa                	mov    %edi,%edx
  105a7e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105a81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105a84:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a8a:	eb 36                	jmp    105ac2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a95:	01 c2                	add    %eax,%edx
  105a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a9a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aa0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105aa6:	89 c1                	mov    %eax,%ecx
  105aa8:	89 d8                	mov    %ebx,%eax
  105aaa:	89 d6                	mov    %edx,%esi
  105aac:	89 c7                	mov    %eax,%edi
  105aae:	fd                   	std    
  105aaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ab1:	fc                   	cld    
  105ab2:	89 f8                	mov    %edi,%eax
  105ab4:	89 f2                	mov    %esi,%edx
  105ab6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ab9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105abc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ac2:	83 c4 30             	add    $0x30,%esp
  105ac5:	5b                   	pop    %ebx
  105ac6:	5e                   	pop    %esi
  105ac7:	5f                   	pop    %edi
  105ac8:	5d                   	pop    %ebp
  105ac9:	c3                   	ret    

00105aca <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105aca:	55                   	push   %ebp
  105acb:	89 e5                	mov    %esp,%ebp
  105acd:	57                   	push   %edi
  105ace:	56                   	push   %esi
  105acf:	83 ec 20             	sub    $0x20,%esp
  105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ade:	8b 45 10             	mov    0x10(%ebp),%eax
  105ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ae7:	c1 e8 02             	shr    $0x2,%eax
  105aea:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105af2:	89 d7                	mov    %edx,%edi
  105af4:	89 c6                	mov    %eax,%esi
  105af6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105af8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105afb:	83 e1 03             	and    $0x3,%ecx
  105afe:	74 02                	je     105b02 <memcpy+0x38>
  105b00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b02:	89 f0                	mov    %esi,%eax
  105b04:	89 fa                	mov    %edi,%edx
  105b06:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105b12:	83 c4 20             	add    $0x20,%esp
  105b15:	5e                   	pop    %esi
  105b16:	5f                   	pop    %edi
  105b17:	5d                   	pop    %ebp
  105b18:	c3                   	ret    

00105b19 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105b19:	55                   	push   %ebp
  105b1a:	89 e5                	mov    %esp,%ebp
  105b1c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b28:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105b2b:	eb 30                	jmp    105b5d <memcmp+0x44>
        if (*s1 != *s2) {
  105b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b30:	0f b6 10             	movzbl (%eax),%edx
  105b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b36:	0f b6 00             	movzbl (%eax),%eax
  105b39:	38 c2                	cmp    %al,%dl
  105b3b:	74 18                	je     105b55 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b40:	0f b6 00             	movzbl (%eax),%eax
  105b43:	0f b6 d0             	movzbl %al,%edx
  105b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b49:	0f b6 00             	movzbl (%eax),%eax
  105b4c:	0f b6 c0             	movzbl %al,%eax
  105b4f:	29 c2                	sub    %eax,%edx
  105b51:	89 d0                	mov    %edx,%eax
  105b53:	eb 1a                	jmp    105b6f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105b55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b59:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  105b60:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b63:	89 55 10             	mov    %edx,0x10(%ebp)
  105b66:	85 c0                	test   %eax,%eax
  105b68:	75 c3                	jne    105b2d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b6f:	c9                   	leave  
  105b70:	c3                   	ret    
