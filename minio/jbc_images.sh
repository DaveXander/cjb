#!/bin/bash

set -e

# 输入 tar
INPUT_TAR=$1

if [ -z "$INPUT_TAR" ]; then
  echo "Usage: $0 images.tar"
  exit 1
fi

# 新仓库前缀
TARGET_REG="10.224.146.200/d1tlaisec_01"

echo "===> Load images..."
docker load -i $INPUT_TAR

echo "===> Retag & Push..."

# 获取本地刚导入的镜像列表
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "cr.ttyuyin.com")

for img in $IMAGES; do
    # 去掉原 registry
    new_img=$(echo $img | sed 's#cr.ttyuyin.com/##')

    target_img="${TARGET_REG}/${new_img}"

    echo "Tagging $img -> $target_img"
    docker tag $img $target_img

    echo "Pushing $target_img"
    docker push $target_img
done

echo "Done"
