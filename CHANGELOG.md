## v1.0.0, 12 July 2020

### BREAKING CHANGES

* Positive (`n`) and negative (`-n`) values are now treated the same.
  e.g `5` and `-5` are both processed as `5`, without any signage.
  To differentiate between a debit and credit, use the correct [Transaction Code](https://github.com/andrba/aba/blob/58446f5b0ef822e9792e9399b4af647319b13515/lib/aba/transaction.rb#L106-L112)
* Removed default values for transactions records to avoid generation of potentially incorrect records. Safety first!
* Minimum Ruby version is now 2.5

### NEW FEATURE

* You can now add a *return* record to be used when you'd like to return
a credit or a debit to another financial institution (OFI).
