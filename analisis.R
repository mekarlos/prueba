
##SE INSTALAN LIBRERIAS DE SER NECESARIO
##install.packages("RSQLite")
##install.packages("sqldf")
##install.packages("dplyr")
##install.packages("ggplot2")
##install.packages("readxl")
##install.packages("gmodels")
##install.packages("Hmisc")
##install.packages("ggthemes")
##install.packages("forcats")
##install.packages("GGally")
##install.packages("corrplot")
##install.packages("PerformanceAnalytics")
##install.packages("ggpubr")

## Se importan librerias
library(dplyr)
library(ggplot2) 
library(readxl)
library(gmodels)
library(Hmisc)
library(ggthemes)
library(RSQLite)
library(DBI)
library(sqldf)
library(forcats)
library(GGally)
library(corrplot)
library(PerformanceAnalytics)
library(ggpubr)

## Se importa base de datos local, debe modificarse esta ruta en PC local en caso de necesitar ejecutarse localmente!!!

filename <- "D:\\Repositorios\\PruebaTecnica\\datos.db"

## Se importa el driver
sqlite.driver <- dbDriver("SQLite")

## Se conecta con la base de datos
db <- dbConnect(sqlite.driver,dbname = filename)
             
## Se listan bases de datos
dbListTables(db)



	##CONSULTAS SQL REALIZADAS

## 1. CONSULTA BASE PARA ANALISIS POR REGIONES - SOLO IPS
resumenBaseSinFiltros<-sqldf('select region, departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter, ese from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1')
resumenBaseESEs<-sqldf('select region, departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter, ese from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where ese="SI" ')
resumenBaseIndependiente<-sqldf('select region, departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter, ese from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=2')

## 1.1 CONSULTA BASE PARA ANALISIS POR REGIONES - SOLO IPS privadas
resumenIPSsPrivadas<-sqldf('select region, departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter, ese from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1 and naju_codigo=1')

## 1.2 CONSULTA BASE PARA ANALISIS POR REGIONES - SOLO IPS publicas
resumenIPSsPublicas<-sqldf('select region, departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter, ese from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1 and naju_codigo=4')


## 2.1 - CONSULTA DE TODAS LAS IPS (SE OMITEN INDEPENDIENTES, TRANSPORTE Y OTROS PROPOSITOS) CON DETALLE DE DEPARTAMENTO, CIUDAD,NATURALEZA Y CARACTER
resumenIPS<-sqldf('select departamento, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1')

## 2.2 - CONSULTA DE TODAS LOS INDEPENDIENTES(SE OMITEN IPS, TRANSPORTE Y OTROS PROPOSITOS) CON DETALLE DE DEPARTAMENTO, CIUDAD,NATURALEZA Y CARACTER
resumenIndependientes<-sqldf('select departamento,naju_nombre,clpr_nombre,municipio, (select sum(poblacion) from municipios where departamento==MM.departamento) as poblacion, (select sum(superficie) from municipios where departamento==MM.departamento) as superficie, nombre_prestador from municipios MM inner join prestadores     on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=2')

## 2.3 - CONSULTA RESUMEN DE NUMERO DE PRESTADORES POR CADA 10.000 HABITANTES AGRUPADO POR DEPARTAMENTO
resumenxHabs<-sqldf('select departamento, count(distinct(municipio)) as numMunicipios,count(*)*10000.0 /(select sum(poblacion) from municipios where departamento==MM.departamento) as Prestadores,count( case when naju_nombre="Privada" then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresPrivados,count( case when naju_nombre="Pública" then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresPublicos,count( case when naju_nombre="Mixta" then 1 end)*10000.0/(select sum(poblacion) from municipios where departamento==MM.departamento) as PrestadoresMixtos from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1 group by departamento order by Prestadores desc')

## 2.4 - CONSULTA RESUMEN DE NUMERO DE PRESTADORES POR CADA 10.000 HABITANTES AGRUPADO POR DEPARTAMENTO
resumenxSuperficie<-sqldf('select departamento, count(distinct(municipio)) as numMunicipios,count(*) as prestadpres,(select sum(superficie) from municipios where departamento==MM.departamento) as superficie,count(*)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as TotalPrestadoresx1000,count( case when naju_nombre="Privada" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresPrivadax1000, count( case when naju_nombre="Pública" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresPublicasx1000, count( case when naju_nombre="Mixta" then 1 end)*1000/(select sum(superficie) from municipios where departamento==MM.departamento) as PrestadoresMixtox1000 from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where clpr_codigo=1 group by departamento order by TotalPrestadoresx1000')

## 2.5 - CONSULTA RESUMEN ENTIDADES CATALOGADAS COMO ESEs
resumenESEs<-sqldf('select region, departamento, municipio, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where  ese="SI"')

## 2.6 - CONSULTA RESUMEN IPS PUBLICAS - (ESEs + OTRAS)
resumenPublicas<-sqldf('select departamento, municipio, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where naju_codigo=4 and clpr_codigo=1')

## 2.7 - CONSULTA RESUMEN IPS PRIVADAS - 
resumenPrivadas<-sqldf('select departamento, municipio, naju_nombre, clpr_nombre, municipio, nombre_prestador, caracter from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre where naju_codigo=1 and clpr_codigo=1')

## 3 - Resumen IPS vs Profesionales Independientes
IPSvsInd<-sqldf('select municipio, count(case when clpr_codigo=1 then 1 end) as IPSs, count(case when clpr_codigo=2 then 1 end) as Independientes from municipios MM inner join prestadores on MM.municipio = prestadores.muni_nombre and MM.departamento = prestadores.depa_nombre group by municipio')

			## ANALISIS DE DATOS CONSULTADOS ##

		##1. ANALSIS POR REGIONES

##Se evaluan todas las IPS
CrossTable(resumenBaseSinFiltros$region, resumenBaseSinFiltros$naju_nombre ,prop.chisq = F)
prop.table(table(resumenBaseSinFiltros$region))*100
	## Graficando los datos


data<-table(resumenBaseSinFiltros$region)
data <- data.frame(prop.table(table(resumenBaseSinFiltros$region))*100)

##Grafica Histograma de porcentaje de IPSs por Region
data %>% mutate(name = fct_reorder(Var1,Freq)) %>%
ggplot( aes(x=Freq, y=Var1)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Porcentaje de IPSs") +
    ylab("Región")
    theme_bw()

##Grafica Pie
pie(data$Freq, labels =data$Var1) 

##GRafica por naturaleza de las IPS
data <- data.frame(table(resumenBaseSinFiltros$naju_nombre)) 
prop.table(table(resumenBaseSinFiltros$naju_nombre))
pie(data$Freq, labels =data$Var1) 

## GRaficas Distribucion de los privado y lo publico

## IPSs privadas
data <- data.frame(prop.table(table(resumenIPSsPrivadas$region))*100)
data %>% mutate(name = fct_reorder(Var1,Freq)) %>%
ggplot( aes(x=Freq, y=Var1)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Porcentaje") +
    ylab("Porcentaje de IPS Privadas")
    theme_bw()

## IPSs publicas
data <- data.frame(prop.table(table(resumenIPSsPublicas$region))*100)
data %>% mutate(name = fct_reorder(Var1,Freq)) %>%
ggplot( aes(x=Freq, y=Var1)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Porcentaje") +
    ylab("Porcentaje de IPS Publicas")
    theme_bw()


##Se evaluan solo las ESE
CrossTable(resumenBaseESEs$region,prop.chisq = F)
prop.table(table(resumenBaseESEs$region))*100
	## Graficando los datos
barplot(prop.table(table(resumenBaseESEs$region))*100)

##independientes por region

CrossTable(resumenBaseIndependiente$region, resumenBaseIndependiente$naju_nombre ,prop.chisq = F)

data<-table(resumenBaseIndependiente$region)
data <- data.frame(prop.table(table(resumenBaseIndependiente$region))*100)

##Grafica Histograma de cantidad de Independientes por Region
data %>% mutate(name = fct_reorder(Var1,Freq)) %>%
ggplot( aes(x=Freq, y=Var1)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Porcentaje de Independientes") +
    ylab("Region")
    theme_bw()

	
		##2. ANALSIS POR DEPARTAMENTOS

	#2.1 Se evaluan unicamente las IPS


##Se tabula por departamento y naturaleza de la IPS

CrossTable(resumenIPS$departamento, resumenIPS$naju_nombre ,prop.chisq = F)
table(resumenIPS$departamento, resumenIPS$naju_nombre )

##Se expresa en porcentaje para hacer mas facil su interpretacion
round(prop.table(table(resumenIPS$departamento, resumenIPS$naju_nombre ))*100,2)

	#2.2 Se evaluan unicamente los prestadores independientes

##Se tabula por departamento y naturaleza de la IPS
CrossTable(resumenIndependientes$departamento, resumenIndependientes$naju_nombre ,prop.chisq = F)

CrossTable(resumenIPS$departamento, resumenIPS$naju_nombre ,prop.chisq = F)

	##2.3 Se evaluan las IPS por cada 10.000 habitantes

##Se detalla por naturaleza, privada, publica o mixta
print(resumenxHabs)
data <- data.frame( name=c(resumenxHabs$departamento) , val=c(resumenxHabs$Prestadores))
data
data %>% mutate(name = fct_reorder(name, val)) %>%
ggplot( aes(x=name, y=val)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Departamento") +
    ylab("Numero de IPSs por cada 10.000 Habitantes")
    theme_bw()

	##2.4 Se evaluan las IPS por cada 1000 Km2 de superficie

##Se detalla por naturaleza, privada, publica o mixta
print(resumenxSuperficie)
data <- data.frame( name=c(resumenxSuperficie$departamento) , val=c(resumenxSuperficie$TotalPrestadoresx1000))
data %>% mutate(name = fct_reorder(name, val)) %>%
ggplot( aes(x=name, y=val)) +
    geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
    coord_flip() +
    xlab("Departamento") +
    ylab("Numero de IPSs por cada 1000 Km2 de Superficie")
    theme_bw()


	##2.5 Se realiza un analisis de las ESEs

##Se cruza el departamento y el caracter
CrossTable(resumenESEs$departamento, resumenESEs$caracter,prop.chisq = F)
table(resumenESEs$departamento, resumenESEs$caracter)

table(resumenESEs$region, resumenESEs$caracter)


	##2.6 Se realiza un analisis de las entidades publicas (ESEs + entidades de origen indigena + educacion ...)

##Se cruza el departamento y el caracter
CrossTable(resumenPublicas$departamento, resumenPublicas$caracter,prop.chisq = F)
table(resumenPublicas$departamento, resumenPublicas$caracter)


	##2.7 Se realiza un analisis de las entidades privadas 

##Se cruza el departamento y el caracter
CrossTable(resumenPrivadas$departamento, resumenPrivadas$caracter,prop.chisq = F)
table(resumenPrivadas$departamento, resumenPrivadas$caracter)

	## 3 IPS vs Independientes (Correlacion)

cor(IPSvsInd$IPSs, IPSvsInd$Independientes)
cor.test(IPSvsInd$IPSs, IPSvsInd$Independientes)

ggscatter(IPSvsInd, x = "IPSs", y = "Independientes",  add = "reg.line",shape = 1 ,size=1,conf.int = TRUE, cor.coef = TRUE, cor.method = "pearson", xlab = "# IPSs", ylab = "# Independientes")




