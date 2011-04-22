<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml"  encoding="utf-8" indent="yes" ></xsl:output>
    
    
    <xsl:template match="/DistillSettings">
        <xsl:processing-instruction name="xml-stylesheet">href = "metadata-result_style.xsl" type = "text/xsl"</xsl:processing-instruction>
        
        <extractedinfo xsi:noNamespaceSchemaLocation="metadata-result.xsd">
            <xsl:variable name="source" select="File"/>
            <xsl:variable name="encoding" select="Encoding"/>

            <xsl:variable name="docAsString">
                <!-- tokenize(unparsed-text($source1,$encoding), '\n' -->
                <!-- unparsed-text('CI_VAS_makro.txt', 'utf-8') -->
                <xsl:value-of select="tokenize(unparsed-text($source,$encoding), '\n')"
                    disable-output-escaping="yes"/>
            </xsl:variable>

            <infotype name="IČO">
                <!-- Pozor, pokud se v regulárním výrazu vyskytují složené závorky, je třeba je  zdvojit -->
                <xsl:analyze-string select="$docAsString"
                    regex="(.{{0,30}})(IČO? [0-9]*)(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>                            
                            <value>
                                <xsl:value-of select="regex-group(2)"/>
                            </value>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>

            <infotype name="Osoba s akademickým titulem">
                <!-- Výraz \p{Lu} rozpoznává velká písmena a výraz \p{Ll} malá písmena. Opět pozor na zdvojené složené závorky kvůi vložení do XML-->
                <xsl:analyze-string select="$docAsString"                    
                    regex="(.{{0,30}})(Ing.|RNDr) (\p{{Lu}}\p{{Ll}}+ )+(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>
                            <value>
                                <xsl:value-of select="regex-group(2)"/> <xsl:value-of select="regex-group(3)"/>
                            </value>
                            <details>
                                <part name="Titul">
                                    <xsl:value-of select="regex-group(2)"/>
                                </part>                            
                                <part name="Příjmení">
                                    <xsl:value-of select="regex-group(3)"/>
                                </part>
                            </details>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
            
            <!-- velmi závisí na struktuře, odhadem jsem zadal možnost 80 znaků vysvětlení, ale nemusí stačit -->
            <infotype name="NACE">
                <!-- Pozor, pokud se v regulárním výrazu vyskytují složené závorky, je třeba je  zdvojit -->
                <xsl:analyze-string select="$docAsString"
                    regex="(.{{0,30}})(\d{{6}}):\s*(.{{1,80}})(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>                            
                            <value>
                                <xsl:value-of select="regex-group(2)"/>
                            </value>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
            
            <!-- nepovedlo se mi zprovoznit look behind assertions, se kterými by ten výsledek byl mnohem lepší -->
            <infotype name="Adresa">
                <!-- Výraz \p{Lu} rozpoznává velká písmena a výraz \p{Ll} malá písmena. Opět pozor na zdvojené složené závorky kvůi vložení do XML-->
                <xsl:analyze-string select="$docAsString"                    
                    regex="(.{{0,30}})((\p{{Lu}}[\p{{Ll}}-]+ ?)+)\s+(\d+([/-]\d+)?)(,\s*|\s+)(\d{{3}} ?\d{{2}})(,\s*|\s+)(([\p{{Lu}}\p{{N}}][\p{{Ll}}\d-]+ ?)+?)(,\s*|\s+)((\p{{Lu}}[\p{{L}} -]+)( ([\p{{L}}-]+\p{{L}}))*)(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>
                            <value>
                                <xsl:value-of select="regex-group(2)"/>, <xsl:value-of select="regex-group(4)"/>, <xsl:value-of select="regex-group(7)"/>, <xsl:value-of select="regex-group(9)"/>, <xsl:value-of select="regex-group(13)"/>
                            </value>
                            <details>
                                <part name="Ulice">
                                    <xsl:value-of select="regex-group(2)"/>
                                </part>                            
                                <part name="Číslo domu">
                                    <xsl:value-of select="regex-group(4)"/>
                                </part>                       
                                <part name="PSČ">
                                    <xsl:value-of select="regex-group(7)"/>
                                </part>                     
                                <part name="Město">
                                    <xsl:value-of select="regex-group(9)"/>
                                </part>                     
                                <part name="Stát">
                                    <xsl:value-of select="regex-group(13)"/>
                                </part>
                            </details>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
            
            <infotype name="HS">
                <!-- Pozor, pokud se v regulárním výrazu vyskytují složené závorky, je třeba je  zdvojit -->
                <xsl:analyze-string select="$docAsString"
                    regex="(.{{0,30}})(HS \d{{4}}(\.?\d{{2}}\.?\d{{4}}|\.?\d{{2}})?)(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>                            
                            <value>
                                <xsl:value-of select="regex-group(2)"/>
                            </value>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
            
            <infotype name="ISO norma">
                <!-- Pozor, pokud se v regulárním výrazu vyskytují složené závorky, je třeba je  zdvojit -->
                <xsl:analyze-string select="$docAsString"
                    regex="(.{{0,30}})((ČSN EN )?ISO(/IEC)? \d{{1,5}}(:[12]\d{{3}})?)(.{{0,30}})">
                    <xsl:matching-substring>
                        <hit>                            
                            <value>
                                <xsl:value-of select="regex-group(2)"/>
                            </value>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
            
            <infotype name="Telefon">
                <!-- Pozor, pokud se v regulárním výrazu vyskytují složené závorky, je třeba je  zdvojit -->
                <xsl:analyze-string select="$docAsString"
                    regex="(.{{0,30}})(\+\d{{3}} ?\d{{3}} ?\d{{3}} ?\d{{3}})(.{{0,30}}?)">
                    <xsl:matching-substring>
                        <hit>                            
                            <value>
                                <xsl:value-of select="regex-group(2)"/>
                            </value>
                            <context>
                                <xsl:value-of select="."/>
                            </context>
                        </hit>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </infotype>
        </extractedinfo>
    </xsl:template>
</xsl:stylesheet>
