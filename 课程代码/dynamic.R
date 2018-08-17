library(RSelenium) #操控浏览器
library(rvest) #解析HTML文档

remDr <- remoteDriver(browserName = "chrome") #建立与浏览器的连接
remDr$open() #打开远程操控的浏览器
remDr$navigate("https://www.haodf.com/")

#静态方法：抓取医院名称列表（默认：按综合排序）
url <- "https://www.guahao.com/s/%E9%AB%98%E8%A1%80%E5%8E%8B/hospital/1/%E5%8C%97%E4%BA%AC/all/%E5%8C%97%E4%BA%AC"
read_html(url,encoding = "utf-8") %>% html_nodes("a.cover-bg.seo-anchor-text") %>% html_text()

#动态方法：抓取医院名称列表（干预：按预约量排序）
remDr$navigate(url)
remDr$findElement("css selector","div.gfm-field > a:nth-child(3)")$clickElement()
remDr$getPageSource()[[1]] %>% read_html(encoding = "utf-8") %>% 
  html_nodes("a.cover-bg.seo-anchor-text") %>% html_text()

#跳转到好大夫在线的登陆页面
remDr$navigate("https://passport.haodf.com/user/showlogin")
#寻找到表单元素并输入账号与密码
remDr$findElement("css selector", "input#tel.userName")$sendKeysToElement(list("18810889628"))
remDr$findElement("css selector", "input#pass")$sendKeysToElement(list("Test1234567"))
#点击表单中的登陆按钮
remDr$findElement("css selector", "a.loginbynormal")$clickElement()

#导航到指定网址
url_dy <- "https://movie.douban.com/typerank?type_name=%E5%89%A7%E6%83%85&type=11&interval_id=100:90&action="
remDr$navigate(url_dy)
#尝试使用静态页面爬取方式
text_dy <- read_html(url_dy) %>% html_nodes("div.movie-list-panel.pictext span.movie-name-text a") %>%
  html_text()
text_dy
#尝试使用动态页面爬取方式
html_dy <- remDr$getPageSource()[[1]]
text_dy <- read_html(html_dy) %>% html_nodes("div.movie-list-panel.pictext span.movie-name-text a") %>% 
  html_text
text_dy
# 使用函数executeScript执行一个JavaScript片段，模拟滚动条向下拉取页面，单次拉取长度=页面剩余高度 
# 循环拉取，每次拉取都记录新的总高度，直到总高度不再变化（即页面加载不出新内容），则停止下拉操作
last_height = 0 
repeat { 
  remDr$executeScript("window.scrollTo(0,document.body.scrollHeight);", 
                      list(remDr$findElement("css", "body"))) 
  Sys.sleep(2) 
  new_height = remDr$executeScript("return document.body.scrollHeight",
                                   list(remDr$findElement("css", "body")))
  if(unlist(last_height) == unlist(new_height)) { 
    break 
  } else { 
    last_height = new_height 
  } 
}
#再次尝试使用动态页面爬取方式
remDr$getPageSource()[[1]] %>% read_html() %>% 
  html_nodes("div.movie-list-panel.pictext span.movie-name-text a") %>% 
  html_text()