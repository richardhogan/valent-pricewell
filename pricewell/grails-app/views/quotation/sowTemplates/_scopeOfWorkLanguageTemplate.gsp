<g:if test="${tagType == 'paragraph' }">
	<g:set var="paraContent" value="${object}" />
	<w:pPr>
		<g:if test="${styleList.contains('h1')}">
			<w:pStyle w:val="Heading1"/>
		</g:if>
		<g:elseif test="${styleList.contains('h2')}">
			<w:pStyle w:val="Heading2"/>
		</g:elseif>
		<g:elseif test="${styleList.contains('h3')}">
			<w:pStyle w:val="Heading3"/>
		</g:elseif>
		<g:elseif test="${styleList.contains('h4')}">
			<w:pStyle w:val="Heading4"/>
		</g:elseif>
		<g:elseif test="${styleList.contains('h5')}">
			<w:pStyle w:val="Heading5"/>
		</g:elseif>
		<g:elseif test="${styleList.contains('h6')}">
			<w:pStyle w:val="Heading6"/>
		</g:elseif>
		<g:else>
			<w:jc w:val="both"/>
		</g:else>
		
		<g:if test="${tagStyleMap['margin-left'] != '' && tagStyleMap['margin-left'] != null}">
			<g:set var="leftMargin" value="${tagStyleMap['margin-left'].toInteger()}" />
			<w:ind w:left="${360 + (360 * (leftMargin/30))}"/>
		</g:if>
	</w:pPr>
	
	${paraContent}
</g:if>

<g:if test="${tagType == 'list' }">
	<g:set var="listContent" value="${object}" />
	<w:pPr>
		<w:pStyle w:val="ListParagraph"/>
		<w:numPr>
			<w:ilvl w:val="3"/>
			<w:numId w:val="2010"/>
		</w:numPr>
		
		<g:set var="leftMargin" value="${30}" />
			
		<g:if test="${tagStyleMap['margin-left'] != '' && tagStyleMap['margin-left'] != null}">
			<g:set var="leftMargin" value="${tagStyleMap['margin-left'].toInteger()}" />
		</g:if>
		
		<g:if test="${contentType == 'sow_introduction' ||  contentType != 'sow_project_parameters' || contentType != 'pre_requisite_metaphors' || contentType != 'out_of_scope_metaphors '}">
			<w:ind w:left="${360 + (360 * (leftMargin/30))}" w:hanging="400"/>
		</g:if>
		<g:else>
			<w:ind w:left="${730 + (720 * (leftMargin/30))}" w:hanging="400"/>
		</g:else>
		
		<w:jc w:val="both"/>
	</w:pPr>
	
	${listContent}
</g:if>

<g:if test="${type == 'line' }">
	<w:pPr>
	
		<w:pBdr>
			<w:bottom w:val="single" w:sz="6" w:space="1" w:color="auto"/>
		</w:pBdr>
		<w:jc w:val="both"/>
		
	</w:pPr>
</g:if>

<g:if test = "${isSpace}">
	<w:r>
		<w:rPr>
			<w:sz w:val="24"/>
			<w:szCs w:val="24"/>
		</w:rPr>
		<w:t xml:space="preserve"> </w:t>
	</w:r>
</g:if>

<g:if test = "${isFinal}">
	<w:r>
		<w:rPr>
			<g:set var="size" value="${24}" />
			
			<w:sz w:val="${size}"/>
			<w:szCs w:val="${size}"/>
			
			<g:if test="${styleList.contains('b') || styleList.contains('strong')}">
				<w:b/>
			</g:if>
			
			<g:if test="${styleList.contains('i') || styleList.contains('em') }">
				<w:i/>
			</g:if>
			
			<g:if test="${styleList.contains('u')}">
				<w:u w:val="single"/>
			</g:if>
		</w:rPr>
		
		<g:if test="${styleList.contains('spaceThere')}">
			<w:t xml:space="preserve">${paragraphContent}</w:t>
		</g:if>
		<g:else>
			<w:t>${paragraphContent}</w:t>
		</g:else>
	</w:r>
</g:if>