FROM debian:11

ARG CROSS_TOOLCHAIN=gcc-4.4.4-glibc-2.11.1-multilib-1.0_EasyARM-iMX283.tar.bz2

WORKDIR /root/

ADD z.tar.gz  $CROSS_TOOLCHAIN  /opt
ADD fengming.d.tar.gz  /etc


ENV COMPILER4WHO=easyarm_gcc_compiler
RUN cat <<-EOF >> .bashrc
alias who='echo $COMPILER4WHO'
export LANG=en_US.UTF-8

if [ -f /etc/fengming.d/mybashrc  ];then
    . /etc/fengming.d/mybashrc
fi
EOF

RUN cat <<-EOF > /etc/apt/sources.list
deb http://mirrors.163.com/debian/ bullseye main contrib 
deb http://mirrors.163.com/debian/ bullseye-updates main contrib
EOF

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y locales vim git wget tree bd file \
		build-essential lib32z1 \
		make cmake gcc-multilib 

RUN cp /etc/locale.gen /etc/locale.gen.bak;\
		echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen;\
		locale-gen

ENV PATH=$PATH:/opt/arm-fsl-linux-gnueabi/bin

CMD ["/bin/bash"]
