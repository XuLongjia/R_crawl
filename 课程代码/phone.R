library(jsonlite)

url_1 <- "https://api.chunyuyisheng.com/api/v4/doctor_search_v2/?from_type=zhaoyisheng&page=1&filter=%7B%22clinic_no%22%3A%229%22%2C%22is_expert%22%3A0%2C%22service_type_list%22%3A%5B%5D%7D&query_id=13157747&lat=39.959281&lon=116.317463&app=0&platform=android&systemVer=6.0&version=8.5.12&app_ver=8.5.12&imei=869511021017260&device_id=869511021017260&mac=02%3A00%3A00%3A00%3A00%3A00&secureId=440279e1e5751074&installId=1529132504394&phoneType=HUAWEI+GRA-TL00_by_HUAWEI&vendor=yingyongbao1&screen_height=1812&screen_width=1080"
destination <- fromJSON(url_1)
doctors <- destination$doctor_list
doctors[1:20,c("name","title","clinic_name","price_str","purchase_num")]

url_2 <- "https://api.chunyuyisheng.com/api/v4/doctor_search_v2/?from_type=zhaoyisheng&page=2&filter=%7B%22clinic_no%22%3A%229%22%2C%22is_expert%22%3A0%2C%22service_type_list%22%3A%5B%5D%7D&query_id=13157747&lat=39.959281&lon=116.317463&app=0&platform=android&systemVer=6.0&version=8.5.12&app_ver=8.5.12&imei=869511021017260&device_id=869511021017260&mac=02%3A00%3A00%3A00%3A00%3A00&secureId=440279e1e5751074&installId=1529132504394&phoneType=HUAWEI+GRA-TL00_by_HUAWEI&vendor=yingyongbao1&screen_height=1812&screen_width=1080"
destination <- fromJSON(url_2)
doctors <- destination$doctor_list
doctors[1:20,c("name","title","is_famous_doctor","clinic_name","price_str","purchase_num")]
