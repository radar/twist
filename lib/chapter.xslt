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
        <p id='{@id}'>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    <xsl:template match="section">
        <section id='{@id}'>
            <xsl:apply-templates />
        </section>
    </xsl:template>
    <xsl:template match="chapter">
        <div class="chapter" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="chapter/title">
        <h1 id='{@id}'>
            <xsl:apply-templates />
        </h1>
    </xsl:template>
    <xsl:template match="chapter/section/title">
        <h2 id='{@id}'>
            <xsl:apply-templates />
        </h2>
    </xsl:template>
    <xsl:template match="chapter/section/section/title">
        <h3 id='{@id}'>
            <xsl:apply-templates />
        </h3>
    </xsl:template>
    <xsl:template match="chapter/section/section/section/title">
        <h4 id='{@id}'>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="filename">
        <span class="filename" id='{@id}'>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="formalpara">
        <div class="formalpara" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="chapter/section/formalpara/title">
        <h4 id='{@id}'>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="chapter/section/section/formalpara/title">
        <h4 id='{@id}'>
            <xsl:apply-templates />
        </h4>
    </xsl:template>
    <xsl:template match="itemizedlist">
        <ul id='{@id}'>
            <xsl:apply-templates />
        </ul>
    </xsl:template>
    <xsl:template match="listitem">
        <li id='{@id}'>
            <xsl:apply-templates />
        </li>
    </xsl:template>
    <xsl:template match="listitem/para">
        <span class="listitem" id='{@id}'>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="command">
        <span class="command" id='{@id}'>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="informalexample">
        <div class="informalexample" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="superscript">
        <sup id='{@id}'>
            <xsl:apply-templates />
        </sup>
    </xsl:template>
    <xsl:template match="programlisting">
        <pre>
            <xsl:apply-templates />
        </pre>
    </xsl:template>
    <xsl:template match="example">
        <div class="example" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="example/title">
        <span class="title" id='{@id}'>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="figure">
        <div class="figure" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="figure/title">
        <span class="title" id='{@id}'>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="mediaobject">
        <div class="mediaobject" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="imageobject">
        <div class="imageobject" id='{@id}'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    <xsl:template match="imagedata">
      <img src="{@fileref}" id='{@id}'>
        <xsl:value-of select="fileref" />
      </img>
    </xsl:template>
    <xsl:template match="footnote">
      <span class="footnote" id='{@id}'>
        <xsl:apply-templates />
      </span>
    </xsl:template>
    
    <xsl:template match="footnote/para">
      <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="uri">
      <a href="{.}" id='{@id}'><xsl:apply-templates /></a>
    </xsl:template>
    <!-- BEGIN TABLE XSLT DEFINITION --> 
    <xsl:template match="table">
      <div id='{@id}' class="table">
        <span class="title"><xsl:value-of select="title"/></span>
        <table>
          <xsl:apply-templates />
        </table>
      </div>
    </xsl:template>
    <xsl:template match="table/title">
    </xsl:template>
    <xsl:template match="table/tgroup">
      <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="table/thead">
      <thead id='{@id}'>
        <xsl:apply-templates />
      </thead>
    </xsl:template>
    <xsl:template match="row">
      <tr id='{@id}'>
        <xsl:apply-templates />
      </tr>
    </xsl:template>
    <xsl:template match="entry">
      <td id='{@id}'>
        <xsl:apply-templates />
      </td>
    </xsl:template>
    <!-- END TABLE XSLT DEFINITION --> 
      
    
    <xsl:template match="note">
      <div class="note" id='{@id}'>
          <xsl:apply-templates />
      </div>
    </xsl:template>
    
    <xsl:template match="internalnote">
      <div class="internalnote" id='{@id}' style="display:none">
          <xsl:apply-templates />
      </div>
    </xsl:template>
    
    <xsl:template match="note/title">
        <span class="title"><xsl:apply-templates /></span>
    </xsl:template>
    
</xsl:stylesheet>
