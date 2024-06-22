## Aula 10 - Regressão Logística
### Vamos trabalhar com os dados de baixo peso ao nascer e considerar que, pelo conhecimento do contexto,
### faz sentido avaliar as seguintes covaríaveis: age,lwt (peso mãe) e smoke (indicador de fumo na gestação)
### Estamos aplicando esse método pensando num contexto em que o nosso interesse seja entender os fatores de 
### risco associados ao baixo peso ao nascer.

require(MASS)
require(dplyr)
require(stats)
require(glmtoolbox)
require(car)

### Vamos transformar smoke em categórica e peso, de libras, para kg
### 1 libra = 0.4535923kg
?birthwt
str(birthwt)

dados <- birthwt %>% 
  dplyr::select(low, age, lwt, smoke) %>% 
  dplyr::mutate(id = seq(1:nrow(birthwt)),
                low_cat = factor(low),
                peso_mae_kg = lwt*0.4535923,
                smoke_cat = factor(smoke))
str(dados)

### Exploração dos dados: contextualização
View(summary(dados))
View(dados)

### Avaliação das preditras com resposta

boxplot(dados$age ~ dados$low_cat,
        xlab = "Baixo peso",
        ylab = "Idade da mãe (anos)")

boxplot(dados$age ~ dados$low_cat,
        xlab = "Baixo peso",
        ylab = "Idade da mãe (anos)")$stats

dados %>% 
  dplyr::group_by(low_cat) %>% 
  dplyr::summarise(q1 = quantile(age, 0.25),
                   q2 = quantile(age, 0.5),
                   q3 = quantile(age, 0.75))

boxplot(dados$peso_mae_kg ~ dados$low_cat,
        xlab = "Baixo peso",
        ylab = "Peso da mãe (kg)")

boxplot(dados$peso_mae_kg ~ dados$low_cat,
        xlab = "Baixo peso",
        ylab = "Peso da mãe (kg)")$stats

dados %>% 
  dplyr::group_by(low_cat, smoke) %>% 
  dplyr::tally() %>% 
  dplyr::mutate(total = sum(n),
                pct = round((n/total)*100,2))

###############################################################################
### Ajuste do modelo de acordo com abordagem proposta por Hosmer & Lemeshow ###
###############################################################################
### Passo 1: ajuste modelo univariável
m1 <- stats::glm(low_cat ~ age, family = 'binomial', data = dados)
summary(m1) 

m2 <- stats::glm(low_cat ~ peso_mae_kg, family = 'binomial', data = dados)
summary(m2) 

m3 <- stats::glm(low_cat ~ smoke_cat, family = 'binomial', data = dados)
summary(m3)

### Passo 2: ajuste modelo multivariável considerando todas as variáveis que tiveram p < 0,25 no passo 1
### SEMPRE PENSAR NO CONTEXTO: FAZ SENTIDO ESSA EXCLUSÃO?
m_passo2 <- stats::glm(low_cat ~ age + peso_mae_kg + smoke_cat, family = 'binomial', data = dados)
summary(m_passo2)

### Passo 3: exclusão das variáveis que tem p > 0,05
### SEMPRE PENSAR NO CONTEXTO: FAZ SENTIDO ESSA EXCLUSÃO?
m_passo3 <- stats::glm(low_cat ~ peso_mae_kg + smoke_cat, family = 'binomial', data = dados)
summary(m_passo3) 

### Passo 4: estatísticas de diagnóstico do modelo
### 1. Medida de ajuste global: teste de Hosmer e Lemeshow
### H0: o modelo está bem ajustado.
# install.packages('glmtoolbox')
glmtoolbox::hltest(m_passo3) 
## estatística de teste segue dist qui-quadrado

### 2. Avaliação das medidas de influência
dist_cook <- data.frame(id = 1:nrow(dados), dist_cook = stats::cooks.distance(m_passo3))

ggplot(dist_cook, aes(x = id, y = dist_cook)) +
  geom_point() +
  geom_hline(yintercept = 4/nrow(dados), color = "red", linetype = "dashed") +
  labs(title = "Distância de Cook",
       x = "Índice",
       y = "Distância de Cook")

### 3. Avaliação dos resíduos de pearson 
residuos_pearson <- data.frame(indice = 1:nrow(dados),
                      residuos = residuals(m_passo3, type = "pearson"))

plot(x = residuos_pearson$indice, y = residuos_pearson$residuos)
abline(0, 0)

plot(x = sample(residuos_pearson$indice), y = residuos_pearson$residuos)
abline(0, 0)


### 4. Avaliação dos resíduos da deviance 
residuos_deviance <- data.frame(indice = 1:nrow(dados),
                               residuos = residuals(m_passo3, type = "deviance"))

plot(x = residuos_deviance$indice, y = residuos_deviance$residuos)
abline(0, 0)

plot(x = sample(residuos_deviance$indice), y = residuos_deviance$residuos)
abline(0, 0)

## Chegamos ao modelo final - vamos considerar que ele é confiável. O que seus coeficientes indicam?
summary(m_passo3) 
exp(coef(m_passo3))
## Para cada aumento de 1kg no peso da mãe, a chance do bebê nascer com baixo reduz em 3% 
## Mulheres q fumam na gestação tem 1,97 vezes a chance (ou chance 97% maior) de ter filho com
## baixo peso do que mães que não fumam

## E se eu quisesse saber o impacto no aumento de 10 kg?
exp(10*m_passo3$coefficients[2]) 
## Para cada aumento de 10kg no peso da mãe, a chance do bebê nascer com baixo reduz em 25%

## Intervalo de confiança para as estimativas:
exp(confint(m_passo3))
