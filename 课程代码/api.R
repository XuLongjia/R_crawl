library(jsonlite)
library(stringr)

#api调用地址
movie_api <- "https://api.douban.com/v2/movie/subject/"
#设置要查询的电影ID
movie_id <- "1291546"
#解析json文档为R对象
info_movie <- fromJSON(str_c(movie_api,movie_id))
#抽取目标信息
info_movie$casts$name
info_movie$casts$id
info_movie$rating$average
info_movie$summary
