<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:l="http://www.landxml.org/schema/LandXML-1.2"
                xmlns:h="http://xml.hexagon.com/schema/HeXML-2.0"
                exclude-result-prefixes="l h">

<!-- **************************************************************************************** -->
<!-- (c) 2020, Leica Geosystems AG. All rights reserved. -->
<!-- /version     : 1.0 -->
<!-- /description : Online learning exercise 1 -->
<!-- **************************************************************************************** -->
  

	<!--
    ***************************************
    Define output method and variables
    ***************************************
    -->

    <!-- Output ASCII type -->
	<xsl:output method="text" indent="no" encoding="ISO-8859-1"/> 

	<!-- What is shown in the Leica Captivate Export XML (Stylesheet) panel-->
	<xsl:variable name="fileExt" select="'csv'" />
	<xsl:variable name="fileDesc" select="'Point Id, code, attribute &amp; coordinates with comma delimiter'" />

	<!-- Declare the separator value -->
	<xsl:variable name="separator" select="','" />

	<!-- Declare the line terminator value -->
	<xsl:variable name="lineTerminator" select="'&#13;&#10;'" />

	<!-- Declare key for HexagonLandXML Point element -->
	<xsl:key name="KeyPointH" match="h:Point" use="@uniqueID" />
	
	<!-- Declare key for HexagonLandXML Point element -->
	<xsl:key name="KeySurveyH" match="h:GPSPosition" use="@targetPntRef" />


	<!--
	***************************************
	Main template
	***************************************
	-->

	<!-- Apply this template to the whole XML document -->
	<xsl:template match="/">

		<!-- Write the header line to the output file -->
		<xsl:value-of select="concat('PointID,Est,Nord,HautEllip,Alti,Incli,IncliQual,IncliDirection,Direction', $lineTerminator)" />
		
		<!-- Select each CgPoint element in turn -->
		<xsl:for-each select="//l:CgPoint">

			<!-- Sort the CgPoint elements by time -->
			<xsl:sort select="@timeStamp" />

			<!-- Write the CgPoint element to the variable called CgPointCoordinates -->
			<xsl:variable name="CgPoint" select="." />

			<!-- Match the CgPoint element with the previously defiend key -->
			<xsl:variable name="PointH" select="key('KeyPointH', $CgPoint/@name)" />
			
			<!-- Match the CgPoint element with the previously defiend key -->
			<xsl:variable name="SurveyH" select="key('KeySurveyH', $CgPoint/@name)" />

			<!-- Write the point ID to the output file -->
		    <xsl:value-of select="concat($CgPoint/@name, $separator)" />
			
			<!-- Write the coord attributes -->
			<xsl:value-of select="concat($PointH/h:Coordinates/h:Local/h:Grid/@e, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@n, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@hghtE, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@hghthO, $separator)" />
			
			<!-- Write the tilt attributes -->
			<xsl:value-of select="concat($SurveyH/h:TiltInfo/@tilt, $separator, $SurveyH/h:TiltInfo/@tiltQuality, $separator, $SurveyH/h:TiltInfo/@tiltDirection, $separator, $SurveyH/h:TiltInfo/@heading, $lineTerminator)" />
			
			
			


		<!-- End of "loop" for the CgPoint elements -->	
      	</xsl:for-each>

    <!-- Closing tag for template -->
	</xsl:template>


<!--
***************************************
Closing tag
***************************************
-->

<!-- Closing tag for whole stylesheet -->
</xsl:stylesheet>