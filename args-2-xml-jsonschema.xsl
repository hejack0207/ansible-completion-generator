<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output encoding="utf-8" method="xml"></xsl:output>

<!--
    <xsl:template match="/">
        <json-schema>
            <type>object</type>
            <properties>
                <xsl:apply-templates select="/actions/action"></xsl:apply-templates>
            </properties>
        </json-schema>
    </xsl:template>
-->
    <xsl:template match="/">
        <json-schema>
            <xsl:apply-templates select="/actions/action"></xsl:apply-templates>
        </json-schema>
    </xsl:template>

    <xsl:template match="action">
        <oneOf>
            <xsl:element name="{an}">
                <type>object</type>
                <description><xsl:value-of select="ac"/></description>
                <properties>
                    <xsl:apply-templates select="p"/>
                </properties>
                <xsl:apply-templates select="p/pnr"/>
            </xsl:element>
        </oneOf>
    </xsl:template>

    <xsl:template match="p">
        <xsl:element name="{pnr|pno}">
            <description>
                <xsl:value-of select="pc"/>
            </description>
            <type>string</type>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p/pnr">
        <required>
            <xsl:value-of select="."></xsl:value-of>
        </required>
    </xsl:template>
</xsl:stylesheet>
