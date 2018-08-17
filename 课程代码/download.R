library(rvest)

html <- read_html("https://www.sohu.com/a/218607373_267160")
urls <- html %>% html_nodes("article img") %>% html_attr("src")
urls

#批量下载图片到img文件夹中
for(i in 1:length(urls)){
  file_name = str_c("img","/",i,".jpeg")
  download.file(urls[i],destfile = file_name, method = "curl")
}
