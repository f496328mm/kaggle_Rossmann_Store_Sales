# kaggle Rossmann Store Sales, NO.315/top 10%
 [Rossmann Store Sales](https://www.kaggle.com/c/rossmann-store-sales)<br>
 e-mail : samlin266118@gmail.com <br>
 如果有問題可以直接寄信給我 <br>
 **********************************************
 結論 : 該篇分析方法與([Grupo Bimbo Inventory Demand](https://github.com/f496328mm/kaggle_Grupo_Bimbo_Inventory_Demand))，
 類似，也得到不錯的成績，因此未來對於類似的問題，這兩篇分析，可以做為一個基礎的方向。
 
 注意 : 
 **********************************************
 # 1. 緒論
 此問題是關於一家位於歐洲七個國家的的連鎖藥妝店，目的是銷售量預測。
 因此選擇該問題的主要因素是，對於上一篇預測的 [Grupo Bimbo Inventory Demand](https://github.com/f496328mm/kaggle_Grupo_Bimbo_Inventory_Demand) ，方法上的驗證。
 由於庫存與銷售量有相關性，因此相同方法是否能有效?
 
 該問題的目的，可以引用題目中的一段話 Reliable sales forecasts enable store managers to create effective staff schedules that increase productivity and motivation ，準確的預測，可以建立良好的排班表，進額提高員工生產力與動力，實際上我並不清楚如何應用，不過這類問題不只發生在單一企業，相信對於該問題有足夠的分析經驗後，未來在該領域上的分析，有個基礎。
 
 # 2. 資料介紹
 Rossmann Store 位於歐洲七個國家，三千家連鎖藥妝店，以下是是該連鎖店一部分的分布圖
 
  ![ross](https://github.com/f496328mm/kaggle_Rossmann_Store_Sales/blob/master/ross.jpg)
 
基本上連鎖店都位於市中心，密集程度高，也代表著競爭對手的多寡。
某些商店鄰近學校，因此特殊節慶，由於學校假日，可能導致銷售量下降。
而歐洲地區也跟台灣不同，通常星期天商店都不會營業，只有少數店家會營業，可能是鄰近精華區。
該藥妝店也會有促銷活動，可預期銷售量將會上升。

資料中包含將近兩年半的銷售資料，目的是預測未來48天的銷售量。

詳細變數意義，可以參考 kaggle 的敘述，我使用的變數大約是以下這些 :

|variable	|意義|
|---------|----|
|Sales|the turnover for any given day(Target)|
|Store|a unique Id for each store|
|Customers|the number of customers on a given day|
|Open|an indicates for whether the store was open: 0=closed, 1=open|
|Date|date|
|DayOfWeek|1-7(Mondau-Sunday)|
|SchoolHoliday|indicates if the (Store,Date) was affected by the closure of public schools|
|Assortment|describes an assortment level: a=basic, b=extra, c=exended|

 
 ### 2.1 資料準備 
 
Kaggle 提供的資料如下：

|data|size|n (資料筆數)|p (變數數量)| 時間長度 |
|----|----|-----------|------------|---------|
|training data|36 MB|1 百萬 筆|14個類別變數，2個數值變數| 2013-01-01 ~ 2015-07-31  |
|testing data|1 MB|4 萬 筆|14個類別變數，2個數值變數|2015-08-01 ~ 2015-09-17 |

另外提供的 data - store ，包含 1 ~ 1115 家店的相關資訊，例如：StoreType 代表商店類別，有 a,b,c,d 四種。CompetitionDistance 代表最近對手商家的距離，其他細節可以參考 Kaggle 提供的資訊 [click](https://www.kaggle.com/c/rossmann-store-sales/data)。

 ### 2.2 資料切割
 由於是時間序列問題，必須預測未來，因此資料切割方式，與前一篇[Grupo Bimbo Inventory Demand](https://github.com/f496328mm/kaggle_Grupo_Bimbo_Inventory_Demand)類似，切割方法如下：<br>
  ![google map](https://github.com/f496328mm/kaggle_Grupo_Bimbo_Inventory_Demand/blob/master/bimbo.jpg)
 
 ，，，，，，，，，，，，，，，，。

# 3. 特徵製造
### 3.1 feature engineering 1 ( 特徵工程 1 )



### 3.2 feature engineering 2 ( 特徵工程 2 )



### 3.3 變數選擇


### 3.4 feature selection

### 3.5 other 


   
# 4. Fitted model





# 50 feature
  

# Reference

 [Bosch Production Line Performance. ( 2016 ) ](https://www.kaggle.com/c/bosch-production-line-performance )<br>

[Daniel FG. ( 2016 )](https://www.kaggle.com/danielfg/xgboost-reg-linear-lb-0-485)







 



