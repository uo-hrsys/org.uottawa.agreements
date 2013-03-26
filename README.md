org.uottawa.agreements
======================

DITA-OT plugins to convert our XML collective agreements  to DITA-XML.

## Introduction

Our collective agreements are bilingual documentation, side by side. We developped in the past a custom EDD (agreement.edd) in Adobe Framemaker 9, that we exported as a DTD (agreement.dtd) to fullfil the need of our clients. 

Later, when we started to use DITA XML, the need of a tool to export one format to the other was required.

## Useage

1. Ensure that your dtd is set properly at the top of the document
```DTD
    <!DOCTYPE agreement PUBLIC "-//uottawa//agreement.dtd" "http://doc.rh.uottawa.ca/agreement/agreement.dtd">
```
    
2. run either:
```Shell
    ant
         -Dargs.input=path/to/union/agreement.xml 
         -Dtranstype=agreement2dita 
         -Doutput.dir=out/union/
```       
or 
    
```Shell    
    java -jar lib/dost.jar
    /i:path/to/union/agreement.xml
    /transtype:agreement2dita
    /outdir:out/union/ 
``` 

3.   In the out/union directory, you will find two directories, one for french (fr), one for english (en) containing your documentation
