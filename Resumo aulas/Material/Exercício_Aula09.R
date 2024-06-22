## Aula 09 -  Regressão Linear Simples e Múltipla

## Para ver todos os conjuntos dados diponíveis:
library(help = "datasets")

dim(mtcars)
str(mtcars)

## Pela descrição, performance de 32 automóveis - 32 carros distintos - podemos assumir idependencia
## Nosso interessse está em olhar: 
## y = consumo de combustível = mpg
## x = wt (peso), hp (potência) e disp (deslocamento)
require(dplyr)

exemplo_reg <- mtcars %>% 
  dplyr::select(mpg, wt, hp, disp)
summary(exemplo_reg)

par(mfrow = c(2, 2))
boxplot(exemplo_reg$mpg, main = "mpg")
boxplot(exemplo_reg$wt, main = 'wt')
boxplot(exemplo_reg$hp, main = 'hp')
boxplot(exemplo_reg$disp, main = 'disp')


## 1. Relação linear?
par(mfrow = c(2, 2))
plot(exemplo_reg$mpg, exemplo_reg$wt)
plot(exemplo_reg$mpg, exemplo_reg$hp)
plot(exemplo_reg$mpg, exemplo_reg$disp)


## 2. Multicolinearidade?
cor(exemplo_reg) # O que chama atenção aqui?

## Ajuste do modelo
modelo1_rlm <- stats::lm(mpg ~ wt + hp + disp, data = exemplo_reg)
summary(modelo1_rlm)

modelo2_rlm <- stats::lm(mpg ~ wt + hp, data = exemplo_reg)
summary(modelo2_rlm) 

## Avaliação ajuste:
# 1. Linearidade das relações entre as variáveis dependentes e independentes
# 2. Independência das observações
# 3. Normalidade dos resíduos
# 4. Homocedasticidade dos resíduos
# 5. Pontos influentes

## Opação 1:
par(mfrow = c(2,3))

plot(x = exemplo_reg$wt , y = stats::rstandard(modelo2_rlm), 
     xlab = "wt", ylab = "Resíduos padronizados")
abline(0, 0)

plot(x = exemplo_reg$hp, y = stats::rstandard(modelo2_rlm), 
     xlab = "hp", ylab = "Resíduos padronizados")
abline(0, 0)

plot(x = predict(modelo2_rlm), y = stats::rstandard(modelo2_rlm), 
     xlab = "mpg estimado", ylab = "Resíduos padronizados")
abline(0, 0)

plot(modelo2_rlm, which = 2)

plot(plot(cooks.distance(modelo2_rlm),
          xlab = "Observação",
          ylab = "Distância de Cook"))

## Opção 2
par(mfrow = c(2,2))
plot(modelo2_rlm)

## Opção 3
#install.packages("performance")
#install.packages("see")
require(performance)
require(see)

performance::check_model(modelo2_rlm)
## Nesse exemplo, a interpretação seria: 
## 81% da variabilidade do consumo de combustível é explicada pelo peso e potencia do carro.
## Beta1  = Para um aumento de uma unidade no peso. o número de milhas/galão reduz, em média, 3,9 
## para um nível constante deslocamento.
## Beta2 = para um aumento de uma unidade de potência, a distância percorrida com um galão diminui, em média, 
## 0,03 milha, para um nível constante de peso.


## Se quisesse saber qual o consumo esperado para um automóvel com peso 4500 libras e hp = 250?
new.dat <- data.frame(wt = 4.5, hp = 250)
stats::predict(modelo2_rlm, newdata = new.dat, interval = 'confidence')
### Média esperada (estimativa pontual): 11,8 milhas por galão; com 95% de confinça: entre 10,07 e 13,6 mpg.


## Agora... e se tivessemos uma variável qualitativa no modelo? como seria?
## Vamos considerar a varivável forma do motor (vs) e acrescentá-la num modelo com peso - objetivo: olhar como seria interpretação
?mtcars

exemplo2_reg <- mtcars %>% 
  dplyr::select(mpg, wt, hp, vs) %>% 
  dplyr::mutate(vs_factor = factor(dplyr::case_when(vs == 1 ~ 'reto', TRUE ~  'formato v'), 
                                   levels = c('reto', 'formato v')))

str(exemplo2_reg)
summary(exemplo2_reg)

modelo3_rlm <- stats::lm(mpg ~ wt + vs_factor, data = exemplo2_reg)
summary(modelo3_rlm) # Vamos avaliar ajuste desse modelo!

performance::check_model(modelo3_rlm)

?AIC
stats::AIC(modelo1_rlm)
stats::AIC(modelo2_rlm)
stats::AIC(modelo3_rlm)
