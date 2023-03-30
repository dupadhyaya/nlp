#configurations

path1 <- Sys.getenv('PATH')

#Sys.setenv(PATH = paste("C:\\rtools43\\bin", Sys.getenv("PATH"), sep=";"))


Sys.which('make')

paste(path1, collapse = ';')

strsplit(path1, split =';')
