#!/bin/bash
# bam to bed

# date # 脚本开始时间
#
# for ((i=1;i<=10;i++))
# do
# {
#         sleep 1  #sleep 1用以模仿执行一条命令需要花费的时间（可以用真实命令来代替）
#         echo 'success'$i;
#  }&              #用{}把循环体括起来，后加一个&符号，代表每次循环都把命令放入后台运行
#                  #一旦放入后台，就意味着{}里面的命令交给操作系统的一个线程处理了
#                  #循环了1000次，就有1000个&将任务放入后台，操作系统会并发1000个线程来处理
# done
# wait             #wait命令表示。等待上面的命令（放入后台的任务）都执行完毕了再往下执行
#
# date # 脚本结束时间

for ((i=1;i<=10;i++))
do {
    sleep 5
}&
done
wait
