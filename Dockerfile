FROM nginx
 # 声明告诉系统，无需向用户请求输入（非交互式）
RUN DEBIAN_FRONTEND=noninteractive \
    # 更新软件包列表
    apt-get update -qq && \
    # 安装 curl runit
    apt-get -y install curl runit && \
    # rm 删除，-r 全部删除子目录, -f 强制删除
    rm -rf /var/lib/apt/lists/*

ADD consul-template_0.19.4_linux_amd64.tgz /usr/local/bin/
# 将 nginx.service 放到指定文件夹，生成run文件
ADD nginx.service /etc/service/nginx/run
# 给所有人添加文件的可执行权限
RUN chmod a+x /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN chmod a+x /etc/service/consul-template/run

RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf /etc/consul-templates/nginx.conf
# 使用runit ,当 runsvdir在/etc/service/目录中发现新的配置时，
# 启动runsv进程来执行和监控/etc/service下的run脚本
CMD ["/usr/bin/runsvdir", "/etc/service"]