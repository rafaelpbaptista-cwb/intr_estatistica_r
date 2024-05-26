## Análise de dados para uma variável

### Passo 1: obtenção dos dados
# install.packages('ggplot2')
require(ggplot2)
dados <- diamonds
# ?diamonds
# View(dados)
str(dados)

### Passo 2: descrição dos dados
summary(dados)

### Passo 3: descrição variáveis qualitativas
freq_abs <- table(dados$cut)
freq_rel <-round(prop.table(freq_abs)*100, 2)
barplot(freq_abs)

text(
  barplot(freq_abs,
          xlab = 'Qualidade do corte',
          ylab = "Freq abs",
          main = "n - qualidade corte",
          col = "red",
          ylim = c(0, 23000)),
  y = freq_abs + 1000, 
  labels = as.character(freq_abs))

barplot(freq_rel,
        xlab = 'Qualidade do corte',
        ylab = "Freq abs",
        main = "n - qualidade corte",
        col = "red",
        ylim = c(0, 100))

pie(freq_abs,
    labels = paste0(freq_rel, "%"),
    col = rainbow(length(freq_abs)),
    main = 'Qualidade do corte')
legend("bottomright", levels(dados$cut), fill = rainbow(length(freq_abs)))


### Passo 4: descrição variáveis quantitativas
mean(dados$price)
median(dados$price)
quantile(dados$price)
var(dados$price) # var amostral (denominador = n-1)
sd(dados$price)
hist(dados$price)
boxplot(dados$price)
boxplot(dados$price, outline = FALSE) # ñ exibe outliers
boxplot(dados$price)
title("Boxplot preço diamantes")

boxplot.stats(dados$price)$stats # função que indica quais são os valores do boxplot
quantile(dados$price)
## Outliers: Q3 + 1,5*IQR; Q1 - 1,5*IQR
limite_sup <- quantile(dados$price)['75%'] + 1.5*(quantile(dados$price)['75%'] - quantile(dados$price)['25%'])
# quantile(dados$price)['25%'] - 1.5*(quantile(dados$price)['75%'] - quantile(dados$price)['25%'])
valores <- as.integer(c(boxplot.stats(dados$price)$stats, limite_sup))
boxplot(dados$price, main = "Boxplot diamonds - price", ylab = "US dollars")
text(y = valores, labels = valores, x = 1.25)

require('vioplot')
vioplot(dados$price)

