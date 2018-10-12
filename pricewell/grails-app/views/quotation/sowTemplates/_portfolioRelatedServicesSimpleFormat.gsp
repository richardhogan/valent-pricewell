<!-- *************************************** Portfolio contents *********************************************************************************** -->
	<g:if test="${type == 'portfolioName' }">
		<g:set var="portfolioInstance" value="${object}" />
		<w:pPr>
			<!-- <w:pStyle w:val="Heading"/> -->
			<!-- <w:numPr>
				<w:ilvl w:val="0"/>
				<w:numId w:val="1"/>
			</w:numPr> -->
			<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
			<w:jc w:val="left"/>
		</w:pPr>
		<w:r>
			<w:rPr>
				<w:b/>
				<w:color w:val="00458A"/>
				<w:sz w:val="24"/>
				<w:szCs w:val="24"/>
			</w:rPr>
			<w:t>${portfolioInstance?.portfolioName }</w:t>
		</w:r>
		
		<g:if test="${portfolioInstance?.description}">
			<w:r>
				<w:rPr>
					<w:sz w:val="24"/>
					<w:szCs w:val="24"/>
				</w:rPr>
				<w:t xml:space="preserve"> - ${portfolioInstance?.description }</w:t>
			</w:r>
		</g:if>
	</g:if>

<!-- *********************************************************************************************************************************************** -->

<!-- *************************************** Service contents *********************************************************************************** -->
			<g:if test="${type == 'serviceName' }">
				<g:set var="serviceQuotationInstance" value="${object}" />
				<w:pPr>
					<!-- <w:pStyle w:val="ListParagraph"/>
					 <w:numPr>
						<w:ilvl w:val="1"/>
						<w:numId w:val="1"/>
					</w:numPr>
					<w:ind w:left="360" w:hanging="400"/> -->
					
					<w:pBdr>
						<w:bottom w:val="single" w:sz="6" w:space="1" w:color="auto"/>
					</w:pBdr>
					<w:jc w:val="both"/>
					
				</w:pPr>
				<w:r>
					<w:rPr>
						<w:b/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
					</w:rPr>
					<w:t>${objectId} ${serviceQuotationInstance?.service?.serviceName }</w:t>
				</w:r>
				
				<!-- <g:if test="${serviceQuotationInstance?.service?.description}">
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/>
							<w:sz w:val="24"/>
							<w:szCs w:val="24"/>
						</w:rPr>
						<w:t xml:space="preserve"> - ${serviceQuotationInstance?.service?.description }</w:t>
					</w:r>
				</g:if> -->
			</g:if>
			
<!-- *********************************************************************************************************************************************** -->

<!-- *************************************** SOW Language contents *********************************************************************************** -->
					
					<g:if test="${type == 'languageTitle' }">
						<w:pPr>
							<w:pStyle w:val="ListParagraph"/>
							<!-- <w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>-->
							<w:ind w:left="360" w:hanging="400"/>
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:jc w:val="both"/>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t>Scope of Work</w:t>
						</w:r>
					</g:if>
			
							<g:if test="${type == 'languageDefinition' }">
								<g:set var="definition" value="${object}" />
								<w:pPr>
									<!-- <w:pStyle w:val="ListParagraph"/>
									<w:numPr>
										<w:ilvl w:val="2"/>
										<w:numId w:val="2"/>
									</w:numPr>-->
									
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> 1080-->
									
									<w:ind w:left="360" w:hanging="400"/>
									<w:jc w:val="both"/>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t>${definition}</w:t>
								</w:r>
							</g:if>
							
<!-- ************************************************************************************************************************************************* -->

<!-- *************************************** Prerequisites contents *********************************************************************************** -->
					
					<g:if test="${type == 'prerequisitesTitle' }">
						<w:pPr>
							<!-- <w:pStyle w:val="ListParagraph"/>
							<w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>
							<w:ind w:left="720" w:hanging="400"/> -->
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:ind w:left="360" w:hanging="400"/>
							<w:jc w:val="both"/>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t>Prerequisites</w:t>
						</w:r>
					</g:if>
			
							<g:if test="${type == 'prerequisiteDefinition' }">
								<g:set var="definition" value="${object}" />
								<w:pPr>
									<w:pStyle w:val="ListParagraph"/>
									<w:numPr>
										<w:ilvl w:val="2"/>
										<w:numId w:val="1"/>
									</w:numPr>
									<w:ind w:left="720" w:hanging="400"/>
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
									<w:jc w:val="both"/>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:noProof/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
										<w:lang w:eastAsia="en-IN"/>
									</w:rPr>
									<w:pict>
										<v:rect xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
   												xmlns:v="urn:schemas-microsoft-com:vml"
   												xmlns:o="urn:schemas-microsoft-com:office:office"
  				 								xml:space="preserve" 
  				 								id="_x0000_s1031" style="position:absolute;left:0;text-align:left;margin-left:15pt;margin-top:2.8pt;width:12pt;height:12pt;z-index:251662336"/>
									</w:pict>
								</w:r>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t>${definition}</w:t>
								</w:r>
							</g:if>
							
<!-- *************************************************************************************************************************************************** -->

<!-- *************************************** Out of scope contents *********************************************************************************** -->
					
					<g:if test="${type == 'outOfScopeTitle' }">
						<w:pPr>
							<!-- <w:pStyle w:val="ListParagraph"/>
							<w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>
							<w:ind w:left="720" w:hanging="400"/>-->
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:ind w:left="360" w:hanging="400"/>
							<w:jc w:val="both"/>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t>Out of Scope</w:t>
						</w:r>
					</g:if>
			
							<g:if test="${type == 'outOfScopeDefinition' }">
								<g:set var="definition" value="${object}" />
								<w:pPr>
									<w:pStyle w:val="ListParagraph"/>
									<w:numPr>
										<w:ilvl w:val="2"/>
										<w:numId w:val="1"/>
									</w:numPr>
									<w:ind w:left="720" w:hanging="400"/>
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
									<w:jc w:val="both"/>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:noProof/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
										<w:lang w:eastAsia="en-IN"/>
									</w:rPr>
									<w:pict>
										<v:rect xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
   												xmlns:v="urn:schemas-microsoft-com:vml"
   												xmlns:o="urn:schemas-microsoft-com:office:office"
  				 								xml:space="preserve" 
  				 								id="_x0000_s1031" style="position:absolute;left:0;text-align:left;margin-left:15pt;margin-top:2.8pt;width:12pt;height:12pt;z-index:251662336"/>
									</w:pict>
								</w:r>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t>${definition}</w:t>
								</w:r>
							</g:if>
							
<!-- *************************************************************************************************************************************************** -->

<!-- *************************************** Activity contents *********************************************************************************** -->
							
					<g:if test="${type == 'activitiyTitle' }">
						<w:pPr>
							<!-- <w:pStyle w:val="ListParagraph"/>
							<w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>
							<w:ind w:left="720" w:hanging="400"/>-->
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:ind w:left="360" w:hanging="400"/>
							<w:jc w:val="both"/>
						</w:pPr>
						<w:r>
							<w:rPr>
								
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t>Activities and Tasks:</w:t>
						</w:r>
					</g:if>
						
							<g:if test="${type == 'activityDefinition' }">
								<g:set var="serviceActivityInstance" value="${object}" />
								<w:pPr>
									<w:pStyle w:val="ListParagraph"/>
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
									<w:ind w:left="360" w:hanging="400"/>
									<!-- <w:ind w:left="2520"/> -->
									<w:jc w:val="both"/>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:b/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t xml:space="preserve">${objectId} </w:t>
								</w:r>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t xml:space="preserve">${serviceActivityInstance?.name}</w:t>
								</w:r>
								
								<g:if test="${serviceActivityInstance?.description}">
									<w:r>
										<w:rPr>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
										<w:t xml:space="preserve"> - ${serviceActivityInstance?.description }</w:t>
									</w:r>
								</g:if>
							</g:if>
							
							<g:if test="${type == 'activityDefinitionGrouping' }">
								<g:set var="serviceActivityInstance" value="${object}" />
								<w:pPr>
									<w:pStyle w:val="ListParagraph"/>
									<!-- <w:numPr>
										<w:ilvl w:val="3"/>
										<w:numId w:val="1"/>
									</w:numPr>-->
									<w:ind w:left="1080" w:hanging="400"/>
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
									<w:jc w:val="both"/>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:b/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t xml:space="preserve">${objectId} </w:t>
								</w:r>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t xml:space="preserve">${serviceActivityInstance?.name}</w:t>
								</w:r>
								
								<g:if test="${serviceActivityInstance?.description}">
									<w:r>
										<w:rPr>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
										<w:t xml:space="preserve"> - ${serviceActivityInstance?.description }</w:t>
									</w:r>
								</g:if>
							</g:if>
							
<!-- ************************************************************************************************************************************************ -->

<!-- *************************************** Activity Tasks *********************************************************************************** -->
					
							
								<g:if test="${type == 'activityTaskDefinition' || type == 'activityTaskDefinitionInGrouping' }">
									<g:set var="serviceActivityTaskInstance" value="${object}" />
									<w:pPr>
										<w:pStyle w:val="ListParagraph"/>
										<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
										<g:if test="${type == 'activityTaskDefinitionInGrouping'}">
											<w:ind w:left="1440" w:hanging="400"/>
										</g:if>
										<g:else>
											<w:ind w:left="720" w:hanging="400"/>
										</g:else>
										
										<!-- <w:ind w:left="2520"/> -->
										<w:jc w:val="both"/>
										<w:rPr>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:b/>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
										<w:t xml:space="preserve">${objectId} </w:t>
									</w:r>
									<w:r>
										<w:rPr>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
										<w:t xml:space="preserve">${serviceActivityTaskInstance?.task}</w:t>
									</w:r>
								</g:if>
							
<!-- *************************************************************************************************************************************************** -->


<!-- *************************************** Deliverables contents *********************************************************************************** -->							
							
					<g:if test="${type == 'deliverableTitle' }">
						<w:pPr>
							<!-- <w:pStyle w:val="ListParagraph"/>
							<w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>
							<w:ind w:left="720" w:hanging="400"/> -->
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:ind w:left="360" w:hanging="400"/>
							<w:jc w:val="both"/>
							
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t xml:space="preserve">Deliverables: </w:t>
						</w:r>
					</g:if>			
				
					<g:if test="${type == 'deliverableAndActivityTitle' }">
						<w:pPr>
							<!-- <w:pStyle w:val="ListParagraph"/>
							<w:numPr>
								<w:ilvl w:val="2"/>
								<w:numId w:val="2"/>
							</w:numPr>
							<w:ind w:left="720" w:hanging="400"/>-->
							<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
							<w:ind w:left="360" w:hanging="400"/>
							<w:jc w:val="both"/>
							
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:b/>
								<w:sz w:val="24"/>
								<w:szCs w:val="24"/>
							</w:rPr>
							<w:t xml:space="preserve">Deliverables: (Activities and Tasks)</w:t>
						</w:r>
					</g:if>
							<g:if test="${type == 'deliverableDefinition' }">
								<g:set var="serviceDeliverableInstance" value="${object}" />
								<w:pPr>
									<!-- <w:pStyle w:val="ListParagraph"/>
									<w:numPr>
										<w:ilvl w:val="2"/>
										<w:numId w:val="1"/>
									</w:numPr>-->
									<w:ind w:left="1080" w:hanging="400"/>
									<!-- <w:spacing w:line="360" w:lineRule="auto"/> -->
									<w:jc w:val="both"/>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
								</w:pPr>
								<w:r>
									<w:rPr>
										<w:noProof/>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
										<w:lang w:eastAsia="en-IN"/>
									</w:rPr>
									<w:pict>
										<v:rect xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
   												xmlns:v="urn:schemas-microsoft-com:vml"
   												xmlns:o="urn:schemas-microsoft-com:office:office"
  				 								xml:space="preserve" 
  				 								id="_x0000_s1031" style="position:absolute;left:0;text-align:left;margin-left:15pt;margin-top:2.8pt;width:12pt;height:12pt;z-index:251662336"/>
									</w:pict>
								</w:r>
								<w:r>
									<w:rPr>
										<w:sz w:val="24"/>
										<w:szCs w:val="24"/>
									</w:rPr>
									<w:t xml:space="preserve">${serviceDeliverableInstance?.name}</w:t>
								</w:r>
								
								<g:if test="${serviceDeliverableInstance?.description}">
									<w:r>
										<w:rPr>
											<w:sz w:val="24"/>
											<w:szCs w:val="24"/>
										</w:rPr>
										<w:t xml:space="preserve"> - ${serviceDeliverableInstance?.newDescription?.value }</w:t>
									</w:r>
								</g:if>
							</g:if>
						
						
				
