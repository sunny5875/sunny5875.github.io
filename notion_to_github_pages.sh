#!/bin/bash

# Author: Kim Hangil(uoneway)
# URL: https://github.com/uoneway/Notion-to-GitHub-Pages
# Contact: uoneway@gmail.com

posts_folder_path='_posts'
images_folder_path='assets'
exported_zip_reg="*.zip"

echo "##### Welcome to Notion-to-GitHub-Pages! #####"

# ZIP 압축 해제 함수
unzd() {
    if [[ $# != 1 ]]; then
        echo "I need a single argument, the name of the archive to extract"
        return 1
    fi
    target="${1%.zip}"
    if [ -d "$target" ]; then
        echo "Folder $target already exists. Skipping unzip."
    else
        unzip -qq "$1" -d "${target##*/}"
    fi
}

exported_foldername_array=()
while IFS=  read -r -d $'\0'; do
    unzd "$REPLY"
    exported_foldername_array+=("$(basename "${REPLY%.*}")")
done < <(find . -maxdepth 1 -name "$exported_zip_reg" -print0)

if [ ${#exported_foldername_array[*]} -lt 1 ]; then
    echo -e "ERROR: No zip file found matching '$exported_zip_reg'.\nExport from Notion and place in repo root."
    exit 100
fi

# Exported 폴더 처리
for exported_foldername in "${exported_foldername_array[@]}"; do
    md_files=(./"$exported_foldername"/*.md)

    # Markdown 파일 존재 여부 확인
    if [ ${#md_files[@]} -eq 0 ]; then
        echo "No Markdown file found in $exported_foldername. Skipping..."
        continue
    fi

    exported_filename=$(basename "${md_files[0]%.*}")
    exported_file_path="$exported_foldername/$exported_filename.md"

    # Title 추출
    meta_title=$(head -n 1 "$exported_file_path")
    if [[ $meta_title != "# "* ]]; then
        echo -n "Enter a title of the post: "
        read meta_title
    fi
    meta_title=$(echo "$meta_title" | sed 's/# //g')
    echo "For the \"$meta_title\" post..."

    meta_title_encoded=$(echo "$meta_title" | sed 's/[][\\^*+=,!?.:;&@()$-]/-/g' | sed 's/# //g' | sed 's/ /-/g' | sed 's/--/-/g')

    # Category 입력
    echo -n "Enter categories: "
    read meta_categories

    # 날짜 생성
    meta_date="$(date +%Y-%m-%d %H:%M:%S) +0900"

    # 메타데이터 삽입
    sed -i '' "1s|.*|---|" "$exported_file_path"
    sed -i '' -e $'1 a\\\n'"layout: post" "$exported_file_path"
    sed -i '' -e $'2 a\\\n'"title: $meta_title_encoded" "$exported_file_path"
    sed -i '' -e $'3 a\\\n'"date: $meta_date" "$exported_file_path"
    sed -i '' -e $'4 a\\\n'"category: $meta_categories" "$exported_file_path"
    sed -i '' -e $'5 a\\\n'"---" "$exported_file_path"

    # 고정 파일명
    fixed_filename="$(date +%Y-%m-%d)-$meta_title_encoded"

    # 이미지 경로 수정
    exported_filename_for_images_path=$(echo "$exported_filename" | sed 's/ /%20/g')
    sed -i '' "s|$exported_filename_for_images_path/Untitled|/$images_folder_path/$fixed_filename/Untitled|g" "$exported_file_path"

    # 폴더 생성
    mkdir -p "$posts_folder_path/$meta_categories"
    mkdir -p "$images_folder_path/$fixed_filename"

    # 파일 이동
    mv -i -v "$exported_file_path" "$posts_folder_path/$meta_categories/$fixed_filename.md"
    mv -i -v "$exported_foldername/$exported_filename" "$images_folder_path/$fixed_filename"

    # Git add/commit
    git add "$posts_folder_path/$meta_categories/$fixed_filename.md"
    git add "$images_folder_path/$fixed_filename"
    git commit -m "$fixed_filename is uploaded"

    # 임시 폴더 삭제
    rm -rf "$exported_foldername"
    rm -f "$exported_foldername.zip"

    echo -e "Work for the $meta_title post is completed!\n"
done

