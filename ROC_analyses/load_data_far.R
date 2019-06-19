# load packages
library(R.matlab)
library(tidyverse)
library(lubridate)

# load task files
data.dev081 = read.csv("~/Documents/code/sanlab/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries/events_DEV081.csv", stringsAsFactors = FALSE) %>%
  mutate(rt = ifelse(rt == 0, NA, rt),
         rating = as.integer(rating),
         craving = ifelse(condition %in% c(3,4), "craved",
                          ifelse(condition == 2, "not craved", "neutral")),
         instruction = ifelse(condition %in% c(1:3), "look", "regulate"))

data = read.csv("~/Documents/code/sanlab/DEV_scripts/fMRI/fx/multiconds/ROC/betaseries/events.csv", stringsAsFactors = FALSE) %>%
  mutate(rt = ifelse(rt == 0, NA, rt),
         rating = as.integer(rating),
         craving = ifelse(condition %in% c(3,4), "craved",
                          ifelse(condition == 2, "not craved", "neutral")),
         instruction = ifelse(condition %in% c(1:3), "look", "regulate")) %>%
  filter(wave == 1) %>%
  filter(!subjectID == "DEV081") %>%
  bind_rows(data.dev081) %>%
  group_by(subjectID, wave, run) %>%
  mutate(trial = row_number())

# load ratings
file_dir = "~/Dropbox (PfeiBer Lab)/Devaluation/Tasks/ImageSelection/output/Categorized/"
file_pattern = "DEV[0-3]{1}[0-9]{1}[1-9]{1}_ratings.csv"
file_list = list.files(file_dir, pattern = file_pattern, recursive = TRUE)

liking.ratings = data.frame()

for (file in file_list){
  temp = tryCatch(read.csv(paste0(file_dir,file), stringsAsFactors = FALSE, header = FALSE) %>%
                    mutate(file = file) %>%
                    extract(file, "subjectID", "(DEV[0-9]{3})_ratings.csv") %>%
                    rename("liking_rating" = V1,
                           "rank" = V2,
                           "image_name" = V3), error = function(e) message(file))
  liking.ratings = rbind(liking.ratings, temp)
  rm(temp)
}

# load trial key
file_dir = "~/Documents/code/sanlab/ROC/"
file_pattern = ".*scan.*txt"
file_list = list.files(file_dir, pattern = file_pattern, recursive = TRUE)

trial.key = data.frame()

for (file in file_list){
  temp = tryCatch(read.table(paste0(file_dir,file), sep = "\t", fill = TRUE, header = TRUE) %>%
                    mutate(file = file) %>%
                    extract(file, "run", "ROC_R([1-4]{1})scan.txt") %>%
                    filter(grepl("neutral|crave", stFile)) %>%
                    select(run, stFile) %>%
                    mutate(run = sprintf("run%s", run),
                           trial = row_number()), error = function(e) message(file))
  trial.key = rbind(trial.key, temp)
  rm(temp)
}

# load stimuli files
file_dir = "~/Dropbox (PfeiBer Lab)/Devaluation/Tasks/ROC/output/"
file_pattern = "DEV[0-3]{1}[0-9]{2}_1_stimuli.*.mat"
file_list = list.files(file_dir, pattern = file_pattern, recursive = TRUE)

key = data.frame()

for (file in file_list){
  temp = tryCatch(readMat(paste0(file_dir,file)) %>%
                    unlist() %>%
                    as.data.frame() %>%
                    rename("image" = ".") %>%
                    mutate(file = file,
                           image = as.character(image),
                           type = rep(c("stFile", "image_name", "category"), each = 60),
                           num = rep(1:60, 3)) %>%
                    extract(file, c("subjectID", "wave", "time_stamp"), "(DEV[0-9]{3})_([0-5]{1})_stimuli_(.*).mat") %>%
                    mutate(wave = as.integer(wave)) %>%
                    filter(!type == "category") %>%
                    spread(type, image) %>%
                    select(-num), error = function(e) message(file))
  key = rbind(key, temp)
  rm(temp)
}


# check and fix timestamps
n.files = key %>%
  select(subjectID, wave, time_stamp) %>%
  unique() %>%
  group_by(subjectID, wave) %>%
  mutate(n = row_number(),
         ntotal = n())

times = data %>% 
  select(file, subjectID) %>% 
  unique()

messedup = times %>% 
  extract(file, c("run", "run_time"), "DEV[0-9]{3}_[0-5]{1}_(run[1-4]{1})_(.*).mat") %>% 
  left_join(., n.files, by = "subjectID") %>% 
  filter(!is.na(n)) %>%
  mutate(run_time = dmy_hm(run_time),
         time_stamp = dmy_hm(time_stamp),
         earlier = time_stamp - run_time) %>%
  spread(n, time_stamp) %>% 
  filter(earlier > 0) %>% 
  select(subjectID) %>% 
  unique()

check = times %>% 
  extract(file, c("run", "run_time"), "DEV[0-9]{3}_[0-5]{1}_(run[1-4]{1})_(.*).mat") %>% 
  left_join(., n.files, by = c("subjectID", "wave")) %>% 
  mutate(run_time1 = dmy_hm(run_time),
         time_stamp1 = dmy_hm(time_stamp),
         earlier = time_stamp1 - run_time1) %>%
  mutate(pos = ifelse(subjectID %in% messedup$subjectID, "check", "")) %>%
  filter(ntotal == n | pos == "check") %>%
  mutate(keep = ifelse(pos == "check" & subjectID == "DEV052" & run == "run1" & time_stamp == "18-Oct-2018_14-04", 1,
                ifelse(pos == "check" & subjectID == "DEV052" & run == "run2" & time_stamp == "18-Oct-2018_16-13", 1,
                ifelse(pos == "check" & subjectID == "DEV052" & run == "run3" & time_stamp == "18-Oct-2018_16-13", 1,
                ifelse(pos == "check" & subjectID == "DEV052" & run == "run4" & time_stamp == "18-Oct-2018_16-13", 1,
                ifelse(pos == "check" & subjectID == "DEV055" & run == "run1" & time_stamp == "06-Feb-2019_16-11", 1,
                ifelse(pos == "check" & subjectID == "DEV055" & run == "run2" & time_stamp == "06-Feb-2019_16-11", 1,
                ifelse(pos == "check" & subjectID == "DEV055" & run == "run3" & time_stamp == "06-Feb-2019_17-58", 1,
                ifelse(pos == "check" & subjectID == "DEV055" & run == "run4" & time_stamp == "06-Feb-2019_17-58", 1,
                ifelse(pos == "check" & subjectID == "DEV064" & run == "run1" & time_stamp == "15-Jan-2019_10-12", 1,
                ifelse(pos == "check" & subjectID == "DEV064" & run == "run2" & time_stamp == "15-Jan-2019_10-22", 1,
                ifelse(pos == "check" & subjectID == "DEV064" & run == "run3" & time_stamp == "15-Jan-2019_10-22", 1,
                ifelse(pos == "check" & subjectID == "DEV064" & run == "run4" & time_stamp == "15-Jan-2019_10-22", 1, 
                ifelse(pos == "", 1, 0)))))))))))))) %>%
  arrange(subjectID) %>%
  filter(keep == 1) %>%
  select(subjectID, wave, run, time_stamp)

# fix DEV017 --> selected fast food category twice, rated all images twice --> take average ratings and remove duplicates
dev017 = liking.ratings %>% 
  filter(subjectID == "DEV017") %>%
  group_by(image_name) %>%
  mutate(liking_rating = mean(liking_rating, na.rm = TRUE)) %>%
  filter(!rank == 3) 

liking.ratings.fixed = liking.ratings %>%
  filter(!subjectID == "DEV017") %>%
  bind_rows(dev017)

# merge data frames
keys = trial.key %>%
  left_join(., check) %>%
  left_join(., key)

data.all = data %>%
  left_join(., keys) %>%
  left_join(., liking.ratings.fixed) %>%
  arrange(subjectID)
  
# check number of trials
data.all %>% 
  group_by(subjectID, wave, run) %>% 
  summarize(n = n())
