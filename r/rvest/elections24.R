# rvest - css

pacman::p_load(rvest, tidyverse, polite, googlesheets4, RCurl, patchwork, tidytext, ggfittext, ggpie)

#eg1------
url <- "http://sports.yahoo.com/mlb/standings/"
read_html(url) %>% html_nodes(".yui3-tabview-content") %>% html_nodes("table") %>% html_table


#eg2-----
url1='https://results.eci.gov.in/PcResultGenJune2024/partywisewinresultState-369.htm'
html <- rvest::read_html(url1)

url2 ='https://results.eci.gov.in/PcResultGenJune2024/index.htm'

html2 <- url2 %>% bow() %>% scrape() 

class(html2)

html2 %>% html_elements('table')
html2 %>% html_attr('href')

html2 %>%  html_element("table") %>% html_table()
html2 %>% html_elements("i") %>% html_text2()
html2 %>% html_nodes(css = "[class=table]") %>% html_table()


url3 = 'https://results.eci.gov.in/PcResultGenJune2024/ConstituencywiseS242.htm'
html3 <- url3 %>% bow() %>% scrape()

html3 %>% html_nodes(xpath ="//table[@class='table table-striped table-bordered']") %>% html_table(fill=T)

aName = html3 %>% html_nodes(css='h2') %>% html_text2() %>% stringr::str_replace('Parliamentary Constituency','') %>% str_trim()
t3 <- html3 %>% html_nodes(css = "[class='table table-striped table-bordered']") %>% html_table() %>% as.data.frame() %>% mutate(aName = aName)
t3


#now put in loop-----

gs1 = '1OkujSKXyQWYdMpAaMBy4fiLXXmtyC7oeEqlYaus31QU'
resultsC = read_sheet(ss=gs1, sheet='state', skip=1)
(cURLs <- resultsC %>% select(cURL) %>% pull(cURL))

resultsC %>% group_by(type,state) %>% tally() %>% as.data.frame()
dim(resultsC)

aResult <- function(url){
  if (url.exists(url)){
    dat <- bow(url) %>% scrape()
    aName = dat %>% html_nodes(css='h2') %>% html_text2() %>% stringr::str_replace('Parliamentary Constituency','') %>% str_trim()
    t3 <-  dat %>% html_nodes(css = "[class='table table-striped table-bordered']") %>% html_table() %>% as.data.frame() %>% mutate(aName = aName, Postal.Votes = as.character(Postal.Votes), EVM.Votes = as.character(EVM.Votes), Total.Votes = as.character(Total.Votes), X..of.Votes = as.character(X..of.Votes))
    t3
  }
}
dim(res)
ts = aResult(resultsC %>% slice(543) %>% pull(cURL))
ts
str(ts)
#allResults <- purrr::map_dfr(resultsA %>% slice(1:30) %>% pull(cURL), aResult)
allResults1 <- purrr::map_dfr(cURLs[1:100], aResult)
dim(allResults1)
allResults2 <- purrr::map_dfr(cURLs[101:200], aResult)
allResults3 <- purrr::map_dfr(cURLs[201:300], aResult)
allResults4 <- purrr::map_dfr(cURLs[301:400], aResult)
allResults5 <- purrr::map_dfr(cURLs[401:500], aResult)
allResults6 <- purrr::map_dfr(cURLs[501:543], aResult)
allResults6 
finalResults <- do.call('rbind', list(allResults1, allResults2, allResults3, allResults4, allResults5, allResults6))

dim(finalResults)
names(finalResults)
cNames = c('ser','candidate','party','evmVotes','postalVotes','totalVotes', 'voteP', 'constituency')
names(finalResults) = cNames
finalResults1 <- finalResults %>% filter(!is.na(ser))

finalResults1 %>% group_by(constituency) %>% tally()
finalResults1  %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% select(1:4)

finalResults2 <- finalResults1 %>% separate(col=constituency, into=c('const', 'state'), sep='\\(', remove=F) %>% mutate(state = str_trim(gsub('\\)','', state)))
finalResults2 <- finalResults2 %>% mutate(state = ifelse(state %in% c('SC','ST'), 'Andhra Pradesh', state)) %>% mutate(party =str_trim(party))
finalResults2 %>% group_by(state) %>% tally() %>% as.data.frame()
head(finalResults2)

gs1 = '1OkujSKXyQWYdMpAaMBy4fiLXXmtyC7oeEqlYaus31QU'
party = read_sheet(ss=gs1, sheet='party2', skip=1)

gs1 = '1OkujSKXyQWYdMpAaMBy4fiLXXmtyC7oeEqlYaus31QU'
state = read_sheet(ss=gs1, sheet='state', skip=1)
(state2 <- state %>% group_by(state) %>% slice_max(n=1, order_by = aCode) %>% ungroup() %>% select(state, state2, stateID, sCode, seats, sType)) 
str(state2)
state2 %>% filter(stateID =='UP')
party <- party %>% mutate(pName = str_trim(pName), party = str_trim(party))
head(finalResults2)
unique(finalResults2$party) 

#dataType-----
finalResults2 <- finalResults2 %>% mutate(across(evmVotes:totalVotes, as.integer)) %>% mutate(voteP = as.numeric(voteP))

#merge with state--------
state2[!state2$state %in% unique(finalResults2$state),]
unique(finalResults2$state)[!unique(finalResults2$state) %in% state2$state]
state2 %>% distinct(state, stateID, sCode)
finalResults2B <- merge(finalResults2, state2 %>% distinct(state, stateID, sCode, sType, seats) %>% select(state, stateID, sCode,sType, seats), by='state', all.x=T)

lapply(list(finalResults2, finalResults2B), dim)
names(finalResults2B)

#-------overallsummary-------
names(finalResults2B)
finalResults2C %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=1) %>% ggpie(., group='pID', count_type = 'full', label_info='all', label_type = 'horizon', label_pos = 'out', label_threshold = 5) + guides(fill='none')

gName = 'gLSE_B02'
indiaVotes = sum(finalResults2C$totalVotes, na.rm=T)
eligibleVoters =scales::label_number(accuracy=.2, scale_cut=scales::cut_short_scale())(968000000)
voted =scales::label_number(accuracy=.2, scale_cut=scales::cut_short_scale())(indiaVotes)

T1 = paste(gName, 'Overall Summary of Vote % (Party Wise): Top X Parties : Total India Votes - ', voted, ' from ', eligibleVoters)
gLSE_B02 <- finalResults2C %>% group_by(party) %>% summarise(totalVotes = sum(totalVotes, na.rm=T)) %>% mutate(voteP = round(100 *totalVotes/sum(totalVotes, na.rm=T),1)) %>% slice_max(order_by = totalVotes, n=20) %>%  ggplot(., aes(y=reorder(party, totalVotes), x=totalVotes, fill=party)) + geom_col(color='black') + theme(plot.title=element_text(hjust=.5)) + guides(fill='none') + geom_text(aes(label=paste(totalVotes, '\n (', voteP,'%)')), size=3) + labs(title=T1, x='Total Votes', y='Top X Parties')
gLSE_B02

?ggpie
gName = 'gLSE_B03'
T1 = paste(gName, 'Overall Summary of Elected Members (Party Wise) : Pie')
gLSE_B03 <- finalResults2C %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=1) %>% ggpie3D(., group='pID', tilt_degrees = 10, start_degrees = 0, count_type = 'full', label_info='all') + ggtitle(T1) + theme(plot.title=element_text(hjust=.5))
gLSE_B03

finalResults2B %>% group_by(stateID,sType, seats) %>% summarise(n=n()) %>% arrange(desc(n))
#no of candidates
gName = 'gLSE_C01'
T1=paste(gName, 'No of Seats(S) & Candidates(C) in each State')
gLSE_C01 <- finalResults2B %>% group_by(stateID,sType, seats) %>% summarise(n=n()) %>% ggplot(., aes(x=reorder(stateID, n), y=n, fill=stateID)) + geom_bar(stat='identity', position = position_dodge2(.8)) + geom_text(aes(label=paste('S-',seats, '/ C-',n)), size=3, angle=90, hjust=.5)  + guides(fill='none') + facet_grid(. ~ sType, scales = 'free', space='free') + labs(title=T1, x='State/ UT', y='count') + theme(plot.title = element_text(hjust=.5))
gLSE_C01

breaks1 = c(1,5,7,10,12,15,20,25,30,40,60)
labels1 = c('[1-5)','6-7','8-10', '11-12','13-15','16-20','21-25','26-30','31-40','41-60')
gName = 'gLSE_C02'
T1=paste(gName, 'Distribution of Candidates (Constituency): Histogram [fm-upto)')
gLSE_C02 <- finalResults2B %>% group_by(constituency) %>% summarise(n=n()) %>% mutate(category = cut(n, breaks= breaks1,include.lowest=T, labels=labels1, ordered_result = T)) %>% arrange(n) %>% as.data.frame() %>% group_by(category) %>% summarise(n=n()) %>% ggplot(., aes(x=category, y=n, fill=category)) + geom_col(colour='black') + geom_text(aes(label=n)) + labs(title=T1) + scale_fill_discrete() + theme(plot.title = element_text(hjust=.5))
gLSE_C02

gName = 'gLSE_C03'
T1=paste(gName, 'Avg No of Candidates in each Constituency of State')
gLSE_C03 <- finalResults2B %>% group_by(state, stateID) %>% summarise(n=n(), constCount = n_distinct(constituency)) %>% mutate(avgCandCons = round(n/constCount))  %>% ggplot(., aes(x=reorder(stateID, avgCandCons), y=avgCandCons, fill=stateID)) + geom_col(colour='black') + geom_text(aes(label=avgCandCons), hjust=.5) + labs(title=T1, x='State', y='Avg : Candidate / Consitituency') + theme(plot.title = element_text(hjust=.5)) + guides(fill='none') + coord_flip() + geom_vline(xintercept =c('UP','MH'))
gLSE_C03

#Parties-------
#no parties in each state
(totalParties = length(unique(finalResults2B$party)))

gName = 'gLSE_D01'
T1=paste(gName, 'No of Parties in each State from total of ',totalParties, ' parties in Country')
gLSE_D01 <- finalResults2B %>% distinct(stateID, party) %>% group_by(stateID) %>% summarise(n=n()) %>% ggplot(., aes(x=reorder(stateID, n), y=n, fill=stateID)) + geom_col(colour='black') + geom_text(aes(label=n), hjust=.5) + labs(title=T1, x='State', y='No of Parties') + theme(plot.title = element_text(hjust=.5)) + guides(fill='none') + coord_flip() + geom_vline(xintercept =c('UP','MH'))
gLSE_D01

gName = 'gLSE_D02'
T1=paste(gName, 'No of Parties in each State with Vote % > .01 (ie 1%) ')
gLSE_D02 <- finalResults2B %>% group_by(stateID, party) %>% summarise(totalVotes = sum(totalVotes, na.rm=T)) %>% group_by(stateID) %>% mutate(votePstate = totalVotes/ sum(totalVotes)) %>% filter(votePstate > .01) %>% distinct(stateID, party) %>% group_by(stateID) %>% summarise(n=n()) %>% ggplot(., aes(x=reorder(stateID, n), y=n, fill=stateID)) + geom_col(colour='black') + geom_text(aes(label=n), hjust=.5) + labs(title=T1, x='State', y='No of Parties') + theme(plot.title = element_text(hjust=.5)) + guides(fill='none') + coord_flip() + geom_vline(xintercept =c('UP','MH'), linewidth=.2)
gLSE_D02
finalResults2B %>% group_by(state, stateID, party) %>% summarise(n=n())
gLSE_D01 + gLSE_D02

gName = 'gLSE_D03'
T1=paste(gName, 'No of Parties (country) with Vote % > .01 (ie 1%) Overall ')
gLSE_D03 <- finalResults2B %>% group_by(party) %>% summarise(totalVotes = sum(totalVotes, na.rm=T))  %>% mutate(voteP = round(totalVotes/ sum(totalVotes,na.rm=T), 3)) %>% filter(voteP> .001) %>% ggplot(., aes(x=reorder(party, voteP), y=voteP, fill=party)) + geom_col(colour='black') + geom_text(aes(label=voteP), hjust=.5) + labs(title=T1, x='Party', y='Vote %') + theme(plot.title = element_text(hjust=.5)) + guides(fill='none') + coord_flip() 
+ geom_vline(xintercept =c('UP','MH'), linewidth=.2)
gLSE_D03

#merge partyAbvn------
gs1 = '1OkujSKXyQWYdMpAaMBy4fiLXXmtyC7oeEqlYaus31QU'
party = read_sheet(ss=gs1, sheet='party2', skip=1)
(pOrder = party %>% arrange(-won) %>% filter(!is.na(pID)) %>% pull(pID))
(pOrder1 = c(pOrder, 'Others'))

party$pName %in% unique(finalResults2B$party)
unique(finalResults2B$party) %in% party$pName
finalResults2C <- merge(finalResults2B, party %>% select(-c(ser, totalVotes, voteP)), by.x='party', by.y='pName', all.x=T)

lapply(list(finalResults2B, finalResults2C), dim)








#only for top parties which secured at least 1 seat
gName = 'gLSE_D05'
T1=paste(gName, 'Popular Parties with their Participation in each State')
gLSE_D05 <- finalResults2C %>% mutate(pID = ifelse(is.na(pID), 'Others', pID)) %>% group_by(pID, stateID) %>% summarise(n=n()) %>% mutate(pID = factor(pID, ordered=T, levels=pOrder1)) %>% ggplot(., aes(x=stateID, y=pID, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='green', low='yellow') + geom_hline(yintercept =c('BJP','INC', 'SP','AITC','TDP','JD(U)'), linewidth=.1) + guides(fill='none') + labs(title=T1, y='Party', x='State / Count of Participation') + theme(plot.title = element_text(hjust=.5)) 
gLSE_D05

#win Distribution of each party in state
gName = 'gLSE_D06'
T1=paste(gName, 'Popular Parties with their Winning Count in each State')
gLSE_D06 <- finalResults2C %>% group_by(constituency) %>% slice_max(order_by=totalVotes, n=1) %>% ungroup() %>% mutate(pID = ifelse(is.na(pID), 'Others', pID)) %>% group_by(pID, stateID) %>% summarise(n=n()) %>% mutate(pID = factor(pID, ordered=T, levels=pOrder1)) %>% ggplot(., aes(x=stateID, y=pID, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='green', low='yellow') + geom_hline(yintercept =c('BJP','INC', 'SP','AITC','TDP','JD(U)'), linewidth=.1) + guides(fill='none') + labs(title=T1, x='State / Count of Wins', y='Party') + theme(plot.title = element_text(hjust=.5)) 
gLSE_D06


gName = 'gLSE_D07'
T1=paste(gName, 'Vote Share of Popular Parties in each State')
gLSE_D07 <- finalResults2C %>% group_by(stateID, pID) %>% summarise(totalVotes = sum(totalVotes, na.rm=T)) %>% ungroup() %>% group_by(stateID) %>% mutate(voteP = round(100* totalVotes/ sum(totalVotes, na.rm=T),1)) %>% mutate(pID = ifelse(is.na(pID), 'Others', pID)) %>% mutate(pID = factor(pID, ordered=T, levels=pOrder1)) %>% ggplot(., aes(x=stateID, y=pID, fill=voteP)) + geom_tile(color='black') + geom_text(aes(label=paste0(voteP,'%')), size=3) + scale_fill_gradient2(high='green', low='yellow') + geom_hline(yintercept =c('BJP','INC', 'SP','AITC','TDP','JD(U)'), linewidth=.1) + guides(fill='none') + labs(title=T1, x='State / Count of Wins', y='Party') + theme(plot.title = element_text(hjust=.5)) 
gLSE_D07

gName = 'gLSE_D08'
T1=paste(gName, 'Vote Share of 3 Popular Parties in each State')
gLSE_D08 <- finalResults2C %>% group_by(stateID, pID) %>% summarise(totalVotes = sum(totalVotes, na.rm=T)) %>% ungroup() %>% group_by(stateID) %>% mutate(voteP = round(100* totalVotes/ sum(totalVotes, na.rm=T),1)) %>% mutate(pID = ifelse(is.na(pID), 'Others', pID)) %>% mutate(pID = factor(pID, ordered=T, levels=pOrder1)) %>% group_by(stateID) %>% slice_max(order_by = voteP, n=3) %>% ggplot(., aes(x=tidytext::reorder_within(pID, -voteP, stateID), fill=pID, y=voteP)) + geom_col(color='black') + geom_text(aes(label=paste0(voteP,'%')), size=3) + facet_wrap(stateID ~. , scale='free') + guides(fill='none') + labs(title=T1, x='State / Count of Wins', y='Party') + theme(plot.title = element_text(hjust=.5)) + scale_x_reordered() + scale_fill_hue()
gLSE_D08


#one state- UP
gName = 'gLSE_D09'; state1 ='UP'
T1=paste(gName, 'Vote Share of 3 Popular Parties in each Constituency of State ', state1)
finalResults2C %>% filter(stateID =='UP') %>% select(constituency, stateID) %>% mutate(constituency = gsub('\\(Uttar Pradesh\\)','', constituency))

gLSE_D09 <- finalResults2C %>% mutate(cno = readr::parse_number(constituency)) %>% mutate(constituency = gsub('[[:digit:]]+','', constituency), cno =  str_pad(cno, 2, pad = "0"), constituency = gsub('\\(Uttar Pradesh\\)', '', constituency)) %>% mutate(constituency = paste0(cno, ':', constituency)) %>% filter(stateID %in% state1) %>% group_by(constituency, pID) %>% summarise(totalVotes = sum(totalVotes, na.rm=T)) %>% ungroup() %>% group_by(constituency) %>% mutate(voteP = round(100* totalVotes/ sum(totalVotes, na.rm=T),1)) %>% mutate(pID = ifelse(is.na(pID), 'Others', pID)) %>% mutate(pID = factor(pID, ordered=T, levels=pOrder1)) %>% group_by(constituency) %>% slice_max(order_by = voteP, n=3) %>% ggplot(., aes(x=tidytext::reorder_within(pID, -voteP, constituency), fill=pID, y=voteP)) + geom_col(color='black') + geom_text(aes(label=paste0(voteP,'%')), size=3) + facet_wrap(constituency ~. , scale='free') + guides(fill='none') + labs(title=T1, x='State / Count of Wins', y='Party') + theme(plot.title = element_text(hjust=.5)) + scale_x_reordered() + scale_fill_hue() + geom_line(aes(group = constituency))
gLSE_D09

gName = 'gLSE_D11'; state1 ='UP'
T1=paste(gName, 'How 1st Party Defeated 2nd Party By Vote Margin of ', state1)
gLSE_D11 <- finalResults2C %>% filter(stateID %in% state1) %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% select(stateID, constituency, candidate,pID, totalVotes)  %>% group_by(stateID, constituency) %>% summarise(diff12 = -diff(totalVotes), party12 = paste(pID,collapse=' -> ')) %>% select(stateID, constituency,  diff12, party12) %>%  mutate(cno = readr::parse_number(constituency)) %>% mutate(constituency = gsub('[[:digit:]]+','', constituency), cno =  str_pad(cno, 2, pad = "0"), constituency = gsub('\\(Uttar Pradesh\\)|-', '', constituency)) %>% mutate(constituency = str_trim(paste0(cno, ':', constituency))) %>% separate(party12, into=c('party1','party2'), sep='->', remove = F) %>% ggplot(., aes(y= reorder(constituency, diff12), x=diff12, fill=party1)) + geom_col(colour='black') + geom_text(aes(label=paste(diff12)), size=3) + guides(fill='none') + ggh4x::facet_nested_wrap( ~ party1 + party12, scales='free', ncol=5)  + labs(title=T1, x='Party 1 -> Party 2', y='Vote Difference ') + theme(plot.title = element_text(hjust=.5))
gLSE_D11

names(finalResults2C)
gName = 'gLSE_D12'; state1 ='UP'
T1=paste(gName, 'How 1st Party Defeated 2nd Party By Vote % of ', state1)
gLSE_D12 <- finalResults2C %>% filter(stateID %in% state1) %>% group_by(constituency) %>% slice_max(order_by = voteP, n=2) %>% select(stateID, constituency, candidate,pID, voteP)  %>% group_by(stateID, constituency) %>% summarise(diff12 = -diff(voteP), party12 = paste(pID,collapse=' -> ')) %>% select(stateID, constituency,  diff12, party12) %>%  mutate(cno = readr::parse_number(constituency)) %>% mutate(constituency = gsub('[[:digit:]]+','', constituency), cno =  str_pad(cno, 2, pad = "0"), constituency = gsub('\\(Uttar Pradesh\\)|-', '', constituency)) %>% mutate(constituency = str_trim(paste0(cno, ':', constituency))) %>% separate(party12, into=c('party1','party2'), sep='->', remove = F) %>% ggplot(., aes(y= reorder(constituency, diff12), x=diff12, fill=party1)) + geom_col(colour='black', position =position_dodge2(preserve = "single", width=.8) ) + geom_text(aes(label=paste(diff12)), size=3) + guides(fill='none') + ggh4x::facet_nested_wrap( ~ party1 + party12, scales='free_y', ncol=5)  + labs(title=T1, x='Party 1 - Won from> Party 2', y='Vote Difference ') + theme(plot.title = element_text(hjust=.5)) + geom_vline(xintercept=10, color='violet')
gLSE_D12


#candidates who won with highest/least vote difference--------
gName = 'gLSE_E01'
T1=paste(gName, '1st Position Candidates who won with High Margin (>30%) of Votes against 2nd position ')
gLSE_E01 <- finalResults2C %>% group_by(constituency) %>% slice_max(order_by = voteP, n=2) %>% select(constituency, stateID, candidate, voteP, pID) %>% ungroup() %>% group_by(constituency) %>% summarise(votePdiff = -diff(voteP), cand12 = paste(candidate, collapse=' > '), party12 = paste(pID, collapse=' > ')) %>% ungroup() %>% filter(votePdiff > 30) %>% mutate(constituency = fct_reorder(constituency, votePdiff)) %>% ggplot(., aes(y=votePdiff, x=reorder(party12,votePdiff), fill=party12, label=cand12)) + geom_col() + geom_bar_text(min.size=0.5, reflow=T, grow=F, place='left', fullheight = F) + facet_wrap(constituency ~ ., scale='free_x', labeller = label_wrap_gen(width=30))  + guides(fill='none') + geom_text(aes(label=votePdiff), size=3) + labs(title=T1, x='Party1 (won) from Party 2(Lost)', y='Vote 5 (Diff)') + theme(plot.title = element_text(hjust=.5)) 
gLSE_E01

gName = 'gLSE_E02'
T1=paste(gName, '1st Position Candidates who won with Low Margin (< 2%) of Votes against 2nd position ')
gLSE_E02 <- finalResults2C %>% group_by(constituency) %>% slice_max(order_by = voteP, n=2) %>% select(constituency, stateID, candidate, voteP, pID) %>% ungroup() %>% group_by(constituency) %>% summarise(votePdiff = -diff(voteP), cand12 = paste(candidate, collapse=' > '), party12 = paste(pID, collapse=' > ')) %>% ungroup() %>% filter(votePdiff < 2) %>% mutate(constituency = fct_reorder(constituency, -votePdiff)) %>% ggplot(., aes(y=votePdiff, x=reorder(party12,votePdiff), fill=party12, label=cand12)) + geom_col() + geom_bar_text(min.size=1, reflow=T, grow=F, place='left', fullheight = F) + facet_wrap(constituency ~ ., scale='free_x', labeller = label_wrap_gen(width=30))  + guides(fill='none') + geom_text(aes(label=round(votePdiff,4)), size=3) + geom_text(aes(label=votePdiff), size=3) + labs(title=T1, x='Party1 (won) from Party 2(Lost)', y='Vote 5 (Diff)') + theme(plot.title = element_text(hjust=.5)) 
gLSE_E02

gName = 'gLSE_E03'
T1=paste(gName, "How many seats did Party1 won from Party2 with narrow vote % < 5")
gLSE_E03 <- finalResults2C %>% group_by(constituency) %>% slice_max(order_by = voteP, n=2) %>% select(constituency, stateID, candidate, voteP, pID) %>% ungroup() %>% group_by(constituency) %>% summarise(votePdiff = -diff(voteP), cand12 = paste(candidate, collapse=' > '), party12 = paste(pID, collapse=' > ')) %>% ungroup() %>% filter(votePdiff < 5) %>% separate(col=party12 , into=c('party1', 'party2'), sep=' > ', remove=F) %>% group_by(party1, party2) %>% summarise(n=n()) %>% ggplot(., aes(y=party1, x=party2, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='green', low='yellow') + labs(title=T1, y='Party1 (Won from Party2)', x=' Party2 (Lost from Party1) ') + theme(plot.title = element_text(hjust=.5)) + geom_hline(yintercept=c('BJP'), color='violet') + guides(fill='none')
gLSE_E03





mtcars %>% mutate(gear = as.character(gear), gear = fct_reorder(gear, mpg))
#winning parties
topParties <- party %>% 
names(finalResults2B)
names(party)

#party share > 1%





#2nd position in each constitutency of state--
finalResults2B %>% group_by(party) %>% summarise(n=n(), totalVotes = sum(totalVotes, na.rm=T), states= n_distinct(stateID), statesNames = paste(unique(stateID), collapse=',')) %>% mutate(voteP= round(totalVotes/sum(totalVotes),2)) %>% arrange(tolower(party)) %>% clipr::write_clip(.)
finalResults2B %>% group_by(party) %>% summarise(n=n()) %>% clipr::write_clip(.)

finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% slice_tail(n = 1) %>% ungroup() %>% group_by(state, party) %>% summarise(n=n()) %>% arrange(state, desc(n)) %>% as.data.frame()

#1stposition------
finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=1)  %>% ungroup() %>% group_by(stateID, party, sType) %>% tally() %>% ggplot(., aes(x=stateID, y=party, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='yellow',low='green') + theme(axis.text.x = element_text(angle=0))

#2nd position-----
finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% slice_tail(n=1)  %>% ungroup() %>% group_by(stateID, party, sType) %>% tally() %>% ggplot(., aes(x=stateID, y=party, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='yellow',low='green') + theme(axis.text.x = element_text(angle=0))

#3rd position-----
finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=3) %>% slice_tail(n=1)  %>% ungroup() %>% group_by(stateID, party, sType) %>% tally() %>% ggplot(., aes(x=stateID, y=party, fill=n)) + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='yellow',low='green') + theme(axis.text.x = element_text(angle=0))

finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=3) %>% slice_tail(n=1)  %>% ungroup() %>% group_by(party, stateID) %>% tally() %>% filter(n > 2) %>% ggplot(., aes(y=reorder(party,n), fill=stateID, x=n)) + geom_bar(stat='identity', position = position_stack(.8), color='black') + geom_text(aes(label=paste(stateID,n)), position = position_stack(.8), size=3, angle=45)  + theme(axis.text.x = element_text(angle=0)) + guides(fill='none') 

finalResults2B %>% filter(grepl('Narendra Modi', candidate, ignore.case=T))

tidyr::extract_numeric('dhiraj 66')
merge(finalResults2B, state, by='')
finalResults2B %>% filter(aCode=='77')

partyList1 = c('Bharatiya Janata Party','Indian National Congress', 'Independent')
finalResults2B %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=3) %>% mutate(rank = rank(-totalVotes)) %>% select(stateID, constituency, candidate, totalVotes, rank , party)  %>% group_by(stateID, party, rank) %>% tally() %>% filter(grepl(paste(partyList1, collapse='|'), party))  %>% ggplot(., aes(y=rank, x=stateID, fill=n)) + facet_grid(party ~. , scale='free') + geom_tile(color='black') + geom_text(aes(label=n)) + scale_fill_gradient2(high='green', low='yellow')

finalResults2 %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% ungroup() %>% group_by(party) %>% summarise(n=n()) %>% arrange(state, n) %>% as.data.frame()

finalResults2 %>% group_by(party) %>% summarise(TotalVotes = sum(totalVotes, na.rm=T)) %>% arrange(-TotalVotes) %>% mutate(percVote = round(100 * TotalVotes/ sum(TotalVotes),2)) %>% filter(percVote > 1.75)

finalResults2 %>% group_by(party) %>% summarise(TotalVotes = sum(totalVotes, na.rm=T)) %>% arrange(-TotalVotes) %>% as.data.frame() %>% tail(10)
finalResults2 %>% group_by(party) %>% summarise(TotalVotes = sum(totalVotes, na.rm=T)) %>% arrange(party) %>% as.data.frame() 

finalResults2 %>% group_by(state, party) %>% summarise(TotalVotes = sum(totalVotes, na.rm=T)) %>% arrange(-TotalVotes) %>% mutate(percVote = round(100 * TotalVotes/ sum(TotalVotes),1)) %>% filter(percVote > 2) %>% arrange(state, -percVote, party)



#-----merge with party-----
party[! party$partyName %in% unique(finalResults2$party),] %>% select(party, partyName)
finalResults2 %>% filter(grepl('Marxist Communist Party of India (United)', party))
finalResults2 %>% filter(grepl('Communist', party)) %>% filter(grepl('Marxist', party))%>% select(party)





finalResults3 <- merge(finalResults2, party %>% select(party, partyName, partyID, partyCode, won) , by.x='party', by.y='partyName', all.x = T)
finalResults3
lapply(list(finalResults2, finalResults3), dim)

saveRDS(finalResults1, file='/Users/du/dup/auData/elections/eResults.rds')
saveRDS(finalResults2B, file='/Users/du/dup/auData/elections/eResults2B.rds')
saveRDS(finalResults2C, file='/Users/du/dup/auData/elections/eResults2C.rds')
str(finalResults2)
finalResults2$totalVotes <- as.integer(finalResults2$totalVotes)
finalResults2 <- finalResults2 %>% mutate(across(evmVotes:totalVotes, as.integer)) %>% mutate(voteP = as.numeric(voteP))

finalResults2 %>% group_by(party) %>% summarise(n=n()) %>% arrange(desc(n))
finalResults2 %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=``) %>% ungroup() %>% group_by(party) %>% summarise(n=n()) %>% arrange(desc(n)) %>% as.data.frame()

finalResults2 %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=2) %>% slice_tail(n = 1) %>% ungroup() %>% group_by(party, state) %>% summarise(n=n()) %>% arrange(desc(n)) %>% as.data.frame()


finalResults3 %>% group_by(constituency) %>% slice_max(order_by = totalVotes, n=1) %>% ungroup() %>% group_by(party) %>% summarise(n=n()) %>% arrange(desc(n)) %>% as.data.frame()


#wikiConst------
urlW1 ='https://en.wikipedia.org/wiki/List_of_constituencies_of_the_Lok_Sabha'

LSseats <- urlW1 %>% read_html() %>% html_nodes('table') %>% html_table(fill=T)

purrr::map_dfr(LSseats[2], dplyr::bind_rows)

#table class='wiki sortable jquery-tablesorter'
html1 <- urlW1 %>% read_html()

cssS_T1 = "#mw-content-text > div.mw-content-ltr.mw-parser-output > table:nth-child(12)"
html1 %>% html_element(css= cssS_T1) %>% html_table(header=NA) %>% head()
T1 <- html1 %>% html_element(css= cssS_T1) %>% html_table(header=NA) %>% as.data.frame()
T1
?html_table

#stateWise------
xp1 ="//*[@id='Arunachal_Pradesh_(2)']"
html1 %>% html_elements(xpath = xp1) %>%  html_text2()
#get state Names as headings
headings <- html1 %>% html_nodes("span.mw-headline") %>% html_text2() 
headings[1:3]

#colNames-----
sNames <- c('constNo', 'constName', 'reservedFor', 'state')

#tableWise getData
cssS_T2 = "#mw-content-text > div.mw-content-ltr.mw-parser-output > table:nth-child(15)"
T2 <- html1 %>% html_element(css= cssS_T2) %>% html_table(header=NA) %>% as.data.frame() %>% mutate(state=headings[3])
names(T2) = sNames
head(T2)

#other ways
cssS_T3 ='#mw-content-text > div.mw-content-ltr.mw-parser-output > table:nth-child(18)'
xpT3= '//*[@id="mw-content-text"]/div[1]/table[3]'
html1 %>% html_element(css= cssS_T3) %>% html_table(header=NA) %>% as.data.frame() %>% mutate(state=headings[4]) #using css
html1 %>% html_elements(xpath = xpT3) %>% html_table(header=NA) %>% as.data.frame() %>% mutate(state=headings[4]) %>% rename(!!!setNames(names(.), sNames)) #using xpath and rename cols

headings[2:37]
headings
?append
headings <- append(headings, 14, values='Madhya Pradesh (29)')

headings[1:38]
x=37;  html1 %>% html_elements(xpath = paste0('//*[@id="mw-content-text"]/div[1]/table[',x,']')) %>% html_table(header=NA) %>% as.data.frame() %>% select(1:3)  %>% mutate(state=headings[x+1]) %>% rename(!!!setNames(names(.), sNames))

datalist = list()
for (x in 2:37) {
  (xpT= paste0('//*[@id="mw-content-text"]/div[1]/table[',x,']'))
  sT <- html1 %>% html_elements(xpath = xpT) %>% html_table(header=NA) %>% as.data.frame() %>% select(1:3)  %>% mutate(state=headings[x+1]) %>% rename(!!!setNames(names(.), sNames))
  #datalist$x <- x
  datalist[[x]] <- sT
}
datalist
datalist[1]
allStates = do.call(rbind, datalist)
allStates
head(allStates)
allStates %>% group_by(state) %>% tally()
allStates %>% group_by(state) %>% tally() %>% summarise(total = sum(n))




#
#---------- will need selenium----------
#statesURL <- resultsA %>% group_by(state) %>% slice(1) %>% pull(sURL)
#sURL ='https://results.eci.gov.in/PcResultGenJune2024/statewiseS011.htm'
#stateWise Summmary-------
#dat <- bow(sURL) %>% scrape()
#(sName = dat %>% html_nodes(css='h2') %>% html_text2()  %>% str_trim())
#cssS2 = "[class='table table-striped table-bordered']"
#t3 <-  dat %>% html_nodes(css = cssS2) %>% html_table(header=NA) %>% as.data.frame() %>% mutate(state = sName)
#sURL %>% bow() %>% scrape() %>% html_table()
----------------------
  #------------------