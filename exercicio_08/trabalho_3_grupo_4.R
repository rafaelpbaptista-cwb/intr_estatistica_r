library(readxl)
dados <- read.csv("C:/Ambiente_desenvolvimento/intr_estatistica_r/exercicio_08/CO2 Emissions_Canada.csv")
## filtrando os dados
dados_compact <- subset(dados, Vehicle.Class == 'COMPACT')

## Analisando cada variavel
summary(dados_compact$Fuel.Consumption.Hwy..L.100.km.)
### Podemos ver que dentro os veiculos do tipo compacto o cosumo de combustivel a cada 100 km tem um valor minimo de 4.5 tendo média e medianas bem proximas,
### onde a mediana é 7,67 e a maxima de 13,10
summary(dados_compact$CO2.Emissions.g.km.)
### Já nos dados podemos de emissão de CO podemos ver que a minima fica em 106 com média e mediana também com valores proximos, onde a mediana é de 216,7 e valor maximo de 404

## teste de corelação 
correlacao_per <- cor(dados_compact$Fuel.Consumption.Hwy..L.100.km., dados_compact$CO2.Emissions.g.km., method = "pearson")
correlacao_spear  <- cor(dados_compact$Fuel.Consumption.Hwy..L.100.km., dados_compact$CO2.Emissions.g.km., method = "spearman")
correlacao_per
correlacao_spear
### com um valor de 0.9522173 podemos ver um grande correlacao entre o consumo de combustivel e a emissoa de CO2, ou seja quanto maior o consumo de combustivel
### maio vai ser a emissao de CO2


### teste de relação 
plot(dados_compact$Fuel.Consumption.Hwy..L.100.km., dados_compact$CO2.Emissions.g.km.,
     xlab = "Consumo de Combustível (L/100 km)",
     ylab = "Emissões de CO2 (g/km)",
     main = "Relação entre Consumo de Combustível e Emissões de CO2",
     pch = 19, col = "blue")

# Adicionar uma linha de tendência linear
abline(lm(dados_compact$CO2.Emissions.g.km. ~ dados_compact$Fuel.Consumption.Hwy..L.100.km.), col = "red")

## teste de hipotese
correlacao_test <- cor.test(dados_compact$Fuel.Consumption.Hwy..L.100.km., dados_compact$CO2.Emissions.g.km., method = "pearson")
correlacao_test

###Os resultados indicam que há uma correlação positiva muito forte e estatisticamente significativa entre o consumo de combustível na rodovia 
### e as emissões de CO2 para veículos do tipo COMPACT.
###Especificamente o coeficiente de correlação de 0.9522173 sugere que conforme o consumo de combustível aumenta, as emissões de CO2 também aumentam de maneira consistente.