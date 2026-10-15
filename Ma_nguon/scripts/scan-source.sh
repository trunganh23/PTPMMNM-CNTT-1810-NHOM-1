#!/usr/bin/env bash
set -u

target_dir="${1:-}"

# TODO 1: Kiem tra dau vao
if [[ -z "$target_dir" || ! -d "$target_dir" ]]; then
  echo "Thu muc khong hop le hoac khong ton tai" >&2
  exit 2
fi

# Tim tat ca cac file .php ke ca trong thu muc con va ten co dau cach
php_files=()
while IFS= read -r -d '' file; do
  php_files+=("$file")
done < <(find "$target_dir" -type f -name "*.php" -print0)

if [[ ${#php_files[@]} -eq 0 ]]; then
  echo "Khong co tep PHP de kiem tra" >&2
  exit 2
fi

# TODO 2: Duyet va dem file dung/sai cu phap
total=0
pass=0
fail=0

for file in "${php_files[@]}"; do
  total=$((total + 1))
  if php -l "$file" >/dev/null 2>&1; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
  fi
done

# TODO 3: Tong hop ket qua va tra ma thoat
printf 'TOTAL=%d PASS=%d FAIL=%d\n' "$total" "$pass" "$fail"

if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
exit 0
# Khung duyệt tệp đã được GV cấp; điền các TODO về điều kiện, đếm và mã thoát.
if [[ $# -ne 1 ]]; then echo 'Usage: scan-source.sh DIRECTORY' >&2; exit 2; fi
root="$1"
# TODO 1: thiếu/không đọc được thư mục hoặc thiếu php -> exit 2.
list="$(mktemp)" || exit 2
trap 'rm -f -- "$list"' EXIT
if ! find "$root" -type f -name '*.php' -print0 > "$list"; then exit 2; fi
total=0; passed=0; failed=0
while IFS= read -r -d '' file; do
  # TODO 2: tăng total; php -l "$file"; tăng passed hoặc failed.
  # Không dừng vòng lặp khi một tệp bị lỗi.
  :
done < "$list"
printf 'TOTAL=%s PASS=%s FAIL=%s\n' "$total" "$passed" "$failed"
# TODO 3: rỗng -> 2; có lỗi -> 1; tất cả đạt -> 0.
exit 3
