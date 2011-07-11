<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
   <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="co">
      <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="emphasis">
        <em>
            <xsl:apply-templates />
        </em>
    </xsl:template>
    <xsl:template match="para">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    <xsl:template match="section">
        <div class="section">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="chapter">
        <div class="chapter">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="chapter/title">
        <h1>
            <xsl:apply-templates />
        </h1>
    </xsl:template>
    <xsl:template match="chapter/section/title">
        <h2>
            <xsl:apply-templates />
        </h2>
    </xsl:template>
    <xsl:template match="chapter/section/section/title">
        <h3>
            <xsl:apply-templates />
        </h3>
    </xsl:template>
    <xsl:template match="chapter/section/section/section/title">
        <h4>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="filename">
        <span class="filename">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="formalpara">
        <div class="formalpara">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="chapter/section/formalpara/title">
        <h4>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="chapter/section/section/formalpara/title">
        <h4>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="itemizedlist">
        <ul>
            <xsl:apply-templates />
        </ul>
    </xsl:template>
    <xsl:template match="listitem">
        <li>
            <xsl:apply-templates />
        </li>
    </xsl:template>
    <xsl:template match="listitem/para">
        <span class="listitem">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="command">
        <span class="command">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="informalexample">
        <div class="informalexample">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="superscript">
        <sup>
            <xsl:apply-templates />
        </sup>
    </xsl:template>
    <xsl:template match="programlisting">
        <pre>
            <xsl:apply-templates />
        </pre>
    </xsl:template>
    <xsl:template match="example">
        <div class="example">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="example/title">
        <span class="exampletitle">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="figure">
        <div class="figure">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="figure/title">
        <span class="figuretitle">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="mediaobject">
        <div class="mediaobject">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="imageobject">
        <div class="imageobject">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="imagedata">
      <img src="{@fileref}">
        <xsl:value-of select="fileref" />
      </img>
    </xsl:template>
    <xsl:template match="footnote">
      <span class="footnote" style='display:none'>
        <xsl:apply-templates />
      </span>
    </xsl:template>
    <xsl:template match="note">
        <div class="note">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
</xsl:stylesheet>
