#载入程序包
library("rvest")
library("stringr")

#读取指定网页源码
html <- read_html("https://movie.douban.com/top250",encoding = "utf-8")

#找到目标数据所在节点
nodes <- html_nodes(html,"div.hd a")

#提取文本信息
text <- html_text(nodes,trim = TRUE)

#提取抓取文本中的题目信息
str_extract(text,"[:alpha:]+")

#提取链接属性信息
url <- html_attr(nodes,"href")


