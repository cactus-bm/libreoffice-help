<?xml version="1.0" encoding="UTF-8"?>

<!--
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->
<!--
Stylesheet to extract tree context and generate a neste list
Usage:
xsltproc get_tree.xsl <file.tree>
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="app"/>
<xsl:param name="lang"/>
<xsl:param name="productname" select="'LibreOffice'"/>
<xsl:param name="productversion"/>

<xsl:output indent="yes" method="html"/>

<!--
############################
# Variables and Parameters #
############################
//-->
<!-- Product brand variables used in the help files -->
<xsl:variable name="brand1" select="'$[officename]'"/>
<xsl:variable name="brand2" select="'$[officeversion]'"/>
<xsl:variable name="brand3" select="'%PRODUCTNAME'"/>
<xsl:variable name="brand4" select="'%PRODUCTVERSION'"/>
<!--
#############
# Templates #
#############
//-->

<!-- Extract the tree and generate a nested UL-->
<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="help_section">
    <ul>
        <li><input type="checkbox" id="{@id}"/>
            <label for="{@id}">
                <xsl:call-template name="brand"><xsl:with-param name="string"><xsl:value-of select="@title"/></xsl:with-param></xsl:call-template>
            </label>
            <ul><xsl:apply-templates/></ul>
        </li>
    </ul>
</xsl:template>

<xsl:template match="node">
    <li><input type="checkbox" id="{@id}"/>
        <label for="{@id}">
            <xsl:call-template name="brand"><xsl:with-param name="string"><xsl:value-of select="@title"/></xsl:with-param></xsl:call-template>
        </label>
        <ul><xsl:apply-templates/></ul>
    </li>
</xsl:template>

<xsl:template match="topic">
    <xsl:variable name="htmlpage"><xsl:call-template name="filehtml">
            <xsl:with-param name="file" select="concat('/',$productversion,'/',$lang,'/',substring-after(@id,'/'))"/>
    </xsl:call-template></xsl:variable>
    <li><a target="_top" href="{$htmlpage}"><xsl:call-template name="brand"><xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param></xsl:call-template></a></li>
</xsl:template>

<!-- weird characters inside bookmarks, replace by HTML entities-->
<xsl:template name="apostrophe">
    <xsl:param name="string"/>
    <xsl:variable name="apost">&apos;</xsl:variable><!-- apostrophe -->
    <xsl:choose>
        <xsl:when test="contains($string,$apost)">
            <xsl:variable name="newstr">
                <xsl:value-of select="substring-before($string,$apost)"/>
                <xsl:text disable-output-escaping="yes"><![CDATA[&]]>#39;</xsl:text>
                <xsl:value-of select="substring-after($string,$apost)"/>
            </xsl:variable>
            <xsl:call-template name="apostrophe">
                <xsl:with-param name="string" select="$newstr"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$string"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Branding -->
<xsl:template match="text()">
    <xsl:call-template name="brand">
        <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="apostrophe">
        <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
    </xsl:call-template>
</xsl:template>


<xsl:template name="brand" >
    <xsl:param name="string"/>

    <xsl:choose>

        <xsl:when test="contains($string,$brand1)">
            <xsl:variable name="newstr">
                <xsl:value-of select="substring-before($string,$brand1)"/>
                <xsl:value-of select="$productname"/>
                <xsl:value-of select="substring-after($string,$brand1)"/>
            </xsl:variable>
            <xsl:call-template name="brand">
                <xsl:with-param name="string" select="$newstr"/>
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($string,$brand2)">
            <xsl:variable name="newstr">
                <xsl:value-of select="substring-before($string,$brand2)"/>
                <xsl:value-of select="$pversion"/>
                <xsl:value-of select="substring-after($string,$brand2)"/>
            </xsl:variable>
            <xsl:call-template name="brand">
                <xsl:with-param name="string" select="$newstr"/>
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($string,$brand3)">
            <xsl:variable name="newstr">
                <xsl:value-of select="substring-before($string,$brand3)"/>
                <xsl:value-of select="$productname"/>
                <xsl:value-of select="substring-after($string,$brand3)"/>
            </xsl:variable>
            <xsl:call-template name="brand">
                <xsl:with-param name="string" select="$newstr"/>
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($string,$brand4)">
            <xsl:variable name="newstr">
                <xsl:value-of select="substring-before($string,$brand4)"/>
                <xsl:value-of select="$pversion"/>
                <xsl:value-of select="substring-after($string,$brand4)"/>
            </xsl:variable>
            <xsl:call-template name="brand">
                <xsl:with-param name="string" select="$newstr"/>
            </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
            <xsl:value-of select="$string"/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>
<xsl:template name="filehtml">
   <xsl:param name="file"/>
   <xsl:value-of select="substring-after(concat(substring-before($file,'.xhp'),'.html'),'/')"/>
</xsl:template>
</xsl:stylesheet>
