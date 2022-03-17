# my_kpi

![示例](https://raw.githubusercontent.com/WellerQu/my_kpi/main/imgs/short_mode_preview.png)

## 使用方法

NOTICE: 脚本执行过程中, 尽量不要 Ctrl-C 终端脚本执行, 否则可能会导致 git 目录工作状态不会自动恢复. 当然, 内容不会丢失.

- step 0 下载脚本

  ```shell
  git clone git@github.com:WellerQu/my_kpi.git
  ```

- step 1 新建配置脚本

  参照示例配置文件示例 `conf.example.sh` 在 `my_kpi.sh` 文件同级目录下创建配置文件 `conf.sh`, 结构如下:

  ```shell
  .
  ├── LICENSE
  ├── README.md
  ├── conf.example.sh
  ├── conf.sh
  ├── imgs
  ├── ... other files
  └── my_kpi.sh
  ```

  修改配置文件 `conf.sh` 中的带有 "*" 必填配置项

  | 配置项 | 类型 | 描述 |
  | -- | -- | -- |
  | `work_spaces`* | 数组 | 需要被统计的目录, 该目录直接子级目录中应包含 .git 目录 |
  | `author`* | 字符串 | gitconfig 中的 username |
  | `ignores`* | 正则字符串 | 如果文件路径符合$ignores的描述, 则该文件的变更行数不会被纳入统计 |
  | `exclude_branches` | 正则字符串 | 如果分支名符合$exclude_branches的描述, 则该分支的任何改动都不会被纳入统计 |
  | `theme` | 字符串 | themes 目录下的文件名(不包含.sh), 默认 "default" |

- step 2 执行脚本

  执行 `./my_kpi.sh` 脚本获取统计信息

  执行 `./my_kpi.sh -h` 获取帮助信息

  ```text
  my_kpi v1.7.0
  A simple tool for stat your numbers of code lines

  USAGE:
      my_kpi [OPTIONS]

  OPTIONS:
      -f
          Display complete information
      -d
          Display daily information
      -w
          Display weekly information
      -m
          Display monthly information
      -h
          Display help information

  Star me, please
  Power by https://github.com/WellerQu/my_kpi
  ```

## 代码行数计算逻辑

对于每一个含有 `.git` 目录的目录, 会通过 `git branch` 获取到所有的本地分支. 在暂存当前未 commit 的文件变更后(如果有的话),
通过 `git checkout` 切换到每一个分支, 然后执行 `git log` 来获取每一个文件的变更信息, 将得到 **新增行数**, **删除行数** 和
目录地址(暂不显示). 基于新增行数和删除行数计算得到 **有效行数** (新增行数减去删除行数, 数学表达式为: loc = add - subs)
和 **变更行数** (新增行数加上删除行数, 数学表达式为: upd = add + subs). 意思就是, 我们将得到一个列表, 由每一个文件的新增行数, 删除行数,
有效行数, 变更行数, 以及文件完整名称(暂不显示)组成的列表. 对此列表汇总, 即得到最终结果.

## 自定义主题

`themes/default.sh` 是一个必然被加载的主题资源, 但是仍然有机会可以覆盖default提供的配色. 只需要在 `themes/` 目录下创建自定义的 shell
 脚本, 并覆盖 `default.sh` 文件中的样式函数即可.

## 注意事项

- 推荐使用 zsh, 其它 shell 暂时无法完美兼容

- 未保存的工作会丢失吗?

  不会丢失, 最多被 git stash 暂存而没有自动恢复. 这种情况将逐步得到改善.

- 为什么会出现统计行数比预期的要少?

  有以下几种情况:

  - 因为仅统计本地分支, 如果分支被删除, 则无法纳入统计.
  - 因为 `merge` 到当前分支的代码不会被纳入统计.
  - 因为出现了错误导致有些分支未被统计, 此时建议打开 `my_kpi.sh` 文件, 然后将 `set -x` 行的注释放开. 重新执行一次后将所有输出内容以 issue 的形式提交给我.
  - 因为配置文件中的 author 为中文等东亚语言字符, 也可能会出现一些意外情况导致无法正确统计.
