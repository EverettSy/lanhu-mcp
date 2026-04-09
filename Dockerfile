FROM python:3.10-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 替换 apt 源为阿里云镜像（Debian Bookworm）
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources \
    && sed -i 's|security.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# pip 使用阿里云镜像
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt

# Playwright 使用 npmmirror 国内镜像下载 Chromium
# 安装Playwright浏览器
RUN playwright install chromium
RUN playwright install-deps chromium

COPY lanhu_mcp_server.py .

RUN mkdir -p /app/data /app/logs

EXPOSE 8000

CMD ["python", "lanhu_mcp_server.py"]
