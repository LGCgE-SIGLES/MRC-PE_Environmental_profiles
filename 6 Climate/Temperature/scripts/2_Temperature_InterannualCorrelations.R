#Gestion des packages avec renv
# renv::init()
# renv::snapshot()
renv::restore() #Permet de restaurer la bonne version de tous les packages utilisés dans le projet RStudio

library(writexl)
library(dplyr)


DEPAS <- read.csv("3 Outputs/2 Après gestion Lyon/Depassement/Temperatures_depassements_annuels_communes.csv",header=TRUE,sep=";",dec=",")

#Permet de verifier que les valeurs prises par les indicateurs sont coherentes. 
#Permet par ailleurs de verifier qu'il n'y a pas de donnee manquante
summary(DEPAS[,c(4:ncol(DEPAS))])

#Pearson
DEPAS_Pearson <- as.data.frame(cor(DEPAS[,c(4:ncol(DEPAS))],method="pearson"))
DEPAS_Pearson$Indicateurs <-row.names(DEPAS_Pearson)
DEPAS_Pearson <- DEPAS_Pearson[,c('Indicateurs',colnames(DEPAS_Pearson)[-ncol(DEPAS_Pearson)])]
write_xlsx(DEPAS_Pearson,"3 Outputs/2 Après gestion Lyon/Depassement/Corrélations interannuelles/DEPAS_Pearson.xlsx")

#Spearman
DEPAS_Spearman <- as.data.frame(cor(DEPAS[,c(4:ncol(DEPAS))],method="spearman"))
DEPAS_Spearman$Indicateurs <-row.names(DEPAS_Spearman)
DEPAS_Spearman <- DEPAS_Spearman[,c('Indicateurs',colnames(DEPAS_Spearman)[-ncol(DEPAS_Spearman)])]
write_xlsx(DEPAS_Spearman,"3 Outputs/2 Après gestion Lyon/Depassement/Corrélations interannuelles/DEPAS_Spearman.xlsx")




QUANTI <- read.csv("3 Outputs/2 Après gestion Lyon/Quanti/Temperatures_moyennes_annuelles_communes.csv",header=TRUE,sep=";",dec=",")
summary(QUANTI[,c(4:ncol(QUANTI))])

#Pearson
QUANTI_Pearson <- as.data.frame(cor(QUANTI[,c(4:ncol(QUANTI))],method="pearson"))
QUANTI_Pearson$Indicateurs <-row.names(QUANTI_Pearson)
QUANTI_Pearson <- QUANTI_Pearson[,c('Indicateurs',colnames(QUANTI_Pearson)[-ncol(QUANTI_Pearson)])]
write_xlsx(QUANTI_Pearson,"3 Outputs/2 Après gestion Lyon/Quanti/Corrélations interannuelles/QUANTI_Pearson.xlsx")

#Spearman
QUANTI_Spearman <- as.data.frame(cor(QUANTI[,c(4:ncol(QUANTI))],method="spearman"))
QUANTI_Spearman$Indicateurs <-row.names(QUANTI_Spearman)
QUANTI_Spearman <- QUANTI_Spearman[,c('Indicateurs',colnames(QUANTI_Spearman)[-ncol(QUANTI_Spearman)])]
write_xlsx(QUANTI_Spearman,"3 Outputs/2 Après gestion Lyon/Quanti/Corrélations interannuelles/QUANTI_Spearman.xlsx")


