require(ggplot2)
dados <- diamonds

### Avaliação duas variáveis qualitativas
## Tabelas de frequência
freq_abs <- table(dados$cut, dados$clarity)
freq_abs[1,4]
freq_abs['Premium', 'IF']
freq_abs[1,2:5]

freq_rel <- round(prop.table(freq_abs, margin = 1)*100, 1)
sum(freq_rel['Good',])

freq_rel_col <- round(prop.table(freq_abs, margin = 2)*100, 1)
sum(freq_rel_col[,'VS1'])

### Avaliação duas variáveis quantitativas
require(readxl) # ou library(readxl) - as duas funções carregam pacotes
veiculos <- read_excel("C:/Users/natie/Google Drive/Aulas_CDA_UTFPR/Aulas_2024/Aula2_E_Aula3(a partir slide21)/veiculos.xls")
View(veiculos)
str(veiculos)
veiculos$proc <- factor(veiculos$proc, levels = c('Nacional', 'Importado'))

plot(veiculos$motor, veiculos$comp,
     xlab = 'Pot. do Motor',
     ylab = 'Comp',
     main = 'Gráfico de dispersão de pot. do motor vs comprimento')

cor(veiculos$motor, veiculos$comp, method = "pearson")
cor(veiculos$motor, veiculos$comp, method = "spearman")
boxplot(veiculos$motor)
boxplot(veiculos$comp)
hist(veiculos$motor)
hist(veiculos$comp)

## Uma quali e uma quanti

tapply(veiculos$motor, veiculos$proc, summary)
boxplot(veiculos$motor ~ veiculos$proc,
        xlab = "Proc. motor",
        ylab = 'Pot. motor (cv)',
        boxwex = 0.5,
        col = 'blue')

## Gráfico de dispersão considerando variável qualitativa
plot(x = veiculos$motor,
     y = veiculos$preco,
     pch = as.numeric(veiculos$proc),
     col = veiculos$proc
     )
legend("topleft", 
       legend = c('Nacional', 'Importado'),
       pch = c(1, 2),
       col = c('black', 'red')
       )

require(ggplot2)
ggplot2::ggplot(data = veiculos,
                aes(x = motor, y = preco)) + geom_point() + facet_wrap(~proc)
                  

## Avaliação var quali e quanti
tapply(veiculos$comp, veiculos$proc, summary)
tapply(veiculos$comp, veiculos$proc, sd)
tapply(veiculos$preco, veiculos$proc, summary)

round(cor(veiculos[,2:4], method = 'pearson'),1)
round(cor(veiculos[,2:4], method = 'spearman'),1)
veiculos[,c('preco', 'comp', 'motor')]

## Avaliação mais de 2 var quali
require(stats) 
# library(stats)
freq_abs_mult <- stats::ftable(diamonds$cut, diamonds$clarity, diamonds$color)
round(prop.table(freq_abs_mult)*100, 1)
  
### Gráfico do desenhista
### Passo 1: criando função que permite personalizar componentes do gráfico
panel.cor <- function(x, y, digits = 2, cex.cor, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  # correlation coefficient
  r <- cor(x,y)
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <-  paste("r= ", txt, sep = "")
  text(0.5, 0.5, txt, cex = 1.1)
}

require(graphics)
g_desenhista1 <- graphics::pairs(~preco + comp + motor, data = veiculos)
g_desenhista2 <- graphics::pairs(~preco + comp + motor, data = veiculos,
                                 upper.panel = panel.cor, # indica o que vai aparecer acima e abaixo da diagonal
                                 cex = 1.2, # aumento tamanho símbolos
                                 pch = 1, # tipo de símbolo (1 = bola em branco; 19 = bola preta)
                                 cex.labels = 1.3, # aumento tamanho nome das variáveis
                                 cex.axis = 1.1 # aumento tamanho eixos
)
