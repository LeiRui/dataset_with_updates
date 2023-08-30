# Dataset of Aggregation over Out-of-Order Data

## Target
Online analysis algorithms incrementally update the results upon data with out-of-order arrivals will cause updates in results [Awad et al. ICPM 2020].
To prove that,
following the definition of continuous queries in IoTDB (https://iotdb.apache.org/UserGuide/V1.1.x/Query-Data/Continuous-Query.html#configuring-time-range-for-resampling),
we conduct a simulated online aggregation analysis over a real-world dataset S-9 [Weiss et al. IoTBDS 2017] which contains out-of-order data arrivals. 

- Awad, Ahmed, Matthias Weidlich, and Sherif Sakr. "Process mining over unordered event streams." 2020 2nd International Conference on Process Mining (ICPM). IEEE, 2020.
- Weiss, Wolfgang, Víctor Juan Expósito Jiménez, and Herwig Zeiner. "A dataset and a comparison of out-of-order event compensation algorithms." International Conference on Internet of Things, Big Data and Security. Vol. 2. SCITEPRESS, 2017.

## How
- analyzeS9.m

Taking d1.xlsx from the dataset S-9 as input, we select "S.Message.received.time.ms" and "C-Send-Time" as the arrival time and generation time of the data points, respectively.
"C.Server.Pocessing.duration.ns" is selected as the metric to be aggregated. 
In other words, "C-Send-Time" and "C.Server.Pocessing.duration.ns" form the time and value fields of the input time series, 
and "S.Message.received.time.ms" is the time the data point arrived in the database.

We simulate a continuous query cq1 as follows.
```
CREATE CONTINUOUS QUERY cq1
RESAMPLE RANGE 2s
BEGIN
  SELECT AVG(duration)
  INTO root.sg1.d1(duration_avg)
  FROM root.sg1.d1
  GROUP BY(500ms)
END
```
cq1 calculates the 500ms average of the target metric, and stores the aggregation results as a new time series in the database (we output the result time series in result.csv). 
cql is executed at 500ms intervals and each execution covers the time range between 2 seconds prior to now() and now(). 
Notice that aggregations for most time intervals will be computed multiple times, which is four in this implementation.
Therefore, delayed data points in the input dataset will lead to updates of the periodic aggregated results.

![cq1](https://github.com/LeiRui/dataset_with_updates/assets/33376433/d6af9def-abbb-4f9f-ae29-66e59ea92730)


## Result
- result.csv

The figure below is a scatter plot of the time series in result.csv.
If there is no update, the values of points with the same timestamp will be the same, and the color density of each dot in the scatter plot will be the same.
Otherwise, a more transparent dot in the scatter plot indicates that an update has occurred, which is the case in the figure below.
![png](scatter_plot_showing_updates.png)
