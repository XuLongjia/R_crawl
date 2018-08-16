library(RSelenium) #操控浏览器
library(xml2)
library(rvest) #解析HTML文档
library(stringr)

remDr <- remoteDriver(browserName = "chrome") #建立与浏览器的连接

remDr$open() #打开远程操控的浏览器
#进入挂号网
remDr$navigate("https://www.guahao.com/eteam/index")
#点击外科
remDr$findElement("css selector","ul.fix-clear > li:nth-child(2)")$clickElement()

#创建一个空的dataframe用来存储数据
info <- vector()
link <- vector()
database <- data.frame(info,link,stringsAsFactors = FALSE)
rm(info)

repeat{
  Sys.sleep(1)
  #读取网页
  html <- remDr$getPageSource()[[1]] %>% read_html(encoding = "utf-8")
  
  #提取团队信息 包括：名称\成员人数\医院名称\累计预约量
  info<- html_nodes(html,"div.result.fix-clear ul li div.info ") %>% html_text(trim = TRUE) 
  
  link <- html_nodes(html,"div.result.fix-clear ul li div.info div.title span.name a ") %>% html_attr("href") 
  
  output <- data.frame(info,link,stringsAsFactors = FALSE)
  #将本次循环的数据加入到database中去
  database<- rbind(database,output)
  rm(output,info,link)
  
  #判断是否需要结束循环
  if(length(html_nodes(html,"div.page a.active+a")) ==0){
    break
  } 
  remDr$findElement("css selector","div.page a.active+a")$clickElement()
}

info_list <- str_split(database$info,"\\s+") 
#提取团队名称
team <- vector()
for(i in (1:length(info_list))){team[i] <- info_list[[i]][1] }

#提取成员人数
amount <- vector()
for(i in (1:length(info_list))){amount[i] <- info_list[[i]][2]}
amount <- str_sub(amount,start = 3,end = 3)

#提取医院名称
hospital <- vector()
for(i in (1:length(info_list))){hospital[i] <- info_list[[i]][3]}

#提取累计预约量
total <- vector()
for(i in (1:length(info_list))){total[i] <- info_list[[i]][4]}
total <- str_sub(total,start = 5,end = 5)

#提取团队url
link <- database$link 
link <- str_c("https://www.guahao.com",link)

#更新databse
database <- data.frame(team,amount,hospital,total,link,stringsAsFactors = FALSE)
rm(team,amount,hospital,total,link,i,info_list)

#将database输出到本地
write.csv(database,file = "爬虫练习.csv")
