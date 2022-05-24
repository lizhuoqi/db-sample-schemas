
|      tab       | rows_count |
|----------------|------------|
| artist         | 275        |
| album          | 347        |
| employee       | 8          |
| customer       | 59         |
| genre          | 25         |
| invoice        | 412        |
| media_type     | 5          |
| track          | 3503       |
| invoice_line   | 2240       |
| playlist       | 18         |
| playlist_track | 8715       |


mysql employee datatime, 因为真实数据有 1958 年的，远小于 1970.

加载数据的最好方式是 insert sql;

但效率最高的提 load with csv;