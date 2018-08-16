#载入程序包
library("xml2")
library("rvest")
library("stringr")

#创建url
url <- vector()
for(i in 1:2){
  url[i] <- str_c("https://www.haodf.com/faculty/DE4roiYGYZwXw0XD2kvYsPktj/menzhen_",i,".htm",sep="")
}

#创建空的dataframe存储数据
link<-vector()
name<-vector()
rank<-vector()
title_1<-vector()
title_2<-vector()
database<-data.frame(link,name,rank,title_1,title_2,stringsAsFactors = FALSE)
rm(link,name,rank,title_1,title_2)

#读取网页，解析变量
for(i in 1:2){
  #读取指定网页源码
  html <- read_html(url[i],encoding = "gb2312")
  #提取姓名
  name <- html_nodes(html,"li a.name")  %>% html_text(trim = TRUE)
  #提取职称
  title <- html_nodes(html,"td.tdnew_a li p:first-of-type")  %>% html_text(trim = TRUE) %>% str_split(" ")
  title_1 <- vector()
  for(i in 1:length(title)){title_1[i] <- title[[i]][1]}
  title_2 <- vector()
  for(i in 1:length(title)){title_2[i] <- title[[i]][2]}
  rm(title,i)
  #提取热度
  rank<- html_nodes(html,"span.patient_recommend i") %>% html_text(trim = TRUE)
  #提取链接
  link <- html_nodes(html,"td.tdnew_a li a.name") %>% html_attrs()
  for(i in 1:length(link)){link[i]<- link[[i]]["href"]}
  link <- unlist(link)
  #创建一个dataframe来存储提取的五个变量
  output<-data.frame(link,name,rank,title_1,title_2,stringsAsFactors = FALSE)
  
  #将本次循环获得的数据添加到database中
  database <- rbind(database,output)
}

rm(link,name,rank,title_1,title_2,i,url,html,output)

#输出
write.csv(database,file="test_pachong_2.csv")

