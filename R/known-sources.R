#' Known data files
#' @export
known_sources <- list(
  fanniemae_2016Q4 = list(
    url = "https://ursa-qa.s3.amazonaws.com/fanniemae_loanperf/2016Q4.csv.gz",
    reader = function(file, ...) arrow::read_delim_arrow(file, delim = "|", col_names = FALSE, ...),
    delim = "|",
    dim = c(22180168L, 31L)
  ),
  `nyctaxi_2010-01` = list(
    url = "https://ursa-qa.s3.amazonaws.com/nyctaxi/yellow_tripdata_2010-01.csv.gz",
    reader = function(file, ...) arrow::read_csv_arrow(file, ...),
    delim = ",",
    dim = c(14863778L, 18L)
  ),
  chi_traffic_2020_Q1 = list(
    url = "https://ursa-qa.s3.amazonaws.com/chitraffic/chi_traffic_2020_Q1.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(13038291L, 23L)
  ),
  type_strings = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_strings.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 5L)
  ),
  type_dict = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_dict.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 5L)
  ),
  type_integers = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_integers.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 5L)
  ),
  type_floats = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_floats.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 5L)
  ),
  type_nested = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_nested.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 4L)
  ),
  type_simple_features = list(
    url = "https://ursa-qa.s3.amazonaws.com/single_types/type_simple_features.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000000L, 5L)
  )
)

# these are similar to known_sources above, with the exception that they come
# with the package, so they have a filename instead of a url
test_sources <- list(
  fanniemae_sample = list(
    filename = "fanniemae_sample.csv",
    reader = function(file, ...) arrow::read_delim_arrow(file, delim = "|", col_names = FALSE, ...),
    delim = "|",
    dim = c(757L, 108L)
  ),
  nyctaxi_sample = list(
    filename = "nyctaxi_sample.csv",
    reader = function(file, ...) arrow::read_delim_arrow(file, ...),
    delim = ",",
    dim = c(998L,  18L)
  ),
  chi_traffic_sample = list(
    filename = "chi_traffic_sample.parquet",
    reader = function(file, ...) arrow::read_parquet(file, ...),
    dim = c(1000L, 23L)
  )
)

all_sources <- c(known_sources, test_sources)

taxi_schema <- function() {
  arrow::schema(
    vendor_id = arrow::string(),
    pickup_at = arrow::timestamp(unit = "us"),
    dropoff_at = arrow::timestamp(unit = "us"),
    passenger_count = arrow::int8(),
    trip_distance = arrow::float(),
    pickup_longitude = arrow::float(),
    pickup_latitude = arrow::float(),
    rate_code_id = arrow::string(),
    store_and_fwd_flag = arrow::string(),
    dropoff_longitude = arrow::float(),
    dropoff_latitude = arrow::float(),
    payment_type = arrow::string(),
    fare_amount = arrow::float(),
    extra = arrow::float(),
    mta_tax = arrow::float(),
    tip_amount = arrow::float(),
    tolls_amount = arrow::float(),
    total_amount = arrow::float()
  )
}

known_datasets <- list(
  taxi_parquet = list(
    url = "s3://ursa-labs-taxi-data",
    download = function(path) {
      arrow::copy_files("s3://ursa-labs-taxi-data", path)
      invisible(path)
    },
    open = function(paths) {
      arrow::open_dataset(paths, partitioning = c("year", "month"))
    },
    dim = c(1547741381L, 20L),
    n_files = 125
  ),
  taxi_file_list_parquet = list(
    url = "s3://ursa-labs-taxi-data",
    files = c(
      "/2009/01/data.parquet",
      "/2009/02/data.parquet"
    ),
    download = function(path) {
      # TODO, find a way to do this if we ever want to download these.
      stop("Can't do that")
    },
    open = function(paths) {
      arrow::open_dataset(
        paths,
        schema = taxi_schema(),
        partitioning = c("year", "month"),
        format = "parquet"
      )
    },
    n_files = 2,
    region = "us-east-2",
    dim = c(27472535L, 18L) # TODO: fix
  ),
  taxi_file_list_feather = list(
    url = "s3://ursa-labs-taxi-data-ipc",
    files = c(
      "/2013/01/data.feather",
      "/2013/02/data.feather"
    ),
    download = function(path) {
      # TODO, find a way to do this if we ever want to download these.
      stop("Can't do that")
    },
    open = function(paths) {
      arrow::open_dataset(
        paths,
        schema = taxi_schema(),
        partitioning = c("year", "month"),
        format = "feather"
      )    },
    n_files = 2,
    region = "us-east-2",
    dim = c(28766791L, 18L) # TODO: fix
  )
)
