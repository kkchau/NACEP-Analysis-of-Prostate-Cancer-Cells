##rm(list=ls(all=TRUE))
library(splines)

NACEP = function(filename, spcNum, Timelength, Knot, loop=500, compStart, compIntvl, alpha=50){
##filename="Data.txt"
##spcNum=3
##Timelength=3
##Knot=2
##loop=500
##compStart=500
##compIntvl=200
##alpha=50
spcInfo<-NULL
for(i in 1:spcNum) {
	spcInfo<-cbind(spcInfo,matrix(c(Timelength,0,0,0,Knot),5,1))
}

compGroups <- as.integer(rep(Timelength,spcNum))

compStart=compStart+100

if(Timelength <= 4) {
	ord=Timelength-1
} else {
	ord=4 ## Cubic Spline ##
}
iStart<-1
for(i in 1:spcNum) {
	spcInfo[2,i]<-iStart
	iStart<-iStart + spcInfo[1,i]
	spcInfo[3,i]<-iStart-1
}

## Bind Conditions
DesignMatrix<-matrix(0,0,0)
for(curSpc in 1:spcNum) {
	knots<-seq(1,spcInfo[1,curSpc],length=spcInfo[5,curSpc])
	timepoints=1:spcInfo[1,curSpc]
	knots<-c(rep(min(timepoints),ord-1),knots,rep(max(timepoints),ord-1))
	## DesignMatrix ##
	DesignMatrixElement<-splineDesign(knots,timepoints,ord)
	zom<-matrix(0,dim(DesignMatrix)[1],dim(DesignMatrixElement)[2])
	zom1<-matrix(0,dim(DesignMatrixElement)[1],dim(DesignMatrix)[2])
	DesignMatrix<-rbind(cbind(DesignMatrix,zom),cbind(zom1,DesignMatrixElement))
}


# Note that timepoints must be changed for different dataset #
DT<-t(DesignMatrix)
DTD<-t(DesignMatrix)%*%(DesignMatrix)
RDTD<-solve(DTD)




#########################################################
# 100 simulation begins! #
#########################################################


# Read Data

Data<-read.table(filename, sep="\t", header=TRUE, row.names=1)
Data<-as.matrix(Data)


## Unified normalization
for(i in 1:spcNum) {
	Data[,spcInfo[2,i]:spcInfo[3,i]]<-Data[,spcInfo[2,i]:spcInfo[3,i]]+spcInfo[4,i]
}

outputPath<-paste("Result_",Sys.Date(),sep="")

dir.create(outputPath)


# Compute initial values for our C code #
Datanum<-dim(Data)[1]
nnn<-dim(Data)[2]
q<-dim(DesignMatrix)[2]

OldTheta1=t(solve(t(DesignMatrix)%*%(DesignMatrix))%*%t(DesignMatrix)%*%t(Data))
OldTheta2<-array()
for(i in 1:Datanum){
   OldTheta2[i]<-t(Data[i,])%*%(diag(nnn)-DesignMatrix%*%solve(t(DesignMatrix)%*%(DesignMatrix))%*%t(DesignMatrix))%*%t(t(Data[i,]))/nnn
   }
OldTheta2<-t(t(OldTheta2))
OldTheta=cbind(OldTheta1,OldTheta2)
##Betao=colMeans(OldTheta1)
Betao=rep(0,dim(DesignMatrix)[2])
b<-rep(0,Datanum)
e=0.5/Datanum
f=1/Datanum
SigmaSquare<-sum((t(Data)-DesignMatrix%*%t(OldTheta1))^2)/(Datanum*nnn)
c_OldTheta<-as.vector(t(OldTheta))
c_DesignMatrix<-as.vector(t(DesignMatrix))
c_DT<-as.vector(t(DT))
c_DTD<-as.vector(t(DTD))
c_RDTD<-as.vector(t(RDTD))
c_Data<-as.vector(t(Data))
dyn.load("gibbssampling.so")
simulation<-NULL
simulation<-.C("GibbsSampling",NewTheta=as.double(rep(0,Datanum)),as.integer(spcNum),as.double(alpha),as.double(e),as.double(f),
               as.double(Betao),Theta=as.double(c_OldTheta),as.double(b),as.double(SigmaSquare),
               as.double(c_DesignMatrix),as.integer(dim(DesignMatrix)[2]),as.double(c_DT),
               as.double(c_DTD),as.double(c_RDTD),as.double(c_Data),as.integer(Datanum),
               as.integer(dim(Data)[2]),z=as.integer(1:Datanum),as.integer(loop),as.integer(500),as.integer(0),
               as.integer(10),my_Clustnum=as.integer(rep(1,loop)),my_NewTheta=as.double(rep(1,loop)),as.integer(0),
               as.integer(spcNum), compGroups, as.integer(compStart), as.integer(compIntvl), 
               hDist=as.double(rep(0,Datanum*(as.integer((loop-compStart)/compIntvl+1)))),as.character(outputPath))


dyn.unload("gibbssampling.so")

hDist_m<-matrix(simulation$hDist,Datanum,as.integer((loop-compStart)/compIntvl+1))

row.names(hDist_m)<-row.names(Data)

write.table(hDist_m, file="Distances.txt")

hDist_m_avg<-rowMeans(hDist_m)
write.table(hDist_m_avg, file="Distances_avg.txt")


}

