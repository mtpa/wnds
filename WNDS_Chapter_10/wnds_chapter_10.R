# From Rules to Recommendations: The Microsoft Case (R)

# install necessary packages prior to running

library(arules)  # association rules
library(arulesViz)  # data visualization of association rules
library(RColorBrewer)  # color palettes for plots
library(car)  # companion to applied regression for recode function

# set criteria for association rule modeling for this analysis
# set support and confidence settings for input to Aprioi package
low_support_setting <- 0.01
high_support_setting <- 0.025
confidence_setting <- 0.25

# --------------------------------------------------------
# carmap is modified recode function from car package 
# to avoid conflict with recode function from arules
# car package from Fox (2014) and Fox and Weisberg (2011)
# --------------------------------------------------------
carmap <- function (var, recodes, as.factor.result = FALSE, 
    as.numeric.result = FALSE, levels) 
{
    lo <- -Inf
    hi <- Inf
    recodes <- gsub("\n|\t", " ", recodes)
    recode.list <- rev(strsplit(recodes, ";")[[1]])
    is.fac <- is.factor(var)
    if (missing(as.factor.result)) 
        as.factor.result <- is.fac
    if (is.fac) 
        var <- as.character(var)
    result <- var
    for (term in recode.list) {
        if (0 < length(grep(":", term))) {
            range <- strsplit(strsplit(term, "=")[[1]][1], ":")
            low <- eval(parse(text = range[[1]][1]))
            high <- eval(parse(text = range[[1]][2]))
            target <- eval(parse(text = strsplit(term, "=")[[1]][2]))
            result[(var >= low) & (var <= high)] <- target
        }
        else if (0 < length(grep("^else=", term))) {
            target <- eval(parse(text = strsplit(term, "=")[[1]][2]))
            result[1:length(var)] <- target
        }
        else {
            set <- eval(parse(text = strsplit(term, "=")[[1]][1]))
            target <- eval(parse(text = strsplit(term, "=")[[1]][2]))
            for (val in set) {
                if (is.na(val)) 
                  result[is.na(var)] <- target
                else result[var == val] <- target
            }
        }
    }
    if (as.factor.result) {
        result <- if (!missing(levels)) 
            factor(result, levels = levels)
        else as.factor(result)
    }
    else if (as.numeric.result && (!is.numeric(result))) {
        result.valid <- na.omit(result)
        opt <- options(warn = -1)
        result.valid <- as.numeric(result.valid)
        options(opt)
        if (!any(is.na(result.valid))) 
            result <- as.numeric(result)
    }
    result
}

# ----------------------------------
# Data preparation work
# ----------------------------------
# 
# note that the initial data file has seven initial records of data 
# that are identifiers only ... these were deleted... 
# then the records that define the attributes (A records) are placed
# in a file <000_attribute_data.csv>
# the base training data for the study are the web activity records
# (C and V records) which are in the original data files
#
# from the documentation we have the following information
#
#  Case and Vote Lines:
#  For each user, there is a case line followed by zero or more vote lines.
# 
#  For example:
#      C,"10164",10164
#      V,1123,1
#      V,1009,1
#      V,1052,1
#          Where:
#             'C' marks this as a case line,
#             '10164' is the case ID number of a user,
#             'V' marks the vote lines for this case,
#             '1123', 1009', 1052' are the attributes ID's 
#                  of Vroots that a user visited.
#                  '1' may be ignored.
# 
#    The datasets record which Vroots [web site areas] 
#    each user visited in a one-week timeframe in Feburary 1998.
#
# note that all C and V data were set as numeric data on input 
# for both training and test data files
# this was done in a plain text editor
# 
# our editing resulted in files <000_training_data.csv> and 
#    <000_test_data.csv>
# the former is used to define association rules
# the latter can be used to test predictions/recommendations 
# based upon these association rules
# 
# we detected what appear to be two miscodings in the attribute data:
# "/security." was changed to "/security" and "/msdownload." to "/msdownload"

# ----------------------------------
# User-defined functions
# ----------------------------------
# function for replacing web area numeric IDs with meaningful area names
map_microsoft <- function(x) {
carmap(var = x, 
recodes = '1287 = "/autoroute";1288 = "/library";1289 = "/masterchef";
1297 = "/centroam";1215 = "/developer";1279 = "/msgolf";1239 = "/msconsult";
1282 = "/home";1251 = "/referencesupport";1121 = "/magazine";
1083 = "/msaccesssupport";1145 = "/vfoxprosupport";1276 = "/vtestsupport";
1200 = "/benelux";1259 = "/controls";1155 = "/sidewalk";1092 = "/vfoxpro";
1004 = "/search";1057 = "/powerpoint";1140 = "/netherlands";
1198 = "/pictureit";1147 = "/msft";1005 = "/norge";1026 = "/sitebuilder";
1119 = "/corpinfo";1216 = "/vrml";1218 = "/publishersupport";
1205 = "/hardwaresupport";1269 = "/business";1031 = "/msoffice";1003 = "/kb";
1238 = "/exceldev";1118 = "/sql";1242 = "/msgarden";1171 = "/merchant";
1175 = "/msprojectsupport";1021 = "/visualc";1222 = "/msofc";
1284 = "/partner";1294 = "/bookshelf";1053 = "/visualj";1293 = "/encarta";
1167 = "/hwtest";1202 = "/advtech";1234 = "/off97cat";1054 = "/exchange";
1262 = "/chile";1074 = "/ntworkstation";1027 = "/intdev";1061 = "/promo";
1236 = "/globaldev";1212 = "/worldwide";1204 = "/msscheduleplus";
1196 = "/ie40";1188 = "/korea";1228 = "/vtest";1078 = "/ntserversupport";
1008 = "/msdownload";1052 = "/word";1091 = "/hwdev";1280 = "/music";
1247 = "/wineguide";1064 = "/activeplatform";1065 = "/java";
1133 = "/frontpagesupport";1102 = "/homeessentials";1132 = "/msmoneysupport";
1240 = "/thailand";1225 = "/piracy";1130 = "/syspro";1157 = "/win32dev";
1058 = "/referral";1076 = "/ntwkssupport";1163 = "/opentype";1187 = "/odbc";
1152 = "/rus";1139 = "/k-12";1223 = "/finland";1001 = "/support";
1043 = "/smallbiz";1165 = "/poland";1194 = "/china";1138 = "/mind";
1158 = "/imedia";1094 = "/mshome";1055 = "/kids";1277 = "/stream";
1143 = "/workshoop";1068 = "/vbscript";1229 = "/uruguay";1177 = "/events";
1014 = "/officefreestuff";1019 = "/mspowerpoint";1122 = "/mindshare";
1041 = "/workshop";1033 = "/logostore";1233 = "/vbscripts";
1211 = "/smsmgmtsupport";1199 = "/feedback";1024 = "/iis";1179 = "/colombia";
1067 = "/frontpage";1181 = "/kidssupport";1174 = "/nz";
1162 = "/infoservsupport";1046 = "/iesupport";1197 = "/sqlsupport";
1231 = "/win32devsupport";1141 = "/europe";1120 = "/switch";1112 = "/canada";
1142 = "/southafrica";1250 = "/middleeast";1214 = "/finserv";
1190 = "/repository";1098 = "/devonly";1263 = "/services";
1049 = "/supportnet";1073 = "/taiwan";1166 = "/mexico";
1226 = "/msschedplussupport";1184 = "/msexcelsupport";1025 = "/gallery";
1160 = "/visualcsupport";1156 = "/powered";1268 = "/javascript";
1220 = "/macofficesupport";1060 = "/msword";1203 = "/danmark";
1176 = "/jscript";1168 = "/salesinfo";1066 = "/musicproducer";1128 = "/msf";
1275 = "/security";1136 = "/usa";1146 = "/msp";1237 = "/devdays";
1081 = "/accessdev";1016 = "/excel";1069 = "/windowsce";
1148 = "/channel_resources";1161 = "/workssupport";1013 = "/vbasicsupport";
1116 = "/switzerland";1093 = "/vba";1249 = "/fortransupport";
1095 = "/catalog";1023 = "/spain";1192 = "/visualjsupport";1080 = "/brasil";
1050 = "/macoffice";1255 = "/msmq";1273 = "/mdn";1206 = "/select";
1230 = "/mailsupport";1172 = "/belgium";1011 = "/officedev";1009 = "/windows";
1096 = "/mspress";1235 = "/onlineeval";1070 = "/activex";1154 = "/project";
1099 = "/cio";1186 = "/college";1291 = "/news";1256 = "/sia";
1270 = "/developr";1232 = "/standards";1159 = "/transaction";
1035 = "/windowssupport";1164 = "/smsmgmt";
1077 = "/msofficesupport";1295 = "/train_cert";1056 = "/sports";
1006 = "/misc";1272 = "/softlib";1123 = "/germany";
1151 = "/mspowerpointsupport";1103 = "/works";1243 = "/usability";
1244 = "/devwire";1260 = "/trial";1258 = "/peru";1208 = "/israel";
1106 = "/cze";1124 = "/industry";1114 = "/servad";1012 = "/outlookdev";
1045 = "/netmeeting";1082 = "/access";1261 = "/diyguide";1137 = "/mscorp";
1059 = "/sverige";1037 = "/windows95";1227 = "/argentina";
1281 = "/intellimouse";1134 = "/backoffice";1044 = "/mediadev";
1028 = "/oledev";1248 = "/softimage";1085 = "/exchangesupport";
1131 = "/moneyzone";1079 = "/australia";1048 = "/publisher";
1042 = "/vstudio";1075 = "/jobs";1201 = "/hardware";1105 = "/france";
1153 = "/venezuela";1292 = "/northafrica";1015 = "/msexcel";
1290 = "/devmovies";1017 = "/products";1010 = "/vbasic";
1126 = "/mediamanager";1144 = "/devnews";1191 = "/management";
1002 = "/athome";1213 = "/corporate_solutions";1084 = "/uk";
1178 = "/msdownload";1036 = "/organizations";1257 = "/devvideos";
1180 = "/slovenija";1246 = "/gamesdev";1088 = "/outlook";
1117 = "/sidewinder";1097 = "/latam";1266 = "/licenses";
1072 = "/vinterdev";1169 = "/msproject";1107 = "/slovakia";
1089 = "/officereference";1038 = "/sbnmember";1224 = "/atec";
1086 = "/oem";1108 = "/teammanager";1007 = "/ie_intl";1252 = "/giving";
1283 = "/cinemania";1127 = "/netshow";1189 = "/internet";1110 = "/mastering";
1090 = "/gamessupport";1109 = "/technet";1040 = "/office";1150 = "/infoserv";
1195 = "/portugal";1111 = "/ssafe";1274 = "/pdc";1267 = "/caribbean";
1113 = "/security";1245 = "/ofc";1253 = "/worddev";1087 = "/proxy";
1185 = "/sna";1209 = "/turkey";1063 = "/intranet";1101 = "/oledb";
1264 = "/se_partners";1032 = "/games";1173 = "/moli";1051 = "/scheduleplus";
1278 = "/hed";1062 = "/msaccess";1020 = "/msdn";1104 = "/hk";
1071 = "/automap";1000 = "/regwiz";1135 = "/mswordsupport";1207 = "/icp";
1217 = "/ireland";1254 = "/ie3";1022 = "/truetype";1183 = "/italy";
1170 = "/mail";1241 = "/india";1149 = "/adc";1029 = "/clipgallerylive";
1221 = "/mstv";1115 = "/hun";1125 = "/imagecomposer";1039 = "/isp";
1034 = "/ie";1265 = "/ssafesupport";1271 = "/mdsn";1129 = "/ado";
1018 = "/isapi";1193 = "/offdevsupport";1219 = "/ads";1030 = "/ntserver";
1182 = "/fortran";1100 = "/education";1210 = "/snasupport"')
}


# ----------------------------------------------------------------
# user-defined function to identify antecedent items and
# consequent items lists... as many items as are given in rules
make_lists_for_all_rules <- function(association_rules) {
    # function returns items lists for antecedents and consequents
    # note. default apriori algorithm finds single-item consequents
    #       but we will return lists for consequents as well
    all_antecedent_matrix <- as(lhs(association_rules), "matrix")
    all_consequent_matrix <- as(rhs(association_rules), "matrix")    
    # create list of lists for antecedent items in each association rule  
    all_antecedent_items <- NULL
    for (irule in 1:nrow(all_antecedent_matrix)) {
        this_rule_antecedent_items <- NULL
        for (jitem in 1:ncol(all_antecedent_matrix)) {
            if (all_antecedent_matrix[irule, jitem] == 1) 
            this_rule_antecedent_items <- 
                c(this_rule_antecedent_items,
                    colnames(all_antecedent_matrix)[jitem])
         }  # end inner for-loop for gathering up items in this rule
         all_antecedent_items <- 
             rbind(all_antecedent_items,list(this_rule_antecedent_items))
     }  # end outter for-loop for rules 

    all_consequent_items <- NULL
    for (irule in 1:nrow(all_consequent_matrix)) {
        this_rule_consequent_items <- NULL
        for (jitem in 1:ncol(all_consequent_matrix)) {
            if (all_consequent_matrix[irule, jitem] == 1) 
                this_rule_consequent_items <- 
                c(this_rule_consequent_items,
                    colnames(all_consequent_matrix)[jitem])
            }  # end inner for-loop for gathering up items in this rule
            all_consequent_items <- 
                rbind(all_consequent_items,list(this_rule_consequent_items))
    }  # end outter for-loop for rules 
   
    list(all_antecedent_items,all_consequent_items)
   
    }  # end of function make.item.lists.for.all rules

# --------------------------------------------------------------------------- 
make_lists_for_single_item_antecedent_rules <- function(association_rules) {
    # function returns items lists for antecedents and consequents
    # note. default apriori algorithm finds single-item consequents
    #       but we will return lists for consequents as well
    all_antecedent_matrix <- as(lhs(association_rules), "matrix")
    all_consequent_matrix <- as(rhs(association_rules), "matrix")  
  
    # create list of lists for antecedent items in each association rule  
    indices_for_single_antecedent_rules <- NULL
    all_antecedent_items <- NULL
    for (irule in 1:nrow(all_antecedent_matrix)) {
        this_rule_antecedent_items <- NULL
        for (jitem in 1:ncol(all_antecedent_matrix)) {
            if (all_antecedent_matrix[irule, jitem] == 1) 
            this_rule_antecedent_items <- 
                c(this_rule_antecedent_items,
                    colnames(all_antecedent_matrix)[jitem])
            }  # end inner for-loop for gathering up items in this rule
        all_antecedent_items <- 
            rbind(all_antecedent_items,list(this_rule_antecedent_items))
        if (length(this_rule_antecedent_items) == 1)
            indices_for_single_antecedent_rules <- 
                c(indices_for_single_antecedent_rules, irule)
        } # end outter for-loop for rules 

    all_consequent_items <- NULL
    for (irule in 1:nrow(all_consequent_matrix)) {
        this_rule_consequent_items <- NULL
        for (jitem in 1:ncol(all_consequent_matrix)) {
            if (all_consequent_matrix[irule, jitem] == 1) 
                this_rule_consequent_items <- 
            c(this_rule_consequent_items,
                colnames(all_consequent_matrix)[jitem])
            }  # end inner for-loop for gathering up items in this rule
        all_consequent_items <- 
            rbind(all_consequent_items,list(this_rule_consequent_items))
        }  # end outter for-loop for rules 
     
    antecedent_items <- 
        all_antecedent_items[indices_for_single_antecedent_rules,]     
    consequent_items <- 
        all_consequent_items[indices_for_single_antecedent_rules,]  
    list(antecedent_items,consequent_items)
   
    }  # end of function make_lists_for_single_item_antecedent_rules
  
# ------------------------------------------ 
# user-defined function to track processing 
# used for long-running loop processing code
multiple_of_one_thousand <- function(x) {
    # return true if x is a multiple of 1000
    returnvalue <- FALSE
    if(trunc(x/1000)==(x/1000)) returnvalue <- TRUE
    returnvalue
    } # end of function multiple_of_one_thousand
  
# ---------------------------------------------------
# Read in training data... create transactions data
# ---------------------------------------------------
# read in the input data for attribute names
# we do not use these data in the jump-start program
# it could be used later to provide an interpretation of association rules
# the rules are identified by numbers only in training and test data
# the attribute data show what those names mean in terms of the 
# subdirectory name (area_name) and its description
# we will use the area_name as our web_area_id because it is 
# short enough for listings and more meaningful than numbers
# in order to do this, we will need to define the mapping 
# much as we would with dictionaries and the map method in Python
attribute_input_data <- 
    read.csv(file = "microsoft_attribute_data.csv", header = FALSE,
        col.names = c("A_type", "numeric_value", "ignore_value", 
            "description", "area_name"), stringsAsFactors = FALSE)
  
# read in the input data for users and web areas visited
training_input_data <- read.csv(file = "microsoft_training_data.csv", 
    header = FALSE, col.names = c("CV_type","value","ignore_value"),
    stringsAsFactors = FALSE)

# the following code creates a transaction data frame for the training data
# as needed for association rule analysis with the R package arules
# the transaction data frame has two columns, the first being user_id
# and the second being the web_area_id, a web site area visited by the user
  
n_records <- nrow(training_input_data )  # stopping rule for while-loop
    
alphanumeric_transaction_data_frame <- NULL  # initialize object
n_record_count <- 0  # intialize record count 

# note that this step can take a while to run... 
# we set things up to report on the process, but this reporting
# may not work on all operating systems... be patient with this step
# note also that this step may be skipped on subsequent runs
# because you will have the transactions_file_name in place
cat("\n\nTransaction processing percentage complete: ")
while (n_record_count < n_records) {
  n_record_count <- n_record_count + 1
  # report to screen the proportion of job completed 
  if(multiple_of_one_thousand(n_record_count)) 
      cat(" ",trunc(100 * (n_record_count /  n_records)))
  # read one record from input data
  this_record <- training_input_data[n_record_count,]  
  if (this_record$CV_type == "C") user_id <- 
      this_record$value  # C for user_id
  if (this_record$CV_type == "V") {  # V record provides web_area_id 
    web_area_id <- map_microsoft(this_record$value)  # meaningful area name
    # add one record to the transaction.data.frame
    alphanumeric_transaction_data_frame <- 
      rbind(alphanumeric_transaction_data_frame, data.frame(user_id, web_area_id))  
    }
  }
  
# write the transactions to a comma-delimited file
transactions_file_name <- "microsoft_training_transactions.csv"
write.csv(alphanumeric_transaction_data_frame, 
    file = transactions_file_name, row.names = FALSE)
cat("\nTransactions sent to ",transactions_file_name,"\n")  

# ------------------------------------------------
# Use transactions data to find association rules 
# ------------------------------------------------
transactions_object <- 
    read.transactions(file = transactions_file_name, cols = c(1,2),
        format = "single", sep = ",", rm.duplicates = TRUE)

cat("\n",dim(transactions_object)[1],"unique user_id values")  
cat("\n",dim(transactions_object)[2],"unique web_area_id values") 

# examine frequency for each item with support 
# greater than high_support_setting
pdf(file = "fig_wnds_recommend_web_area_support_bar_plot.pdf", 
  width = 8.5, height = 11)
itemFrequencyPlot(transactions_object, support = high_support_setting, 
  cex.names=0.8, xlim = c(0,0.4),
  type = "relative", horiz = TRUE, col = "darkblue", las = 1,
  xlab = "Proportion of Users Viewing the Web Area")
 title("Association Rules Analysis (Areas with Highest Support)")   
dev.off()   

# obtain large set of association rules for web areas
# this is done by setting very low criteria for support and confidence
# set support at low_support_setting and confidence at confidence_setting
# using our best judgment
association_rules <- apriori(transactions_object, 
  parameter = 
      list(support = low_support_setting, confidence = confidence_setting))
print(summary(association_rules))

# data visualization of association rules in scatter plot
pdf(file = "fig_wnds_recommend_web_area_rules_scatter_plot.pdf", 
    width = 8.5,height = 11)
plot(association_rules, 
  control=list(jitter=2, col = rev(brewer.pal(9, "Blues")[4:9])),
  shading = "lift")   
dev.off()    

# grouped matrix of rules 
pdf(file = "fig_wnds_recommend_web_area_bubble_chart.pdf", 
    width = 8.5, height = 11)
plot(association_rules, method="grouped",   
  control=list(col = rev(brewer.pal(9, "Blues")[4:9])))
dev.off()  

# route association rule results to text file
sink(file = "fig_wnds_recommend_partial_list_of_rules.txt")
cat("Web Usage Analysis by Association Rules\n")
cat("\n",dim(transactions_object)[1],"unique user_id values")  
cat("\n",dim(transactions_object)[2],"unique web_area_id values") 
cat("\n\nCriteria set for discovering association rules:")
cat("\nMinimum support set to:   ",low_support_setting)  
cat("\nMinimum confidence set to:",confidence_setting,"\n\n")  
print(summary(association_rules))
cat("\n","Resulting Web Area Association Rules\n\n")
inspect(association_rules)
sink()

# -----------------------------------------------
# Select association rules for recommender model
# -----------------------------------------------
# let's focus upon rules with a single-item/area-antecedent rules

selected_rules <- 
    make_lists_for_single_item_antecedent_rules(association_rules)
antecedent_areas <- as.numeric(unlist(selected_rules[[1]]))
consequent_areas <- as.numeric(unlist(selected_rules[[2]]))

# ---------------------------------------------------
# Read in test data and create users-by-areas matrix
# ---------------------------------------------------

test_input_data <- read.csv(file = "microsoft_test_data.csv", header = FALSE,
  col.names = c("CV_type","value","ignore_value"), stringsAsFactors = FALSE)

case_test_data <- subset(test_input_data, subset = (CV_type == "C")) 
list_of_case_id_names <- as.character(sort(unique(case_test_data$value))) 

web_area_test_data <- subset(test_input_data, subset = (CV_type == "V")) 
list_of_web_area_id_names <- 
    as.character(sort(unique(web_area_test_data$value)))  
  
# the following code creates a test data matrix for the test data
# rows correspond to the user_ids
# columns correspond to the web_area_ids  

# initialize test matrix as matrix of zeroes
test_data_matrix <- matrix(0, nrow = length(list_of_case_id_names), 
  ncol = length(list_of_web_area_id_names),
  dimnames = list(as.character(list_of_case_id_names), 
                  as.character(list_of_web_area_id_names)))
                                   
n_records <- nrow(test_input_data )  # used as stopping rule for while-loop
    
n_record_count <- 0  # intialize record count 

# note that this step should go pretty fast...  
cat("\n\nTest data processing percentage complete: ")
while (n_record_count < n_records) {
  n_record_count <- n_record_count + 1
  # report to screen the proportion of job completed 
  if(multiple_of_one_thousand(n_record_count)) 
      cat(" ",trunc(100 * (n_record_count /  n_records)))
  # read one record from input data
  this_record <- test_input_data[n_record_count,]  
  if (this_record$CV_type == "C") 
      name_user_id <- as.character(this_record$value)  # C record for user_id
  if (this_record$CV_type == "V") {  # V record provides web_area_id 
    name_web_area_id <- map_microsoft(this_record$value)
    # enter 1 in appropriate cell of test_data_matrix
    test_data_matrix[name_user_id, name_web_area_id] <- 1
    }
  }

# quick check of the test_data_matrix
# there should be as many 1s in test_data_matrix 
#    as there are V records in the test data file
if(nrow(web_area_test_data) != sum(test_data_matrix)) 
    stop("test_data_matrix problem")
  
# useful rows for testing are those with at least two web areas visited
# sum of rows is number of 1s
user_areas_visited <- apply(test_data_matrix, 1, FUN = sum)  

# keep track of the antecedent that is selected for testing
selected_antecedent <- rep(NA, length = nrow(test_data_matrix)) # initialize

# set up binary indicator for a correct prediction 
# from any of the association rules
correct_predictions <- rep(0, length = nrow(test_data_matrix)) # initialize

# set up a counter for the number of rules 
# that match the antecedent for this user
antecedent_rule_matches <- 
    rep(0, length = nrow(test_data_matrix))  # initialize

# set up character string vector for storing consequents correctly predicted
correctly_predicted_consequents <- 
    rep("", length = nrow(test_data_matrix))  # initialize

# for each user visiting more than one area
# select an area from his/her visited list at random
# predict from this area other areas likely to have been visited
# using the selected association rules from previous work
# determine if, in fact, these predictions are correct

set.seed(9999)  # for reproducible results
for(iuser in 1:nrow(test_data_matrix)) {
  if(user_areas_visited[iuser] > 1) {
    this_user_row <- test_data_matrix[iuser,]
    this_user_web_areas <- 
        as.numeric(names(this_user_row[(this_user_row == 1)])) 
    # pick one of the areas at random
    randomized_web_areas <- sample(this_user_web_areas)  
    selected_antecedent[iuser] <- 
        randomly_selected_antecedent <- randomized_web_areas[1] 
    randomly_selected_consequents <- 
        randomized_web_areas[2:length(randomized_web_areas)]
  
    # apply association rules to obtain predicted consequents
    for (iarea in seq(along = antecedent_areas)) {
      if (randomly_selected_antecedent == antecedent_areas[iarea]) {
        antecedent_rule_matches[iuser] <- antecedent_rule_matches[iuser] + 1  
        predicted_consequent <- consequent_areas[iarea]
        if (predicted_consequent %in% randomly_selected_consequents) {
          correct_predictions[iuser] <- correct_predictions[iuser] + 1
          correctly_predicted_consequents[iuser] <- 
            paste(correctly_predicted_consequents[iuser], 
                predicted_consequent, " ")
          }
        }
      } # end for-loop for checking association rules   
  
    } # end of if-block for users with more than one site visited
  } # end of testing for-loop

prediction_data_frame <- na.omit(data.frame(user.id = list_of_case_id_names, 
                                    user_areas_visited, 
                                    selected_antecedent,
                                    antecedent_rule_matches,
                                    correct_predictions,
                                    correctly_predicted_consequents))
                                    
cat("\n\nPercentage predicted accurately by recommendation model: ",
  round((100 * sum(correct_predictions) / 
      sum(antecedent_rule_matches)),digits = 3),"\n") 

# Suggestions for the student: Try alternative values for support 
# and confidence and note changes in the set off association rules.
# Develop a formal assessment strategy for evaluating the accuracy
# of recommendations. How much better are we doing with the model
# than we would expect from the levels of support across website areas?
# We see Percentage predicted accurately by recommendation model: 36.461
# How good is that value compared to what we could get without a model?
# What about recommendation system models other than association rules? 
# Could any of those models be used given the data we have here?



