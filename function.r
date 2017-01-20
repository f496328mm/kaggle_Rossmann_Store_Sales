
kaggle.fun=function(y,y.hat){
		y.hat=round(y.hat)
		n=length(y)
		value = 
		((y-y.hat)/y)^2 %>%
		sum(.)/n 
		value2 = sqrt(value)
		return(value)
}

	RMSPE <- function(true_data, pred_data){ #Function input: 2 vectors with values for real sales and predicted sales
	
	  #Filter out values, where true sales = 0 (according to evaluation)
	  y <- true_data[true_data > 0]
	  y_hat <- pred_data[true_data > 0]
	
	  #Return resulting RMSPE
	  return(sqrt(mean(((y-y_hat)/y)^2)))
	}


work.train.test.map.fun2=function(n,amount){
	#n=nrow(train.x)
	num=c(1:n)	
	if( n*0.7>=amount){
		n1 = sample(num,amount)
	}else if( n*0.7<amount){
		n1 = sample(num,n*1)		
	}	
	n2=num[-n1]
	return(list(n1,n2))
}

work.train.data.fun=function(test2){

	temp	 = work.train.test.map.fun2( nrow(test2),2000000 )

	train.num=temp[[1]]
	test.num=temp[[2]]

	train=test2[train.num,]
	test3=test2[test.num,]
	return( list(train,test3) )
}
 
xgb.fun=function(train,test3,nro,eta=0.1,md=10,cb=0.5,start,ss,npt){

	clf <- xgb.train(params=list(  objective="reg:linear", 
                               booster = "gbtree",
                               eta=eta, 
                               max_depth=md, 
                               colsample_bytree=cb,
							subsample           = ss
							,num_parallel_tree=npt
				) ,
                	data = xgb.DMatrix(
				data=data.matrix(
				train[,c(start:ncol(train)),with=FALSE]),
                	label=data.matrix(train[,.(log.sale)])
				,missing=NA), 
				nrounds =nro,
                 maximize            = TRUE,
				eval_metric='rmse'
	)

	pred1<-predict(clf,xgb.DMatrix(data.matrix(
					train[,c(start:ncol(train)),with=FALSE]),
					missing=NA))
	pred1.log = exp( pred1 )-5

	value1 = RMSPE(train$Sales,pred1.log)

	pred2<-predict(clf,xgb.DMatrix(data.matrix(
					test3[,c(start:ncol(test3)),with=FALSE]),
					missing=NA))
	pred2.log = exp( pred2 )

	pred2.log[pred2.log<0]=0
	value2 = RMSPE(test3$Sales,pred2.log)
#--------------------------------------------------------------------------
	return( list( c(value1,value2 ) , clf ) )
}

work.model.fun2=function(main.train.y,
                         sample.amount,test){
  
  #----------------------------------------------------------------
  set.seed(100)
  temp = work.train.data.fun( test )
  train=data.table( temp[[1]] )
  test3=data.table( temp[[2]] )
  set.seed(100)
  value = xgb.fun(train,test3,51,0.1,18,0.45,29,1,9)
  (v1=value[[1]])
  
  model1=value[[2]]
  #----------------------------------------------------------------
  return(list(c(v1),model1))
}
	
work.var.fun=function(main.train.x){

	main.train.x$log.sale	= log( main.train.x$Sales +5)	#sale
	main.train.x$log.cus	= log( main.train.x$Customers+5)
	#--------------------------------------------------------------------------------------------
	mean.sale.store 		= main.train.x[, .(mean.sale.store = mean(log.sale)), by = .(Store)]
	mean.sale.weekday		= main.train.x[, .(mean.sale.weekday = mean(log.sale)), by = .(DayOfWeek)]
	mean.sale.promo 		= main.train.x[, .(mean.sale.promo = mean(log.sale)), by = .(Promo)]#促銷
	mean.sale.month 		= main.train.x[, .(mean.sale.month = mean(log.sale)), by = .(month)]
	mean.sale.day 		= main.train.x[, .(mean.sale.day = mean(log.sale)), by = .(day)]
	mean.sale.year 		= main.train.x[, .(mean.sale.year= mean(log.sale)), by = .(year)]
	mean.sale.school.h	= main.train.x[, .(mean.sale.school.h = mean(log.sale)), by = .(SchoolHoliday)]
	mean.sale.StoreType	= main.train.x[, .(mean.sale.StoreType = mean(log.sale)), by = .(StoreType)]
	mean.sale.Assortment	= main.train.x[, .(mean.sale.Assortment= mean(log.sale)), by = .(Assortment)]
	mean.sale.cd	 		= main.train.x[, .(mean.sale.cd = mean(log.sale)), by = .(CompetitionDistance)]
	mean.sale.co	 		= main.train.x[, .(mean.sale.co = mean(log.sale)), by = .(CompetitionOpenSinceYear)]
	mean.sale.promo2		= main.train.x[, .(mean.sale.promo2= mean(log.sale)), by = .(Promo2)]
	mean.sale.p2sy		= main.train.x[, .(mean.sale.p2sy= mean(log.sale)), by = .(Promo2SinceYear)]
	mean.sale.pi			= main.train.x[, .(mean.sale.pi= mean(log.sale)), by = .(PromoInterval)]

	mean.sale.yesop		= main.train.x[, .(mean.sale.yesop= mean(log.sale)), by = .(yesterday.open)]
	mean.sale.tomop		= main.train.x[, .(mean.sale.tomop= mean(log.sale)), by = .(tomorrow.open)]
	mean.sale.yespro		= main.train.x[, .(mean.sale.yespro= mean(log.sale)), by = .(yesterday.promo)]
	mean.sale.tompro		= main.train.x[, .(mean.sale.tompro= mean(log.sale)), by = .(tomorrow.promo)]
	mean.sale.fir			= main.train.x[, .(mean.sale.fir= mean(log.sale)), by = .(first)]
	#--------------------------------------------------------------------------------------------
	mean.sale.store.weekday 	= 
		main.train.x[, .(mean.sale.store.weekday = mean(log.sale)), by = .(Store,DayOfWeek)]
	mean.sale.store.promo	= 
		main.train.x[, .(mean.sale.store.promo= mean(log.sale)), by = .(Store,Promo)]
	mean.sale.store.month 	= 
		main.train.x[, .(mean.sale.store.month= mean(log.sale)), by = .(Store,month)]
	mean.sale.store.day 	= 
		main.train.x[, .(mean.sale.store.day= mean(log.sale)), by = .(Store,day)]
	mean.sale.store.school.h	= 
		main.train.x[, .(mean.sale.store.school.h= mean(log.sale)), by = .(Store,SchoolHoliday)]
	mean.sale.store.StoreType	= 
		main.train.x[, .(mean.sale.store.StoreType= mean(log.sale)), by = .(Store,StoreType)]
	mean.sale.store.Assortment	= 
		main.train.x[, .(mean.sale.store.Assortment= mean(log.sale)), by = .(Store,Assortment)]
	mean.sale.store.cd	= 
		main.train.x[, .(mean.sale.store.cd= mean(log.sale)), by = .(Store,CompetitionDistance)]
	mean.sale.store.promo2	= 
		main.train.x[, .(mean.sale.store.promo2= mean(log.sale)), by = .(Store,Promo2)]
	mean.sale.store.co	= 
		main.train.x[, .(mean.sale.store.co= mean(log.sale)), by = .(Store,CompetitionOpenSinceYear)]
	mean.sale.sy	= 
		main.train.x[, .(mean.sale.sy= mean(log.sale)), by = .(Store,year)]
	#--------------------------------------------------------------------------------------------
	mean.sale.sdm	= main.train.x[, .(mean.sale.sdm = mean(log.sale)), 
							by = .(Store,DayOfWeek,month)]
	ppp = main.train.x[,.(ppp=mean(Sales)/mean(Customers)),by=Store]
	mean.cus.sdpm = 
		main.train.x[,.(mean.cus.sdpm=mean(log.cus)),
			by=.(Store,DayOfWeek,Promo,month)]
	mean.sale.smy 	= 
		main.train.x[, .(mean.sale.smy= mean(log.sale)), by = .(Store,month,year)]
	mean.sale.swc 	= 
		main.train.x[, .(mean.sale.swc = mean(log.sale)), by = .(Store,DayOfWeek,CompetitionDistance)]
	#--------------------------------------------------------------------------------------------

	open.rate 	= 
		main.train[, .(open.rate = mean(Open) ), by = .(Store)]

	#--------------------------------------------------------------------------------------------
	mean.sale.swpm	= main.train.x[, .(mean.sale.swpm = mean(log.sale)), 
							by = .(Store,DayOfWeek,Promo,month)]
	mean.sale.swpm.st.sc	= main.train.x[, .(mean.sale.swpm.st.sc = mean(log.sale)), 
							by = .(Store,DayOfWeek,Promo,month,StateHoliday,SchoolHoliday)]
	sd.sale.swpm.st.sc	= main.train.x[, .(sd.sale.swpm.st.sc = sd(log.sale)), 
							by = .(Store,DayOfWeek,Promo,month,StateHoliday,SchoolHoliday)]
	#--------------------------------------------------------------------------------------------
	return( list(
	mean.sale.store,				mean.sale.weekday	,	
	mean.sale.promo,				mean.sale.month 	,	
	mean.sale.day,				mean.sale.school.h,
	mean.sale.StoreType,			mean.sale.Assortment	,
	mean.sale.cd,	mean.sale.promo2,
	mean.sale.store.weekday, 		mean.sale.store.promo	,
	mean.sale.store.month,		mean.sale.store.day 	,
	mean.sale.store.school.h,		mean.sale.store.StoreType,	
	mean.sale.store.Assortment,	mean.sale.store.cd,	
	mean.sale.store.promo2,		mean.sale.swpm,		
	mean.sale.swpm.st.sc,			sd.sale.swpm.st.sc,
	mean.sale.co,					mean.sale.store.co,
	mean.sale.p2sy,				mean.sale.pi,
	mean.sale.sdm,				ppp,
	mean.cus.sdpm,				mean.sale.year,
	mean.sale.sy,					mean.sale.swc,
	open.rate,
	mean.sale.yesop,		
	mean.sale.tomop,		
	mean.sale.yespro,		
	mean.sale.tompro,	
	mean.sale.fir		
	) )
}

pred.fun=function(main.train.x,main.train.y,main.test3){
  #--------------------------------------------------------------------------------------------
  #生變數
  main.train.y$log.sale=log(main.train.y$Sales+5)
  main.train.x = data.table(main.train.x)
  
  temp = work.var.fun(main.train.x)
  mean.sale.store				=temp[[1]]			
  mean.sale.weekday				=temp[[2]]	
  mean.sale.promo				=temp[[3]]				
  mean.sale.month 				=temp[[4]]
  mean.sale.day					=temp[[5]]				
  mean.sale.school.h			=temp[[6]]
  mean.sale.StoreType			=temp[[7]]			
  mean.sale.Assortment			=temp[[8]]
  mean.sale.cd					=temp[[9]]
  mean.sale.promo2				=temp[[10]]
  mean.sale.store.weekday		=temp[[11]]		
  mean.sale.store.promo			=temp[[12]]
  mean.sale.store.month			=temp[[13]]
  mean.sale.store.day 			=temp[[14]]
  mean.sale.store.school.h		=temp[[15]]
  mean.sale.store.StoreType		=temp[[16]]
  mean.sale.store.Assortment		=temp[[17]]
  mean.sale.store.cd			=temp[[18]]
  mean.sale.store.promo2		=temp[[19]]
  mean.sale.swpm				=temp[[20]]
  mean.sale.swpm.st.sc			=temp[[21]]
  sd.sale.swpm.st.sc			=temp[[22]]
  mean.sale.co					=temp[[23]]
  mean.sale.store.co			=temp[[24]]
  mean.sale.p2sy				=temp[[25]]
  mean.sale.pi					=temp[[26]]
  mean.sale.sdm					=temp[[27]]
  ppp							=temp[[28]]
  mean.cus.sdpm					=temp[[29]]
  mean.sale.year				=temp[[30]]
  mean.sale.sy					=temp[[31]]
  mean.sale.swc					=temp[[32]]
  open.rate					=temp[[33]]
  mean.sale.yesop				=temp[[34]]		
  mean.sale.tomop				=temp[[35]]		
  mean.sale.yespro				=temp[[36]]		
  mean.sale.tompro				=temp[[37]]	
  mean.sale.fir					=temp[[38]]	
  
  gc()
  #--------------------------------------------------------------------------------------------
  test = work.test.fun(1,main.test,main.train.y,
                       sample.amount,
                       mean.sale.store,				mean.sale.weekday	,	
                       mean.sale.promo,				mean.sale.month 	,	
                       mean.sale.day,				mean.sale.school.h,
                       mean.sale.StoreType,			mean.sale.Assortment	,
                       mean.sale.cd,	mean.sale.promo2,
                       mean.sale.store.weekday, 		mean.sale.store.promo	,
                       mean.sale.store.month,		mean.sale.store.day 	,
                       mean.sale.store.school.h,		mean.sale.store.StoreType,	
                       mean.sale.store.Assortment,	mean.sale.store.cd,	
                       mean.sale.store.promo2,		mean.sale.swpm,		
                       mean.sale.swpm.st.sc,			sd.sale.swpm.st.sc,
                       mean.sale.co,					mean.sale.store.co,
                       mean.sale.p2sy,				mean.sale.pi,
                       mean.sale.sdm,				ppp,
                       mean.cus.sdpm,				mean.sale.year,
                       mean.sale.sy,					mean.sale.swc,
                       open.rate,
                       mean.sale.yesop,		
                       mean.sale.tomop,		
                       mean.sale.yespro,		
                       mean.sale.tompro,	
                       mean.sale.fir)
  #--------------------------------------------------------------------------------------------
  #xgb model
  sample.amount = nrow(main.train.y)
  temp2 = work.model.fun2(main.train.y,sample.amount,
                          test)
  print( temp2[[1]] )
  model.xgb=temp2[[2]]
  #----------------------------------------------------------
  #glmnet model
  temp = work.glmnet.model.fun(test)
  
  model.glmnet = temp[[1]]
  print(temp[[2]])
  #-----------------------------------------------------------------
  #模型生好了   接下來是預測
  #--------------------------------------------------------------------------------------------
  #---------------------------------------------------
  #---------------------------------------------------
  pred.data = 
    work.test.fun(0,main.test3,main.train.y,
                  sample.amount,
                  mean.sale.store,				mean.sale.weekday	,	
                  mean.sale.promo,				mean.sale.month 	,	
                  mean.sale.day,				mean.sale.school.h,
                  mean.sale.StoreType,			mean.sale.Assortment	,
                  mean.sale.cd,	mean.sale.promo2,
                  mean.sale.store.weekday, 		mean.sale.store.promo	,
                  mean.sale.store.month,		mean.sale.store.day 	,
                  mean.sale.store.school.h,		mean.sale.store.StoreType,	
                  mean.sale.store.Assortment,	mean.sale.store.cd,	
                  mean.sale.store.promo2,		mean.sale.swpm,		
                  mean.sale.swpm.st.sc,			sd.sale.swpm.st.sc,
                  mean.sale.co,					mean.sale.store.co,
                  mean.sale.p2sy,				mean.sale.pi,
                  mean.sale.sdm,				ppp,
                  mean.cus.sdpm,				mean.sale.year,
                  mean.sale.sy,					mean.sale.swc	,
                  open.rate,
                  mean.sale.yesop,		
                  mean.sale.tomop,		
                  mean.sale.yespro,		
                  mean.sale.tompro,	
                  mean.sale.fir	)
  
  result.glmnet = work.finish.pred.fun(model.glmnet,model.xgb,pred.data,1)
  result.glmnet$Sales = round( result.glmnet$Sales*0.968 , digits=0)
  result.xgb = work.finish.pred.fun(model.glmnet,model.xgb,pred.data,2)
  
  result.glmnet = data.table( result.glmnet )
  
  result3 = result.glmnet[,.(Id)]
  
  result3$Sales = 
    round( ( result.glmnet$Sales + result.xgb$Sales )*0.5 , digits = 0)
  
  return(result3)
}

month.day.train.fun=function(main.train){

	#開店才有意義
	main.train =	filter(main.train,Open ==1 )
				#filter(main.train,Open ==1 )  
				#filter(.,Sales >0 )

	#日期轉數字，用於篩選data
	main.train$date=
	main.train$Date %>%
	as.Date(., format = "%Y-%m-%d") %>%
	as.numeric(.)	

	#train
	#月份
	main.train$month =
	main.train$Date %>%
	as.Date(.) %>%
	format(.,"%m")

	#日期
	main.train$day =
	main.train$Date %>%
	as.Date(.) %>%
	format(.,"%d")

	#日期
	main.train$year =
	main.train$Date %>%
	as.Date(.) %>%
	format(.,"%y")

	main.train = merge( main.train , store , by=c("Store"))
	return(main.train)
}

month.day.test.fun=function(main.test){

	#test
	#月份
	main.test$month =
	main.test$Date %>%
	as.Date(.) %>%
	format(.,"%m")

	#日期
	main.test$day =
	main.test$Date %>%
	as.Date(.) %>%
	format(.,"%d")
	
	#日期
	main.test$year =
	main.test$Date %>%
	as.Date(.) %>%
	format(.,"%y")

	main.test = merge( main.test, store , by=c("Store"))

	return(main.test)
}

work.test.fun=function(bo,main.test,main.train.y,
			sample.amount,
			mean.sale.store,				mean.sale.weekday	,	
			mean.sale.promo,				mean.sale.month 	,	
			mean.sale.day,				mean.sale.school.h,
			mean.sale.StoreType,			mean.sale.Assortment	,
			mean.sale.cd,	mean.sale.promo2,
			mean.sale.store.weekday, 		mean.sale.store.promo	,
			mean.sale.store.month,		mean.sale.store.day 	,
			mean.sale.store.school.h,		mean.sale.store.StoreType,	
			mean.sale.store.Assortment,	mean.sale.store.cd,	
			mean.sale.store.promo2,		mean.sale.swpm,		
			mean.sale.swpm.st.sc,			sd.sale.swpm.st.sc,
			mean.sale.co,					mean.sale.store.co,
			mean.sale.p2sy,				mean.sale.pi,
			mean.sale.sdm,				ppp,
			mean.cus.sdpm,				mean.sale.year,
			mean.sale.sy,					mean.sale.swc,
			open.rate,
			mean.sale.yesop,		
			mean.sale.tomop,		
			mean.sale.yespro,		
			mean.sale.tompro,	
			mean.sale.fir	,				sd.sale.store	){

	if(bo==1){
		sample.amount=nrow(main.train.y)
		set.seed(100)
		n=sample.amount
		num = sample( c( 1:sample.amount ) ,n )
		
		test = main.train.y[num,]	
	}else if(bo==0){
		test = main.test
	}
	#--------------------------------------------------------------------------------------------
	test = merge(test , mean.sale.store, all.x = TRUE, by = c("Store"))
	test = merge(test , mean.sale.weekday, all.x = TRUE, by = c("DayOfWeek"))
	test = merge(test , mean.sale.promo, all.x = TRUE, by = c("Promo"))

	test = merge(test , mean.sale.month, all.x = TRUE, by = c("month"))
	test = merge(test , mean.sale.day, all.x = TRUE, by = c("day"))
	test = merge(test , mean.sale.school.h, all.x = TRUE, by = c("SchoolHoliday"))

	test = merge(test , mean.sale.StoreType, all.x = TRUE, by = c("StoreType"))
	test = merge(test , mean.sale.Assortment, all.x = TRUE, by = c("Assortment"))
	test = merge(test , mean.sale.cd, all.x = TRUE, by = c("CompetitionDistance"))
	test = merge(test , mean.sale.promo2, all.x = TRUE, by = c("Promo2"))

	test = merge(test , mean.sale.co, all.x = TRUE, by = c("CompetitionOpenSinceYear"))
	test = merge(test , mean.sale.p2sy, all.x = TRUE, by = c("Promo2SinceYear"))
	test = merge(test , mean.sale.pi, all.x = TRUE, by = c("PromoInterval"))

	#test = merge(test , mean.sale.year, all.x = TRUE, by = c("year"))

	test = merge(test , open.rate, all.x = TRUE, by = c("Store"))
	#--------------------------------------------------------------------------------------------
	test = merge(test , mean.sale.store.weekday, all.x = TRUE, by = c("Store","DayOfWeek"))
	test = merge(test , mean.sale.store.promo, all.x = TRUE, by = c("Store","Promo"))
	test = merge(test , mean.sale.store.month, all.x = TRUE, by = c("Store","month"))
	#test = merge(test , mean.sale.store.day, all.x = TRUE, by = c("Store","day"))
	test = merge(test , mean.sale.store.school.h, all.x = TRUE, by = c("Store","SchoolHoliday"))

	test = merge(test , mean.sale.store.StoreType, all.x = TRUE, by = c("Store","StoreType"))
	test = merge(test , mean.sale.store.Assortment, all.x = TRUE, by = c("Store","Assortment"))
	test = merge(test , mean.sale.store.cd, all.x = TRUE, by = c("Store","CompetitionDistance"))
	test = merge(test , mean.sale.store.promo2, all.x = TRUE, by = c("Store","Promo2"))
	test = merge(test , mean.sale.store.co, all.x = TRUE, by = c("Store","CompetitionOpenSinceYear"))

	test = merge(test , mean.sale.sy, all.x = TRUE, by = c("Store","year"))
	#--------------------------------------------------------------------------------------------
	#test = merge(test , mean.sale.sdm, all.x = TRUE, by = c("Store","DayOfWeek","month"))
	#test = merge(test , ppp, all.x = TRUE, by = c("Store"))
	#test = merge(test , mean.cus.sdpm , all.x = TRUE, by = c("Store","DayOfWeek","Promo","month"))

	#test = merge(test , mean.sale.swc , all.x = TRUE, 
	#		by = c("Store","DayOfWeek","CompetitionDistance"))
	#--------------------------------------------------------------------------------------------
	test = merge(test , mean.sale.swpm, all.x = TRUE, 
			by = c("Store","DayOfWeek","Promo","month"))
	#test = merge(test , mean.sale.swpm.st.sc, all.x = TRUE, 
	#		by = c("Store","DayOfWeek","month","Promo","StateHoliday","SchoolHoliday"))
	#test = merge(test , sd.sale.swpm.st.sc, all.x = TRUE, 
	#		by = c("Store","DayOfWeek","month","Promo","StateHoliday","SchoolHoliday"))
	#--------------------------------------------------------------------------------------------
	#test = merge(test , mean.sale.swpmc, all.x = TRUE, 
	#		by = c("Store","DayOfWeek","Promo","month","CompetitionDistance"))
	#test = merge(test , mean.cus.sy, all.x = TRUE, 
	#		by = c("Store","year"))
	#test = merge(test , mean.sale.swp2m, all.x = TRUE, 
	#		by = c("Store","DayOfWeek","Promo2","month"))
	#--------------------------------------------------------------------------------------------
	test = merge(test , mean.sale.yesop, all.x = TRUE, by = c("yesterday.open"))
	#test = merge(test , mean.sale.tomop, all.x = TRUE, by = c("tomorrow.open"))
	#test = merge(test , mean.sale.yespro,all.x = TRUE, by = c("yesterday.promo"))
	test = merge(test , mean.sale.tompro,all.x = TRUE, by = c("tomorrow.promo"))
	#test = merge(test , mean.sale.fir,   all.x = TRUE, by = c("first"))

	return(test)
}


new.variable.fun=function(main.train2,num){
	data3 = 	sapply(num , 
			function(x) 
			work.yes.fir.tom.fun(main.train2,x)
			)

	data4 = do.call("rbind",data3)
	
	return(data4)
}

work.yes.fir.tom.fun=function(main.train2,i){

	data = 
	main.train2 %>%
	filter(.,Store==i) %>%
	arrange(Date)

	x=as.integer(data$Open[1:(nrow(data)-1)]==1)
	data$yesterday.open=c( "NA", x )
	x2=as.integer(data$Open[2:(nrow(data))]==1)
	data$tomorrow.open=c( x2,"NA" )

	data=
	cbind(data,	
	yesterday.promo=c( 0,data$Promo[1:(nrow(data)-1) ] )
	)

	data=
	cbind(data,	
	tomorrow.promo=c( data$Promo[2:(nrow(data)) ],0 )
	)

	first = sapply( c(1:nrow(data)), function(x) first.fun(data,x) ) 
	data = cbind(data,first)

	#data[1:50,.(
	#Open,Promo,yesterday.open,tomorrow.open,yesterday.promo,first
	#)]
	
	return(list(data))
}

first.fun=function(data2,i){
	
	first=0
	if(data2$Promo[i]==1){
		if(i==1){
			first=0
		}else if(data2$Promo[i-1]==0){
			first=1
		}
	}
	return(first)
}

work.finish.pred.fun=function(model.glmnet,model.xgb,pred.data,bo){
  
  #分割data , open=0 直接預測為0 
  pred.data1 = data.table( filter(pred.data,Open==1) )
  pred.data0 = data.table( filter(pred.data,Open==0) )
  pred.data0$Sales=0
  
  x=as.matrix( pred.data1[,26:ncol(pred.data1),with=F])
  if(bo==1){
    pred <-predict(	
      model.glmnet, s=0 , 
      x,type="response")
  }else if(bo==2){
    pred<-predict(model.xgb,xgb.DMatrix(data.matrix(
      pred.data1[,c(26:ncol(pred.data1)),with=FALSE]),
      missing=NA))
  }
  
  pred.log = exp( pred )-5
  pred.log = as.integer(round(pred.log))
  
  result1 = data.table( Id=pred.data1$Id,
                        Sales=pred.log)
  result3 = 
    rbind( result1,pred.data0[,.(Id,Sales)] ) %>%
    arrange(Id)
  
  return((result3))
}

work.glmnet.model.fun=function(test){
  
  set.seed(100)
  temp = work.train.data.fun( test )
  train = data.table( temp[[1]] )
  
  train2 = train[,28:ncol(train),with=F]
  
  #補na
  set.seed(100)
  fix.train2 = data.table( complete( 
    mice( train2, m = 5,
          defaultMethod = c("pmm","logreg"), maxit = 2 ) 
  ) )
  
  sum( is.na(fix.train2) )
  colnames(fix.train2)
  x=fix.train2[,2:ncol(fix.train2),with=F]
  y=train$log.sale
  y2=train$Sales
  ncol(x)
  
  model = 	glmnet(as.matrix(x) , y 
                  ,family = c("poisson")
                  ,alpha = 0.005
                  ,nlambda = 5
                  ,standardize = FALSE
                  ,maxit=100000
  )
  
  pred1<-predict(model, s=0, as.matrix(x), type="response")
  pred1.log = exp( pred1 )-5
  
  value1 = RMSPE(y2,pred1.log)
  value1
  return( list( model,value1) )
}








