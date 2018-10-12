
	<w:tblPr>
		<w:tblStyle w:val="TableGrid"/>
		<w:tblW w:w="5000" w:type="pct"/>
		<w:tblBorders>
			<w:top w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
			<w:left w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
			<w:bottom w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
			<w:right w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
			<w:insideH w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
			<w:insideV w:val="single" w:sz="8" w:space="0" w:color="000000" w:themeColor="text1"/>
		</w:tblBorders>
	</w:tblPr>
	
	<w:tblGrid>
		<w:gridCol/>
		<w:gridCol/>
	</w:tblGrid>
	
	<g:each in="${portfolioList}" status="p" var="portfolioInstance">
	
		<w:tr w:rsidR="00101270" w:rsidTr="00F538A6">
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="9242" w:type="dxa"/>
					<w:gridSpan w:val="2"/>
				</w:tcPr>
				<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
					
					<w:r>
						<w:rPr>
							<w:b/>
							<w:sz w:val="28"/>
							<w:szCs w:val="28"/>
						</w:rPr>
						<w:t>${portfolioInstance?.portfolioName }</w:t>
					</w:r>
				</w:p>
			</w:tc>
		</w:tr>
		
		<g:set var="serviceQuotationList" value="${portfolioServices[portfolioInstance?.id]}" />
		
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
				</w:tc>
			
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="4621" w:type="dxa"/>
					</w:tcPr>
					
					<g:set var="deliverables" value="${serviceQuotationInstance?.profile.listCustomerDeliverables()}" />
			
					<g:if test="${deliverables.size() > 0 }">
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
										<w:sz w:val="22"/>
										<w:szCs w:val="22"/>
									</w:rPr>
									<w:t>${serviceDeliverableInstance?.name }</w:t>
								</w:r>
								
								<w:r>
									<w:t xml:space="preserve"> - ${serviceDeliverableInstance?.description }</w:t>
								</w:r>
							</w:p>
						</g:each>
					</g:if>
				</w:tc>
			</w:tr>			
	
		</g:each>
		
		<g:if test="${p+1 < portfolioList.size()}">
			<w:tr w:rsidR="00101270" w:rsidTr="00F538A6">
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="9242" w:type="dxa"/>
						<w:gridSpan w:val="2"/>
					</w:tcPr>
					<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
						<w:r>
							<w:t></w:t>
						</w:r>
					</w:p>
					<w:p w:rsidR="00101270" w:rsidRDefault="00101270" w:rsidP="00451B4D">
						<w:r>
							<w:t></w:t>
						</w:r>
					</w:p>
				</w:tc>
			</w:tr>
		</g:if>
		
	</g:each>