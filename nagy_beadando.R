#############################
#Stat_prog_1 nagybeadand�   #
#                           #
#############################

#1. sz�ks�ges library-k beolvas�sa/install�l�sa:
library(ggpubr)
library(ggplot2)      #adatvizualiz�ci�
library(RColorBrewer) #ggplot sz�neinek kieg�sz��se
library(tidyverse)    #adatok lev�logat�sa
library(gridExtra)    #grafikonok �sszef�z�se
library(grid)         #grafikonok �sszef�z�se

#data.frame beolvas�sa:
rm(list = ls())
setwd("C:/Users/molna/Desktop/Egyetem/KRE/R programoz�s/")
csv <- read.csv("master.csv", check.names=FALSE, header = TRUE, sep = ",", stringsAsFactors = FALSE, encoding = "UTF-8")
#header nevek regexp-je:
newhead <- enc2native(colnames(csv))
newhead <- gsub("<[^>]+>", "", newhead)
colnames(csv) <- newhead
#rendben van-e a country v�ltoz�: (igen)
colnames(csv[1])
colnames(csv)

###########################################
#felt�r� statisztika (adatok felfedez�se) #
###########################################
#12 v�ltoz�nk van:
length(colnames(csv))
#van-e NA �rt�k�nk?:
which(is.na(csv) == TRUE)

#####################################################################################
#a. �bra: Id�sor (x tengely: �vek �s y tengely: suicides/100k pop) vonalak orsz�gok #
#####################################################################################

#vizualiz�ci�hoz sz�ks�ges adatok lev�logat�sa egy k�l�n data frame-be:
df1 <- aggregate(cbind(population, suicides_no) ~ country + year, data = csv, sum)
rate <- (df1$suicides_no/df1$population)*100000
df1 <- cbind(df1, rate)

#101 orsz�g vizualiz�ci�ja:
#legend-ek elt�vol�t�sra ker�ltek (t�l sok volt)
#sz�nez�s az �ngyilkoss�gok ar�ny�ban:
a <- ggplot(df1, aes(x=year, y=rate, group=country)) +
        geom_line(aes(col=rate)) + 
        geom_point(aes(col=rate)) +
        ggtitle("Suicide rates grouped by country from 1985 to 2016") +
        labs(y="Suicides per 100k", x="Year") +
        theme(legend.position="none") +
        scale_color_gradient(low="lightblue", high="darkblue")
a

#tidyverse package kipr�b�l�sa: (glob�lis trend!)
x_axis_labels <- min(csv$year):max(csv$year)
global_average <- (sum(as.numeric(csv$suicides_no)) / sum(as.numeric(csv$population))) * 100000
a3 <- csv %>%
        group_by(year) %>%
        summarize(population = sum(population), 
                  suicides = sum(suicides_no), 
                  suicides_per_100k = (suicides / population) * 100000) %>%
        ggplot(aes(x = year, y = suicides_per_100k)) + 
        geom_line(col = "deepskyblue3", size = 1) + 
        geom_point(col = "deepskyblue3", size = 2) + 
        geom_hline(yintercept = global_average, linetype = 2, color = "grey35", size = 1) +
        labs(title = "Global Suicides trend from 1985 - 2015",
             subtitle = "Average line value: 13.15",
             x = "Year", 
             y = "Suicides per 100k") + 
        theme(axis.text.x = element_text(angle = 75, vjust = 0.5, face = "bold", color = "black"),
              axis.text.y = element_text(color = "black", face = "bold"),
              axis.title = element_text(face="bold")) +
        scale_x_continuous(labels = x_axis_labels, breaks = x_axis_labels)
a3

#101 t�l sok volt, ez�rt a top15-�t v�logattam le:
top15_list <- tail(sort((tapply(df1$rate, df1$country, mean)), decreasing= FALSE), 15)
top15 <- unlist(dimnames(top15_list))
unique(top15)
df <- df1[df1$country %in% top15, ]
head(df)
unique(df$country)

#top 15 orsz�g vizualiz�ci�ja:
x_axis_labels <- min(df$year):max(df$year)
a2 <- ggplot(df, aes(x=year, y=rate, group=country)) +
        geom_line(aes(col=country), size = 0.72) + 
        geom_point(aes(col=country)) +
        ggtitle("Suicide rates grouped by top 25 country from 1985 to 2016") +
        labs(y="Suicides per 100k", x="Year",
             subtitle = "Average line value: 26.33") +
        theme(legend.title = element_blank()) +
        theme(legend.direction = "horizontal", legend.position = "bottom",
              axis.text.x = element_text(angle = 75, vjust = 0.5, face = "bold", color = "black"),
              axis.text.y = element_text(color = "black", face = "bold"),
              axis.title = element_text(face="bold")) +
      geom_hline(yintercept = mean(df$rate), linetype = 2, color = "grey35", size = 1) +
      scale_x_continuous(labels = x_axis_labels, breaks = x_axis_labels) +
      scale_color_manual(values = 
                           c("Guyana"="chocolate1",
                             "Austria"="cornflowerblue",
                             "Belgium"="cyan4",
                             "Japan"="darkgoldenrod1",
                             "Finland"="darkgray",
                             "Ukraine"="darkolivegreen",
                             "Estonia"="darkorange",
                             "Slovenia"="darkorchid",
                             "Kazakhstan"="darkred",
                             "Latvia"="darkseagreen4",
                             "Hungary"="darkslategray3",
                             "Belarus"="chocolate4",
                             "Sri Lanka"="darkviolet",
                             "Russian Federation"="deeppink3",
                             "Lithuania"="deepskyblue4"))

a2

#######################################################################################################
#c. �bra: Id�sor (x tengely: �vek �s y tengely: suicides/100k pop) vonalak orsz�gok CSAK N�K (top 11) #
#######################################################################################################

#vizualiz�ci�hoz sz�ks�ges adatok lev�logat�sa egy k�l�n data frame-be:
df2 <- aggregate(cbind(population, suicides_no) ~ country + year + sex, data = csv, sum)
#n�k lev�logat�sa:
female_df <- df2[which(df2$sex=='female'),]
head(female_df)
#check:
unique(female_df$sex)
#�ngyilkoss�gi r�ta kisz�m�t�sa n�kre:
rate_female <- (female_df$suicides_no/female_df$population)*100000
female_df <- cbind(female_df, rate_female)
head(female_df)
#top 11 orsz�g a n�i �ngyilkoss�gi r�ta alapj�n:
top11_f_list <- tail(sort((tapply(female_df$rate_female, female_df$country, mean)), decreasing= FALSE), 11)
top11_f <- unlist(dimnames(top11_f_list))
unique(top11_f)
female_df_11 <- female_df[female_df$country %in% top11_f, ]
head(female_df_11)
unique(female_df_11$country)

#top 11 orsz�g a n�i �ngyilkoss�gi adatok vizualiz�ci�ja:
x_axis_labels <- min(female_df_11$year):max(female_df_11$year)
c <- ggplot(female_df_11, aes(x=year, y=rate_female, group=country)) +
        geom_line(aes(col=country), size = 0.72) + 
        #geom_point(aes(col=country)) +
        ggtitle("Female suicide rates grouped by country from 1985 to 2016") +
        labs(y="Female suicides per 100k", x="Year") +
        theme(legend.title = element_blank()) +
        theme(legend.direction = "horizontal", legend.position = "bottom",
              axis.text.x = element_text(angle = 75, vjust = 0.5, face = "bold", color = "black"),
              axis.text.y = element_text(color = "black", face = "bold"),
              axis.title = element_text(face="bold")) +
        scale_x_continuous(labels = x_axis_labels, breaks = x_axis_labels) +
        scale_colour_brewer(palette = "Spectral")
c

##########################################################################################################
#b. �bra: Id�sor (x tengely: �vek �s y tengely: suicides/100k pop) vonalak orsz�gok CSAK F�RFIAK (top 11)#
##########################################################################################################

#vizualiz�ci�hoz sz�ks�ges adatok lev�logat�sa, aggreg�l�sa egy k�l�n data frame-be:
male_df <- df2[which(df2$sex=='male'), ]
#check:
unique(male_df$sex)
#�ngyilkoss�gi r�ta kisz�m�t�sa f�rfiakra:
rate_male <- (male_df$suicides_no/male_df$population)*100000
#k�t dataframe �sszef�z�se:
male_df <- cbind(male_df, rate_male)
#top 11 orsz�g a f�rfi �ngyilkoss�gi r�ta alapj�n:
top11_m_list <- tail(sort((tapply(male_df$rate_male, male_df$country, mean)), decreasing= FALSE), 11)
top11_m <- unlist(dimnames(top11_m_list))
unique(top11_m)
#top 11 orsz�g lev�logat�sa a f�rfi adatb�zisb�l egy �j data.frame-be:
male_df_11 <- male_df[male_df$country %in% top11_m, ]
unique(male_df_11$country)

#top 11 orsz�g a f�rfi �ngyilkoss�gi adatok vizualiz�ci�ja:
x_axis_labels <- min(male_df_11$year):max(male_df_11$year) #�vek lev�logat�sa
b <- ggplot(male_df_11, aes(x=year, y=rate_male, group=country)) +
        geom_line(aes(col=country), size = 0.72) + 
        geom_point(aes(col=country)) +
        ggtitle("Male suicide rates grouped by country from 1985 to 2016") +
        labs(y="Male suicides per 100k", x="Year") +
        theme(legend.title = element_blank()) +
        theme(legend.direction = "horizontal", legend.position = "bottom",
              axis.text.x = element_text(angle = 75, vjust = 0.5, face = "bold", color = "black"),
              axis.text.y = element_text(color = "black", face = "bold"),
              axis.title = element_text(face="bold")) +
        scale_x_continuous(labels = x_axis_labels, breaks = x_axis_labels) +
        scale_colour_brewer(palette = "Spectral")
b

################################################################################################
#d. �bra: Id�sor (x tengely: �vek �s y tengely: suicides/100k pop) vonalak gener�ci�k (top11)  #
################################################################################################

#vizualiz�ci�hoz sz�ks�ges adatok lev�logat�sa, aggreg�l�sa egy k�l�n data frame-be:
df3 <- aggregate(cbind(population, suicides_no) ~ year + generation, data = csv, sum)
unique(df3$generation)
#gener�ci�kra vonatkoz� �ngyilkoss�gi r�ta kisz�m�t�sa:
rate_gen <- (df3$suicides_no/df3$population)*100000
#k�t dataframe �sszef�z�se:
df3 <- cbind(df3, rate_gen)

#�ngyilkoss�gi adatok vizualiz�ci�ja gener�ci�nk�nt:
x_axis_labels <- min(df3$year):max(df3$year) #�vek lev�logat�sa
d <- ggplot(df3, aes(x=year, y=rate_gen, group=generation)) +
        geom_line(aes(col=generation), size = 0.72) + 
        geom_point(aes(col=generation), size = 2) +
        ggtitle("Suicide rates grouped by generation from 1985 to 2016") +
        labs(y="Suicides per 100k", x="Year",
             subtitle = "Average line value: 13.97") +
        theme(legend.title = element_blank()) +
        theme(legend.direction = "horizontal", legend.position = "bottom",
              axis.text.x = element_text(angle = 75, vjust = 0.5, face = "bold", color = "black"),
              axis.text.y = element_text(color = "black", face = "bold"),
              axis.title = element_text(face="bold")) +
        scale_x_continuous(labels = x_axis_labels, breaks = x_axis_labels) +
        scale_colour_brewer(palette = "Spectral") +
        geom_text(data = df3, label= round(df3$rate_gen, 1), size = 3, check_overlap = TRUE,
                  colour="black")+
        geom_hline(yintercept = mean(df3$rate_gen), linetype = 2, color = "grey35", size = 1)
d

#######################################################################################################################
#e. �bra: (x tengely: orsz�gok (csak a 6 legnagyobb �ngyilk. ar�ny�) - y tengely: suicides/100k pop - csoportok: �vek #
#######################################################################################################################

#top 6 orsz�g az �ngyilkoss�gi r�ta alapj�n:
top6_list <- tail(sort((tapply(df1$rate, df1$country, mean)), decreasing= FALSE), 6)
top6 <- unlist(dimnames(top6_list))
unique(top6)
df1_6 <- df1[df1$country %in% top6, ]
head(df1_6)
unique(df1_6$country)


###############################################################################################################################
#f. �bra:  (x tengely: orsz�gok (csak a 6 legnagyobb �ngyilk. ar�ny�) - y tengely: suicides/100k pop - csoportok: gener�ci�k) #
###############################################################################################################################

#vizualiz�ci�hoz sz�ks�ges adatok lev�logat�sa �s aggreg�l�sa egy k�l�n data frame-be:
df4 <- aggregate(cbind(population, suicides_no) ~ country  + generation, data = csv, sum)
#�ngyilkoss�gi r�ta kisz�m�t�sa a lev�logatott adatokb�l:
ratedf4 <- (df4$suicides_no/df4$population)*100000
#vektor dataframe-hez f�z�se:
df4 <- cbind(df4, ratedf4)

#a dataframe-b�l a top 6 orsz�g lev�logat�sa, az �ngyilkoss�gi r�ta alapj�n:
top6_list2 <- tail(sort((tapply(df4$ratedf4, df4$country, mean)), decreasing=FALSE), 6)
top6_2 <- unlist(dimnames(top6_list2))
unique(top6_2)
#top 6 orsz�g lev�logat�sa az eredeti data.frame-b�l:
df2_6 <- df4[df4$country %in% top6_2, ]
unique(df2_6$country)

#gener�ci�k sorba�ll�t�sa:
df2_6$generation <- factor(df2_6$generation, 
                          ordered = T, 
                          levels = c("G.I. Generation", 
                                     "Silent",
                                     "Boomers", 
                                     "Generation X", 
                                     "Millenials", 
                                     "Generation Z"))

#top 6 orsz�g �ngyilkoss�g�nak vizualiz�ci�ja gener�ci�ra bontva:
f <- ggplot(df2_6, aes(country, ratedf4)) +   
            geom_bar(aes(fill = generation),  position="dodge", stat="identity", width=0.8, colour="black") +
            labs(title = "Suicides in top 6 country by generations from 1985 to 2016",
                 y = "Suicides per 100k",
                 x = "Country",
                 subtitle = "Average line value: 31.18") +
            theme(legend.title = element_blank(),
                  legend.direction = "horizontal", legend.position = "bottom",
                  axis.text.x = element_text(angle = 15, vjust = 0.5, face = "bold", color = "black"),
                  axis.text.y = element_text(color = "black", face = "bold"),
                  axis.title = element_text(face="bold")) +
            scale_fill_brewer(palette = "Set1") +
            #geom_text(aes(label=round(ratedf4,1)), vjust=1.6, color="black", position = position_dodge(0.9), size=1)
            geom_hline(yintercept = mean(df2_6$ratedf4), linetype = 2, color = "grey35", size = 1)
f

###########################################################################################
##########################A l�trehozott vizualiz�ci�k �sszef�z�se##########################
###########################################################################################
w1 <- grid.arrange(a3, a2, d, f, ncol=2, top= textGrob("Analyze Global Suicide Trends",gp=gpar(fontsize=20,font=3)),
             bottom="Data Source:\nhttps://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016/ ")

w2 <- w1 <- grid.arrange(a, b, c, ncol=2, top= textGrob("Analyze Global Suicide Trends",gp=gpar(fontsize=20,font=3)),
                         bottom="Data Source:\nhttps://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016/ ")

