# 准备工作

- 数据库设计
- 基础结构搭建

## 数据库设计

> 根据我们的业务需要设计数据库的结构，这个过程是每个项目开始时所必须的，一般由专门的 DBA 角色完成（很多没有划分的非常具体的公司由后端开发人员兼任）。

![数据库结构](media/database.png)

### 选项表（options）

用于记录网站的一些配置属性信息，如：站点标题，站点描述等

| 字段 | 描述 | 备注 |
| ----- | ---- | ---------- |
| id | 🔑 主键 | &nbsp; |
| key | 属性键 | snake_case |
| value | 属性值 | JSON 格式 |

### 用户表（users）

用于记录用户信息

| 字段 | 描述 | 备注 |
| -------- | ------ | ---------------------------------------- |
| id | 🔑 主键 | &nbsp; |
| slug | URL 别名 | &nbsp; |
| email | 邮箱 | 亦做登录名 |
| password | 密码 | &nbsp; |
| nickname | 昵称 | &nbsp; |
| avatar | 头像 | 图片 URL 路径 |
| bio | 简介 | &nbsp； |
| status | 状态 | 未激活（unactivated）/ 激活（activated）/ 禁止（forbidden）/ 回收站（trashed） |

### 文章表（posts）

用于记录文章信息

| 字段 | 描述 | 备注 |
| ----------- | ------ | ---------------------------------------- |
| id | 🔑 主键 | &nbsp; |
| slug | URL 别名 | &nbsp; |
| title | 标题 | &nbsp; |
| feature | 特色图像 | 图片 URL 路径 |
| created | 创建时间 | &nbsp; |
| content | 内容 | &nbsp; |
| views | 浏览次数 | &nbsp; |
| likes | 点赞数 | &nbsp; |
| status | 状态 | 草稿（drafted）/ 已发布（published）/ 回收站（trashed） |
| user_id | 🔗 用户 ID | 当前文章的作者 ID |
| category_id | 🔗 分类 ID | 当前文章的分类 ID |

> 提问：为什么要用关联 ID？

<!-- 答：数据同步，便于维护 -->

### 分类表（categories）

用于记录文章分类信息

| 字段 | 描述 | 备注 |
| ---- | ------ | ------------------ |
| id | 🔑 主键 | &nbsp; |
| slug | URL 别名 | &nbsp; |
| name | 分类名称 | &nbsp; |

### 评论表（comments）

用于记录文章评论信息

| 字段 | 描述 | 备注 |
| --------- | ----- | ---------------------------------------- |
| id | 🔑 主键 | &nbsp; |
| author | 作者 | &nbsp; |
| email | 邮箱 | &nbsp; |
| created | 创建时间 | &nbsp; |
| content | 内容 | &nbsp; |
| status | 状态 | 待审核（held）/ 准许（approved）/ 拒绝（rejected）/ 回收站（trashed） |
| post_id | 🔗 文章 ID | &nbsp; |
| parent_id | 🔗 父级 ID | &nbsp; |

> 点击下载：[初始化数据库脚本](media/baixiu.sql)

---

## 搭建项目架构

项目最基本的分为两个大块，前台（对大众开放）和后台（仅对管理员开放）。

一般在实际项目中，很多人会把前台和后台分为两个项目去做，部署时也会分开部署：

- **前台访问地址**：`https://www.wedn.net/`
- **后台访问地址**：`https://admin.wedn.net/`

这样做相互独立不容易乱，也更加安全。但是有点麻烦，所以我们采用更为常见的方案：让后台作为一个子目录出现。这样的话，大体结构就是：

- **前台访问地址**：`https://www.wedn.net/`
- **后台访问地址**：`https://www.wedn.net/admin/`

### 基本的目录结构

```
└── baixiu ······································ 项目文件夹（网站根目录）
    ├── admin ··································· 后台文件夹
    │   └── index.php ··························· 后台脚本文件
    ├── static ·································· 静态文件夹
    │   ├── assets ······························ 资源文件夹
    │   └── uploads ····························· 上传文件夹
    └── index.php ······························· 前台脚本文件
```

#### 基本原则：

- 先明确一共有多少个页面
- 一个页面就对应一个 php 文件去处理

> 🚩 源代码: step-01

### 整合静态资源文件

#### 静态文件 vs. 动态文件

- 静态文件指的就是服务器不会经过任何处理就返回给客户端浏览器的文件，比如：图片、样式表、字体文件等
- 动态文件指的就是服务器会对请求的文件进行处理，并将处理后的结果返回给客户端浏览器的文件，比如：PHP 文件、ASP 文件、JSP 文件

#### 具体操作

由于 Apache / Nginx 这一类 Web Server 本身可以处理静态文件请求，所以不需要 PHP 处理静态文件请求。只需要将静态资源放到网站目录中，即可访问

```diff
└── baixiu ······································ 项目文件夹（网站根目录）
    ├── ......
    ├── static ·································· 静态文件夹
    │   ├── assets ······························ 资源文件夹
+   │   │   ├── css ····························· 样式文件夹
+   │   │   ├── img ····························· 图片文件夹
+   │   │   ├── js ······························ 脚本文件夹
+   │   │   └── venders ························· 第三方资源
    │   └── uploads ····························· 上传文件夹
+   │       └── 2017 ···························· 2017 年上传文件目录
    ├── ......
```

##### 注意：

- `static` 目录中只允许出现静态文件。
- `assets` 目录中放置网页中所需的资源文件。
- `uploads` 目录中放置网站运营过程中上传的文件，如果担心文件过多，可以按年归档（一年一个文件夹）。

> 🚩 源代码: step-02

### 项目配置文件

由于在接下来的开发过程中，肯定又一部分公共的成员，例如数据库名称，数据库主机，数据库用户名密码等，这些数据应该放到公共的地方，抽象成一个配置文件 `config.php` 放到项目根目录下。

这个配置文件采用定义常量的方式定义配置成员：

```php
/**
 * 数据库主机
 */
define('DB_HOST', '127.0.0.1');

/**
 * 数据库用户名
 */
define('DB_USER', 'root');

/**
 * 数据库密码
 */
define('DB_PASS', 'wanglei');

/**
 * 数据库名称
 */
define('DB_NAME', 'baixiu');
```

> 注意：这种只有服务端代码的 PHP 文件应该去除结尾处的 `?>`，防止输出内容

在需要的时候可以通过 `require` 载入：

```php
// 载入配置文件
require 'config.php';

...

// 用到的时候
echo DB_NAME;
```

> 🚩 源代码: step-03

#### 载入脚本的几种方式对比

> - `require`
> - `require_once`
> - `include`
> - `include_once`

- 共同点：
  + 都可以在当前 PHP 脚本文件执行时载入另外一个 PHP 脚本文件。
- `require` 和 `include` 不同点：
  + 当载入的脚本文件不存在时，`require` 会报一个致命错误（结束程序执行），而 `include` 不会
- 有 `once` 后缀的特点：
  + 判断当前载入的脚本文件是否已经载入过，如果载入了就不在执行

> 提问：由以上几种方式的对比可以得出：在载入 `config.php` 时使用哪种方式更合适？

<!-- 答：require_once，原因有二：1. 载入失败无法继续执行；2. 不能重复载入 -->

#### 显示 PHP 错误信息

当执行 PHP 文件发生错误时，如果在页面上不显示错误信息，只是提示 500 Internal Server Error 错误，应该是 PHP 配置的问题，解决方案就是：找到 `php.ini` 配置文件中 `display_errors` 选项，将值设置为 `On`

```ini
; http://php.net/display-errors
; display_errors = Off
display_errors = On

; The display of errors which occur during PHP's startup sequence are handled
```

---

## 项目架构总结

架构的目的就是搭建一个基本的架子或者说是制定一个基础的约束，让所有的开发人员基于这一个约束基础之上展开开发工作。

有利于后期维护（不至于写一段时间过后大家都不认识这个项目，找一个文件，找一个功能找半天）

例如 `venders` 目录

<!-- TODO: 为什么要这么设计 -->
<!-- 1. 一个请求对应一个文件处理方式 -->
<!-- 2. 单一入口应用程序方式 -->

---

## 开始编码

对于网站功能开发人员来说，他们在展开工作之前就已经完成了静态页面的制作，接下来就是具体开发每一个业务功能。

对于目前我们的情况来说，我们有两种方式：

1. 先把每一个静态页直接转换成一个对应的 PHP 文件，调整页面中的资源路径，然后在此静态页面可以访问的基础之上实现各个功能。
2. ~~一个功能一个功能的来。先明确要做的功能，建立对应的 PHP 文件，然后再把静态页贴进来，实现具体功能。~~

### 整合全部静态页面

1. 将静态页面全部拷贝到 `admin` 目录中。
2. 将文件扩展名由 `.html` 改为 `.php`，页面中的 `a` 链接也需要调整。
3. 调整页面文件中的静态资源路径，将原本的相对路径调整为绝对路径

#### 绝对路径 vs 相对路径（重点掌握）

1. 不会跟随当前页面的访问地址变化而变化
2. 更简单明了，不容易出错，不用一层一层的找

> 🚩 源代码: step-04

### 抽离公共部分

由于每一个页面中都有一部分代码（侧边栏）是相同的，分散到各个文件中，不便于维护，所以应该抽象到一个公共的文件中。

于是我们在 `admin` 目录中创建一个 `inc`（includes 的简称）子目录，在这个目录里创建一个 `sidebar.php` 文件，用于抽象公共的侧边栏 `<div class="aside"> ... </div>`，然后在每一个需要这个模块的页面中通过 `include` 载入：

```php
...
<?php include 'inc/sidebar.php' ;?>
...
```

> 提问：为什么使用 `include` 而不是 `require`？

<!-- 答：侧边栏不会影响其他模块，没有侧边栏其余代码应该也可以继续执行 -->

> 🚩 源代码: step-05

#### 侧边栏的焦点状态

由于侧边栏在不同页面时，active class name 出现的位置不尽相同，所以我们需要区分当前 `sidebar.php` 文件是在哪个页面中载入的，从而明确焦点状态。

所以目前的关键问题就出现在了如何在 `sidebar.php` 中知道当前被哪个文件载入了。

通过查看 `include` 函数的文档发现：如果 `a.php` 通过 `include` 载入了 `b.php` 文件，那么在 `b.php` 文件中可以访问到 `a.php` 中定义的变量。

> http://php.net/manual/zh/function.include.php

借助这个特性，我们可以在各个页面中定义一个标识变量，然后在 `sidebar.php` 中通过这个标识变量区别不同页面的载入：

每一个菜单项 `<li>` 元素：

```php
...
<li<?php echo $current_page == 'dashboard' ? ' class="active"' : ''; ?>>
  <a href="index.php"><i class="fa fa-dashboard"></i>仪表盘</a>
</li>
...
```

对于有子菜单的菜单项，有一点例外：

```php
···
<li<?php echo in_array($current_page, array('posts', 'post-add', 'categories')) ? ' class="active"' : ''; ?>>
  <a href="#menu-posts"<?php echo in_array($current_page, array('posts', 'post-add', 'categories')) ? '' : ' class="collapsed"'; ?> data-toggle="collapse">
    <i class="fa fa-thumb-tack"></i>文章<i class="fa fa-angle-right"></i>
  </a>
  <ul id="menu-posts" class="collapse<?php echo in_array($current_page, array('posts', 'post-add', 'categories')) ? ' in' : ''; ?>">
    <li<?php echo $current_page == 'posts' ? ' class="active"' : ''; ?>><a href="posts.php">所有文章</a></li>
    <li<?php echo $current_page == 'post-add' ? ' class="active"' : ''; ?>><a href="post-add.php">写文章</a></li>
    <li<?php echo $current_page == 'categories' ? ' class="active"' : ''; ?>><a href="categories.php">分类目录</a></li>
  </ul>
</li>
···
```

> 🚩 源代码: step-06
