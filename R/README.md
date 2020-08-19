---
output: 
  html_document:
    df_print: paged
    toc: true
    toc_float:
      collapsed: false
      smooth_scroll: false
    number_section: true
    theme: journal
    keep_md: true
---

# Regressão Linear no R

</br>

## Pacotes utilizados para a regressão linear

</br>


```r
library(skimr)
```

Ferramenta para análise exploratória dos dados.


```r
library(tidyverse)
```

Ferramenta completa para análise de dados.


```r
library(tidymodels)
```

Além de ser uma forte ferramenta de modelagem (utilizando o parsnip, que não veremos por agora), inclui o pacote broom, que transforma o output de um modelo de regressão linear em uma base de dados tidy.


```r
library(olsrr)
```

Possui diversos testes que validam as suposições do modelo de regressão linear.


```r
library(tseries)
```

Possui o teste jarque-bera, que testa a normalidade de um conjunto de dados. Em geral o shapiro-wilk test performa melhor, mas o teste jarque-bera é o ensinado no curso de econometria.

***

O único elemento diferente do curso tradicional de econometria (além da aplicação no R) é o uso do teste breusch-pagan de heterocedasticidade ao invés do teste de white. Apesar de ser mais fácil de pronunciar, o teste de white não é feito de forma satisfatória no R. Contudo, ele é apenas um caso especial do breusch-pagan. Além disso, o teste de white é tão específico que pode indicar outros problemas no modelo que não a heterocedasticidade, não indicando qual o problema encontrado. Dessa forma, o breusch-pagan é uma forma menos confusa e mais objetiva de realizar esse teste.  



</br>

## Base utilizada

</br>

A título de exemplo, utilizaremos a clássica base mtcars, já presente no R. Como ela vem como um data.frame, transformarei ela em um tibble para mais fácil manipulação. Aproveitarei para realizar uma análise exploratória com o skimr.


```r
tibble(mtcars)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["mpg"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["cyl"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["disp"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hp"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["drat"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["wt"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["qsec"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["vs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["am"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["gear"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["carb"],"name":[11],"type":["dbl"],"align":["right"]}],"data":[{"1":"21.0","2":"6","3":"160.0","4":"110","5":"3.90","6":"2.620","7":"16.46","8":"0","9":"1","10":"4","11":"4"},{"1":"21.0","2":"6","3":"160.0","4":"110","5":"3.90","6":"2.875","7":"17.02","8":"0","9":"1","10":"4","11":"4"},{"1":"22.8","2":"4","3":"108.0","4":"93","5":"3.85","6":"2.320","7":"18.61","8":"1","9":"1","10":"4","11":"1"},{"1":"21.4","2":"6","3":"258.0","4":"110","5":"3.08","6":"3.215","7":"19.44","8":"1","9":"0","10":"3","11":"1"},{"1":"18.7","2":"8","3":"360.0","4":"175","5":"3.15","6":"3.440","7":"17.02","8":"0","9":"0","10":"3","11":"2"},{"1":"18.1","2":"6","3":"225.0","4":"105","5":"2.76","6":"3.460","7":"20.22","8":"1","9":"0","10":"3","11":"1"},{"1":"14.3","2":"8","3":"360.0","4":"245","5":"3.21","6":"3.570","7":"15.84","8":"0","9":"0","10":"3","11":"4"},{"1":"24.4","2":"4","3":"146.7","4":"62","5":"3.69","6":"3.190","7":"20.00","8":"1","9":"0","10":"4","11":"2"},{"1":"22.8","2":"4","3":"140.8","4":"95","5":"3.92","6":"3.150","7":"22.90","8":"1","9":"0","10":"4","11":"2"},{"1":"19.2","2":"6","3":"167.6","4":"123","5":"3.92","6":"3.440","7":"18.30","8":"1","9":"0","10":"4","11":"4"},{"1":"17.8","2":"6","3":"167.6","4":"123","5":"3.92","6":"3.440","7":"18.90","8":"1","9":"0","10":"4","11":"4"},{"1":"16.4","2":"8","3":"275.8","4":"180","5":"3.07","6":"4.070","7":"17.40","8":"0","9":"0","10":"3","11":"3"},{"1":"17.3","2":"8","3":"275.8","4":"180","5":"3.07","6":"3.730","7":"17.60","8":"0","9":"0","10":"3","11":"3"},{"1":"15.2","2":"8","3":"275.8","4":"180","5":"3.07","6":"3.780","7":"18.00","8":"0","9":"0","10":"3","11":"3"},{"1":"10.4","2":"8","3":"472.0","4":"205","5":"2.93","6":"5.250","7":"17.98","8":"0","9":"0","10":"3","11":"4"},{"1":"10.4","2":"8","3":"460.0","4":"215","5":"3.00","6":"5.424","7":"17.82","8":"0","9":"0","10":"3","11":"4"},{"1":"14.7","2":"8","3":"440.0","4":"230","5":"3.23","6":"5.345","7":"17.42","8":"0","9":"0","10":"3","11":"4"},{"1":"32.4","2":"4","3":"78.7","4":"66","5":"4.08","6":"2.200","7":"19.47","8":"1","9":"1","10":"4","11":"1"},{"1":"30.4","2":"4","3":"75.7","4":"52","5":"4.93","6":"1.615","7":"18.52","8":"1","9":"1","10":"4","11":"2"},{"1":"33.9","2":"4","3":"71.1","4":"65","5":"4.22","6":"1.835","7":"19.90","8":"1","9":"1","10":"4","11":"1"},{"1":"21.5","2":"4","3":"120.1","4":"97","5":"3.70","6":"2.465","7":"20.01","8":"1","9":"0","10":"3","11":"1"},{"1":"15.5","2":"8","3":"318.0","4":"150","5":"2.76","6":"3.520","7":"16.87","8":"0","9":"0","10":"3","11":"2"},{"1":"15.2","2":"8","3":"304.0","4":"150","5":"3.15","6":"3.435","7":"17.30","8":"0","9":"0","10":"3","11":"2"},{"1":"13.3","2":"8","3":"350.0","4":"245","5":"3.73","6":"3.840","7":"15.41","8":"0","9":"0","10":"3","11":"4"},{"1":"19.2","2":"8","3":"400.0","4":"175","5":"3.08","6":"3.845","7":"17.05","8":"0","9":"0","10":"3","11":"2"},{"1":"27.3","2":"4","3":"79.0","4":"66","5":"4.08","6":"1.935","7":"18.90","8":"1","9":"1","10":"4","11":"1"},{"1":"26.0","2":"4","3":"120.3","4":"91","5":"4.43","6":"2.140","7":"16.70","8":"0","9":"1","10":"5","11":"2"},{"1":"30.4","2":"4","3":"95.1","4":"113","5":"3.77","6":"1.513","7":"16.90","8":"1","9":"1","10":"5","11":"2"},{"1":"15.8","2":"8","3":"351.0","4":"264","5":"4.22","6":"3.170","7":"14.50","8":"0","9":"1","10":"5","11":"4"},{"1":"19.7","2":"6","3":"145.0","4":"175","5":"3.62","6":"2.770","7":"15.50","8":"0","9":"1","10":"5","11":"6"},{"1":"15.0","2":"8","3":"301.0","4":"335","5":"3.54","6":"3.570","7":"14.60","8":"0","9":"1","10":"5","11":"8"},{"1":"21.4","2":"4","3":"121.0","4":"109","5":"4.11","6":"2.780","7":"18.60","8":"1","9":"1","10":"4","11":"2"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
skim(tibble(mtcars))
```


Table: Data summary

|                         |               |
|:------------------------|:--------------|
|Name                     |tibble(mtcars) |
|Number of rows           |32             |
|Number of columns        |11             |
|_______________________  |               |
|Column type frequency:   |               |
|numeric                  |11             |
|________________________ |               |
|Group variables          |None           |


**Variable type: numeric**

|skim_variable | n_missing| complete_rate|   mean|     sd|    p0|    p25|    p50|    p75|   p100|hist                                     |
|:-------------|---------:|-------------:|------:|------:|-----:|------:|------:|------:|------:|:----------------------------------------|
|mpg           |         0|             1|  20.09|   6.03| 10.40|  15.43|  19.20|  22.80|  33.90|▃▇▅▁▂ |
|cyl           |         0|             1|   6.19|   1.79|  4.00|   4.00|   6.00|   8.00|   8.00|▆▁▃▁▇ |
|disp          |         0|             1| 230.72| 123.94| 71.10| 120.83| 196.30| 326.00| 472.00|▇▃▃▃▂ |
|hp            |         0|             1| 146.69|  68.56| 52.00|  96.50| 123.00| 180.00| 335.00|▇▇▆▃▁ |
|drat          |         0|             1|   3.60|   0.53|  2.76|   3.08|   3.70|   3.92|   4.93|▇▃▇▅▁ |
|wt            |         0|             1|   3.22|   0.98|  1.51|   2.58|   3.33|   3.61|   5.42|▃▃▇▁▂ |
|qsec          |         0|             1|  17.85|   1.79| 14.50|  16.89|  17.71|  18.90|  22.90|▃▇▇▂▁ |
|vs            |         0|             1|   0.44|   0.50|  0.00|   0.00|   0.00|   1.00|   1.00|▇▁▁▁▆ |
|am            |         0|             1|   0.41|   0.50|  0.00|   0.00|   0.00|   1.00|   1.00|▇▁▁▁▆ |
|gear          |         0|             1|   3.69|   0.74|  3.00|   3.00|   4.00|   4.00|   5.00|▇▁▆▁▂ |
|carb          |         0|             1|   2.81|   1.62|  1.00|   2.00|   2.00|   4.00|   8.00|▇▂▅▁▁ |

Apesar de todas as variáveis serem numéricas, é possível observar que algumas delas, como a 'cyl', são variáveis discretas. Por isso, é desejável que elas sejam tratadas como fatores, não como variáveis contínuas. O código a seguir faz exatamente isso, transformando em fatores apenas as variáveis com menos de 6 valores distintos.


```r
df <- 
  tibble(mtcars)%>% 
  mutate_if(~ length(unique(.x)) < 6, as.factor)
```

</br>

## Execução da regressão linear

</br>

O comando a seguir (lm) utiliza o formato de fórmulas do R. O argumento "mpg ~ ." (que é a fórmula) pode ser lido como "mpg explicado por todas as outras variáveis do modelo". O resultado dessa abordagem é idêntico ao resultado caso a fórmula fosse "mpg ~ cyl + disp + hp + drat + wt + qsec + vs + am + gear + carb", ou seja, "mpg explicado por todas essas variáveis enunciadas". Contudo, escrever assim é claramente mais trabalhoso.


```r
reg <- lm(mpg ~ ., data = df)
reg
```

```
## 
## Call:
## lm(formula = mpg ~ ., data = df)
## 
## Coefficients:
## (Intercept)         cyl6         cyl8         disp           hp         drat  
##    15.09262     -1.19940      3.05492      0.01257     -0.05712      0.73577  
##          wt         qsec          vs1          am1        gear4        gear5  
##    -3.54512      0.76801      2.48849      3.34736     -0.99922      1.06455  
##        carb  
##     0.78703
```

Com isso, é estimado nosso modelo de regressão linear. Ao imprimirmos "reg", o console nos mostra as estimativas dos parâmetros de cada um dos fatores da regressão, mas não nos mostra as estatísticas da regressão.

É interessante notar que, automaticamente, o R reconhece que variáveis em formato de fatores são variáveis dummy e adiciona essas variáveis em quantidade certa, deixando sempre uma dummy como valor base. É possível alterar a dummy base manipulando a variável por meio da função fct_relevel().


```r
summary(reg)
```

```
## 
## Call:
## lm(formula = mpg ~ ., data = df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.2015 -1.2319  0.1033  1.1953  4.3085 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept) 15.09262   17.13627   0.881   0.3895  
## cyl6        -1.19940    2.38736  -0.502   0.6212  
## cyl8         3.05492    4.82987   0.633   0.5346  
## disp         0.01257    0.01774   0.708   0.4873  
## hp          -0.05712    0.03175  -1.799   0.0879 .
## drat         0.73577    1.98461   0.371   0.7149  
## wt          -3.54512    1.90895  -1.857   0.0789 .
## qsec         0.76801    0.75222   1.021   0.3201  
## vs1          2.48849    2.54015   0.980   0.3396  
## am1          3.34736    2.28948   1.462   0.1601  
## gear4       -0.99922    2.94658  -0.339   0.7382  
## gear5        1.06455    3.02730   0.352   0.7290  
## carb         0.78703    1.03599   0.760   0.4568  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.616 on 19 degrees of freedom
## Multiple R-squared:  0.8845,	Adjusted R-squared:  0.8116 
## F-statistic: 12.13 on 12 and 19 DF,  p-value: 1.764e-06
```

A função summary pertence ao R base e nos mostra a mesma saída do Stata. Essencialmente possui as principais estatísticas para a análise do modelo. Contudo, apesar de muito positivo nesse aspecto, peca por não sair em formato tidy. Para isso, usamos o pacote "broom", que possui 3 funções muito úteis na análise de regressões. A função tidy() foca nos parâmetros, mostrando seus valores e estatísticas em formato tidy. A função augment() foca nos resultados do modelo, sendo útil para extrair os resíduos e os resíduos padronizados do modelo. Por último, a função glance() foca na qualidade do modelo, analisando medidas como o $R^2$ e o teste F-parcial da regressão.

É bom relembrar que, uma vez com as tabelas tidy, essas poderão ser manipuladas assim como qualquer outro tibble pelo tidyverse.


```r
tidy(reg)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["term"],"name":[1],"type":["chr"],"align":["left"]},{"label":["estimate"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["std.error"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["statistic"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["p.value"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"(Intercept)","2":"15.09261548","3":"17.13627433","4":"0.8807408","5":"0.38946336"},{"1":"cyl6","2":"-1.19939698","3":"2.38736481","4":"-0.5023937","5":"0.62116357"},{"1":"cyl8","2":"3.05491692","3":"4.82986776","4":"0.6325053","5":"0.53459525"},{"1":"disp","2":"0.01256810","3":"0.01774024","4":"0.7084518","5":"0.48726645"},{"1":"hp","2":"-0.05711722","3":"0.03174603","4":"-1.7991927","5":"0.08789210"},{"1":"drat","2":"0.73576811","3":"1.98461241","4":"0.3707364","5":"0.71493502"},{"1":"wt","2":"-3.54511861","3":"1.90895437","4":"-1.8570997","5":"0.07886857"},{"1":"qsec","2":"0.76801287","3":"0.75221895","4":"1.0209964","5":"0.32008122"},{"1":"vs1","2":"2.48849171","3":"2.54014636","4":"0.9796647","5":"0.33956206"},{"1":"am1","2":"3.34735713","3":"2.28948094","4":"1.4620594","5":"0.16006890"},{"1":"gear4","2":"-0.99921782","3":"2.94657533","4":"-0.3391116","5":"0.73824498"},{"1":"gear5","2":"1.06454635","3":"3.02729599","4":"0.3516492","5":"0.72897110"},{"1":"carb","2":"0.78702815","3":"1.03599487","4":"0.7596834","5":"0.45676696"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
augment(reg)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["mpg"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["cyl"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["disp"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hp"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["drat"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["wt"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["qsec"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["vs"],"name":[8],"type":["fctr"],"align":["left"]},{"label":["am"],"name":[9],"type":["fctr"],"align":["left"]},{"label":["gear"],"name":[10],"type":["fctr"],"align":["left"]},{"label":["carb"],"name":[11],"type":["dbl"],"align":["right"]},{"label":[".fitted"],"name":[12],"type":["dbl"],"align":["right"]},{"label":[".resid"],"name":[13],"type":["dbl"],"align":["right"]},{"label":[".std.resid"],"name":[14],"type":["dbl"],"align":["right"]},{"label":[".hat"],"name":[15],"type":["dbl"],"align":["right"]},{"label":[".sigma"],"name":[16],"type":["dbl"],"align":["right"]},{"label":[".cooksd"],"name":[17],"type":["dbl"],"align":["right"]}],"data":[{"1":"21.0","2":"6","3":"160.0","4":"110","5":"3.90","6":"2.620","7":"16.46","8":"0","9":"1","10":"4","11":"4","12":"21.34025","13":"-0.34024954","14":"-0.16966778","15":"0.4124628","16":"2.685912","17":"0.0015545505"},{"1":"21.0","2":"6","3":"160.0","4":"110","5":"3.90","6":"2.875","7":"17.02","8":"0","9":"1","10":"4","11":"4","12":"20.86633","13":"0.13366851","14":"0.06501380","15":"0.3824301","16":"2.687650","17":"0.0002013417"},{"1":"22.8","2":"4","3":"108.0","4":"93","5":"3.85","6":"2.320","7":"18.61","8":"1","9":"1","10":"4","11":"1","12":"25.66248","13":"-2.86247995","14":"-1.36012757","15":"0.3529101","16":"2.553742","17":"0.0776095805"},{"1":"21.4","2":"6","3":"258.0","4":"110","5":"3.08","6":"3.215","7":"19.44","8":"1","9":"0","10":"3","11":"1","12":"19.92719","13":"1.47280544","14":"0.74641594","15":"0.4311890","16":"2.648247","17":"0.0324876417"},{"1":"18.7","2":"8","3":"360.0","4":"175","5":"3.15","6":"3.440","7":"17.02","8":"0","9":"0","10":"3","11":"2","12":"17.44463","13":"1.25536684","14":"0.54337585","15":"0.2202064","16":"2.666982","17":"0.0064136844"},{"1":"18.1","2":"6","3":"225.0","4":"105","5":"2.76","6":"3.460","7":"20.22","8":"1","9":"0","10":"3","11":"1","12":"19.29308","13":"-1.19308342","14":"-0.61560374","15":"0.4512454","16":"2.661008","17":"0.0239714228"},{"1":"14.3","2":"8","3":"360.0","4":"245","5":"3.21","6":"3.570","7":"15.84","8":"0","9":"0","10":"3","11":"4","12":"13.69751","13":"0.60249038","14":"0.30152724","15":"0.4167078","16":"2.681510","17":"0.0049963776"},{"1":"24.4","2":"4","3":"146.7","4":"62","5":"3.69","6":"3.190","7":"20.00","8":"1","9":"0","10":"4","11":"2","12":"23.22473","13":"1.17526784","14":"0.64155554","15":"0.5097200","16":"2.658675","17":"0.0329164217"},{"1":"22.8","2":"4","3":"140.8","4":"95","5":"3.92","6":"3.150","7":"22.90","8":"1","9":"0","10":"4","11":"2","12":"23.80398","13":"-1.00398085","14":"-0.82489338","15":"0.7835816","16":"2.639378","17":"0.1895144146"},{"1":"19.2","2":"6","3":"167.6","4":"123","5":"3.92","6":"3.440","7":"18.30","8":"1","9":"0","10":"4","11":"4","12":"18.35524","13":"0.84476037","14":"0.43109334","15":"0.4389992","16":"2.674771","17":"0.0111866372"},{"1":"17.8","2":"6","3":"167.6","4":"123","5":"3.92","6":"3.440","7":"18.90","8":"1","9":"0","10":"4","11":"4","12":"18.81605","13":"-1.01604735","14":"-0.49440488","15":"0.3829769","16":"2.670603","17":"0.0116706038"},{"1":"16.4","2":"8","3":"275.8","4":"180","5":"3.07","6":"4.070","7":"17.40","8":"0","9":"0","10":"3","11":"3","12":"14.88740","13":"1.51260039","14":"0.70952686","15":"0.3360280","16":"2.652100","17":"0.0195983753"},{"1":"17.3","2":"8","3":"275.8","4":"180","5":"3.07","6":"3.730","7":"17.60","8":"0","9":"0","10":"3","11":"3","12":"16.24634","13":"1.05365749","14":"0.45507803","15":"0.2168117","16":"2.673260","17":"0.0044100643"},{"1":"15.2","2":"8","3":"275.8","4":"180","5":"3.07","6":"3.780","7":"18.00","8":"0","9":"0","10":"3","11":"3","12":"16.37629","13":"-1.17629173","14":"-0.51952788","15":"0.2510525","16":"2.668789","17":"0.0069596514"},{"1":"10.4","2":"8","3":"472.0","4":"205","5":"2.93","6":"5.250","7":"17.98","8":"0","9":"0","10":"3","11":"4","12":"12.87156","13":"-2.47155917","14":"-1.23808052","15":"0.4177852","16":"2.577243","17":"0.0846104847"},{"1":"10.4","2":"8","3":"460.0","4":"215","5":"3.00","6":"5.424","7":"17.82","8":"0","9":"0","10":"3","11":"4","12":"11.46134","13":"-1.06134080","14":"-0.49609511","15":"0.3313192","16":"2.670484","17":"0.0093802466"},{"1":"14.7","2":"8","3":"440.0","4":"230","5":"3.23","6":"5.345","7":"17.42","8":"0","9":"0","10":"3","11":"4","12":"10.49531","13":"4.20469366","14":"1.94844268","15":"0.3196499","16":"2.404457","17":"0.1372062704"},{"1":"32.4","2":"4","3":"78.7","4":"66","5":"4.08","6":"2.200","7":"19.47","8":"1","9":"1","10":"4","11":"1","12":"28.09153","13":"4.30846861","14":"1.82801665","15":"0.1884326","16":"2.440154","17":"0.0596826882"},{"1":"30.4","2":"4","3":"75.7","4":"52","5":"4.93","6":"1.615","7":"18.52","8":"1","9":"1","10":"4","11":"2","12":"31.61018","13":"-1.21018136","14":"-0.91355327","15":"0.7436271","16":"2.628252","17":"0.1862118803"},{"1":"33.9","2":"4","3":"71.1","4":"65","5":"4.22","6":"1.835","7":"19.90","8":"1","9":"1","10":"4","11":"1","12":"29.78035","13":"4.11964761","14":"1.80272409","15":"0.2370420","16":"2.447299","17":"0.0776675893"},{"1":"21.5","2":"4","3":"120.1","4":"97","5":"3.70","6":"2.465","7":"20.01","8":"1","9":"0","10":"3","11":"1","12":"23.68876","13":"-2.18875642","14":"-1.19660668","15":"0.5112002","16":"2.584681","17":"0.1151912330"},{"1":"15.5","2":"8","3":"318.0","4":"150","5":"2.76","6":"3.520","7":"16.87","8":"0","9":"0","10":"3","11":"2","12":"17.65894","13":"-2.15894230","14":"-0.97945139","15":"0.2901684","16":"2.619212","17":"0.0301659656"},{"1":"15.2","2":"8","3":"304.0","4":"150","5":"3.15","6":"3.435","7":"17.30","8":"0","9":"0","10":"3","11":"2","12":"18.40152","13":"-3.20151903","14":"-1.36825383","15":"0.2001329","16":"2.552090","17":"0.0360321808"},{"1":"13.3","2":"8","3":"350.0","4":"245","5":"3.73","6":"3.840","7":"15.41","8":"0","9":"0","10":"3","11":"4","12":"12.66700","13":"0.63299956","14":"0.32092764","15":"0.4316294","16":"2.680654","17":"0.0060165887"},{"1":"19.2","2":"8","3":"400.0","4":"175","5":"3.08","6":"3.845","7":"17.05","8":"0","9":"0","10":"3","11":"2","12":"16.48312","13":"2.71687912","14":"1.17976482","15":"0.2252015","16":"2.587624","17":"0.0311193146"},{"1":"27.3","2":"4","3":"79.0","4":"66","5":"4.08","6":"1.935","7":"18.90","8":"1","9":"1","10":"4","11":"1","12":"28.59699","13":"-1.29699092","14":"-0.54353299","15":"0.1681192","16":"2.666970","17":"0.0045926650"},{"1":"26.0","2":"4","3":"120.3","4":"91","5":"4.43","6":"2.140","7":"16.70","8":"0","9":"1","10":"5","11":"2","12":"25.89156","13":"0.10843504","14":"0.07460193","15":"0.6913416","16":"2.687555","17":"0.0009588956"},{"1":"30.4","2":"4","3":"95.1","4":"113","5":"3.77","6":"1.513","7":"16.90","8":"1","9":"1","10":"5","11":"2","12":"28.69755","13":"1.70245337","14":"0.91910844","15":"0.4987482","16":"2.627515","17":"0.0646569950"},{"1":"15.8","2":"8","3":"351.0","4":"264","5":"4.22","6":"3.170","7":"14.50","8":"0","9":"1","10":"5","11":"4","12":"18.04311","13":"-2.24310900","14":"-1.59007052","15":"0.7092585","16":"2.502725","17":"0.4744461980"},{"1":"19.7","2":"6","3":"145.0","4":"175","5":"3.62","6":"2.770","7":"15.50","8":"0","9":"1","10":"5","11":"6","12":"19.60185","13":"0.09814599","14":"0.05127650","15":"0.4647614","16":"2.687763","17":"0.0001756208"},{"1":"15.0","2":"8","3":"301.0","4":"335","5":"3.54","6":"3.570","7":"14.60","8":"0","9":"1","10":"5","11":"8","12":"14.66593","13":"0.33407460","14":"0.22528182","15":"0.6787274","16":"2.684357","17":"0.0082476588"},{"1":"21.4","2":"4","3":"121.0","4":"109","5":"4.11","6":"2.780","7":"18.60","8":"1","9":"1","10":"4","11":"2","12":"24.25188","13":"-2.85188296","14":"-1.30899687","15":"0.3065340","16":"2.563882","17":"0.0582622492"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
glance(reg)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["r.squared"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["adj.r.squared"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["sigma"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["statistic"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["p.value"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["df"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["logLik"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["AIC"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["BIC"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["deviance"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["df.residual"],"name":[11],"type":["int"],"align":["right"]},{"label":["nobs"],"name":[12],"type":["int"],"align":["right"]}],"data":[{"1":"0.8845064","2":"0.811563","3":"2.616258","4":"12.12594","5":"1.764049e-06","6":"12","7":"-67.84112","8":"163.6822","9":"184.2025","10":"130.0513","11":"19","12":"32","_row":"value"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

</br>

## Validando as suposições

</br>

O modelo de regressão linear depende de 6 suposições:

1. O modelo de regressão é linear nos parâmetros

2. A amostragem é aleatória
  + independente
  + identicamente distribuída
  
3. Existe variação amostral no regressor
  + os regressores apresentam variação amostral
  + não há relação linear perfeita entre os regressores

4. A média condicional do erro é zero $\Rightarrow E(\varepsilon|x_i) = 0$
  + o valor do erro não pode depender do valor de nenhuma variável
  + existe intercepto
  + $x_i$ é exógeno
  + ausência de correlação entre o termo de erro aleatório e as variáveis independentes

5. Homocedasticidade $\Rightarrow Var(\varepsilon|x) = \sigma^2$
  + o termo de erro aleatório tem a mesma variância dado quaisquer conjunto de valores para os regressores
  
6. O termo de erro aleatório não observável, $\varepsilon$, é:
  + independente dos regressores $x_i$
  + normalmente distribuído, com média zero e variância $\sigma^2_\varepsilon$ $\Rightarrow ~ \sim N(0;\sigma^2_\varepsilon)$

</br>

Algumas suposições são validadas apenas olhando para o modelo escolhido ou para a amostra, como as suposições 1 a 3. Outras, como a 4, são validadas por meio da argumentação (a 4 exige uma validação da exogeneidade das variáveis independentes do modelo). Outras, como é o caso das suposições 5 e 6, são validadas por meio de testes com o modelo. Estudaremos agora como realizar esses testes no R de maneira simples.

</br>

### Homocedasticidade

</br>

Durante a matéria de econometria, nos acostumamos a usar o teste de white para testar a homodasticidade do modelo. Contudo, um teste mais utilizado e de mais fácil acesso no R é o teste de breusch-pagan. No final o resultado é o mesmo: o teste consiste em um teste de hipótese em que Ho é a homocedasticidade e Ha é a heterocedasticidade. Caso o p-valor do teste seja menor do que o nível de significância escolhido, a hipótese nula é rejeitada e o teste passa a indicar a heterocedasticidade do modelo.

A função abaixo vem do pacote "olsrr", que possui diversos testes para o modelo de regressão linear por MQO.


```r
ols_test_breusch_pagan(reg)
```

```
## 
##  Breusch Pagan Test for Heteroskedasticity
##  -----------------------------------------
##  Ho: the variance is constant            
##  Ha: the variance is not constant        
## 
##              Data               
##  -------------------------------
##  Response : mpg 
##  Variables: fitted values of mpg 
## 
##         Test Summary         
##  ----------------------------
##  DF            =    1 
##  Chi2          =    0.6807846 
##  Prob > Chi2   =    0.4093167
```

No caso desse exemplo o p-valor é 0.4093, maior do que qualquer nível de significância racional. Dessa forma, é possível validar a quinta suposição do modelo de regressão linear.

</br>

### Normalidade dos resíduos

</br>

Assim como no teste de homocedasticidade, utilizaremos um teste de normalidade diferente do que vemos na sala de aula. Segundo [um paper do Journal of Statistical Computation and Simulation](https://www.tandfonline.com/doi/pdf/10.1080/00949655.2010.520163), que analisou a qualidade de cada teste de normalidade empiricamente, o teste jarque-bera, utilizado em sala de aula, tem performance consistentemente pior ao que usaremos no R, o teste shapiro-wilks. Além de menos consistente, a interface do teste JB no R é menos consistente com o tidyverse do que a interface do teste SW. Enquanto o SW aceita uma especificação de modelo (reg), o JB aceita apenas um vetor contendo os resíduos do modelo, sendo menos prático.

Contudo, indicarei a forma de realizar o teste JB no R também, apesar de não indicar.

O teste SW também é proveniente do pacote "olsrr", enquanto o teste JB vem do pacote "tseries".

Assim como no teste de heterocedasticidade, o teste de normalidade é composto por um teste de hipóteses, onde Ho é a normalidade da distribuição e Ha é a não normalidade da distribuição. Um p-valor abaixo do nível de significância indica a não normalidade da distribuição, enquanto um p-valor alto indica a normalidade da distribuição.


```r
ols_test_normality(reg) # Shapiro-Wilk test
```

```
## -----------------------------------------------
##        Test             Statistic       pvalue  
## -----------------------------------------------
## Shapiro-Wilk              0.9503         0.1472 
## Kolmogorov-Smirnov        0.1255         0.6490 
## Cramer-von Mises            2            0.0000 
## Anderson-Darling          0.4316         0.2874 
## -----------------------------------------------
```

```r
jarque.bera.test(reg$residuals) # Jarque-Bera test
```

```
## 
## 	Jarque Bera Test
## 
## data:  reg$residuals
## X-squared = 1.4055, df = 2, p-value = 0.4952
```

Dessa forma, quanto no teste JB quanto no SW é possível observar que essa distribuição pode ser considerada normal. 

Interessante notar que o comando ols_test_normality() retorna o resultado de mais de um teste de normalidade. O melhor continua sendo o SW, mas mostra a solidez desse pacote na análise de dados.

</br>

## Visualização do modelo

</br>

Algumas formas de visualização são muito convenientes para a análise do modelo de regressão linear. Claro que não existem limites, existem diversas visualizações extremamente úteis, mas aqui passarei pelas principais visualizações a serem utilizadas no processo de análise de dados.

</br>

### Regressão linear simples

</br>

Modelos de regressão linear simples são bons para visualizarmos a intuição do modelo de regressão linear. Essa análise é dificultada em modelos mais complexos pela existência de mais de duas dimensões no modelo. 

Supondo que iremos realizar uma regressão que explica mpg por hp, podemos visualizar esse modelo diretamente no ggplot utilizando geom_smooth():


```r
ggplot(df, aes(hp, mpg)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE)
```

```
## `geom_smooth()` using formula 'y ~ x'
```

![](capacitacao_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

O método indica ao R que o modelo a ser usado será o de regressão linear (lm) e se = FALSE tira o intervalo de confiança da visualização.

</br> 

### Distribuição das amostras

</br>

Para testarmos se as amostras são de fato aleatórias é conveniente criarmos um identificador de cada amostra. Além disso, é conveniente realizar essa análise com todas as variáveis ao mesmo tempo, contando com os resíduos e as variáveis explicativas. Dessa forma, terminamos com um diagrama que indica se houve qualquer parcialidade na retirada da amostra.

Portanto, buscamos gráficos aleatórios, sem tendência alguma. Qualquer tendência pode ser problemática.

No exemplo, extraímos as informações que queríamos do modelo com augment(), que além das observações inclui o valores previsto e o resíduo de cada observação. Retiramos os últimos dados porque não são tão relevantes nessa análise, e por último inserimos um índice de identificação de cada observação.


```r
observations <- 
  reg %>% 
  augment %>%  
  select(-c(.hat:.cooksd)) %>% 
  mutate(id = seq_along(mpg))
```

Para a visualização é bom utilizar um pequeno hack. Seria muito conveniente fazer essa análise por meio de facetas, sem ter que analisar variável por variável. Porém, facetas funcionam dentro de uma mesma variável, como resolver?

A solução, apesar de simples, é contraintuitiva. Podemos deixar a tabela não tidy utilizando pivot longer (ao redor da variável ID), resultando em uma coluna com todos os valores e outra indicando a qual variável esse valor pertece, além da coluna que indica o ID de cada observação. Com isso, podemos plotar no eixo x o ID de cada observação e no eixo y o valor das variáveis, utilizando o facet wrap para separar as variáveis. O resultado final é bastante útil:


```r
observations %>% 
  mutate_all(as.double) %>% 
  select(-c(.resid, .fitted)) %>% 
  pivot_longer(-id) %>% 
  ggplot(aes(id, value)) +
    facet_wrap(vars(name), scales = "free") +
    geom_point() +
    labs(y = "",
         title = "Checagem de amostragem aleatória",
         subtitle = "subdividido por variável")
```

![](capacitacao_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

</br>

### Distribuição dos resíduos por variável

</br>


```r
observations %>% 
  mutate_all(as.double) %>% 
  select(-c(.fitted, .resid)) %>% 
  pivot_longer(-.std.resid) %>% 
  ggplot(aes(value, .std.resid)) +
    facet_wrap(vars(name), scales = "free") +
    geom_point() 
```

![](capacitacao_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

```r
estimations <- 
  reg %>% 
  tidy(conf.int = TRUE) %>% 
  mutate(term = fct_reorder(term, estimate))

ggplot(estimations, aes(estimate, term, 
                        color = conf.low < 0 & conf.high > 0)) +
  geom_point() +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high)) +
  scale_color_manual(values = c("red", "black")) +
  theme(legend.position = "none")
```

![](capacitacao_files/figure-html/unnamed-chunk-17-2.png)<!-- -->

```r
observations %>% 
  ggplot(aes(id, .std.resid)) +
    geom_point()
```

![](capacitacao_files/figure-html/unnamed-chunk-17-3.png)<!-- -->

```r
observations %>% 
  ggplot(aes(.resid)) +
    geom_density(fill = "blue", alpha = .4) +
    labs(x = "Resíduos",
         y = "Densidade",
         title = "Distribuição dos resíduos do modelo")
```

![](capacitacao_files/figure-html/unnamed-chunk-17-4.png)<!-- -->


