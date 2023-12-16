# Цветков Артём Бисо-03-20

# Информационно-аналитические технологии поиска угроз информационной безопасности

## Лабораторная работа №2

## Цель работы

1.  Развить практические навыки использования языка программирования R для обработки данных
2.  Закрепить знания базовых типов данных языка R
3.  Развить пркатические навыки использования функций обработки данных пакета dplyr -- функции select(), filter(), mutate(), arrange(), group_by()

## Ход работы

```{r}
library(dplyr)
```

```{r}
library(nycflights13)
```

1.  Сколько встроенных в пакет nycflights13 датафреймов?

nycflights13:: 5 (airlines, airports, flights, planes, weather)

2.  Сколько строк в каждом датафрейме?

```{r}
library('nycflights13')
library('dplyr')
nycflights13::airlines %>% nrow()
nycflights13::airports %>% nrow()
nycflights13::flights %>% nrow()
nycflights13::planes %>% nrow()
nycflights13::weather %>% nrow()
```

3.Сколько столбцов в каждом датафрейме?

```{r}
ncol(nycflights13::airlines)
ncol(nycflights13::airports)
ncol(nycflights13::flights)
ncol(nycflights13::planes)
ncol(nycflights13::weather)
```

4.Как просмотреть примерный вид датафрейма?

```{r}
nycflights13::airlines %>% glimpse()
nycflights13::airports %>% glimpse()
nycflights13::flights %>% glimpse()
nycflights13::planes %>% glimpse()
nycflights13::weather %>% glimpse()
```

5.Сколько компаний-перевозчиков (carrier) учитывают эти наборы данных (представлено в наборах данных)?

```{r}
airlines$carrier
```

6.Сколько рейсов принял аэропорт John F Kennedy Intl в мае?

```{r}
filter(airports,name == "John F Kennedy Intl")
filter(flights,dest == "JFK",month == 5)
```

7.Какой самый северный аэропорт?

```{r}
airports %>% arrange(desc(lat)) %>% select(faa, name) %>% head(1)
```

8.Какой аэропорт самый высокогорный (находится выше всех над уровнем моря)?

```{r}
nycflights13::airports %>% arrange(desc(alt)) %>% select(name, alt) %>% top_n(1)
```

9.Какие бортовые номера у самых старых самолетов?

```{r}
planes %>% arrange(year) %>% select(tailnum, year) %>% head(3)
```

10.Какая средняя температура воздуха была в сентябре в аэропорту John F Kennedy Intl (в градусах Цельсия).

```{r}
nycflights13::weather %>% filter(month == 9,origin == "JFK") %>% summarise("temp" = ((temp = mean(temp,0))-32)*5/9)
```

11.Самолеты какой авиакомпании совершили больше всего вылетов в июне?

```{r}
flights %>% group_by(carrier) %>% filter(month == 6) %>% summarize(total = n()) %>% arrange(desc(total))%>% head(1)
airlines %>% select (carrier,name) %>% filter(carrier == "UA")
```

12.Самолеты какой авиакомпании задерживались чаще других в 2013 году?

```{r}
flights %>% filter(year == 2013, arr_delay > 0, dep_delay > 0) %>% group_by(carrier) %>% summarize(total = n()) %>% arrange(desc(total)) %>% head(1)
```
