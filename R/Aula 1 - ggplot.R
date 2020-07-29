### Lógica inicial do R

## Por que o R é diferente de VBA?

## Média no VBA

x <- 1:10

soma <- 0

for (i in 1:10){
  soma <- x[i] + soma
}

soma/length(x)

# Média no R

x <- 1:10

mean(x)

## Operações vetorizadas

x <- 1:10

# lógica no VBA/Python

for (i in 1:10) {
  x[i] = x[i] * 2
}

x

# lógica no R --> linguagens vetorizadas

x <- 1:10

x * 2

# Outro exemplo:

# Lógica VBA/Python

x <- 1:10
y <- 31:40

for (i in 1:10){
  x[i] = x[i] + y[i]
}

x

# Lógica R

x <- 1:10
y <- 31:40

x + y

## OperaçÕes com Data Frames

z <- data.frame("gustavo" = 1:10,
                "brunao" = 31:40)

sapply(z, mean)


###########################################################


# install.packages('tidyverse')
# install.packages('gapminder')
# install.packages('ggthemes')

library(gapminder)
library(tidyverse)
library(ggthemes)

gap <- filter(gapminder, year == 1997)

ggplot(data = gap) +
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp))

ggplot(data = gap) +
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp, color = continent))

ggplot(data = gap) +
  geom_point(mapping = aes(x = gdpPercap, y = lifeExp, 
                           color = continent, size = pop)) +
  scale_x_log10()

ggplot(data = gap) +
  geom_text(mapping = aes(x = gdpPercap, y = lifeExp, 
                          color = continent, size = pop,
                          label = country)) +
  scale_x_log10()


ggplot(data = gap) +
  geom_text(mapping = aes(x = gdpPercap, y = lifeExp, 
                          color = continent, size = pop,
                          label = country)) +
  scale_x_log10()

ggplot(data = gap, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(mapping = aes(color = continent, size = pop)) +
  scale_x_log10() +
  geom_smooth(se = FALSE, method = lm, mapping = aes(color = continent))

ggplot(data = gap, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(mapping = aes(color = continent, size = pop)) +
  scale_x_log10() +
  geom_smooth(se = FALSE, method = lm, mapping = aes(group = continent), color = "black")


ggplot(data = gap, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(mapping = aes(color = continent, size = pop)) +
  scale_x_log10() +
  geom_smooth(se = FALSE, method = lm, mapping = aes(color = continent)) +
  facet_wrap(vars(continent), scales = "free")


ggplot(data = gap, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(mapping = aes(color = continent, size = pop)) +
  scale_x_log10() +
  geom_smooth(se = FALSE, method = lm, mapping = aes(group = continent), color = "black") +
  theme_bw()


ggplot(data = gap, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(mapping = aes(color = continent, size = pop)) +
  scale_x_log10() +
  geom_smooth(se = FALSE, method = lm, mapping = aes(color = continent)) +
  facet_wrap(vars(continent), scales = "free") +
  theme_stata()

