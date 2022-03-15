# my_kpi

![示例](https://raw.githubusercontent.com/WellerQu/my_kpi/main/imgs/12A15B25-EA11-44B0-AF7C-74ABFB643F8C.png)

**推荐使用 zsh**

**推荐使用 zsh**

**推荐使用 zsh**

## 使用方法

```shell
git clone git@github.com:WellerQu/my_kpi.git && cd $_
vim my_kpi.sh
```

参照示例修改 **work_spaces**, **author**, **ignores** 配置项.

| 配置项 | 类型 | 描述 |
| -- | -- | -- |
| `work_spaces` | 数组 | 需要被统计的目录, 该目录直接子级目录中应包含 .git 目录 |
| `author` | 字符串 | gitconfig 中的 username |
| `ignores` | 正则字符串 | 如果文件路径符合$ignores的描述, 则该文件的变更行数不会被纳入统计 |

## 注意事项

* 推荐使用 zsh, 其它 shell 暂时无法完美兼容

* 未保存的工作会丢失吗?

  不会丢失, 最多被 git stash 暂存而没有自动恢复. 这种情况将逐步得到改善.

* 为什么会出现统计行数比预期的要少?

  有两种情况:

  - 之一, 因为仅统计本地分支, 如果分支被删除, 则无法纳入统计.
  - 之二, 因为 `merge` 到当前分支的代码不会被纳入统计.
  - 之三, 因为出现了错误导致有些分支未被统计, 此时建议打开 `my_kpi.sh` 文件, 然后将 `set -x` 行的注释放开. 重新执行一次后将所有输出内容以 issue 的形式提交给我.

