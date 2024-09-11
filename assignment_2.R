#this line lists all the csv files found in Data
list.files(path = 'Data/', pattern = "\\.csv$")

#this line stores the list under csv_files
csv_files <- list.files(path = 'Data/', pattern = "\\.csv$")

#this line finds out how many files fit that description
length(csv_files)

#this line opens and stores wingspan_vs_mass file
read.csv('Data/wingspan_vs_mass.csv')
df <- read.csv('Data/wingspan_vs_mass.csv')

#this line shows the first five lines of the data
head(df, n = 5)

#this line gives any files that begin with a lowercase b in Data
list.files(path = 'Data/', recursive = TRUE, pattern = "^b", full.names = TRUE)
b_files <- list.files(path = 'Data/', recursive = TRUE, pattern = "^b", full.names = TRUE)

#this will print the top line for all the files starting with lowercase b
for (i in b_files) {
  top_line <- readLines(i, n = 1)
  print(top_line)
}

csvfiles_1 <- list.files(path = 'Data/', pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)

#this loop will print the top line for all of the csv files
for (i in csvfiles_1) {
  top_line <- readLines(i, n = 1)
  print(top_line)
}