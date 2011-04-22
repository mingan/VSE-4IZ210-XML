<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <!-- Tuto transformaci nemusíte měnit, je určena pro přímé zobrazení výsledku extrakce metadat () v prohlížeči -->
    <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
    
    <xsl:template match="extractedinfo">
        
        <html>
            <head>
                <title>Seznam vyextrahovaných anotací</title>
                <style type="text/css">                    
                    th {align:left}                            
                </style>
            </head>
            <body>
                <h1>Seznam vyextrahovaných anotací</h1>
                <xsl:apply-templates select="infotype"> </xsl:apply-templates>
            </body>

        </html>


    </xsl:template>
    <xsl:template match="infotype">
        <h2>
            <xsl:value-of select="@name"/>
        </h2>
        <table>
            <tr>
                <th style="width:100px; align:left">Hodnota</th>
                <th style="width:100px">Detaily</th>
                <th>Kontext</th>
            </tr>
            <xsl:apply-templates select="hit"/>
        </table>
    </xsl:template>
    <xsl:template match="hit">
        <tr>
            <td>
                <xsl:value-of select="value"/>
            </td>
            <td>
                <xsl:for-each select="details/part">
                    <span title="@name">
                        <xsl:value-of select="."/>
                    </span>
                    <xsl:if test="following-sibling::node()">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
            </td>
            <td>
                <xsl:value-of select="context"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
