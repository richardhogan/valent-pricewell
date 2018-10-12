<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="body">
		<w:body>
			<xsl:apply-templates/>
		</w:body>
	</xsl:template>
	<xsl:template match="table">
		<!--caption goes before the table in WordProcessingML-->
		<w:p>
			<w:pPr>
				<w:pStyle w:val="Caption"/>
				<w:keepNext/>
			</w:pPr>
			<w:r>
				<w:t><xsl:value-of select="caption"/></w:t>
			</w:r>
		</w:p>
		<!--Start Table-->
		<w:tbl>
			<w:tblPr>
				<w:tblStyle w:val="TableGrid"/>
				<w:tblW w:w="0" w:type="auto"/>
			</w:tblPr>
			<w:tblGrid/>
			<xsl:apply-templates select="*[name() != 'caption']"/>
		</w:tbl>
	</xsl:template>
	<xsl:template match="thead | tbody | tfoot">
		<!--No WordProcessingML equivalent.  Keep drilling down.-->
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tr">
		<w:tr>
			<xsl:apply-templates />
		</w:tr>
	</xsl:template>
	<xsl:template match="th">
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="0" w:type="auto"/>
			</w:tcPr>
			<w:p>
				<w:pPr>
					<w:jc w:val="center"/>
				</w:pPr>
				<w:r>
					<w:rPr>
						<w:b/>
					</w:rPr>
					<w:t><xsl:value-of select="."/></w:t>
				</w:r>
			</w:p>
		</w:tc>
	</xsl:template>
	<xsl:template match="td">
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="0" w:type="auto"/>
			</w:tcPr>
			<w:p>
				<w:r>
					<w:t><xsl:value-of select="."/></w:t>
				</w:r>
			</w:p>
		</w:tc>
	</xsl:template>
</xsl:stylesheet>