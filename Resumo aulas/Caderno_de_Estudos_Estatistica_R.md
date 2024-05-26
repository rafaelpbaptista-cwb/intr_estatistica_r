
# Caderno de Estudos: Introdução à Estatística com R

## 2. Tipos de Variáveis

### Variáveis Quantitativas (Discretas e Contínuas)
- **Discretas**: Números inteiros que contam a frequência de ocorrências (ex: número de filhos).
- **Contínuas**: Números reais que podem representar qualquer valor dentro de um intervalo (ex: peso, altura).

### Variáveis Qualitativas (Nominais e Ordinais)
- **Nominais**: Não possuem uma ordem natural (ex: sexo, raça).
- **Ordinais**: Possuem uma ordem natural (ex: grau de satisfação).

## 3. Análise Exploratória de Dados

### Análise de uma Variável Qualitativa
Utilize o seguinte código R para criar um gráfico de barras da variável categórica 'gear' no conjunto de dados mtcars:
```R
library(ggplot2)
ggplot(mtcars, aes(x=factor(gear))) + 
  geom_bar() + 
  xlab("Número de Engrenagens") + 
  ylab("Frequência") + 
  ggtitle("Distribuição de Engrenagens nos Carros")
```

### Análise de uma Variável Quantitativa
Exemplo de histograma e boxplot para a variável 'Ozone' no conjunto de dados 'airquality':
```R
# Histograma
ggplot(airquality, aes(x=Ozone)) +
  geom_histogram(bins=10, fill="blue", color="black") +
  ggtitle("Distribuição de Ozônio") +
  xlab("Concentração de Ozônio") +
  ylab("Frequência")

# Boxplot
ggplot(airquality, aes(y=Ozone)) +
  geom_boxplot(fill="tomato", color="black") +
  ggtitle("Boxplot de Ozônio") +
  ylab("Concentração de Ozônio")
```

## 4. Relacionamentos Entre Variáveis
Exploração gráfica da relação entre duas ou mais variáveis usando gráficos de dispersão e análise de correlação em R.

## 5. Exercícios e Exemplos Práticos em R
Detalhamento dos scripts de R fornecidos com exemplos adicionais para ilustrar os conceitos com dados práticos.

## 6. Conclusão
Resumo dos principais aprendizados e orientações para aplicação dos conceitos em situações práticas e estudos futuros.
