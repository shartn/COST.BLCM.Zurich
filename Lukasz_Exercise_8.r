library(readxl)
library(questionr)


#install.packages("questionr")
#install.packages("epitools")
#install.packages("oddsratio")

library(oddsratio)

prj.dir <- getwd()
df <- read_excel(file.path(prj.dir,'echinococcus.xlsx'))

#outcomes ELISA EgPCR EmPCR Egp01 Emp01
#sex   age    Taenia01

#outcomes <- c('ELISA', 'EgPCR', 'EmPCR', 'Egp01', 'Emp01')
outcomes <- c('Egp01', 'EgPCR','ELISA')

df[["sex"]] <- as.factor(df[["sex"]])
df[["age"]] <- as.numeric(df[["age"]])
df[["Taenia01"]] <- as.factor(df[["Taenia01"]])

for( outcome in outcomes)
{
  df[[outcome]] <- as.factor(df[[outcome]])
}

summary(df)
tmp <- df[,outcomes]
for( outcome in outcomes)
{
  tmp[[outcome]] <- as.numeric(tmp[[outcome]])
}

cor(tmp, method = "spearman")



#outcome <- 'ELISA'
for( outcome in outcomes)
{
  print(outcome)
  df[['outcome']] <- as.factor(df[[outcome]])
  model <- glm(outcome~sex+age+Taenia01, data = df, family = binomial(link = "logit"))
  print(summary(model))
  #exp(summary(m)$coefficients["DSH",1] + 
  #+     qnorm(c(0.025,0.5,0.975)) * summary(m)$coefficients["DSH",2])
  print(or_glm(df, model, incr = list(sex = 1, age = 1, Taenia01 = 1)))
}

#model, slopes
df_short = df[,c('Egp01', 'EgPCR','ELISA','sex', 'age', 'Taenia01')]
data_matrix <- as.matrix(df_short)
n.rows <- NROW(data_matrix)
n.cols <- NCOL(data_matrix)
data <- as.numeric(data_matrix)
m.short <- structure(data,
                  .Dim = c(n.rows, n.cols), 
                  .Dimnames = list(NULL, names(df_short)))

ones <- rep(1, n.rows)

inits1 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 100022)
inits2 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 300022)
inits3 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 500022)

# run the model - equivalent to the longer scripts:
               
N = n.rows          
results_cov <- run.jags('model1_ex_8_cov.bug', data=list(N=N, m.short=m.short, ones=ones), inits=list(inits1, inits2, inits3), 
                            monitor=c('prc','c1','c2','c3','s1','s2','s3',
                                      'deviance','dic',
                                      'covs12','covs13','covs23','covc12','covc13','covc23',
                                      'intercept', 'slope_sex', 'slope_age', 'slope_taenia'
                                      ))

results_cov
summary(results_cov)

exp(results_cov$summaries[c("intercept","slope_sex","slope_age", "slope_taenia"),"Median"])


#org dbeta

