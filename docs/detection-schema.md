# Detection schema

## Purpose

The same evaluation scheme is used for every test case so that the results of Snort, Suricata and Zeek can be compared systematically and traceably.

## Main criteria

For every attack or test the following is examined:

1. **Is an alert raised?** – yes / no
2. **Is there a suspicious log entry?** – yes / no
3. **How fast is the detection?** – real time / delayed / only visible in the logs afterwards
4. **Was the attack detected?** – detected / not detected
5. **Was the attack technically successful?** – successful / not successful

Point 5 is supplementary and not the focus. The focus of the thesis is detection.

## Priority of observations

1. Alert
2. Suspicious log entry
3. Timing of the detection

This order matters because Zeek in particular does not work with clear alerts like classic IDS.

## Additional comparison points

- differences between Windows and Linux targets
- differences between default and custom configuration
- differences in CPU and RAM usage
- traceability and analysability of the results

## Documentation per test case

At least the following is recorded for every test:

- test ID
- date
- target system
- attack / scan
- tool used
- IDS configuration
- alert yes/no
- suspicious log yes/no
- timing
- detected / not detected
- technically successful yes/no
- remarks
