# 构建阶段
FROM node:20-alpine AS builder

WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm ci --legacy-peer-deps

# 复制源代码
COPY . .

# 构建生产版本
RUN npm run build

# 生产阶段 - 使用 Nginx
FROM nginx

# 复制自定义 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 从构建阶段复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]

# docker build -t airword-web --platform=linux/amd64 . && docker tag airword-web ccr.ccs.tencentyun.com/likeshop/airword-web && docker push ccr.ccs.tencentyun.com/likeshop/airword-web && docker rmi ccr.ccs.tencentyun.com/likeshop/airword-web
# docker run -d --rm -p 127.0.0.1:3721:80 --name airword-web airword-web