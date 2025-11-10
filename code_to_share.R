rm(list = ls())

#Change to the appropriate working directory here:
setwd('set/your/wd')

#loading packages
library(dplyr)
library(data.table)
library(stats)


#Load the dataset
df<-fread('data_to_share.csv',sep=',')



#A review is classified as fake if either it was detected by the Jaccard similarity method or by the intersection of reviews of suspicious products:
df$is_review_fake<-pmax(df$is_review_fake_cycles,df$is_review_fake_jaccard)

#filtering only positive reviews:
df<-df %>% filter(numb_stars>=4)


#Filtering observations with no variation in the dependent variable (important when incorporating fixed effects).
non_varying_asins <- df %>%
  group_by(asin) %>%
  summarize(variation = n_distinct(is_review_fake)) %>%
  filter(variation == 1) %>%
  pull(asin)
filtered_data=df[!df$asin %in% non_varying_asins,]

#model specifications
model1 <- glm(is_review_fake ~  score + score_2+dist_1st_rev+trend, data = df,family = binomial)
model2 <- glm(is_review_fake ~  score + score_2+dist_1st_rev+  predict_review_text_and_header+review_helpful+verified_purchase+has_images_or_videos+trend, data = df,family = binomial)
model3 <- glm(is_review_fake ~  score + score_2+score_3+score_4+dist_1st_rev+predict_review_text_and_header+  review_helpful+verified_purchase+has_images_or_videos+trend, data = df,family = binomial)
model4 <- glm(is_review_fake ~  score + score_2+dist_1st_rev+predict_review_text_and_header+review_helpful+verified_purchase+has_images_or_videos+factor(asin), data = filtered_data,family = binomial)
model5 <- glm(is_review_fake ~  score + score_2+score_3+score_4+dist_1st_rev+predict_review_text_and_header+review_helpful+verified_purchase+has_images_or_videos+factor(asin), data = filtered_data,family = binomial)
 

 

#===============Ading Mcfaden pseudo R^2=======
# List of models
models_list <- list(model1, model2, model3, model4, model5)
spec_names <- c("Specification 1", "Specification 2", "Specification 3", "Specification 4", "Specification 5")

# Compute McFadden's Pseudo R² for each model
pseudo_r2_list <- sapply(models_list, function(model) {
  data_used <- model$data  # Get the data used in the model
  dependent_var <- as.character(formula(model)[[2]])
  null_model <- glm(as.formula(paste(dependent_var, "~ 1")), data = data_used, family = binomial)
  pseudo_r2 <- 1 - (logLik(model) / logLik(null_model))
  return(as.numeric(pseudo_r2))
})

# Print Pseudo R² values
pseudo_r2_list
#=============

fe_row <- c("ASIN Fixed Effects", "No", "No", "No", "Yes", "Yes")
r2_row <- c("McFadden Pseudo R\u00b2", sprintf("%.3f", pseudo_r2_list))


stargazer(model1, model2, model3, model4, model5,type = "text", title = "Regression Results",  omit = "factor\\(asin\\)",
          omit.labels = "ASIN Fixed Effects",
          add.lines = list(fe_row, r2_row)
)




