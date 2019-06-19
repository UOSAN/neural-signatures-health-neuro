# load packages
library(tidyverse)

# load task files
data.chives1036 = read.csv("~/Documents/code/sanlab/CHIVES_scripts/fMRI/fx/multiconds/picture/betaseries/events_CHIVES1036.csv", stringsAsFactors = FALSE) %>%
  mutate(rt = ifelse(rt == 0, NA, rt),
         rating = as.integer(rating),
         craving = ifelse(condition %in% c(3,4), "craved",
                          ifelse(condition == 2, "not craved", "neutral")),
         instruction = ifelse(condition %in% c(1:3), "look", "regulate"))

data.tidy = read.csv("~/Documents/code/sanlab/CHIVES_scripts/fMRI/fx/multiconds/picture/betaseries/events.csv", stringsAsFactors = FALSE) %>%
  mutate(rt = ifelse(rt == 0, NA, rt),
         rating = as.integer(rating),
         craving = ifelse(condition %in% c(3,4), "craved",
                          ifelse(condition == 2, "not craved", "neutral")),
         instruction = ifelse(condition %in% c(1:3), "look", "regulate")) %>%
  filter(!subjectID == "CHIVES1036") %>%
  bind_rows(data.chives1036) %>%
  mutate(run = ifelse(run == "R1", "run1", 
               ifelse(run == "R2", "run2", NA))) %>%
  group_by(subjectID, wave, run) %>%
  mutate(trial = row_number())

# check data
data.tidy %>%
  group_by(subjectID, run) %>%
  summarize(n = n()) %>%
  arrange(n)

# export
#write.csv(data.tidy, "ROC_trial_info.csv", row.names = FALSE)


