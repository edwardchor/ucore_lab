
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 92 59 00 00       	call   c01059e8 <memset>

    cons_init();                // init the console
c0100056:	e8 b7 14 00 00       	call   c0101512 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 5b 10 c0 	movl   $0xc0105b80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 5b 10 c0 	movl   $0xc0105b9c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 14 40 00 00       	call   c0104098 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 f2 15 00 00       	call   c010167b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 6a 17 00 00       	call   c01017f8 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 35 0c 00 00       	call   c0100cc8 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 51 15 00 00       	call   c01015e9 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 3e 0b 00 00       	call   c0100bfa <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 5b 10 c0 	movl   $0xc0105ba1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 5b 10 c0 	movl   $0xc0105baf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 5b 10 c0 	movl   $0xc0105bbd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 5b 10 c0 	movl   $0xc0105bcb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 5b 10 c0 	movl   $0xc0105bd9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 5b 10 c0 	movl   $0xc0105be8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 5c 10 c0 	movl   $0xc0105c08,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 5c 10 c0 	movl   $0xc0105c27,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 44 12 00 00       	call   c010153e <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ca 4e 00 00       	call   c0105201 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 cb 11 00 00       	call   c010153e <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 ab 11 00 00       	call   c010157a <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 5c 10 c0    	movl   $0xc0105c2c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 5c 10 c0 	movl   $0xc0105c2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 50 6e 10 c0 	movl   $0xc0106e50,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 74 16 11 c0 	movl   $0xc0111674,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 75 16 11 c0 	movl   $0xc0111675,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 93 40 11 c0 	movl   $0xc0114093,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 70 51 00 00       	call   c010585c <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 5c 10 c0 	movl   $0xc0105c36,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 5c 10 c0 	movl   $0xc0105c4f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 71 5b 10 	movl   $0xc0105b71,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 5c 10 c0 	movl   $0xc0105c67,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 5c 10 c0 	movl   $0xc0105c7f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 5c 10 c0 	movl   $0xc0105c97,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 5c 10 c0 	movl   $0xc0105cb0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 5c 10 c0 	movl   $0xc0105cda,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 5c 10 c0 	movl   $0xc0105cf6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c01009bd:	5d                   	pop    %ebp
c01009be:	c3                   	ret    

c01009bf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c01009bf:	55                   	push   %ebp
c01009c0:	89 e5                	mov    %esp,%ebp
c01009c2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c01009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009cc:	eb 0c                	jmp    c01009da <parse+0x1b>
            *buf ++ = '\0';
c01009ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01009d1:	8d 50 01             	lea    0x1(%eax),%edx
c01009d4:	89 55 08             	mov    %edx,0x8(%ebp)
c01009d7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009da:	8b 45 08             	mov    0x8(%ebp),%eax
c01009dd:	0f b6 00             	movzbl (%eax),%eax
c01009e0:	84 c0                	test   %al,%al
c01009e2:	74 1d                	je     c0100a01 <parse+0x42>
c01009e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e7:	0f b6 00             	movzbl (%eax),%eax
c01009ea:	0f be c0             	movsbl %al,%eax
c01009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f1:	c7 04 24 88 5d 10 c0 	movl   $0xc0105d88,(%esp)
c01009f8:	e8 2c 4e 00 00       	call   c0105829 <strchr>
c01009fd:	85 c0                	test   %eax,%eax
c01009ff:	75 cd                	jne    c01009ce <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a04:	0f b6 00             	movzbl (%eax),%eax
c0100a07:	84 c0                	test   %al,%al
c0100a09:	75 02                	jne    c0100a0d <parse+0x4e>
            break;
c0100a0b:	eb 67                	jmp    c0100a74 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a0d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a11:	75 14                	jne    c0100a27 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100a1a:	00 
c0100a1b:	c7 04 24 8d 5d 10 c0 	movl   $0xc0105d8d,(%esp)
c0100a22:	e8 15 f9 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a3a:	01 c2                	add    %eax,%edx
c0100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a3f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a41:	eb 04                	jmp    c0100a47 <parse+0x88>
            buf ++;
c0100a43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4a:	0f b6 00             	movzbl (%eax),%eax
c0100a4d:	84 c0                	test   %al,%al
c0100a4f:	74 1d                	je     c0100a6e <parse+0xaf>
c0100a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a54:	0f b6 00             	movzbl (%eax),%eax
c0100a57:	0f be c0             	movsbl %al,%eax
c0100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5e:	c7 04 24 88 5d 10 c0 	movl   $0xc0105d88,(%esp)
c0100a65:	e8 bf 4d 00 00       	call   c0105829 <strchr>
c0100a6a:	85 c0                	test   %eax,%eax
c0100a6c:	74 d5                	je     c0100a43 <parse+0x84>
            buf ++;
        }
    }
c0100a6e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a6f:	e9 66 ff ff ff       	jmp    c01009da <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a7f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a89:	89 04 24             	mov    %eax,(%esp)
c0100a8c:	e8 2e ff ff ff       	call   c01009bf <parse>
c0100a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100a98:	75 0a                	jne    c0100aa4 <runcmd+0x2b>
        return 0;
c0100a9a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100a9f:	e9 85 00 00 00       	jmp    c0100b29 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100aab:	eb 5c                	jmp    c0100b09 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100aad:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ab3:	89 d0                	mov    %edx,%eax
c0100ab5:	01 c0                	add    %eax,%eax
c0100ab7:	01 d0                	add    %edx,%eax
c0100ab9:	c1 e0 02             	shl    $0x2,%eax
c0100abc:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ac1:	8b 00                	mov    (%eax),%eax
c0100ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ac7:	89 04 24             	mov    %eax,(%esp)
c0100aca:	e8 bb 4c 00 00       	call   c010578a <strcmp>
c0100acf:	85 c0                	test   %eax,%eax
c0100ad1:	75 32                	jne    c0100b05 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ad6:	89 d0                	mov    %edx,%eax
c0100ad8:	01 c0                	add    %eax,%eax
c0100ada:	01 d0                	add    %edx,%eax
c0100adc:	c1 e0 02             	shl    $0x2,%eax
c0100adf:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ae4:	8b 40 08             	mov    0x8(%eax),%eax
c0100ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100aea:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100aed:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100af0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100af4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100af7:	83 c2 04             	add    $0x4,%edx
c0100afa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100afe:	89 0c 24             	mov    %ecx,(%esp)
c0100b01:	ff d0                	call   *%eax
c0100b03:	eb 24                	jmp    c0100b29 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0c:	83 f8 02             	cmp    $0x2,%eax
c0100b0f:	76 9c                	jbe    c0100aad <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b11:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 ab 5d 10 c0 	movl   $0xc0105dab,(%esp)
c0100b1f:	e8 18 f8 ff ff       	call   c010033c <cprintf>
    return 0;
c0100b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b29:	c9                   	leave  
c0100b2a:	c3                   	ret    

c0100b2b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100b2b:	55                   	push   %ebp
c0100b2c:	89 e5                	mov    %esp,%ebp
c0100b2e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100b31:	c7 04 24 c4 5d 10 c0 	movl   $0xc0105dc4,(%esp)
c0100b38:	e8 ff f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100b3d:	c7 04 24 ec 5d 10 c0 	movl   $0xc0105dec,(%esp)
c0100b44:	e8 f3 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b4d:	74 0b                	je     c0100b5a <kmonitor+0x2f>
        print_trapframe(tf);
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	89 04 24             	mov    %eax,(%esp)
c0100b55:	e8 ea 0c 00 00       	call   c0101844 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b5a:	c7 04 24 11 5e 10 c0 	movl   $0xc0105e11,(%esp)
c0100b61:	e8 cd f6 ff ff       	call   c0100233 <readline>
c0100b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b6d:	74 18                	je     c0100b87 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b79:	89 04 24             	mov    %eax,(%esp)
c0100b7c:	e8 f8 fe ff ff       	call   c0100a79 <runcmd>
c0100b81:	85 c0                	test   %eax,%eax
c0100b83:	79 02                	jns    c0100b87 <kmonitor+0x5c>
                break;
c0100b85:	eb 02                	jmp    c0100b89 <kmonitor+0x5e>
            }
        }
    }
c0100b87:	eb d1                	jmp    c0100b5a <kmonitor+0x2f>
}
c0100b89:	c9                   	leave  
c0100b8a:	c3                   	ret    

c0100b8b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b8b:	55                   	push   %ebp
c0100b8c:	89 e5                	mov    %esp,%ebp
c0100b8e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b98:	eb 3f                	jmp    c0100bd9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9d:	89 d0                	mov    %edx,%eax
c0100b9f:	01 c0                	add    %eax,%eax
c0100ba1:	01 d0                	add    %edx,%eax
c0100ba3:	c1 e0 02             	shl    $0x2,%eax
c0100ba6:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bab:	8b 48 04             	mov    0x4(%eax),%ecx
c0100bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb1:	89 d0                	mov    %edx,%eax
c0100bb3:	01 c0                	add    %eax,%eax
c0100bb5:	01 d0                	add    %edx,%eax
c0100bb7:	c1 e0 02             	shl    $0x2,%eax
c0100bba:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bbf:	8b 00                	mov    (%eax),%eax
c0100bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc9:	c7 04 24 15 5e 10 c0 	movl   $0xc0105e15,(%esp)
c0100bd0:	e8 67 f7 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdc:	83 f8 02             	cmp    $0x2,%eax
c0100bdf:	76 b9                	jbe    c0100b9a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be6:	c9                   	leave  
c0100be7:	c3                   	ret    

c0100be8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100be8:	55                   	push   %ebp
c0100be9:	89 e5                	mov    %esp,%ebp
c0100beb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100bee:	e8 7d fc ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf8:	c9                   	leave  
c0100bf9:	c3                   	ret    

c0100bfa <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100bfa:	55                   	push   %ebp
c0100bfb:	89 e5                	mov    %esp,%ebp
c0100bfd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c00:	e8 b5 fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c0a:	c9                   	leave  
c0100c0b:	c3                   	ret    

c0100c0c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c0c:	55                   	push   %ebp
c0100c0d:	89 e5                	mov    %esp,%ebp
c0100c0f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100c12:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100c17:	85 c0                	test   %eax,%eax
c0100c19:	74 02                	je     c0100c1d <__panic+0x11>
        goto panic_dead;
c0100c1b:	eb 48                	jmp    c0100c65 <__panic+0x59>
    }
    is_panic = 1;
c0100c1d:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100c24:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100c27:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c30:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3b:	c7 04 24 1e 5e 10 c0 	movl   $0xc0105e1e,(%esp)
c0100c42:	e8 f5 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c51:	89 04 24             	mov    %eax,(%esp)
c0100c54:	e8 b0 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100c59:	c7 04 24 3a 5e 10 c0 	movl   $0xc0105e3a,(%esp)
c0100c60:	e8 d7 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100c65:	e8 85 09 00 00       	call   c01015ef <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100c71:	e8 b5 fe ff ff       	call   c0100b2b <kmonitor>
    }
c0100c76:	eb f2                	jmp    c0100c6a <__panic+0x5e>

c0100c78 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100c78:	55                   	push   %ebp
c0100c79:	89 e5                	mov    %esp,%ebp
c0100c7b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100c7e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100c84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c87:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c92:	c7 04 24 3c 5e 10 c0 	movl   $0xc0105e3c,(%esp)
c0100c99:	e8 9e f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca5:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ca8:	89 04 24             	mov    %eax,(%esp)
c0100cab:	e8 59 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100cb0:	c7 04 24 3a 5e 10 c0 	movl   $0xc0105e3a,(%esp)
c0100cb7:	e8 80 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100cbc:	c9                   	leave  
c0100cbd:	c3                   	ret    

c0100cbe <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100cbe:	55                   	push   %ebp
c0100cbf:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100cc1:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100cc6:	5d                   	pop    %ebp
c0100cc7:	c3                   	ret    

c0100cc8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cc8:	55                   	push   %ebp
c0100cc9:	89 e5                	mov    %esp,%ebp
c0100ccb:	83 ec 28             	sub    $0x28,%esp
c0100cce:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100cd4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100cd8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100cdc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ce0:	ee                   	out    %al,(%dx)
c0100ce1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ce7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100ceb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100cef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100cf3:	ee                   	out    %al,(%dx)
c0100cf4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100cfa:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100cfe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d02:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d06:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d07:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d0e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d11:	c7 04 24 5a 5e 10 c0 	movl   $0xc0105e5a,(%esp)
c0100d18:	e8 1f f6 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d24:	e8 24 09 00 00       	call   c010164d <pic_enable>
}
c0100d29:	c9                   	leave  
c0100d2a:	c3                   	ret    

c0100d2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d2b:	55                   	push   %ebp
c0100d2c:	89 e5                	mov    %esp,%ebp
c0100d2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d31:	9c                   	pushf  
c0100d32:	58                   	pop    %eax
c0100d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d39:	25 00 02 00 00       	and    $0x200,%eax
c0100d3e:	85 c0                	test   %eax,%eax
c0100d40:	74 0c                	je     c0100d4e <__intr_save+0x23>
        intr_disable();
c0100d42:	e8 a8 08 00 00       	call   c01015ef <intr_disable>
        return 1;
c0100d47:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d4c:	eb 05                	jmp    c0100d53 <__intr_save+0x28>
    }
    return 0;
c0100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d53:	c9                   	leave  
c0100d54:	c3                   	ret    

c0100d55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d55:	55                   	push   %ebp
c0100d56:	89 e5                	mov    %esp,%ebp
c0100d58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d5f:	74 05                	je     c0100d66 <__intr_restore+0x11>
        intr_enable();
c0100d61:	e8 83 08 00 00       	call   c01015e9 <intr_enable>
    }
}
c0100d66:	c9                   	leave  
c0100d67:	c3                   	ret    

c0100d68 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d68:	55                   	push   %ebp
c0100d69:	89 e5                	mov    %esp,%ebp
c0100d6b:	83 ec 10             	sub    $0x10,%esp
c0100d6e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d74:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d78:	89 c2                	mov    %eax,%edx
c0100d7a:	ec                   	in     (%dx),%al
c0100d7b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100d7e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d84:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d88:	89 c2                	mov    %eax,%edx
c0100d8a:	ec                   	in     (%dx),%al
c0100d8b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d8e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100d94:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100d98:	89 c2                	mov    %eax,%edx
c0100d9a:	ec                   	in     (%dx),%al
c0100d9b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100d9e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100da4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100da8:	89 c2                	mov    %eax,%edx
c0100daa:	ec                   	in     (%dx),%al
c0100dab:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100dae:	c9                   	leave  
c0100daf:	c3                   	ret    

c0100db0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100db0:	55                   	push   %ebp
c0100db1:	89 e5                	mov    %esp,%ebp
c0100db3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100db6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dc0:	0f b7 00             	movzwl (%eax),%eax
c0100dc3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dca:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd2:	0f b7 00             	movzwl (%eax),%eax
c0100dd5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100dd9:	74 12                	je     c0100ded <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ddb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100de2:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100de9:	b4 03 
c0100deb:	eb 13                	jmp    c0100e00 <cga_init+0x50>
    } else {
        *cp = was;
c0100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100df0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100df4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100df7:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100dfe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e00:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e07:	0f b7 c0             	movzwl %ax,%eax
c0100e0a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100e0e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e12:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e1a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e1b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e22:	83 c0 01             	add    $0x1,%eax
c0100e25:	0f b7 c0             	movzwl %ax,%eax
c0100e28:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e30:	89 c2                	mov    %eax,%edx
c0100e32:	ec                   	in     (%dx),%al
c0100e33:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e3a:	0f b6 c0             	movzbl %al,%eax
c0100e3d:	c1 e0 08             	shl    $0x8,%eax
c0100e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e43:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e4a:	0f b7 c0             	movzwl %ax,%eax
c0100e4d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100e51:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e55:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e59:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e5d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e5e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e65:	83 c0 01             	add    $0x1,%eax
c0100e68:	0f b7 c0             	movzwl %ax,%eax
c0100e6b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e6f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100e73:	89 c2                	mov    %eax,%edx
c0100e75:	ec                   	in     (%dx),%al
c0100e76:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100e79:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e7d:	0f b6 c0             	movzbl %al,%eax
c0100e80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e86:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e8e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100e94:	c9                   	leave  
c0100e95:	c3                   	ret    

c0100e96 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100e96:	55                   	push   %ebp
c0100e97:	89 e5                	mov    %esp,%ebp
c0100e99:	83 ec 48             	sub    $0x48,%esp
c0100e9c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100ea2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eae:	ee                   	out    %al,(%dx)
c0100eaf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100eb5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100eb9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ebd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
c0100ec2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100ec8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
c0100ed5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100edb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100edf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ee7:	ee                   	out    %al,(%dx)
c0100ee8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100eee:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100ef2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ef6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100efa:	ee                   	out    %al,(%dx)
c0100efb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100f01:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100f05:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f09:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f0d:	ee                   	out    %al,(%dx)
c0100f0e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f14:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100f18:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f1c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
c0100f21:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f27:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100f2b:	89 c2                	mov    %eax,%edx
c0100f2d:	ec                   	in     (%dx),%al
c0100f2e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100f31:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f35:	3c ff                	cmp    $0xff,%al
c0100f37:	0f 95 c0             	setne  %al
c0100f3a:	0f b6 c0             	movzbl %al,%eax
c0100f3d:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100f42:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f48:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100f4c:	89 c2                	mov    %eax,%edx
c0100f4e:	ec                   	in     (%dx),%al
c0100f4f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100f52:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100f58:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100f5c:	89 c2                	mov    %eax,%edx
c0100f5e:	ec                   	in     (%dx),%al
c0100f5f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f62:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100f67:	85 c0                	test   %eax,%eax
c0100f69:	74 0c                	je     c0100f77 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0100f6b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f72:	e8 d6 06 00 00       	call   c010164d <pic_enable>
    }
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f86:	eb 09                	jmp    c0100f91 <lpt_putc_sub+0x18>
        delay();
c0100f88:	e8 db fd ff ff       	call   c0100d68 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100f91:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100f97:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f9b:	89 c2                	mov    %eax,%edx
c0100f9d:	ec                   	in     (%dx),%al
c0100f9e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fa1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100fa5:	84 c0                	test   %al,%al
c0100fa7:	78 09                	js     c0100fb2 <lpt_putc_sub+0x39>
c0100fa9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fb0:	7e d6                	jle    c0100f88 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb5:	0f b6 c0             	movzbl %al,%eax
c0100fb8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0100fbe:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0100fe3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0100fe7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100feb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100ff0:	c9                   	leave  
c0100ff1:	c3                   	ret    

c0100ff2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0100ff2:	55                   	push   %ebp
c0100ff3:	89 e5                	mov    %esp,%ebp
c0100ff5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0100ff8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0100ffc:	74 0d                	je     c010100b <lpt_putc+0x19>
        lpt_putc_sub(c);
c0100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101001:	89 04 24             	mov    %eax,(%esp)
c0101004:	e8 70 ff ff ff       	call   c0100f79 <lpt_putc_sub>
c0101009:	eb 24                	jmp    c010102f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c010100b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101012:	e8 62 ff ff ff       	call   c0100f79 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101017:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010101e:	e8 56 ff ff ff       	call   c0100f79 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101023:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010102a:	e8 4a ff ff ff       	call   c0100f79 <lpt_putc_sub>
    }
}
c010102f:	c9                   	leave  
c0101030:	c3                   	ret    

c0101031 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101031:	55                   	push   %ebp
c0101032:	89 e5                	mov    %esp,%ebp
c0101034:	53                   	push   %ebx
c0101035:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101038:	8b 45 08             	mov    0x8(%ebp),%eax
c010103b:	b0 00                	mov    $0x0,%al
c010103d:	85 c0                	test   %eax,%eax
c010103f:	75 07                	jne    c0101048 <cga_putc+0x17>
        c |= 0x0700;
c0101041:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101048:	8b 45 08             	mov    0x8(%ebp),%eax
c010104b:	0f b6 c0             	movzbl %al,%eax
c010104e:	83 f8 0a             	cmp    $0xa,%eax
c0101051:	74 4c                	je     c010109f <cga_putc+0x6e>
c0101053:	83 f8 0d             	cmp    $0xd,%eax
c0101056:	74 57                	je     c01010af <cga_putc+0x7e>
c0101058:	83 f8 08             	cmp    $0x8,%eax
c010105b:	0f 85 88 00 00 00    	jne    c01010e9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101061:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101068:	66 85 c0             	test   %ax,%ax
c010106b:	74 30                	je     c010109d <cga_putc+0x6c>
            crt_pos --;
c010106d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101074:	83 e8 01             	sub    $0x1,%eax
c0101077:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010107d:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101082:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101089:	0f b7 d2             	movzwl %dx,%edx
c010108c:	01 d2                	add    %edx,%edx
c010108e:	01 c2                	add    %eax,%edx
c0101090:	8b 45 08             	mov    0x8(%ebp),%eax
c0101093:	b0 00                	mov    $0x0,%al
c0101095:	83 c8 20             	or     $0x20,%eax
c0101098:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010109b:	eb 72                	jmp    c010110f <cga_putc+0xde>
c010109d:	eb 70                	jmp    c010110f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010109f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010a6:	83 c0 50             	add    $0x50,%eax
c01010a9:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010af:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c01010b6:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c01010bd:	0f b7 c1             	movzwl %cx,%eax
c01010c0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01010c6:	c1 e8 10             	shr    $0x10,%eax
c01010c9:	89 c2                	mov    %eax,%edx
c01010cb:	66 c1 ea 06          	shr    $0x6,%dx
c01010cf:	89 d0                	mov    %edx,%eax
c01010d1:	c1 e0 02             	shl    $0x2,%eax
c01010d4:	01 d0                	add    %edx,%eax
c01010d6:	c1 e0 04             	shl    $0x4,%eax
c01010d9:	29 c1                	sub    %eax,%ecx
c01010db:	89 ca                	mov    %ecx,%edx
c01010dd:	89 d8                	mov    %ebx,%eax
c01010df:	29 d0                	sub    %edx,%eax
c01010e1:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01010e7:	eb 26                	jmp    c010110f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010e9:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01010ef:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010f6:	8d 50 01             	lea    0x1(%eax),%edx
c01010f9:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c0101100:	0f b7 c0             	movzwl %ax,%eax
c0101103:	01 c0                	add    %eax,%eax
c0101105:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	66 89 02             	mov    %ax,(%edx)
        break;
c010110e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010110f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101116:	66 3d cf 07          	cmp    $0x7cf,%ax
c010111a:	76 5b                	jbe    c0101177 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010111c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101121:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101127:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010112c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101133:	00 
c0101134:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101138:	89 04 24             	mov    %eax,(%esp)
c010113b:	e8 e7 48 00 00       	call   c0105a27 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101140:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101147:	eb 15                	jmp    c010115e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101149:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101151:	01 d2                	add    %edx,%edx
c0101153:	01 d0                	add    %edx,%eax
c0101155:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010115a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010115e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101165:	7e e2                	jle    c0101149 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101167:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010116e:	83 e8 50             	sub    $0x50,%eax
c0101171:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101177:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010117e:	0f b7 c0             	movzwl %ax,%eax
c0101181:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101185:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101189:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010118d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101191:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101192:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101199:	66 c1 e8 08          	shr    $0x8,%ax
c010119d:	0f b6 c0             	movzbl %al,%eax
c01011a0:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011a7:	83 c2 01             	add    $0x1,%edx
c01011aa:	0f b7 d2             	movzwl %dx,%edx
c01011ad:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01011b1:	88 45 ed             	mov    %al,-0x13(%ebp)
c01011b4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011bc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011bd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c01011c4:	0f b7 c0             	movzwl %ax,%eax
c01011c7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01011cb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01011cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01011d7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011d8:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011df:	0f b6 c0             	movzbl %al,%eax
c01011e2:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011e9:	83 c2 01             	add    $0x1,%edx
c01011ec:	0f b7 d2             	movzwl %dx,%edx
c01011ef:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01011f3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01011f6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01011fa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01011fe:	ee                   	out    %al,(%dx)
}
c01011ff:	83 c4 34             	add    $0x34,%esp
c0101202:	5b                   	pop    %ebx
c0101203:	5d                   	pop    %ebp
c0101204:	c3                   	ret    

c0101205 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101205:	55                   	push   %ebp
c0101206:	89 e5                	mov    %esp,%ebp
c0101208:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101212:	eb 09                	jmp    c010121d <serial_putc_sub+0x18>
        delay();
c0101214:	e8 4f fb ff ff       	call   c0100d68 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101219:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010121d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101223:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101227:	89 c2                	mov    %eax,%edx
c0101229:	ec                   	in     (%dx),%al
c010122a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010122d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101231:	0f b6 c0             	movzbl %al,%eax
c0101234:	83 e0 20             	and    $0x20,%eax
c0101237:	85 c0                	test   %eax,%eax
c0101239:	75 09                	jne    c0101244 <serial_putc_sub+0x3f>
c010123b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101242:	7e d0                	jle    c0101214 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101244:	8b 45 08             	mov    0x8(%ebp),%eax
c0101247:	0f b6 c0             	movzbl %al,%eax
c010124a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101250:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101253:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101257:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010125b:	ee                   	out    %al,(%dx)
}
c010125c:	c9                   	leave  
c010125d:	c3                   	ret    

c010125e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010125e:	55                   	push   %ebp
c010125f:	89 e5                	mov    %esp,%ebp
c0101261:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101264:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101268:	74 0d                	je     c0101277 <serial_putc+0x19>
        serial_putc_sub(c);
c010126a:	8b 45 08             	mov    0x8(%ebp),%eax
c010126d:	89 04 24             	mov    %eax,(%esp)
c0101270:	e8 90 ff ff ff       	call   c0101205 <serial_putc_sub>
c0101275:	eb 24                	jmp    c010129b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101277:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010127e:	e8 82 ff ff ff       	call   c0101205 <serial_putc_sub>
        serial_putc_sub(' ');
c0101283:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010128a:	e8 76 ff ff ff       	call   c0101205 <serial_putc_sub>
        serial_putc_sub('\b');
c010128f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101296:	e8 6a ff ff ff       	call   c0101205 <serial_putc_sub>
    }
}
c010129b:	c9                   	leave  
c010129c:	c3                   	ret    

c010129d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010129d:	55                   	push   %ebp
c010129e:	89 e5                	mov    %esp,%ebp
c01012a0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012a3:	eb 33                	jmp    c01012d8 <cons_intr+0x3b>
        if (c != 0) {
c01012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012a9:	74 2d                	je     c01012d8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012ab:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012b0:	8d 50 01             	lea    0x1(%eax),%edx
c01012b3:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c01012b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012bc:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012c2:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012c7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012cc:	75 0a                	jne    c01012d8 <cons_intr+0x3b>
                cons.wpos = 0;
c01012ce:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01012d5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01012d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012db:	ff d0                	call   *%eax
c01012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012e4:	75 bf                	jne    c01012a5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01012e6:	c9                   	leave  
c01012e7:	c3                   	ret    

c01012e8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012e8:	55                   	push   %ebp
c01012e9:	89 e5                	mov    %esp,%ebp
c01012eb:	83 ec 10             	sub    $0x10,%esp
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 01             	and    $0x1,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 07                	jne    c0101313 <serial_proc_data+0x2b>
        return -1;
c010130c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101311:	eb 2a                	jmp    c010133d <serial_proc_data+0x55>
c0101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101319:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010131d:	89 c2                	mov    %eax,%edx
c010131f:	ec                   	in     (%dx),%al
c0101320:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101327:	0f b6 c0             	movzbl %al,%eax
c010132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010132d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101331:	75 07                	jne    c010133a <serial_proc_data+0x52>
        c = '\b';
c0101333:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010133a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010133d:	c9                   	leave  
c010133e:	c3                   	ret    

c010133f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010133f:	55                   	push   %ebp
c0101340:	89 e5                	mov    %esp,%ebp
c0101342:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101345:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010134a:	85 c0                	test   %eax,%eax
c010134c:	74 0c                	je     c010135a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010134e:	c7 04 24 e8 12 10 c0 	movl   $0xc01012e8,(%esp)
c0101355:	e8 43 ff ff ff       	call   c010129d <cons_intr>
    }
}
c010135a:	c9                   	leave  
c010135b:	c3                   	ret    

c010135c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010135c:	55                   	push   %ebp
c010135d:	89 e5                	mov    %esp,%ebp
c010135f:	83 ec 38             	sub    $0x38,%esp
c0101362:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101368:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010136c:	89 c2                	mov    %eax,%edx
c010136e:	ec                   	in     (%dx),%al
c010136f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101372:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101376:	0f b6 c0             	movzbl %al,%eax
c0101379:	83 e0 01             	and    $0x1,%eax
c010137c:	85 c0                	test   %eax,%eax
c010137e:	75 0a                	jne    c010138a <kbd_proc_data+0x2e>
        return -1;
c0101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101385:	e9 59 01 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
c010138a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101390:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101394:	89 c2                	mov    %eax,%edx
c0101396:	ec                   	in     (%dx),%al
c0101397:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010139a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010139e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013a1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013a5:	75 17                	jne    c01013be <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c01013a7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013ac:	83 c8 40             	or     $0x40,%eax
c01013af:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01013b4:	b8 00 00 00 00       	mov    $0x0,%eax
c01013b9:	e9 25 01 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01013be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013c2:	84 c0                	test   %al,%al
c01013c4:	79 47                	jns    c010140d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013c6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013cb:	83 e0 40             	and    $0x40,%eax
c01013ce:	85 c0                	test   %eax,%eax
c01013d0:	75 09                	jne    c01013db <kbd_proc_data+0x7f>
c01013d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d6:	83 e0 7f             	and    $0x7f,%eax
c01013d9:	eb 04                	jmp    c01013df <kbd_proc_data+0x83>
c01013db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013df:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e6:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01013ed:	83 c8 40             	or     $0x40,%eax
c01013f0:	0f b6 c0             	movzbl %al,%eax
c01013f3:	f7 d0                	not    %eax
c01013f5:	89 c2                	mov    %eax,%edx
c01013f7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013fc:	21 d0                	and    %edx,%eax
c01013fe:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101403:	b8 00 00 00 00       	mov    $0x0,%eax
c0101408:	e9 d6 00 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010140d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101412:	83 e0 40             	and    $0x40,%eax
c0101415:	85 c0                	test   %eax,%eax
c0101417:	74 11                	je     c010142a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101419:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010141d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101422:	83 e0 bf             	and    $0xffffffbf,%eax
c0101425:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c010142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010142e:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101435:	0f b6 d0             	movzbl %al,%edx
c0101438:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010143d:	09 d0                	or     %edx,%eax
c010143f:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101448:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010144f:	0f b6 d0             	movzbl %al,%edx
c0101452:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101457:	31 d0                	xor    %edx,%eax
c0101459:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010145e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101463:	83 e0 03             	and    $0x3,%eax
c0101466:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010146d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101471:	01 d0                	add    %edx,%eax
c0101473:	0f b6 00             	movzbl (%eax),%eax
c0101476:	0f b6 c0             	movzbl %al,%eax
c0101479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010147c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101481:	83 e0 08             	and    $0x8,%eax
c0101484:	85 c0                	test   %eax,%eax
c0101486:	74 22                	je     c01014aa <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101488:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010148c:	7e 0c                	jle    c010149a <kbd_proc_data+0x13e>
c010148e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101492:	7f 06                	jg     c010149a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101494:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101498:	eb 10                	jmp    c01014aa <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010149a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010149e:	7e 0a                	jle    c01014aa <kbd_proc_data+0x14e>
c01014a0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014a4:	7f 04                	jg     c01014aa <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c01014a6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014aa:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014af:	f7 d0                	not    %eax
c01014b1:	83 e0 06             	and    $0x6,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	75 28                	jne    c01014e0 <kbd_proc_data+0x184>
c01014b8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014bf:	75 1f                	jne    c01014e0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01014c1:	c7 04 24 75 5e 10 c0 	movl   $0xc0105e75,(%esp)
c01014c8:	e8 6f ee ff ff       	call   c010033c <cprintf>
c01014cd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01014d3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014d7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014db:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014df:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014e3:	c9                   	leave  
c01014e4:	c3                   	ret    

c01014e5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014e5:	55                   	push   %ebp
c01014e6:	89 e5                	mov    %esp,%ebp
c01014e8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014eb:	c7 04 24 5c 13 10 c0 	movl   $0xc010135c,(%esp)
c01014f2:	e8 a6 fd ff ff       	call   c010129d <cons_intr>
}
c01014f7:	c9                   	leave  
c01014f8:	c3                   	ret    

c01014f9 <kbd_init>:

static void
kbd_init(void) {
c01014f9:	55                   	push   %ebp
c01014fa:	89 e5                	mov    %esp,%ebp
c01014fc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01014ff:	e8 e1 ff ff ff       	call   c01014e5 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010150b:	e8 3d 01 00 00       	call   c010164d <pic_enable>
}
c0101510:	c9                   	leave  
c0101511:	c3                   	ret    

c0101512 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101512:	55                   	push   %ebp
c0101513:	89 e5                	mov    %esp,%ebp
c0101515:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101518:	e8 93 f8 ff ff       	call   c0100db0 <cga_init>
    serial_init();
c010151d:	e8 74 f9 ff ff       	call   c0100e96 <serial_init>
    kbd_init();
c0101522:	e8 d2 ff ff ff       	call   c01014f9 <kbd_init>
    if (!serial_exists) {
c0101527:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010152c:	85 c0                	test   %eax,%eax
c010152e:	75 0c                	jne    c010153c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101530:	c7 04 24 81 5e 10 c0 	movl   $0xc0105e81,(%esp)
c0101537:	e8 00 ee ff ff       	call   c010033c <cprintf>
    }
}
c010153c:	c9                   	leave  
c010153d:	c3                   	ret    

c010153e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010153e:	55                   	push   %ebp
c010153f:	89 e5                	mov    %esp,%ebp
c0101541:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101544:	e8 e2 f7 ff ff       	call   c0100d2b <__intr_save>
c0101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010154c:	8b 45 08             	mov    0x8(%ebp),%eax
c010154f:	89 04 24             	mov    %eax,(%esp)
c0101552:	e8 9b fa ff ff       	call   c0100ff2 <lpt_putc>
        cga_putc(c);
c0101557:	8b 45 08             	mov    0x8(%ebp),%eax
c010155a:	89 04 24             	mov    %eax,(%esp)
c010155d:	e8 cf fa ff ff       	call   c0101031 <cga_putc>
        serial_putc(c);
c0101562:	8b 45 08             	mov    0x8(%ebp),%eax
c0101565:	89 04 24             	mov    %eax,(%esp)
c0101568:	e8 f1 fc ff ff       	call   c010125e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101570:	89 04 24             	mov    %eax,(%esp)
c0101573:	e8 dd f7 ff ff       	call   c0100d55 <__intr_restore>
}
c0101578:	c9                   	leave  
c0101579:	c3                   	ret    

c010157a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010157a:	55                   	push   %ebp
c010157b:	89 e5                	mov    %esp,%ebp
c010157d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101587:	e8 9f f7 ff ff       	call   c0100d2b <__intr_save>
c010158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010158f:	e8 ab fd ff ff       	call   c010133f <serial_intr>
        kbd_intr();
c0101594:	e8 4c ff ff ff       	call   c01014e5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101599:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010159f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01015a4:	39 c2                	cmp    %eax,%edx
c01015a6:	74 31                	je     c01015d9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015a8:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015ad:	8d 50 01             	lea    0x1(%eax),%edx
c01015b0:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c01015b6:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c01015bd:	0f b6 c0             	movzbl %al,%eax
c01015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015c3:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015c8:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015cd:	75 0a                	jne    c01015d9 <cons_getc+0x5f>
                cons.rpos = 0;
c01015cf:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01015d6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015dc:	89 04 24             	mov    %eax,(%esp)
c01015df:	e8 71 f7 ff ff       	call   c0100d55 <__intr_restore>
    return c;
c01015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015e7:	c9                   	leave  
c01015e8:	c3                   	ret    

c01015e9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01015e9:	55                   	push   %ebp
c01015ea:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01015ec:	fb                   	sti    
    sti();
}
c01015ed:	5d                   	pop    %ebp
c01015ee:	c3                   	ret    

c01015ef <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01015ef:	55                   	push   %ebp
c01015f0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01015f2:	fa                   	cli    
    cli();
}
c01015f3:	5d                   	pop    %ebp
c01015f4:	c3                   	ret    

c01015f5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01015f5:	55                   	push   %ebp
c01015f6:	89 e5                	mov    %esp,%ebp
c01015f8:	83 ec 14             	sub    $0x14,%esp
c01015fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01015fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101602:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101606:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c010160c:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	74 36                	je     c010164b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101615:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101619:	0f b6 c0             	movzbl %al,%eax
c010161c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101622:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101625:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101629:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010162d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010162e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101632:	66 c1 e8 08          	shr    $0x8,%ax
c0101636:	0f b6 c0             	movzbl %al,%eax
c0101639:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010163f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101642:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101646:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010164a:	ee                   	out    %al,(%dx)
    }
}
c010164b:	c9                   	leave  
c010164c:	c3                   	ret    

c010164d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010164d:	55                   	push   %ebp
c010164e:	89 e5                	mov    %esp,%ebp
c0101650:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101653:	8b 45 08             	mov    0x8(%ebp),%eax
c0101656:	ba 01 00 00 00       	mov    $0x1,%edx
c010165b:	89 c1                	mov    %eax,%ecx
c010165d:	d3 e2                	shl    %cl,%edx
c010165f:	89 d0                	mov    %edx,%eax
c0101661:	f7 d0                	not    %eax
c0101663:	89 c2                	mov    %eax,%edx
c0101665:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010166c:	21 d0                	and    %edx,%eax
c010166e:	0f b7 c0             	movzwl %ax,%eax
c0101671:	89 04 24             	mov    %eax,(%esp)
c0101674:	e8 7c ff ff ff       	call   c01015f5 <pic_setmask>
}
c0101679:	c9                   	leave  
c010167a:	c3                   	ret    

c010167b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010167b:	55                   	push   %ebp
c010167c:	89 e5                	mov    %esp,%ebp
c010167e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101681:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101688:	00 00 00 
c010168b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101691:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101695:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101699:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010169d:	ee                   	out    %al,(%dx)
c010169e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016a4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01016a8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016ac:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016b0:	ee                   	out    %al,(%dx)
c01016b1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01016b7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01016bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01016bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01016c3:	ee                   	out    %al,(%dx)
c01016c4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01016ca:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01016ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01016d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01016d6:	ee                   	out    %al,(%dx)
c01016d7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01016dd:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01016e1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01016e5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01016e9:	ee                   	out    %al,(%dx)
c01016ea:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01016f0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01016f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01016f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01016fc:	ee                   	out    %al,(%dx)
c01016fd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101703:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101707:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010170b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010170f:	ee                   	out    %al,(%dx)
c0101710:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101716:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010171a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010171e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101722:	ee                   	out    %al,(%dx)
c0101723:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101729:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010172d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101731:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101735:	ee                   	out    %al,(%dx)
c0101736:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010173c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101740:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101744:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101748:	ee                   	out    %al,(%dx)
c0101749:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010174f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101753:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101757:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010175b:	ee                   	out    %al,(%dx)
c010175c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101762:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101766:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010176a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
c010176f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101775:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
c0101782:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101788:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010178c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101790:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101795:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010179c:	66 83 f8 ff          	cmp    $0xffff,%ax
c01017a0:	74 12                	je     c01017b4 <pic_init+0x139>
        pic_setmask(irq_mask);
c01017a2:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01017a9:	0f b7 c0             	movzwl %ax,%eax
c01017ac:	89 04 24             	mov    %eax,(%esp)
c01017af:	e8 41 fe ff ff       	call   c01015f5 <pic_setmask>
    }
}
c01017b4:	c9                   	leave  
c01017b5:	c3                   	ret    

c01017b6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01017b6:	55                   	push   %ebp
c01017b7:	89 e5                	mov    %esp,%ebp
c01017b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01017bc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01017c3:	00 
c01017c4:	c7 04 24 a0 5e 10 c0 	movl   $0xc0105ea0,(%esp)
c01017cb:	e8 6c eb ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01017d0:	c7 04 24 aa 5e 10 c0 	movl   $0xc0105eaa,(%esp)
c01017d7:	e8 60 eb ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c01017dc:	c7 44 24 08 b8 5e 10 	movl   $0xc0105eb8,0x8(%esp)
c01017e3:	c0 
c01017e4:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01017eb:	00 
c01017ec:	c7 04 24 ce 5e 10 c0 	movl   $0xc0105ece,(%esp)
c01017f3:	e8 14 f4 ff ff       	call   c0100c0c <__panic>

c01017f8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01017f8:	55                   	push   %ebp
c01017f9:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01017fb:	5d                   	pop    %ebp
c01017fc:	c3                   	ret    

c01017fd <trapname>:

static const char *
trapname(int trapno) {
c01017fd:	55                   	push   %ebp
c01017fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101800:	8b 45 08             	mov    0x8(%ebp),%eax
c0101803:	83 f8 13             	cmp    $0x13,%eax
c0101806:	77 0c                	ja     c0101814 <trapname+0x17>
        return excnames[trapno];
c0101808:	8b 45 08             	mov    0x8(%ebp),%eax
c010180b:	8b 04 85 20 62 10 c0 	mov    -0x3fef9de0(,%eax,4),%eax
c0101812:	eb 18                	jmp    c010182c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101814:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101818:	7e 0d                	jle    c0101827 <trapname+0x2a>
c010181a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010181e:	7f 07                	jg     c0101827 <trapname+0x2a>
        return "Hardware Interrupt";
c0101820:	b8 df 5e 10 c0       	mov    $0xc0105edf,%eax
c0101825:	eb 05                	jmp    c010182c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101827:	b8 f2 5e 10 c0       	mov    $0xc0105ef2,%eax
}
c010182c:	5d                   	pop    %ebp
c010182d:	c3                   	ret    

c010182e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010182e:	55                   	push   %ebp
c010182f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101831:	8b 45 08             	mov    0x8(%ebp),%eax
c0101834:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101838:	66 83 f8 08          	cmp    $0x8,%ax
c010183c:	0f 94 c0             	sete   %al
c010183f:	0f b6 c0             	movzbl %al,%eax
}
c0101842:	5d                   	pop    %ebp
c0101843:	c3                   	ret    

c0101844 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101844:	55                   	push   %ebp
c0101845:	89 e5                	mov    %esp,%ebp
c0101847:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010184a:	8b 45 08             	mov    0x8(%ebp),%eax
c010184d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101851:	c7 04 24 33 5f 10 c0 	movl   $0xc0105f33,(%esp)
c0101858:	e8 df ea ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c010185d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101860:	89 04 24             	mov    %eax,(%esp)
c0101863:	e8 a1 01 00 00       	call   c0101a09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101868:	8b 45 08             	mov    0x8(%ebp),%eax
c010186b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010186f:	0f b7 c0             	movzwl %ax,%eax
c0101872:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101876:	c7 04 24 44 5f 10 c0 	movl   $0xc0105f44,(%esp)
c010187d:	e8 ba ea ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101882:	8b 45 08             	mov    0x8(%ebp),%eax
c0101885:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101889:	0f b7 c0             	movzwl %ax,%eax
c010188c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101890:	c7 04 24 57 5f 10 c0 	movl   $0xc0105f57,(%esp)
c0101897:	e8 a0 ea ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010189c:	8b 45 08             	mov    0x8(%ebp),%eax
c010189f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01018a3:	0f b7 c0             	movzwl %ax,%eax
c01018a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018aa:	c7 04 24 6a 5f 10 c0 	movl   $0xc0105f6a,(%esp)
c01018b1:	e8 86 ea ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01018b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01018bd:	0f b7 c0             	movzwl %ax,%eax
c01018c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018c4:	c7 04 24 7d 5f 10 c0 	movl   $0xc0105f7d,(%esp)
c01018cb:	e8 6c ea ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01018d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01018d3:	8b 40 30             	mov    0x30(%eax),%eax
c01018d6:	89 04 24             	mov    %eax,(%esp)
c01018d9:	e8 1f ff ff ff       	call   c01017fd <trapname>
c01018de:	8b 55 08             	mov    0x8(%ebp),%edx
c01018e1:	8b 52 30             	mov    0x30(%edx),%edx
c01018e4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01018e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01018ec:	c7 04 24 90 5f 10 c0 	movl   $0xc0105f90,(%esp)
c01018f3:	e8 44 ea ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01018f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01018fb:	8b 40 34             	mov    0x34(%eax),%eax
c01018fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101902:	c7 04 24 a2 5f 10 c0 	movl   $0xc0105fa2,(%esp)
c0101909:	e8 2e ea ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010190e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101911:	8b 40 38             	mov    0x38(%eax),%eax
c0101914:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101918:	c7 04 24 b1 5f 10 c0 	movl   $0xc0105fb1,(%esp)
c010191f:	e8 18 ea ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101924:	8b 45 08             	mov    0x8(%ebp),%eax
c0101927:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010192b:	0f b7 c0             	movzwl %ax,%eax
c010192e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101932:	c7 04 24 c0 5f 10 c0 	movl   $0xc0105fc0,(%esp)
c0101939:	e8 fe e9 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010193e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101941:	8b 40 40             	mov    0x40(%eax),%eax
c0101944:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101948:	c7 04 24 d3 5f 10 c0 	movl   $0xc0105fd3,(%esp)
c010194f:	e8 e8 e9 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010195b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101962:	eb 3e                	jmp    c01019a2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101964:	8b 45 08             	mov    0x8(%ebp),%eax
c0101967:	8b 50 40             	mov    0x40(%eax),%edx
c010196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010196d:	21 d0                	and    %edx,%eax
c010196f:	85 c0                	test   %eax,%eax
c0101971:	74 28                	je     c010199b <print_trapframe+0x157>
c0101973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101976:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c010197d:	85 c0                	test   %eax,%eax
c010197f:	74 1a                	je     c010199b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101981:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101984:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c010198b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010198f:	c7 04 24 e2 5f 10 c0 	movl   $0xc0105fe2,(%esp)
c0101996:	e8 a1 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010199b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010199f:	d1 65 f0             	shll   -0x10(%ebp)
c01019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019a5:	83 f8 17             	cmp    $0x17,%eax
c01019a8:	76 ba                	jbe    c0101964 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01019aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ad:	8b 40 40             	mov    0x40(%eax),%eax
c01019b0:	25 00 30 00 00       	and    $0x3000,%eax
c01019b5:	c1 e8 0c             	shr    $0xc,%eax
c01019b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019bc:	c7 04 24 e6 5f 10 c0 	movl   $0xc0105fe6,(%esp)
c01019c3:	e8 74 e9 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c01019c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cb:	89 04 24             	mov    %eax,(%esp)
c01019ce:	e8 5b fe ff ff       	call   c010182e <trap_in_kernel>
c01019d3:	85 c0                	test   %eax,%eax
c01019d5:	75 30                	jne    c0101a07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01019d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019da:	8b 40 44             	mov    0x44(%eax),%eax
c01019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e1:	c7 04 24 ef 5f 10 c0 	movl   $0xc0105fef,(%esp)
c01019e8:	e8 4f e9 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01019ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01019f4:	0f b7 c0             	movzwl %ax,%eax
c01019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fb:	c7 04 24 fe 5f 10 c0 	movl   $0xc0105ffe,(%esp)
c0101a02:	e8 35 e9 ff ff       	call   c010033c <cprintf>
    }
}
c0101a07:	c9                   	leave  
c0101a08:	c3                   	ret    

c0101a09 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101a09:	55                   	push   %ebp
c0101a0a:	89 e5                	mov    %esp,%ebp
c0101a0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a12:	8b 00                	mov    (%eax),%eax
c0101a14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a18:	c7 04 24 11 60 10 c0 	movl   $0xc0106011,(%esp)
c0101a1f:	e8 18 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a27:	8b 40 04             	mov    0x4(%eax),%eax
c0101a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a2e:	c7 04 24 20 60 10 c0 	movl   $0xc0106020,(%esp)
c0101a35:	e8 02 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3d:	8b 40 08             	mov    0x8(%eax),%eax
c0101a40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a44:	c7 04 24 2f 60 10 c0 	movl   $0xc010602f,(%esp)
c0101a4b:	e8 ec e8 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a53:	8b 40 0c             	mov    0xc(%eax),%eax
c0101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5a:	c7 04 24 3e 60 10 c0 	movl   $0xc010603e,(%esp)
c0101a61:	e8 d6 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a69:	8b 40 10             	mov    0x10(%eax),%eax
c0101a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a70:	c7 04 24 4d 60 10 c0 	movl   $0xc010604d,(%esp)
c0101a77:	e8 c0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7f:	8b 40 14             	mov    0x14(%eax),%eax
c0101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a86:	c7 04 24 5c 60 10 c0 	movl   $0xc010605c,(%esp)
c0101a8d:	e8 aa e8 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a95:	8b 40 18             	mov    0x18(%eax),%eax
c0101a98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9c:	c7 04 24 6b 60 10 c0 	movl   $0xc010606b,(%esp)
c0101aa3:	e8 94 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aab:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab2:	c7 04 24 7a 60 10 c0 	movl   $0xc010607a,(%esp)
c0101ab9:	e8 7e e8 ff ff       	call   c010033c <cprintf>
}
c0101abe:	c9                   	leave  
c0101abf:	c3                   	ret    

c0101ac0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ac0:	55                   	push   %ebp
c0101ac1:	89 e5                	mov    %esp,%ebp
c0101ac3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac9:	8b 40 30             	mov    0x30(%eax),%eax
c0101acc:	83 f8 2f             	cmp    $0x2f,%eax
c0101acf:	77 1e                	ja     c0101aef <trap_dispatch+0x2f>
c0101ad1:	83 f8 2e             	cmp    $0x2e,%eax
c0101ad4:	0f 83 bf 00 00 00    	jae    c0101b99 <trap_dispatch+0xd9>
c0101ada:	83 f8 21             	cmp    $0x21,%eax
c0101add:	74 40                	je     c0101b1f <trap_dispatch+0x5f>
c0101adf:	83 f8 24             	cmp    $0x24,%eax
c0101ae2:	74 15                	je     c0101af9 <trap_dispatch+0x39>
c0101ae4:	83 f8 20             	cmp    $0x20,%eax
c0101ae7:	0f 84 af 00 00 00    	je     c0101b9c <trap_dispatch+0xdc>
c0101aed:	eb 72                	jmp    c0101b61 <trap_dispatch+0xa1>
c0101aef:	83 e8 78             	sub    $0x78,%eax
c0101af2:	83 f8 01             	cmp    $0x1,%eax
c0101af5:	77 6a                	ja     c0101b61 <trap_dispatch+0xa1>
c0101af7:	eb 4c                	jmp    c0101b45 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101af9:	e8 7c fa ff ff       	call   c010157a <cons_getc>
c0101afe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101b01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101b05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101b09:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b11:	c7 04 24 89 60 10 c0 	movl   $0xc0106089,(%esp)
c0101b18:	e8 1f e8 ff ff       	call   c010033c <cprintf>
        break;
c0101b1d:	eb 7e                	jmp    c0101b9d <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101b1f:	e8 56 fa ff ff       	call   c010157a <cons_getc>
c0101b24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101b27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101b2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101b2f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b37:	c7 04 24 9b 60 10 c0 	movl   $0xc010609b,(%esp)
c0101b3e:	e8 f9 e7 ff ff       	call   c010033c <cprintf>
        break;
c0101b43:	eb 58                	jmp    c0101b9d <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101b45:	c7 44 24 08 aa 60 10 	movl   $0xc01060aa,0x8(%esp)
c0101b4c:	c0 
c0101b4d:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0101b54:	00 
c0101b55:	c7 04 24 ce 5e 10 c0 	movl   $0xc0105ece,(%esp)
c0101b5c:	e8 ab f0 ff ff       	call   c0100c0c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b68:	0f b7 c0             	movzwl %ax,%eax
c0101b6b:	83 e0 03             	and    $0x3,%eax
c0101b6e:	85 c0                	test   %eax,%eax
c0101b70:	75 2b                	jne    c0101b9d <trap_dispatch+0xdd>
            print_trapframe(tf);
c0101b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b75:	89 04 24             	mov    %eax,(%esp)
c0101b78:	e8 c7 fc ff ff       	call   c0101844 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101b7d:	c7 44 24 08 ba 60 10 	movl   $0xc01060ba,0x8(%esp)
c0101b84:	c0 
c0101b85:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101b8c:	00 
c0101b8d:	c7 04 24 ce 5e 10 c0 	movl   $0xc0105ece,(%esp)
c0101b94:	e8 73 f0 ff ff       	call   c0100c0c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101b99:	90                   	nop
c0101b9a:	eb 01                	jmp    c0101b9d <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101b9c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101b9d:	c9                   	leave  
c0101b9e:	c3                   	ret    

c0101b9f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101b9f:	55                   	push   %ebp
c0101ba0:	89 e5                	mov    %esp,%ebp
c0101ba2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	89 04 24             	mov    %eax,(%esp)
c0101bab:	e8 10 ff ff ff       	call   c0101ac0 <trap_dispatch>
}
c0101bb0:	c9                   	leave  
c0101bb1:	c3                   	ret    

c0101bb2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101bb2:	1e                   	push   %ds
    pushl %es
c0101bb3:	06                   	push   %es
    pushl %fs
c0101bb4:	0f a0                	push   %fs
    pushl %gs
c0101bb6:	0f a8                	push   %gs
    pushal
c0101bb8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101bb9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101bbe:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101bc0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101bc2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101bc3:	e8 d7 ff ff ff       	call   c0101b9f <trap>

    # pop the pushed stack pointer
    popl %esp
c0101bc8:	5c                   	pop    %esp

c0101bc9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101bc9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101bca:	0f a9                	pop    %gs
    popl %fs
c0101bcc:	0f a1                	pop    %fs
    popl %es
c0101bce:	07                   	pop    %es
    popl %ds
c0101bcf:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101bd0:	83 c4 08             	add    $0x8,%esp
    iret
c0101bd3:	cf                   	iret   

c0101bd4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101bd4:	6a 00                	push   $0x0
  pushl $0
c0101bd6:	6a 00                	push   $0x0
  jmp __alltraps
c0101bd8:	e9 d5 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101bdd <vector1>:
.globl vector1
vector1:
  pushl $0
c0101bdd:	6a 00                	push   $0x0
  pushl $1
c0101bdf:	6a 01                	push   $0x1
  jmp __alltraps
c0101be1:	e9 cc ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101be6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101be6:	6a 00                	push   $0x0
  pushl $2
c0101be8:	6a 02                	push   $0x2
  jmp __alltraps
c0101bea:	e9 c3 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101bef <vector3>:
.globl vector3
vector3:
  pushl $0
c0101bef:	6a 00                	push   $0x0
  pushl $3
c0101bf1:	6a 03                	push   $0x3
  jmp __alltraps
c0101bf3:	e9 ba ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101bf8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101bf8:	6a 00                	push   $0x0
  pushl $4
c0101bfa:	6a 04                	push   $0x4
  jmp __alltraps
c0101bfc:	e9 b1 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c01 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101c01:	6a 00                	push   $0x0
  pushl $5
c0101c03:	6a 05                	push   $0x5
  jmp __alltraps
c0101c05:	e9 a8 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c0a <vector6>:
.globl vector6
vector6:
  pushl $0
c0101c0a:	6a 00                	push   $0x0
  pushl $6
c0101c0c:	6a 06                	push   $0x6
  jmp __alltraps
c0101c0e:	e9 9f ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c13 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101c13:	6a 00                	push   $0x0
  pushl $7
c0101c15:	6a 07                	push   $0x7
  jmp __alltraps
c0101c17:	e9 96 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c1c <vector8>:
.globl vector8
vector8:
  pushl $8
c0101c1c:	6a 08                	push   $0x8
  jmp __alltraps
c0101c1e:	e9 8f ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c23 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101c23:	6a 09                	push   $0x9
  jmp __alltraps
c0101c25:	e9 88 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c2a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101c2a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101c2c:	e9 81 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c31 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101c31:	6a 0b                	push   $0xb
  jmp __alltraps
c0101c33:	e9 7a ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c38 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101c38:	6a 0c                	push   $0xc
  jmp __alltraps
c0101c3a:	e9 73 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c3f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101c3f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101c41:	e9 6c ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c46 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101c46:	6a 0e                	push   $0xe
  jmp __alltraps
c0101c48:	e9 65 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c4d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101c4d:	6a 00                	push   $0x0
  pushl $15
c0101c4f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101c51:	e9 5c ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c56 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101c56:	6a 00                	push   $0x0
  pushl $16
c0101c58:	6a 10                	push   $0x10
  jmp __alltraps
c0101c5a:	e9 53 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c5f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101c5f:	6a 11                	push   $0x11
  jmp __alltraps
c0101c61:	e9 4c ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c66 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101c66:	6a 00                	push   $0x0
  pushl $18
c0101c68:	6a 12                	push   $0x12
  jmp __alltraps
c0101c6a:	e9 43 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c6f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101c6f:	6a 00                	push   $0x0
  pushl $19
c0101c71:	6a 13                	push   $0x13
  jmp __alltraps
c0101c73:	e9 3a ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c78 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101c78:	6a 00                	push   $0x0
  pushl $20
c0101c7a:	6a 14                	push   $0x14
  jmp __alltraps
c0101c7c:	e9 31 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c81 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101c81:	6a 00                	push   $0x0
  pushl $21
c0101c83:	6a 15                	push   $0x15
  jmp __alltraps
c0101c85:	e9 28 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c8a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101c8a:	6a 00                	push   $0x0
  pushl $22
c0101c8c:	6a 16                	push   $0x16
  jmp __alltraps
c0101c8e:	e9 1f ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c93 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101c93:	6a 00                	push   $0x0
  pushl $23
c0101c95:	6a 17                	push   $0x17
  jmp __alltraps
c0101c97:	e9 16 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101c9c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101c9c:	6a 00                	push   $0x0
  pushl $24
c0101c9e:	6a 18                	push   $0x18
  jmp __alltraps
c0101ca0:	e9 0d ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101ca5 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ca5:	6a 00                	push   $0x0
  pushl $25
c0101ca7:	6a 19                	push   $0x19
  jmp __alltraps
c0101ca9:	e9 04 ff ff ff       	jmp    c0101bb2 <__alltraps>

c0101cae <vector26>:
.globl vector26
vector26:
  pushl $0
c0101cae:	6a 00                	push   $0x0
  pushl $26
c0101cb0:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101cb2:	e9 fb fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cb7 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101cb7:	6a 00                	push   $0x0
  pushl $27
c0101cb9:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101cbb:	e9 f2 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cc0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101cc0:	6a 00                	push   $0x0
  pushl $28
c0101cc2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101cc4:	e9 e9 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cc9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101cc9:	6a 00                	push   $0x0
  pushl $29
c0101ccb:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ccd:	e9 e0 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cd2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101cd2:	6a 00                	push   $0x0
  pushl $30
c0101cd4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101cd6:	e9 d7 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cdb <vector31>:
.globl vector31
vector31:
  pushl $0
c0101cdb:	6a 00                	push   $0x0
  pushl $31
c0101cdd:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101cdf:	e9 ce fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101ce4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ce4:	6a 00                	push   $0x0
  pushl $32
c0101ce6:	6a 20                	push   $0x20
  jmp __alltraps
c0101ce8:	e9 c5 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101ced <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ced:	6a 00                	push   $0x0
  pushl $33
c0101cef:	6a 21                	push   $0x21
  jmp __alltraps
c0101cf1:	e9 bc fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cf6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101cf6:	6a 00                	push   $0x0
  pushl $34
c0101cf8:	6a 22                	push   $0x22
  jmp __alltraps
c0101cfa:	e9 b3 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101cff <vector35>:
.globl vector35
vector35:
  pushl $0
c0101cff:	6a 00                	push   $0x0
  pushl $35
c0101d01:	6a 23                	push   $0x23
  jmp __alltraps
c0101d03:	e9 aa fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d08 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101d08:	6a 00                	push   $0x0
  pushl $36
c0101d0a:	6a 24                	push   $0x24
  jmp __alltraps
c0101d0c:	e9 a1 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d11 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101d11:	6a 00                	push   $0x0
  pushl $37
c0101d13:	6a 25                	push   $0x25
  jmp __alltraps
c0101d15:	e9 98 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d1a <vector38>:
.globl vector38
vector38:
  pushl $0
c0101d1a:	6a 00                	push   $0x0
  pushl $38
c0101d1c:	6a 26                	push   $0x26
  jmp __alltraps
c0101d1e:	e9 8f fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d23 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101d23:	6a 00                	push   $0x0
  pushl $39
c0101d25:	6a 27                	push   $0x27
  jmp __alltraps
c0101d27:	e9 86 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d2c <vector40>:
.globl vector40
vector40:
  pushl $0
c0101d2c:	6a 00                	push   $0x0
  pushl $40
c0101d2e:	6a 28                	push   $0x28
  jmp __alltraps
c0101d30:	e9 7d fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d35 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101d35:	6a 00                	push   $0x0
  pushl $41
c0101d37:	6a 29                	push   $0x29
  jmp __alltraps
c0101d39:	e9 74 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d3e <vector42>:
.globl vector42
vector42:
  pushl $0
c0101d3e:	6a 00                	push   $0x0
  pushl $42
c0101d40:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101d42:	e9 6b fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d47 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101d47:	6a 00                	push   $0x0
  pushl $43
c0101d49:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101d4b:	e9 62 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d50 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101d50:	6a 00                	push   $0x0
  pushl $44
c0101d52:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101d54:	e9 59 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d59 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101d59:	6a 00                	push   $0x0
  pushl $45
c0101d5b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101d5d:	e9 50 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d62 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101d62:	6a 00                	push   $0x0
  pushl $46
c0101d64:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101d66:	e9 47 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d6b <vector47>:
.globl vector47
vector47:
  pushl $0
c0101d6b:	6a 00                	push   $0x0
  pushl $47
c0101d6d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101d6f:	e9 3e fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d74 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101d74:	6a 00                	push   $0x0
  pushl $48
c0101d76:	6a 30                	push   $0x30
  jmp __alltraps
c0101d78:	e9 35 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d7d <vector49>:
.globl vector49
vector49:
  pushl $0
c0101d7d:	6a 00                	push   $0x0
  pushl $49
c0101d7f:	6a 31                	push   $0x31
  jmp __alltraps
c0101d81:	e9 2c fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d86 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101d86:	6a 00                	push   $0x0
  pushl $50
c0101d88:	6a 32                	push   $0x32
  jmp __alltraps
c0101d8a:	e9 23 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d8f <vector51>:
.globl vector51
vector51:
  pushl $0
c0101d8f:	6a 00                	push   $0x0
  pushl $51
c0101d91:	6a 33                	push   $0x33
  jmp __alltraps
c0101d93:	e9 1a fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101d98 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101d98:	6a 00                	push   $0x0
  pushl $52
c0101d9a:	6a 34                	push   $0x34
  jmp __alltraps
c0101d9c:	e9 11 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101da1 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101da1:	6a 00                	push   $0x0
  pushl $53
c0101da3:	6a 35                	push   $0x35
  jmp __alltraps
c0101da5:	e9 08 fe ff ff       	jmp    c0101bb2 <__alltraps>

c0101daa <vector54>:
.globl vector54
vector54:
  pushl $0
c0101daa:	6a 00                	push   $0x0
  pushl $54
c0101dac:	6a 36                	push   $0x36
  jmp __alltraps
c0101dae:	e9 ff fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101db3 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101db3:	6a 00                	push   $0x0
  pushl $55
c0101db5:	6a 37                	push   $0x37
  jmp __alltraps
c0101db7:	e9 f6 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101dbc <vector56>:
.globl vector56
vector56:
  pushl $0
c0101dbc:	6a 00                	push   $0x0
  pushl $56
c0101dbe:	6a 38                	push   $0x38
  jmp __alltraps
c0101dc0:	e9 ed fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101dc5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101dc5:	6a 00                	push   $0x0
  pushl $57
c0101dc7:	6a 39                	push   $0x39
  jmp __alltraps
c0101dc9:	e9 e4 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101dce <vector58>:
.globl vector58
vector58:
  pushl $0
c0101dce:	6a 00                	push   $0x0
  pushl $58
c0101dd0:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101dd2:	e9 db fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101dd7 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101dd7:	6a 00                	push   $0x0
  pushl $59
c0101dd9:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101ddb:	e9 d2 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101de0 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101de0:	6a 00                	push   $0x0
  pushl $60
c0101de2:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101de4:	e9 c9 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101de9 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101de9:	6a 00                	push   $0x0
  pushl $61
c0101deb:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101ded:	e9 c0 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101df2 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101df2:	6a 00                	push   $0x0
  pushl $62
c0101df4:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101df6:	e9 b7 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101dfb <vector63>:
.globl vector63
vector63:
  pushl $0
c0101dfb:	6a 00                	push   $0x0
  pushl $63
c0101dfd:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101dff:	e9 ae fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e04 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101e04:	6a 00                	push   $0x0
  pushl $64
c0101e06:	6a 40                	push   $0x40
  jmp __alltraps
c0101e08:	e9 a5 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e0d <vector65>:
.globl vector65
vector65:
  pushl $0
c0101e0d:	6a 00                	push   $0x0
  pushl $65
c0101e0f:	6a 41                	push   $0x41
  jmp __alltraps
c0101e11:	e9 9c fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e16 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $66
c0101e18:	6a 42                	push   $0x42
  jmp __alltraps
c0101e1a:	e9 93 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e1f <vector67>:
.globl vector67
vector67:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $67
c0101e21:	6a 43                	push   $0x43
  jmp __alltraps
c0101e23:	e9 8a fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e28 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101e28:	6a 00                	push   $0x0
  pushl $68
c0101e2a:	6a 44                	push   $0x44
  jmp __alltraps
c0101e2c:	e9 81 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e31 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101e31:	6a 00                	push   $0x0
  pushl $69
c0101e33:	6a 45                	push   $0x45
  jmp __alltraps
c0101e35:	e9 78 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e3a <vector70>:
.globl vector70
vector70:
  pushl $0
c0101e3a:	6a 00                	push   $0x0
  pushl $70
c0101e3c:	6a 46                	push   $0x46
  jmp __alltraps
c0101e3e:	e9 6f fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e43 <vector71>:
.globl vector71
vector71:
  pushl $0
c0101e43:	6a 00                	push   $0x0
  pushl $71
c0101e45:	6a 47                	push   $0x47
  jmp __alltraps
c0101e47:	e9 66 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e4c <vector72>:
.globl vector72
vector72:
  pushl $0
c0101e4c:	6a 00                	push   $0x0
  pushl $72
c0101e4e:	6a 48                	push   $0x48
  jmp __alltraps
c0101e50:	e9 5d fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e55 <vector73>:
.globl vector73
vector73:
  pushl $0
c0101e55:	6a 00                	push   $0x0
  pushl $73
c0101e57:	6a 49                	push   $0x49
  jmp __alltraps
c0101e59:	e9 54 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e5e <vector74>:
.globl vector74
vector74:
  pushl $0
c0101e5e:	6a 00                	push   $0x0
  pushl $74
c0101e60:	6a 4a                	push   $0x4a
  jmp __alltraps
c0101e62:	e9 4b fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e67 <vector75>:
.globl vector75
vector75:
  pushl $0
c0101e67:	6a 00                	push   $0x0
  pushl $75
c0101e69:	6a 4b                	push   $0x4b
  jmp __alltraps
c0101e6b:	e9 42 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e70 <vector76>:
.globl vector76
vector76:
  pushl $0
c0101e70:	6a 00                	push   $0x0
  pushl $76
c0101e72:	6a 4c                	push   $0x4c
  jmp __alltraps
c0101e74:	e9 39 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e79 <vector77>:
.globl vector77
vector77:
  pushl $0
c0101e79:	6a 00                	push   $0x0
  pushl $77
c0101e7b:	6a 4d                	push   $0x4d
  jmp __alltraps
c0101e7d:	e9 30 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e82 <vector78>:
.globl vector78
vector78:
  pushl $0
c0101e82:	6a 00                	push   $0x0
  pushl $78
c0101e84:	6a 4e                	push   $0x4e
  jmp __alltraps
c0101e86:	e9 27 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e8b <vector79>:
.globl vector79
vector79:
  pushl $0
c0101e8b:	6a 00                	push   $0x0
  pushl $79
c0101e8d:	6a 4f                	push   $0x4f
  jmp __alltraps
c0101e8f:	e9 1e fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e94 <vector80>:
.globl vector80
vector80:
  pushl $0
c0101e94:	6a 00                	push   $0x0
  pushl $80
c0101e96:	6a 50                	push   $0x50
  jmp __alltraps
c0101e98:	e9 15 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101e9d <vector81>:
.globl vector81
vector81:
  pushl $0
c0101e9d:	6a 00                	push   $0x0
  pushl $81
c0101e9f:	6a 51                	push   $0x51
  jmp __alltraps
c0101ea1:	e9 0c fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101ea6 <vector82>:
.globl vector82
vector82:
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  pushl $82
c0101ea8:	6a 52                	push   $0x52
  jmp __alltraps
c0101eaa:	e9 03 fd ff ff       	jmp    c0101bb2 <__alltraps>

c0101eaf <vector83>:
.globl vector83
vector83:
  pushl $0
c0101eaf:	6a 00                	push   $0x0
  pushl $83
c0101eb1:	6a 53                	push   $0x53
  jmp __alltraps
c0101eb3:	e9 fa fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101eb8 <vector84>:
.globl vector84
vector84:
  pushl $0
c0101eb8:	6a 00                	push   $0x0
  pushl $84
c0101eba:	6a 54                	push   $0x54
  jmp __alltraps
c0101ebc:	e9 f1 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101ec1 <vector85>:
.globl vector85
vector85:
  pushl $0
c0101ec1:	6a 00                	push   $0x0
  pushl $85
c0101ec3:	6a 55                	push   $0x55
  jmp __alltraps
c0101ec5:	e9 e8 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101eca <vector86>:
.globl vector86
vector86:
  pushl $0
c0101eca:	6a 00                	push   $0x0
  pushl $86
c0101ecc:	6a 56                	push   $0x56
  jmp __alltraps
c0101ece:	e9 df fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101ed3 <vector87>:
.globl vector87
vector87:
  pushl $0
c0101ed3:	6a 00                	push   $0x0
  pushl $87
c0101ed5:	6a 57                	push   $0x57
  jmp __alltraps
c0101ed7:	e9 d6 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101edc <vector88>:
.globl vector88
vector88:
  pushl $0
c0101edc:	6a 00                	push   $0x0
  pushl $88
c0101ede:	6a 58                	push   $0x58
  jmp __alltraps
c0101ee0:	e9 cd fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101ee5 <vector89>:
.globl vector89
vector89:
  pushl $0
c0101ee5:	6a 00                	push   $0x0
  pushl $89
c0101ee7:	6a 59                	push   $0x59
  jmp __alltraps
c0101ee9:	e9 c4 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101eee <vector90>:
.globl vector90
vector90:
  pushl $0
c0101eee:	6a 00                	push   $0x0
  pushl $90
c0101ef0:	6a 5a                	push   $0x5a
  jmp __alltraps
c0101ef2:	e9 bb fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101ef7 <vector91>:
.globl vector91
vector91:
  pushl $0
c0101ef7:	6a 00                	push   $0x0
  pushl $91
c0101ef9:	6a 5b                	push   $0x5b
  jmp __alltraps
c0101efb:	e9 b2 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f00 <vector92>:
.globl vector92
vector92:
  pushl $0
c0101f00:	6a 00                	push   $0x0
  pushl $92
c0101f02:	6a 5c                	push   $0x5c
  jmp __alltraps
c0101f04:	e9 a9 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f09 <vector93>:
.globl vector93
vector93:
  pushl $0
c0101f09:	6a 00                	push   $0x0
  pushl $93
c0101f0b:	6a 5d                	push   $0x5d
  jmp __alltraps
c0101f0d:	e9 a0 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f12 <vector94>:
.globl vector94
vector94:
  pushl $0
c0101f12:	6a 00                	push   $0x0
  pushl $94
c0101f14:	6a 5e                	push   $0x5e
  jmp __alltraps
c0101f16:	e9 97 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f1b <vector95>:
.globl vector95
vector95:
  pushl $0
c0101f1b:	6a 00                	push   $0x0
  pushl $95
c0101f1d:	6a 5f                	push   $0x5f
  jmp __alltraps
c0101f1f:	e9 8e fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f24 <vector96>:
.globl vector96
vector96:
  pushl $0
c0101f24:	6a 00                	push   $0x0
  pushl $96
c0101f26:	6a 60                	push   $0x60
  jmp __alltraps
c0101f28:	e9 85 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f2d <vector97>:
.globl vector97
vector97:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $97
c0101f2f:	6a 61                	push   $0x61
  jmp __alltraps
c0101f31:	e9 7c fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f36 <vector98>:
.globl vector98
vector98:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $98
c0101f38:	6a 62                	push   $0x62
  jmp __alltraps
c0101f3a:	e9 73 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f3f <vector99>:
.globl vector99
vector99:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $99
c0101f41:	6a 63                	push   $0x63
  jmp __alltraps
c0101f43:	e9 6a fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f48 <vector100>:
.globl vector100
vector100:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $100
c0101f4a:	6a 64                	push   $0x64
  jmp __alltraps
c0101f4c:	e9 61 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f51 <vector101>:
.globl vector101
vector101:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $101
c0101f53:	6a 65                	push   $0x65
  jmp __alltraps
c0101f55:	e9 58 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f5a <vector102>:
.globl vector102
vector102:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $102
c0101f5c:	6a 66                	push   $0x66
  jmp __alltraps
c0101f5e:	e9 4f fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f63 <vector103>:
.globl vector103
vector103:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $103
c0101f65:	6a 67                	push   $0x67
  jmp __alltraps
c0101f67:	e9 46 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f6c <vector104>:
.globl vector104
vector104:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $104
c0101f6e:	6a 68                	push   $0x68
  jmp __alltraps
c0101f70:	e9 3d fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f75 <vector105>:
.globl vector105
vector105:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $105
c0101f77:	6a 69                	push   $0x69
  jmp __alltraps
c0101f79:	e9 34 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f7e <vector106>:
.globl vector106
vector106:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $106
c0101f80:	6a 6a                	push   $0x6a
  jmp __alltraps
c0101f82:	e9 2b fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f87 <vector107>:
.globl vector107
vector107:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $107
c0101f89:	6a 6b                	push   $0x6b
  jmp __alltraps
c0101f8b:	e9 22 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f90 <vector108>:
.globl vector108
vector108:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $108
c0101f92:	6a 6c                	push   $0x6c
  jmp __alltraps
c0101f94:	e9 19 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101f99 <vector109>:
.globl vector109
vector109:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $109
c0101f9b:	6a 6d                	push   $0x6d
  jmp __alltraps
c0101f9d:	e9 10 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101fa2 <vector110>:
.globl vector110
vector110:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $110
c0101fa4:	6a 6e                	push   $0x6e
  jmp __alltraps
c0101fa6:	e9 07 fc ff ff       	jmp    c0101bb2 <__alltraps>

c0101fab <vector111>:
.globl vector111
vector111:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $111
c0101fad:	6a 6f                	push   $0x6f
  jmp __alltraps
c0101faf:	e9 fe fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fb4 <vector112>:
.globl vector112
vector112:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $112
c0101fb6:	6a 70                	push   $0x70
  jmp __alltraps
c0101fb8:	e9 f5 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fbd <vector113>:
.globl vector113
vector113:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $113
c0101fbf:	6a 71                	push   $0x71
  jmp __alltraps
c0101fc1:	e9 ec fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fc6 <vector114>:
.globl vector114
vector114:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $114
c0101fc8:	6a 72                	push   $0x72
  jmp __alltraps
c0101fca:	e9 e3 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fcf <vector115>:
.globl vector115
vector115:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $115
c0101fd1:	6a 73                	push   $0x73
  jmp __alltraps
c0101fd3:	e9 da fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fd8 <vector116>:
.globl vector116
vector116:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $116
c0101fda:	6a 74                	push   $0x74
  jmp __alltraps
c0101fdc:	e9 d1 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fe1 <vector117>:
.globl vector117
vector117:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $117
c0101fe3:	6a 75                	push   $0x75
  jmp __alltraps
c0101fe5:	e9 c8 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101fea <vector118>:
.globl vector118
vector118:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $118
c0101fec:	6a 76                	push   $0x76
  jmp __alltraps
c0101fee:	e9 bf fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101ff3 <vector119>:
.globl vector119
vector119:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $119
c0101ff5:	6a 77                	push   $0x77
  jmp __alltraps
c0101ff7:	e9 b6 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0101ffc <vector120>:
.globl vector120
vector120:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $120
c0101ffe:	6a 78                	push   $0x78
  jmp __alltraps
c0102000:	e9 ad fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102005 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $121
c0102007:	6a 79                	push   $0x79
  jmp __alltraps
c0102009:	e9 a4 fb ff ff       	jmp    c0101bb2 <__alltraps>

c010200e <vector122>:
.globl vector122
vector122:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $122
c0102010:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102012:	e9 9b fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102017 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $123
c0102019:	6a 7b                	push   $0x7b
  jmp __alltraps
c010201b:	e9 92 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102020 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $124
c0102022:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102024:	e9 89 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102029 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $125
c010202b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010202d:	e9 80 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102032 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $126
c0102034:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102036:	e9 77 fb ff ff       	jmp    c0101bb2 <__alltraps>

c010203b <vector127>:
.globl vector127
vector127:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $127
c010203d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010203f:	e9 6e fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102044 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $128
c0102046:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010204b:	e9 62 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102050 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $129
c0102052:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102057:	e9 56 fb ff ff       	jmp    c0101bb2 <__alltraps>

c010205c <vector130>:
.globl vector130
vector130:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $130
c010205e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102063:	e9 4a fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102068 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $131
c010206a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010206f:	e9 3e fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102074 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $132
c0102076:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010207b:	e9 32 fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102080 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $133
c0102082:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102087:	e9 26 fb ff ff       	jmp    c0101bb2 <__alltraps>

c010208c <vector134>:
.globl vector134
vector134:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $134
c010208e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102093:	e9 1a fb ff ff       	jmp    c0101bb2 <__alltraps>

c0102098 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $135
c010209a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010209f:	e9 0e fb ff ff       	jmp    c0101bb2 <__alltraps>

c01020a4 <vector136>:
.globl vector136
vector136:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $136
c01020a6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01020ab:	e9 02 fb ff ff       	jmp    c0101bb2 <__alltraps>

c01020b0 <vector137>:
.globl vector137
vector137:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $137
c01020b2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01020b7:	e9 f6 fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020bc <vector138>:
.globl vector138
vector138:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $138
c01020be:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01020c3:	e9 ea fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020c8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $139
c01020ca:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01020cf:	e9 de fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020d4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $140
c01020d6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01020db:	e9 d2 fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020e0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $141
c01020e2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01020e7:	e9 c6 fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020ec <vector142>:
.globl vector142
vector142:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $142
c01020ee:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01020f3:	e9 ba fa ff ff       	jmp    c0101bb2 <__alltraps>

c01020f8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $143
c01020fa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01020ff:	e9 ae fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102104 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $144
c0102106:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010210b:	e9 a2 fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102110 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $145
c0102112:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102117:	e9 96 fa ff ff       	jmp    c0101bb2 <__alltraps>

c010211c <vector146>:
.globl vector146
vector146:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $146
c010211e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102123:	e9 8a fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102128 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $147
c010212a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010212f:	e9 7e fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102134 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $148
c0102136:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010213b:	e9 72 fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102140 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $149
c0102142:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102147:	e9 66 fa ff ff       	jmp    c0101bb2 <__alltraps>

c010214c <vector150>:
.globl vector150
vector150:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $150
c010214e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102153:	e9 5a fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102158 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $151
c010215a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010215f:	e9 4e fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102164 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $152
c0102166:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010216b:	e9 42 fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102170 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $153
c0102172:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102177:	e9 36 fa ff ff       	jmp    c0101bb2 <__alltraps>

c010217c <vector154>:
.globl vector154
vector154:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $154
c010217e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102183:	e9 2a fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102188 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $155
c010218a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010218f:	e9 1e fa ff ff       	jmp    c0101bb2 <__alltraps>

c0102194 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $156
c0102196:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010219b:	e9 12 fa ff ff       	jmp    c0101bb2 <__alltraps>

c01021a0 <vector157>:
.globl vector157
vector157:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $157
c01021a2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01021a7:	e9 06 fa ff ff       	jmp    c0101bb2 <__alltraps>

c01021ac <vector158>:
.globl vector158
vector158:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $158
c01021ae:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01021b3:	e9 fa f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021b8 <vector159>:
.globl vector159
vector159:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $159
c01021ba:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01021bf:	e9 ee f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021c4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $160
c01021c6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01021cb:	e9 e2 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021d0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $161
c01021d2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01021d7:	e9 d6 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021dc <vector162>:
.globl vector162
vector162:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $162
c01021de:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01021e3:	e9 ca f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021e8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $163
c01021ea:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01021ef:	e9 be f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01021f4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $164
c01021f6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01021fb:	e9 b2 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102200 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $165
c0102202:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102207:	e9 a6 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c010220c <vector166>:
.globl vector166
vector166:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $166
c010220e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102213:	e9 9a f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102218 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $167
c010221a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010221f:	e9 8e f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102224 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $168
c0102226:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010222b:	e9 82 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102230 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $169
c0102232:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102237:	e9 76 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c010223c <vector170>:
.globl vector170
vector170:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $170
c010223e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102243:	e9 6a f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102248 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $171
c010224a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010224f:	e9 5e f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102254 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $172
c0102256:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010225b:	e9 52 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102260 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $173
c0102262:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102267:	e9 46 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c010226c <vector174>:
.globl vector174
vector174:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $174
c010226e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102273:	e9 3a f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102278 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $175
c010227a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010227f:	e9 2e f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102284 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $176
c0102286:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010228b:	e9 22 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c0102290 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $177
c0102292:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102297:	e9 16 f9 ff ff       	jmp    c0101bb2 <__alltraps>

c010229c <vector178>:
.globl vector178
vector178:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $178
c010229e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01022a3:	e9 0a f9 ff ff       	jmp    c0101bb2 <__alltraps>

c01022a8 <vector179>:
.globl vector179
vector179:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $179
c01022aa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01022af:	e9 fe f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022b4 <vector180>:
.globl vector180
vector180:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $180
c01022b6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01022bb:	e9 f2 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022c0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $181
c01022c2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01022c7:	e9 e6 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022cc <vector182>:
.globl vector182
vector182:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $182
c01022ce:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01022d3:	e9 da f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022d8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $183
c01022da:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01022df:	e9 ce f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022e4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $184
c01022e6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01022eb:	e9 c2 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022f0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $185
c01022f2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01022f7:	e9 b6 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01022fc <vector186>:
.globl vector186
vector186:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $186
c01022fe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102303:	e9 aa f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102308 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $187
c010230a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010230f:	e9 9e f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102314 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $188
c0102316:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010231b:	e9 92 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102320 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $189
c0102322:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102327:	e9 86 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c010232c <vector190>:
.globl vector190
vector190:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $190
c010232e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102333:	e9 7a f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102338 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $191
c010233a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010233f:	e9 6e f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102344 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $192
c0102346:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010234b:	e9 62 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102350 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $193
c0102352:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102357:	e9 56 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c010235c <vector194>:
.globl vector194
vector194:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $194
c010235e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102363:	e9 4a f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102368 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $195
c010236a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010236f:	e9 3e f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102374 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $196
c0102376:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010237b:	e9 32 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102380 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $197
c0102382:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102387:	e9 26 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c010238c <vector198>:
.globl vector198
vector198:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $198
c010238e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102393:	e9 1a f8 ff ff       	jmp    c0101bb2 <__alltraps>

c0102398 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $199
c010239a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010239f:	e9 0e f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01023a4 <vector200>:
.globl vector200
vector200:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $200
c01023a6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01023ab:	e9 02 f8 ff ff       	jmp    c0101bb2 <__alltraps>

c01023b0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $201
c01023b2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01023b7:	e9 f6 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023bc <vector202>:
.globl vector202
vector202:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $202
c01023be:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01023c3:	e9 ea f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023c8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $203
c01023ca:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01023cf:	e9 de f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023d4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $204
c01023d6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01023db:	e9 d2 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023e0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $205
c01023e2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01023e7:	e9 c6 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023ec <vector206>:
.globl vector206
vector206:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $206
c01023ee:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01023f3:	e9 ba f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01023f8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $207
c01023fa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01023ff:	e9 ae f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102404 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $208
c0102406:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010240b:	e9 a2 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102410 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $209
c0102412:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102417:	e9 96 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c010241c <vector210>:
.globl vector210
vector210:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $210
c010241e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102423:	e9 8a f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102428 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $211
c010242a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010242f:	e9 7e f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102434 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $212
c0102436:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010243b:	e9 72 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102440 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $213
c0102442:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102447:	e9 66 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c010244c <vector214>:
.globl vector214
vector214:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $214
c010244e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102453:	e9 5a f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102458 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $215
c010245a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010245f:	e9 4e f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102464 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $216
c0102466:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010246b:	e9 42 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102470 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $217
c0102472:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102477:	e9 36 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c010247c <vector218>:
.globl vector218
vector218:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $218
c010247e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102483:	e9 2a f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102488 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $219
c010248a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010248f:	e9 1e f7 ff ff       	jmp    c0101bb2 <__alltraps>

c0102494 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $220
c0102496:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010249b:	e9 12 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01024a0 <vector221>:
.globl vector221
vector221:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $221
c01024a2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01024a7:	e9 06 f7 ff ff       	jmp    c0101bb2 <__alltraps>

c01024ac <vector222>:
.globl vector222
vector222:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $222
c01024ae:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01024b3:	e9 fa f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024b8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $223
c01024ba:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01024bf:	e9 ee f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024c4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $224
c01024c6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01024cb:	e9 e2 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024d0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $225
c01024d2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01024d7:	e9 d6 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024dc <vector226>:
.globl vector226
vector226:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $226
c01024de:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01024e3:	e9 ca f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024e8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $227
c01024ea:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01024ef:	e9 be f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01024f4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $228
c01024f6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01024fb:	e9 b2 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102500 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $229
c0102502:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102507:	e9 a6 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c010250c <vector230>:
.globl vector230
vector230:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $230
c010250e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102513:	e9 9a f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102518 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $231
c010251a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010251f:	e9 8e f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102524 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $232
c0102526:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010252b:	e9 82 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102530 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $233
c0102532:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102537:	e9 76 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c010253c <vector234>:
.globl vector234
vector234:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $234
c010253e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102543:	e9 6a f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102548 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $235
c010254a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010254f:	e9 5e f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102554 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $236
c0102556:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010255b:	e9 52 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102560 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $237
c0102562:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102567:	e9 46 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c010256c <vector238>:
.globl vector238
vector238:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $238
c010256e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102573:	e9 3a f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102578 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $239
c010257a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010257f:	e9 2e f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102584 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $240
c0102586:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010258b:	e9 22 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c0102590 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $241
c0102592:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102597:	e9 16 f6 ff ff       	jmp    c0101bb2 <__alltraps>

c010259c <vector242>:
.globl vector242
vector242:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $242
c010259e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01025a3:	e9 0a f6 ff ff       	jmp    c0101bb2 <__alltraps>

c01025a8 <vector243>:
.globl vector243
vector243:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $243
c01025aa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01025af:	e9 fe f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025b4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $244
c01025b6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01025bb:	e9 f2 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025c0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $245
c01025c2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01025c7:	e9 e6 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025cc <vector246>:
.globl vector246
vector246:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $246
c01025ce:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01025d3:	e9 da f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025d8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $247
c01025da:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01025df:	e9 ce f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025e4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $248
c01025e6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01025eb:	e9 c2 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025f0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $249
c01025f2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01025f7:	e9 b6 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c01025fc <vector250>:
.globl vector250
vector250:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $250
c01025fe:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102603:	e9 aa f5 ff ff       	jmp    c0101bb2 <__alltraps>

c0102608 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $251
c010260a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010260f:	e9 9e f5 ff ff       	jmp    c0101bb2 <__alltraps>

c0102614 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $252
c0102616:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010261b:	e9 92 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c0102620 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $253
c0102622:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102627:	e9 86 f5 ff ff       	jmp    c0101bb2 <__alltraps>

c010262c <vector254>:
.globl vector254
vector254:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $254
c010262e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102633:	e9 7a f5 ff ff       	jmp    c0101bb2 <__alltraps>

c0102638 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $255
c010263a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010263f:	e9 6e f5 ff ff       	jmp    c0101bb2 <__alltraps>

c0102644 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102644:	55                   	push   %ebp
c0102645:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102647:	8b 55 08             	mov    0x8(%ebp),%edx
c010264a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010264f:	29 c2                	sub    %eax,%edx
c0102651:	89 d0                	mov    %edx,%eax
c0102653:	c1 f8 02             	sar    $0x2,%eax
c0102656:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010265c:	5d                   	pop    %ebp
c010265d:	c3                   	ret    

c010265e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010265e:	55                   	push   %ebp
c010265f:	89 e5                	mov    %esp,%ebp
c0102661:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102664:	8b 45 08             	mov    0x8(%ebp),%eax
c0102667:	89 04 24             	mov    %eax,(%esp)
c010266a:	e8 d5 ff ff ff       	call   c0102644 <page2ppn>
c010266f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102672:	c9                   	leave  
c0102673:	c3                   	ret    

c0102674 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102674:	55                   	push   %ebp
c0102675:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102677:	8b 45 08             	mov    0x8(%ebp),%eax
c010267a:	8b 00                	mov    (%eax),%eax
}
c010267c:	5d                   	pop    %ebp
c010267d:	c3                   	ret    

c010267e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010267e:	55                   	push   %ebp
c010267f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102681:	8b 45 08             	mov    0x8(%ebp),%eax
c0102684:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102687:	89 10                	mov    %edx,(%eax)
}
c0102689:	5d                   	pop    %ebp
c010268a:	c3                   	ret    

c010268b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010268b:	55                   	push   %ebp
c010268c:	89 e5                	mov    %esp,%ebp
c010268e:	83 ec 10             	sub    $0x10,%esp
c0102691:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102698:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010269b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010269e:	89 50 04             	mov    %edx,0x4(%eax)
c01026a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026a4:	8b 50 04             	mov    0x4(%eax),%edx
c01026a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026aa:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01026ac:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01026b3:	00 00 00 
}
c01026b6:	c9                   	leave  
c01026b7:	c3                   	ret    

c01026b8 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01026b8:	55                   	push   %ebp
c01026b9:	89 e5                	mov    %esp,%ebp
c01026bb:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01026be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01026c2:	75 24                	jne    c01026e8 <default_init_memmap+0x30>
c01026c4:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c01026cb:	c0 
c01026cc:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01026d3:	c0 
c01026d4:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01026db:	00 
c01026dc:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01026e3:	e8 24 e5 ff ff       	call   c0100c0c <__panic>
    struct Page *p = base;
c01026e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01026ee:	e9 dc 00 00 00       	jmp    c01027cf <default_init_memmap+0x117>
        assert(PageReserved(p));
c01026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026f6:	83 c0 04             	add    $0x4,%eax
c01026f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102700:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102703:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102706:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102709:	0f a3 10             	bt     %edx,(%eax)
c010270c:	19 c0                	sbb    %eax,%eax
c010270e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102711:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102715:	0f 95 c0             	setne  %al
c0102718:	0f b6 c0             	movzbl %al,%eax
c010271b:	85 c0                	test   %eax,%eax
c010271d:	75 24                	jne    c0102743 <default_init_memmap+0x8b>
c010271f:	c7 44 24 0c a1 62 10 	movl   $0xc01062a1,0xc(%esp)
c0102726:	c0 
c0102727:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010272e:	c0 
c010272f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102736:	00 
c0102737:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010273e:	e8 c9 e4 ff ff       	call   c0100c0c <__panic>
        p->flags = 0;
c0102743:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c010274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102750:	83 c0 04             	add    $0x4,%eax
c0102753:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010275a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010275d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102763:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102769:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c0102770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102777:	00 
c0102778:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010277b:	89 04 24             	mov    %eax,(%esp)
c010277e:	e8 fb fe ff ff       	call   c010267e <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102786:	83 c0 0c             	add    $0xc,%eax
c0102789:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102790:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102793:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102796:	8b 00                	mov    (%eax),%eax
c0102798:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010279b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010279e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01027a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01027a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01027a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01027aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01027ad:	89 10                	mov    %edx,(%eax)
c01027af:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01027b2:	8b 10                	mov    (%eax),%edx
c01027b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01027b7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01027ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01027bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01027c0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01027c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01027c6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01027c9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01027cb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01027cf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01027d2:	89 d0                	mov    %edx,%eax
c01027d4:	c1 e0 02             	shl    $0x2,%eax
c01027d7:	01 d0                	add    %edx,%eax
c01027d9:	c1 e0 02             	shl    $0x2,%eax
c01027dc:	89 c2                	mov    %eax,%edx
c01027de:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e1:	01 d0                	add    %edx,%eax
c01027e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01027e6:	0f 85 07 ff ff ff    	jne    c01026f3 <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c01027ec:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01027f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027f5:	01 d0                	add    %edx,%eax
c01027f7:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    //first block
    base->property = n;
c01027fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102802:	89 50 08             	mov    %edx,0x8(%eax)
}
c0102805:	c9                   	leave  
c0102806:	c3                   	ret    

c0102807 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102807:	55                   	push   %ebp
c0102808:	89 e5                	mov    %esp,%ebp
c010280a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010280d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102811:	75 24                	jne    c0102837 <default_alloc_pages+0x30>
c0102813:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c010281a:	c0 
c010281b:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102822:	c0 
c0102823:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c010282a:	00 
c010282b:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102832:	e8 d5 e3 ff ff       	call   c0100c0c <__panic>
    if (n > nr_free) {
c0102837:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010283c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010283f:	73 0a                	jae    c010284b <default_alloc_pages+0x44>
        return NULL;
c0102841:	b8 00 00 00 00       	mov    $0x0,%eax
c0102846:	e9 37 01 00 00       	jmp    c0102982 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c010284b:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c0102852:	e9 0a 01 00 00       	jmp    c0102961 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c0102857:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010285a:	83 e8 0c             	sub    $0xc,%eax
c010285d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0102860:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102863:	8b 40 08             	mov    0x8(%eax),%eax
c0102866:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102869:	0f 82 f2 00 00 00    	jb     c0102961 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c010286f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102876:	eb 7c                	jmp    c01028f4 <default_alloc_pages+0xed>
c0102878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010287b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010287e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102881:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0102884:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c0102887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010288a:	83 e8 0c             	sub    $0xc,%eax
c010288d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0102890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102893:	83 c0 04             	add    $0x4,%eax
c0102896:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010289d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01028a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01028a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01028a6:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c01028a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01028ac:	83 c0 04             	add    $0x4,%eax
c01028af:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01028b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01028b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01028bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01028bf:	0f b3 10             	btr    %edx,(%eax)
c01028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01028c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01028cb:	8b 40 04             	mov    0x4(%eax),%eax
c01028ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01028d1:	8b 12                	mov    (%edx),%edx
c01028d3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01028d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01028dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01028df:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01028e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01028e5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01028e8:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c01028ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01028ed:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c01028f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01028f7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01028fa:	0f 82 78 ff ff ff    	jb     c0102878 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0102900:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102903:	8b 40 08             	mov    0x8(%eax),%eax
c0102906:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102909:	76 12                	jbe    c010291d <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c010290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010290e:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102911:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102914:	8b 40 08             	mov    0x8(%eax),%eax
c0102917:	2b 45 08             	sub    0x8(%ebp),%eax
c010291a:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c010291d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102920:	83 c0 04             	add    $0x4,%eax
c0102923:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010292a:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010292d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102930:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102933:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0102936:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102939:	83 c0 04             	add    $0x4,%eax
c010293c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102943:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102946:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102949:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010294c:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c010294f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102954:	2b 45 08             	sub    0x8(%ebp),%eax
c0102957:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        return p;
c010295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010295f:	eb 21                	jmp    c0102982 <default_alloc_pages+0x17b>
c0102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102964:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102967:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010296a:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c010296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102970:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102977:	0f 85 da fe ff ff    	jne    c0102857 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c010297d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102982:	c9                   	leave  
c0102983:	c3                   	ret    

c0102984 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102984:	55                   	push   %ebp
c0102985:	89 e5                	mov    %esp,%ebp
c0102987:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010298a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010298e:	75 24                	jne    c01029b4 <default_free_pages+0x30>
c0102990:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c0102997:	c0 
c0102998:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010299f:	c0 
c01029a0:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c01029a7:	00 
c01029a8:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01029af:	e8 58 e2 ff ff       	call   c0100c0c <__panic>
    assert(PageReserved(base));
c01029b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b7:	83 c0 04             	add    $0x4,%eax
c01029ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01029c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01029ca:	0f a3 10             	bt     %edx,(%eax)
c01029cd:	19 c0                	sbb    %eax,%eax
c01029cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01029d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01029d6:	0f 95 c0             	setne  %al
c01029d9:	0f b6 c0             	movzbl %al,%eax
c01029dc:	85 c0                	test   %eax,%eax
c01029de:	75 24                	jne    c0102a04 <default_free_pages+0x80>
c01029e0:	c7 44 24 0c b1 62 10 	movl   $0xc01062b1,0xc(%esp)
c01029e7:	c0 
c01029e8:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01029ef:	c0 
c01029f0:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c01029f7:	00 
c01029f8:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01029ff:	e8 08 e2 ff ff       	call   c0100c0c <__panic>

    list_entry_t *le = &free_list;
c0102a04:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102a0b:	eb 13                	jmp    c0102a20 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c0102a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a10:	83 e8 0c             	sub    $0xc,%eax
c0102a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0102a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a19:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a1c:	76 02                	jbe    c0102a20 <default_free_pages+0x9c>
        break;
c0102a1e:	eb 18                	jmp    c0102a38 <default_free_pages+0xb4>
c0102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a29:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a2f:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102a36:	75 d5                	jne    c0102a0d <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c0102a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a3e:	eb 4b                	jmp    c0102a8b <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c0102a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a43:	8d 50 0c             	lea    0xc(%eax),%edx
c0102a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a49:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102a4c:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a52:	8b 00                	mov    (%eax),%eax
c0102a54:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a57:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a60:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a63:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a69:	89 10                	mov    %edx,(%eax)
c0102a6b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a6e:	8b 10                	mov    (%eax),%edx
c0102a70:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a79:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a82:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a85:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c0102a87:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a8e:	89 d0                	mov    %edx,%eax
c0102a90:	c1 e0 02             	shl    $0x2,%eax
c0102a93:	01 d0                	add    %edx,%eax
c0102a95:	c1 e0 02             	shl    $0x2,%eax
c0102a98:	89 c2                	mov    %eax,%edx
c0102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9d:	01 d0                	add    %edx,%eax
c0102a9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102aa2:	77 9c                	ja     c0102a40 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102aae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102ab5:	00 
c0102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab9:	89 04 24             	mov    %eax,(%esp)
c0102abc:	e8 bd fb ff ff       	call   c010267e <set_page_ref>
    ClearPageProperty(base);
c0102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac4:	83 c0 04             	add    $0x4,%eax
c0102ac7:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102ace:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ad1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ad4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ad7:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0102add:	83 c0 04             	add    $0x4,%eax
c0102ae0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102ae7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102aed:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102af0:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102af9:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le,page_link) ;
c0102afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aff:	83 e8 0c             	sub    $0xc,%eax
c0102b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0102b05:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b08:	89 d0                	mov    %edx,%eax
c0102b0a:	c1 e0 02             	shl    $0x2,%eax
c0102b0d:	01 d0                	add    %edx,%eax
c0102b0f:	c1 e0 02             	shl    $0x2,%eax
c0102b12:	89 c2                	mov    %eax,%edx
c0102b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b17:	01 d0                	add    %edx,%eax
c0102b19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102b1c:	75 1e                	jne    c0102b3c <default_free_pages+0x1b8>
      base->property += p->property;
c0102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b21:	8b 50 08             	mov    0x8(%eax),%edx
c0102b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b27:	8b 40 08             	mov    0x8(%eax),%eax
c0102b2a:	01 c2                	add    %eax,%edx
c0102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b2f:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0102b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b3f:	83 c0 0c             	add    $0xc,%eax
c0102b42:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102b45:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b48:	8b 00                	mov    (%eax),%eax
c0102b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b50:	83 e8 0c             	sub    $0xc,%eax
c0102b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0102b56:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102b5d:	74 57                	je     c0102bb6 <default_free_pages+0x232>
c0102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b62:	83 e8 14             	sub    $0x14,%eax
c0102b65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102b68:	75 4c                	jne    c0102bb6 <default_free_pages+0x232>
      while(le!=&free_list){
c0102b6a:	eb 41                	jmp    c0102bad <default_free_pages+0x229>
        if(p->property){
c0102b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b6f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b72:	85 c0                	test   %eax,%eax
c0102b74:	74 20                	je     c0102b96 <default_free_pages+0x212>
          p->property += base->property;
c0102b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b79:	8b 50 08             	mov    0x8(%eax),%edx
c0102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b7f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b82:	01 c2                	add    %eax,%edx
c0102b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b87:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0102b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0102b94:	eb 20                	jmp    c0102bb6 <default_free_pages+0x232>
c0102b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b99:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102b9c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b9f:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0102ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba7:	83 e8 0c             	sub    $0xc,%eax
c0102baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0102bad:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102bb4:	75 b6                	jne    c0102b6c <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0102bb6:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bbf:	01 d0                	add    %edx,%eax
c0102bc1:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return ;
c0102bc6:	90                   	nop
}
c0102bc7:	c9                   	leave  
c0102bc8:	c3                   	ret    

c0102bc9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102bc9:	55                   	push   %ebp
c0102bca:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102bcc:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102bd1:	5d                   	pop    %ebp
c0102bd2:	c3                   	ret    

c0102bd3 <basic_check>:

static void
basic_check(void) {
c0102bd3:	55                   	push   %ebp
c0102bd4:	89 e5                	mov    %esp,%ebp
c0102bd6:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102bd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102bec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102bf3:	e8 90 0e 00 00       	call   c0103a88 <alloc_pages>
c0102bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102bff:	75 24                	jne    c0102c25 <basic_check+0x52>
c0102c01:	c7 44 24 0c c4 62 10 	movl   $0xc01062c4,0xc(%esp)
c0102c08:	c0 
c0102c09:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102c10:	c0 
c0102c11:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0102c18:	00 
c0102c19:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102c20:	e8 e7 df ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102c25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102c2c:	e8 57 0e 00 00       	call   c0103a88 <alloc_pages>
c0102c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102c38:	75 24                	jne    c0102c5e <basic_check+0x8b>
c0102c3a:	c7 44 24 0c e0 62 10 	movl   $0xc01062e0,0xc(%esp)
c0102c41:	c0 
c0102c42:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102c49:	c0 
c0102c4a:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102c51:	00 
c0102c52:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102c59:	e8 ae df ff ff       	call   c0100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102c5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102c65:	e8 1e 0e 00 00       	call   c0103a88 <alloc_pages>
c0102c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c71:	75 24                	jne    c0102c97 <basic_check+0xc4>
c0102c73:	c7 44 24 0c fc 62 10 	movl   $0xc01062fc,0xc(%esp)
c0102c7a:	c0 
c0102c7b:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102c82:	c0 
c0102c83:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102c8a:	00 
c0102c8b:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102c92:	e8 75 df ff ff       	call   c0100c0c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102c9d:	74 10                	je     c0102caf <basic_check+0xdc>
c0102c9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ca2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ca5:	74 08                	je     c0102caf <basic_check+0xdc>
c0102ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102caa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cad:	75 24                	jne    c0102cd3 <basic_check+0x100>
c0102caf:	c7 44 24 0c 18 63 10 	movl   $0xc0106318,0xc(%esp)
c0102cb6:	c0 
c0102cb7:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102cbe:	c0 
c0102cbf:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102cc6:	00 
c0102cc7:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102cce:	e8 39 df ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102cd6:	89 04 24             	mov    %eax,(%esp)
c0102cd9:	e8 96 f9 ff ff       	call   c0102674 <page_ref>
c0102cde:	85 c0                	test   %eax,%eax
c0102ce0:	75 1e                	jne    c0102d00 <basic_check+0x12d>
c0102ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ce5:	89 04 24             	mov    %eax,(%esp)
c0102ce8:	e8 87 f9 ff ff       	call   c0102674 <page_ref>
c0102ced:	85 c0                	test   %eax,%eax
c0102cef:	75 0f                	jne    c0102d00 <basic_check+0x12d>
c0102cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf4:	89 04 24             	mov    %eax,(%esp)
c0102cf7:	e8 78 f9 ff ff       	call   c0102674 <page_ref>
c0102cfc:	85 c0                	test   %eax,%eax
c0102cfe:	74 24                	je     c0102d24 <basic_check+0x151>
c0102d00:	c7 44 24 0c 3c 63 10 	movl   $0xc010633c,0xc(%esp)
c0102d07:	c0 
c0102d08:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102d0f:	c0 
c0102d10:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102d17:	00 
c0102d18:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d1f:	e8 e8 de ff ff       	call   c0100c0c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d27:	89 04 24             	mov    %eax,(%esp)
c0102d2a:	e8 2f f9 ff ff       	call   c010265e <page2pa>
c0102d2f:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102d35:	c1 e2 0c             	shl    $0xc,%edx
c0102d38:	39 d0                	cmp    %edx,%eax
c0102d3a:	72 24                	jb     c0102d60 <basic_check+0x18d>
c0102d3c:	c7 44 24 0c 78 63 10 	movl   $0xc0106378,0xc(%esp)
c0102d43:	c0 
c0102d44:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102d4b:	c0 
c0102d4c:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102d53:	00 
c0102d54:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d5b:	e8 ac de ff ff       	call   c0100c0c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d63:	89 04 24             	mov    %eax,(%esp)
c0102d66:	e8 f3 f8 ff ff       	call   c010265e <page2pa>
c0102d6b:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102d71:	c1 e2 0c             	shl    $0xc,%edx
c0102d74:	39 d0                	cmp    %edx,%eax
c0102d76:	72 24                	jb     c0102d9c <basic_check+0x1c9>
c0102d78:	c7 44 24 0c 95 63 10 	movl   $0xc0106395,0xc(%esp)
c0102d7f:	c0 
c0102d80:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102d87:	c0 
c0102d88:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102d8f:	00 
c0102d90:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d97:	e8 70 de ff ff       	call   c0100c0c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9f:	89 04 24             	mov    %eax,(%esp)
c0102da2:	e8 b7 f8 ff ff       	call   c010265e <page2pa>
c0102da7:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102dad:	c1 e2 0c             	shl    $0xc,%edx
c0102db0:	39 d0                	cmp    %edx,%eax
c0102db2:	72 24                	jb     c0102dd8 <basic_check+0x205>
c0102db4:	c7 44 24 0c b2 63 10 	movl   $0xc01063b2,0xc(%esp)
c0102dbb:	c0 
c0102dbc:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102dc3:	c0 
c0102dc4:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102dcb:	00 
c0102dcc:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102dd3:	e8 34 de ff ff       	call   c0100c0c <__panic>

    list_entry_t free_list_store = free_list;
c0102dd8:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102ddd:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102de3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102de6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102de9:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102df6:	89 50 04             	mov    %edx,0x4(%eax)
c0102df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102dfc:	8b 50 04             	mov    0x4(%eax),%edx
c0102dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e02:	89 10                	mov    %edx,(%eax)
c0102e04:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102e0e:	8b 40 04             	mov    0x4(%eax),%eax
c0102e11:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102e14:	0f 94 c0             	sete   %al
c0102e17:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102e1a:	85 c0                	test   %eax,%eax
c0102e1c:	75 24                	jne    c0102e42 <basic_check+0x26f>
c0102e1e:	c7 44 24 0c cf 63 10 	movl   $0xc01063cf,0xc(%esp)
c0102e25:	c0 
c0102e26:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102e2d:	c0 
c0102e2e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0102e35:	00 
c0102e36:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102e3d:	e8 ca dd ff ff       	call   c0100c0c <__panic>

    unsigned int nr_free_store = nr_free;
c0102e42:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e47:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102e4a:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102e51:	00 00 00 

    assert(alloc_page() == NULL);
c0102e54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e5b:	e8 28 0c 00 00       	call   c0103a88 <alloc_pages>
c0102e60:	85 c0                	test   %eax,%eax
c0102e62:	74 24                	je     c0102e88 <basic_check+0x2b5>
c0102e64:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c0102e6b:	c0 
c0102e6c:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102e73:	c0 
c0102e74:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0102e7b:	00 
c0102e7c:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102e83:	e8 84 dd ff ff       	call   c0100c0c <__panic>

    free_page(p0);
c0102e88:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102e8f:	00 
c0102e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e93:	89 04 24             	mov    %eax,(%esp)
c0102e96:	e8 25 0c 00 00       	call   c0103ac0 <free_pages>
    free_page(p1);
c0102e9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102ea2:	00 
c0102ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea6:	89 04 24             	mov    %eax,(%esp)
c0102ea9:	e8 12 0c 00 00       	call   c0103ac0 <free_pages>
    free_page(p2);
c0102eae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102eb5:	00 
c0102eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb9:	89 04 24             	mov    %eax,(%esp)
c0102ebc:	e8 ff 0b 00 00       	call   c0103ac0 <free_pages>
    assert(nr_free == 3);
c0102ec1:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ec6:	83 f8 03             	cmp    $0x3,%eax
c0102ec9:	74 24                	je     c0102eef <basic_check+0x31c>
c0102ecb:	c7 44 24 0c fb 63 10 	movl   $0xc01063fb,0xc(%esp)
c0102ed2:	c0 
c0102ed3:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102eda:	c0 
c0102edb:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0102ee2:	00 
c0102ee3:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102eea:	e8 1d dd ff ff       	call   c0100c0c <__panic>

    assert((p0 = alloc_page()) != NULL);
c0102eef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ef6:	e8 8d 0b 00 00       	call   c0103a88 <alloc_pages>
c0102efb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102efe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f02:	75 24                	jne    c0102f28 <basic_check+0x355>
c0102f04:	c7 44 24 0c c4 62 10 	movl   $0xc01062c4,0xc(%esp)
c0102f0b:	c0 
c0102f0c:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f13:	c0 
c0102f14:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0102f1b:	00 
c0102f1c:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f23:	e8 e4 dc ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f2f:	e8 54 0b 00 00       	call   c0103a88 <alloc_pages>
c0102f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f3b:	75 24                	jne    c0102f61 <basic_check+0x38e>
c0102f3d:	c7 44 24 0c e0 62 10 	movl   $0xc01062e0,0xc(%esp)
c0102f44:	c0 
c0102f45:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f4c:	c0 
c0102f4d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0102f54:	00 
c0102f55:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f5c:	e8 ab dc ff ff       	call   c0100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f68:	e8 1b 0b 00 00       	call   c0103a88 <alloc_pages>
c0102f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f74:	75 24                	jne    c0102f9a <basic_check+0x3c7>
c0102f76:	c7 44 24 0c fc 62 10 	movl   $0xc01062fc,0xc(%esp)
c0102f7d:	c0 
c0102f7e:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f85:	c0 
c0102f86:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0102f8d:	00 
c0102f8e:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f95:	e8 72 dc ff ff       	call   c0100c0c <__panic>

    assert(alloc_page() == NULL);
c0102f9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fa1:	e8 e2 0a 00 00       	call   c0103a88 <alloc_pages>
c0102fa6:	85 c0                	test   %eax,%eax
c0102fa8:	74 24                	je     c0102fce <basic_check+0x3fb>
c0102faa:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c0102fb1:	c0 
c0102fb2:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102fb9:	c0 
c0102fba:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0102fc1:	00 
c0102fc2:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102fc9:	e8 3e dc ff ff       	call   c0100c0c <__panic>

    free_page(p0);
c0102fce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102fd5:	00 
c0102fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fd9:	89 04 24             	mov    %eax,(%esp)
c0102fdc:	e8 df 0a 00 00       	call   c0103ac0 <free_pages>
c0102fe1:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0102fe8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102feb:	8b 40 04             	mov    0x4(%eax),%eax
c0102fee:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0102ff1:	0f 94 c0             	sete   %al
c0102ff4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0102ff7:	85 c0                	test   %eax,%eax
c0102ff9:	74 24                	je     c010301f <basic_check+0x44c>
c0102ffb:	c7 44 24 0c 08 64 10 	movl   $0xc0106408,0xc(%esp)
c0103002:	c0 
c0103003:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010300a:	c0 
c010300b:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103012:	00 
c0103013:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010301a:	e8 ed db ff ff       	call   c0100c0c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010301f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103026:	e8 5d 0a 00 00       	call   c0103a88 <alloc_pages>
c010302b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010302e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103031:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103034:	74 24                	je     c010305a <basic_check+0x487>
c0103036:	c7 44 24 0c 20 64 10 	movl   $0xc0106420,0xc(%esp)
c010303d:	c0 
c010303e:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103045:	c0 
c0103046:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010304d:	00 
c010304e:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103055:	e8 b2 db ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c010305a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103061:	e8 22 0a 00 00       	call   c0103a88 <alloc_pages>
c0103066:	85 c0                	test   %eax,%eax
c0103068:	74 24                	je     c010308e <basic_check+0x4bb>
c010306a:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c0103071:	c0 
c0103072:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103079:	c0 
c010307a:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103081:	00 
c0103082:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103089:	e8 7e db ff ff       	call   c0100c0c <__panic>

    assert(nr_free == 0);
c010308e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103093:	85 c0                	test   %eax,%eax
c0103095:	74 24                	je     c01030bb <basic_check+0x4e8>
c0103097:	c7 44 24 0c 39 64 10 	movl   $0xc0106439,0xc(%esp)
c010309e:	c0 
c010309f:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01030a6:	c0 
c01030a7:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01030ae:	00 
c01030af:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01030b6:	e8 51 db ff ff       	call   c0100c0c <__panic>
    free_list = free_list_store;
c01030bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030c1:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01030c6:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c01030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030cf:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c01030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030db:	00 
c01030dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030df:	89 04 24             	mov    %eax,(%esp)
c01030e2:	e8 d9 09 00 00       	call   c0103ac0 <free_pages>
    free_page(p1);
c01030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030ee:	00 
c01030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030f2:	89 04 24             	mov    %eax,(%esp)
c01030f5:	e8 c6 09 00 00       	call   c0103ac0 <free_pages>
    free_page(p2);
c01030fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103101:	00 
c0103102:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103105:	89 04 24             	mov    %eax,(%esp)
c0103108:	e8 b3 09 00 00       	call   c0103ac0 <free_pages>
}
c010310d:	c9                   	leave  
c010310e:	c3                   	ret    

c010310f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010310f:	55                   	push   %ebp
c0103110:	89 e5                	mov    %esp,%ebp
c0103112:	53                   	push   %ebx
c0103113:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103120:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103127:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010312e:	eb 6b                	jmp    c010319b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103130:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103133:	83 e8 0c             	sub    $0xc,%eax
c0103136:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103139:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010313c:	83 c0 04             	add    $0x4,%eax
c010313f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103146:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103149:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010314c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010314f:	0f a3 10             	bt     %edx,(%eax)
c0103152:	19 c0                	sbb    %eax,%eax
c0103154:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103157:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010315b:	0f 95 c0             	setne  %al
c010315e:	0f b6 c0             	movzbl %al,%eax
c0103161:	85 c0                	test   %eax,%eax
c0103163:	75 24                	jne    c0103189 <default_check+0x7a>
c0103165:	c7 44 24 0c 46 64 10 	movl   $0xc0106446,0xc(%esp)
c010316c:	c0 
c010316d:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103174:	c0 
c0103175:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010317c:	00 
c010317d:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103184:	e8 83 da ff ff       	call   c0100c0c <__panic>
        count ++, total += p->property;
c0103189:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103190:	8b 50 08             	mov    0x8(%eax),%edx
c0103193:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103196:	01 d0                	add    %edx,%eax
c0103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010319e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01031a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01031a4:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01031a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031aa:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01031b1:	0f 85 79 ff ff ff    	jne    c0103130 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01031b7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01031ba:	e8 33 09 00 00       	call   c0103af2 <nr_free_pages>
c01031bf:	39 c3                	cmp    %eax,%ebx
c01031c1:	74 24                	je     c01031e7 <default_check+0xd8>
c01031c3:	c7 44 24 0c 56 64 10 	movl   $0xc0106456,0xc(%esp)
c01031ca:	c0 
c01031cb:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01031d2:	c0 
c01031d3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01031da:	00 
c01031db:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01031e2:	e8 25 da ff ff       	call   c0100c0c <__panic>

    basic_check();
c01031e7:	e8 e7 f9 ff ff       	call   c0102bd3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01031ec:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01031f3:	e8 90 08 00 00       	call   c0103a88 <alloc_pages>
c01031f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01031fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01031ff:	75 24                	jne    c0103225 <default_check+0x116>
c0103201:	c7 44 24 0c 6f 64 10 	movl   $0xc010646f,0xc(%esp)
c0103208:	c0 
c0103209:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103210:	c0 
c0103211:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103218:	00 
c0103219:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103220:	e8 e7 d9 ff ff       	call   c0100c0c <__panic>
    assert(!PageProperty(p0));
c0103225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103228:	83 c0 04             	add    $0x4,%eax
c010322b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103232:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103235:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103238:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010323b:	0f a3 10             	bt     %edx,(%eax)
c010323e:	19 c0                	sbb    %eax,%eax
c0103240:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103243:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103247:	0f 95 c0             	setne  %al
c010324a:	0f b6 c0             	movzbl %al,%eax
c010324d:	85 c0                	test   %eax,%eax
c010324f:	74 24                	je     c0103275 <default_check+0x166>
c0103251:	c7 44 24 0c 7a 64 10 	movl   $0xc010647a,0xc(%esp)
c0103258:	c0 
c0103259:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103260:	c0 
c0103261:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103268:	00 
c0103269:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103270:	e8 97 d9 ff ff       	call   c0100c0c <__panic>

    list_entry_t free_list_store = free_list;
c0103275:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010327a:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103280:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103283:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103286:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010328d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103290:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103293:	89 50 04             	mov    %edx,0x4(%eax)
c0103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103299:	8b 50 04             	mov    0x4(%eax),%edx
c010329c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010329f:	89 10                	mov    %edx,(%eax)
c01032a1:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01032a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01032ab:	8b 40 04             	mov    0x4(%eax),%eax
c01032ae:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01032b1:	0f 94 c0             	sete   %al
c01032b4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032b7:	85 c0                	test   %eax,%eax
c01032b9:	75 24                	jne    c01032df <default_check+0x1d0>
c01032bb:	c7 44 24 0c cf 63 10 	movl   $0xc01063cf,0xc(%esp)
c01032c2:	c0 
c01032c3:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01032ca:	c0 
c01032cb:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01032d2:	00 
c01032d3:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01032da:	e8 2d d9 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c01032df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032e6:	e8 9d 07 00 00       	call   c0103a88 <alloc_pages>
c01032eb:	85 c0                	test   %eax,%eax
c01032ed:	74 24                	je     c0103313 <default_check+0x204>
c01032ef:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c01032f6:	c0 
c01032f7:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01032fe:	c0 
c01032ff:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103306:	00 
c0103307:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010330e:	e8 f9 d8 ff ff       	call   c0100c0c <__panic>

    unsigned int nr_free_store = nr_free;
c0103313:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103318:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010331b:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103322:	00 00 00 

    free_pages(p0 + 2, 3);
c0103325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103328:	83 c0 28             	add    $0x28,%eax
c010332b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103332:	00 
c0103333:	89 04 24             	mov    %eax,(%esp)
c0103336:	e8 85 07 00 00       	call   c0103ac0 <free_pages>
    assert(alloc_pages(4) == NULL);
c010333b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103342:	e8 41 07 00 00       	call   c0103a88 <alloc_pages>
c0103347:	85 c0                	test   %eax,%eax
c0103349:	74 24                	je     c010336f <default_check+0x260>
c010334b:	c7 44 24 0c 8c 64 10 	movl   $0xc010648c,0xc(%esp)
c0103352:	c0 
c0103353:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010335a:	c0 
c010335b:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103362:	00 
c0103363:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010336a:	e8 9d d8 ff ff       	call   c0100c0c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103372:	83 c0 28             	add    $0x28,%eax
c0103375:	83 c0 04             	add    $0x4,%eax
c0103378:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010337f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103382:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103385:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103388:	0f a3 10             	bt     %edx,(%eax)
c010338b:	19 c0                	sbb    %eax,%eax
c010338d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103390:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103394:	0f 95 c0             	setne  %al
c0103397:	0f b6 c0             	movzbl %al,%eax
c010339a:	85 c0                	test   %eax,%eax
c010339c:	74 0e                	je     c01033ac <default_check+0x29d>
c010339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033a1:	83 c0 28             	add    $0x28,%eax
c01033a4:	8b 40 08             	mov    0x8(%eax),%eax
c01033a7:	83 f8 03             	cmp    $0x3,%eax
c01033aa:	74 24                	je     c01033d0 <default_check+0x2c1>
c01033ac:	c7 44 24 0c a4 64 10 	movl   $0xc01064a4,0xc(%esp)
c01033b3:	c0 
c01033b4:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01033bb:	c0 
c01033bc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01033c3:	00 
c01033c4:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01033cb:	e8 3c d8 ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01033d0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01033d7:	e8 ac 06 00 00       	call   c0103a88 <alloc_pages>
c01033dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01033df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01033e3:	75 24                	jne    c0103409 <default_check+0x2fa>
c01033e5:	c7 44 24 0c d0 64 10 	movl   $0xc01064d0,0xc(%esp)
c01033ec:	c0 
c01033ed:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01033f4:	c0 
c01033f5:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01033fc:	00 
c01033fd:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103404:	e8 03 d8 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c0103409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103410:	e8 73 06 00 00       	call   c0103a88 <alloc_pages>
c0103415:	85 c0                	test   %eax,%eax
c0103417:	74 24                	je     c010343d <default_check+0x32e>
c0103419:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c0103420:	c0 
c0103421:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103428:	c0 
c0103429:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103430:	00 
c0103431:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103438:	e8 cf d7 ff ff       	call   c0100c0c <__panic>
    assert(p0 + 2 == p1);
c010343d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103440:	83 c0 28             	add    $0x28,%eax
c0103443:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103446:	74 24                	je     c010346c <default_check+0x35d>
c0103448:	c7 44 24 0c ee 64 10 	movl   $0xc01064ee,0xc(%esp)
c010344f:	c0 
c0103450:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103457:	c0 
c0103458:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010345f:	00 
c0103460:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103467:	e8 a0 d7 ff ff       	call   c0100c0c <__panic>

    p2 = p0 + 1;
c010346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010346f:	83 c0 14             	add    $0x14,%eax
c0103472:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103475:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010347c:	00 
c010347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103480:	89 04 24             	mov    %eax,(%esp)
c0103483:	e8 38 06 00 00       	call   c0103ac0 <free_pages>
    free_pages(p1, 3);
c0103488:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010348f:	00 
c0103490:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103493:	89 04 24             	mov    %eax,(%esp)
c0103496:	e8 25 06 00 00       	call   c0103ac0 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010349b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010349e:	83 c0 04             	add    $0x4,%eax
c01034a1:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01034a8:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01034ae:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01034b1:	0f a3 10             	bt     %edx,(%eax)
c01034b4:	19 c0                	sbb    %eax,%eax
c01034b6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01034b9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01034bd:	0f 95 c0             	setne  %al
c01034c0:	0f b6 c0             	movzbl %al,%eax
c01034c3:	85 c0                	test   %eax,%eax
c01034c5:	74 0b                	je     c01034d2 <default_check+0x3c3>
c01034c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034ca:	8b 40 08             	mov    0x8(%eax),%eax
c01034cd:	83 f8 01             	cmp    $0x1,%eax
c01034d0:	74 24                	je     c01034f6 <default_check+0x3e7>
c01034d2:	c7 44 24 0c fc 64 10 	movl   $0xc01064fc,0xc(%esp)
c01034d9:	c0 
c01034da:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01034e1:	c0 
c01034e2:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01034e9:	00 
c01034ea:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01034f1:	e8 16 d7 ff ff       	call   c0100c0c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01034f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034f9:	83 c0 04             	add    $0x4,%eax
c01034fc:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103503:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103506:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103509:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010350c:	0f a3 10             	bt     %edx,(%eax)
c010350f:	19 c0                	sbb    %eax,%eax
c0103511:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103514:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103518:	0f 95 c0             	setne  %al
c010351b:	0f b6 c0             	movzbl %al,%eax
c010351e:	85 c0                	test   %eax,%eax
c0103520:	74 0b                	je     c010352d <default_check+0x41e>
c0103522:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103525:	8b 40 08             	mov    0x8(%eax),%eax
c0103528:	83 f8 03             	cmp    $0x3,%eax
c010352b:	74 24                	je     c0103551 <default_check+0x442>
c010352d:	c7 44 24 0c 24 65 10 	movl   $0xc0106524,0xc(%esp)
c0103534:	c0 
c0103535:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010353c:	c0 
c010353d:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103544:	00 
c0103545:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010354c:	e8 bb d6 ff ff       	call   c0100c0c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103558:	e8 2b 05 00 00       	call   c0103a88 <alloc_pages>
c010355d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103560:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103563:	83 e8 14             	sub    $0x14,%eax
c0103566:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103569:	74 24                	je     c010358f <default_check+0x480>
c010356b:	c7 44 24 0c 4a 65 10 	movl   $0xc010654a,0xc(%esp)
c0103572:	c0 
c0103573:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010357a:	c0 
c010357b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103582:	00 
c0103583:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010358a:	e8 7d d6 ff ff       	call   c0100c0c <__panic>
    free_page(p0);
c010358f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103596:	00 
c0103597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010359a:	89 04 24             	mov    %eax,(%esp)
c010359d:	e8 1e 05 00 00       	call   c0103ac0 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01035a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01035a9:	e8 da 04 00 00       	call   c0103a88 <alloc_pages>
c01035ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01035b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035b4:	83 c0 14             	add    $0x14,%eax
c01035b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01035ba:	74 24                	je     c01035e0 <default_check+0x4d1>
c01035bc:	c7 44 24 0c 68 65 10 	movl   $0xc0106568,0xc(%esp)
c01035c3:	c0 
c01035c4:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01035cb:	c0 
c01035cc:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01035d3:	00 
c01035d4:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01035db:	e8 2c d6 ff ff       	call   c0100c0c <__panic>

    free_pages(p0, 2);
c01035e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01035e7:	00 
c01035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035eb:	89 04 24             	mov    %eax,(%esp)
c01035ee:	e8 cd 04 00 00       	call   c0103ac0 <free_pages>
    free_page(p2);
c01035f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035fa:	00 
c01035fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035fe:	89 04 24             	mov    %eax,(%esp)
c0103601:	e8 ba 04 00 00       	call   c0103ac0 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103606:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010360d:	e8 76 04 00 00       	call   c0103a88 <alloc_pages>
c0103612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103619:	75 24                	jne    c010363f <default_check+0x530>
c010361b:	c7 44 24 0c 88 65 10 	movl   $0xc0106588,0xc(%esp)
c0103622:	c0 
c0103623:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010362a:	c0 
c010362b:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103632:	00 
c0103633:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010363a:	e8 cd d5 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c010363f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103646:	e8 3d 04 00 00       	call   c0103a88 <alloc_pages>
c010364b:	85 c0                	test   %eax,%eax
c010364d:	74 24                	je     c0103673 <default_check+0x564>
c010364f:	c7 44 24 0c e6 63 10 	movl   $0xc01063e6,0xc(%esp)
c0103656:	c0 
c0103657:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010365e:	c0 
c010365f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103666:	00 
c0103667:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010366e:	e8 99 d5 ff ff       	call   c0100c0c <__panic>

    assert(nr_free == 0);
c0103673:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103678:	85 c0                	test   %eax,%eax
c010367a:	74 24                	je     c01036a0 <default_check+0x591>
c010367c:	c7 44 24 0c 39 64 10 	movl   $0xc0106439,0xc(%esp)
c0103683:	c0 
c0103684:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010368b:	c0 
c010368c:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103693:	00 
c0103694:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010369b:	e8 6c d5 ff ff       	call   c0100c0c <__panic>
    nr_free = nr_free_store;
c01036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036a3:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01036a8:	8b 45 80             	mov    -0x80(%ebp),%eax
c01036ab:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01036ae:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01036b3:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01036b9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01036c0:	00 
c01036c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c4:	89 04 24             	mov    %eax,(%esp)
c01036c7:	e8 f4 03 00 00       	call   c0103ac0 <free_pages>

    le = &free_list;
c01036cc:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01036d3:	eb 1d                	jmp    c01036f2 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01036d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036d8:	83 e8 0c             	sub    $0xc,%eax
c01036db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01036de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01036e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01036e8:	8b 40 08             	mov    0x8(%eax),%eax
c01036eb:	29 c2                	sub    %eax,%edx
c01036ed:	89 d0                	mov    %edx,%eax
c01036ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036f5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01036f8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01036fb:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01036fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103701:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103708:	75 cb                	jne    c01036d5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010370a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010370e:	74 24                	je     c0103734 <default_check+0x625>
c0103710:	c7 44 24 0c a6 65 10 	movl   $0xc01065a6,0xc(%esp)
c0103717:	c0 
c0103718:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010371f:	c0 
c0103720:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103727:	00 
c0103728:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010372f:	e8 d8 d4 ff ff       	call   c0100c0c <__panic>
    assert(total == 0);
c0103734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103738:	74 24                	je     c010375e <default_check+0x64f>
c010373a:	c7 44 24 0c b1 65 10 	movl   $0xc01065b1,0xc(%esp)
c0103741:	c0 
c0103742:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103749:	c0 
c010374a:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103751:	00 
c0103752:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103759:	e8 ae d4 ff ff       	call   c0100c0c <__panic>
}
c010375e:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103764:	5b                   	pop    %ebx
c0103765:	5d                   	pop    %ebp
c0103766:	c3                   	ret    

c0103767 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103767:	55                   	push   %ebp
c0103768:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010376a:	8b 55 08             	mov    0x8(%ebp),%edx
c010376d:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103772:	29 c2                	sub    %eax,%edx
c0103774:	89 d0                	mov    %edx,%eax
c0103776:	c1 f8 02             	sar    $0x2,%eax
c0103779:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010377f:	5d                   	pop    %ebp
c0103780:	c3                   	ret    

c0103781 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103781:	55                   	push   %ebp
c0103782:	89 e5                	mov    %esp,%ebp
c0103784:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103787:	8b 45 08             	mov    0x8(%ebp),%eax
c010378a:	89 04 24             	mov    %eax,(%esp)
c010378d:	e8 d5 ff ff ff       	call   c0103767 <page2ppn>
c0103792:	c1 e0 0c             	shl    $0xc,%eax
}
c0103795:	c9                   	leave  
c0103796:	c3                   	ret    

c0103797 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103797:	55                   	push   %ebp
c0103798:	89 e5                	mov    %esp,%ebp
c010379a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010379d:	8b 45 08             	mov    0x8(%ebp),%eax
c01037a0:	c1 e8 0c             	shr    $0xc,%eax
c01037a3:	89 c2                	mov    %eax,%edx
c01037a5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01037aa:	39 c2                	cmp    %eax,%edx
c01037ac:	72 1c                	jb     c01037ca <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01037ae:	c7 44 24 08 ec 65 10 	movl   $0xc01065ec,0x8(%esp)
c01037b5:	c0 
c01037b6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01037bd:	00 
c01037be:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01037c5:	e8 42 d4 ff ff       	call   c0100c0c <__panic>
    }
    return &pages[PPN(pa)];
c01037ca:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c01037d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d3:	c1 e8 0c             	shr    $0xc,%eax
c01037d6:	89 c2                	mov    %eax,%edx
c01037d8:	89 d0                	mov    %edx,%eax
c01037da:	c1 e0 02             	shl    $0x2,%eax
c01037dd:	01 d0                	add    %edx,%eax
c01037df:	c1 e0 02             	shl    $0x2,%eax
c01037e2:	01 c8                	add    %ecx,%eax
}
c01037e4:	c9                   	leave  
c01037e5:	c3                   	ret    

c01037e6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01037e6:	55                   	push   %ebp
c01037e7:	89 e5                	mov    %esp,%ebp
c01037e9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01037ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ef:	89 04 24             	mov    %eax,(%esp)
c01037f2:	e8 8a ff ff ff       	call   c0103781 <page2pa>
c01037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037fd:	c1 e8 0c             	shr    $0xc,%eax
c0103800:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103803:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103808:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010380b:	72 23                	jb     c0103830 <page2kva+0x4a>
c010380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103810:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103814:	c7 44 24 08 1c 66 10 	movl   $0xc010661c,0x8(%esp)
c010381b:	c0 
c010381c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103823:	00 
c0103824:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010382b:	e8 dc d3 ff ff       	call   c0100c0c <__panic>
c0103830:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103833:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103838:	c9                   	leave  
c0103839:	c3                   	ret    

c010383a <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010383a:	55                   	push   %ebp
c010383b:	89 e5                	mov    %esp,%ebp
c010383d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103840:	8b 45 08             	mov    0x8(%ebp),%eax
c0103843:	83 e0 01             	and    $0x1,%eax
c0103846:	85 c0                	test   %eax,%eax
c0103848:	75 1c                	jne    c0103866 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010384a:	c7 44 24 08 40 66 10 	movl   $0xc0106640,0x8(%esp)
c0103851:	c0 
c0103852:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103859:	00 
c010385a:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103861:	e8 a6 d3 ff ff       	call   c0100c0c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103866:	8b 45 08             	mov    0x8(%ebp),%eax
c0103869:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010386e:	89 04 24             	mov    %eax,(%esp)
c0103871:	e8 21 ff ff ff       	call   c0103797 <pa2page>
}
c0103876:	c9                   	leave  
c0103877:	c3                   	ret    

c0103878 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103878:	55                   	push   %ebp
c0103879:	89 e5                	mov    %esp,%ebp
c010387b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010387e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103881:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103886:	89 04 24             	mov    %eax,(%esp)
c0103889:	e8 09 ff ff ff       	call   c0103797 <pa2page>
}
c010388e:	c9                   	leave  
c010388f:	c3                   	ret    

c0103890 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103890:	55                   	push   %ebp
c0103891:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103893:	8b 45 08             	mov    0x8(%ebp),%eax
c0103896:	8b 00                	mov    (%eax),%eax
}
c0103898:	5d                   	pop    %ebp
c0103899:	c3                   	ret    

c010389a <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c010389a:	55                   	push   %ebp
c010389b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010389d:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a0:	8b 00                	mov    (%eax),%eax
c01038a2:	8d 50 01             	lea    0x1(%eax),%edx
c01038a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01038aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ad:	8b 00                	mov    (%eax),%eax
}
c01038af:	5d                   	pop    %ebp
c01038b0:	c3                   	ret    

c01038b1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01038b1:	55                   	push   %ebp
c01038b2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01038b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b7:	8b 00                	mov    (%eax),%eax
c01038b9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01038bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01038bf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01038c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c4:	8b 00                	mov    (%eax),%eax
}
c01038c6:	5d                   	pop    %ebp
c01038c7:	c3                   	ret    

c01038c8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01038c8:	55                   	push   %ebp
c01038c9:	89 e5                	mov    %esp,%ebp
c01038cb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01038ce:	9c                   	pushf  
c01038cf:	58                   	pop    %eax
c01038d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01038d6:	25 00 02 00 00       	and    $0x200,%eax
c01038db:	85 c0                	test   %eax,%eax
c01038dd:	74 0c                	je     c01038eb <__intr_save+0x23>
        intr_disable();
c01038df:	e8 0b dd ff ff       	call   c01015ef <intr_disable>
        return 1;
c01038e4:	b8 01 00 00 00       	mov    $0x1,%eax
c01038e9:	eb 05                	jmp    c01038f0 <__intr_save+0x28>
    }
    return 0;
c01038eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038f0:	c9                   	leave  
c01038f1:	c3                   	ret    

c01038f2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01038f2:	55                   	push   %ebp
c01038f3:	89 e5                	mov    %esp,%ebp
c01038f5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01038f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01038fc:	74 05                	je     c0103903 <__intr_restore+0x11>
        intr_enable();
c01038fe:	e8 e6 dc ff ff       	call   c01015e9 <intr_enable>
    }
}
c0103903:	c9                   	leave  
c0103904:	c3                   	ret    

c0103905 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103905:	55                   	push   %ebp
c0103906:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103908:	8b 45 08             	mov    0x8(%ebp),%eax
c010390b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010390e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103913:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103915:	b8 23 00 00 00       	mov    $0x23,%eax
c010391a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c010391c:	b8 10 00 00 00       	mov    $0x10,%eax
c0103921:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103923:	b8 10 00 00 00       	mov    $0x10,%eax
c0103928:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c010392a:	b8 10 00 00 00       	mov    $0x10,%eax
c010392f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103931:	ea 38 39 10 c0 08 00 	ljmp   $0x8,$0xc0103938
}
c0103938:	5d                   	pop    %ebp
c0103939:	c3                   	ret    

c010393a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c010393a:	55                   	push   %ebp
c010393b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010393d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103940:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103945:	5d                   	pop    %ebp
c0103946:	c3                   	ret    

c0103947 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103947:	55                   	push   %ebp
c0103948:	89 e5                	mov    %esp,%ebp
c010394a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010394d:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103952:	89 04 24             	mov    %eax,(%esp)
c0103955:	e8 e0 ff ff ff       	call   c010393a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c010395a:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103961:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103963:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c010396a:	68 00 
c010396c:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103971:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103977:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c010397c:	c1 e8 10             	shr    $0x10,%eax
c010397f:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103984:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c010398b:	83 e0 f0             	and    $0xfffffff0,%eax
c010398e:	83 c8 09             	or     $0x9,%eax
c0103991:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103996:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c010399d:	83 e0 ef             	and    $0xffffffef,%eax
c01039a0:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c01039a5:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c01039ac:	83 e0 9f             	and    $0xffffff9f,%eax
c01039af:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c01039b4:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c01039bb:	83 c8 80             	or     $0xffffff80,%eax
c01039be:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c01039c3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01039ca:	83 e0 f0             	and    $0xfffffff0,%eax
c01039cd:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01039d2:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01039d9:	83 e0 ef             	and    $0xffffffef,%eax
c01039dc:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01039e1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01039e8:	83 e0 df             	and    $0xffffffdf,%eax
c01039eb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01039f0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01039f7:	83 c8 40             	or     $0x40,%eax
c01039fa:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01039ff:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103a06:	83 e0 7f             	and    $0x7f,%eax
c0103a09:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103a0e:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103a13:	c1 e8 18             	shr    $0x18,%eax
c0103a16:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103a1b:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103a22:	e8 de fe ff ff       	call   c0103905 <lgdt>
c0103a27:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103a2d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103a31:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103a34:	c9                   	leave  
c0103a35:	c3                   	ret    

c0103a36 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103a36:	55                   	push   %ebp
c0103a37:	89 e5                	mov    %esp,%ebp
c0103a39:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103a3c:	c7 05 5c 89 11 c0 d0 	movl   $0xc01065d0,0xc011895c
c0103a43:	65 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103a46:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103a4b:	8b 00                	mov    (%eax),%eax
c0103a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a51:	c7 04 24 6c 66 10 c0 	movl   $0xc010666c,(%esp)
c0103a58:	e8 df c8 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103a5d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103a62:	8b 40 04             	mov    0x4(%eax),%eax
c0103a65:	ff d0                	call   *%eax
}
c0103a67:	c9                   	leave  
c0103a68:	c3                   	ret    

c0103a69 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103a69:	55                   	push   %ebp
c0103a6a:	89 e5                	mov    %esp,%ebp
c0103a6c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103a6f:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103a74:	8b 40 08             	mov    0x8(%eax),%eax
c0103a77:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a7a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a7e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a81:	89 14 24             	mov    %edx,(%esp)
c0103a84:	ff d0                	call   *%eax
}
c0103a86:	c9                   	leave  
c0103a87:	c3                   	ret    

c0103a88 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103a88:	55                   	push   %ebp
c0103a89:	89 e5                	mov    %esp,%ebp
c0103a8b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103a95:	e8 2e fe ff ff       	call   c01038c8 <__intr_save>
c0103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103a9d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103aa2:	8b 40 0c             	mov    0xc(%eax),%eax
c0103aa5:	8b 55 08             	mov    0x8(%ebp),%edx
c0103aa8:	89 14 24             	mov    %edx,(%esp)
c0103aab:	ff d0                	call   *%eax
c0103aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab3:	89 04 24             	mov    %eax,(%esp)
c0103ab6:	e8 37 fe ff ff       	call   c01038f2 <__intr_restore>
    return page;
c0103abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103abe:	c9                   	leave  
c0103abf:	c3                   	ret    

c0103ac0 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103ac0:	55                   	push   %ebp
c0103ac1:	89 e5                	mov    %esp,%ebp
c0103ac3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ac6:	e8 fd fd ff ff       	call   c01038c8 <__intr_save>
c0103acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103ace:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ad3:	8b 40 10             	mov    0x10(%eax),%eax
c0103ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103add:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ae0:	89 14 24             	mov    %edx,(%esp)
c0103ae3:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae8:	89 04 24             	mov    %eax,(%esp)
c0103aeb:	e8 02 fe ff ff       	call   c01038f2 <__intr_restore>
}
c0103af0:	c9                   	leave  
c0103af1:	c3                   	ret    

c0103af2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103af2:	55                   	push   %ebp
c0103af3:	89 e5                	mov    %esp,%ebp
c0103af5:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103af8:	e8 cb fd ff ff       	call   c01038c8 <__intr_save>
c0103afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103b00:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103b05:	8b 40 14             	mov    0x14(%eax),%eax
c0103b08:	ff d0                	call   *%eax
c0103b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b10:	89 04 24             	mov    %eax,(%esp)
c0103b13:	e8 da fd ff ff       	call   c01038f2 <__intr_restore>
    return ret;
c0103b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103b1b:	c9                   	leave  
c0103b1c:	c3                   	ret    

c0103b1d <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103b1d:	55                   	push   %ebp
c0103b1e:	89 e5                	mov    %esp,%ebp
c0103b20:	57                   	push   %edi
c0103b21:	56                   	push   %esi
c0103b22:	53                   	push   %ebx
c0103b23:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103b29:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103b30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103b37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103b3e:	c7 04 24 83 66 10 c0 	movl   $0xc0106683,(%esp)
c0103b45:	e8 f2 c7 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103b4a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103b51:	e9 15 01 00 00       	jmp    c0103c6b <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103b56:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103b59:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103b5c:	89 d0                	mov    %edx,%eax
c0103b5e:	c1 e0 02             	shl    $0x2,%eax
c0103b61:	01 d0                	add    %edx,%eax
c0103b63:	c1 e0 02             	shl    $0x2,%eax
c0103b66:	01 c8                	add    %ecx,%eax
c0103b68:	8b 50 08             	mov    0x8(%eax),%edx
c0103b6b:	8b 40 04             	mov    0x4(%eax),%eax
c0103b6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103b71:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103b74:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103b77:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103b7a:	89 d0                	mov    %edx,%eax
c0103b7c:	c1 e0 02             	shl    $0x2,%eax
c0103b7f:	01 d0                	add    %edx,%eax
c0103b81:	c1 e0 02             	shl    $0x2,%eax
c0103b84:	01 c8                	add    %ecx,%eax
c0103b86:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103b89:	8b 58 10             	mov    0x10(%eax),%ebx
c0103b8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103b8f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103b92:	01 c8                	add    %ecx,%eax
c0103b94:	11 da                	adc    %ebx,%edx
c0103b96:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103b99:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103b9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ba2:	89 d0                	mov    %edx,%eax
c0103ba4:	c1 e0 02             	shl    $0x2,%eax
c0103ba7:	01 d0                	add    %edx,%eax
c0103ba9:	c1 e0 02             	shl    $0x2,%eax
c0103bac:	01 c8                	add    %ecx,%eax
c0103bae:	83 c0 14             	add    $0x14,%eax
c0103bb1:	8b 00                	mov    (%eax),%eax
c0103bb3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103bb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103bbc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103bbf:	83 c0 ff             	add    $0xffffffff,%eax
c0103bc2:	83 d2 ff             	adc    $0xffffffff,%edx
c0103bc5:	89 c6                	mov    %eax,%esi
c0103bc7:	89 d7                	mov    %edx,%edi
c0103bc9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103bcf:	89 d0                	mov    %edx,%eax
c0103bd1:	c1 e0 02             	shl    $0x2,%eax
c0103bd4:	01 d0                	add    %edx,%eax
c0103bd6:	c1 e0 02             	shl    $0x2,%eax
c0103bd9:	01 c8                	add    %ecx,%eax
c0103bdb:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103bde:	8b 58 10             	mov    0x10(%eax),%ebx
c0103be1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103be7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103beb:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103bef:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103bf3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103bf6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103bf9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103bfd:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103c01:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103c05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103c09:	c7 04 24 90 66 10 c0 	movl   $0xc0106690,(%esp)
c0103c10:	e8 27 c7 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103c15:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c18:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c1b:	89 d0                	mov    %edx,%eax
c0103c1d:	c1 e0 02             	shl    $0x2,%eax
c0103c20:	01 d0                	add    %edx,%eax
c0103c22:	c1 e0 02             	shl    $0x2,%eax
c0103c25:	01 c8                	add    %ecx,%eax
c0103c27:	83 c0 14             	add    $0x14,%eax
c0103c2a:	8b 00                	mov    (%eax),%eax
c0103c2c:	83 f8 01             	cmp    $0x1,%eax
c0103c2f:	75 36                	jne    c0103c67 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103c37:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103c3a:	77 2b                	ja     c0103c67 <page_init+0x14a>
c0103c3c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103c3f:	72 05                	jb     c0103c46 <page_init+0x129>
c0103c41:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103c44:	73 21                	jae    c0103c67 <page_init+0x14a>
c0103c46:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103c4a:	77 1b                	ja     c0103c67 <page_init+0x14a>
c0103c4c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103c50:	72 09                	jb     c0103c5b <page_init+0x13e>
c0103c52:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103c59:	77 0c                	ja     c0103c67 <page_init+0x14a>
                maxpa = end;
c0103c5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103c5e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103c61:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c64:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c67:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103c6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103c6e:	8b 00                	mov    (%eax),%eax
c0103c70:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103c73:	0f 8f dd fe ff ff    	jg     c0103b56 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103c7d:	72 1d                	jb     c0103c9c <page_init+0x17f>
c0103c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103c83:	77 09                	ja     c0103c8e <page_init+0x171>
c0103c85:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103c8c:	76 0e                	jbe    c0103c9c <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103c8e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103c95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ca2:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ca6:	c1 ea 0c             	shr    $0xc,%edx
c0103ca9:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103cae:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103cb5:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103cba:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103cbd:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103cc0:	01 d0                	add    %edx,%eax
c0103cc2:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103cc5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103cc8:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ccd:	f7 75 ac             	divl   -0x54(%ebp)
c0103cd0:	89 d0                	mov    %edx,%eax
c0103cd2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103cd5:	29 c2                	sub    %eax,%edx
c0103cd7:	89 d0                	mov    %edx,%eax
c0103cd9:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103cde:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ce5:	eb 2f                	jmp    c0103d16 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103ce7:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103ced:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cf0:	89 d0                	mov    %edx,%eax
c0103cf2:	c1 e0 02             	shl    $0x2,%eax
c0103cf5:	01 d0                	add    %edx,%eax
c0103cf7:	c1 e0 02             	shl    $0x2,%eax
c0103cfa:	01 c8                	add    %ecx,%eax
c0103cfc:	83 c0 04             	add    $0x4,%eax
c0103cff:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103d06:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103d09:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103d0c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103d0f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103d12:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103d16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d19:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103d1e:	39 c2                	cmp    %eax,%edx
c0103d20:	72 c5                	jb     c0103ce7 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103d22:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103d28:	89 d0                	mov    %edx,%eax
c0103d2a:	c1 e0 02             	shl    $0x2,%eax
c0103d2d:	01 d0                	add    %edx,%eax
c0103d2f:	c1 e0 02             	shl    $0x2,%eax
c0103d32:	89 c2                	mov    %eax,%edx
c0103d34:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103d39:	01 d0                	add    %edx,%eax
c0103d3b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103d3e:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103d45:	77 23                	ja     c0103d6a <page_init+0x24d>
c0103d47:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103d4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d4e:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0103d55:	c0 
c0103d56:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103d5d:	00 
c0103d5e:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0103d65:	e8 a2 ce ff ff       	call   c0100c0c <__panic>
c0103d6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103d6d:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d72:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103d75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d7c:	e9 74 01 00 00       	jmp    c0103ef5 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d87:	89 d0                	mov    %edx,%eax
c0103d89:	c1 e0 02             	shl    $0x2,%eax
c0103d8c:	01 d0                	add    %edx,%eax
c0103d8e:	c1 e0 02             	shl    $0x2,%eax
c0103d91:	01 c8                	add    %ecx,%eax
c0103d93:	8b 50 08             	mov    0x8(%eax),%edx
c0103d96:	8b 40 04             	mov    0x4(%eax),%eax
c0103d99:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103d9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103d9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103da2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103da5:	89 d0                	mov    %edx,%eax
c0103da7:	c1 e0 02             	shl    $0x2,%eax
c0103daa:	01 d0                	add    %edx,%eax
c0103dac:	c1 e0 02             	shl    $0x2,%eax
c0103daf:	01 c8                	add    %ecx,%eax
c0103db1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103db4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103db7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103dba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103dbd:	01 c8                	add    %ecx,%eax
c0103dbf:	11 da                	adc    %ebx,%edx
c0103dc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103dc4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103dc7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dcd:	89 d0                	mov    %edx,%eax
c0103dcf:	c1 e0 02             	shl    $0x2,%eax
c0103dd2:	01 d0                	add    %edx,%eax
c0103dd4:	c1 e0 02             	shl    $0x2,%eax
c0103dd7:	01 c8                	add    %ecx,%eax
c0103dd9:	83 c0 14             	add    $0x14,%eax
c0103ddc:	8b 00                	mov    (%eax),%eax
c0103dde:	83 f8 01             	cmp    $0x1,%eax
c0103de1:	0f 85 0a 01 00 00    	jne    c0103ef1 <page_init+0x3d4>
            if (begin < freemem) {
c0103de7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103dea:	ba 00 00 00 00       	mov    $0x0,%edx
c0103def:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103df2:	72 17                	jb     c0103e0b <page_init+0x2ee>
c0103df4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103df7:	77 05                	ja     c0103dfe <page_init+0x2e1>
c0103df9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103dfc:	76 0d                	jbe    c0103e0b <page_init+0x2ee>
                begin = freemem;
c0103dfe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103e01:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e04:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103e0b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103e0f:	72 1d                	jb     c0103e2e <page_init+0x311>
c0103e11:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103e15:	77 09                	ja     c0103e20 <page_init+0x303>
c0103e17:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103e1e:	76 0e                	jbe    c0103e2e <page_init+0x311>
                end = KMEMSIZE;
c0103e20:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103e27:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103e2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e34:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103e37:	0f 87 b4 00 00 00    	ja     c0103ef1 <page_init+0x3d4>
c0103e3d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103e40:	72 09                	jb     c0103e4b <page_init+0x32e>
c0103e42:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103e45:	0f 83 a6 00 00 00    	jae    c0103ef1 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103e4b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103e52:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103e55:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103e58:	01 d0                	add    %edx,%eax
c0103e5a:	83 e8 01             	sub    $0x1,%eax
c0103e5d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103e60:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103e63:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e68:	f7 75 9c             	divl   -0x64(%ebp)
c0103e6b:	89 d0                	mov    %edx,%eax
c0103e6d:	8b 55 98             	mov    -0x68(%ebp),%edx
c0103e70:	29 c2                	sub    %eax,%edx
c0103e72:	89 d0                	mov    %edx,%eax
c0103e74:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e79:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103e7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103e82:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103e85:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103e88:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e8d:	89 c7                	mov    %eax,%edi
c0103e8f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0103e95:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0103e98:	89 d0                	mov    %edx,%eax
c0103e9a:	83 e0 00             	and    $0x0,%eax
c0103e9d:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103ea0:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103ea3:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ea9:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103eac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103eaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103eb2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103eb5:	77 3a                	ja     c0103ef1 <page_init+0x3d4>
c0103eb7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103eba:	72 05                	jb     c0103ec1 <page_init+0x3a4>
c0103ebc:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103ebf:	73 30                	jae    c0103ef1 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103ec1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0103ec4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0103ec7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103eca:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103ecd:	29 c8                	sub    %ecx,%eax
c0103ecf:	19 da                	sbb    %ebx,%edx
c0103ed1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ed5:	c1 ea 0c             	shr    $0xc,%edx
c0103ed8:	89 c3                	mov    %eax,%ebx
c0103eda:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103edd:	89 04 24             	mov    %eax,(%esp)
c0103ee0:	e8 b2 f8 ff ff       	call   c0103797 <pa2page>
c0103ee5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103ee9:	89 04 24             	mov    %eax,(%esp)
c0103eec:	e8 78 fb ff ff       	call   c0103a69 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0103ef1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ef5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ef8:	8b 00                	mov    (%eax),%eax
c0103efa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103efd:	0f 8f 7e fe ff ff    	jg     c0103d81 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0103f03:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103f09:	5b                   	pop    %ebx
c0103f0a:	5e                   	pop    %esi
c0103f0b:	5f                   	pop    %edi
c0103f0c:	5d                   	pop    %ebp
c0103f0d:	c3                   	ret    

c0103f0e <enable_paging>:

static void
enable_paging(void) {
c0103f0e:	55                   	push   %ebp
c0103f0f:	89 e5                	mov    %esp,%ebp
c0103f11:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103f14:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c0103f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f1f:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103f22:	0f 20 c0             	mov    %cr0,%eax
c0103f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103f28:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103f2e:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103f35:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0103f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f42:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103f45:	c9                   	leave  
c0103f46:	c3                   	ret    

c0103f47 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103f47:	55                   	push   %ebp
c0103f48:	89 e5                	mov    %esp,%ebp
c0103f4a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103f4d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f50:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f53:	31 d0                	xor    %edx,%eax
c0103f55:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103f5a:	85 c0                	test   %eax,%eax
c0103f5c:	74 24                	je     c0103f82 <boot_map_segment+0x3b>
c0103f5e:	c7 44 24 0c f2 66 10 	movl   $0xc01066f2,0xc(%esp)
c0103f65:	c0 
c0103f66:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0103f6d:	c0 
c0103f6e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103f75:	00 
c0103f76:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0103f7d:	e8 8a cc ff ff       	call   c0100c0c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103f82:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103f89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103f8c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103f91:	89 c2                	mov    %eax,%edx
c0103f93:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f96:	01 c2                	add    %eax,%edx
c0103f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f9b:	01 d0                	add    %edx,%eax
c0103f9d:	83 e8 01             	sub    $0x1,%eax
c0103fa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fa6:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fab:	f7 75 f0             	divl   -0x10(%ebp)
c0103fae:	89 d0                	mov    %edx,%eax
c0103fb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103fb3:	29 c2                	sub    %eax,%edx
c0103fb5:	89 d0                	mov    %edx,%eax
c0103fb7:	c1 e8 0c             	shr    $0xc,%eax
c0103fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103fcb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103fce:	8b 45 14             	mov    0x14(%ebp),%eax
c0103fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103fdc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103fdf:	eb 6b                	jmp    c010404c <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103fe1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103fe8:	00 
c0103fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ff3:	89 04 24             	mov    %eax,(%esp)
c0103ff6:	e8 cc 01 00 00       	call   c01041c7 <get_pte>
c0103ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103ffe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104002:	75 24                	jne    c0104028 <boot_map_segment+0xe1>
c0104004:	c7 44 24 0c 1e 67 10 	movl   $0xc010671e,0xc(%esp)
c010400b:	c0 
c010400c:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104013:	c0 
c0104014:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010401b:	00 
c010401c:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104023:	e8 e4 cb ff ff       	call   c0100c0c <__panic>
        *ptep = pa | PTE_P | perm;
c0104028:	8b 45 18             	mov    0x18(%ebp),%eax
c010402b:	8b 55 14             	mov    0x14(%ebp),%edx
c010402e:	09 d0                	or     %edx,%eax
c0104030:	83 c8 01             	or     $0x1,%eax
c0104033:	89 c2                	mov    %eax,%edx
c0104035:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104038:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010403a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010403e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104045:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010404c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104050:	75 8f                	jne    c0103fe1 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104052:	c9                   	leave  
c0104053:	c3                   	ret    

c0104054 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104054:	55                   	push   %ebp
c0104055:	89 e5                	mov    %esp,%ebp
c0104057:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010405a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104061:	e8 22 fa ff ff       	call   c0103a88 <alloc_pages>
c0104066:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104069:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010406d:	75 1c                	jne    c010408b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010406f:	c7 44 24 08 2b 67 10 	movl   $0xc010672b,0x8(%esp)
c0104076:	c0 
c0104077:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010407e:	00 
c010407f:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104086:	e8 81 cb ff ff       	call   c0100c0c <__panic>
    }
    return page2kva(p);
c010408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010408e:	89 04 24             	mov    %eax,(%esp)
c0104091:	e8 50 f7 ff ff       	call   c01037e6 <page2kva>
}
c0104096:	c9                   	leave  
c0104097:	c3                   	ret    

c0104098 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104098:	55                   	push   %ebp
c0104099:	89 e5                	mov    %esp,%ebp
c010409b:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010409e:	e8 93 f9 ff ff       	call   c0103a36 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01040a3:	e8 75 fa ff ff       	call   c0103b1d <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01040a8:	e8 d7 02 00 00       	call   c0104384 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01040ad:	e8 a2 ff ff ff       	call   c0104054 <boot_alloc_page>
c01040b2:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01040b7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01040bc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01040c3:	00 
c01040c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01040cb:	00 
c01040cc:	89 04 24             	mov    %eax,(%esp)
c01040cf:	e8 14 19 00 00       	call   c01059e8 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01040d4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01040d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01040dc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01040e3:	77 23                	ja     c0104108 <pmm_init+0x70>
c01040e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040ec:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c01040f3:	c0 
c01040f4:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01040fb:	00 
c01040fc:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104103:	e8 04 cb ff ff       	call   c0100c0c <__panic>
c0104108:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104110:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c0104115:	e8 88 02 00 00       	call   c01043a2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010411a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010411f:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104125:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010412a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010412d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104134:	77 23                	ja     c0104159 <pmm_init+0xc1>
c0104136:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104139:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010413d:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0104144:	c0 
c0104145:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010414c:	00 
c010414d:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104154:	e8 b3 ca ff ff       	call   c0100c0c <__panic>
c0104159:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010415c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104161:	83 c8 03             	or     $0x3,%eax
c0104164:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104166:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010416b:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104172:	00 
c0104173:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010417a:	00 
c010417b:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104182:	38 
c0104183:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010418a:	c0 
c010418b:	89 04 24             	mov    %eax,(%esp)
c010418e:	e8 b4 fd ff ff       	call   c0103f47 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104193:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104198:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010419e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01041a4:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01041a6:	e8 63 fd ff ff       	call   c0103f0e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01041ab:	e8 97 f7 ff ff       	call   c0103947 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01041b0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01041b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01041bb:	e8 7d 08 00 00       	call   c0104a3d <check_boot_pgdir>

    print_pgdir();
c01041c0:	e8 05 0d 00 00       	call   c0104eca <print_pgdir>

}
c01041c5:	c9                   	leave  
c01041c6:	c3                   	ret    

c01041c7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041c7:	55                   	push   %ebp
c01041c8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01041ca:	5d                   	pop    %ebp
c01041cb:	c3                   	ret    

c01041cc <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01041cc:	55                   	push   %ebp
c01041cd:	89 e5                	mov    %esp,%ebp
c01041cf:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01041d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01041d9:	00 
c01041da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01041e4:	89 04 24             	mov    %eax,(%esp)
c01041e7:	e8 db ff ff ff       	call   c01041c7 <get_pte>
c01041ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01041ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01041f3:	74 08                	je     c01041fd <get_page+0x31>
        *ptep_store = ptep;
c01041f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01041f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01041fb:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01041fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104201:	74 1b                	je     c010421e <get_page+0x52>
c0104203:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104206:	8b 00                	mov    (%eax),%eax
c0104208:	83 e0 01             	and    $0x1,%eax
c010420b:	85 c0                	test   %eax,%eax
c010420d:	74 0f                	je     c010421e <get_page+0x52>
        return pte2page(*ptep);
c010420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104212:	8b 00                	mov    (%eax),%eax
c0104214:	89 04 24             	mov    %eax,(%esp)
c0104217:	e8 1e f6 ff ff       	call   c010383a <pte2page>
c010421c:	eb 05                	jmp    c0104223 <get_page+0x57>
    }
    return NULL;
c010421e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104223:	c9                   	leave  
c0104224:	c3                   	ret    

c0104225 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104225:	55                   	push   %ebp
c0104226:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104228:	5d                   	pop    %ebp
c0104229:	c3                   	ret    

c010422a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010422a:	55                   	push   %ebp
c010422b:	89 e5                	mov    %esp,%ebp
c010422d:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104230:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104237:	00 
c0104238:	8b 45 0c             	mov    0xc(%ebp),%eax
c010423b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010423f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104242:	89 04 24             	mov    %eax,(%esp)
c0104245:	e8 7d ff ff ff       	call   c01041c7 <get_pte>
c010424a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010424d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104251:	74 19                	je     c010426c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104253:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104256:	89 44 24 08          	mov    %eax,0x8(%esp)
c010425a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010425d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104261:	8b 45 08             	mov    0x8(%ebp),%eax
c0104264:	89 04 24             	mov    %eax,(%esp)
c0104267:	e8 b9 ff ff ff       	call   c0104225 <page_remove_pte>
    }
}
c010426c:	c9                   	leave  
c010426d:	c3                   	ret    

c010426e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010426e:	55                   	push   %ebp
c010426f:	89 e5                	mov    %esp,%ebp
c0104271:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104274:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010427b:	00 
c010427c:	8b 45 10             	mov    0x10(%ebp),%eax
c010427f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104283:	8b 45 08             	mov    0x8(%ebp),%eax
c0104286:	89 04 24             	mov    %eax,(%esp)
c0104289:	e8 39 ff ff ff       	call   c01041c7 <get_pte>
c010428e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104295:	75 0a                	jne    c01042a1 <page_insert+0x33>
        return -E_NO_MEM;
c0104297:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010429c:	e9 84 00 00 00       	jmp    c0104325 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01042a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042a4:	89 04 24             	mov    %eax,(%esp)
c01042a7:	e8 ee f5 ff ff       	call   c010389a <page_ref_inc>
    if (*ptep & PTE_P) {
c01042ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042af:	8b 00                	mov    (%eax),%eax
c01042b1:	83 e0 01             	and    $0x1,%eax
c01042b4:	85 c0                	test   %eax,%eax
c01042b6:	74 3e                	je     c01042f6 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042bb:	8b 00                	mov    (%eax),%eax
c01042bd:	89 04 24             	mov    %eax,(%esp)
c01042c0:	e8 75 f5 ff ff       	call   c010383a <pte2page>
c01042c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01042c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01042ce:	75 0d                	jne    c01042dd <page_insert+0x6f>
            page_ref_dec(page);
c01042d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042d3:	89 04 24             	mov    %eax,(%esp)
c01042d6:	e8 d6 f5 ff ff       	call   c01038b1 <page_ref_dec>
c01042db:	eb 19                	jmp    c01042f6 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01042dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01042e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01042e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ee:	89 04 24             	mov    %eax,(%esp)
c01042f1:	e8 2f ff ff ff       	call   c0104225 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01042f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042f9:	89 04 24             	mov    %eax,(%esp)
c01042fc:	e8 80 f4 ff ff       	call   c0103781 <page2pa>
c0104301:	0b 45 14             	or     0x14(%ebp),%eax
c0104304:	83 c8 01             	or     $0x1,%eax
c0104307:	89 c2                	mov    %eax,%edx
c0104309:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010430c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010430e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104311:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104315:	8b 45 08             	mov    0x8(%ebp),%eax
c0104318:	89 04 24             	mov    %eax,(%esp)
c010431b:	e8 07 00 00 00       	call   c0104327 <tlb_invalidate>
    return 0;
c0104320:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104325:	c9                   	leave  
c0104326:	c3                   	ret    

c0104327 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104327:	55                   	push   %ebp
c0104328:	89 e5                	mov    %esp,%ebp
c010432a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010432d:	0f 20 d8             	mov    %cr3,%eax
c0104330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104333:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104336:	89 c2                	mov    %eax,%edx
c0104338:	8b 45 08             	mov    0x8(%ebp),%eax
c010433b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010433e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104345:	77 23                	ja     c010436a <tlb_invalidate+0x43>
c0104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010434e:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0104355:	c0 
c0104356:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c010435d:	00 
c010435e:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104365:	e8 a2 c8 ff ff       	call   c0100c0c <__panic>
c010436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104372:	39 c2                	cmp    %eax,%edx
c0104374:	75 0c                	jne    c0104382 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104376:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104379:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010437c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010437f:	0f 01 38             	invlpg (%eax)
    }
}
c0104382:	c9                   	leave  
c0104383:	c3                   	ret    

c0104384 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104384:	55                   	push   %ebp
c0104385:	89 e5                	mov    %esp,%ebp
c0104387:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010438a:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010438f:	8b 40 18             	mov    0x18(%eax),%eax
c0104392:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104394:	c7 04 24 44 67 10 c0 	movl   $0xc0106744,(%esp)
c010439b:	e8 9c bf ff ff       	call   c010033c <cprintf>
}
c01043a0:	c9                   	leave  
c01043a1:	c3                   	ret    

c01043a2 <check_pgdir>:

static void
check_pgdir(void) {
c01043a2:	55                   	push   %ebp
c01043a3:	89 e5                	mov    %esp,%ebp
c01043a5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01043a8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01043ad:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01043b2:	76 24                	jbe    c01043d8 <check_pgdir+0x36>
c01043b4:	c7 44 24 0c 63 67 10 	movl   $0xc0106763,0xc(%esp)
c01043bb:	c0 
c01043bc:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01043c3:	c0 
c01043c4:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01043cb:	00 
c01043cc:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01043d3:	e8 34 c8 ff ff       	call   c0100c0c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01043d8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043dd:	85 c0                	test   %eax,%eax
c01043df:	74 0e                	je     c01043ef <check_pgdir+0x4d>
c01043e1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043e6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043eb:	85 c0                	test   %eax,%eax
c01043ed:	74 24                	je     c0104413 <check_pgdir+0x71>
c01043ef:	c7 44 24 0c 80 67 10 	movl   $0xc0106780,0xc(%esp)
c01043f6:	c0 
c01043f7:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01043fe:	c0 
c01043ff:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104406:	00 
c0104407:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c010440e:	e8 f9 c7 ff ff       	call   c0100c0c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104413:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104418:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010441f:	00 
c0104420:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104427:	00 
c0104428:	89 04 24             	mov    %eax,(%esp)
c010442b:	e8 9c fd ff ff       	call   c01041cc <get_page>
c0104430:	85 c0                	test   %eax,%eax
c0104432:	74 24                	je     c0104458 <check_pgdir+0xb6>
c0104434:	c7 44 24 0c b8 67 10 	movl   $0xc01067b8,0xc(%esp)
c010443b:	c0 
c010443c:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104443:	c0 
c0104444:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c010444b:	00 
c010444c:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104453:	e8 b4 c7 ff ff       	call   c0100c0c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104458:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010445f:	e8 24 f6 ff ff       	call   c0103a88 <alloc_pages>
c0104464:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104467:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010446c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104473:	00 
c0104474:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010447b:	00 
c010447c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010447f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104483:	89 04 24             	mov    %eax,(%esp)
c0104486:	e8 e3 fd ff ff       	call   c010426e <page_insert>
c010448b:	85 c0                	test   %eax,%eax
c010448d:	74 24                	je     c01044b3 <check_pgdir+0x111>
c010448f:	c7 44 24 0c e0 67 10 	movl   $0xc01067e0,0xc(%esp)
c0104496:	c0 
c0104497:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c010449e:	c0 
c010449f:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01044a6:	00 
c01044a7:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01044ae:	e8 59 c7 ff ff       	call   c0100c0c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01044b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044bf:	00 
c01044c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044c7:	00 
c01044c8:	89 04 24             	mov    %eax,(%esp)
c01044cb:	e8 f7 fc ff ff       	call   c01041c7 <get_pte>
c01044d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044d7:	75 24                	jne    c01044fd <check_pgdir+0x15b>
c01044d9:	c7 44 24 0c 0c 68 10 	movl   $0xc010680c,0xc(%esp)
c01044e0:	c0 
c01044e1:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01044e8:	c0 
c01044e9:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c01044f0:	00 
c01044f1:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01044f8:	e8 0f c7 ff ff       	call   c0100c0c <__panic>
    assert(pte2page(*ptep) == p1);
c01044fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104500:	8b 00                	mov    (%eax),%eax
c0104502:	89 04 24             	mov    %eax,(%esp)
c0104505:	e8 30 f3 ff ff       	call   c010383a <pte2page>
c010450a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010450d:	74 24                	je     c0104533 <check_pgdir+0x191>
c010450f:	c7 44 24 0c 39 68 10 	movl   $0xc0106839,0xc(%esp)
c0104516:	c0 
c0104517:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c010451e:	c0 
c010451f:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104526:	00 
c0104527:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c010452e:	e8 d9 c6 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p1) == 1);
c0104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104536:	89 04 24             	mov    %eax,(%esp)
c0104539:	e8 52 f3 ff ff       	call   c0103890 <page_ref>
c010453e:	83 f8 01             	cmp    $0x1,%eax
c0104541:	74 24                	je     c0104567 <check_pgdir+0x1c5>
c0104543:	c7 44 24 0c 4f 68 10 	movl   $0xc010684f,0xc(%esp)
c010454a:	c0 
c010454b:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104552:	c0 
c0104553:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c010455a:	00 
c010455b:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104562:	e8 a5 c6 ff ff       	call   c0100c0c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104567:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010456c:	8b 00                	mov    (%eax),%eax
c010456e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104573:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104576:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104579:	c1 e8 0c             	shr    $0xc,%eax
c010457c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010457f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104584:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104587:	72 23                	jb     c01045ac <check_pgdir+0x20a>
c0104589:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010458c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104590:	c7 44 24 08 1c 66 10 	movl   $0xc010661c,0x8(%esp)
c0104597:	c0 
c0104598:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c010459f:	00 
c01045a0:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01045a7:	e8 60 c6 ff ff       	call   c0100c0c <__panic>
c01045ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045af:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045b4:	83 c0 04             	add    $0x4,%eax
c01045b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01045ba:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045c6:	00 
c01045c7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01045ce:	00 
c01045cf:	89 04 24             	mov    %eax,(%esp)
c01045d2:	e8 f0 fb ff ff       	call   c01041c7 <get_pte>
c01045d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01045da:	74 24                	je     c0104600 <check_pgdir+0x25e>
c01045dc:	c7 44 24 0c 64 68 10 	movl   $0xc0106864,0xc(%esp)
c01045e3:	c0 
c01045e4:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01045eb:	c0 
c01045ec:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c01045f3:	00 
c01045f4:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01045fb:	e8 0c c6 ff ff       	call   c0100c0c <__panic>

    p2 = alloc_page();
c0104600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104607:	e8 7c f4 ff ff       	call   c0103a88 <alloc_pages>
c010460c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010460f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104614:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010461b:	00 
c010461c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104623:	00 
c0104624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104627:	89 54 24 04          	mov    %edx,0x4(%esp)
c010462b:	89 04 24             	mov    %eax,(%esp)
c010462e:	e8 3b fc ff ff       	call   c010426e <page_insert>
c0104633:	85 c0                	test   %eax,%eax
c0104635:	74 24                	je     c010465b <check_pgdir+0x2b9>
c0104637:	c7 44 24 0c 8c 68 10 	movl   $0xc010688c,0xc(%esp)
c010463e:	c0 
c010463f:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104646:	c0 
c0104647:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c010464e:	00 
c010464f:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104656:	e8 b1 c5 ff ff       	call   c0100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010465b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104660:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104667:	00 
c0104668:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010466f:	00 
c0104670:	89 04 24             	mov    %eax,(%esp)
c0104673:	e8 4f fb ff ff       	call   c01041c7 <get_pte>
c0104678:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010467b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010467f:	75 24                	jne    c01046a5 <check_pgdir+0x303>
c0104681:	c7 44 24 0c c4 68 10 	movl   $0xc01068c4,0xc(%esp)
c0104688:	c0 
c0104689:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104690:	c0 
c0104691:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104698:	00 
c0104699:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01046a0:	e8 67 c5 ff ff       	call   c0100c0c <__panic>
    assert(*ptep & PTE_U);
c01046a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a8:	8b 00                	mov    (%eax),%eax
c01046aa:	83 e0 04             	and    $0x4,%eax
c01046ad:	85 c0                	test   %eax,%eax
c01046af:	75 24                	jne    c01046d5 <check_pgdir+0x333>
c01046b1:	c7 44 24 0c f4 68 10 	movl   $0xc01068f4,0xc(%esp)
c01046b8:	c0 
c01046b9:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01046c0:	c0 
c01046c1:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01046c8:	00 
c01046c9:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01046d0:	e8 37 c5 ff ff       	call   c0100c0c <__panic>
    assert(*ptep & PTE_W);
c01046d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d8:	8b 00                	mov    (%eax),%eax
c01046da:	83 e0 02             	and    $0x2,%eax
c01046dd:	85 c0                	test   %eax,%eax
c01046df:	75 24                	jne    c0104705 <check_pgdir+0x363>
c01046e1:	c7 44 24 0c 02 69 10 	movl   $0xc0106902,0xc(%esp)
c01046e8:	c0 
c01046e9:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01046f0:	c0 
c01046f1:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c01046f8:	00 
c01046f9:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104700:	e8 07 c5 ff ff       	call   c0100c0c <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104705:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010470a:	8b 00                	mov    (%eax),%eax
c010470c:	83 e0 04             	and    $0x4,%eax
c010470f:	85 c0                	test   %eax,%eax
c0104711:	75 24                	jne    c0104737 <check_pgdir+0x395>
c0104713:	c7 44 24 0c 10 69 10 	movl   $0xc0106910,0xc(%esp)
c010471a:	c0 
c010471b:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104722:	c0 
c0104723:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c010472a:	00 
c010472b:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104732:	e8 d5 c4 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 1);
c0104737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010473a:	89 04 24             	mov    %eax,(%esp)
c010473d:	e8 4e f1 ff ff       	call   c0103890 <page_ref>
c0104742:	83 f8 01             	cmp    $0x1,%eax
c0104745:	74 24                	je     c010476b <check_pgdir+0x3c9>
c0104747:	c7 44 24 0c 26 69 10 	movl   $0xc0106926,0xc(%esp)
c010474e:	c0 
c010474f:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104756:	c0 
c0104757:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c010475e:	00 
c010475f:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104766:	e8 a1 c4 ff ff       	call   c0100c0c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010476b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104770:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104777:	00 
c0104778:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010477f:	00 
c0104780:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104783:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104787:	89 04 24             	mov    %eax,(%esp)
c010478a:	e8 df fa ff ff       	call   c010426e <page_insert>
c010478f:	85 c0                	test   %eax,%eax
c0104791:	74 24                	je     c01047b7 <check_pgdir+0x415>
c0104793:	c7 44 24 0c 38 69 10 	movl   $0xc0106938,0xc(%esp)
c010479a:	c0 
c010479b:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01047a2:	c0 
c01047a3:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01047aa:	00 
c01047ab:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01047b2:	e8 55 c4 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p1) == 2);
c01047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ba:	89 04 24             	mov    %eax,(%esp)
c01047bd:	e8 ce f0 ff ff       	call   c0103890 <page_ref>
c01047c2:	83 f8 02             	cmp    $0x2,%eax
c01047c5:	74 24                	je     c01047eb <check_pgdir+0x449>
c01047c7:	c7 44 24 0c 64 69 10 	movl   $0xc0106964,0xc(%esp)
c01047ce:	c0 
c01047cf:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01047d6:	c0 
c01047d7:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01047de:	00 
c01047df:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01047e6:	e8 21 c4 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c01047eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ee:	89 04 24             	mov    %eax,(%esp)
c01047f1:	e8 9a f0 ff ff       	call   c0103890 <page_ref>
c01047f6:	85 c0                	test   %eax,%eax
c01047f8:	74 24                	je     c010481e <check_pgdir+0x47c>
c01047fa:	c7 44 24 0c 76 69 10 	movl   $0xc0106976,0xc(%esp)
c0104801:	c0 
c0104802:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104809:	c0 
c010480a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104811:	00 
c0104812:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104819:	e8 ee c3 ff ff       	call   c0100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010481e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104823:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010482a:	00 
c010482b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104832:	00 
c0104833:	89 04 24             	mov    %eax,(%esp)
c0104836:	e8 8c f9 ff ff       	call   c01041c7 <get_pte>
c010483b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010483e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104842:	75 24                	jne    c0104868 <check_pgdir+0x4c6>
c0104844:	c7 44 24 0c c4 68 10 	movl   $0xc01068c4,0xc(%esp)
c010484b:	c0 
c010484c:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104853:	c0 
c0104854:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010485b:	00 
c010485c:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104863:	e8 a4 c3 ff ff       	call   c0100c0c <__panic>
    assert(pte2page(*ptep) == p1);
c0104868:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010486b:	8b 00                	mov    (%eax),%eax
c010486d:	89 04 24             	mov    %eax,(%esp)
c0104870:	e8 c5 ef ff ff       	call   c010383a <pte2page>
c0104875:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104878:	74 24                	je     c010489e <check_pgdir+0x4fc>
c010487a:	c7 44 24 0c 39 68 10 	movl   $0xc0106839,0xc(%esp)
c0104881:	c0 
c0104882:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104889:	c0 
c010488a:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104891:	00 
c0104892:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104899:	e8 6e c3 ff ff       	call   c0100c0c <__panic>
    assert((*ptep & PTE_U) == 0);
c010489e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a1:	8b 00                	mov    (%eax),%eax
c01048a3:	83 e0 04             	and    $0x4,%eax
c01048a6:	85 c0                	test   %eax,%eax
c01048a8:	74 24                	je     c01048ce <check_pgdir+0x52c>
c01048aa:	c7 44 24 0c 88 69 10 	movl   $0xc0106988,0xc(%esp)
c01048b1:	c0 
c01048b2:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01048b9:	c0 
c01048ba:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01048c1:	00 
c01048c2:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01048c9:	e8 3e c3 ff ff       	call   c0100c0c <__panic>

    page_remove(boot_pgdir, 0x0);
c01048ce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048da:	00 
c01048db:	89 04 24             	mov    %eax,(%esp)
c01048de:	e8 47 f9 ff ff       	call   c010422a <page_remove>
    assert(page_ref(p1) == 1);
c01048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e6:	89 04 24             	mov    %eax,(%esp)
c01048e9:	e8 a2 ef ff ff       	call   c0103890 <page_ref>
c01048ee:	83 f8 01             	cmp    $0x1,%eax
c01048f1:	74 24                	je     c0104917 <check_pgdir+0x575>
c01048f3:	c7 44 24 0c 4f 68 10 	movl   $0xc010684f,0xc(%esp)
c01048fa:	c0 
c01048fb:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104902:	c0 
c0104903:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010490a:	00 
c010490b:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104912:	e8 f5 c2 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c0104917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010491a:	89 04 24             	mov    %eax,(%esp)
c010491d:	e8 6e ef ff ff       	call   c0103890 <page_ref>
c0104922:	85 c0                	test   %eax,%eax
c0104924:	74 24                	je     c010494a <check_pgdir+0x5a8>
c0104926:	c7 44 24 0c 76 69 10 	movl   $0xc0106976,0xc(%esp)
c010492d:	c0 
c010492e:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104935:	c0 
c0104936:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c010493d:	00 
c010493e:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104945:	e8 c2 c2 ff ff       	call   c0100c0c <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010494a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010494f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104956:	00 
c0104957:	89 04 24             	mov    %eax,(%esp)
c010495a:	e8 cb f8 ff ff       	call   c010422a <page_remove>
    assert(page_ref(p1) == 0);
c010495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104962:	89 04 24             	mov    %eax,(%esp)
c0104965:	e8 26 ef ff ff       	call   c0103890 <page_ref>
c010496a:	85 c0                	test   %eax,%eax
c010496c:	74 24                	je     c0104992 <check_pgdir+0x5f0>
c010496e:	c7 44 24 0c 9d 69 10 	movl   $0xc010699d,0xc(%esp)
c0104975:	c0 
c0104976:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c010497d:	c0 
c010497e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104985:	00 
c0104986:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c010498d:	e8 7a c2 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c0104992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104995:	89 04 24             	mov    %eax,(%esp)
c0104998:	e8 f3 ee ff ff       	call   c0103890 <page_ref>
c010499d:	85 c0                	test   %eax,%eax
c010499f:	74 24                	je     c01049c5 <check_pgdir+0x623>
c01049a1:	c7 44 24 0c 76 69 10 	movl   $0xc0106976,0xc(%esp)
c01049a8:	c0 
c01049a9:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01049b0:	c0 
c01049b1:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01049b8:	00 
c01049b9:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c01049c0:	e8 47 c2 ff ff       	call   c0100c0c <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01049c5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049ca:	8b 00                	mov    (%eax),%eax
c01049cc:	89 04 24             	mov    %eax,(%esp)
c01049cf:	e8 a4 ee ff ff       	call   c0103878 <pde2page>
c01049d4:	89 04 24             	mov    %eax,(%esp)
c01049d7:	e8 b4 ee ff ff       	call   c0103890 <page_ref>
c01049dc:	83 f8 01             	cmp    $0x1,%eax
c01049df:	74 24                	je     c0104a05 <check_pgdir+0x663>
c01049e1:	c7 44 24 0c b0 69 10 	movl   $0xc01069b0,0xc(%esp)
c01049e8:	c0 
c01049e9:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01049f8:	00 
c01049f9:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104a00:	e8 07 c2 ff ff       	call   c0100c0c <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104a05:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a0a:	8b 00                	mov    (%eax),%eax
c0104a0c:	89 04 24             	mov    %eax,(%esp)
c0104a0f:	e8 64 ee ff ff       	call   c0103878 <pde2page>
c0104a14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a1b:	00 
c0104a1c:	89 04 24             	mov    %eax,(%esp)
c0104a1f:	e8 9c f0 ff ff       	call   c0103ac0 <free_pages>
    boot_pgdir[0] = 0;
c0104a24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104a2f:	c7 04 24 d7 69 10 c0 	movl   $0xc01069d7,(%esp)
c0104a36:	e8 01 b9 ff ff       	call   c010033c <cprintf>
}
c0104a3b:	c9                   	leave  
c0104a3c:	c3                   	ret    

c0104a3d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104a3d:	55                   	push   %ebp
c0104a3e:	89 e5                	mov    %esp,%ebp
c0104a40:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a4a:	e9 ca 00 00 00       	jmp    c0104b19 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a58:	c1 e8 0c             	shr    $0xc,%eax
c0104a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a5e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104a63:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104a66:	72 23                	jb     c0104a8b <check_boot_pgdir+0x4e>
c0104a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a6f:	c7 44 24 08 1c 66 10 	movl   $0xc010661c,0x8(%esp)
c0104a76:	c0 
c0104a77:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104a7e:	00 
c0104a7f:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104a86:	e8 81 c1 ff ff       	call   c0100c0c <__panic>
c0104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a8e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a93:	89 c2                	mov    %eax,%edx
c0104a95:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aa1:	00 
c0104aa2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104aa6:	89 04 24             	mov    %eax,(%esp)
c0104aa9:	e8 19 f7 ff ff       	call   c01041c7 <get_pte>
c0104aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ab1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ab5:	75 24                	jne    c0104adb <check_boot_pgdir+0x9e>
c0104ab7:	c7 44 24 0c f4 69 10 	movl   $0xc01069f4,0xc(%esp)
c0104abe:	c0 
c0104abf:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104ac6:	c0 
c0104ac7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104ace:	00 
c0104acf:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104ad6:	e8 31 c1 ff ff       	call   c0100c0c <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ade:	8b 00                	mov    (%eax),%eax
c0104ae0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ae5:	89 c2                	mov    %eax,%edx
c0104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aea:	39 c2                	cmp    %eax,%edx
c0104aec:	74 24                	je     c0104b12 <check_boot_pgdir+0xd5>
c0104aee:	c7 44 24 0c 31 6a 10 	movl   $0xc0106a31,0xc(%esp)
c0104af5:	c0 
c0104af6:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104afd:	c0 
c0104afe:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104b05:	00 
c0104b06:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104b0d:	e8 fa c0 ff ff       	call   c0100c0c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104b12:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b1c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104b21:	39 c2                	cmp    %eax,%edx
c0104b23:	0f 82 26 ff ff ff    	jb     c0104a4f <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104b29:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b2e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104b33:	8b 00                	mov    (%eax),%eax
c0104b35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b3a:	89 c2                	mov    %eax,%edx
c0104b3c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b44:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104b4b:	77 23                	ja     c0104b70 <check_boot_pgdir+0x133>
c0104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b50:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b54:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0104b5b:	c0 
c0104b5c:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104b63:	00 
c0104b64:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104b6b:	e8 9c c0 ff ff       	call   c0100c0c <__panic>
c0104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b73:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b78:	39 c2                	cmp    %eax,%edx
c0104b7a:	74 24                	je     c0104ba0 <check_boot_pgdir+0x163>
c0104b7c:	c7 44 24 0c 48 6a 10 	movl   $0xc0106a48,0xc(%esp)
c0104b83:	c0 
c0104b84:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104b8b:	c0 
c0104b8c:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104b93:	00 
c0104b94:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104b9b:	e8 6c c0 ff ff       	call   c0100c0c <__panic>

    assert(boot_pgdir[0] == 0);
c0104ba0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ba5:	8b 00                	mov    (%eax),%eax
c0104ba7:	85 c0                	test   %eax,%eax
c0104ba9:	74 24                	je     c0104bcf <check_boot_pgdir+0x192>
c0104bab:	c7 44 24 0c 7c 6a 10 	movl   $0xc0106a7c,0xc(%esp)
c0104bb2:	c0 
c0104bb3:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104bba:	c0 
c0104bbb:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104bc2:	00 
c0104bc3:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104bca:	e8 3d c0 ff ff       	call   c0100c0c <__panic>

    struct Page *p;
    p = alloc_page();
c0104bcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bd6:	e8 ad ee ff ff       	call   c0103a88 <alloc_pages>
c0104bdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104bde:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104be3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104bea:	00 
c0104beb:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104bf2:	00 
c0104bf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bfa:	89 04 24             	mov    %eax,(%esp)
c0104bfd:	e8 6c f6 ff ff       	call   c010426e <page_insert>
c0104c02:	85 c0                	test   %eax,%eax
c0104c04:	74 24                	je     c0104c2a <check_boot_pgdir+0x1ed>
c0104c06:	c7 44 24 0c 90 6a 10 	movl   $0xc0106a90,0xc(%esp)
c0104c0d:	c0 
c0104c0e:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104c15:	c0 
c0104c16:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104c1d:	00 
c0104c1e:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104c25:	e8 e2 bf ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p) == 1);
c0104c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c2d:	89 04 24             	mov    %eax,(%esp)
c0104c30:	e8 5b ec ff ff       	call   c0103890 <page_ref>
c0104c35:	83 f8 01             	cmp    $0x1,%eax
c0104c38:	74 24                	je     c0104c5e <check_boot_pgdir+0x221>
c0104c3a:	c7 44 24 0c be 6a 10 	movl   $0xc0106abe,0xc(%esp)
c0104c41:	c0 
c0104c42:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104c49:	c0 
c0104c4a:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104c51:	00 
c0104c52:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104c59:	e8 ae bf ff ff       	call   c0100c0c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104c5e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c63:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104c6a:	00 
c0104c6b:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104c72:	00 
c0104c73:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104c76:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c7a:	89 04 24             	mov    %eax,(%esp)
c0104c7d:	e8 ec f5 ff ff       	call   c010426e <page_insert>
c0104c82:	85 c0                	test   %eax,%eax
c0104c84:	74 24                	je     c0104caa <check_boot_pgdir+0x26d>
c0104c86:	c7 44 24 0c d0 6a 10 	movl   $0xc0106ad0,0xc(%esp)
c0104c8d:	c0 
c0104c8e:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104c95:	c0 
c0104c96:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104c9d:	00 
c0104c9e:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104ca5:	e8 62 bf ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p) == 2);
c0104caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cad:	89 04 24             	mov    %eax,(%esp)
c0104cb0:	e8 db eb ff ff       	call   c0103890 <page_ref>
c0104cb5:	83 f8 02             	cmp    $0x2,%eax
c0104cb8:	74 24                	je     c0104cde <check_boot_pgdir+0x2a1>
c0104cba:	c7 44 24 0c 07 6b 10 	movl   $0xc0106b07,0xc(%esp)
c0104cc1:	c0 
c0104cc2:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104cc9:	c0 
c0104cca:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104cd1:	00 
c0104cd2:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104cd9:	e8 2e bf ff ff       	call   c0100c0c <__panic>

    const char *str = "ucore: Hello world!!";
c0104cde:	c7 45 dc 18 6b 10 c0 	movl   $0xc0106b18,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104cf3:	e8 19 0a 00 00       	call   c0105711 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104cf8:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104cff:	00 
c0104d00:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104d07:	e8 7e 0a 00 00       	call   c010578a <strcmp>
c0104d0c:	85 c0                	test   %eax,%eax
c0104d0e:	74 24                	je     c0104d34 <check_boot_pgdir+0x2f7>
c0104d10:	c7 44 24 0c 30 6b 10 	movl   $0xc0106b30,0xc(%esp)
c0104d17:	c0 
c0104d18:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104d1f:	c0 
c0104d20:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104d27:	00 
c0104d28:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104d2f:	e8 d8 be ff ff       	call   c0100c0c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d37:	89 04 24             	mov    %eax,(%esp)
c0104d3a:	e8 a7 ea ff ff       	call   c01037e6 <page2kva>
c0104d3f:	05 00 01 00 00       	add    $0x100,%eax
c0104d44:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104d47:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104d4e:	e8 66 09 00 00       	call   c01056b9 <strlen>
c0104d53:	85 c0                	test   %eax,%eax
c0104d55:	74 24                	je     c0104d7b <check_boot_pgdir+0x33e>
c0104d57:	c7 44 24 0c 68 6b 10 	movl   $0xc0106b68,0xc(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 08 09 67 10 	movl   $0xc0106709,0x8(%esp)
c0104d66:	c0 
c0104d67:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104d6e:	00 
c0104d6f:	c7 04 24 e4 66 10 c0 	movl   $0xc01066e4,(%esp)
c0104d76:	e8 91 be ff ff       	call   c0100c0c <__panic>

    free_page(p);
c0104d7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d82:	00 
c0104d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d86:	89 04 24             	mov    %eax,(%esp)
c0104d89:	e8 32 ed ff ff       	call   c0103ac0 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104d8e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d93:	8b 00                	mov    (%eax),%eax
c0104d95:	89 04 24             	mov    %eax,(%esp)
c0104d98:	e8 db ea ff ff       	call   c0103878 <pde2page>
c0104d9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104da4:	00 
c0104da5:	89 04 24             	mov    %eax,(%esp)
c0104da8:	e8 13 ed ff ff       	call   c0103ac0 <free_pages>
    boot_pgdir[0] = 0;
c0104dad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104db8:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104dbf:	e8 78 b5 ff ff       	call   c010033c <cprintf>
}
c0104dc4:	c9                   	leave  
c0104dc5:	c3                   	ret    

c0104dc6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104dc6:	55                   	push   %ebp
c0104dc7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dcc:	83 e0 04             	and    $0x4,%eax
c0104dcf:	85 c0                	test   %eax,%eax
c0104dd1:	74 07                	je     c0104dda <perm2str+0x14>
c0104dd3:	b8 75 00 00 00       	mov    $0x75,%eax
c0104dd8:	eb 05                	jmp    c0104ddf <perm2str+0x19>
c0104dda:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104ddf:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0104de4:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dee:	83 e0 02             	and    $0x2,%eax
c0104df1:	85 c0                	test   %eax,%eax
c0104df3:	74 07                	je     c0104dfc <perm2str+0x36>
c0104df5:	b8 77 00 00 00       	mov    $0x77,%eax
c0104dfa:	eb 05                	jmp    c0104e01 <perm2str+0x3b>
c0104dfc:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104e01:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0104e06:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0104e0d:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0104e12:	5d                   	pop    %ebp
c0104e13:	c3                   	ret    

c0104e14 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104e14:	55                   	push   %ebp
c0104e15:	89 e5                	mov    %esp,%ebp
c0104e17:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104e1a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e20:	72 0a                	jb     c0104e2c <get_pgtable_items+0x18>
        return 0;
c0104e22:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e27:	e9 9c 00 00 00       	jmp    c0104ec8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0104e2c:	eb 04                	jmp    c0104e32 <get_pgtable_items+0x1e>
        start ++;
c0104e2e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0104e32:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e35:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e38:	73 18                	jae    c0104e52 <get_pgtable_items+0x3e>
c0104e3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e44:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e47:	01 d0                	add    %edx,%eax
c0104e49:	8b 00                	mov    (%eax),%eax
c0104e4b:	83 e0 01             	and    $0x1,%eax
c0104e4e:	85 c0                	test   %eax,%eax
c0104e50:	74 dc                	je     c0104e2e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0104e52:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e55:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e58:	73 69                	jae    c0104ec3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104e5a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104e5e:	74 08                	je     c0104e68 <get_pgtable_items+0x54>
            *left_store = start;
c0104e60:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e63:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e66:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104e68:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e6b:	8d 50 01             	lea    0x1(%eax),%edx
c0104e6e:	89 55 10             	mov    %edx,0x10(%ebp)
c0104e71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e78:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e7b:	01 d0                	add    %edx,%eax
c0104e7d:	8b 00                	mov    (%eax),%eax
c0104e7f:	83 e0 07             	and    $0x7,%eax
c0104e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e85:	eb 04                	jmp    c0104e8b <get_pgtable_items+0x77>
            start ++;
c0104e87:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e91:	73 1d                	jae    c0104eb0 <get_pgtable_items+0x9c>
c0104e93:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e9d:	8b 45 14             	mov    0x14(%ebp),%eax
c0104ea0:	01 d0                	add    %edx,%eax
c0104ea2:	8b 00                	mov    (%eax),%eax
c0104ea4:	83 e0 07             	and    $0x7,%eax
c0104ea7:	89 c2                	mov    %eax,%edx
c0104ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104eac:	39 c2                	cmp    %eax,%edx
c0104eae:	74 d7                	je     c0104e87 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0104eb0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104eb4:	74 08                	je     c0104ebe <get_pgtable_items+0xaa>
            *right_store = start;
c0104eb6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104eb9:	8b 55 10             	mov    0x10(%ebp),%edx
c0104ebc:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104ec1:	eb 05                	jmp    c0104ec8 <get_pgtable_items+0xb4>
    }
    return 0;
c0104ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec8:	c9                   	leave  
c0104ec9:	c3                   	ret    

c0104eca <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104eca:	55                   	push   %ebp
c0104ecb:	89 e5                	mov    %esp,%ebp
c0104ecd:	57                   	push   %edi
c0104ece:	56                   	push   %esi
c0104ecf:	53                   	push   %ebx
c0104ed0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104ed3:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104eda:	e8 5d b4 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0104edf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104ee6:	e9 fa 00 00 00       	jmp    c0104fe5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104eeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eee:	89 04 24             	mov    %eax,(%esp)
c0104ef1:	e8 d0 fe ff ff       	call   c0104dc6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104ef6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104ef9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104efc:	29 d1                	sub    %edx,%ecx
c0104efe:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104f00:	89 d6                	mov    %edx,%esi
c0104f02:	c1 e6 16             	shl    $0x16,%esi
c0104f05:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f08:	89 d3                	mov    %edx,%ebx
c0104f0a:	c1 e3 16             	shl    $0x16,%ebx
c0104f0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f10:	89 d1                	mov    %edx,%ecx
c0104f12:	c1 e1 16             	shl    $0x16,%ecx
c0104f15:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104f18:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f1b:	29 d7                	sub    %edx,%edi
c0104f1d:	89 fa                	mov    %edi,%edx
c0104f1f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104f23:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104f27:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104f2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104f2f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f33:	c7 04 24 dd 6b 10 c0 	movl   $0xc0106bdd,(%esp)
c0104f3a:	e8 fd b3 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f42:	c1 e0 0a             	shl    $0xa,%eax
c0104f45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f48:	eb 54                	jmp    c0104f9e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f4d:	89 04 24             	mov    %eax,(%esp)
c0104f50:	e8 71 fe ff ff       	call   c0104dc6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104f55:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104f58:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f5b:	29 d1                	sub    %edx,%ecx
c0104f5d:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f5f:	89 d6                	mov    %edx,%esi
c0104f61:	c1 e6 0c             	shl    $0xc,%esi
c0104f64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f67:	89 d3                	mov    %edx,%ebx
c0104f69:	c1 e3 0c             	shl    $0xc,%ebx
c0104f6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f6f:	c1 e2 0c             	shl    $0xc,%edx
c0104f72:	89 d1                	mov    %edx,%ecx
c0104f74:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104f77:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f7a:	29 d7                	sub    %edx,%edi
c0104f7c:	89 fa                	mov    %edi,%edx
c0104f7e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104f82:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104f86:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104f8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104f8e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f92:	c7 04 24 fc 6b 10 c0 	movl   $0xc0106bfc,(%esp)
c0104f99:	e8 9e b3 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f9e:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0104fa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fa6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104fa9:	89 ce                	mov    %ecx,%esi
c0104fab:	c1 e6 0a             	shl    $0xa,%esi
c0104fae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104fb1:	89 cb                	mov    %ecx,%ebx
c0104fb3:	c1 e3 0a             	shl    $0xa,%ebx
c0104fb6:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0104fb9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0104fbd:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0104fc0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0104fc4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104fcc:	89 74 24 04          	mov    %esi,0x4(%esp)
c0104fd0:	89 1c 24             	mov    %ebx,(%esp)
c0104fd3:	e8 3c fe ff ff       	call   c0104e14 <get_pgtable_items>
c0104fd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104fdf:	0f 85 65 ff ff ff    	jne    c0104f4a <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104fe5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0104fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fed:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0104ff0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0104ff4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0104ff7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0104ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104fff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105003:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010500a:	00 
c010500b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105012:	e8 fd fd ff ff       	call   c0104e14 <get_pgtable_items>
c0105017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010501a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010501e:	0f 85 c7 fe ff ff    	jne    c0104eeb <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105024:	c7 04 24 20 6c 10 c0 	movl   $0xc0106c20,(%esp)
c010502b:	e8 0c b3 ff ff       	call   c010033c <cprintf>
}
c0105030:	83 c4 4c             	add    $0x4c,%esp
c0105033:	5b                   	pop    %ebx
c0105034:	5e                   	pop    %esi
c0105035:	5f                   	pop    %edi
c0105036:	5d                   	pop    %ebp
c0105037:	c3                   	ret    

c0105038 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105038:	55                   	push   %ebp
c0105039:	89 e5                	mov    %esp,%ebp
c010503b:	83 ec 58             	sub    $0x58,%esp
c010503e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105041:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105044:	8b 45 14             	mov    0x14(%ebp),%eax
c0105047:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010504a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010504d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105050:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105053:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105056:	8b 45 18             	mov    0x18(%ebp),%eax
c0105059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010505c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010505f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105062:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105065:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105068:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010506b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010506e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105072:	74 1c                	je     c0105090 <printnum+0x58>
c0105074:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105077:	ba 00 00 00 00       	mov    $0x0,%edx
c010507c:	f7 75 e4             	divl   -0x1c(%ebp)
c010507f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105082:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105085:	ba 00 00 00 00       	mov    $0x0,%edx
c010508a:	f7 75 e4             	divl   -0x1c(%ebp)
c010508d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105090:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105093:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105096:	f7 75 e4             	divl   -0x1c(%ebp)
c0105099:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010509c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010509f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01050ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01050b1:	8b 45 18             	mov    0x18(%ebp),%eax
c01050b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01050b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050bc:	77 56                	ja     c0105114 <printnum+0xdc>
c01050be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050c1:	72 05                	jb     c01050c8 <printnum+0x90>
c01050c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01050c6:	77 4c                	ja     c0105114 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01050c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01050cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01050ce:	8b 45 20             	mov    0x20(%ebp),%eax
c01050d1:	89 44 24 18          	mov    %eax,0x18(%esp)
c01050d5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01050d9:	8b 45 18             	mov    0x18(%ebp),%eax
c01050dc:	89 44 24 10          	mov    %eax,0x10(%esp)
c01050e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01050ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f8:	89 04 24             	mov    %eax,(%esp)
c01050fb:	e8 38 ff ff ff       	call   c0105038 <printnum>
c0105100:	eb 1c                	jmp    c010511e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105102:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105105:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105109:	8b 45 20             	mov    0x20(%ebp),%eax
c010510c:	89 04 24             	mov    %eax,(%esp)
c010510f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105112:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105114:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105118:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010511c:	7f e4                	jg     c0105102 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010511e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105121:	05 d4 6c 10 c0       	add    $0xc0106cd4,%eax
c0105126:	0f b6 00             	movzbl (%eax),%eax
c0105129:	0f be c0             	movsbl %al,%eax
c010512c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010512f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105133:	89 04 24             	mov    %eax,(%esp)
c0105136:	8b 45 08             	mov    0x8(%ebp),%eax
c0105139:	ff d0                	call   *%eax
}
c010513b:	c9                   	leave  
c010513c:	c3                   	ret    

c010513d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010513d:	55                   	push   %ebp
c010513e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105140:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105144:	7e 14                	jle    c010515a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105146:	8b 45 08             	mov    0x8(%ebp),%eax
c0105149:	8b 00                	mov    (%eax),%eax
c010514b:	8d 48 08             	lea    0x8(%eax),%ecx
c010514e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105151:	89 0a                	mov    %ecx,(%edx)
c0105153:	8b 50 04             	mov    0x4(%eax),%edx
c0105156:	8b 00                	mov    (%eax),%eax
c0105158:	eb 30                	jmp    c010518a <getuint+0x4d>
    }
    else if (lflag) {
c010515a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010515e:	74 16                	je     c0105176 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105160:	8b 45 08             	mov    0x8(%ebp),%eax
c0105163:	8b 00                	mov    (%eax),%eax
c0105165:	8d 48 04             	lea    0x4(%eax),%ecx
c0105168:	8b 55 08             	mov    0x8(%ebp),%edx
c010516b:	89 0a                	mov    %ecx,(%edx)
c010516d:	8b 00                	mov    (%eax),%eax
c010516f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105174:	eb 14                	jmp    c010518a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105176:	8b 45 08             	mov    0x8(%ebp),%eax
c0105179:	8b 00                	mov    (%eax),%eax
c010517b:	8d 48 04             	lea    0x4(%eax),%ecx
c010517e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105181:	89 0a                	mov    %ecx,(%edx)
c0105183:	8b 00                	mov    (%eax),%eax
c0105185:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010518a:	5d                   	pop    %ebp
c010518b:	c3                   	ret    

c010518c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010518c:	55                   	push   %ebp
c010518d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010518f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105193:	7e 14                	jle    c01051a9 <getint+0x1d>
        return va_arg(*ap, long long);
c0105195:	8b 45 08             	mov    0x8(%ebp),%eax
c0105198:	8b 00                	mov    (%eax),%eax
c010519a:	8d 48 08             	lea    0x8(%eax),%ecx
c010519d:	8b 55 08             	mov    0x8(%ebp),%edx
c01051a0:	89 0a                	mov    %ecx,(%edx)
c01051a2:	8b 50 04             	mov    0x4(%eax),%edx
c01051a5:	8b 00                	mov    (%eax),%eax
c01051a7:	eb 28                	jmp    c01051d1 <getint+0x45>
    }
    else if (lflag) {
c01051a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01051ad:	74 12                	je     c01051c1 <getint+0x35>
        return va_arg(*ap, long);
c01051af:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b2:	8b 00                	mov    (%eax),%eax
c01051b4:	8d 48 04             	lea    0x4(%eax),%ecx
c01051b7:	8b 55 08             	mov    0x8(%ebp),%edx
c01051ba:	89 0a                	mov    %ecx,(%edx)
c01051bc:	8b 00                	mov    (%eax),%eax
c01051be:	99                   	cltd   
c01051bf:	eb 10                	jmp    c01051d1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01051c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c4:	8b 00                	mov    (%eax),%eax
c01051c6:	8d 48 04             	lea    0x4(%eax),%ecx
c01051c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01051cc:	89 0a                	mov    %ecx,(%edx)
c01051ce:	8b 00                	mov    (%eax),%eax
c01051d0:	99                   	cltd   
    }
}
c01051d1:	5d                   	pop    %ebp
c01051d2:	c3                   	ret    

c01051d3 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01051d3:	55                   	push   %ebp
c01051d4:	89 e5                	mov    %esp,%ebp
c01051d6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01051d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01051dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01051e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f7:	89 04 24             	mov    %eax,(%esp)
c01051fa:	e8 02 00 00 00       	call   c0105201 <vprintfmt>
    va_end(ap);
}
c01051ff:	c9                   	leave  
c0105200:	c3                   	ret    

c0105201 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105201:	55                   	push   %ebp
c0105202:	89 e5                	mov    %esp,%ebp
c0105204:	56                   	push   %esi
c0105205:	53                   	push   %ebx
c0105206:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105209:	eb 18                	jmp    c0105223 <vprintfmt+0x22>
            if (ch == '\0') {
c010520b:	85 db                	test   %ebx,%ebx
c010520d:	75 05                	jne    c0105214 <vprintfmt+0x13>
                return;
c010520f:	e9 d1 03 00 00       	jmp    c01055e5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105214:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105217:	89 44 24 04          	mov    %eax,0x4(%esp)
c010521b:	89 1c 24             	mov    %ebx,(%esp)
c010521e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105221:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105223:	8b 45 10             	mov    0x10(%ebp),%eax
c0105226:	8d 50 01             	lea    0x1(%eax),%edx
c0105229:	89 55 10             	mov    %edx,0x10(%ebp)
c010522c:	0f b6 00             	movzbl (%eax),%eax
c010522f:	0f b6 d8             	movzbl %al,%ebx
c0105232:	83 fb 25             	cmp    $0x25,%ebx
c0105235:	75 d4                	jne    c010520b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105237:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010523b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105245:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105248:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010524f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105252:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105255:	8b 45 10             	mov    0x10(%ebp),%eax
c0105258:	8d 50 01             	lea    0x1(%eax),%edx
c010525b:	89 55 10             	mov    %edx,0x10(%ebp)
c010525e:	0f b6 00             	movzbl (%eax),%eax
c0105261:	0f b6 d8             	movzbl %al,%ebx
c0105264:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105267:	83 f8 55             	cmp    $0x55,%eax
c010526a:	0f 87 44 03 00 00    	ja     c01055b4 <vprintfmt+0x3b3>
c0105270:	8b 04 85 f8 6c 10 c0 	mov    -0x3fef9308(,%eax,4),%eax
c0105277:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105279:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010527d:	eb d6                	jmp    c0105255 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010527f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105283:	eb d0                	jmp    c0105255 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105285:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010528c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010528f:	89 d0                	mov    %edx,%eax
c0105291:	c1 e0 02             	shl    $0x2,%eax
c0105294:	01 d0                	add    %edx,%eax
c0105296:	01 c0                	add    %eax,%eax
c0105298:	01 d8                	add    %ebx,%eax
c010529a:	83 e8 30             	sub    $0x30,%eax
c010529d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01052a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01052a3:	0f b6 00             	movzbl (%eax),%eax
c01052a6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01052a9:	83 fb 2f             	cmp    $0x2f,%ebx
c01052ac:	7e 0b                	jle    c01052b9 <vprintfmt+0xb8>
c01052ae:	83 fb 39             	cmp    $0x39,%ebx
c01052b1:	7f 06                	jg     c01052b9 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01052b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01052b7:	eb d3                	jmp    c010528c <vprintfmt+0x8b>
            goto process_precision;
c01052b9:	eb 33                	jmp    c01052ee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01052bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01052be:	8d 50 04             	lea    0x4(%eax),%edx
c01052c1:	89 55 14             	mov    %edx,0x14(%ebp)
c01052c4:	8b 00                	mov    (%eax),%eax
c01052c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01052c9:	eb 23                	jmp    c01052ee <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01052cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052cf:	79 0c                	jns    c01052dd <vprintfmt+0xdc>
                width = 0;
c01052d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01052d8:	e9 78 ff ff ff       	jmp    c0105255 <vprintfmt+0x54>
c01052dd:	e9 73 ff ff ff       	jmp    c0105255 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01052e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01052e9:	e9 67 ff ff ff       	jmp    c0105255 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01052ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052f2:	79 12                	jns    c0105306 <vprintfmt+0x105>
                width = precision, precision = -1;
c01052f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105301:	e9 4f ff ff ff       	jmp    c0105255 <vprintfmt+0x54>
c0105306:	e9 4a ff ff ff       	jmp    c0105255 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010530b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010530f:	e9 41 ff ff ff       	jmp    c0105255 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105314:	8b 45 14             	mov    0x14(%ebp),%eax
c0105317:	8d 50 04             	lea    0x4(%eax),%edx
c010531a:	89 55 14             	mov    %edx,0x14(%ebp)
c010531d:	8b 00                	mov    (%eax),%eax
c010531f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105322:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105326:	89 04 24             	mov    %eax,(%esp)
c0105329:	8b 45 08             	mov    0x8(%ebp),%eax
c010532c:	ff d0                	call   *%eax
            break;
c010532e:	e9 ac 02 00 00       	jmp    c01055df <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105333:	8b 45 14             	mov    0x14(%ebp),%eax
c0105336:	8d 50 04             	lea    0x4(%eax),%edx
c0105339:	89 55 14             	mov    %edx,0x14(%ebp)
c010533c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010533e:	85 db                	test   %ebx,%ebx
c0105340:	79 02                	jns    c0105344 <vprintfmt+0x143>
                err = -err;
c0105342:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105344:	83 fb 06             	cmp    $0x6,%ebx
c0105347:	7f 0b                	jg     c0105354 <vprintfmt+0x153>
c0105349:	8b 34 9d b8 6c 10 c0 	mov    -0x3fef9348(,%ebx,4),%esi
c0105350:	85 f6                	test   %esi,%esi
c0105352:	75 23                	jne    c0105377 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105358:	c7 44 24 08 e5 6c 10 	movl   $0xc0106ce5,0x8(%esp)
c010535f:	c0 
c0105360:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105363:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105367:	8b 45 08             	mov    0x8(%ebp),%eax
c010536a:	89 04 24             	mov    %eax,(%esp)
c010536d:	e8 61 fe ff ff       	call   c01051d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105372:	e9 68 02 00 00       	jmp    c01055df <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105377:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010537b:	c7 44 24 08 ee 6c 10 	movl   $0xc0106cee,0x8(%esp)
c0105382:	c0 
c0105383:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105386:	89 44 24 04          	mov    %eax,0x4(%esp)
c010538a:	8b 45 08             	mov    0x8(%ebp),%eax
c010538d:	89 04 24             	mov    %eax,(%esp)
c0105390:	e8 3e fe ff ff       	call   c01051d3 <printfmt>
            }
            break;
c0105395:	e9 45 02 00 00       	jmp    c01055df <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010539a:	8b 45 14             	mov    0x14(%ebp),%eax
c010539d:	8d 50 04             	lea    0x4(%eax),%edx
c01053a0:	89 55 14             	mov    %edx,0x14(%ebp)
c01053a3:	8b 30                	mov    (%eax),%esi
c01053a5:	85 f6                	test   %esi,%esi
c01053a7:	75 05                	jne    c01053ae <vprintfmt+0x1ad>
                p = "(null)";
c01053a9:	be f1 6c 10 c0       	mov    $0xc0106cf1,%esi
            }
            if (width > 0 && padc != '-') {
c01053ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053b2:	7e 3e                	jle    c01053f2 <vprintfmt+0x1f1>
c01053b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01053b8:	74 38                	je     c01053f2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01053ba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01053bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053c4:	89 34 24             	mov    %esi,(%esp)
c01053c7:	e8 15 03 00 00       	call   c01056e1 <strnlen>
c01053cc:	29 c3                	sub    %eax,%ebx
c01053ce:	89 d8                	mov    %ebx,%eax
c01053d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053d3:	eb 17                	jmp    c01053ec <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01053d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01053d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053dc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053e0:	89 04 24             	mov    %eax,(%esp)
c01053e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01053e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01053ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053f0:	7f e3                	jg     c01053d5 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01053f2:	eb 38                	jmp    c010542c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01053f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01053f8:	74 1f                	je     c0105419 <vprintfmt+0x218>
c01053fa:	83 fb 1f             	cmp    $0x1f,%ebx
c01053fd:	7e 05                	jle    c0105404 <vprintfmt+0x203>
c01053ff:	83 fb 7e             	cmp    $0x7e,%ebx
c0105402:	7e 15                	jle    c0105419 <vprintfmt+0x218>
                    putch('?', putdat);
c0105404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105407:	89 44 24 04          	mov    %eax,0x4(%esp)
c010540b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105412:	8b 45 08             	mov    0x8(%ebp),%eax
c0105415:	ff d0                	call   *%eax
c0105417:	eb 0f                	jmp    c0105428 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105419:	8b 45 0c             	mov    0xc(%ebp),%eax
c010541c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105420:	89 1c 24             	mov    %ebx,(%esp)
c0105423:	8b 45 08             	mov    0x8(%ebp),%eax
c0105426:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105428:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010542c:	89 f0                	mov    %esi,%eax
c010542e:	8d 70 01             	lea    0x1(%eax),%esi
c0105431:	0f b6 00             	movzbl (%eax),%eax
c0105434:	0f be d8             	movsbl %al,%ebx
c0105437:	85 db                	test   %ebx,%ebx
c0105439:	74 10                	je     c010544b <vprintfmt+0x24a>
c010543b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010543f:	78 b3                	js     c01053f4 <vprintfmt+0x1f3>
c0105441:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105445:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105449:	79 a9                	jns    c01053f4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010544b:	eb 17                	jmp    c0105464 <vprintfmt+0x263>
                putch(' ', putdat);
c010544d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105450:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105454:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010545b:	8b 45 08             	mov    0x8(%ebp),%eax
c010545e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105460:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105464:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105468:	7f e3                	jg     c010544d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010546a:	e9 70 01 00 00       	jmp    c01055df <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010546f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105472:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105476:	8d 45 14             	lea    0x14(%ebp),%eax
c0105479:	89 04 24             	mov    %eax,(%esp)
c010547c:	e8 0b fd ff ff       	call   c010518c <getint>
c0105481:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105484:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105487:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010548a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010548d:	85 d2                	test   %edx,%edx
c010548f:	79 26                	jns    c01054b7 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105491:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105494:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105498:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010549f:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a2:	ff d0                	call   *%eax
                num = -(long long)num;
c01054a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054aa:	f7 d8                	neg    %eax
c01054ac:	83 d2 00             	adc    $0x0,%edx
c01054af:	f7 da                	neg    %edx
c01054b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01054b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01054be:	e9 a8 00 00 00       	jmp    c010556b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054ca:	8d 45 14             	lea    0x14(%ebp),%eax
c01054cd:	89 04 24             	mov    %eax,(%esp)
c01054d0:	e8 68 fc ff ff       	call   c010513d <getuint>
c01054d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01054db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01054e2:	e9 84 00 00 00       	jmp    c010556b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01054e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054ee:	8d 45 14             	lea    0x14(%ebp),%eax
c01054f1:	89 04 24             	mov    %eax,(%esp)
c01054f4:	e8 44 fc ff ff       	call   c010513d <getuint>
c01054f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01054ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105506:	eb 63                	jmp    c010556b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105508:	8b 45 0c             	mov    0xc(%ebp),%eax
c010550b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010550f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105516:	8b 45 08             	mov    0x8(%ebp),%eax
c0105519:	ff d0                	call   *%eax
            putch('x', putdat);
c010551b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010551e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105522:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105529:	8b 45 08             	mov    0x8(%ebp),%eax
c010552c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010552e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105531:	8d 50 04             	lea    0x4(%eax),%edx
c0105534:	89 55 14             	mov    %edx,0x14(%ebp)
c0105537:	8b 00                	mov    (%eax),%eax
c0105539:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010553c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105543:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010554a:	eb 1f                	jmp    c010556b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010554c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010554f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105553:	8d 45 14             	lea    0x14(%ebp),%eax
c0105556:	89 04 24             	mov    %eax,(%esp)
c0105559:	e8 df fb ff ff       	call   c010513d <getuint>
c010555e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105561:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105564:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010556b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010556f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105572:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105576:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105579:	89 54 24 14          	mov    %edx,0x14(%esp)
c010557d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105581:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105584:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105587:	89 44 24 08          	mov    %eax,0x8(%esp)
c010558b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105592:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105596:	8b 45 08             	mov    0x8(%ebp),%eax
c0105599:	89 04 24             	mov    %eax,(%esp)
c010559c:	e8 97 fa ff ff       	call   c0105038 <printnum>
            break;
c01055a1:	eb 3c                	jmp    c01055df <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01055a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055aa:	89 1c 24             	mov    %ebx,(%esp)
c01055ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b0:	ff d0                	call   *%eax
            break;
c01055b2:	eb 2b                	jmp    c01055df <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01055b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01055c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01055c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01055cb:	eb 04                	jmp    c01055d1 <vprintfmt+0x3d0>
c01055cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01055d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055d4:	83 e8 01             	sub    $0x1,%eax
c01055d7:	0f b6 00             	movzbl (%eax),%eax
c01055da:	3c 25                	cmp    $0x25,%al
c01055dc:	75 ef                	jne    c01055cd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01055de:	90                   	nop
        }
    }
c01055df:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055e0:	e9 3e fc ff ff       	jmp    c0105223 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01055e5:	83 c4 40             	add    $0x40,%esp
c01055e8:	5b                   	pop    %ebx
c01055e9:	5e                   	pop    %esi
c01055ea:	5d                   	pop    %ebp
c01055eb:	c3                   	ret    

c01055ec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01055ec:	55                   	push   %ebp
c01055ed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01055ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f2:	8b 40 08             	mov    0x8(%eax),%eax
c01055f5:	8d 50 01             	lea    0x1(%eax),%edx
c01055f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105601:	8b 10                	mov    (%eax),%edx
c0105603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105606:	8b 40 04             	mov    0x4(%eax),%eax
c0105609:	39 c2                	cmp    %eax,%edx
c010560b:	73 12                	jae    c010561f <sprintputch+0x33>
        *b->buf ++ = ch;
c010560d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105610:	8b 00                	mov    (%eax),%eax
c0105612:	8d 48 01             	lea    0x1(%eax),%ecx
c0105615:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105618:	89 0a                	mov    %ecx,(%edx)
c010561a:	8b 55 08             	mov    0x8(%ebp),%edx
c010561d:	88 10                	mov    %dl,(%eax)
    }
}
c010561f:	5d                   	pop    %ebp
c0105620:	c3                   	ret    

c0105621 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105621:	55                   	push   %ebp
c0105622:	89 e5                	mov    %esp,%ebp
c0105624:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105627:	8d 45 14             	lea    0x14(%ebp),%eax
c010562a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010562d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105630:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105634:	8b 45 10             	mov    0x10(%ebp),%eax
c0105637:	89 44 24 08          	mov    %eax,0x8(%esp)
c010563b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105642:	8b 45 08             	mov    0x8(%ebp),%eax
c0105645:	89 04 24             	mov    %eax,(%esp)
c0105648:	e8 08 00 00 00       	call   c0105655 <vsnprintf>
c010564d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105653:	c9                   	leave  
c0105654:	c3                   	ret    

c0105655 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105655:	55                   	push   %ebp
c0105656:	89 e5                	mov    %esp,%ebp
c0105658:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010565b:	8b 45 08             	mov    0x8(%ebp),%eax
c010565e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105661:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105664:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	01 d0                	add    %edx,%eax
c010566c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010566f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010567a:	74 0a                	je     c0105686 <vsnprintf+0x31>
c010567c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010567f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105682:	39 c2                	cmp    %eax,%edx
c0105684:	76 07                	jbe    c010568d <vsnprintf+0x38>
        return -E_INVAL;
c0105686:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010568b:	eb 2a                	jmp    c01056b7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010568d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105690:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105694:	8b 45 10             	mov    0x10(%ebp),%eax
c0105697:	89 44 24 08          	mov    %eax,0x8(%esp)
c010569b:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010569e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056a2:	c7 04 24 ec 55 10 c0 	movl   $0xc01055ec,(%esp)
c01056a9:	e8 53 fb ff ff       	call   c0105201 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01056ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01056b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01056b7:	c9                   	leave  
c01056b8:	c3                   	ret    

c01056b9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01056b9:	55                   	push   %ebp
c01056ba:	89 e5                	mov    %esp,%ebp
c01056bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01056bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01056c6:	eb 04                	jmp    c01056cc <strlen+0x13>
        cnt ++;
c01056c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01056cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056cf:	8d 50 01             	lea    0x1(%eax),%edx
c01056d2:	89 55 08             	mov    %edx,0x8(%ebp)
c01056d5:	0f b6 00             	movzbl (%eax),%eax
c01056d8:	84 c0                	test   %al,%al
c01056da:	75 ec                	jne    c01056c8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01056dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01056df:	c9                   	leave  
c01056e0:	c3                   	ret    

c01056e1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01056e1:	55                   	push   %ebp
c01056e2:	89 e5                	mov    %esp,%ebp
c01056e4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01056e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01056ee:	eb 04                	jmp    c01056f4 <strnlen+0x13>
        cnt ++;
c01056f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01056f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01056fa:	73 10                	jae    c010570c <strnlen+0x2b>
c01056fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ff:	8d 50 01             	lea    0x1(%eax),%edx
c0105702:	89 55 08             	mov    %edx,0x8(%ebp)
c0105705:	0f b6 00             	movzbl (%eax),%eax
c0105708:	84 c0                	test   %al,%al
c010570a:	75 e4                	jne    c01056f0 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010570c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010570f:	c9                   	leave  
c0105710:	c3                   	ret    

c0105711 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105711:	55                   	push   %ebp
c0105712:	89 e5                	mov    %esp,%ebp
c0105714:	57                   	push   %edi
c0105715:	56                   	push   %esi
c0105716:	83 ec 20             	sub    $0x20,%esp
c0105719:	8b 45 08             	mov    0x8(%ebp),%eax
c010571c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010571f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105722:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105725:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010572b:	89 d1                	mov    %edx,%ecx
c010572d:	89 c2                	mov    %eax,%edx
c010572f:	89 ce                	mov    %ecx,%esi
c0105731:	89 d7                	mov    %edx,%edi
c0105733:	ac                   	lods   %ds:(%esi),%al
c0105734:	aa                   	stos   %al,%es:(%edi)
c0105735:	84 c0                	test   %al,%al
c0105737:	75 fa                	jne    c0105733 <strcpy+0x22>
c0105739:	89 fa                	mov    %edi,%edx
c010573b:	89 f1                	mov    %esi,%ecx
c010573d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105740:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105749:	83 c4 20             	add    $0x20,%esp
c010574c:	5e                   	pop    %esi
c010574d:	5f                   	pop    %edi
c010574e:	5d                   	pop    %ebp
c010574f:	c3                   	ret    

c0105750 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105750:	55                   	push   %ebp
c0105751:	89 e5                	mov    %esp,%ebp
c0105753:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105756:	8b 45 08             	mov    0x8(%ebp),%eax
c0105759:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010575c:	eb 21                	jmp    c010577f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010575e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105761:	0f b6 10             	movzbl (%eax),%edx
c0105764:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105767:	88 10                	mov    %dl,(%eax)
c0105769:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010576c:	0f b6 00             	movzbl (%eax),%eax
c010576f:	84 c0                	test   %al,%al
c0105771:	74 04                	je     c0105777 <strncpy+0x27>
            src ++;
c0105773:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105777:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010577b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010577f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105783:	75 d9                	jne    c010575e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105785:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105788:	c9                   	leave  
c0105789:	c3                   	ret    

c010578a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010578a:	55                   	push   %ebp
c010578b:	89 e5                	mov    %esp,%ebp
c010578d:	57                   	push   %edi
c010578e:	56                   	push   %esi
c010578f:	83 ec 20             	sub    $0x20,%esp
c0105792:	8b 45 08             	mov    0x8(%ebp),%eax
c0105795:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010579b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010579e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a4:	89 d1                	mov    %edx,%ecx
c01057a6:	89 c2                	mov    %eax,%edx
c01057a8:	89 ce                	mov    %ecx,%esi
c01057aa:	89 d7                	mov    %edx,%edi
c01057ac:	ac                   	lods   %ds:(%esi),%al
c01057ad:	ae                   	scas   %es:(%edi),%al
c01057ae:	75 08                	jne    c01057b8 <strcmp+0x2e>
c01057b0:	84 c0                	test   %al,%al
c01057b2:	75 f8                	jne    c01057ac <strcmp+0x22>
c01057b4:	31 c0                	xor    %eax,%eax
c01057b6:	eb 04                	jmp    c01057bc <strcmp+0x32>
c01057b8:	19 c0                	sbb    %eax,%eax
c01057ba:	0c 01                	or     $0x1,%al
c01057bc:	89 fa                	mov    %edi,%edx
c01057be:	89 f1                	mov    %esi,%ecx
c01057c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057c3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01057c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01057c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01057cc:	83 c4 20             	add    $0x20,%esp
c01057cf:	5e                   	pop    %esi
c01057d0:	5f                   	pop    %edi
c01057d1:	5d                   	pop    %ebp
c01057d2:	c3                   	ret    

c01057d3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01057d3:	55                   	push   %ebp
c01057d4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01057d6:	eb 0c                	jmp    c01057e4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01057d8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01057dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01057e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057e8:	74 1a                	je     c0105804 <strncmp+0x31>
c01057ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ed:	0f b6 00             	movzbl (%eax),%eax
c01057f0:	84 c0                	test   %al,%al
c01057f2:	74 10                	je     c0105804 <strncmp+0x31>
c01057f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f7:	0f b6 10             	movzbl (%eax),%edx
c01057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057fd:	0f b6 00             	movzbl (%eax),%eax
c0105800:	38 c2                	cmp    %al,%dl
c0105802:	74 d4                	je     c01057d8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105804:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105808:	74 18                	je     c0105822 <strncmp+0x4f>
c010580a:	8b 45 08             	mov    0x8(%ebp),%eax
c010580d:	0f b6 00             	movzbl (%eax),%eax
c0105810:	0f b6 d0             	movzbl %al,%edx
c0105813:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105816:	0f b6 00             	movzbl (%eax),%eax
c0105819:	0f b6 c0             	movzbl %al,%eax
c010581c:	29 c2                	sub    %eax,%edx
c010581e:	89 d0                	mov    %edx,%eax
c0105820:	eb 05                	jmp    c0105827 <strncmp+0x54>
c0105822:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105827:	5d                   	pop    %ebp
c0105828:	c3                   	ret    

c0105829 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105829:	55                   	push   %ebp
c010582a:	89 e5                	mov    %esp,%ebp
c010582c:	83 ec 04             	sub    $0x4,%esp
c010582f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105832:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105835:	eb 14                	jmp    c010584b <strchr+0x22>
        if (*s == c) {
c0105837:	8b 45 08             	mov    0x8(%ebp),%eax
c010583a:	0f b6 00             	movzbl (%eax),%eax
c010583d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105840:	75 05                	jne    c0105847 <strchr+0x1e>
            return (char *)s;
c0105842:	8b 45 08             	mov    0x8(%ebp),%eax
c0105845:	eb 13                	jmp    c010585a <strchr+0x31>
        }
        s ++;
c0105847:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010584b:	8b 45 08             	mov    0x8(%ebp),%eax
c010584e:	0f b6 00             	movzbl (%eax),%eax
c0105851:	84 c0                	test   %al,%al
c0105853:	75 e2                	jne    c0105837 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105855:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010585a:	c9                   	leave  
c010585b:	c3                   	ret    

c010585c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010585c:	55                   	push   %ebp
c010585d:	89 e5                	mov    %esp,%ebp
c010585f:	83 ec 04             	sub    $0x4,%esp
c0105862:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105865:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105868:	eb 11                	jmp    c010587b <strfind+0x1f>
        if (*s == c) {
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	0f b6 00             	movzbl (%eax),%eax
c0105870:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105873:	75 02                	jne    c0105877 <strfind+0x1b>
            break;
c0105875:	eb 0e                	jmp    c0105885 <strfind+0x29>
        }
        s ++;
c0105877:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010587b:	8b 45 08             	mov    0x8(%ebp),%eax
c010587e:	0f b6 00             	movzbl (%eax),%eax
c0105881:	84 c0                	test   %al,%al
c0105883:	75 e5                	jne    c010586a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105885:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105888:	c9                   	leave  
c0105889:	c3                   	ret    

c010588a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010588a:	55                   	push   %ebp
c010588b:	89 e5                	mov    %esp,%ebp
c010588d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105890:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105897:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010589e:	eb 04                	jmp    c01058a4 <strtol+0x1a>
        s ++;
c01058a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01058a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a7:	0f b6 00             	movzbl (%eax),%eax
c01058aa:	3c 20                	cmp    $0x20,%al
c01058ac:	74 f2                	je     c01058a0 <strtol+0x16>
c01058ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b1:	0f b6 00             	movzbl (%eax),%eax
c01058b4:	3c 09                	cmp    $0x9,%al
c01058b6:	74 e8                	je     c01058a0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01058b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bb:	0f b6 00             	movzbl (%eax),%eax
c01058be:	3c 2b                	cmp    $0x2b,%al
c01058c0:	75 06                	jne    c01058c8 <strtol+0x3e>
        s ++;
c01058c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058c6:	eb 15                	jmp    c01058dd <strtol+0x53>
    }
    else if (*s == '-') {
c01058c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cb:	0f b6 00             	movzbl (%eax),%eax
c01058ce:	3c 2d                	cmp    $0x2d,%al
c01058d0:	75 0b                	jne    c01058dd <strtol+0x53>
        s ++, neg = 1;
c01058d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01058dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058e1:	74 06                	je     c01058e9 <strtol+0x5f>
c01058e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01058e7:	75 24                	jne    c010590d <strtol+0x83>
c01058e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ec:	0f b6 00             	movzbl (%eax),%eax
c01058ef:	3c 30                	cmp    $0x30,%al
c01058f1:	75 1a                	jne    c010590d <strtol+0x83>
c01058f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f6:	83 c0 01             	add    $0x1,%eax
c01058f9:	0f b6 00             	movzbl (%eax),%eax
c01058fc:	3c 78                	cmp    $0x78,%al
c01058fe:	75 0d                	jne    c010590d <strtol+0x83>
        s += 2, base = 16;
c0105900:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105904:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010590b:	eb 2a                	jmp    c0105937 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010590d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105911:	75 17                	jne    c010592a <strtol+0xa0>
c0105913:	8b 45 08             	mov    0x8(%ebp),%eax
c0105916:	0f b6 00             	movzbl (%eax),%eax
c0105919:	3c 30                	cmp    $0x30,%al
c010591b:	75 0d                	jne    c010592a <strtol+0xa0>
        s ++, base = 8;
c010591d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105921:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105928:	eb 0d                	jmp    c0105937 <strtol+0xad>
    }
    else if (base == 0) {
c010592a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010592e:	75 07                	jne    c0105937 <strtol+0xad>
        base = 10;
c0105930:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105937:	8b 45 08             	mov    0x8(%ebp),%eax
c010593a:	0f b6 00             	movzbl (%eax),%eax
c010593d:	3c 2f                	cmp    $0x2f,%al
c010593f:	7e 1b                	jle    c010595c <strtol+0xd2>
c0105941:	8b 45 08             	mov    0x8(%ebp),%eax
c0105944:	0f b6 00             	movzbl (%eax),%eax
c0105947:	3c 39                	cmp    $0x39,%al
c0105949:	7f 11                	jg     c010595c <strtol+0xd2>
            dig = *s - '0';
c010594b:	8b 45 08             	mov    0x8(%ebp),%eax
c010594e:	0f b6 00             	movzbl (%eax),%eax
c0105951:	0f be c0             	movsbl %al,%eax
c0105954:	83 e8 30             	sub    $0x30,%eax
c0105957:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010595a:	eb 48                	jmp    c01059a4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010595c:	8b 45 08             	mov    0x8(%ebp),%eax
c010595f:	0f b6 00             	movzbl (%eax),%eax
c0105962:	3c 60                	cmp    $0x60,%al
c0105964:	7e 1b                	jle    c0105981 <strtol+0xf7>
c0105966:	8b 45 08             	mov    0x8(%ebp),%eax
c0105969:	0f b6 00             	movzbl (%eax),%eax
c010596c:	3c 7a                	cmp    $0x7a,%al
c010596e:	7f 11                	jg     c0105981 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105970:	8b 45 08             	mov    0x8(%ebp),%eax
c0105973:	0f b6 00             	movzbl (%eax),%eax
c0105976:	0f be c0             	movsbl %al,%eax
c0105979:	83 e8 57             	sub    $0x57,%eax
c010597c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010597f:	eb 23                	jmp    c01059a4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105981:	8b 45 08             	mov    0x8(%ebp),%eax
c0105984:	0f b6 00             	movzbl (%eax),%eax
c0105987:	3c 40                	cmp    $0x40,%al
c0105989:	7e 3d                	jle    c01059c8 <strtol+0x13e>
c010598b:	8b 45 08             	mov    0x8(%ebp),%eax
c010598e:	0f b6 00             	movzbl (%eax),%eax
c0105991:	3c 5a                	cmp    $0x5a,%al
c0105993:	7f 33                	jg     c01059c8 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105995:	8b 45 08             	mov    0x8(%ebp),%eax
c0105998:	0f b6 00             	movzbl (%eax),%eax
c010599b:	0f be c0             	movsbl %al,%eax
c010599e:	83 e8 37             	sub    $0x37,%eax
c01059a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01059a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a7:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059aa:	7c 02                	jl     c01059ae <strtol+0x124>
            break;
c01059ac:	eb 1a                	jmp    c01059c8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01059ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059b5:	0f af 45 10          	imul   0x10(%ebp),%eax
c01059b9:	89 c2                	mov    %eax,%edx
c01059bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059be:	01 d0                	add    %edx,%eax
c01059c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01059c3:	e9 6f ff ff ff       	jmp    c0105937 <strtol+0xad>

    if (endptr) {
c01059c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059cc:	74 08                	je     c01059d6 <strtol+0x14c>
        *endptr = (char *) s;
c01059ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01059d4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01059d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01059da:	74 07                	je     c01059e3 <strtol+0x159>
c01059dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059df:	f7 d8                	neg    %eax
c01059e1:	eb 03                	jmp    c01059e6 <strtol+0x15c>
c01059e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01059e6:	c9                   	leave  
c01059e7:	c3                   	ret    

c01059e8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01059e8:	55                   	push   %ebp
c01059e9:	89 e5                	mov    %esp,%ebp
c01059eb:	57                   	push   %edi
c01059ec:	83 ec 24             	sub    $0x24,%esp
c01059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01059f5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01059f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01059fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01059ff:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105a02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105a08:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105a0b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105a0f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105a12:	89 d7                	mov    %edx,%edi
c0105a14:	f3 aa                	rep stos %al,%es:(%edi)
c0105a16:	89 fa                	mov    %edi,%edx
c0105a18:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a1b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105a21:	83 c4 24             	add    $0x24,%esp
c0105a24:	5f                   	pop    %edi
c0105a25:	5d                   	pop    %ebp
c0105a26:	c3                   	ret    

c0105a27 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105a27:	55                   	push   %ebp
c0105a28:	89 e5                	mov    %esp,%ebp
c0105a2a:	57                   	push   %edi
c0105a2b:	56                   	push   %esi
c0105a2c:	53                   	push   %ebx
c0105a2d:	83 ec 30             	sub    $0x30,%esp
c0105a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105a48:	73 42                	jae    c0105a8c <memmove+0x65>
c0105a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a5f:	c1 e8 02             	shr    $0x2,%eax
c0105a62:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a6a:	89 d7                	mov    %edx,%edi
c0105a6c:	89 c6                	mov    %eax,%esi
c0105a6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105a73:	83 e1 03             	and    $0x3,%ecx
c0105a76:	74 02                	je     c0105a7a <memmove+0x53>
c0105a78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a7a:	89 f0                	mov    %esi,%eax
c0105a7c:	89 fa                	mov    %edi,%edx
c0105a7e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105a81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105a84:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a8a:	eb 36                	jmp    c0105ac2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a8f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a95:	01 c2                	add    %eax,%edx
c0105a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a9a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105aa6:	89 c1                	mov    %eax,%ecx
c0105aa8:	89 d8                	mov    %ebx,%eax
c0105aaa:	89 d6                	mov    %edx,%esi
c0105aac:	89 c7                	mov    %eax,%edi
c0105aae:	fd                   	std    
c0105aaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ab1:	fc                   	cld    
c0105ab2:	89 f8                	mov    %edi,%eax
c0105ab4:	89 f2                	mov    %esi,%edx
c0105ab6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ab9:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105abc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ac2:	83 c4 30             	add    $0x30,%esp
c0105ac5:	5b                   	pop    %ebx
c0105ac6:	5e                   	pop    %esi
c0105ac7:	5f                   	pop    %edi
c0105ac8:	5d                   	pop    %ebp
c0105ac9:	c3                   	ret    

c0105aca <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105aca:	55                   	push   %ebp
c0105acb:	89 e5                	mov    %esp,%ebp
c0105acd:	57                   	push   %edi
c0105ace:	56                   	push   %esi
c0105acf:	83 ec 20             	sub    $0x20,%esp
c0105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ade:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ae7:	c1 e8 02             	shr    $0x2,%eax
c0105aea:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af2:	89 d7                	mov    %edx,%edi
c0105af4:	89 c6                	mov    %eax,%esi
c0105af6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105af8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105afb:	83 e1 03             	and    $0x3,%ecx
c0105afe:	74 02                	je     c0105b02 <memcpy+0x38>
c0105b00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b02:	89 f0                	mov    %esi,%eax
c0105b04:	89 fa                	mov    %edi,%edx
c0105b06:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105b12:	83 c4 20             	add    $0x20,%esp
c0105b15:	5e                   	pop    %esi
c0105b16:	5f                   	pop    %edi
c0105b17:	5d                   	pop    %ebp
c0105b18:	c3                   	ret    

c0105b19 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105b19:	55                   	push   %ebp
c0105b1a:	89 e5                	mov    %esp,%ebp
c0105b1c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105b25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b28:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105b2b:	eb 30                	jmp    c0105b5d <memcmp+0x44>
        if (*s1 != *s2) {
c0105b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b30:	0f b6 10             	movzbl (%eax),%edx
c0105b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b36:	0f b6 00             	movzbl (%eax),%eax
c0105b39:	38 c2                	cmp    %al,%dl
c0105b3b:	74 18                	je     c0105b55 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b40:	0f b6 00             	movzbl (%eax),%eax
c0105b43:	0f b6 d0             	movzbl %al,%edx
c0105b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b49:	0f b6 00             	movzbl (%eax),%eax
c0105b4c:	0f b6 c0             	movzbl %al,%eax
c0105b4f:	29 c2                	sub    %eax,%edx
c0105b51:	89 d0                	mov    %edx,%eax
c0105b53:	eb 1a                	jmp    c0105b6f <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105b55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b59:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105b5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b60:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b63:	89 55 10             	mov    %edx,0x10(%ebp)
c0105b66:	85 c0                	test   %eax,%eax
c0105b68:	75 c3                	jne    c0105b2d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b6f:	c9                   	leave  
c0105b70:	c3                   	ret    
