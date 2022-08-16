# STK-code
Some code for experiments with stk.

```
.
├── README.md: This file.
├── data
│   ├── conjunction_event_1km_maneuver.csv: For Pc.m.
│   └── conjunction_event_brust_maneuver.csv: For Pc.m
├── generate_tle.m
├── pc.m: Calculate Pc and miss distance based on TLE.
├── propagation: Propagate TLE with paopagators.
│   ├── propagation_base_on_tle_interval.m
│   ├── propagation_base_on_tle_interval_SPG4.m
│   ├── propagation_base_on_tle_interval_SPG4_TEST.m
│   ├── propagation_fixed_interval.m
│   └── propagation_fixed_interval_SPG4.m
├── rosette-lite
│   ├── etc: Config.
│   └── matlab_code: A little messy, to be organized.
│       ├── Altitude.m
│       ├── Create_Fac.m
│       ├── Create_LEO.m
│       ├── Create_delay.m
│       ├── Create_delay_hierarchi.m
│       ├── Create_link.m
│       ├── Create_location.m
│       ├── Create_report.m
│       ├── Lla2Cbf.m
│       ├── Satellite_numbers.m
│       ├── SimpleCone.m
│       ├── build_constellation.m
│       ├── coverage.m
│       ├── get_table.m
│       ├── min_altitude.m
│       ├── position2row_col.m
│       └── row_col.m
└── starperf-lite
    ├── etc
    └── matlab_code
        ├── Create_Fac.m
        ├── Create_LEO.m
        ├── Create_delay.m
        ├── Create_link.m: For sigcomm22 video and figure.
        ├── Create_location.m
        ├── Lla2Cbf.m
        └── build_constellation.m