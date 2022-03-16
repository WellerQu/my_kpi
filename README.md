# my_kpi

![示例](https://raw.githubusercontent.com/WellerQu/my_kpi/main/imgs/12A15B25-EA11-44B0-AF7C-74ABFB643F8C.png)

## 使用方法

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

  修改配置文件 `conf.sh` 中的配置项 **work_spaces**, **author**, **ignores**.

  | 配置项 | 类型 | 描述 |
  | -- | -- | -- |
  | `work_spaces` | 数组 | 需要被统计的目录, 该目录直接子级目录中应包含 .git 目录 |
  | `author` | 字符串 | gitconfig 中的 username |
  | `ignores` | 正则字符串 | 如果文件路径符合$ignores的描述, 则该文件的变更行数不会被纳入统计 |

- step 2 执行脚本

  执行 `./my_kpi.sh` 脚本获取统计信息
  执行 `./version.sh` 脚本获取版本信息

## 代码行数计算逻辑

对于每一个含有 `.git` 目录的目录, 会通过 `git branch` 获取到所有的本地分支. 在暂存当前未 commit 的文件变更后(如果有的话),
通过 `git checkout` 切换到每一个分支, 然后执行 `git log` 来获取每一个文件的变更信息, 将得到 **新增行数**, **删除行数** 和
目录地址(暂不显示). 基于新增行数和删除行数计算得到 **有效行数** (新增行数减去删除行数, 数学表达式为: loc = add - subs)
和 **变更行数** (新增行数加上删除行数, 数学表达式为: upd = add + subs). 意思就是, 我们将得到一个列表, 由每一个文件的新增行数, 删除行数,
有效行数, 变更行数, 以及文件完整名称(暂不显示)组成的列表. 对此列表汇总, 即得到最终结果.

## 注意事项

* 推荐使用 zsh, 其它 shell 暂时无法完美兼容

* 未保存的工作会丢失吗?

  不会丢失, 最多被 git stash 暂存而没有自动恢复. 这种情况将逐步得到改善.

* 为什么会出现统计行数比预期的要少?

  有两种情况:

  * 之一, 因为仅统计本地分支, 如果分支被删除, 则无法纳入统计.
  * 之二, 因为 `merge` 到当前分支的代码不会被纳入统计.
  * 之三, 因为出现了错误导致有些分支未被统计, 此时建议打开 `my_kpi.sh` 文件, 然后将 `set -x` 行的注释放开. 重新执行一次后将所有输出内容以 issue 的形式提交给我.
