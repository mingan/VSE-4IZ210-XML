<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">            
    <xsl:output method="xhtml"  encoding="utf-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" xml:lang="cs"></xsl:output>
<!-- Následující šablona se uplatní na element SHOP -->    
<xsl:template match="SHOP">
    <!-- Obsah šablony se vypíše na výstup včetně obsažených značek, v tomto případě jazyka HTML  -->
    <!-- příkazy jazyka XSL Stylesheets jsou v tomto dokumentu odlišeny prefixem xsl -->
    <!-- elementy obsahující prefix xsl se nevypisují na výstup ale interpretují XSL parserem -->
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>       
        <title>Nabídka TT klávesnice</title>        
        <link rel="stylesheet" type="text/css" href="zbozifeed_style.css"/>
        <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    </head>
    <body>
        <h1>Nabídka TT klávesnice</h1>        
                             
        <!-- Příkaz pro nalezení a provedení šablony pro element SHOPITEM-->
        <xsl:apply-templates select="SHOPITEM"/>        
        <p>
            <a href="http://validator.w3.org/check/referer"><img
                src="http://www.w3.org/Icons/valid-xhtml11"
                alt="Valid XHTML 1.1!" height="31" width="88" /></a>
        </p>
        
    </body>
    </html>

</xsl:template>    
    <!-- šablona pro element SHOPITEM -->
    <xsl:template match="SHOPITEM">
        <hr/>
        <h2><xsl:value-of select="PRODUCT"/></h2>
                
        <table>
            <tr><td rowspan="8" ><img src="{IMGURL}" alt=""/></td><td>Popis</td><td><xsl:value-of select="DESCRIPTION"/></td></tr>
            <!-- XML dokument musí obsahovat PRICE nebo PRICE_VAT a VAT-->
            <xsl:if test="PRICE"><tr><td class="nazevParametru">Cena v Kč bez DPH</td><td><xsl:value-of select="PRICE"/></td></tr></xsl:if>                                    
            <xsl:if test="PRICE_VAT"><tr><td>Cena v Kč s DPH</td><td><xsl:value-of select="PRICE_VAT"/></td></tr></xsl:if>
            <xsl:if test="VAT"><tr><td>Sazba DPH</td><td><xsl:value-of select="VAT"/></td></tr></xsl:if>
            <tr>
                <xsl:variable name="serviceLife" select="SERVICE_LIFE"/>
                <td>Životnost</td>
                <td><xsl:analyze-string select="$serviceLife" regex="(10|([1-9]\d*?))(0+)?">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                    
                    <xsl:if test="string-length(regex-group(3))">
                        × 10<sup><xsl:value-of select="string-length(regex-group(3))"/></sup>
                    </xsl:if>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="$serviceLife"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string> cyklů</td></tr>
            <tr><td>Rozteč kláves (hor./vert.)</td><td><xsl:value-of select="KEY_SPACING/HORIZONTAL"/>/<xsl:value-of select="KEY_SPACING/VERTICAL"/> mm</td></tr>
            <tr><td>Mechanická odezva</td><td><xsl:value-of select="MECHANICAL_RESPONSE"/></td></tr>
            <tr><td>Počet kláves</td><td><xsl:value-of select="KEY_COUNT"/></td></tr>
            <tr><td>Stupeň ochrany</td><td><xsl:value-of select="INGRESS_PROTECTION "/></td></tr>            
        </table>        
        

    </xsl:template>    
</xsl:stylesheet>
