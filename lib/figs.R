###############################################################################
# Stylised figures for us in vis-for-gds
#
# Author: Roger Beecham
###############################################################################

library(tidyverse) # Bundle of packages for doing modern data analysis.
library(fst) # Fast/efficient working with tbls.
library(sf) # Spatial operations
library(lubridate) # Work with dates
library(here) # For navigating project directory
library(piggyback) # For download of large files from a git repository.

###############################################################################
# T H E M E S
###############################################################################

site_colours <- list(
  primary = "#003c8f",
  primary_selected = "#1565c0",
  secondary = "#8e0000",
  secondary_selected = "#c62828"
)

update_geom_defaults("label", list(family = "Roboto Condensed", face = "plain"))
update_geom_defaults("text", list(family = "Roboto Condensed", face = "plain"))

theme_v_gds <- function(base_size = 11, base_family = "Roboto Condensed") {
  return <- theme_minimal(base_size, base_family) +
    theme(plot.title = element_text(size = rel(1.4), face = "plain",
                                    family = "Roboto Condensed Regular"),
          plot.subtitle = element_text(size = rel(1), face = "plain",
                                       family = "Roboto Condensed Light"),
          plot.caption = element_text(size = rel(0.8), color = "grey50", face = "plain",
                                      family = "Roboto Condensed Light",
                                      margin = margin(t = 10)),
          plot.tag = element_text(size = rel(1), face = "plain", color = "grey50",
                                  family = "Roboto Condensed Regular"),
          strip.text = element_text(size = rel(0.8), face = "plain",
                                    family = "Roboto Condensed Regular"),
          strip.text.x = element_text(margin = margin(t = 1, b = 1)),
          panel.border = element_blank(),
          plot.background = element_rect(fill="#eeeeee", colour = NA),
          axis.ticks = element_blank(),
          panel.grid = element_line(colour="#e0e0e0"),
          axis.title.x = element_text(margin = margin(t = 10)),
          axis.title.y = element_text(margin = margin(r = 10)),
          #legend.margin = margin(t = 0),
          legend.title = element_text(size = rel(0.8)),
          legend.position = "bottom")

  return
}

###############################################################################
# S E S S I O N  1
###############################################################################

plot <- anscombe %>%
  gather(var, value) %>%
  add_column(var_type=c(rep("x",44),rep("y",44)), row_index=rep(1:44,2)) %>%
  mutate(dataset=paste("dataset",str_sub(var,2,2))) %>%
  select(-var) %>%
  spread(key=var_type, value=value) %>%
  ggplot(aes(x, y))+
  geom_point(colour=site_colours$primary, fill=site_colours$primary, pch=21) +
  stat_smooth(method=lm, se=FALSE, size=0.6, colour="#636363")+
  annotate("segment", x=9, xend=9, y=2.5, yend=7.5, colour=site_colours$secondary, alpha=.5, size=.5)+
  annotate("segment", x=5, xend=9, y=7.5, yend=7.5, colour=site_colours$secondary, alpha=.5, size=.5)+
  annotate("text", label="mean - 9.00 ",
           vjust="centre", hjust="centre", family="Roboto Condensed Light",size=2,
           x=9, y=2, colour=site_colours$secondary)+
  annotate("text", label="variance  - 11.00 ",
           vjust="centre", hjust="centre", family="Roboto Condensed Light",size=2,
           x=9, y=1)+
  annotate("text", label="correlation r.0.82",
           vjust="top", hjust="right", family="Roboto Condensed Light",size=2.5,
           x=20, y=3)+
  annotate("text", label="mean - 7.50 ",
           vjust="centre", hjust="right", family="Roboto Condensed Light",size=2,
           x=5, y=8, colour=site_colours$secondary)+
  annotate("text", label="variance  - 4.12 ",
           vjust="centre", hjust="right", family="Roboto Condensed Light",size=2,
           x=5, y=7)+
  facet_wrap(~dataset, nrow=2)+
  coord_equal(xlim = c(5, 20), ylim=c(3,13), # This focuses the x-axis on the range of interest
                  clip = 'off')+
  theme_v_gds()+
  theme(plot.margin = unit(c(1,1,1.5,2), "lines"),
        axis.text = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.spacing = unit(3, "lines"))

ggsave(filename="./static/class/01-class_files/anscombe.png", plot=plot,width=7, height=4, dpi=300)

###############################################################################
# S E S S I O N  2
###############################################################################

# ny_trips <- read_csv(here("data", "202006-citibike-tripdata.csv"))
# write_fst(ny_trips, here("data", "ny_trips_to_clean.fst"))
# ny_trips <- read_fst(here("data", "ny_trips_to_clean.fst"))
# t <- ny_trips %>%  rename_all(~str_replace_all(., "\ ", "_")) %>%  rename("start_time"=starttime, "stop_time"=stoptime, "trip_duration"=tripduration, "bike_id"=bikeid, "user_type"=usertype) %>%  
#   mutate(
#     id=row_number(), 
#     city="ny", 
#     start_station_id=paste0("ny", start_station_id),
#     end_station_id=paste0("ny", end_station_id)) %>%  
#   select(id, city, trip_duration, start_time, stop_time, start_station_id, end_station_id, bike_id, user_type, birth_year, gender) %>% 
#   mutate(birth_year=as.character(birth_year), bike_id=as.character(bike_id), start_time=as.character(start_time), stop_time=as.character(stop_time))
# write_fst(t, here("data", "ny_trips_cleaned.fst"))

# Data 
tmp_file <- tempfile()
pb_download("ny_trips.fst", repo = "rogerbeecham/datasets", tag = "v1.0", dest = tmp_file)
ny_trips <- fst::read_fst(tmp_file)

tmp_file <- tempfile()
csv_url <- "https://www.roger-beecham.com/datasets/ny_stations.csv"
curl::curl_download(csv_url, tmp_file, mode="wb")
ny_stations <- read_csv(tmp_file)

# Recode
ny_trips <- ny_trips %>%
  select(-c(city)) %>% 
  mutate_at(vars(start_station_id, end_station_id), ~as.integer(str_remove(., "ny"))) %>% 
  mutate_at(vars(start_time, stop_time), ~as.POSIXct(., format="%Y-%m-%d %H:%M:%S")) %>% 
  mutate(
    bike_id=as.integer(bike_id),
    # birth_year=year(as.POSIXct(birth_year, format="%Y")),
    gender=case_when(
      gender == 0 ~ "unknown", 
      gender == 1 ~ "male",
      gender == 2 ~ "female")
  ) 

ny_stations <- ny_stations %>% 
  select(-city) %>% 
  mutate(stn_id=as.integer(str_remove(stn_id, "ny"))) %>% 
  mutate_at(vars(longitude, latitude), ~as.double(.))


# Plot trips by hod doy and by gender 

ny_temporal <- ny_trips %>%  
  mutate(
    day=wday(start_time, label=TRUE),
    hour=hour(start_time)) %>%
  group_by(gender, day, hour) %>%
  summarise(count=n()) %>% 
  ungroup()

plot <- 
  ny_temporal %>% 
  filter(gender!="unknown") %>%
  ggplot(aes(x=hour, y=count, group=gender)) +
  geom_line(aes(colour=gender), size=1.1) +
  scale_colour_manual(values=c("#e31a1c", "#1f78b4")) +
  facet_wrap(~day, nrow=1)+
  labs(
    title="Citibike trip counts by hour of day, day of week and gender", 
    subtitle="--Jun 2020",
    caption="Data provided and owned by: NYC Bike Share, LLC and Jersey City Bike Share, LLC",
    x="", y="trip counts"
  )+
  theme_v_gds()

ggsave(filename="./static/class/02-class_files/hod_dow.png", plot=plot,width=9, height=5, dpi=300)



# Plot distance travelled

plot <- 
  ny_trips %>% 
  mutate(user_type=factor(user_type, levels=c("Subscriber", "Customer"))) %>% 
  ggplot(aes(dist)) +
  geom_histogram(fill=site_colours$primary) +
  facet_wrap(~user_type)+
  labs(
    title="Citibike trip distances (approximate km/h)", 
    subtitle="--Jun 2020",
    caption="Data provided and owned by: NYC Bike Share, LLC and Jersey City Bike Share, LLC",
    x="distance = km/h", y="frequency"
  )+
  theme_v_gds()
ggsave(filename="./static/class/02-class_files/dist.png", plot=plot,width=9, height=4, dpi=300)

# Utility trips
get_age <- function(dob, now) {
  period <- lubridate::as.period(lubridate::interval(dob, now),unit = "year")
  return(period$year)
} 

ny_trips <- ny_trips %>% 
  mutate(age=get_age(as.POSIXct(birth_year, format="%Y"), as.POSIXct("2020", format="%Y")))
ny_trips <- ny_trips %>% 
  mutate(duration_minutes=as.numeric(as.duration(stop_time-start_time),"minutes"))

od_pairs <- ny_trips %>% select(start_station_id, end_station_id) %>% unique() %>% 
  left_join(ny_stations %>% select(stn_id, longitude, latitude), by=c("start_station_id"="stn_id")) %>%
  rename(o_lon=longitude, o_lat=latitude) %>% 
  left_join(ny_stations %>% select(stn_id, longitude, latitude), by=c("end_station_id"="stn_id")) %>%
  rename(d_lon=longitude, d_lat=latitude) %>%  
  rowwise() %>% 
  mutate(dist=geosphere::distHaversine(c(o_lat, o_lon), c(d_lat, d_lon))/1000) %>% 
  ungroup()

ny_trips <- ny_trips %>% 
  mutate(od_pair=paste0(start_station_id,"-",end_station_id)) %>% 
  left_join(od_pairs %>% 
              mutate(od_pair=paste0(start_station_id,"-",end_station_id)) %>% 
              select(od_pair, dist)
  ) 

t <- ny_trips %>%
  mutate(day=wday(start_time, label=TRUE), is_weekday=as.numeric(!day %in% c("Sat", "Sun"))) %>%  
  filter(
    is_weekday==1,
    start_station_id!=end_station_id, 
    duration_minutes<=60,
    user_type=="Subscriber",
    between(age, 16, 74), 
    gender!="unknown") %>% 
  mutate(
    dist_bands=case_when(
      dist < 1.5 ~ "<1.5km", 
      dist < 3 ~ ">1.5-3km",
      dist < 4.5 ~ ">3-4.5km",
      TRUE ~ ">4.5km"),
    age_band=if_else(age %% 10 > 4, ceiling(age/5)*5, floor(age/5)*5), 
    speed=dist/(duration_minutes/60)
  ) %>% 
  group_by(gender, age_band, dist_bands) %>% 
  summarise(speed=mean(speed), n=n())

plot <- t %>% 
  ggplot(aes(x=age_band, y=speed))+
  geom_line(aes(colour=gender))+
  scale_colour_manual(values=c("#e31a1c", "#1f78b4")) +
  facet_wrap(~dist_bands, nrow=1) +
  labs(
    title="Citibike average trip speeds (approximate) by age, gender and trip distance", 
    subtitle="--Jun 2020",
    caption="Data provided and owned by: NYC Bike Share, LLC and Jersey City Bike Share, LLC",
    x="age - 5 year bands", y="speed - km/h "
  )+
  theme_v_gds()

ggsave(filename="./static/class/02-class_files/speeds.png", plot=plot,width=9, height=5, dpi=300)

