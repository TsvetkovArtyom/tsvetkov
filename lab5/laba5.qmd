# Цветков Артём Бисо-03-20

# Информационно-аналитические технологии поиска угроз информационной безопасности

## Лабораторная работа №5

## Цель работы

1.  Развить практические навыки использования языка программирования R
    для обработки данных
2.  Закрепить знания базовых типов данных языка R
3.  Развить пркатические навыки использования функций обработки данных
    пакета dplyr – функции select(), filter(), mutate(), arrange(),
    group_by()
    
## Ход работы

1.Импортируйте данные.

```{r}
library(dplyr)
dataset <- read.csv("C:/Users/lalka/OneDrive/Desktop/mir.cvs/mir.csv-01.csv")
```

```{r}
dataset1 <- read.csv(file="C:/Users/lalka/OneDrive/Desktop/mir.cvs/mir.csv-01.csv",nrows=167)
```

```{r}
dataset2 <- read.csv(file="C:/Users/lalka/OneDrive/Desktop/mir.cvs/mir.csv-01.csv",skip=169)
```

2.Привести датасеты в вид "аккуратных данных", преобразовать типы столбцов всоответствии с типом данных

```{r}
dataset2 <- dataset2 %>% mutate_at(vars(Station.MAC, BSSID, Probed.ESSIDs), trimws) %>% mutate_at(vars(Station.MAC, BSSID, Probed.ESSIDs), na_if, "")
```

3.Просмотрите общую структуру данных с помощью функции glimpse()

```{r}
dataset1 %>% glimpse()
```

```{r}
dataset2 %>% glimpse()
```
### Анализ

1.Определить небезопасные точки доступа (без шифрования – OPN)

```{r}
dataset1 %>% filter(Privacy == ' OPN')
```

2.Определить производителя для каждого обнаруженного устройства

-   00:03:7A Taiyo Yuden Co., Ltd.

-   00:03:7F Atheros Communications, Inc.

-   00:25:00 Apple, Inc.

-   00:26:99 Cisco Systems, Inc

-   E0:D9:E3 Eltex Enterprise Ltd.

-   E8:28:C1 Eltex Enterprise Ltd.

3.Выявить устройства, использующие последнюю версию протокола шифрования WPA3, и названия точек доступа, реализованных на этих устройствах

```{r}
dataset1 %>% filter(Privacy == " WPA3 WPA2")
```

4.Отсортировать точки доступа по интервалу времени, в течение которого они находились на связи, по убыванию.

```{r}
a <- difftime(dataset1$Last.time.seen, dataset1$First.time.seen, units = "secs")
time1 <- dataset1
time1 <- cbind(time1,a)
time1 %>% select(BSSID,ESSID, a) %>% arrange(desc(a))
```

5.Обнаружить топ-10 самых быстрых точек доступа.

```{r}
dataset1 %>% 
  select(BSSID,ESSID,Speed) %>% 
  arrange(desc(Speed)) %>% 
  head(10)
```

6.Отсортировать точки доступа по частоте отправки запросов (beacons) в единицу времени по их убыванию.

```{r}
dataset1 %>% 
  select(BSSID,ESSID,X..beacons) %>% 
  arrange(desc(X..beacons))
```

### Данные клиентов

1.Определить производителя для каждого обнаруженного устройства

```{r}
dataset2 %>% glimpse()
```

-   00:03:7F Atheros Communications, Inc.

-   00:0D:97 Hitachi Energy USA Inc.

-   00:23:EB Cisco Systems, Inc

-   00:25:00 Apple, Inc.

-   00:26:99 Cisco Systems, Inc

-   08:3A:2F Guangzhou Juan Intelligent Tech Joint Stock Co.,Ltd

-   0C:80:63 Tp-Link Technologies Co.,Ltd.

-   DC:09:4C Huawei Technologies Co.,Ltd

-   E0:D9:E3 Eltex Enterprise Ltd.

-   E8:28:C1 Eltex Enterprise Ltd.

2.Обнаружить устройства, которые НЕ рандомизируют свой MAC адрес

```{r}
dataset2 %>% 
  select(Station.MAC) %>% 
  filter(!Station.MAC %in% 
           grep(":",dataset2$Station.MAC, value = TRUE))
```

3.Кластеризовать запросы от устройств к точкам доступа по их именам.Определить время появления устройства в зоне радиовидимости и времявыхода его из нее

```{r}
dataset2 %>% 
  filter(!is.na(Probed.ESSIDs)) %>% 
  group_by(Station.MAC, Probed.ESSIDs) %>%  
  summarise("first" = min(First.time.seen), "last" = max(Last.time.seen), Power)
```

4.Оценить стабильность уровня сигнала внури кластера во времени. Выявить наиболее стабильный кластер

```{r}
dataset2 %>% 
  filter(!is.na(Probed.ESSIDs),!is.na(Power) ) %>% 
  group_by(Station.MAC) %>%  
  summarise("first" = min(First.time.seen), "last" = max(Last.time.seen), Power) %>% 
  arrange(desc(Power)) %>% 
  head(1)
```
