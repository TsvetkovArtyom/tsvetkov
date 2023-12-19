# Цветков Артём Бисо-03-20

# Информационно-аналитические технологии поиска угроз информационной безопасности

## Лабораторная работа №4

## Цель работы

1.  Развить практические навыки использования языка программирования R
    для обработки данных
2.  Закрепить знания базовых типов данных языка R
3.  Развить пркатические навыки использования функций обработки данных
    пакета dplyr – функции select(), filter(), mutate(), arrange(),
    group_by()
    
## Ход работы

```{r}
library(dplyr)
```

1.Импорт данных из файлов dns.log и header.csv

```{r}
library(tidyverse)
library(dplyr)

data = read.csv("dns.log", header = FALSE, sep="\t", encoding = "UTF-8")
```
2.Добавьте пропущенные данные о структуре данных (назначении столбцов)

```{r}
header = read.csv("header.csv", encoding = "UTF-8", skip = 1, header = FALSE, sep = ',')$V1
colnames(data) = header
```

3.  Преобразуйте данные в столбцах в нужный формат

```{r}
data$ts <- as.POSIXct(data$ts, origin="1970-01-01")
```

4.Просмотрите общую структуру данных с помощью функции glimpse()

```{r}
dns %>% glimpse()
```

## Анализ


4.Сколько участников информационного обмена в сети Доброй Организации?

```{r}
number_of_praticipants <- union(unique(data$id.orig_h), unique(data$id.resp_h))
number_of_praticipants %>% length()
```

5.Какое соотношение участников обмена внутри сети и участников обращений к внешним ресурсам?

```{r}
internal_ip_pattern <- c("192.168.", "10.", "100.([6-9]|1[0-1][0-9]|12[0-7]).", "172.((1[6-9])|(2[0-9])|(3[0-1])).")
internal_ips <- number_of_praticipants[grep(paste(internal_ip_pattern, collapse = "|"), number_of_praticipants)]
internal <- sum(number_of_praticipants %in% internal_ips)
external <- length(number_of_praticipants) - internal
ratio <- internal / external
cat(ratio)
```

6.Найдите топ-10 участников сети, проявляющих наибольшую сетевую активность

```{r}
dns %>% 
  select(id.orig_h) %>% 
  group_by(id.orig_h) %>% 
  summarize(total = n()) %>% 
  arrange(desc(total)) %>% 
  head(10)
```


7.Найдите топ-10 доменов, к которым обращаются пользователи сети и соответственное количество обращений

```{r}
top10 <- dns %>% 
  select(query, qtype_name) %>% 
  filter(qtype_name == "A"|qtype_name == "AA"| qtype_name == "AAA" | qtype_name == "AAAA") %>% 
  group_by(query) %>% 
  summarize(total = n()) %>% 
  arrange(desc(total)) %>% 
  head(10)
top10
```

8.Опеределите базовые статистические характеристики (функция summary()) интервала времени между последовательным обращениями к топ-10 доменам.

```{r}
summary(diff((dns %>% 
                filter(tolower(query) %in% top10$query) 
              %>% arrange(ts))$ts))
```

9.Часто вредоносное программное обеспечение использует DNS канал в качестве канала управления, периодически отправляя запросы на подконтрольный злоумышленникам DNS сервер. По периодическим запросам на один и тот же домен можно выявить скрытый DNS канал. Есть ли такие IP адреса в исследуемом датасете?

```{r}
ip_domain_counts <- dns %>%
  group_by(ip = tolower(id.orig_h), domain = tolower(query)) %>%
  summarise(request_count = n()) %>%
  filter(request_count > 1)
unique_ips_with_periodic_requests <- unique(ip_domain_counts$ip)
unique_ips_with_periodic_requests %>% length()
unique_ips_with_periodic_requests %>% head()
```