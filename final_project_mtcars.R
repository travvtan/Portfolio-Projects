
##### developer vs good developer 
##### optimized manner(optimize time,memory,dynamic) and well commented 

######### install the packages required for this project
install.packages("caret")
install.packages("car")
install.packages("corrplot")
#### to check the installation 
installed.packages("ggplot2")

####### loading the packages required for the project 
library("caret")
library("car")
library("corrplot")
library("ggplot2")

###### loading the mtcars dataset for the model building and analysis
getwd() ### get working directory means where your program is storing (your r program)
mtcars<-read.csv("/Users/somilupadhyay/downloads/BRP-PROJECT-0222A/mtcars.csv")

########### check the distribution of your data 
### checking the head & tails of mtcars
head(mtcars)
tail(mtcars)
### check the summary()
summary(mtcars)

###### checking the structure of mtcars to detect the variables if datatype is appropriate or not
str(mtcars)
#### unique function is used to check the unique values in your particular column
unique(mtcars$cyl)
unique(mtcars$vs)
unique(mtcars$gear)
unique(mtcars$am)

##### checking records and fields of mtcars
dim(mtcars)

mtcars$cyl<-as.factor(mtcars$cyl)
mtcars$am<-as.factor(mtcars$am)
mtcars$gear<-as.factor(mtcars$gear)
mtcars$vs<-as.factor(mtcars$vs)

#### again check the structure of mtcars to reflect the changes 
str(mtcars)

######## separating dependent and independent variables(fields)
###### dependent variable (DV) should be linear
#### Independent variable should not have any correlation
#### DV should follow normality curve (bell curve)
#### homosedasticity means residuals should have constant variance

y<-mtcars$mpg
################################## dropping dependent variable/fields
x1<-subset(mtcars,select=c(-1))
###### negative indexing to remove the field or rows from dataframe 
x<-mtcars[,c(-1)]

x

##### dipslaying the structure of independent fields
str(x)

#################### Exploratory data analysis
##### here you will check your each independent variable w.r.t dependent variable
###### and you will select only those variables which are important and will drop others
##### normal graphics, ggplot2, lattice
plot(x$cyl,y)

plot(x$disp,y)

plot(x$gear,y)

plot(x$wt,y)

plot(x$cyl,x$disp)
ggplot(data = x,aes(x$hp,y)) +
  geom_point()

########### correlation plot which will show you if independent variable is having 
## correlation or not

############ using sapply function for separating numeric features
numeric_var<- x[sapply(x,is.numeric)]
numeric_var

str(numeric_var)


########## checking the correlation between numeric features 

mat_cor<- cor(numeric_var)

mat_cor

#### variables which have correlation more than .8(-ve or +ve ) will drop those variables
corrplot(mat_cor,method = 'shade',order = 'alphabet')

corrplot(mat_cor,method = 'ellipse',order = 'alphabet')

corrplot(mat_cor,method = 'color',order = 'alphabet')

high_rel_1<-findCorrelation(mat_cor,cutoff = 0.80)
high_rel_1

high_rel<-findCorrelation(mat_cor,cutoff = 0.71)
high_rel
############# getting the column names of the variables 
hig_rel_names<- colnames(numeric_var)[high_rel_1]
hig_rel_names

hig_rel_n<- colnames(numeric_var)[high_rel]
hig_rel_n

################ removing the variable showing high correlation

#x_new<-numeric_var[,-which(colnames(numeric_var) %in% hig_rel_names)]

x_new<- x[,-2]

x_new

dim(x_new)

x_m2<-x[,c(-2,-3,-5)]

x_m2
########################## creating model/ building model

fit_model_1<- lm(y ~.,data=x_new)

summary(fit_model_1)

######### checking coefficients and plotting it
summary(fit_model_1$coefficients)


########################## creating model/ building model

fit_model_2<- lm(y ~.,data=x_m2)

summary(fit_model_2)

######### checking coefficients and plotting it
summary(fit_model_2$coefficients)


#####################plotting the model parameters 
par(mfrow=c(2,2))
plot(fit_model_1)

fit_model_1$fitted.values

######################## extracting r squared and adjusted r squared

summary(fit_model_1)$r.squared

r1<-summary(fit_model_1)$adj.r.squared
r1<- r1*100
r1

r_v<-c(r1,75,78)

r_v

#### r2 r3 r4 

########################## same mtcars dataset to predict

new_data<-mtcars

mtcars

predicted_m<-predict(fit_model_1,new_data)




new_data$predicted<- predicted_m


new_data$predicted<-cbind(new_data,predicted_m)



new_data

#################### displaying the actual mpg and predicted mpg for model 1

mpg_c<-new_data[,c('mpg','predicted')]


plot(mpg_c)







