# 使用超小的Linux镜像alpine
FROM alpine

ENV HOME /root

RUN apk update && apk add --no-cache  git gcc libc-dev bash make automake autoconf libtool linux-headers 

RUN cd /root \
    && git clone https://github.com/happyfish100/libfastcommon.git --depth 1 \
    && git clone https://github.com/happyfish100/fastdfs.git --depth 1 

RUN cd /root/libfastcommon/ \
    && ./make.sh  \
    && ./make.sh install

RUN cd /root/fastdfs/ \
    && ./make.sh \
    && ./make.sh install 
      
RUN cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
    && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
    && sed -i "s|/home/yuqing/fastdfs|/var/local/fdfs/tracker|g" /etc/fdfs/tracker.conf \
    && sed -i "s|/home/yuqing/fastdfs|/var/local/fdfs/storage|g" /etc/fdfs/storage.conf 

RUN rm -rf /root/*

# 默认nginx端口
ENV WEB_PORT 8888
# 默认fastdfs端口
ENV FDFS_PORT 22122


# 创建启动脚本#TRACKERSERVER
RUN  echo -e "\
mkdir -p /var/local/fdfs/storage/data /var/local/fdfs/tracker; \n\
sed -i \"s/http.server_port=.*$/http.server_port=\$WEB_PORT/g\" /etc/fdfs/storage.conf; \n\n\
if [ \"\$TRACKERSERVER\" = \"localhost\" ]; then \n\
   IP=\"localhost\"; \n\
   sed -i \"s/^tracker_server=.*$/tracker_server=\$IP:\$FDFS_PORT/g\" /etc/fdfs/storage.conf; \n\
else  \n\
   sed -i \"/^tracker_server/d\" /etc/fdfs/storage.conf; \n\
   server=\`echo \$TRACKERSERVER | awk ' {print \$0}'\` \n\
   for tracker_server in \$server ; \n\
   do\n\
      echo \"tracker_server=\$tracker_server:\$FDFS_PORT\"  >> /etc/fdfs/storage.conf; \n\
   done \n\
fi \n\
/etc/init.d/fdfs_trackerd start; \n\
/etc/init.d/fdfs_storaged start;\n\
">/start.sh \
&& chmod u+x /start.sh
 
 
# 暴露端口。改为采用host网络，不需要单独暴露端口
# EXPOSE 80 22122

#RUN /bin/bash /start.sh


#CMD /bin/bash /start.sh
ENTRYPOINT /bin/bash /start.sh  && /bin/bash  


#["/bin/bash","/start.sh"]
