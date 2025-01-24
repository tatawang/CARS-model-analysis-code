
##This R code is develop by Dr. Chi-Tsan Wang at George Mason University in 2021
##This R code is for analyzing the CARS model (https://github.com/bokhaeng/CARS) input and output data
#
#  
##The figures for CARS model
##Data input and preparation
library(latex2exp)
library(sf)
library(dplyr)
library(scales)

setwd('/XXXXX/CARS/CARS_test_Country_KNU/')
read.csv('/XXXXXX/activity_data/cars_input_v3.2.2.csv')->ACTD

summary(ACTD)
##vehicle count array setup the right numbers for the array, should be the same the count of X and Y
NM<-matrix(, nrow=8, ncol=8)
X <- c('Gasoline','Diesel','LPG','CNG','h-gasoline','h-diesel','h-lpg','h-cng')
Y <- c('sedan','truck','bus','SUV','van','taxi','special','Motocycle')
colnames(NM) <- X
rownames(NM) <- c('sedan','truck','bus','SUV','van','taxi','special','Motorcycle')
for ( f in 1:8){
	for (v in 1:8){
		 NM[v,f]<-length(which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ))
		 #print(f)
		 #print(v)
	}
}
NM[8,1]<-2150000.  #correct Monocycle counts, because the numbers in cars_input is incorrect.
#
#total VKT 
VKTT<-matrix(0, nrow=8, ncol=8)
X <- c('Gasoline','Diesel','LPG','CNG','h-gasoline','h-diesel','h-lpg','h-cng')
Y <- c('sedan','truck','bus','SUV','van','taxi','special','Motocycle')
colnames(VKTT) <- X
rownames(VKTT) <- c('sedan','truck','bus','SUV','van','taxi','special','Motorcycle')
for ( f in 1:8){
	for (v in 1:8){
#		 NM[v,f]<-length(which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ))
		 VKTT[v,f]<-sum(ACTD[which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ), "daily_vkt"])
		 #print(f)
		 #print(v)
	}
}

VKTT[,c(5:8)]->hbv
VKTT<-cbind(VKTT,HyBbrid=rowSums(hbv))


##################################################################
######################    Figure 2 a, b.    #############################
##################################################################
par(mfrow=c(1,2))
NM[,c(5:8)]->hb
NM<-cbind(NM,HyBbrid=rowSums(hb))
barplot(t(NM[,c(1:4,9)]/1000000), col=c("red", "orange", "blue", "cyan" ,"green"), ylab="numbers of vehicle (millions)", xlab="vehicle type", ylim=c(0,14))
legend('topright', legend=c('Hybrid','CNG','LPG','Diesel','Gasoline'),fill=c("green", "cyan", "blue", "orange" ,"red"))
VKTT[,c(5:8)]->hbv
VKTT<-cbind(VKTT,HyBbrid=rowSums(hbv))
barplot(t(VKTT[,c(1:4,9)]/1000000), col=c("red", "orange", "blue", "cyan" ,"green"), ylab="total daily vkt (million km)", xlab="vehicle type")
legend('topright', legend=c('Hybrid','CNG','LPG','Diesel','Gasoline'),fill=c("green", "cyan", "blue", "orange" ,"red"))
#####################################################################################################################
#######################################    Appendix A  ######################  take very long time to process millions of data
#####################################################################################################################
pol<- array(0, dim=c(8,8,13))
vol<- array(0, dim=c(8,8,13))
X <- c('Gasoline','Diesel','LPG','CNG','h-gasoline','h-diesel','h-lpg','h-cng')
Y <- c('sedan','truck','bus','SUV','van','taxi','special','Motocycle')
Z <- c('supercompact','compact','Compact','midsize','Midsize','fullsize','Fullsize','urban','rural','tow','wrecking', 'others', 'special')
for ( f in 1:8){
	for (v in 1:8){
		for (e in 1:13){
		 	pol[v,f,e]<-length(which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] & ACTD$type==Z[e] ))
#		 	VKTT[v,f]<-sum(ACTD[which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ), "daily_vkt"])
		 	#print(f)
		 	#print(v)
		} 
	}
}
for ( f in 1:8){
	for (v in 1:8){
		for (e in 1:13){
#		 	vol[v,f,e]<-length(which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] & ACTD$type==Z[e] ))
		 	vol[v,f,e]<-sum(ACTD[which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] & ACTD$type==Z[e]), "daily_vkt"])
		 	#print(f)
		 	#print(v)
		} 
	}
}

#####################################################################################################################
#######################################   Appendix C   ##############################################################  
#####################################################################################################################
#VKT per car
VKTM<-matrix(0, nrow=8, ncol=8)
colnames(VKTM) <- X
rownames(VKTM) <- Y
X <- c('Gasoline','Diesel','LPG','CNG','h-gasoline','h-diesel','h-lpg','h-cng')
Y <- c('sedan','truck','bus','SUV','van','taxi','special','Motocycle')
for ( f in 1:8){
	for (v in 1:8){
#		 NM[v,f]<-length(which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ))
		 VKTM[v,f]<-sum(ACTD[which(ACTD$fuel==X[f] & ACTD$vehicle==Y[v] ), "daily_vkt"])/NM[v,f] 
		 #print(f)
		 #print(v)
	}
}
write.csv(VKTM,"vktm_v3.1.csv")

##################################################################
######################    Figure 3    #############################
##################################################################
###########################################################################hot emission Speed bins Figure
read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/EmisFact_by_YR_SPD.csv')->EFtable

read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/EmisFact_by_YR_SPD_0_10temp.csv')->EFtable010

read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/EmisFact_by_YR_SPD_0005.csv')->EFtable0005

read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/EmisFact_by_YR_SPD_25.csv')->EFtable25

W <- c('CO','NH3','NOX','SOX','VOC')
W2 <- c('PM10','PM2.5')
year2=2010 # only PM10 and PM2.5
year=2006 # other spec
#vc='suv_compact_gasoline'
vc<-'van_midsize_diesel'
SPA<-matrix(0, nrow=16, ncol=1)
for ( p in 1:5){
	SPA<- cbind(SPA,EFtable[which(EFtable$pollutant==W[p] & EFtable$fullname==vc & EFtable$years==year),2])
}

for ( p in 1:2){
	SPA<- cbind(SPA,EFtable[which(EFtable$pollutant==W2[p] & EFtable$fullname==vc & EFtable$years==year2),2])
}

par(mfrow=c(1,2))
spb<-c(4,12,20,28,36,44,52,60,68,76,84,93,101,109,116,121)
#p='NH3'
year=2010  #NOx=2010
p='NOX'
vc<-'truck_compact_diesel'

EFY<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==year),2]
plot(spb,EFY,type="o", ylim=c(0,8), pch=17, xlab=TeX('Speed (km $h^{-1}$)'),ylab=TeX('NOx Emission Factor (g $km^{-1}$)'), cex=1.5, col='green')

#vc<-'van_midsize_diesel'
#vc<-'van_compact_diesel'
#EFY2<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==year),2]
#lines(spb,EFY2,type="o", col="orange3", pch=19, cex=1.5)

#vc<-'van_compact_diesel'
#EFY3<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==year),2]
#lines(spb,EFY3,type="o", col=2, pch=17, cex=1.5)

vc<-'suv_compact_diesel'
EFY4<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==year),2]
lines(spb,EFY4,type="o", col="orange2", pch=15, cex=1.5)

vc<-'sedan_compact_diesel'
EFY6<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==year),2]
lines(spb,EFY6,type="o", col="orange", pch=18, cex=2)

legend('topright', legend=c('diesel compact truck','diesel compact SUV','diesel compact sedan'),col=c('green','orange2', 'orange'),pch=c(17,15,18))

p='NOX'
vc<-'truck_compact_diesel'
EFY<-EFtable[which(EFtable$pollutant==p & EFtable$fullname==vc & EFtable$years==2010 &EFtable$temperatures == "GT10_LE20"),2]
plot(spb,EFY,type="o", ylim=c(0,8), pch=17, col='green' ,xlab='Speed (km/h)',ylab='NOx Emission Factor (g/km)', cex=1.5)

vc<-'truck_compact_diesel'
EFY010<-EFtable010[which(EFtable010$pollutant==p & EFtable010$fullname==vc  & EFtable010$years==2010 &EFtable010$temperatures == "GT0_LE10"),2]
lines(spb,EFY010,type="o", ylim=c(0,4), pch=17, col='dodgerblue' ,xlab='Speed (km/h)',ylab='NOx Emission Factor (g/km)', cex=1.5)

EFY0005<-EFtable0005[which(EFtable0005$pollutant==p & EFtable0005$fullname==vc  & EFtable0005$years==2010 &EFtable0005$temperatures == "LE0"),2]
lines(spb,EFY0005,type="o", ylim=c(0,4), pch=17, col='deepskyblue' ,xlab='Speed (km/h)',ylab='NOx Emission Factor (g/km)', cex=1.5)

EFY25<-EFtable25[which(EFtable25$pollutant==p & EFtable25$fullname==vc  & EFtable25$years==2010 &EFtable25$temperatures == "GT20"),2]
lines(spb,EFY25,type="o", ylim=c(0,4), pch=17, col='green4' ,xlab=TeX('Speed (km $h^{-1}$)'),ylab=TeX('NOx Emission Factor (g $km^{-1}$)'), cex=1.5)

legend('topright', legend=c(' less than 0 °C',' between 0-10°C',' between 10-20°C','greater than 20°C'),col=c('deepskyblue','dodgerblue','green','green4'),pch=17)

###########################################################################


#####################################################################################################################
##########################  Analysis the ASD in the shape file   #############################
#####################################################################################################################
SHF<-st_read("/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/input_country/shapes/Road_by_County_SK_AADT_UTM52N.shp")

#read.csv('RSFPD.csv', head=TRUE)->SHF
SHF[,1:11]->SHF	# remove the geo data
SHF$SB=NA
SHF$SB[which(SHF$spd<4)]=4
SHF$SB[which(SHF$spd>=4 &SHF$spd<12)]=8
SHF$SB[which(SHF$spd>=12 &SHF$spd<20)]=16
SHF$SB[which(SHF$spd>=20 &SHF$spd<28)]=24
SHF$SB[which(SHF$spd>=28 &SHF$spd<36)]=32
SHF$SB[which(SHF$spd>=36 &SHF$spd<44)]=40
SHF$SB[which(SHF$spd>=44 &SHF$spd<52)]=48
SHF$SB[which(SHF$spd>=52 &SHF$spd<60)]=56
SHF$SB[which(SHF$spd>=60 &SHF$spd<68)]=64
SHF$SB[which(SHF$spd>=68 &SHF$spd<76)]=72
SHF$SB[which(SHF$spd>=76 &SHF$spd<84)]=80
SHF$SB[which(SHF$spd>=84 &SHF$spd<93)]=89
SHF$SB[which(SHF$spd>=93 &SHF$spd<101)]=97
SHF$SB[which(SHF$spd>=101 &SHF$spd<109)]=105
SHF$SB[which(SHF$spd>=109 &SHF$spd<116)]=113
SHF$SB[which(SHF$spd>116)]=121

RT<-c('101','102','103','104','105','106','107','108')
AS<-c(4,8,16,24,32,40,48,56,64,72,80,89,97,105,113,121)

tapply(SHF$VKT, list(SHF$SB,SHF$ROAD_RANK), sum)->ASD_VKT
ASD_VKT<-rbind(c(0,0,0,0,0,0,0,0),ASD_VKT, c(0,0,0,0,0,0,0,0)) # made 4km and 121km speed
ASD_VKT[is.na(ASD_VKT)]<-0
ASD_PST = matrix(0, nrow=16, ncol=8)
for (i in 1:8){
	ASD_PST[,i] = ASD_VKT[,i]/sum(ASD_VKT[,i], na.rm=TRUE)
}


FS[which(FS<4)]=4
FS[which(FS>=4 &FS<12)]=8
FS[which(FS>=12 &FS<20)]=16
FS[which(FS>=20 &FS<28)]=24
FS[which(FS>=28 &FS<36)]=32
FS[which(FS>=36 &FS<44)]=40
FS[which(FS>=44 &FS<52)]=48
FS[which(FS>=52 &FS<60)]=56
FS[which(FS>=60 &FS<68)]=64
FS[which(FS>=68 &FS<76)]=72
FS[which(FS>=76 &FS<84)]=80
FS[which(FS>=84 &FS<93)]=89
FS[which(FS>=93 &FS<101)]=97
FS[which(FS>=101 &FS<109)]=105
FS[which(FS>=109 &FS<116)]=113
FS[which(FS>116)]=121



#par(mfrow=c(1,2))

#read.csv("/Users/chi-tsanwang/University of North Carolina at Chapel Hill/CARS - Publication/Input Data/Korea_Speed_distribution.csv")->ASD

#colorbar = c("red","orange","chartreuse1","chartreuse4","blue","cyan2","purple","gray50")

#plot(ASD[,1],ASD[,2]*100,type="o", pch=1 ,col=colorbar[1], ylab="Distribution (%)", xlab="Average Speed Bins (km/hour)", ylim=c(0,100), xlim=c(0,125), lwd=2, cex.lab=1.2, cex.axis=1.2)
#for (i in 3:9) {
#	lines(ASD[,1],ASD[,i]*100,type="o",pch=i-1 ,col=colorbar[i-1], ylab="Fraction", xlab="Average speed (km/hour)", lwd=2, cex.lab=1.2, cex.axis=1.2)
#}
#legend("topright", c("Interstate Expressway","Urban Expressway","Highway","Urban Highway","Rural Highway","Rural local road","Urban local road","Other road"), pch=c(1:8), col=colorbar, lwd=2)



plot(AS,ASD_PST[,1]*100,type="o", pch=1 ,col=colorbar[1], ylab="Distribution (%)", xlab="Average Speed Bins (km/hour)", ylim=c(0,60), xlim=c(0,125), lwd=2, cex.lab=1.2, cex.axis=1.2)
for (i in 2:8) {
	lines(AS,ASD_PST[,i]*100,type="o",pch=i ,col=colorbar[i], ylab="Fraction", xlab="Average speed (km/hour)", lwd=2, cex.lab=1.2, cex.axis=1.2)
}
legend("topright", c("Interstate Expressway","Urban Expressway","Highway","Urban Highway","Rural Highway","Rural local road","Urban local road","Other road"), pch=c(1:8), col=colorbar, lwd=2)


write.csv(ASD_PST, "ASD_VKT.csv")

##################################################################
######################    Figure 4    #############################
##################################################################
########################################################################### ASD figure

setwd("/Users/chi-tsanwang/University of North Carolina at Chapel Hill/CARS - Publication/Input Data/")
read.csv("/Users/chi-tsanwang/University of North Carolina at Chapel Hill/CARS - Publication/Input Data/Korea_Speed_distribution.csv")->ASD

read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/input_country/emissions_factor/avgSpeedDistribution_rev_05_CTWv2.csv')->ASD

colorbar = c("red","orange","chartreuse1","chartreuse4","blue","cyan2","purple","gray50")

plot(ASD[,1],ASD[,2]*100,type="o", pch=1 ,col=colorbar[1], ylab="Distribution (%)", xlab="Average Speed Bins (km/hour)", ylim=c(0,45), xlim=c(0,125), lwd=2, cex.lab=1.2, cex.axis=1.2)
for (i in 3:9) {
	lines(ASD[,1],ASD[,i]*100,type="o",pch=i-1 ,col=colorbar[i-1], ylab="Fraction", xlab="Average speed (km/hour)", lwd=2, cex.lab=1.2, cex.axis=1.2)
}
legend("topright", c("Interstate Expressway","Urban Expressway","Highway","Urban Highway","Rural Highway","Rural local road","Urban local road","Ramp"), pch=c(1:8), col=colorbar, lwd=2)


###########################################################################
##################################################################
######################    Figure 9 a b    #############################
##################################################################
read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/output_CTWv2_SSD/Pollutant_Total_Emis_by_Road_CTWv2_SSD.csv')->RDEM_SSD
colnames(RDEM_SSD)[grepl("truck_special",colnames(RDEM_SSD))]<-c("truck_sp_cng","truck_sp_gasoline","truck_sp_lpg") #change the truck special to truck sp

#read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/output_SK_CTW_RR/Pollutant_Total_Emis_by_Road_SK_CTW_RR.csv')->RDEM_ASD

read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/output_CTWv2/Pollutant_Total_Emis_by_Road_CTWv2.csv')->RDEM_ASD

colnames(RDEM_ASD)[grepl("truck_special",colnames(RDEM_ASD))]<-c("truck_sp_cng","truck_sp_gasoline","truck_sp_lpg") #change the truck special to truck sp

tapply(RDEM_ASD[,100],list(RDEM_ASD$pollutant), sum)->RDEM_ASD_PT
tapply(RDEM_SSD[,100],list(RDEM_SSD$pollutant), sum)->RDEM_SSD_PT

(RDEM_ASD_PT-RDEM_SSD_PT)/RDEM_ASD_PT


rbind(RDEM_ASD_PT, RDEM_SSD_PT)->RDEM_PT
colnames(RDEM_PT)<-c('CO','NH3','NOx','PM10','PM2.5','SOx','VOC')


# # # # # # # # # # # # #
W <- c('CO','NH3','NOX','PM10','PM2.5','SOX','VOC')
X <- c('gasoline','diesel','lpg','cng','h.')  
Y <- c('sedan','truck','bus','van','SUV','taxi','special','Motocycle')
Z <- c(101,102,103,104,105,106,107,108)

tapply(RDEM_ASD[,100],list(RDEM_ASD$pollutant, RDEM_ASD$road_type), sum)->RDEM_ASD_RD
RDEM_ASD_PT_RD<-t(RDEM_ASD_RD)

tapply(RDEM_SSD[,100],list(RDEM_SSD$pollutant, RDEM_SSD$road_type), sum)->RDEM_SSD_RD
RDEM_SSD_PT_RD<-t(RDEM_SSD_RD)

RDEM_SSD_PT_RD-RDEM_ASD_PT_RD -> RDEM_DIFF
RDEM_DIFF_COMP <- matrix(0, nrow=8, ncol=7)
colnames(RDEM_DIFF_COMP) <- c('CO','NH3','NOx','PM10','PM2.5','SOx','VOC')
rownames(RDEM_DIFF_COMP) <- Z
for (i in 1:7){
	for (j in 1:8){
		RDEM_DIFF_COMP[j,i]<-RDEM_DIFF[j,i]/RDEM_ASD_PT[i]*100*-1
	}
}

colorbar = c("red","orange","chartreuse1","chartreuse4","blue","cyan2","purple","gray50")
par(mfrow=c(1,2),mar=c(5,5,3,2))
barplot(RDEM_PT[,c(3,7,5,1,6,2)]/1000, beside=TRUE, ylab=TeX('Annual Emission Rate (1000 ton $yr^{-1}$)'), col=c("blue","red"), border=NA, ylim=c(0,400))
legend("topright",legend=c('Average Speed Distribution','Single Speed'), fill=c('blue','red'), border=NA)
barplot(RDEM_DIFF_COMP[,c(3,7,5,1,6,2)], col=alpha(c("red","orange","chartreuse1","chartreuse4","blue","cyan2","purple","gray50"),0.6),border=NA, beside=TRUE, ylab="Difference (%)", ylim=c(-1,20))
legend("topright", c("Interstate Expressway","Urban Expressway","Highway","Urban Highway","Rural Highway","Rural local road","Urban local road","Ramp"), fill=alpha(colorbar,0.6),border=NA)

###########################################################################
#################  table 3 code ###########################################
###########################################################################
read.csv('/Users/chi-tsanwang/PycharmProjects/IMAC_python3/CARS_test_Country_KNU/output_CTWv2/Pollutant_Total_Emissions_Tons_per_Year_CTWv2.csv')->PTEM_CTW2

colnames(PTEM_CTW2)[grepl("truck_special",colnames(PTEM_CTW2))]<-c("truck_sp_cng","truck_sp_gasoline","truck_sp_lpg") #change the truck special to truck sp
PTEM<-PTEM_CTW2
pollutant="NOX"  #VOC NOX PM2.5 NH3 CO
X <- c('_gasoline','_diesel','_lpg','_cng','_h.')
Y <- c('sedan_','truck_','bus_','suv_','van_','taxi_','special_','motocycle_')

EVF<-matrix(0, nrow=8, ncol=5)

colnames(EVF)<-X
rownames(EVF)<-Y
for ( f in 1:5){
	for (v in 1:8){
		PTEM[, grepl(X[f], names(PTEM))]->PTEM_FUEL
		if (any(grepl(Y[v], names(PTEM_FUEL)))) {
			EVF[v,f]=sum(PTEM_FUEL[which(PTEM$pollutant==pollutant), grepl(Y[v], names(PTEM_FUEL))])
		}
	}
}

write.csv(EVF,"evf_NOX.csv")
