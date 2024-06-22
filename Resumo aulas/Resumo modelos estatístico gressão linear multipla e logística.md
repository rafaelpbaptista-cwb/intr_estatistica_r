
# Passo-a-passo Detalhado de Uso de Modelos Estatísticos em Regressão Linear e Logística

## Introdução

Este guia passo-a-passo foi elaborado para ajudar estudantes a entenderem e aplicarem modelos estatísticos de regressão linear simples, múltipla e logística, conforme discutido nas aulas anteriores. Utilizaremos os materiais de apoio como transcrições das aulas, slides e códigos fornecidos para construir este tutorial.

## Regressão Linear Simples

### Conceitos Básicos
- **Definição:** Técnica estatística para modelar a relação entre uma variável dependente contínua (Y) e uma variável independente (X).
- **Modelo Matemático:** \(Y_i = \beta_0 + \beta_1 X_i + \epsilon_i\), onde \(Y_i\) é a variável resposta, \(X_i\) é a variável preditora, \(\beta_0\) é o intercepto, \(\beta_1\) é o coeficiente angular e \(\epsilon_i\) é o termo de erro.

### Etapas para Ajustar o Modelo
1. **Carregar os Dados:** Carregue o conjunto de dados no R.
2. **Visualização Inicial:** Use gráficos de dispersão para visualizar a relação entre X e Y.
3. **Ajuste do Modelo:** Utilize a função `lm()` para ajustar o modelo de regressão linear.
   ```R
   modelo <- lm(Y ~ X, data = dataset)
   summary(modelo)
   ```
4. **Avaliação do Modelo:** Verifique os coeficientes do modelo, o valor de R² e os resíduos.
5. **Diagnóstico do Modelo:** Utilize gráficos de resíduos, gráficos de distância de Cook, entre outros, para avaliar a adequação do modelo.

### Exemplo
```R
# Carregando dados
data <- read.csv("dados.csv")

# Visualização inicial
plot(data$X, data$Y, main="Dispersão de X e Y")

# Ajuste do modelo
modelo <- lm(Y ~ X, data = data)
summary(modelo)

# Avaliação dos resíduos
plot(resid(modelo), main="Resíduos do Modelo")
```

## Regressão Linear Múltipla

### Conceitos Básicos
- **Definição:** Extensão da regressão linear simples, onde várias variáveis independentes (X1, X2, ..., Xp) são utilizadas para predizer a variável dependente contínua (Y).
- **Modelo Matemático:** \(Y_i = \beta_0 + \beta_1 X_{i1} + \beta_2 X_{i2} + ... + \beta_p X_{ip} + \epsilon_i\)

### Etapas para Ajustar o Modelo
1. **Carregar os Dados:** Carregue o conjunto de dados no R.
2. **Visualização Inicial:** Utilize matrizes de correlação e gráficos de dispersão múltipla para entender as relações entre as variáveis.
3. **Ajuste do Modelo:** Utilize a função `lm()` para ajustar o modelo de regressão linear múltipla.
   ```R
   modelo <- lm(Y ~ X1 + X2 + ... + Xp, data = dataset)
   summary(modelo)
   ```
4. **Avaliação do Modelo:** Verifique os coeficientes do modelo, o valor de R² ajustado e os resíduos.
5. **Diagnóstico do Modelo:** Utilize gráficos de resíduos, gráficos de distância de Cook, análise de multicolinearidade, entre outros.

### Exemplo
```R
# Carregando dados
data <- read.csv("dados.csv")

# Ajuste do modelo
modelo <- lm(Y ~ X1 + X2 + X3, data = data)
summary(modelo)

# Avaliação dos resíduos
par(mfrow=c(2,2))
plot(modelo)
```

## Regressão Logística

### Conceitos Básicos
- **Definição:** Técnica estatística para modelar a relação entre uma variável dependente binária (Y) e uma ou mais variáveis independentes (X).
- **Modelo Matemático:** \(logit(p) = log(\frac{p}{1-p}) = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + ... + \beta_n X_n\)

### Etapas para Ajustar o Modelo
1. **Carregar os Dados:** Carregue o conjunto de dados no R.
2. **Visualização Inicial:** Use tabelas de contingência e gráficos de barras para visualizar a relação entre as variáveis.
3. **Ajuste do Modelo:** Utilize a função `glm()` com a família `binomial` para ajustar o modelo de regressão logística.
   ```R
   modelo <- glm(Y ~ X1 + X2 + ... + Xn, family = binomial, data = dataset)
   summary(modelo)
   ```
4. **Avaliação do Modelo:** Verifique os coeficientes do modelo, os valores de \(exp(\beta)\) e os resíduos.
5. **Diagnóstico do Modelo:** Utilize o teste de Hosmer & Lemeshow, análise de resíduos de Pearson e Deviance, e gráficos de distância de Cook.

### Exemplo
```R
# Carregando dados
data <- read.csv("dados.csv")

# Ajuste do modelo
modelo <- glm(Y ~ X1 + X2 + X3, family = binomial, data = data)
summary(modelo)

# Avaliação dos resíduos
residuals(modelo, type = "pearson")
```

## Exercícios Práticos

### Regressão Linear Simples
1. Carregar os dados do exemplo de altura dos pais e filhos.
2. Ajustar o modelo de regressão linear simples.
3. Avaliar e interpretar os resultados.

### Regressão Linear Múltipla
1. Carregar os dados do exemplo do consumo de oxigênio (VO2) com IMC e carga.
2. Ajustar o modelo de regressão linear múltipla.
3. Avaliar e interpretar os resultados.

### Regressão Logística
1. Carregar os dados do exemplo de baixo peso ao nascer.
2. Ajustar o modelo de regressão logística.
3. Avaliar e interpretar os resultados.

## Conclusão

Este guia abrange os conceitos e passos necessários para aplicar modelos de regressão linear simples, múltipla e logística. Com a prática e a familiarização com os exemplos fornecidos, os alunos serão capazes de aplicar essas técnicas em diversos contextos e conjuntos de dados.
