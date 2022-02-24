#Xây dựng image mới từ image Ubuntu
FROM ubuntu:16.04

#Ký tên tác giả
LABEL author.name="TheVan" \
    author.email="van.nguyenthe@thecoffeehouse.vn"

RUN DEBIAN_FRONTEND=noninteractive


#Thiết lập thư mục hiện tại
#directory used in any further RUN, COPY, and ENTRYPOINT
ENV APP_PATH /venv
WORKDIR $APP_PATH

#Set time zone
ENV TZ=Asia/Ho_Chi_Minh
RUN set -x \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

#Cập nhật các gói & cài NGINX
RUN set -x \
    && apt-get update \
    && apt-get install -y nginx nano vim

#Cài mySQL
RUN set -x \
    && echo "mysql-server mysql-server/root_password password root" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections \
    && apt-get install -y mysql-server

#Chuyển file start.sh vào thư mục chính

COPY start.sh /venv

#Set quyền thư mục
RUN set -x \
    && chmod a+x /venv/*

#Khi chạy container tự động chạy ngay start.sh
ENTRYPOINT ["/venv/start.sh"]

#Thiết lập khi tạo container từ image sẽ mở cổng 8080 ở mạng mà container nối vào
EXPOSE 8080

