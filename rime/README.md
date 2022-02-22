# 如何设置 RIME 自然码双拼
## Linux / MacOS

### 1 Install 東風破 /plum/
```shell
curl -fsSL https://git.io/rime-install | bash
```
### 2 Install 双拼输入法
```shell
bash rime-install double-pinyin
```
### 3 设置
default.custom.yaml
```yaml
# save it to:
#   ~/.config/ibus/rime  (linux)
#   ~/Library/Rime       (macos)
#   %APPDATA%\Rime       (windows)

patch:
  schema_list:
    - schema: double_pinyin
    - schema: luna_pinyin_simp
```
