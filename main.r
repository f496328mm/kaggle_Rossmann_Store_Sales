

	#install.packages("data.table")
	#install.packages("xgboost")
	#install.packages("snow")
	#install.packages("xlsx")
	#install.packages("glmnet")
	#install.packages("dplyr")
	#install.packages("moments")

	library(data.table)
	library(xgboost)
	library(snow)
	library(xlsx)
	library(glmnet)
	library(dplyr)
	library(moments)

	setwd("g:\\kaggle3")

	main.train=fread("train.csv")
	main.test=fread("test.csv")
	store <- fread("store.csv")

	#新增類別變數
	num = c(1:1115)
	num = num[num %in% levels( factor(main.test$Store) ) ]
	main.train2 = new.variable.fun(main.train,c(1:1115))
	main.test2 = new.variable.fun(main.test,num)

	#刪除open==0  分別生成年月日變數
	main.train3 = month.day.train.fun( main.train2 )
	main.test3  = month.day.test.fun( main.test2 )

	#刪除sales=0的data，因為這種情形不合理
	main.train4 = filter(main.train3,Sales !=0 )


	#data 分割
	main.train.y=filter(main.train4,date >=16600)#48天要預測當作y
	main.train.x=filter(main.train4,date < 16600)#48天前資料

	
	#main.train.x=filter(main.train,date >0)#實際 預測10
	#main.train.x.2=filter(main.train,date >= 16600)#實際 預測10
	#-------------------------------------------------------------
	#-------------------------------------------------------------
	result1 = pred.fun(main.train.x,main.train.y,main.test3)
	#-------------------------------------------------------------
	result3 = result1 %>% arrange(Id)

	gc()
	write.csv(result3,"pred1.csv",row.names = FALSE)




