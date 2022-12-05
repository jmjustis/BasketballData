library(tidyverse)

salaryDataset <- read_csv("C:\\Users\\mistr\\Downloads\\Player_Salary.csv")

view(salaryDataset)

salary = salaryDataset %>% group_by(namePlayer)
salary <- salary %>% summarise(value = sum(value))
avgSalary = salaryDataset %>% group_by(namePlayer)
avgSalary <- avgSalary %>% summarise(value = mean(value))

view(salary)

playerDataset <- read_csv("C:\\Users\\mistr\\Downloads\\Player_Attributes2.csv")

colnames(playerDataset)[2] = "namePlayer"

view(playerDataset)

statsSalary <- merge(salary, playerDataset, by = "namePlayer")
statsSalary <- merge(statsSalary, avgSalary, by = "namePlayer")

statsSalary$PRA <- statsSalary$PTS + statsSalary$AST + statsSalary$REB
colnames(statsSalary)[2] = "salary"
colnames(statsSalary)[10] = "avgSalary"

ggplot(statsSalary, aes(x = salary, y = PRA)) + geom_point() + ggtitle("Points + Rebounds + Assists vs Total Salary")

ggplot(statsSalary, aes(x = avgSalary, y = PRA)) + geom_point() + ggtitle("Points + Rebounds + Assists vs Average Salary")



