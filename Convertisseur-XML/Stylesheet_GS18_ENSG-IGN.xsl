<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:l="http://www.landxml.org/schema/LandXML-1.2"
                xmlns:h="http://xml.hexagon.com/schema/HeXML-2.0"
                exclude-result-prefixes="l h">

<!-- **************************************************************************************** -->
<!-- Stylesheet for ENSG-IGN - Leica GS18 -->
<!-- /version     : 1.0 (16/07/2024) -->
<!-- /author : Bruce Pourny mailto:bruce.pourny@ign.fr -->
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

	<!-- Declare a separator variable -->
	<xsl:variable name="separator" select="','" />

	<!-- Declare a line terminator variable -->
	<xsl:variable name="lineTerminator" select="'&#13;&#10;'" />

	<!-- Declare key for HexagonLandXML Point element -->
	<xsl:key name="KeyPointH" match="h:Point" use="@uniqueID" />
	
	<!-- Declare key for HexagonLandXML GPSPosition element -->
	<xsl:key name="KeyGPSPosH" match="h:GPSPosition" use="@targetPntRef" />


	<!--
	***************************************
	Main template
	***************************************
	-->

	<!-- Apply this template to the whole XML document -->
	<xsl:template match="/">

		<!-- Write the header line to the output file -->
		<xsl:value-of select="concat('PointID,Est,Nord,HautEllip,Alti,CQ3D,CQPlan,CQHauteur,Incli,IncliQual,IncliDirection,Direction,RTKRefStation,GPSTracked,GPSUsed,GLONASSTracked,GLONASSUsed,GALILEOTracked,GALILEOUsed,BEIDOUTracked,BEIDOUUsed', $lineTerminator)" />
		
		<!-- Select each CgPoint element in turn -->
		<xsl:for-each select="//l:CgPoint">

			<!-- Sort the CgPoint elements by time -->
			<xsl:sort select="@timeStamp" />

			<!-- Write the CgPoint element to the variable called CgPointCoordinates -->
			<xsl:variable name="CgPoint" select="." />

			<!-- Match the CgPoint element with the previously defiend key -->
			<xsl:variable name="PointH" select="key('KeyPointH', $CgPoint/@name)" />
			
			<!-- Match the CgPoint element with the previously defiend key -->
			<xsl:variable name="GPSPosH" select="key('KeyGPSPosH', $CgPoint/@name)" />

			<!-- Write the point ID to the output file -->
		    <xsl:value-of select="concat($CgPoint/@name, $separator)" />
			
			<!-- Write the coord attributes -->
			<xsl:value-of select="concat($PointH/h:Coordinates/h:Local/h:Grid/@e, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@n, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@hghtE, $separator, $PointH/h:Coordinates/h:Local/h:Grid/@hghthO, $separator)" />
			
			<!-- Write the control of quality (CQ) values -->
			<xsl:value-of select="concat($PointH/h:PointQuality/@CQ3D, $separator, $PointH/h:PointQuality/@CQPos, $separator, $PointH/h:PointQuality/@CQHeight, $separator)" />
			
			<!-- Write the tilt attributes -->
			<xsl:value-of select="concat($GPSPosH/h:TiltInfo/@tilt, $separator, $GPSPosH/h:TiltInfo/@tiltQuality, $separator, $GPSPosH/h:TiltInfo/@tiltDirection, $separator, $GPSPosH/h:TiltInfo/@heading, $separator)" />
			
			<!-- Write the RTK Reference station -->
			<xsl:value-of select="concat($GPSPosH/h:RTKInfo/@mountpoint, $separator)" />
			
			<!-- Write the GPS tracked/used station -->
			<xsl:value-of select="concat($GPSPosH/h:SatelliteInfo/@GPSSatTracked, $separator, $GPSPosH/h:SatelliteInfo/@GPSSatUsed, $separator)" />
			
			<!-- Write the GLONASS tracked/used station -->
			<xsl:value-of select="concat($GPSPosH/h:SatelliteInfo/@GLONASSSatTracked, $separator, $GPSPosH/h:SatelliteInfo/@GLONASSSatUsed, $separator)" />
			
			<!-- Write the GALILEO tracked/used station -->
			<xsl:value-of select="concat($GPSPosH/h:SatelliteInfo/@GALILEOSatTracked, $separator, $GPSPosH/h:SatelliteInfo/@GALILEOSatUsed, $separator)" />
			
			<!-- Write the BEIDOU tracked/used station -->
			<xsl:value-of select="concat($GPSPosH/h:SatelliteInfo/@BEIDOUSatTracked, $separator, $GPSPosH/h:SatelliteInfo/@BEIDOUSatUsed, $lineTerminator)" />
			
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