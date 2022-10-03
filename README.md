# TLSCertAnalyzer
Interactive tool that enables better understanding of TLS Certificate Chains in [Glamorous Toolkit](https://gtoolkit.com/)

# Installation

```Smalltalk
[ EpMonitor current disableDuring: [ Metacello new
   baseline: 'TLSCertAnalyzer';
   repository: 'github://botwhytho/TLSCertAnalyzer:main/src';
   onConflictUseLoaded;
   load. ]] asAsyncFuture await
   ```
   
   # Usage
   
 Seach for the `TLSCertAnalyzer` class through spotter and use the 'Certs' class view to analyze new cert files or cert chain from specific host names.