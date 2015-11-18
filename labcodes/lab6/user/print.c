#include<stdio.h>
#include<ulib.h>
#include<string.h>
#include<stdlib.h>
#define TOTAL 4

int main(void){
int i=0;
fork();
fork();
for (;i<100;i++){
cprintf("%d\n",i);
yield();
}
cprintf("This is process : %d, wakeup_times: %d.\n",getpid(),getwakeuptimes());
return 0;
}

