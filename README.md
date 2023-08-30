# Dataset of Aggregation over Out-of-Order Data

## Target
Online analysis algorithms incrementally update the results upon data with out-of-order arrivals will cause updates [Awad et al. ICPM 2020].
To prove that,
following the definition of continuous queries in IoTDB (https://iotdb.apache.org/UserGuide/V1.1.x/Query-Data/Continuous-Query.html#configuring-time-range-for-resampling),
we conduct a similar online aggregation analysis over a real-world dataset S-9 [Weiss et al. IoTBDS 2017] which contains out-of-order data arrivals. 

## How
- xxx.m

Taking d1.xlsx from S-9 as input, we select "S.Message.received.time.ms" and "C-Send-Time" as the arrival time and generation time of the data points, respectively.
"C.Server.Pocessing.duration.ns" is selected as the metric to be aggregated.

We simulate the online aggregation process that calculates the 500ms average of the target metric, and store the aggregation results as a time series in xxx.csv. 
The aggregation is executed at 500ms intervals and each execution covers the time range between 2 seconds prior to now() and now(). 
Notice that with this setting, aggregations for most time intervals will be computed four times.
Therefore, delayed data points in the input dataset will lead to updates of the periodic aggregated results.

## Result
- xxx.csv
- xxx.png

Updates are visually displayed in the figure below, which is a scatter plot of the resulting time series in xxx.csv.
If there is no update, the values of points with the same timestamp will be the same, and the color density of each dot in the scatter plot will be the same.
Otherwise, a more transparent dot in the scatter plot indicates that an update has occurred, which is the case in the figure below.
![png](scatter_plot_showing_updates.png)


- Awad, Ahmed, Matthias Weidlich, and Sherif Sakr. "Process mining over unordered event streams." 2020 2nd International Conference on Process Mining (ICPM). IEEE, 2020.
- Weiss, Wolfgang, Víctor Juan Expósito Jiménez, and Herwig Zeiner. "A dataset and a comparison of out-of-order event compensation algorithms." International Conference on Internet of Things, Big Data and Security. Vol. 2. SCITEPRESS, 2017.
