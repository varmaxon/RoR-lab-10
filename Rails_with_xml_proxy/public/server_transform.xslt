<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <table>
            <thead>
                <tr>
                    <th>№</th>
                    <th>Число 1</th>
                    <th>Число 2</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="objects/object">
                    <xsl:variable name="counter" select="position()"/>
                        <tr>
                            <th>
                                <xsl:value-of select="$counter"></xsl:value-of>
                            </th>
                            <th>
                                <xsl:value-of select="first"></xsl:value-of>
                            </th>
                            <th>
                                <xsl:value-of select="second"></xsl:value-of>
                            </th>
                        </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>