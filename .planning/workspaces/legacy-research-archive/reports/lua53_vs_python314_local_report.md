# Lua 5.3.6 vs Python 3.14.0 本地对比

## 运行时

- Lua: `Lua 5.3` via `.tools\lua53\bin\lua.exe`
- Python: `CPython` `3.14.0 (tags/v3.14.0:ebf955d, Oct  7 2025, 10:15:03) [MSC v.1944 64 bit (AMD64)]`
- Python executable: `C:\Users\DCY1\AppData\Local\Programs\Python\Python314\python.exe`
- Platform: `Windows-11-10.0.26200-SP0`

## 启动开销

| 指标 | Lua 5.3.6 | Python 3.14.0 | Python/Lua |
| --- | ---: | ---: | ---: |
| 空进程启动中位数 | 6.019 ms | 17.284 ms | 2.87x |
| 空进程启动最小值 | 5.402 ms | 16.657 ms | 3.08x |

## 时间基准

| 项目 | Lua 5.3.6 中位数 | Python 3.14.0 中位数 | Python/Lua |
| --- | ---: | ---: | ---: |
| 整数运算 | 34.000 ms | 173.829 ms | 5.11x |
| 浮点运算 | 30.000 ms | 118.776 ms | 3.96x |
| 函数调用 | 52.000 ms | 132.031 ms | 2.54x |
| 顺序容器构建 | 6.000 ms | 19.727 ms | 3.29x |
| 顺序容器遍历求和 | 3.000 ms | 9.940 ms | 3.31x |
| 哈希容器构建 | 16.000 ms | 15.073 ms | 0.94x |
| 哈希容器查找 | 5.000 ms | 9.654 ms | 1.93x |

## 内存基准

| 项目 | Lua 5.3.6 | Python 3.14.0 | Python/Lua |
| --- | ---: | ---: | ---: |
| 空 table vs 空 list 平均开销 | 56.0 B | 56.0 B | 1.00x |
| 空 table vs 空 dict 平均开销 | 56.0 B | 64.0 B | 1.14x |
| 空 table vs 空 set 平均开销 | 56.0 B | 216.0 B | 3.86x |
| 数组型 100k int vs list | 2.000 MiB | 3.807 MiB | 1.90x |
| 数组型 100k int vs tuple | 2.000 MiB | 3.807 MiB | 1.90x |
| 数组型 100k int vs array('q') | 2.000 MiB | 797.734 KiB | 0.39x |
| 字典型 100k str->int | 4.000 MiB | 11.183 MiB | 2.80x |
| 集合型 100k str | 4.000 MiB | 8.472 MiB | 2.12x |
| 记录对象 vs Python dict 记录 | 184.0 B | 247.9 B | 1.35x |
| 记录对象 vs Python slots 记录 | 184.0 B | 119.9 B | 0.65x |

## Python 3.14 细分容器

| 容器 | 数值 |
| --- | ---: |
| `list` 100k int | 3.807 MiB |
| `tuple` 100k int | 3.807 MiB |
| `array('q')` 100k int | 797.734 KiB |
| `dict` 100k str->int | 11.183 MiB |
| `set` 100k str | 8.472 MiB |
| `dict` 记录平均开销 | 247.9 B |
| `dataclass(slots=True)` 记录平均开销 | 119.9 B |

## 方法说明

- 时间基准使用纯解释执行代码，不包含 NumPy、C 扩展或 LuaJIT。
- Lua 内存数据来自 `collectgarbage('count')` 堆增量；Python 内存数据来自 `tracemalloc` 活跃分配增量。
- Lua table 能同时承担数组、字典、集合、记录对象职责；Python 则拆分为多个专用容器，所以比较时应按场景看，而不是只盯着单一表结构。
