FROM oven/bun:latest

# コンテナ内のwork dirを設定
WORKDIR /src

# 環境変数を設定し、ポートとホストを指定
ARG API_URL
ARG SITE_URL
ARG PROXY_URL
ARG GTAG
ARG RECAPTCHA_SITE_KEY
ARG BASIC_USER
ARG BASIC_PASS

ENV PORT 8080
ENV HOST 0.0.0.0
ENV API_URL ${API_URL}
ENV SITE_URL ${SITE_URL}
ENV PROXY_URL ${PROXY_URL}
ENV GTAG ${GTAG}
ENV RECAPTCHA_SITE_KEY ${RECAPTCHA_SITE_KEY}
ENV BASIC_USER ${BASIC_USER}
ENV BASIC_PASS ${BASIC_PASS}

# package.jsonをコピーして、パッケージのインストール
COPY package.json ./
COPY bun.lockb ./
RUN bun install

# ソースをコピーして、ビルド
COPY . .
RUN bun nbuild

# コンテナが起動したら、nuxtを起動するよう指定
CMD [ "bun", "start"]