#********************************************************************************
#     Sujet: Nbre de d�faillances d'entreprises en Normandie 
#             Secteur H�bergement-Restauration
#********************************************************************************

#I�) Importations, Manipulations, Nettoyages et Validations des donn�es
file="//calebasse/21713532/Documents/M2_SAAD/Mod_Temporelles/Projet/data_projet/valeurs_trimestrielles.csv"
BD <- read.csv2(file,header = TRUE, sep = ";",stringsAsFactors = FALSE)
colnames(BD)
class(BD)

# #Manipulation des donn�es : Suppression les lignes 2 et 3 et renommer les BD
# colnames(BD)<-c("date","NbreObs","code")  #Renommer les champs des donn�es
# BD
# BD<-BD[-1:-2,,]   #Suppression de lignes 1 et 2

#V�rification de l'importation des donn�es
summary(BD)
head(BD,5)  #debut de s�rie
tail(BD,5)  #fin de s�rie

#Structure et format des donn�es
str(BD) #122 observations pour 3 variables (var: date,NbreObs,code)

#Recherche de Valeurs manquantes (NA)
library(dplyr)
apply(BD, MARGIN = 2, FUN = function(x){x%>%is.na%>%sum})
attach(BD)      #Aucune valeur manquante 
sum(is.na(BD))  #Recherche de valeurs manquantes: Aucune valeurs trouvee

#Transformation des donn�es en s�ries temporelles et Affichage du graphe
X <- ts(data = NbreObs, start = c(1990, 1), frequency = 4)
X
plot(X, ylab="Nombre de d�faillances d'entreprises",col="brown")
#Observons bien une s�rie de type multiplicative

#*******************************************************************************
#II) Analyse et Exploitation des donn�es
#II-1) D�termination de la S�rie Corrig� des variations saisionni�res
t=1:122
X<-data.frame(cbind(t,X))
modele<-lm(X~t, data=X)
summary(modele)
#R2=0.2955 tr�s faible. Donc la s�rie est saisonni�re

#Calcul des coefs et Ajustement par la droite
v<-modele$coefficients
plot(X$X, type="l", main="Ajustement de la s�rie par la droite de r�gression", 
     ylab="d�faillances")
lines(modele$fitted.values, col="red")

#Calcul des valeurs estim�es
Z=modele$fitted.values
Z=ts(Z,start=c(1990,1),frequency=4)
X<-data.frame(X)
X<-select(X,X)
X=ts(X,start=c(1990,1),frequency=4)

#Calcul des coefficients saisonniers
#comme notre mod�le est multiplicatif, alors on divsise les valeurs brutes par
#les valeurs estim�es.
S=X/Z
cycle(S) #indicatrices des colonnes
s=tapply(S,cycle(S),mean,na.rm=TRUE) #Estimation des moyennes de chaque periodes
#la fonction tapply est appliqu�e fonction a chaque groupe

#Calcul de la CVS et de la repr�sentation de la CVS
CVS=matrix(1,29,4)
CVS=rbind(CVS,matrix(c(1,1,0,0),1,4)) #Ajout d'une ligne � la matrice
dim(CVS)    #on obtient bien dimension attendue

for (i in 1:30) {for (j in 1 :4) {CVS[i,j]=t(matrix(X,4,30))[i,j]/s[j]}}
CVS=as.vector(t(CVS))
CVS=as.ts(CVS)
CVS=ts(CVS,start=c(1990,1), frequency=4)

#Superposition de la CVS et de la s�rie brute
ts.plot(X,CVS, col = c("black", "red"), lwd = c(1, 2),main=" R�presentation de s�rie brute et de la CVS")
legend(1990, 120, legend=c("S�rie brute", "CVS"), col=c("black", "red"), lty=1:2, cex=0.8)

#III�) D�composition de la s�rie temporelle
X_decom <- decompose(X, "multiplicative")
plot(X_decom)

# #Saisonnalit� :Lissage avec les moyennes mobiles
# MA<-stats::filter(X_decom$seasonal,filter=array(1/10,dim=10), method = c("convolution"),sides=2,circular = FALSE)
# plot(X_decom$seasonal,type='l',main="Repr�sentaion de la saisonnalit�")
# lines(MA,col='brown')

#III�-1) Autocorr�lation de la s�rie
par(mfrow = c(1,1))
res_acf<-acf(X,lag=40)
# res_pacf<-pacf(X)
#On trouve bien que le coef de corr�lation vaut 1 au d�calage 0 de d�part
#Et La d�croissance progressive des batons est typique d'une s�rie chronologique 
#contenant une tendance.
#Le pic au trimestre 1 indique bien une variation saisonni�re.

#Affichages des valeurs du graphe de corr�lation
print(data.frame(res_acf$lag,res_acf$acf)[1:10,])
#Afficher la sortie de ces r�sultats pour une bonne interpr�tation 

#III�-2) Analyse des R�sidus 
plot(ts(X_decom$random[3:120]))
#la s�rie des d�faillance est corrig�e des variations saisonni�res 
#et la tendance est supprim�e. 

#Trac� du corr�llogramme
par(mfrow=c(1,2))
acf(X_decom$random[3:120], main="acf des r�sidus")
pacf(X_decom$random[3:120], main="pacf des r�sidus")
#Le coef de corr�lation vaut 1 au d�calage 0.
#Et on ne distingue aucune structure partuli�re.

#Test de Normalit� des R�sidus
shapiro.test(X_decom$random[3:120])
#p-value = 0.1912 > 0.05.
#Donc les r�sidus sont distribu�es suivant une loi normale de param�tres N(0,1)

#D�tection des corr�lation sur les 4 derniers trimestres
lag.plot(X,lag=12,layout=c(3,4))
#Le nombre de d�faillances d'entreprise est fortement corr�l� au 4�me trimestre
#Ainsi donc, au lag4 les points sont align�s.
#Donc les nombres de d�faillances pour un trimestre est fortement corr�l� au m�me 
#trimestre de l'ann�e pr�c�dente.

#**************************************************************************
#III�-3) Calcul des ratios et des valeurs extr�mes
#Evolution annuel des moyennes trimestrielles des d�faillances (par ann�es)
layout(1:2)
X.annuel <- aggregate(X)/4     
plot(X.annuel,ylab="Nbre de d�faillances" ,col="brown")      #Moyenne trimestrielles par ann�e
boxplot(X~cycle(X),ylab="Nbre de d�faillances",names=c("T1","T2","T3","T4")) #Boite � moustache de la d�faillance par trim

layout(1:1)
#Valeurs extr�mes des d�faillances
max(aggregate(X))  
min(aggregate(X))  

# Calcul des Ratio trimestriels
X.trim1 <- window(X, start=c(1990, 1), freq=TRUE)
X.trim2 <- window(X, start=c(1990, 2), freq=TRUE)
X.trim3 <- window(X, start=c(1990, 3), freq=TRUE)
X.trim4 <- window(X, start=c(1990, 4), freq=TRUE)

ratio.trim1 <- mean(X.trim1)/mean(X)
ratio.trim2 <- mean(X.trim2)/mean(X)
ratio.trim3 <- mean(X.trim3)/mean(X)
ratio.trim4 <- mean(X.trim4)/mean(X)
ratio.trim1; ratio.trim2; ratio.trim3; ratio.trim4

taux2 = 1-ratio.trim2
taux3 = 1-ratio.trim3  
taux1 = ratio.trim1 - 1
taux4 = ratio.trim4 - 1

#********* Pr�vision par lissage exponentielle ***********
#D�composition par lissage de la s�rie corrig�e
ts_ajust = stl(CVS,s.window=4,s.degree=0)
plot(ts_ajust,main = "Ajustement de la tendance de la CVS")
tendance=ts_ajust$time.series[,"trend"]
saisonalite=ts_ajust$time.series[,"seasonal"]
residus=ts_ajust$time.series[,"remainder"]

#estimation de la tendance 
lm.tendance=lm(tendance~time(tendance))
plot(tendance)
abline(lm.tendance$coefficients[1],lm.tendance$coefficients[2],col="red")

#Pr�vision par la M�thode de Holt-Winters: estimation de la tendance
library(forecast)
hw=ets(tendance,model="MMM")
hw.pred=predict(hw,10)  #10 prochains trimestres
hw.pred
plot(hw.pred, xlab="Time",ylab = "Nbr. de d�faillances")

#***************** Pr�vison de la s�rie X ******************
library(forecast)
hwt.pred=hw(X,seasonal="multiplicative")  #prochains trimestres
hwt.pred
plot(hwt.pred, xlab="Time",ylab = "Nbr. de d�faillances")
#Au 3�me trimestre de l'ann�e 2020, il �tait pr�vu un total de 51.67408~52 
#d�faillances d'entreprises dans l'Hebergement et la Restauration.
