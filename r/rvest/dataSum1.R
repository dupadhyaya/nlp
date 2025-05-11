pacman::p_load(tidyverse, maps, ISOcodes, rnaturalearth, rnaturalearthdata, WDI, scales)

state_names <- map('state', plot=F)$names
state_names

# Get subdivision data
data("ISO_3166_2")

# Filter for a country, e.g., India (IN)
india_states <- ISO_3166_2 %>% filter(grepl("^IN-", Code))

# View
india_states$Name

world_countries <- ne_countries(scale = "medium", returnclass = "sf")

# Select country name and population
country_population <- world_countries %>%
  select(name, pop_est) %>%
  arrange(desc(pop_est))   # Optional: arrange by population descending

# View top 10 countries
head(country_population, 10)

#wdi
# Fetch population data
population_data <- WDI(indicator = "SP.POP.TOTL", start = 2022, end = 2022)

# View
head(population_data)

population_data %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1, scale_cut = cut_short_scale()))
population_data %>% mutate(SP.POP.TOTL = SP.POP.TOTL/1000) %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1, scale_cut = cut_si(unit='M')))

population_data %>% mutate(SP.POP.TOTL = SP.POP.TOTL/1) %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1000000))

population_data %>% mutate(SP.POP.TOTL = SP.POP.TOTL/100000) %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1, scale_cut = cut_si('M')))

population_data %>% mutate(SP.POP.TOTL = SP.POP.TOTL/100000) %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1, scale_cut = cut_si('M')))

population_data %>% mutate(SP.POP.TOTL = SP.POP.TOTL/1) %>% slice_max(., order_by = SP.POP.TOTL, n=10) %>% ggplot(., aes(y=reorder(iso2c, SP.POP.TOTL) , x=SP.POP.TOTL)) + geom_col(aes(fill=iso2c)) + scale_x_continuous(labels = label_number(accuracy=1, scale_cut = cut_short_scale()))


