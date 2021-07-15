#Test1: PCR
#Test2: IgGorM, IgG only, IgM only

# Libraries
#install.packages("runjags", "rjags")
library(runjags)
library(rjags)
testjags()

# Directory 
prj.dir <- ("C:\\Users\\shartn\\Documents\\Cost Harmony\\Cost WS 2021\\Trial files\\aje")

# Change working directory
#list.files(prj.dir)

# Model
source(file.path(prj.dir, "blcm_A.R"))
#other choice: "blcm_B.R"
#other choice: "blcm_C.R".R

# Data
library(tidyverse)
library(readxl)


df <- read_excel(file.path(prj.dir,'CLIA_LFIA_ELISA_final.xlsx'))

df
df2 <- df %>%
  filter(Week %in% 3, # Change week
         Ab %in% "IgG/M") %>% # Change with Ab type (IgM, IgG, IgG/M)
  select(Author, `PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  group_by(Author) %>%
  summarise_all(funs(sum)) 

print(df2)

y <- df2 %>%
  select(`PCR+/Ab+`, `PCR+/Ab-`, `PCR-/Ab+`, `PCR-/Ab-`) %>%
  as.matrix()

y

m = dim(y)[1]
n = apply(y, 1, sum)

inits1 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 100022)
inits2 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 300022)
inits3 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 500022)



# Running
results <- run.jags(model, 
                    n.chains = 3,
                    inits=list(inits1, inits2, inits3),
                    burnin = 10000,
                    sample = 110000)
print(results)

