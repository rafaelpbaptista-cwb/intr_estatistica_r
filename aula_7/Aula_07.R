###################################
#   AULA 7 - TESTE DE HIPÓTESES   #
###################################

require(dplyr)
require(ggplot2)
require(car)
require(dunn.test)

dados <- read.csv("aula_7/pizzasize.csv")
head(dados)
dim(dados)
str(dados)
summary(dados)

## Primeiro passo: entender melhor esses dados
## 1. sabores e tipos de massas.. são iguais (mesmos nomes) em ambas as redes?
table(dados$Store, dados$CrustDescription)
table(dados$Store, dados$Topping)

dados <- dados %>% 
  dplyr::mutate(tipo_massa = factor(
    dplyr::case_when(CrustDescription %in% c('ClassicCrust', 'MidCrust') ~ 'Média',
                     CrustDescription == 'ThinNCrispy' | CrustDescription == 'ThinCrust' ~ 'Fina',
                     TRUE ~ 'Grossa'),
    levels = c('Fina', 'Média', 'Grossa')),
    sabor = factor(dplyr::case_when(Topping == 'SuperSupremo' | Topping == 'Supreme' ~ 'Supreme',
                                    TRUE ~ Topping)),
    marca = factor(Store, levels = c('EagleBoys', 'Dominos')))
str(dados)
summary(dados)

## 2. Que análises exploratórias poderíamos gerar? E que conclusões obtemos?
dados %>% 
  dplyr::group_by(Store) %>% 
  dplyr::summarise(media_diametro = mean(Diameter),
                   dp = sd(Diameter),
                   qtde = dplyr::n()) %>% 
  dplyr::ungroup()

boxplot(dados$Diameter ~ dados$Store)

dados %>% 
  dplyr::group_by(Store, tipo_massa) %>% 
  dplyr::summarise(media_diametro = mean(Diameter),
                   dp = sd(Diameter),
                   qtde = dplyr::n()) %>% 
  dplyr::ungroup() %>% 
  dplyr::arrange(tipo_massa)

par(mfrow = c(1,2))
boxplot(dados$Diameter ~ dados$tipo_massa, subset = (dados$Store == "Dominos"), 
        ylim = c(min(dados$Diameter), max(dados$Diameter)), 
        main = 'Dominos')
boxplot(dados$Diameter ~ dados$tipo_massa, subset = (dados$Store == "EagleBoys"),
        ylim = c(min(dados$Diameter), max(dados$Diameter)), main = 'EagleBoys')


dados %>% 
  dplyr::group_by(Store, sabor) %>% 
  dplyr::summarise(media_diametro = mean(Diameter),
                   dp = sd(Diameter),
                   qtde = dplyr::n()) %>% 
  dplyr::ungroup() %>% 
  dplyr::arrange(sabor)

par(mfrow = c(1,2))
boxplot(dados$Diameter ~ dados$sabor, subset = (dados$Store == "Dominos"),
        ylim = c(min(dados$Diameter), max(dados$Diameter)),
        main = 'Dominos')
boxplot(dados$Diameter ~ dados$sabor, subset = (dados$Store == "EagleBoys"),
        ylim = c(min(dados$Diameter), max(dados$Diameter)),
        main = 'EagleBoys')

## 3. As pizzas da EagleBoys realmente são maiores que as da Dominos?
## H1: diâmetro médio da Eagle > diâmetro médio Dominos - que teste utilizar?

hist(dados$Diameter)
car::qqPlot(dados$Diameter)
shapiro.test(dados$Diameter) # H0: dados são normais

hist(dados$Diameter[dados$Store == "Dominos"])
car::qqPlot(dados$Diameter[dados$Store == "Dominos"])
shapiro.test(dados$Diameter[dados$Store == "Dominos"]) # H0: dados são normais

hist(dados$Diameter[dados$Store == "EagleBoys"])
car::qqPlot(dados$Diameter[dados$Store == "EagleBoys"])
shapiro.test(dados$Diameter[dados$Store == "EagleBoys"]) # H0: dados são normais

car::leveneTest(Diameter ~ marca , data = dados) # H0: variâncias são iguais

print("Olá")
show(wilcox.test(Diameter ~ marca , data = dados, alternative = "greater"))
# dados %>% 
#   dplyr::group_by(marca) %>% 
#   dplyr::summarise(media_diametro = mean(Diameter),
#                    dp = sd(Diameter),
#                    qtde = dplyr::n()) %>% 
#   dplyr::ungroup()

# ## Dado o contexto do problema, será que está certo avaliar assim? 
# ## Na análise descritiva percebemos que existe diferença nos diametros de acordo com o tipo de massa e recheio. Como você faria?

# dados %>% 
#   dplyr::group_by(marca, tipo_massa, sabor) %>% 
#   dplyr::summarise(media_diametro = mean(Diameter),
#                    dp = sd(Diameter),
#                    qtde = dplyr::n()) %>% 
#   dplyr::ungroup() %>% 
#   dplyr::arrange(sabor, tipo_massa)


# teste1 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Fina" & sabor == "BBQMeatlovers"), exact = F) 
# teste2 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Média" & sabor == "BBQMeatlovers"), exact = F) 
# teste3 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Grossa" & sabor == "BBQMeatlovers"), exact = F) 

# teste4 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Fina" & sabor == "Hawaiian"), exact = F) 
# teste5 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Média" & sabor == "Hawaiian"), exact = F) 
# teste6 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Grossa" & sabor == "Hawaiian"), exact = F) 

# teste7 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Fina" & sabor == "Supreme"), exact = F) 
# teste8 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Média" & sabor == "Supreme"), exact = F) 
# teste9 <- wilcox.test(Diameter ~ marca , data = dados, alternative = "greater", subset = (tipo_massa == "Grossa" & sabor == "Supreme"), exact = F) 

# valores_p <- c(teste1$p.value, teste2$p.value, teste3$p.value, teste4$p.value, teste5$p.value, teste6$p.value, teste7$p.value, teste8$p.value, teste9$p.value) 
# p.adjust(valores_p, method = "bonferroni", n = 9)
# ## Conclusão: rejeitamos H0 em todas as comparações. 
# ## O que isso significa? Para todas as massas e sabores, o tamanho da pizza EagleBoys > Dominos.

# ## 4. As pizzas grandes da EagleBoys tem tamanho = 30,48 cm
# ## H1: diâmetro médio da pizza grande da Eagle # 30,48 cm -> que teste utilizar?

# dados %>% 
#   dplyr::filter(marca == 'EagleBoys') %>% 
#   dplyr::summarise(media_diametro = mean(Diameter),
#                    dp = sd(Diameter),
#                    qtde = dplyr::n()) %>% 
#   dplyr::ungroup()

# par(mfrow = c(1,2))
# hist(dados$Diameter[dados$Store == "EagleBoys"])
# car::qqPlot(dados$Diameter[dados$Store == "EagleBoys"])
# shapiro.test(dados$Diameter[dados$Store == "EagleBoys"]) # H0: dados são normais

# t.test(dados$Diameter[dados$Store == "EagleBoys"], mu = 30.48)
# ## Conclusão: rejeitamos H0. O que isso significa?
# ## Essa "propaganda" é falsa. O diâmetro das pizzas grandes varia entre 29,06 e 29,9 cm com 95% de confiança.

# ## 5. E se quiséssemos comparar o diâmetro médio das pizzas da Dominos de acordo com o tipo de massa?
# ## Como poderíamos fazer?
# ## H0 = diâmetro médio da pizza grande com massa fina = diâmetro médio da pizza grande com massa média = diâmetro médio da pizza grande com massa grossa 

# dados %>% 
#   dplyr::filter(marca == 'Dominos') %>% 
#   dplyr::group_by(tipo_massa) %>% 
#   dplyr::summarise(media_diametro = mean(Diameter),
#                    dp = sd(Diameter),
#                    qtde = dplyr::n()) %>% 
#   dplyr::ungroup()

# par(mfrow = c(2,2))
# hist(dados$Diameter[dados$Store == "Dominos"])
# car::qqPlot(dados$Diameter[dados$Store == "Dominos"])
# shapiro.test(dados$Diameter[dados$Store == "Dominos"]) # H0: dados são normais
# boxplot(Diameter ~ tipo_massa, data = dados, subset = (marca == 'Dominos'))

# kruskal.test(Diameter ~ tipo_massa, data = dados, subset = (marca == 'Dominos'))
# # Conclusão: há evidências de que o diâmetro das pizzas grandes é diferente entre os tipos de massas.
# # Quais são diferentes?
# dunn.test(dados$Diameter[dados$Store == "Dominos"], dados$tipo_massa[dados$Store == "Dominos"], method = "bonferroni")
# ## Conclusão: diâmetro pizza com massa fina é difente tanto da pizza com massa grossa, quanto da com massa média. Mas os diâmetros
# ## das pizzas com massas média e grossa podem ser considerados iguais.

# ## 6. E se quiséssemos comparar se a proporção de pizzas pedidas por marca é a mesma?
# ## Como poderíamos fazer?
# ## H0 = proporção de pedidos EagleBoys = proporção de pedidos Dominos 

# table(dados$marca)
# round(prop.table(table(dados$marca))*100, 0)
# prop.test(table(dados$marca))

