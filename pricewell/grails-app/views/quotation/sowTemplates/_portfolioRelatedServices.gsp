
	<w:tblPr>
		<w:tblStyle w:val="TableGrid"/>
		<w:tblW w:w="5000" w:type="pct"/>
		<w:tblBorders>
			<w:top w:val="single" w:sz="12" w:space="0" w:color="7F7F7F" />
			<w:left w:val="single" w:sz="12" w:space="0" w:color="7F7F7F" />
			<w:bottom w:val="single" w:sz="12" w:space="0" w:color="7F7F7F" />
			<w:right w:val="single" w:sz="12" w:space="0" w:color="7F7F7F" />
			<w:insideH w:val="single" w:sz="8" w:space="0" w:color="000000" />
			<w:insideV w:val="single" w:sz="8" w:space="0" w:color="000000" />
		</w:tblBorders>
	</w:tblPr>
	
	<w:tblGrid>
		<w:gridCol/>
		<w:gridCol/>
	</w:tblGrid>
	
	
	
	<w:tr w:rsidR="00101270" w:rsidTr="00F538A6">
		<w:tc>
			<w:tcPr>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
				<w:tcW w:w="9242" w:type="dxa"/>
				<w:gridSpan w:val="2"/>
			</w:tcPr>
			<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
				
				<w:r>
					<w:rPr>
						<w:b/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${portfolioInstance?.portfolioName }</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<g:each in="${serviceQuotationList}" status="s" var="serviceQuotationInstance">
	
		<w:tr w:rsidR="00101270" w:rsidTr="00101270">
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="4621" w:type="dxa"/>
				</w:tcPr>
				<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
					<w:r>
						<w:t></w:t>
					</w:r>
				</w:p>
				<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
					<w:r>
						<w:rPr>
							<w:b/>
							<w:sz w:val="24"/>
							<w:szCs w:val="24"/>
						</w:rPr>
						<w:t>${s+1}) ${serviceQuotationInstance?.service?.serviceName }</w:t>
					</w:r>
				</w:p>
				<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
					<w:r>
						<w:t></w:t>
					</w:r>
				</w:p>
				
				<g:set var="serviceDefs" value="${serviceDefinitionLanguages[s]}" />
		
				<g:if test="${serviceDefs?.size() > 0 }">
					
					<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t>Scope Of Language : </w:t>
						</w:r>
					</w:p>
					
					<g:each in="${serviceDefs}" status="sd" var="definition">
						<w:p w:rsidR="00101270" w:rsidRDefault="000D4776" w:rsidP="00451B4D">
							<w:pPr>
								<w:pStyle w:val="ListParagraph"/>
								<w:numPr>
									<w:ilvl w:val="0"/>
									<w:numId w:val="1"/>
								</w:numPr>
							</w:pPr>
							
							<w:r>
								<w:rPr>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
								</w:rPr>
								<w:t>${definition}</w:t>
							</w:r>
							
						</w:p>
					</g:each>
					
				</g:if>
			</w:tc>
		
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="4621" w:type="dxa"/>
				</w:tcPr>
				
				<g:set var="deliverables" value="${serviceQuotationInstance?.profile?.listCustomerDeliverables()}" />
		
				<g:if test="${deliverables?.size() > 0 }">
					<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
						<w:r>
							<w:t></w:t>
						</w:r>
					</w:p>
					
					<g:each in="${deliverables}" status="d" var="serviceDeliverableInstance">
						<w:p w:rsidR="00101270" w:rsidRDefault="000D4776" w:rsidP="00451B4D">
							<w:pPr>
								<w:pStyle w:val="ListParagraph"/>
								<w:numPr>
									<w:ilvl w:val="0"/>
									<w:numId w:val="1"/>
								</w:numPr>
							</w:pPr>
							
							<w:r>
								<w:rPr>
									<w:b/>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
								</w:rPr>
								<w:t>${serviceDeliverableInstance?.name }</w:t>
							</w:r>
							
							<w:r>
								<w:t xml:space="preserve"> - ${serviceDeliverableInstance?.newDescription?.value }</w:t>
							</w:r>
						</w:p>
					</g:each>
					
				</g:if>
			</w:tc>
		</w:tr>			

	</g:each>
