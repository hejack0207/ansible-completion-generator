<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output encoding="utf-8" method="xml"></xsl:output>

    <xsl:template match="/">
<xsl:text>
{
    "type":"object",
    "properties": {
</xsl:text>
        <xsl:apply-templates select="/actions/action"></xsl:apply-templates>
<xsl:text>
    }
}
</xsl:text>
    </xsl:template>

    <xsl:template match="action">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="an"/>
        <xsl:text>": {
            "type": "object",
            "description": "</xsl:text>
        <xsl:value-of select="ac"/>
        <xsl:text>",
            "properties": {</xsl:text>
        <xsl:apply-templates select="p"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="p/pnr">
            <xsl:text>,
                "required": [
                    "</xsl:text>
            <xsl:value-of select="p/pnr" separator=","/>"
            <xsl:text>    ]</xsl:text>
        </xsl:if>
        <xsl:text>
        }</xsl:text>
        <xsl:if test="position()!=last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="p">
        <xsl:if test="pnr">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="pnr"/>
            <xsl:text>": {
                "description": "</xsl:text>
            <xsl:call-template name="escapeQuote">
                <xsl:with-param name="pText" select="pc"></xsl:with-param>
            </xsl:call-template>
            <xsl:text>"
            }</xsl:text>
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="pno">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="pno"/>
            <xsl:text>": {
                "description": "</xsl:text>
            <xsl:call-template name="escapeQuote">
                <xsl:with-param name="pText" select="pc"></xsl:with-param>
            </xsl:call-template>
            <xsl:text>"
            }</xsl:text>
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="escapeQuote">
        <xsl:param name="pText" select="."/>
        <xsl:if test="string-length($pText) >0">
            <xsl:value-of select="substring-before(concat($pText, '&quot;'), '&quot;')"/>
            <xsl:if test="contains($pText, '&quot;')">
                <xsl:text>\"</xsl:text>
                <xsl:call-template name="escapeQuote">
                    <xsl:with-param name="pText" select=
                            "substring-after($pText, '&quot;')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
