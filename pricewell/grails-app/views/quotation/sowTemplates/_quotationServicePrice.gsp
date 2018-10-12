	<w:tblPr>
		<w:tblStyle w:val="TableGrid"/>
		<w:tblW w:w="5000" w:type="pct"/>
		<w:tblLook w:val="04A0"/>
		<w:tblBorders>
			<w:top w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:left w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:bottom w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:right w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:insideH w:val="single" w:sz="8" w:space="0" w:color="000000"/>
			<w:insideV w:val="single" w:sz="8" w:space="0" w:color="000000"/>
		</w:tblBorders>
	</w:tblPr>
	<w:tblGrid>
		<w:gridCol/>
		<w:gridCol/>
		<w:gridCol/>
		<w:gridCol/>
		<w:gridCol/>
		<w:gridCol/>
		<w:gridCol/>
	</w:tblGrid>
	
	<w:tr w:rsidR="001A7C80" w:rsidTr="001A7C80">
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="1364" w:type="dxa"/>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
			</w:tcPr>
			<w:p w:rsidR="001A7C80" w:rsidRPr="00E5457C" w:rsidRDefault="001A7C80">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						
					</w:rPr>
					<w:t>Portfolio</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
				<w:tcW w:w="3472" w:type="dxa"/>
			</w:tcPr>
			<w:p w:rsidR="001A7C80" w:rsidRPr="00E5457C" w:rsidRDefault="001A7C80">
				
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						
					</w:rPr>
					<w:t>Service</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
				<w:tcW w:w="1621" w:type="dxa"/><w:gridSpan w:val="2"/>
			</w:tcPr>
			<w:p w:rsidR="001A7C80" w:rsidRPr="00E5457C" w:rsidRDefault="001A7C80">
				
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						
					</w:rPr>
					<w:t>Unit Of Sale</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
				<w:tcW w:w="1276" w:type="dxa"/><w:gridSpan w:val="2"/>
			</w:tcPr>
			<w:p w:rsidR="001A7C80" w:rsidRPr="00E5457C" w:rsidRDefault="001A7C80">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						
					</w:rPr>
					<w:t>Units</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
				<w:tcW w:w="1509" w:type="dxa"/>
			</w:tcPr>
			<w:p w:rsidR="001A7C80" w:rsidRPr="00E5457C" w:rsidRDefault="001A7C80">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						
					</w:rPr>
					<w:t>Price</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
	</w:tr>
	
	
	
		<g:set var="previousPortfolioId" value=""/>
		
		<g:each in="${quotationInstance?.serviceQuotations.sort{it?.sequenceOrder}}" status="i" var="serviceQuotationInstance">
			
			
			<g:if test="${serviceQuotationInstance?.stagingStatus?.name != 'delete'}">
				
				<g:set var="portfolioInstance" value="${serviceQuotationInstance?.service?.portfolio}"/>
												
				<g:if test="${previousPortfolioId == '' || previousPortfolioId != portfolioInstance?.id}">
					
					<w:tr w:rsidR="001A7C80" w:rsidTr="007830E5">
						<w:tc>
							<w:tcPr>
								<w:tcW w:w="9242" w:type="dxa"/><w:gridSpan w:val="7"/>
							</w:tcPr>
							<w:p w:rsidR="001A7C80" w:rsidRDefault="00E5457C">
								<w:r>
									<w:rPr>
										<w:b/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
										
									</w:rPr>
									<w:t>${portfolioInstance?.portfolioName}</w:t>
								</w:r>
							</w:p>
						</w:tc>
					</w:tr>
					
					<g:set var="previousPortfolioId" value="${portfolioInstance?.id}"/>
					
				</g:if>
						
				
				
				<w:tr w:rsidR="001A7C80" w:rsidTr="001A7C80">
					<w:tc>
						<w:tcPr><w:tcW w:w="1364" w:type="dxa"/></w:tcPr>
						<w:p w:rsidR="001A7C80" w:rsidRDefault="001A7C80"/>
					</w:tc>
					
					<w:tc>
						<w:tcPr><w:tcW w:w="3472" w:type="dxa"/></w:tcPr>
						<w:p w:rsidR="001A7C80" w:rsidRDefault="00E5457C">
							<w:r>
								<w:rPr>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
									
								</w:rPr>
								<w:t>${serviceQuotationInstance?.service} [Version ${serviceQuotationInstance.profile.revision}]</w:t>
							</w:r>
						</w:p>
					</w:tc>
					
					<w:tc>
						<w:tcPr><w:tcW w:w="1621" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
						<w:p w:rsidR="001A7C80" w:rsidRDefault="00E5457C">
							<w:r>
								<w:rPr>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
								</w:rPr>
								<w:t>${serviceQuotationInstance?.profile?.unitOfSale}</w:t>
							</w:r>
						</w:p>
					</w:tc>
					
					<w:tc>
						<w:tcPr><w:tcW w:w="1276" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
						<w:p w:rsidR="001A7C80" w:rsidRDefault="00E5457C">
							<w:r>
								<w:rPr>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
								</w:rPr>
								<w:t>${serviceQuotationInstance?.totalUnits}</w:t>
							</w:r>
						</w:p>
					</w:tc>
					
					<w:tc>
						<w:tcPr><w:tcW w:w="1509" w:type="dxa"/></w:tcPr>
						<w:p w:rsidR="001A7C80" w:rsidRDefault="00E5457C">
							<w:r>
								<w:rPr>
									<w:sz w:val="24"/>
									<w:szCs w:val="24"/>
								</w:rPr>
								<w:t>${serviceQuotationInstance?.geo.currencySymbol} ${serviceQuotationInstance?.price}</w:t>
							</w:r>
						</w:p>
					</w:tc>
					
				</w:tr>
			</g:if>
		</g:each>
	
		
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00F05EFD">
		<w:trPr><w:trHeight w:val="300"/></w:trPr>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="9242" w:type="dxa"/><w:gridSpan w:val="7"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00E5457C">
		<w:tc>
			<w:tcPr><w:tcW w:w="5487" w:type="dxa"/><w:gridSpan w:val="3"/><w:vMerge w:val="restart"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
		<w:tc>
			<w:tcPr><w:tcW w:w="1751" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRPr="00E5457C" w:rsidRDefault="00E5457C">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>Subtotal Price</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="2004" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C">
				<w:r>
					<w:rPr>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${quotationInstance?.totalQuotedPrice}</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00E5457C">
		<w:tc>
			<w:tcPr><w:tcW w:w="5487" w:type="dxa"/><w:gridSpan w:val="3"/><w:vMerge/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
		<w:tc>
			<w:tcPr><w:tcW w:w="1751" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRPr="00E5457C" w:rsidRDefault="00E5457C">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>Discount</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="2004" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C">
				<w:r>
					<w:rPr>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${quotationInstance?.discountAmount} ${(!quotationInstance.flatDiscount ? '(' + quotationInstance.discountPercent + '%)': '')}</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00E5457C">
		<w:tc>
			<w:tcPr><w:tcW w:w="5487" w:type="dxa"/><w:gridSpan w:val="3"/><w:vMerge/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
		<w:tc>
			<w:tcPr><w:tcW w:w="1751" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRPr="00E5457C" w:rsidRDefault="00E5457C">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>Tax</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="2004" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C">
				<w:r>
					<w:rPr>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${quotationInstance?.taxAmount} (${quotationInstance?.taxPercent}%)</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00E5457C">
		<w:tc>
			<w:tcPr><w:tcW w:w="5487" w:type="dxa"/><w:gridSpan w:val="3"/><w:vMerge/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
		<w:tc>
			<w:tcPr><w:tcW w:w="1751" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRPr="00E5457C" w:rsidRDefault="00E5457C">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>Expenses</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="2004" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C">
				<w:r>
					<w:rPr>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${quotationInstance?.expenseAmount}</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00E5457C" w:rsidTr="00E5457C">
		<w:tc>
			<w:tcPr><w:tcW w:w="5487" w:type="dxa"/><w:gridSpan w:val="3"/><w:vMerge/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C"/>
		</w:tc>
		<w:tc>
			<w:tcPr><w:tcW w:w="1751" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRPr="00E5457C" w:rsidRDefault="00E5457C">
				<w:r w:rsidRPr="00E5457C">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>Total Price</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr><w:tcW w:w="2004" w:type="dxa"/><w:gridSpan w:val="2"/></w:tcPr>
			<w:p w:rsidR="00E5457C" w:rsidRDefault="00E5457C">
				<w:r>
					<w:rPr>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${quotationInstance?.finalPrice}</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>