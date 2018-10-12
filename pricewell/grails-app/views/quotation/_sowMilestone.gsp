<w:tblPr>
		<w:tblStyle w:val="TableGrid"/>
		<w:tblW w:w="5000" w:type="pct"/>
		<w:tblBorders>
			<w:top w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:left w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:bottom w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:right w:val="single" w:sz="12" w:space="0" w:color="7F7F7F"/>
			<w:insideH w:val="single" w:sz="8" w:space="0" w:color="000000"/>
			<w:insideV w:val="single" w:sz="8" w:space="0" w:color="000000"/>
		</w:tblBorders>
		<w:tblLook w:val="04A0"/>
	</w:tblPr>
	
	<w:tblGrid>
		<w:gridCol w:w="3000"/>
		<w:gridCol w:w="2000"/>
	</w:tblGrid>
	<w:tr w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidTr="006C6123">
		<w:trPr>
			<w:trHeight w:val="260"/>
		</w:trPr>
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="3000" w:type="dxa"/>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
			</w:tcPr>
			<w:p w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:r w:rsidRPr="00546C26">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="17"/>
						<w:szCs w:val="17"/>
					</w:rPr>
					<w:t>Billing Milestones</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="2000" w:type="dxa"/>
				<w:shd w:val="clear" w:color="auto" w:fill="B2B2B2"/>
			</w:tcPr>
			<w:p w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:r w:rsidRPr="00546C26">
					<w:rPr>
						<w:b/>
						<w:bCs w:val="0"/>
						<w:color w:val="00458A"/>
						<w:sz w:val="17"/>
						<w:szCs w:val="17"/>
					</w:rPr>
					<w:t>Amount</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>
	
	<w:tr w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidTr="006C6123">
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="3000" w:type="dxa"/>
			</w:tcPr>
			<g:each in="${quotationInstance?.milestones?.sort {it.id}}" status="m" var="quotationMilestoneInstance">
			
				<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
					<w:r>
						<w:rPr>
							<w:sz w:val="17"/>
							<w:szCs w:val="17"/>
						</w:rPr>
					
						<w:t xml:space="preserve">${quotationMilestoneInstance?.milestone }</w:t>
					</w:r>
				</w:p>
			</g:each>
			<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:pPr>
					<w:rPr>
						<w:i/>
					</w:rPr>
				</w:pPr>
			</w:p>
			<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:pPr>
					<w:rPr>
						<w:i/>
					</w:rPr>
				</w:pPr>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="2000" w:type="dxa"/>
			</w:tcPr>
			<g:each in="${quotationInstance?.milestones?.sort {it.id}}" status="m" var="quotationMilestoneInstance">
			
				<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
					<w:r>
						<w:rPr>
							<w:sz w:val="17"/>
							<w:szCs w:val="17"/>
						</w:rPr>
						<w:t xml:space="preserve">${quotationInstance?.geo?.currencySymbol} ${quotationMilestoneInstance?.amount } (${quotationMilestoneInstance?.percentage}%)</w:t>
					</w:r>
				</w:p>
			</g:each>
			<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:pPr>
					<w:rPr>
						<w:i/>
					</w:rPr>
				</w:pPr>
			</w:p>
			<w:p w:rsidR="00A515EF" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:pPr>
					<w:rPr>
						<w:i/>
					</w:rPr>
				</w:pPr>
			</w:p>
		</w:tc>
		
	</w:tr>
	
	
	
	<w:tr w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidTr="006C6123">
		<w:trPr>
			<w:trHeight w:val="215"/>
		</w:trPr>
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="3000" w:type="dxa"/>
			</w:tcPr>
			<w:p w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidDel="00761225" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:r w:rsidRPr="00546C26">
					<w:rPr>
						<w:b/>
						<w:sz w:val="17"/>
						<w:szCs w:val="17"/>
					</w:rPr>
					<w:t>Total Fees</w:t>
				</w:r>
			</w:p>
		</w:tc>
		
		<w:tc>
			<w:tcPr>
				<w:tcW w:w="2000" w:type="dxa"/>
			</w:tcPr>
			<w:p w:rsidR="00A515EF" w:rsidRPr="00546C26" w:rsidDel="00761225" w:rsidRDefault="00A515EF" w:rsidP="006C6123">
				<w:r w:rsidRPr="00546C26">
					<w:rPr>
						<w:b/>
						<w:sz w:val="17"/>
						<w:szCs w:val="17"/>
					</w:rPr>
					<w:t>${quotationInstance?.geo?.currencySymbol} ${totalAmount}</w:t>
				</w:r>
			</w:p>
		</w:tc>
	</w:tr>