<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="no" indent="yes"/>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz-'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>
	<xsl:key name="GRANT_BY_START_DATE" match="GRANT" use="substring(START_DATE, 1, 4)"/>

	<xsl:template match="/">
		<!--
		<xsl:element name="html">
			<xsl:element name="head">
			</xsl:element>
			<xsl:element name="body">
				<xsl:element name="div">
					<xsl:attribute name="class">
						<xsl:text>w3-container</xsl:text>
					</xsl:attribute>
					<xsl:apply-templates select="GRANTS"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		-->
		<xsl:element name="div">
			<xsl:attribute name="class">
				<xsl:text>w3-container</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="GRANTS"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="GRANTS">
		<xsl:for-each select="GRANT[count(. | key('GRANT_BY_START_DATE', substring(START_DATE, 1, 4))[1]) = 1]">
			<xsl:sort order="descending" select="substring(START_DATE, 1, 4)"/>
			<xsl:element name="div">
				<xsl:attribute name="class">
					<xsl:text>w3-container</xsl:text>
				</xsl:attribute>
				<xsl:element name="details">
					<xsl:attribute name="open"/>
					<xsl:attribute name="class">
						<xsl:text>grant w3-section w3-card-2 w3-theme-l4</xsl:text>
					</xsl:attribute>
					<xsl:element name="summary">
						<xsl:attribute name="class">
							<xsl:text>w3-container w3-theme w3-xlarge</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="substring(START_DATE, 1, 4)"/>
					</xsl:element>
					<xsl:apply-templates select="key('GRANT_BY_START_DATE', substring(START_DATE, 1, 4))"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="GRANT">
		<xsl:element name="p">
			<xsl:attribute name="class">grant</xsl:attribute>
			<xsl:call-template name="display_titles"/>
			<xsl:call-template name="display_agencies"/>
			<xsl:call-template name="display_dates"/>
			<xsl:call-template name="display_amounts"/>
			<xsl:call-template name="display_lead_pis"/>
			<xsl:call-template name="display_ttu_pi"/>
			<xsl:call-template name="display_pi"/>
			<xsl:call-template name="display_co_pi"/>
			<xsl:call-template name="display_senior_personnel"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="display_titles">
		<xsl:for-each select="TITLE">
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:text>. </xsl:text>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_dates">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:text>date-wrapper</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="START_DATE and END_DATE">
					<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:text>start-date</xsl:text>
						</xsl:attribute>
						<xsl:apply-templates select="START_DATE"/>
					</xsl:element>
					<xsl:text> - </xsl:text>
					<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:text>end-date</xsl:text>
						</xsl:attribute>
						<xsl:apply-templates select="END_DATE"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="START_DATE">
					<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:text>start-date</xsl:text>
						</xsl:attribute>
						<xsl:apply-templates select="START_DATE"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="END_DATE">
					<xsl:element name="span">
						<xsl:attribute name="class">
							<xsl:text>end-date</xsl:text>
						</xsl:attribute>
						<xsl:apply-templates select="END_DATE"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="AMOUNT"><xsl:text>, </xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="display_agencies">
		<xsl:variable name="mark">
			<xsl:choose>
				<xsl:when test="START_DATE or END_DATE or AMOUNT"><xsl:text>, </xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="AGENCY">
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:value-of select="$mark"/> </xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_amounts">
		<xsl:for-each select="AMOUNT">
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_lead_pis">
		<xsl:for-each select="LEAD_PI">
			<xsl:if test="position() = 1">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:text>lead-pi-title</xsl:text>
					</xsl:attribute>
					<xsl:text>Lead-PI</xsl:text>
					<xsl:if test="position() != last()">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_ttu_pi">
		<xsl:for-each select="TTU_PI">
			<xsl:if test="position() = 1">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:text>ttu-pi-title</xsl:text>
					</xsl:attribute>
					<xsl:text>TTU-PI</xsl:text>
					<xsl:if test="position() != last()">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_pi">
		<xsl:for-each select="PI">
			<xsl:if test="position() = 1">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:text>pi-title</xsl:text>
					</xsl:attribute>
					<xsl:text>PI</xsl:text>
					<xsl:if test="position() != last()">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="display_co_pi">
		<xsl:for-each select="CO_PI">
			<xsl:if test="position() = 1">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:text>co-pi-title</xsl:text>
					</xsl:attribute>
					<xsl:text>Co-PI</xsl:text>
					<xsl:if test="position() != last()">
						<xsl:text>s</xsl:text>
					</xsl:if>
					<xsl:text>: </xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="display_senior_personnel">
		<xsl:for-each select="SENIOR_PERSONNEL">
			<xsl:if test="position() = 1">
				<xsl:element name="span">
					<xsl:attribute name="class">
						<xsl:text>co-pi-title</xsl:text>
					</xsl:attribute>
					<xsl:text>Senior Personnel: </xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-wrapper')"/>
				</xsl:attribute>
				<xsl:apply-templates select="current()"/>
				<xsl:choose>
					<xsl:when test="position() != last()"><xsl:text>, </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="TITLE|AGENCY|LEAD_PI|TTU_PI|PI|CO_PI|SENIOR_PERSONNEL">
		<!-- <span style="color:red;"><xsl:value-of select="name()"/></span> -->
		<xsl:call-template name="display_with_note"/>
	</xsl:template>
	
	<xsl:template match="AMOUNT">
		<!-- <span style="color:red;"><xsl:value-of select="name()"/></span> -->
		<xsl:if test="@phase">
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-phase')"/>
				</xsl:attribute>
				<xsl:value-of select="@phase"/>
				<xsl:text> Phase</xsl:text>
			</xsl:element>
			<xsl:text>: </xsl:text>
		</xsl:if>
		<xsl:call-template name="display_with_note"/>
	</xsl:template>
	
	<xsl:template match="START_DATE|END_DATE">
		<!-- <span style="color:red;"><xsl:value-of select="name()"/></span> -->
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-phase')"/>
			</xsl:attribute>
			<xsl:variable name="year" select="substring(current(), 1, 4)"/>
			<xsl:variable name="month" select="substring(current(), 6, 2)"/>
			<xsl:variable name="day" select="substring(current(), 9, 2)"/>
			<xsl:choose>
				<xsl:when test="number($month) != number($month)">
					<xsl:value-of select="$year"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$month = 01">January</xsl:when>
						<xsl:when test="$month = 02">February</xsl:when>
						<xsl:when test="$month = 03">March</xsl:when>
						<xsl:when test="$month = 04">April</xsl:when>
						<xsl:when test="$month = 05">May</xsl:when>
						<xsl:when test="$month = 06">June</xsl:when>
						<xsl:when test="$month = 07">July</xsl:when>
						<xsl:when test="$month = 08">August</xsl:when>
						<xsl:when test="$month = 09">September</xsl:when>
						<xsl:when test="$month = 10">October</xsl:when>
						<xsl:when test="$month = 11">November</xsl:when>
						<xsl:when test="$month = 12">December</xsl:when>
						<xsl:otherwise>[Error: <xsl:value-of select="$month"/>]</xsl:otherwise>
					</xsl:choose>	
					<xsl:text> </xsl:text>
					<xsl:if test="number($day) = number($day)">
						<xsl:value-of select="number($day)"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:value-of select="$year"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="display_with_note">
		<xsl:element name="span">
			<xsl:attribute name="class">
				<xsl:value-of select="translate(name(current()), $uppercase, $lowercase)"/>
			</xsl:attribute>
			<xsl:value-of select="current()"/>
		</xsl:element>
		<xsl:if test="@note">
			<xsl:text> (</xsl:text>
			<xsl:element name="span">
				<xsl:attribute name="class">
					<xsl:value-of select="concat(translate(name(current()), $uppercase, $lowercase), '-note')"/>
				</xsl:attribute>
				<xsl:value-of select="@note"/>
			</xsl:element>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
