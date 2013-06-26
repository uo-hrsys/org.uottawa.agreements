org.uottawa.agreements
======================

DITA-OT plugins to convert our XML collective agreements  to DITA-XML.

## Introduction

Our collective agreements are bilingual documentation, side by side. We developped in the past a custom EDD (agreement.edd) in Adobe Framemaker 9, that we exported as a DTD (agreement.dtd) to fullfil the need of our clients. 

Later, when we started to use DITA XML, the need of a tool to export one format to the other was required.

## Installation note

This plugin is a standard DITA-OT plugin, it simply need to be installed in the plugins directory of the DITA-OT.
You will need to add the xmltask.jar in the classpath. A copy of the library is provided in this installation. Simply add
the following line to the startcmd.sh script at the root ot the DITA-OT installation.

```Shell
NEW_CLASSPATH="$DITA_DIR/plugins/org.uottawa.agreements/xmltask/xmltask.jar:$NEW_CLASSPATH"
``` 

The plugins works with version 1.7.* of the DITA-OT.

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
