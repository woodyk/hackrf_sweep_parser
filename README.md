# hackrf_sweep_parser

This is a simple script to parse hackrf_sweep output and identify
signals of a strength equal to or greater than the power level 
specified. The \<num_of_sweeps\> must be >= 2.

freq_finder.pl <power_level> <num_of_sweeps>


The following will search out frequencies with a powerlevel of -30 or
greater, across 5 sweeps.

```
freq_finder.pl -30 5
freq:99061979 seen:2 avgPower:-29 maxPower:-29.19 minPower:-29.27
freq:99091969 seen:2 avgPower:-26 maxPower:-23.63 minPower:-29.40
freq:99094968 seen:2 avgPower:-23 maxPower:-22.34 minPower:-24.53
freq:99097967 seen:2 avgPower:-27 maxPower:-27.39 minPower:-28.45
freq:105864378 seen:2 avgPower:-27 maxPower:-26.81 minPower:-28.68
freq:105867377 seen:2 avgPower:-28 maxPower:-28.17 minPower:-29.81
freq:105870376 seen:2 avgPower:-29 maxPower:-28.99 minPower:-29.82
freq:106689770 seen:2 avgPower:-29 maxPower:-28.69 minPower:-29.96
freq:106692769 seen:2 avgPower:-25 maxPower:-25.00 minPower:-25.90
freq:106695768 seen:3 avgPower:-27 maxPower:-24.55 minPower:-28.85
freq:106698767 seen:2 avgPower:-27 maxPower:-25.48 minPower:-28.87
freq:106701766 seen:3 avgPower:-29 maxPower:-28.28 minPower:-29.71
freq:106704765 seen:2 avgPower:-25 maxPower:-24.03 minPower:-26.91
freq:106707764 seen:2 avgPower:-23 maxPower:-22.16 minPower:-25.80
freq:106710763 seen:3 avgPower:-25 maxPower:-24.74 minPower:-27.22
freq:106713762 seen:3 avgPower:-24 maxPower:-21.24 minPower:-28.01
freq:106716761 seen:4 avgPower:-24 maxPower:-20.17 minPower:-28.73
freq:106719760 seen:3 avgPower:-25 maxPower:-21.97 minPower:-29.62
```

The output will return the following.
```
freq:frequency in hz
seen:number of times seen across each sweep
avgPower:average power across the sweeps
maxPower:maximum power across the sweeps
minPower:minimum power across the sweeps
```
