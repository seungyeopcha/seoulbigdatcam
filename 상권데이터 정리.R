setwd("C:/data")
df1<-read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2018년.csv")
df2<-read.csv("서울시_우리마을가게_상권분석서비스(상권-점포)_2019년.csv")

df<-rbind(df1,df2)

write.csv(df,"df.csv")

install.packages("tidyvers")
install.packages("tydyr")

library(tidyverse)
df1<-read.csv("df1.csv")
df3<-spread(data=df1,key="서비스_업종_코드_명",value="점포_수",fill=0)


write.csv(df3,"df3.csv")

##데이터 통합
#데이터 불러오기
df.apt<-read.csv("n상권_아파트.csv")
df.pop<-read.csv("n상권_생활인구.csv")
df.store<-read.csv("n상권_점포.csv")
df.fac<-read.csv("n상권_집객시설.csv")



dim(df.apt)
dim(df.fac)
dim(df.pop)
dim(df.store)


#열정리
colnames(df.apt)[c(1,2,5,6)]<-c('년','분기','상권코드','상권코드명')
colnames(df.fac)[c(1,2,5,6)]<-c('년','분기','상권코드','상권코드명')
colnames(df.pop)[c(1,2,5,6)]<-c('년','분기','상권코드','상권코드명')
colnames(df.store)[c(1,2,5,6)]<-c('년','분기','상권코드','상권코드명')
df.apt<-df.apt[,-c(3,4)]
df.fac<-df.fac[,-c(3,4)]
df.pop<-df.pop[,-c(3,4)]
df.store<-df.store[,-c(3,4)]

#결측치 == 0
for (i in 6:24) {
df.fac[,i]<-ifelse(is.na(df.fac[,i]),0,df.fac[,i])
}

#join
#install.packages('plyr')
library(plyr)
dim(df)
df<-join(df.pop,df.store,by=c('상권코드','년','분기','상권코드명'))
df<-join(df,df.fac,by=c('상권코드','년','분기','상권코드명'))
df<-join(df,df.apt,by=c('상권코드','년','분기','상권코드명'))

write.csv(df,"상권통합.csv",row.names=F)

# 결측치
sum(is.na(df))

for (i in 1:ncol(df)){
  df[,i]<-ifelse(is.na(df[,i]),0,df[,i])
  }

write.csv(df,"상권통합.csv",row.names=F)

##분기->월로 전환
#각행을 세번씩 반복
df.n<-as.data.frame(c(1:ncol(df)))
df.n<-t(df.n)
length(colnames(df.n))
colnames(df.n)<-colnames(df)

for(i in 1:nrow(df)){
  k<-rbind(df[i,],df[i,],df[i,])
  df.n<-rbind(df.n,k)
}
df.n<-df.n[-1,]
dim(df.n)  
dim(df)

#월
x<-factor(df$상권코드명)
x
월<-rep(c(1:12),2020)
length(월)

df.n[,2]<-월
colnames(df.n)[2]<-"월"

write.csv(df.n,"상권통합_월별.csv",row.names=F)
